<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use AlbaStock\Core\Database;
use AlbaStock\Core\Session;
use mysqli;
use RuntimeException;

final class AuthService
{
    private mysqli $db;

    public function __construct()
    {
        $this->db = Database::connection();
    }

    public function login(string $emailOrUsername, string $password): array
    {
        return $this->loginUser($emailOrUsername, $password);
    }

    // Authentifie uniquement un utilisateur rattaché à une entreprise active.
    public function loginUser(string $emailOrUsername, string $password): array
    {
        $user = $this->findUser($emailOrUsername);
        if (!$user || !password_verify($password, $user['password_hash'])) {
            throw new RuntimeException('Identifiants utilisateur incorrects ou compte non activé.');
        }
        Session::login($user, 'user');
        return ['type' => 'user', 'user' => Session::current()];
    }

    // Authentifie uniquement un compte présent dans la table des super administrateurs.
    public function loginSuperAdmin(string $email, string $password): array
    {
        $admin = $this->findSuperAdmin($email);
        if (!$admin || !password_verify($password, $admin['password_hash'])) {
            throw new RuntimeException('Identifiants super administrateur incorrects.');
        }
        Session::login($admin, 'super_admin');
        return ['type' => 'super_admin', 'user' => Session::current()];
    }

    public function superAdminsPage(int $page, int $perPage): array
    {
        $count = (int) ($this->db->query('SELECT COUNT(*) AS total FROM super_admins')->fetch_assoc()['total'] ?? 0);
        $offset = ($page - 1) * $perPage;
        $statement = $this->db->prepare('SELECT super_admin_id, email, full_name, is_active, created_at FROM super_admins ORDER BY super_admin_id DESC LIMIT ? OFFSET ?');
        $statement->bind_param('ii', $perPage, $offset);
        $statement->execute();
        return [
            'rows' => $statement->get_result()->fetch_all(MYSQLI_ASSOC),
            'pagination' => ['page' => $page, 'per_page' => $perPage, 'total' => $count, 'pages' => max(1, (int) ceil($count / $perPage))],
        ];
    }

