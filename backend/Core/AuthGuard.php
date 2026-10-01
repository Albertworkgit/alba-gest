<?php
declare(strict_types=1);

namespace AlbaStock\Core;

use RuntimeException;

final class AuthGuard
{
    /** Charge l'utilisateur connecté et actualise ses droits depuis la base à chaque appel API. */
    public static function requireAuthenticated(): array
    {
        $user = Session::current();
        if ($user === null) {
            throw new RuntimeException('Authentification requise.');
        }
        // Le compte le plus ancien de l'entreprise est le propriétaire administrateur initial.
        if ($user['type'] === 'user') {
            $userId = (int) ($user['id'] ?? 0);
            $enterpriseId = (int) ($user['entreprise_id'] ?? 0);
            $statement = Database::connection()->prepare('SELECT u.succursale_id, r.permissions, r.role_name, e.name AS enterprise_name, (SELECT MIN(first_user.user_id) FROM users first_user WHERE first_user.entreprise_id = u.entreprise_id) AS first_user_id FROM users u INNER JOIN roles r ON r.role_id = u.role_id AND r.entreprise_id = u.entreprise_id INNER JOIN entreprises e ON e.entreprise_id = u.entreprise_id WHERE u.user_id = ? AND u.entreprise_id = ? AND u.is_active = 1 AND e.is_active = 1 LIMIT 1');
            $statement->bind_param('ii', $userId, $enterpriseId);
            $statement->execute();
            $currentAccess = $statement->get_result()->fetch_assoc();
            if (!$currentAccess) {
                Session::logout();
                throw new RuntimeException('Authentification requise.');
            }
            // L'identifiant est comparé au plus petit user_id de cette entreprise uniquement.
            $isCompanyAdmin = $userId === (int) $currentAccess['first_user_id'];
            if ($isCompanyAdmin) {
                // Le propriétaire conserve l'administration complète, même si son rôle historique est incomplet.
                $currentAccess['permissions'] = '["*", "toutes_succursales"]';
                $currentAccess['role_name'] = 'Administrateur de l’entreprise';
            }
            // Remplace le snapshot de session par les valeurs que la base considère actuelles.
            $user = array_merge($user, $currentAccess);
            $user['is_company_admin'] = $isCompanyAdmin;
            $moduleAccess = Database::connection()->prepare('SELECT modules_autorises FROM entreprise_droits_modules WHERE entreprise_id = ? LIMIT 1');
            $moduleAccess->bind_param('i', $enterpriseId);
            $moduleAccess->execute();
            $configuredModules = $moduleAccess->get_result()->fetch_assoc();
            $modules = $configuredModules ? json_decode((string) $configuredModules['modules_autorises'], true) : [];
            $user['modules_autorises'] = is_array($modules) ? $modules : [];
            $_SESSION['auth'] = $user;
        }
        return $user;
    }

    public static function enterpriseId(array $user): int
    {
        if ($user['type'] === 'super_admin') {
            return (int) ($_GET['entreprise_id'] ?? \ALBA_STOCK_ENTERPRISE_ID);
        }
        return (int) ($user['entreprise_id'] ?? 0);
    }
}