    public function createSuperAdmin(array $data): int
    {
        $email = strtolower(trim((string) ($data['email'] ?? '')));
        $fullName = trim((string) ($data['full_name'] ?? ''));
        $password = (string) ($data['password'] ?? '');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL) || strlen($email) > 150) {
            throw new RuntimeException('Saisissez une adresse électronique valide (150 caractères maximum).');
        }
        if ($fullName === '' || mb_strlen($fullName, 'UTF-8') > 100) {
            throw new RuntimeException('Le nom complet est obligatoire (100 caractères maximum).');
        }
        if (strlen($password) < 8) {
            throw new RuntimeException('Le mot de passe doit contenir au moins 8 caractères.');
        }
        $exists = $this->db->prepare('SELECT super_admin_id FROM super_admins WHERE email = ? LIMIT 1');
        $exists->bind_param('s', $email);
        $exists->execute();
        if ($exists->get_result()->fetch_assoc()) {
            throw new RuntimeException('Un super administrateur utilise déjà cette adresse électronique.');
        }
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $statement = $this->db->prepare('INSERT INTO super_admins (email, password_hash, full_name, is_active) VALUES (?, ?, ?, 1)');
        $statement->bind_param('sss', $email, $hash, $fullName);
        try {
            $statement->execute();
        } catch (\mysqli_sql_exception $exception) {
            if ($exception->getCode() === 1062) {
                throw new RuntimeException('Un super administrateur utilise déjà cette adresse électronique.', 0, $exception);
            }
            throw $exception;
        }
        return (int) $this->db->insert_id;
    }

    // Retourne toutes les entreprises visibles par le super administrateur.
    public function enterprises(): array
    {
        $result = $this->db->query('SELECT e.entreprise_id, e.name, e.email, e.phone, e.is_active, e.created_at, d.modules_autorises FROM entreprises e LEFT JOIN entreprise_droits_modules d ON d.entreprise_id = e.entreprise_id ORDER BY e.entreprise_id DESC');
        $enterprises = $result->fetch_all(MYSQLI_ASSOC);
        foreach ($enterprises as &$enterprise) {
            $modules = $enterprise['modules_autorises'] !== null
                ? json_decode((string) $enterprise['modules_autorises'], true)
                : [];
            $enterprise['modules_autorises'] = is_array($modules) ? $modules : [];
        }
        unset($enterprise);
        return $enterprises;
    }

    public function setEnterpriseModules(int $enterpriseId, array $modules): void
    {
        $availableModules = \AlbaStock\Core\Authorization::modules();
        if ($enterpriseId < 1 || array_diff($modules, array_keys($availableModules)) !== []) {
            throw new RuntimeException('Entreprise ou module invalide.');
        }
        $exists = $this->db->prepare('SELECT entreprise_id FROM entreprises WHERE entreprise_id = ? LIMIT 1');
        $exists->bind_param('i', $enterpriseId);
        $exists->execute();
        if (!$exists->get_result()->fetch_assoc()) throw new RuntimeException('Entreprise introuvable.');

        $json = json_encode(array_values(array_unique($modules)), JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
        $statement = $this->db->prepare('INSERT INTO entreprise_droits_modules (entreprise_id, modules_autorises) VALUES (?, ?) ON DUPLICATE KEY UPDATE modules_autorises = VALUES(modules_autorises)');
        $statement->bind_param('is', $enterpriseId, $json);
        $statement->execute();
    }

    public function enterpriseModules(int $enterpriseId): array
    {
        $enterprise = $this->db->prepare('SELECT entreprise_id FROM entreprises WHERE entreprise_id = ? LIMIT 1');
        $enterprise->bind_param('i', $enterpriseId);
        $enterprise->execute();
        if (!$enterprise->get_result()->fetch_assoc()) throw new RuntimeException('Entreprise introuvable.');

        $statement = $this->db->prepare('SELECT modules_autorises FROM entreprise_droits_modules WHERE entreprise_id = ? LIMIT 1');
        $statement->bind_param('i', $enterpriseId);
        $statement->execute();
        $configured = $statement->get_result()->fetch_assoc();
        $modules = $configured
            ? json_decode((string) $configured['modules_autorises'], true)
            : [];
        return is_array($modules) ? $modules : [];
    }

    public function users(int $enterpriseId, ?int $branchId = null): array
    {
        $sql = 'SELECT u.user_id, u.username, u.email, u.full_name, u.is_active, u.created_at, u.succursale_id, u.role_id, r.role_name, s.name AS branch_name FROM users u INNER JOIN roles r ON r.role_id = u.role_id AND r.entreprise_id = u.entreprise_id LEFT JOIN succursales s ON s.succursale_id = u.succursale_id AND s.entreprise_id = u.entreprise_id WHERE u.entreprise_id = ?';
        if ($branchId !== null) $sql .= ' AND u.succursale_id = ?';
        $sql .= ' ORDER BY u.user_id DESC';
        $statement = $this->db->prepare($sql);
        if ($branchId === null) $statement->bind_param('i', $enterpriseId);
        else $statement->bind_param('ii', $enterpriseId, $branchId);
        $statement->execute();
        return $statement->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /** Charge uniquement la page d'utilisateurs demandée et renvoie son total. */
    public function usersPage(int $enterpriseId, ?int $branchId, int $page, int $perPage): array
    {
        $where = ' WHERE u.entreprise_id = ?' . ($branchId !== null ? ' AND u.succursale_id = ?' : '');
        $count = $this->db->prepare('SELECT COUNT(*) AS total FROM users u' . $where);
        if ($branchId === null) $count->bind_param('i', $enterpriseId); else $count->bind_param('ii', $enterpriseId, $branchId);
        $count->execute();
        $total = (int) ($count->get_result()->fetch_assoc()['total'] ?? 0);
        $offset = ($page - 1) * $perPage;
        $sql = 'SELECT u.user_id, u.username, u.email, u.full_name, u.is_active, u.created_at, u.succursale_id, u.role_id, r.role_name, s.name AS branch_name FROM users u INNER JOIN roles r ON r.role_id = u.role_id AND r.entreprise_id = u.entreprise_id LEFT JOIN succursales s ON s.succursale_id = u.succursale_id AND s.entreprise_id = u.entreprise_id' . $where . ' ORDER BY u.user_id DESC LIMIT ? OFFSET ?';
        $statement = $this->db->prepare($sql);
        if ($branchId === null) $statement->bind_param('iii', $enterpriseId, $perPage, $offset); else $statement->bind_param('iiii', $enterpriseId, $branchId, $perPage, $offset);
        $statement->execute();
        return ['rows' => $statement->get_result()->fetch_all(MYSQLI_ASSOC), 'pagination' => ['page' => $page, 'per_page' => $perPage, 'total' => $total, 'pages' => max(1, (int) ceil($total / $perPage))]];
    }

    public function sessionProfile(array $actor): array
    {
        if (($actor['type'] ?? '') !== 'user') return $actor;
        $userId = (int) ($actor['id'] ?? 0);
        $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
        $companyColumns = array_column($this->db->query('SHOW COLUMNS FROM entreprises')->fetch_all(MYSQLI_ASSOC), 'Field');
        $companyColumn = static fn (string $column, string $alias): string => in_array($column, $companyColumns, true)
            ? 'e.' . $column . ' AS ' . $alias
            : 'NULL AS ' . $alias;
        $rccmColumn = $companyColumn('rccm', 'enterprise_rccm');
        $postalBoxColumn = $companyColumn('boite_postale', 'enterprise_boite_postale');
        $logoColumn = $companyColumn('logo', 'enterprise_logo');
        $stampColumn = $companyColumn('cachet', 'enterprise_cachet');
        // Charge le nom de l'entreprise et de la succursale depuis la base, pas depuis le navigateur.
        $statement = $this->db->prepare('SELECT u.full_name, u.username, u.email, u.succursale_id, r.role_name, r.permissions, e.name AS enterprise_name, e.email AS enterprise_email, e.phone AS enterprise_phone, e.address AS enterprise_address, ' . $rccmColumn . ', ' . $postalBoxColumn . ', ' . $logoColumn . ', ' . $stampColumn . ', s.name AS branch_name, (SELECT MIN(first_user.user_id) FROM users first_user WHERE first_user.entreprise_id = u.entreprise_id) AS first_user_id FROM users u INNER JOIN roles r ON r.role_id = u.role_id AND r.entreprise_id = u.entreprise_id INNER JOIN entreprises e ON e.entreprise_id = u.entreprise_id LEFT JOIN succursales s ON s.succursale_id = u.succursale_id AND s.entreprise_id = u.entreprise_id WHERE u.user_id = ? AND u.entreprise_id = ? AND u.is_active = 1 AND e.is_active = 1 LIMIT 1');
        $statement->bind_param('ii', $userId, $enterpriseId);
        $statement->execute();
        $profile = $statement->get_result()->fetch_assoc() ?: [];
        // Compatibilité avec les anciens rôles enregistrés sous l'alias "stock".
        $permissions = json_decode((string) ($profile['permissions'] ?? '[]'), true);
        if (is_array($permissions) && (in_array('stock', $permissions, true) || (in_array('voir_stock', $permissions, true) && !in_array('approvisionnement', $permissions, true)))) {
            $profile['permissions'] = json_encode(array_values(array_unique(array_merge($permissions, ['voir_stock', 'modifier_stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements']))), JSON_UNESCAPED_UNICODE);
        } elseif (is_array($permissions) && in_array('creer_approvisionnements', $permissions, true)) {
            $permissions[] = 'creer_fournisseurs';
            $profile['permissions'] = json_encode(array_values(array_unique($permissions)), JSON_UNESCAPED_UNICODE);
        }
        $isCompanyAdmin = isset($profile['first_user_id']) && $userId === (int) $profile['first_user_id'];
        if ($isCompanyAdmin) {
            // Aligne les droits renvoyés au menu avec ceux accordés à cet administrateur par AuthGuard.
            $profile['role_name'] = 'Administrateur de l’entreprise';
            $profile['permissions'] = json_encode(['*', 'toutes_succursales'], JSON_UNESCAPED_UNICODE);
        }
        unset($profile['first_user_id']);
        return array_merge($actor, $profile, ['is_company_admin' => $isCompanyAdmin]);
    }

    // Met à jour les informations modifiables du compte actuellement connecté.
    public function updateProfile(array $actor, array $data): array
    {
        $fullName = trim((string) ($data['full_name'] ?? ''));
        $email = trim((string) ($data['email'] ?? ''));
        if ($fullName === '' || $email === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new RuntimeException('Le nom complet et une adresse email valide sont obligatoires.');
        }

        $userId = (int) ($actor['id'] ?? 0);
        if (($actor['type'] ?? '') === 'super_admin') {
            $statement = $this->db->prepare('UPDATE super_admins SET full_name = ?, email = ? WHERE super_admin_id = ?');
            $statement->bind_param('ssi', $fullName, $email, $userId);
            $statement->execute();
            $updated = array_merge($actor, ['full_name' => $fullName, 'email' => $email]);
        } else {
            $username = trim((string) ($data['username'] ?? ''));
            if ($username === '') throw new RuntimeException('Le nom utilisateur est obligatoire.');
            $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
            $statement = $this->db->prepare('UPDATE users SET full_name = ?, username = ?, email = ? WHERE user_id = ? AND entreprise_id = ?');
            $statement->bind_param('sssii', $fullName, $username, $email, $userId, $enterpriseId);
            $statement->execute();
            $updated = array_merge($actor, ['full_name' => $fullName, 'username' => $username, 'email' => $email]);
        }

        $_SESSION['auth'] = $updated;
        return $updated;
    }

    // Vérifie le mot de passe actuel avant de le remplacer par un hash sécurisé.
    public function changePassword(array $actor, string $currentPassword, string $newPassword, string $confirmation): void
    {
        if (strlen($newPassword) < 8) throw new RuntimeException('Le nouveau mot de passe doit contenir au moins 8 caractères.');
        if ($newPassword !== $confirmation) throw new RuntimeException('La confirmation du nouveau mot de passe ne correspond pas.');

        $userId = (int) ($actor['id'] ?? 0);
        if (($actor['type'] ?? '') === 'super_admin') {
            $statement = $this->db->prepare('SELECT password_hash FROM super_admins WHERE super_admin_id = ? LIMIT 1');
            $statement->bind_param('i', $userId);
        } else {
            $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
            $statement = $this->db->prepare('SELECT password_hash FROM users WHERE user_id = ? AND entreprise_id = ? LIMIT 1');
            $statement->bind_param('ii', $userId, $enterpriseId);
        }
        $statement->execute();
        $account = $statement->get_result()->fetch_assoc();
        if (!$account || !password_verify($currentPassword, $account['password_hash'])) {
            throw new RuntimeException('Le mot de passe actuel est incorrect.');
        }

        $passwordHash = password_hash($newPassword, PASSWORD_DEFAULT);
        if (($actor['type'] ?? '') === 'super_admin') {
            $update = $this->db->prepare('UPDATE super_admins SET password_hash = ? WHERE super_admin_id = ?');
            $update->bind_param('si', $passwordHash, $userId);
        } else {
            $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
            $update = $this->db->prepare('UPDATE users SET password_hash = ? WHERE user_id = ? AND entreprise_id = ?');
            $update->bind_param('sii', $passwordHash, $userId, $enterpriseId);
        }
        $update->execute();
    }

    // Active ou désactive une entreprise et ses utilisateurs associés.
    public function setEnterpriseStatus(int $enterpriseId, bool $active): void
    {
        $this->db->begin_transaction();
        try {
            $status = $active ? 1 : 0;
            $enterprise = $this->db->prepare('UPDATE entreprises SET is_active = ? WHERE entreprise_id = ?');
            $enterprise->bind_param('ii', $status, $enterpriseId);
            $enterprise->execute();
            $users = $this->db->prepare('UPDATE users SET is_active = ? WHERE entreprise_id = ?');
            $users->bind_param('ii', $status, $enterpriseId);
            $users->execute();
            $this->db->commit();
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    /** Supprime toutes les données d'une entreprise et son répertoire de fichiers. */
    public function deleteEnterprise(int $enterpriseId): bool
    {
        if ($enterpriseId < 1) throw new RuntimeException('Identifiant d’entreprise invalide.');

        $this->db->begin_transaction();
        try {
            $enterprise = $this->db->prepare('SELECT entreprise_id FROM entreprises WHERE entreprise_id = ? LIMIT 1 FOR UPDATE');
            $enterprise->bind_param('i', $enterpriseId);
            $enterprise->execute();
            if (!$enterprise->get_result()->fetch_assoc()) throw new RuntimeException('Entreprise introuvable.');

            foreach ($this->enterpriseTablesInDeleteOrder() as $table) {
                $quotedTable = '`' . str_replace('`', '``', $table) . '`';
                $delete = $this->db->prepare("DELETE FROM {$quotedTable} WHERE entreprise_id = ?");
                $delete->bind_param('i', $enterpriseId);
                $delete->execute();
                if ($table === 'entreprises' && $delete->affected_rows !== 1) {
                    throw new RuntimeException('La suppression de l’entreprise a échoué.');
                }
            }
            $this->db->commit();
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }

        return $this->removeEnterpriseUploads($enterpriseId);
    }

    /** Ordonne les tables pour supprimer les lignes enfant avant leurs parents. */
    private function enterpriseTablesInDeleteOrder(): array
    {
        $tablesQuery = $this->db->prepare('SELECT TABLE_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND COLUMN_NAME = ? ORDER BY TABLE_NAME');
        $companyColumn = 'entreprise_id';
        $tablesQuery->bind_param('s', $companyColumn);
        $tablesQuery->execute();
        $tables = array_column($tablesQuery->get_result()->fetch_all(MYSQLI_ASSOC), 'TABLE_NAME');
        if (!in_array('entreprises', $tables, true)) throw new RuntimeException('Schéma entreprise introuvable.');
        $tableSet = array_fill_keys($tables, true);

        $foreignKeys = $this->db->query('SELECT TABLE_NAME, REFERENCED_TABLE_NAME FROM information_schema.KEY_COLUMN_USAGE WHERE CONSTRAINT_SCHEMA = DATABASE() AND REFERENCED_TABLE_NAME IS NOT NULL');
        $children = [];
        foreach ($foreignKeys->fetch_all(MYSQLI_ASSOC) as $foreignKey) {
            $child = (string) $foreignKey['TABLE_NAME'];
            $parent = (string) $foreignKey['REFERENCED_TABLE_NAME'];
            if (isset($tableSet[$child], $tableSet[$parent]) && $child !== $parent) $children[$parent][] = $child;
        }

        $ordered = [];
        $states = [];
        $visit = function (string $table) use (&$visit, &$ordered, &$states, $children): void {
            if (($states[$table] ?? 0) === 2) return;
            if (($states[$table] ?? 0) === 1) throw new RuntimeException('Cycle détecté dans les dépendances des données entreprise.');
            $states[$table] = 1;
            foreach ($children[$table] ?? [] as $child) $visit($child);
            $states[$table] = 2;
            $ordered[] = $table;
        };
        foreach ($tables as $table) $visit((string) $table);
        return $ordered;
    }

    private function removeEnterpriseUploads(int $enterpriseId): bool
    {
        $companiesDirectory = dirname(__DIR__) . '/uploads/companies';
        if (is_link($companiesDirectory)) return false;
        $basePath = realpath($companiesDirectory);
        if ($basePath === false) return true;
        $targetPath = $basePath . DIRECTORY_SEPARATOR . $enterpriseId;
        if (!file_exists($targetPath) && !is_link($targetPath)) return true;
        if (is_link($targetPath)) return unlink($targetPath);
        if (!is_dir($targetPath)) return unlink($targetPath);

        try {
            $iterator = new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($targetPath, \FilesystemIterator::SKIP_DOTS),
                \RecursiveIteratorIterator::CHILD_FIRST
            );
            foreach ($iterator as $item) {
                $path = $item->getPathname();
                if ($item->isLink() || !$item->isDir()) {
                    if (!unlink($path)) return false;
                } elseif (!rmdir($path)) {
                    return false;
                }
            }
            return rmdir($targetPath);
        } catch (\Throwable) {
            return false;
        }
    }

    public function createUser(int $enterpriseId, array $data): int
    {
        $password = (string) ($data['password'] ?? '');
        if (strlen($password) < 8) {
            throw new RuntimeException('Le mot de passe doit contenir au moins 8 caractères.');
        }

        $statement = $this->db->prepare('INSERT INTO users (entreprise_id, succursale_id, role_id, username, email, password_hash, full_name, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, 1)');
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $branchId = isset($data['succursale_id']) ? (int) $data['succursale_id'] : null;
        $roleId = (int) $data['role_id'];
        $username = (string) $data['username'];
        $email = (string) ($data['email'] ?? '');
        $fullName = (string) ($data['full_name'] ?? $username);
        $statement->bind_param('iiissss', $enterpriseId, $branchId, $roleId, $username, $email, $hash, $fullName);
        $statement->execute();
        return (int) $this->db->insert_id;
    }

    // Vérifie qu'un rôle et une succursale appartiennent à la même entreprise.
    public function createUserForActor(array $actor, array $data): int
    {
        $enterpriseId = (int) $actor['entreprise_id'];
        $roleId = (int) ($data['role_id'] ?? 0);
        $role = $this->db->prepare('SELECT role_id FROM roles WHERE role_id = ? AND entreprise_id = ? LIMIT 1');
        $role->bind_param('ii', $roleId, $enterpriseId);
        $role->execute();
        if (!$role->get_result()->fetch_assoc()) {
            throw new RuntimeException('Le rôle sélectionné n’appartient pas à votre entreprise.');
        }

        if ($actor['succursale_id'] !== null && empty($actor['is_company_admin'])) {
            $data['succursale_id'] = (int) $actor['succursale_id'];
        }
        if (isset($data['succursale_id']) && $data['succursale_id'] !== null) {
            $branchId = (int) $data['succursale_id'];
            $branch = $this->db->prepare('SELECT succursale_id FROM succursales WHERE succursale_id = ? AND entreprise_id = ? LIMIT 1');
            $branch->bind_param('ii', $branchId, $enterpriseId);
            $branch->execute();
            if (!$branch->get_result()->fetch_assoc()) {
                throw new RuntimeException('La succursale sélectionnée n’appartient pas à votre entreprise.');
            }
        }
        return $this->createUser($enterpriseId, $data);
    }

    // Modifie un utilisateur uniquement dans l'entreprise et la succursale de l'acteur.
    public function updateUserForActor(array $actor, int $userId, array $data): void
    {
        $enterpriseId = (int) $actor['entreprise_id'];
        $roleId = (int) ($data['role_id'] ?? 0);
        $role = $this->db->prepare('SELECT role_id FROM roles WHERE role_id = ? AND entreprise_id = ? LIMIT 1');
        $role->bind_param('ii', $roleId, $enterpriseId);
        $role->execute();
        if (!$role->get_result()->fetch_assoc()) throw new RuntimeException('Le rôle choisi n’appartient pas à cette entreprise.');

        $branchId = isset($data['succursale_id']) && $data['succursale_id'] !== '' ? (int) $data['succursale_id'] : null;
        if ($actor['succursale_id'] !== null && empty($actor['is_company_admin'])) $branchId = (int) $actor['succursale_id'];
        if ($branchId !== null) {
            $branch = $this->db->prepare('SELECT succursale_id FROM succursales WHERE succursale_id = ? AND entreprise_id = ? LIMIT 1');
            $branch->bind_param('ii', $branchId, $enterpriseId);
            $branch->execute();
            if (!$branch->get_result()->fetch_assoc()) throw new RuntimeException('La succursale choisie n’appartient pas à cette entreprise.');
        }

        $username = trim((string) ($data['username'] ?? ''));
        $fullName = trim((string) ($data['full_name'] ?? ''));
        $email = trim((string) ($data['email'] ?? ''));
        if ($username === '' || $fullName === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new RuntimeException('Nom complet, nom utilisateur et email valide sont obligatoires.');
        }
        $active = !empty($data['is_active']) ? 1 : 0;
        if ($userId === (int) $actor['id'] && $active === 0) {
            throw new RuntimeException('Vous ne pouvez pas désactiver votre propre compte.');
        }

        $password = (string) ($data['password'] ?? '');
        if ($password !== '' && strlen($password) < 8) throw new RuntimeException('Le mot de passe doit contenir au moins 8 caractères.');
        if ($password === '') {
            $statement = $this->db->prepare('UPDATE users SET succursale_id = ?, role_id = ?, username = ?, email = ?, full_name = ?, is_active = ? WHERE user_id = ? AND entreprise_id = ?');
            $statement->bind_param('iisssiii', $branchId, $roleId, $username, $email, $fullName, $active, $userId, $enterpriseId);
        } else {
            $hash = password_hash($password, PASSWORD_DEFAULT);
            $statement = $this->db->prepare('UPDATE users SET succursale_id = ?, role_id = ?, username = ?, email = ?, full_name = ?, is_active = ?, password_hash = ? WHERE user_id = ? AND entreprise_id = ?');
            $statement->bind_param('iisssisii', $branchId, $roleId, $username, $email, $fullName, $active, $hash, $userId, $enterpriseId);
        }
        $statement->execute();
    }

    // Supprime seulement un utilisateur de l'entreprise; les références de ventes peuvent bloquer l'opération.
    public function deleteUserForActor(array $actor, int $userId): bool
    {
        if ($userId === (int) $actor['id']) throw new RuntimeException('Vous ne pouvez pas supprimer votre propre compte.');
        $enterpriseId = (int) $actor['entreprise_id'];
        $statement = $this->db->prepare('DELETE FROM users WHERE user_id = ? AND entreprise_id = ?');
        $statement->bind_param('ii', $userId, $enterpriseId);
        $statement->execute();
        return $statement->affected_rows > 0;
    }

    // Crée un rôle appartenant exclusivement à l'entreprise connectée.
    public function createRole(int $enterpriseId, array $data): int
    {
        $name = trim((string) ($data['role_name'] ?? ''));
        $description = trim((string) ($data['description'] ?? ''));
        $permissions = $data['permissions'] ?? [];
        if ($name === '' || !is_array($permissions)) {
            throw new RuntimeException('Le nom et les permissions du rôle sont obligatoires.');
        }
        $accessRights = [
            // Ventes : consultation, création et modification des enregistrements de vente.
            'vente' => ['voir_ventes', 'creer_ventes', 'modifier_ventes'],
            // Caisse : consultation et gestion complète des caisses.
            'caisse' => ['voir_caisse', 'creer_caisse', 'modifier_caisse', 'supprimer_caisse'],
            // Stock : consultation/ajustement des quantités et gestion des produits.
            'stock' => ['voir_stock', 'modifier_stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements'],
            // Approvisionnement : recherche du catalogue, fournisseurs et mouvements d'entrée/sortie.
            'approvisionnement' => ['voir_stock', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements'],
            'voir_clients' => ['voir_clients'],
            'gerer_clients' => ['voir_clients', 'gerer_clients'],
            // Comptabilité : consultation des totaux de ventes et d'approvisionnements.
            'comptabilite' => ['voir_comptabilite', 'creer_comptabilite', 'modifier_comptabilite'],
        ];
        $expandedPermissions = [];
        foreach ($permissions as $permission) {
            if (!is_string($permission) || !array_key_exists($permission, $accessRights)) {
                throw new RuntimeException('Une permission sélectionnée est invalide.');
            }
            $expandedPermissions = array_merge($expandedPermissions, [$permission], $accessRights[$permission]);
        }
        $permissions = array_values(array_unique($expandedPermissions));
        $permissionsJson = json_encode(array_values($permissions), JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
        $statement = $this->db->prepare('INSERT INTO roles (entreprise_id, role_name, permissions, description) VALUES (?, ?, ?, ?)');
        $statement->bind_param('isss', $enterpriseId, $name, $permissionsJson, $description);
        $statement->execute();
        return (int) $this->db->insert_id;
    }

    // Modifie les droits d'un rôle de l'entreprise depuis les groupes métier disponibles.
    public function updateRole(int $enterpriseId, int $roleId, array $data): void
    {
        $name = trim((string) ($data['role_name'] ?? ''));
        $description = trim((string) ($data['description'] ?? ''));
        $permissions = $data['permissions'] ?? [];
        if ($name === '' || !is_array($permissions)) throw new RuntimeException('Nom et permissions du rôle obligatoires.');
        $groups = [
            'vente' => ['voir_ventes', 'creer_ventes', 'modifier_ventes'],
            'caisse' => ['voir_caisse', 'creer_caisse', 'modifier_caisse', 'supprimer_caisse'],
            'stock' => ['voir_stock', 'modifier_stock', 'creer_produit', 'modifier_produit', 'supprimer_produit', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'modifier_fournisseurs', 'supprimer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements'],
            'approvisionnement' => ['voir_stock', 'voir_succursales', 'voir_fournisseurs', 'creer_fournisseurs', 'voir_approvisionnements', 'creer_approvisionnements'],
            'voir_clients' => ['voir_clients'],
            'gerer_clients' => ['voir_clients', 'gerer_clients'],
            'comptabilite' => ['voir_comptabilite', 'creer_comptabilite', 'modifier_comptabilite'],
        ];
        $expanded = [];
        foreach ($permissions as $group) {
            if (!is_string($group) || !isset($groups[$group])) throw new RuntimeException('Un groupe de permissions est invalide.');
            $expanded = array_merge($expanded, [$group], $groups[$group]);
        }
        $json = json_encode(array_values(array_unique($expanded)), JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
        $statement = $this->db->prepare('UPDATE roles SET role_name = ?, permissions = ?, description = ? WHERE role_id = ? AND entreprise_id = ?');
        $statement->bind_param('sssii', $name, $json, $description, $roleId, $enterpriseId);
        $statement->execute();
        if ($statement->affected_rows === 0) {
            $exists = $this->db->prepare('SELECT role_id FROM roles WHERE role_id = ? AND entreprise_id = ? LIMIT 1');
            $exists->bind_param('ii', $roleId, $enterpriseId);
            $exists->execute();
            if (!$exists->get_result()->fetch_assoc()) throw new RuntimeException('Rôle introuvable dans cette entreprise.');
        }
    }

    // Supprime un rôle de l'entreprise; MySQL refuse l'opération s'il est encore assigné.
    public function deleteRole(int $enterpriseId, int $roleId): bool
    {
        $statement = $this->db->prepare('DELETE FROM roles WHERE role_id = ? AND entreprise_id = ?');
        $statement->bind_param('ii', $roleId, $enterpriseId);
        $statement->execute();
        return $statement->affected_rows > 0;
    }

    // Crée une entreprise et son administrateur dans une seule transaction.
    public function registerEnterprise(array $data): int
    {
        $name = trim((string) ($data['enterprise_name'] ?? ''));
        $email = trim((string) ($data['email'] ?? ''));
        $phone = trim((string) ($data['phone'] ?? ''));
        $address = trim((string) ($data['address'] ?? ''));
        $fullName = trim((string) ($data['full_name'] ?? ''));
        $username = trim((string) ($data['username'] ?? ''));
        $password = (string) ($data['password'] ?? '');

        if ($name === '' || $email === '' || $fullName === '' || $username === '' || strlen($password) < 8) {
            throw new RuntimeException('Tous les champs sont obligatoires et le mot de passe doit contenir au moins 8 caractères.');
        }
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new RuntimeException('Adresse email invalide.');
        }

        $this->db->begin_transaction();
        try {
            // L’entreprise est inactive jusqu’à l’approbation du super administrateur.
            $enterprise = $this->db->prepare('INSERT INTO entreprises (name, email, phone, address, is_active) VALUES (?, ?, ?, ?, 0)');
            $enterprise->bind_param('ssss', $name, $email, $phone, $address);
            $enterprise->execute();
            $enterpriseId = (int) $this->db->insert_id;

            $noModules = '[]';
            $moduleAccess = $this->db->prepare('INSERT INTO entreprise_droits_modules (entreprise_id, modules_autorises) VALUES (?, ?)');
            $moduleAccess->bind_param('is', $enterpriseId, $noModules);
            $moduleAccess->execute();

            // La succursale mère est créée dès l'inscription avec les coordonnées de l'entreprise.
            $branchCode = 'MERE';
            $mainBranch = $this->db->prepare('INSERT INTO succursales (entreprise_id, name, code, est_sucursal_mere, address, phone) VALUES (?, ?, ?, 1, ?, ?)');
            $mainBranch->bind_param('issss', $enterpriseId, $name, $branchCode, $address, $phone);
            $mainBranch->execute();
            $branchId = (int) $this->db->insert_id;

            // Le premier rôle de l’entreprise est son administrateur principal.
            $roleName = 'Administrateur';
            $roleDescription = 'Administrateur de l’entreprise';
            $permissions = json_encode(['*', 'toutes_succursales'], JSON_UNESCAPED_UNICODE);
            $role = $this->db->prepare('INSERT INTO roles (entreprise_id, role_name, permissions, description) VALUES (?, ?, ?, ?)');
            $role->bind_param('isss', $enterpriseId, $roleName, $permissions, $roleDescription);
            $role->execute();
            $roleId = (int) $this->db->insert_id;

            // Le compte est également inactif tant que l’entreprise n’est pas validée.
            $user = $this->db->prepare('INSERT INTO users (entreprise_id, succursale_id, role_id, username, email, password_hash, full_name, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, 0)');
            $hash = password_hash($password, PASSWORD_DEFAULT);
            $user->bind_param('iiissss', $enterpriseId, $branchId, $roleId, $username, $email, $hash, $fullName);
            $user->execute();
            $this->db->commit();
            return $enterpriseId;
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    private function findUser(string $login): ?array
    {
        $statement = $this->db->prepare('SELECT u.*, r.permissions, r.role_name, e.name AS enterprise_name FROM users u INNER JOIN entreprises e ON e.entreprise_id = u.entreprise_id INNER JOIN roles r ON r.role_id = u.role_id WHERE (u.email = ? OR u.username = ?) AND u.is_active = 1 AND e.is_active = 1 LIMIT 1');
        $statement->bind_param('ss', $login, $login);
        $statement->execute();
        return $statement->get_result()->fetch_assoc() ?: null;
    }

    private function findSuperAdmin(string $email): ?array
    {
        // Le schéma déjà présent dans la base XAMPP utilise super_admins et email.
        $statement = $this->db->prepare('SELECT super_admin_id, email, password_hash, full_name, is_active, created_at FROM super_admins WHERE email = ? AND is_active = 1 LIMIT 1');
        $statement->bind_param('s', $email);
        $statement->execute();
        return $statement->get_result()->fetch_assoc() ?: null;
    }
}
