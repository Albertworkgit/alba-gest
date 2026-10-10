<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Services/AuthService.php';
require_once __DIR__ . '/../Services/ProcurementService.php';
require_once __DIR__ . '/../Services/SalesService.php';
require_once __DIR__ . '/../Services/CompanyProfileService.php';
require_once __DIR__ . '/../Services/ExchangeRateService.php';

use AlbaStock\Core\JsonResponse;
use AlbaStock\Core\Session;
use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Services\AuthService;
use AlbaStock\Services\ProcurementService;
use AlbaStock\Services\SalesService;
use AlbaStock\Services\CompanyProfileService;
use AlbaStock\Services\ExchangeRateService;
use AlbaStock\Core\Database;

$method = $_SERVER['REQUEST_METHOD'];
$action = trim((string) ($_GET['action'] ?? 'me'));

try {
    $service = new AuthService();
    if (($action === 'login' || $action === 'user-login') && $method === 'POST') {
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $login = trim((string) ($body['login'] ?? ''));
        $password = (string) ($body['password'] ?? '');
        if ($login === '' || $password === '') {
            JsonResponse::error('Email/nom utilisateur et mot de passe requis.', 422);
        }
        JsonResponse::send(['success' => true, 'data' => $service->loginUser($login, $password)]);
    }

    if ($action === 'super-admin-login' && $method === 'POST') {
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $email = trim((string) ($body['email'] ?? ''));
        $password = (string) ($body['password'] ?? '');
        if ($email === '' || $password === '') {
            JsonResponse::error('Email et mot de passe requis.', 422);
        }
        JsonResponse::send(['success' => true, 'data' => $service->loginSuperAdmin($email, $password)]);
    }

    if ($action === 'super-admin-admins' && $method === 'GET') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') JsonResponse::error('Accès réservé au super administrateur.', 403);
        $page = max(1, (int) ($_GET['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($_GET['per_page'] ?? 10)));
        $result = $service->superAdminsPage($page, $perPage);
        JsonResponse::send(['success' => true, 'data' => $result['rows'], 'pagination' => $result['pagination']]);
    }

    if ($action === 'super-admin-admins' && $method === 'POST') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') JsonResponse::error('Accès réservé au super administrateur.', 403);
        $body = json_decode((string) file_get_contents('php://input'), true);
        if (!is_array($body)) JsonResponse::error('Corps JSON invalide.', 400);
        $adminId = $service->createSuperAdmin($body);
        JsonResponse::send(['success' => true, 'data' => ['super_admin_id' => $adminId]], 201);
    }

    if ($action === 'super-admin-enterprises' && $method === 'GET') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') {
            JsonResponse::error('Accès réservé au super administrateur.', 403);
        }
        JsonResponse::send(['success' => true, 'data' => $service->enterprises()]);
    }

    if ($action === 'super-admin-enterprise-status' && $method === 'POST') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') {
            JsonResponse::error('Accès réservé au super administrateur.', 403);
        }
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $service->setEnterpriseStatus((int) ($body['entreprise_id'] ?? 0), (bool) ($body['is_active'] ?? false));
        JsonResponse::send(['success' => true, 'message' => 'Statut de l’entreprise mis à jour.']);
    }

    if ($action === 'super-admin-enterprise-delete' && $method === 'DELETE') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') {
            JsonResponse::error('Suppression réservée au super administrateur.', 403);
        }
        $enterpriseId = (int) ($_GET['entreprise_id'] ?? 0);
        $filesRemoved = $service->deleteEnterprise($enterpriseId);
        JsonResponse::send([
            'success' => true,
            'message' => $filesRemoved
                ? 'Entreprise et toutes ses données supprimées.'
                : 'Entreprise et données supprimées, mais certains fichiers n’ont pas pu être supprimés.',
            'data' => ['files_removed' => $filesRemoved],
        ]);
    }

    if ($action === 'super-admin-enterprise-modules' && $method === 'GET') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') JsonResponse::error('Accès réservé au super administrateur.', 403);
        $enterpriseId = (int) ($_GET['entreprise_id'] ?? 0);
        JsonResponse::send(['success' => true, 'data' => [
            'modules' => \AlbaStock\Core\Authorization::modules(),
            'modules_autorises' => $service->enterpriseModules($enterpriseId),
        ]]);
    }

    if ($action === 'super-admin-enterprise-modules' && $method === 'PUT') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') JsonResponse::error('Accès réservé au super administrateur.', 403);
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        if (!isset($body['modules_autorises']) || !is_array($body['modules_autorises'])) {
            JsonResponse::error('La liste des modules autorisés est invalide.', 422);
        }
        $service->setEnterpriseModules((int) ($body['entreprise_id'] ?? 0), $body['modules_autorises']);
        JsonResponse::send(['success' => true, 'message' => 'Droits des modules mis à jour.']);
    }

    // Seul un super administrateur peut ajouter les monnaies proposées dans le catalogue.
    if ($action === 'super-admin-currencies' && $method === 'GET') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') {
            JsonResponse::error('Accès réservé au super administrateur.', 403);
        }
        $result = Database::connection()->query('SELECT type_monais, description FROM tb_monais ORDER BY type_monais');
        JsonResponse::send(['success' => true, 'data' => $result->fetch_all(MYSQLI_ASSOC)]);
    }

    if ($action === 'super-admin-currencies' && $method === 'POST') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') {
            JsonResponse::error('Accès réservé au super administrateur.', 403);
        }
        $body = json_decode((string) file_get_contents('php://input'), true);
        // Accepte aussi le POST HTML natif si JavaScript est désactivé ou en cache.
        if (!is_array($body)) $body = $_POST;
        $code = strtoupper(trim((string) ($body['type_monais'] ?? '')));
        $description = trim((string) ($body['description'] ?? ''));
        if ($code === '' || strlen($code) > 10 || $description === '' || strlen($description) > 10) {
            JsonResponse::error('Le code monnaie (10 caractères max.) et son symbole (10 caractères max.) sont obligatoires.', 422);
        }
        $statement = Database::connection()->prepare('INSERT INTO tb_monais (type_monais, description) VALUES (?, ?)');
        $statement->bind_param('ss', $code, $description);
        $statement->execute();
        // Le formulaire classique revient à l'écran d'administration après l'enregistrement.
        if (($_SERVER['HTTP_X_REQUESTED_WITH'] ?? '') !== 'XMLHttpRequest') {
            header('Location: ../../front/superadmin.html?monnaie=enregistree', true, 303);
            exit;
        }
        JsonResponse::send(['success' => true, 'data' => ['type_monais' => $code, 'description' => $description]], 201);
    }

    if ($action === 'super-admin-currencies' && in_array($method, ['PUT', 'PATCH'], true)) {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') JsonResponse::error('Accès réservé au super administrateur.', 403);
        $oldCode = strtoupper(trim((string) ($_GET['code'] ?? '')));
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $newCode = strtoupper(trim((string) ($body['type_monais'] ?? '')));
        $description = trim((string) ($body['description'] ?? ''));
        if ($oldCode === '' || $newCode === '' || strlen($newCode) > 10 || $description === '' || strlen($description) > 10) {
            JsonResponse::error('Code monnaie et symbole sont obligatoires (10 caractères maximum).', 422);
        }
        $db = Database::connection();
        $db->begin_transaction();
        try {
            $updateCurrency = $db->prepare('UPDATE tb_monais SET type_monais = ?, description = ? WHERE type_monais = ?');
            $updateCurrency->bind_param('sss', $newCode, $description, $oldCode);
            $updateCurrency->execute();
            if ($updateCurrency->affected_rows === 0) {
                $exists = $db->prepare('SELECT type_monais FROM tb_monais WHERE type_monais = ? LIMIT 1');
                $exists->bind_param('s', $oldCode);
                $exists->execute();
                if (!$exists->get_result()->fetch_assoc()) throw new RuntimeException('Monnaie introuvable.');
            }
            if ($newCode !== $oldCode) {
                $products = $db->prepare('UPDATE produits SET monais = ? WHERE monais = ?');
                $products->bind_param('ss', $newCode, $oldCode);
                $products->execute();
            }
            $db->commit();
        } catch (Throwable $exception) {
            $db->rollback();
            throw $exception;
        }
        JsonResponse::send(['success' => true, 'data' => ['type_monais' => $newCode, 'description' => $description]]);
    }

    if ($action === 'super-admin-currencies' && $method === 'DELETE') {
        $session = Session::current();
        if (!$session || $session['type'] !== 'super_admin') JsonResponse::error('Accès réservé au super administrateur.', 403);
        $code = strtoupper(trim((string) ($_GET['code'] ?? '')));
        if ($code === '') JsonResponse::error('Code monnaie requis.', 422);
        $db = Database::connection();
        $usage = $db->prepare('SELECT COUNT(*) AS usage_count FROM produits WHERE monais = ?');
        $usage->bind_param('s', $code);
        $usage->execute();
        if ((int) $usage->get_result()->fetch_assoc()['usage_count'] > 0) {
            JsonResponse::error('Cette monnaie est utilisée par des produits. Modifiez ces produits avant de la supprimer.', 409);
        }
        $delete = $db->prepare('DELETE FROM tb_monais WHERE type_monais = ?');
        $delete->bind_param('s', $code);
        $delete->execute();
        JsonResponse::send(['success' => true, 'data' => ['deleted' => $delete->affected_rows > 0]]);
    }

    // Les utilisateurs connectés peuvent consulter les monnaies, mais pas les créer.
    if($action==='payment-modes'&&$method==='GET'){
        AuthGuard::requireAuthenticated();$result=Database::connection()->query("SELECT mode_paiement_id,code,name,requires_cash FROM modes_paiement WHERE is_active=1 AND code IN ('CASH','BANK','MOBILE_MONEY') ORDER BY requires_cash DESC,name");JsonResponse::send(['success'=>true,'data'=>$result->fetch_all(MYSQLI_ASSOC)]);
    }
    if ($action === 'banks' && $method === 'GET') {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à une entreprise.',403);
        Authorization::requireModule($actor, 'caisse');
        $query=Database::connection()->prepare('SELECT banque_id,name,account_number FROM banques WHERE entreprise_id=? AND is_active=1 ORDER BY name');$enterprise=(int)$actor['entreprise_id'];$query->bind_param('i',$enterprise);$query->execute();JsonResponse::send(['success'=>true,'data'=>$query->get_result()->fetch_all(MYSQLI_ASSOC)]);
    }
    if ($action === 'banks' && $method === 'POST') {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à une entreprise.',403);Authorization::requirePermission($actor,'modifier_caisse');
        $body=json_decode((string)file_get_contents('php://input'),true)?:[];$name=trim((string)($body['name']??''));$account=trim((string)($body['account_number']??''));if($name===''||mb_strlen($name,'UTF-8')>120||mb_strlen($account,'UTF-8')>80)JsonResponse::error('Nom de banque requis; numéro de compte limité à 80 caractères.',422);$accountValue=$account!==''?$account:null;$enterprise=(int)$actor['entreprise_id'];$db=Database::connection();$db->begin_transaction();$enterpriseLock=$db->prepare('SELECT entreprise_id FROM entreprises WHERE entreprise_id=? FOR UPDATE');$enterpriseLock->bind_param('i',$enterprise);$enterpriseLock->execute();if(!$enterpriseLock->get_result()->fetch_assoc()){$db->rollback();JsonResponse::error('Entreprise introuvable.',404);}$duplicate=$db->prepare('SELECT banque_id FROM banques WHERE entreprise_id=? AND name=? AND account_number <=> ? AND is_active=1 LIMIT 1');$duplicate->bind_param('iss',$enterprise,$name,$accountValue);$duplicate->execute();if($duplicate->get_result()->fetch_assoc()){$db->rollback();JsonResponse::error('Cette banque avec ce numéro de compte existe déjà.',409);}$query=$db->prepare('INSERT INTO banques (entreprise_id,name,account_number) VALUES (?,?,?)');$query->bind_param('iss',$enterprise,$name,$accountValue);$query->execute();$bankId=(int)$db->insert_id;$db->commit();JsonResponse::send(['success'=>true,'data'=>['banque_id'=>$bankId]],201);
    }
    if ($action === 'banks' && in_array($method, ['PUT', 'DELETE'], true)) {
        $actor=AuthGuard::requireAuthenticated();
        if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à une entreprise.',403);
        Authorization::requirePermission($actor,'modifier_caisse');
        $enterprise=(int)$actor['entreprise_id'];
        $db=Database::connection();
        if($method==='PUT'){
            $body=json_decode((string)file_get_contents('php://input'),true);
            if(!is_array($body))JsonResponse::error('Corps JSON invalide.',400);
            $bankId=(int)($body['banque_id']??0);
            $name=trim((string)($body['name']??''));
            $account=trim((string)($body['account_number']??''));
            if($bankId<1||$name===''||mb_strlen($name,'UTF-8')>120||mb_strlen($account,'UTF-8')>80)JsonResponse::error('Banque, nom et numéro de compte valides requis.',422);
            $accountValue=$account!==''?$account:null;
            $db->begin_transaction();
            try{
                $current=$db->prepare('SELECT banque_id FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1 FOR UPDATE');
                $current->bind_param('ii',$bankId,$enterprise);$current->execute();
                if(!$current->get_result()->fetch_assoc())throw new RuntimeException('Banque introuvable ou déjà supprimée.');
                $duplicate=$db->prepare('SELECT banque_id FROM banques WHERE entreprise_id=? AND name=? AND account_number <=> ? AND banque_id<>? AND is_active=1 LIMIT 1');
                $duplicate->bind_param('issi',$enterprise,$name,$accountValue,$bankId);$duplicate->execute();
                if($duplicate->get_result()->fetch_assoc())throw new RuntimeException('Une autre banque utilise déjà ce nom et ce numéro de compte.');
                $update=$db->prepare('UPDATE banques SET name=?,account_number=? WHERE banque_id=? AND entreprise_id=? AND is_active=1');
                $update->bind_param('ssii',$name,$accountValue,$bankId,$enterprise);$update->execute();
                $db->commit();
                JsonResponse::send(['success'=>true,'data'=>['banque_id'=>$bankId]]);
            }catch(Throwable $exception){$db->rollback();throw $exception;}
        }
        $bankId=(int)($_GET['banque_id']??0);
        if($bankId<1)JsonResponse::error('Identifiant de banque invalide.',422);
        $db->begin_transaction();
        try{
            $current=$db->prepare('SELECT banque_id FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1 FOR UPDATE');
            $current->bind_param('ii',$bankId,$enterprise);$current->execute();
            if(!$current->get_result()->fetch_assoc())throw new RuntimeException('Banque introuvable ou déjà supprimée.');
            $openCash=$db->prepare("SELECT caisse_id FROM caisses WHERE entreprise_id=? AND banque_id=? AND statut='OUVERTE' LIMIT 1 FOR UPDATE");
            $openCash->bind_param('ii',$enterprise,$bankId);$openCash->execute();
            if($openCash->get_result()->fetch_assoc())throw new RuntimeException('Cette banque est associée à une caisse ouverte. Fermez ou modifiez d’abord cette caisse.');
            $references=[];
            foreach(['caisses','paiements_ventes','paiements_fournisseurs','mouvements_caisse'] as $table){
                $reference=$db->prepare("SELECT banque_id FROM {$table} WHERE entreprise_id=? AND banque_id=? LIMIT 1");
                $reference->bind_param('ii',$enterprise,$bankId);$reference->execute();
                if($reference->get_result()->fetch_assoc()){$references[]=$table;break;}
            }
            if($references){
                $delete=$db->prepare('UPDATE banques SET is_active=0 WHERE banque_id=? AND entreprise_id=? AND is_active=1');
                $delete->bind_param('ii',$bankId,$enterprise);$delete->execute();
            }else{
                $delete=$db->prepare('DELETE FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1');
                $delete->bind_param('ii',$bankId,$enterprise);$delete->execute();
            }
            $db->commit();
            JsonResponse::send(['success'=>true,'data'=>['deleted'=>true,'archived'=>(bool)$references]]);
        }catch(Throwable $exception){$db->rollback();throw $exception;}
    }

    if ($action === 'exchange-rates' && in_array($method, ['GET', 'POST', 'PUT', 'DELETE'], true)) {
        $actor = AuthGuard::requireAuthenticated();
        if (!$actor || $actor['type'] !== 'user') JsonResponse::error('Action réservée à un utilisateur d’entreprise.', 403);
        $enterpriseId = (int) $actor['entreprise_id'];
        $rateService = new ExchangeRateService(Database::connection());
        if ($method === 'GET') {
            Authorization::requireAnyPermission($actor, ['voir_caisse', 'modifier_caisse']);
            JsonResponse::send(['success' => true, 'data' => $rateService->list($enterpriseId)]);
        }
        Authorization::requirePermission($actor, 'voir_caisse');
        if ($method === 'DELETE') {
            if (($_GET['type'] ?? '') === 'reference') {
                $rateService->deleteReference($enterpriseId);
            } else {
                $rateService->deleteRate($enterpriseId, (string) ($_GET['monais'] ?? ''));
            }
            JsonResponse::send(['success' => true, 'data' => $rateService->list($enterpriseId)]);
        }
        $body = json_decode((string) file_get_contents('php://input'), true);
        if (!is_array($body)) JsonResponse::error('Corps JSON invalide.', 400);
        $type = (string) ($body['type'] ?? '');
        if ($type === 'reference' && $method === 'POST') {
            $rateService->setReference($enterpriseId, (string) ($body['monais'] ?? ''));
        } elseif ($type === 'rate' && in_array($method, ['POST', 'PUT'], true)) {
            $value = $body['taux_vers_reference'] ?? null;
            if (!is_numeric($value)) JsonResponse::error('Saisissez un taux de change numérique.', 422);
            $rateService->saveRate($enterpriseId, (string) ($body['monais'] ?? ''), (float) $value, (int) $actor['id'], $method === 'PUT');
        } else {
            JsonResponse::error('Opération de taux de change invalide.', 422);
        }
        JsonResponse::send(['success' => true, 'data' => $rateService->list($enterpriseId)]);
    }

    if ($action === 'currencies' && $method === 'GET') {
        AuthGuard::requireAuthenticated();
        $result = Database::connection()->query('SELECT type_monais, description FROM tb_monais ORDER BY type_monais');
        JsonResponse::send(['success' => true, 'data' => $result->fetch_all(MYSQLI_ASSOC)]);
    }

    if ($action === 'profile' && $method === 'GET') {
        $actor = AuthGuard::requireAuthenticated();
        JsonResponse::send(['success' => true, 'data' => $service->sessionProfile($actor)]);
    }

    if ($action === 'profile' && in_array($method, ['PUT', 'PATCH'], true)) {
        $actor = AuthGuard::requireAuthenticated();
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $profile = $service->updateProfile($actor, $body);
        JsonResponse::send(['success' => true, 'data' => $service->sessionProfile($profile)]);
    }

    if ($action === 'company-profile' && $method === 'POST') {
        $actor = AuthGuard::requireAuthenticated();
        if (($actor['type'] ?? '') !== 'user' || empty($actor['is_company_admin'])) {
            JsonResponse::error('Action réservée à l’administrateur de l’entreprise.', 403);
        }
        $companyProfile = (new CompanyProfileService(Database::connection()))->update(
            (int) $actor['entreprise_id'],
            $_POST,
            $_FILES
        );
        JsonResponse::send(['success' => true, 'data' => $service->sessionProfile($actor), 'company' => $companyProfile]);
    }

    if ($action === 'change-password' && $method === 'POST') {
        $actor = AuthGuard::requireAuthenticated();
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $service->changePassword($actor, (string) ($body['current_password'] ?? ''), (string) ($body['new_password'] ?? ''), (string) ($body['confirm_password'] ?? ''));
        JsonResponse::send(['success' => true, 'message' => 'Mot de passe modifié.']);
    }

    if ($action === 'register' && $method === 'POST') {
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $enterpriseId = $service->registerEnterprise($body);
        JsonResponse::send([
            'success' => true,
            'message' => 'Votre demande a été enregistrée. Le super administrateur doit activer votre entreprise.',
            'data' => ['entreprise_id' => $enterpriseId],
        ], 201);
    }

    if ($action === 'create-user' && $method === 'POST') {
        $actor = AuthGuard::requireAuthenticated();
        if (!$actor || $actor['type'] !== 'user') {
            JsonResponse::error('Seul un administrateur d’entreprise peut créer un utilisateur.', 403);
        }
        Authorization::requirePermission($actor, 'gerer_utilisateurs');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $userId = $service->createUserForActor($actor, $body);
        JsonResponse::send(['success' => true, 'data' => ['user_id' => $userId]], 201);
    }

    if ($action === 'update-user' && in_array($method, ['PUT', 'PATCH'], true)) {
        $actor = AuthGuard::requireAuthenticated();
        if ($actor['type'] !== 'user') JsonResponse::error('Action réservée à un administrateur d’entreprise.', 403);
        Authorization::requirePermission($actor, 'gerer_utilisateurs');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $userId = (int) ($_GET['id'] ?? 0);
        if ($userId < 1) JsonResponse::error('Identifiant utilisateur requis.', 422);
        $service->updateUserForActor($actor, $userId, $body);
        JsonResponse::send(['success' => true, 'message' => 'Utilisateur modifié.']);
    }

    if ($action === 'delete-user' && $method === 'DELETE') {
        $actor = AuthGuard::requireAuthenticated();
        if ($actor['type'] !== 'user') JsonResponse::error('Action réservée à un administrateur d’entreprise.', 403);
        Authorization::requirePermission($actor, 'gerer_utilisateurs');
        $deleted = $service->deleteUserForActor($actor, (int) ($_GET['id'] ?? 0));
        JsonResponse::send(['success' => true, 'data' => ['deleted' => $deleted]]);
    }

    if ($action === 'list-users' && $method === 'GET') {
        $actor = AuthGuard::requireAuthenticated();
        if (!$actor || $actor['type'] !== 'user') JsonResponse::error('Authentification requise.', 401);
        Authorization::requirePermission($actor, 'gerer_utilisateurs');
        $branchId = Authorization::branchId($actor, isset($_GET['succursale_id']) ? (int) $_GET['succursale_id'] : null);
        if (isset($_GET['page'])) {
            $page = max(1, (int) $_GET['page']);
            $perPage = min(100, max(1, (int) ($_GET['per_page'] ?? 10)));
            $pageResult = $service->usersPage((int) $actor['entreprise_id'], $branchId, $page, $perPage);
            JsonResponse::send(['success' => true, 'data' => $pageResult['rows'], 'pagination' => $pageResult['pagination']]);
        }
        JsonResponse::send(['success' => true, 'data' => $service->users((int) $actor['entreprise_id'], $branchId)]);
    }

    if ($action === 'create-role' && $method === 'POST') {
        $actor = AuthGuard::requireAuthenticated();
        if (!$actor || $actor['type'] !== 'user') {
            JsonResponse::error('Seul un administrateur d’entreprise peut créer un rôle.', 403);
        }
        Authorization::requirePermission($actor, 'gerer_roles');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $roleId = $service->createRole((int) $actor['entreprise_id'], $body);
        JsonResponse::send(['success' => true, 'data' => ['role_id' => $roleId]], 201);
    }

    if ($action === 'update-role' && in_array($method, ['PUT', 'PATCH'], true)) {
        $actor = AuthGuard::requireAuthenticated();
        if ($actor['type'] !== 'user') JsonResponse::error('Action réservée à un administrateur d’entreprise.', 403);
        Authorization::requirePermission($actor, 'gerer_roles');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $roleId = (int) ($_GET['id'] ?? 0);
        if ($roleId < 1) JsonResponse::error('Identifiant rôle requis.', 422);
        $service->updateRole((int) $actor['entreprise_id'], $roleId, $body);
        JsonResponse::send(['success' => true, 'message' => 'Rôle modifié.']);
    }

    if ($action === 'delete-role' && $method === 'DELETE') {
        $actor = AuthGuard::requireAuthenticated();
        if ($actor['type'] !== 'user') JsonResponse::error('Action réservée à un administrateur d’entreprise.', 403);
        Authorization::requirePermission($actor, 'gerer_roles');
        $deleted = $service->deleteRole((int) $actor['entreprise_id'], (int) ($_GET['id'] ?? 0));
        JsonResponse::send(['success' => true, 'data' => ['deleted' => $deleted]]);
    }

    // Enregistre un approvisionnement complet avec sa ligne produit et le stock reçu.
    if ($action === 'create-purchase' && $method === 'POST') {
        $actor = AuthGuard::requireAuthenticated();
        if (!$actor || $actor['type'] !== 'user') {
            JsonResponse::error('Seul un utilisateur d’entreprise peut créer un approvisionnement.', 403);
        }
        // Cette action ajoute un achat et réceptionne les quantités dans le stock.
        // Le droit utilisé correspond à celui accordé par l'accès « stock ».
        Authorization::requirePermission($actor, 'creer_approvisionnements');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $requestedBranchId = isset($body['succursale_id']) && $body['succursale_id'] !== '' ? (int) $body['succursale_id'] : null;
        $authorizedBranchId = Authorization::branchId($actor, $requestedBranchId);
        if ($authorizedBranchId !== null) $body['succursale_id'] = $authorizedBranchId;
        else unset($body['succursale_id']);
        $purchaseId = (new ProcurementService(Database::connection()))->createPurchase($actor, $body);
        JsonResponse::send(['success' => true, 'data' => ['achat_id' => $purchaseId]], 201);
    }

    if ($action === 'update-purchase-status' && in_array($method, ['PATCH', 'PUT'], true)) {
        $actor = AuthGuard::requireAuthenticated();
        if (!$actor || $actor['type'] !== 'user') JsonResponse::error('Action réservée à un utilisateur d’entreprise.', 403);
        Authorization::requirePermission($actor, 'creer_approvisionnements');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        (new ProcurementService(Database::connection()))->updatePurchaseStatus($actor, (int) ($body['achat_id'] ?? 0), (string) ($body['status'] ?? ''));
        JsonResponse::send(['success' => true, 'message' => 'Statut modifié.']);
    }

    if ($action === 'create-sale' && $method === 'POST') {
        $actor=AuthGuard::requireAuthenticated(); if(!$actor||$actor['type']!=='user') JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403);
        Authorization::requirePermission($actor,'creer_ventes'); $body=json_decode((string)file_get_contents('php://input'),true)?:[];
        $requested=isset($body['succursale_id'])?(int)$body['succursale_id']:null; $allowed=Authorization::branchId($actor,$requested); if($allowed!==null)$body['succursale_id']=$allowed;
        $id=(new SalesService(Database::connection()))->create($actor,$body); JsonResponse::send(['success'=>true,'data'=>['vente_id'=>$id]],201);
    }
    if ($action === 'create-sale-client' && $method === 'POST') {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403);
        Authorization::requireAnyPermission($actor,['creer_ventes','gerer_clients'],'Accès refusé. Autorisation requise : création de ventes ou gestion des clients.');$body=json_decode((string)file_get_contents('php://input'),true)?:[];
        $requested=isset($body['succursale_id'])?(int)$body['succursale_id']:null;Authorization::branchId($actor,$requested);
        $name=trim((string)($body['name']??''));$email=trim((string)($body['email']??''));$phone=trim((string)($body['phone']??''));$address=trim((string)($body['address']??''));
        if($name==='')JsonResponse::error('Le nom du client est obligatoire.',422);if($email!==''&&!filter_var($email,FILTER_VALIDATE_EMAIL))JsonResponse::error('Adresse électronique invalide.',422);
        $db=Database::connection();$enterprise=(int)$actor['entreprise_id'];$insert=$db->prepare('INSERT INTO clients (entreprise_id,name,email,phone,address) VALUES (?,?,?,?,?)');$insert->bind_param('issss',$enterprise,$name,$email,$phone,$address);$insert->execute();JsonResponse::send(['success'=>true,'data'=>['client_id'=>(int)$db->insert_id,'name'=>$name]],201);
    }
    if ($action === 'collect-sale-payment' && in_array($method,['POST','PATCH'],true)) {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403);
        $body=json_decode((string)file_get_contents('php://input'),true)?:[];$source=strtoupper((string)($body['source']??''));
        if($source!=='CASH')JsonResponse::error('Le paiement doit être validé depuis le module de caisse.',403);
        Authorization::requirePermission($actor,'modifier_caisse');
        $invoiceCurrency=trim((string)($body['monais']??''));$receivedCurrency=trim((string)($body['received_monais']??$invoiceCurrency));$salePaid=(new SalesService(Database::connection()))->collectPayment($actor,(int)($body['vente_id']??0),$invoiceCurrency,(float)($body['amount']??0),$receivedCurrency,(int)($body['mode_paiement_id']??0),isset($body['caisse_id'])&&$body['caisse_id']!==''?(int)$body['caisse_id']:null,trim((string)($body['reference']??'')),isset($body['banque_id'])&&$body['banque_id']!==''?(int)$body['banque_id']:null);
        JsonResponse::send(['success'=>true,'message'=>$salePaid?'Paiement enregistré en caisse. Facture réglée.':'Paiement partiel enregistré en caisse. Un solde reste dû.']);
    }
    if ($action === 'cancel-sale' && in_array($method,['POST','PATCH'],true)) {
        $actor=AuthGuard::requireAuthenticated(); if(!$actor||$actor['type']!=='user') JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403);
        Authorization::requirePermission($actor,'modifier_ventes'); $body=json_decode((string)file_get_contents('php://input'),true)?:[];
        (new SalesService(Database::connection()))->cancel($actor,(int)($body['vente_id']??0)); JsonResponse::send(['success'=>true,'message'=>'Vente annulée et stock rétabli.']);
    }
    if ($action === 'open-cash' && $method === 'POST') {
        $actor=AuthGuard::requireAuthenticated(); if(!$actor||$actor['type']!=='user') JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403); Authorization::requirePermission($actor,'creer_caisse');
        $body=json_decode((string)file_get_contents('php://input'),true)?:[]; $requested=isset($body['succursale_id'])?(int)$body['succursale_id']:null; $branch=Authorization::branchId($actor,$requested)??(int)($actor['succursale_id']??0);
        $currency= strtoupper(trim((string)($body['type_monais']??'')));$name=trim((string)($body['name']??''));$opening=(float)($body['solde_ouverture']??0);$modeId=(int)($body['mode_paiement_id']??0);if($branch<1||$currency===''||$name===''||$opening<0||$modeId<1)JsonResponse::error('Succursale, monnaie, mode de paiement, nom et solde d’ouverture valide requis.',422);
        $db=Database::connection();$enterprise=(int)$actor['entreprise_id'];$currencyQuery=$db->prepare('SELECT type_monais,description FROM tb_monais WHERE type_monais=? LIMIT 1');$currencyQuery->bind_param('s',$currency);$currencyQuery->execute();$currencyRow=$currencyQuery->get_result()->fetch_assoc();if(!$currencyRow)JsonResponse::error('La monnaie choisie n’est plus autorisée.',422);
        $modeQuery=$db->prepare("SELECT mode_paiement_id,code FROM modes_paiement WHERE mode_paiement_id=? AND is_active=1 AND code IN ('CASH','BANK','MOBILE_MONEY')");$modeQuery->bind_param('i',$modeId);$modeQuery->execute();$mode=$modeQuery->get_result()->fetch_assoc();if(!$mode)JsonResponse::error('Mode de paiement indisponible.',422);
        $bankId=isset($body['banque_id'])?(int)$body['banque_id']:0;if($mode['code']==='BANK'){if($bankId<1)JsonResponse::error('Choisissez une banque pour cette caisse.',422);$bank=$db->prepare('SELECT banque_id FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1');$bank->bind_param('ii',$bankId,$enterprise);$bank->execute();if(!$bank->get_result()->fetch_assoc())JsonResponse::error('La banque choisie est indisponible.',422);}elseif($bankId>0)JsonResponse::error('Une banque ne peut être associée qu’à une caisse en mode Banque.',422);$nullableBankId=$bankId>0?$bankId:null;
        $db->begin_transaction();$branchLock=$db->prepare('SELECT succursale_id FROM succursales WHERE succursale_id=? AND entreprise_id=? FOR UPDATE');$branchLock->bind_param('ii',$branch,$enterprise);$branchLock->execute();if(!$branchLock->get_result()->fetch_assoc()){ $db->rollback();JsonResponse::error('Succursale introuvable.',404); }
        $currencySymbol=trim((string)($currencyRow['description']??''))?:$currency;$typeName='Monnaie '.$currency;$typeDescription='Caisse en '.$currency;
        $ensureType=$db->prepare('INSERT INTO types_caisses (entreprise_id,code,name,symbole,description,is_active) VALUES (?,?,?,?,?,1) ON DUPLICATE KEY UPDATE type_caisse_id=LAST_INSERT_ID(type_caisse_id),name=VALUES(name),symbole=VALUES(symbole),description=VALUES(description),is_active=1');$ensureType->bind_param('issss',$enterprise,$currency,$typeName,$currencySymbol,$typeDescription);$ensureType->execute();$typeId=(int)$db->insert_id;
        if($typeId<1){$typeQuery=$db->prepare('SELECT type_caisse_id FROM types_caisses WHERE entreprise_id=? AND code=? LIMIT 1');$typeQuery->bind_param('is',$enterprise,$currency);$typeQuery->execute();$typeId=(int)($typeQuery->get_result()->fetch_assoc()['type_caisse_id']??0);}if($typeId<1)JsonResponse::error('Impossible de préparer le type de caisse pour cette monnaie.',500);
        $duplicate=$db->prepare("SELECT caisse_id FROM caisses WHERE entreprise_id=? AND succursale_id=? AND type_caisse_id=? AND mode_paiement_id=? AND statut='OUVERTE' LIMIT 1");$duplicate->bind_param('iiii',$enterprise,$branch,$typeId,$modeId);$duplicate->execute();if($duplicate->get_result()->fetch_assoc()){ $db->rollback();JsonResponse::error('Une caisse est déjà ouverte pour cette succursale, cette monnaie et ce mode de paiement.',409); }
        $userId=(int)$actor['id'];$insert=$db->prepare("INSERT INTO caisses (entreprise_id,succursale_id,type_caisse_id,mode_paiement_id,banque_id,user_id,name,solde_ouverture,montant,statut) VALUES (?,?,?,?,?,?,?,?,?,'OUVERTE')");$insert->bind_param('iiiiiisdd',$enterprise,$branch,$typeId,$modeId,$nullableBankId,$userId,$name,$opening,$opening);$insert->execute();$cashId=(int)$db->insert_id;$db->commit();JsonResponse::send(['success'=>true,'data'=>['caisse_id'=>$cashId]],201);
    }
    if ($action === 'close-cash' && in_array($method,['POST','PATCH'],true)) {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403);Authorization::requirePermission($actor,'modifier_caisse');
        $body=json_decode((string)file_get_contents('php://input'),true)?:[];$cashId=(int)($body['caisse_id']??0);$closing=(float)($body['solde_fermeture']??-1);if($cashId<1||$closing<0)JsonResponse::error('Caisse et solde de fermeture valide requis.',422);
        $db=Database::connection();$enterprise=(int)$actor['entreprise_id'];$query=$db->prepare("SELECT caisse_id,succursale_id FROM caisses WHERE caisse_id=? AND entreprise_id=? AND statut='OUVERTE' LIMIT 1");$query->bind_param('ii',$cashId,$enterprise);$query->execute();$cash=$query->get_result()->fetch_assoc();if(!$cash)JsonResponse::error('Caisse ouverte introuvable.',404);if((int)($actor['succursale_id']??0)>0&&(int)$actor['succursale_id']!==(int)$cash['succursale_id'])JsonResponse::error('Accès limité à une autre succursale.',403);
        $pending=$db->prepare("SELECT COUNT(*) AS total FROM ventes WHERE entreprise_id=? AND caisse_id=? AND status IN ('PENDING','PARTIAL')");$pending->bind_param('ii',$enterprise,$cashId);$pending->execute();if((int)($pending->get_result()->fetch_assoc()['total']??0)>0)JsonResponse::error('Cette caisse a des ventes en attente de paiement. Validez-les ou annulez-les avant de clôturer la caisse.',409);
        $update=$db->prepare("UPDATE caisses SET solde_fermeture=?, montant=?, date_fermeture=NOW(), statut='FERMEE' WHERE caisse_id=? AND entreprise_id=? AND statut='OUVERTE'");$update->bind_param('ddii',$closing,$closing,$cashId,$enterprise);$update->execute();JsonResponse::send(['success'=>true,'message'=>'Caisse fermée.']);
    }
    if ($action === 'delete-cash' && $method === 'POST') {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à une entreprise.',403);Authorization::requirePermission($actor,'supprimer_caisse');
        $body=json_decode((string)file_get_contents('php://input'),true)?:[];$cashId=(int)($body['caisse_id']??0);if($cashId<1)JsonResponse::error('Identifiant de caisse invalide.',422);
        $db=Database::connection();$enterprise=(int)$actor['entreprise_id'];$db->begin_transaction();
        try{$cashQuery=$db->prepare('SELECT caisse_id,succursale_id,statut FROM caisses WHERE caisse_id=? AND entreprise_id=? FOR UPDATE');$cashQuery->bind_param('ii',$cashId,$enterprise);$cashQuery->execute();$cash=$cashQuery->get_result()->fetch_assoc();if(!$cash)throw new RuntimeException('Caisse introuvable.');if((int)($actor['succursale_id']??0)>0&&(int)$actor['succursale_id']!==(int)$cash['succursale_id'])throw new RuntimeException('Accès limité à une autre succursale.');if($cash['statut']!=='FERMEE')throw new RuntimeException('Clôturez la caisse avant de la supprimer.');
            $usage=$db->prepare('SELECT (SELECT COUNT(*) FROM mouvements_caisse WHERE entreprise_id=? AND caisse_id=?) + (SELECT COUNT(*) FROM ventes WHERE entreprise_id=? AND caisse_id=?) + (SELECT COUNT(*) FROM paiements_ventes WHERE entreprise_id=? AND caisse_id=?) + (SELECT COUNT(*) FROM paiements_fournisseurs WHERE entreprise_id=? AND caisse_id=?) AS total');$usage->bind_param('iiiiiiii',$enterprise,$cashId,$enterprise,$cashId,$enterprise,$cashId,$enterprise,$cashId);$usage->execute();if((int)$usage->get_result()->fetch_assoc()['total']>0)throw new RuntimeException('Cette caisse contient des opérations ou des paiements. Elle ne peut pas être supprimée.');
            $delete=$db->prepare('DELETE FROM caisses WHERE caisse_id=? AND entreprise_id=? AND statut=\'FERMEE\'');$delete->bind_param('ii',$cashId,$enterprise);$delete->execute();$db->commit();JsonResponse::send(['success'=>true,'message'=>'Caisse supprimée.']);
        }catch(Throwable $exception){$db->rollback();throw $exception;}
    }
    if ($action === 'create-cash-movement' && $method === 'POST') {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403);Authorization::requirePermission($actor,'modifier_caisse');
        $body=json_decode((string)file_get_contents('php://input'),true)?:[];$cashId=(int)($body['caisse_id']??0);$type=strtoupper((string)($body['type']??''));$amount=(float)($body['amount']??0);$reason=trim((string)($body['reason']??''));$bankReference=trim((string)($body['bank_reference']??''));if($cashId<1||!in_array($type,['ENTREE','SORTIE'],true)||$amount<=0||$reason==='')JsonResponse::error('Caisse, type, motif et montant positif requis.',422);if(mb_strlen($bankReference,'UTF-8')>120)JsonResponse::error('La référence bancaire est limitée à 120 caractères.',422);
        $db=Database::connection();$enterprise=(int)$actor['entreprise_id'];$q=$db->prepare("SELECT c.succursale_id,c.mode_paiement_id,c.banque_id,c.montant,m.code AS mode_code FROM caisses c JOIN modes_paiement m ON m.mode_paiement_id=c.mode_paiement_id WHERE c.caisse_id=? AND c.entreprise_id=? AND c.statut='OUVERTE' LIMIT 1");$q->bind_param('ii',$cashId,$enterprise);$q->execute();$cash=$q->get_result()->fetch_assoc();if(!$cash)JsonResponse::error('La caisse choisie n’est pas ouverte.',422);if((int)($actor['succursale_id']??0)>0&&(int)$actor['succursale_id']!==(int)$cash['succursale_id'])JsonResponse::error('Accès limité à une autre succursale.',403);
        $bankId=isset($body['banque_id'])?(int)$body['banque_id']:0;if($cash['mode_code']==='BANK'){if($bankId<1)JsonResponse::error('Choisissez la banque concernée par cette opération.',422);if($cash['banque_id']!==null&&(int)$cash['banque_id']!==$bankId)JsonResponse::error('La banque choisie ne correspond pas à la banque associée à cette caisse.',422);if($bankReference==='')JsonResponse::error('Saisissez la référence de l’opération bancaire.',422);$bank=$db->prepare('SELECT banque_id FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1');$bank->bind_param('ii',$bankId,$enterprise);$bank->execute();if(!$bank->get_result()->fetch_assoc())JsonResponse::error('La banque choisie est indisponible.',422);}elseif($bankId>0||$bankReference!=='')JsonResponse::error('La banque et sa référence ne peuvent être choisies que pour une caisse de mode Banque.',422);
        $user=(int)$actor['id'];$modeId=(int)$cash['mode_paiement_id'];$nullableBankId=$bankId>0?$bankId:null;$nullableBankReference=$bankReference!==''?$bankReference:null;$db->begin_transaction();
        try{$lockedCashQuery=$db->prepare("SELECT montant FROM caisses WHERE caisse_id=? AND entreprise_id=? AND statut='OUVERTE' FOR UPDATE");$lockedCashQuery->bind_param('ii',$cashId,$enterprise);$lockedCashQuery->execute();$lockedCash=$lockedCashQuery->get_result()->fetch_assoc();if(!$lockedCash){$db->rollback();JsonResponse::error('La caisse choisie n’est plus ouverte.',422);}if($type==='SORTIE'&&(float)$lockedCash['montant']<(float)$amount-0.009){$db->rollback();JsonResponse::error('Solde insuffisant dans la caisse pour cette sortie.',422);}
            $insert=$db->prepare('INSERT INTO mouvements_caisse (entreprise_id,caisse_id,user_id,mode_paiement_id,banque_id,bank_reference,type,amount,reason) VALUES (?,?,?,?,?,?,?,?,?)');$insert->bind_param('iiiiissds',$enterprise,$cashId,$user,$modeId,$nullableBankId,$nullableBankReference,$type,$amount,$reason);$insert->execute();$delta=$type==='ENTREE'?$amount:-$amount;$balance=$db->prepare('UPDATE caisses SET montant=montant+? WHERE caisse_id=? AND entreprise_id=? AND statut="OUVERTE"');$balance->bind_param('dii',$delta,$cashId,$enterprise);$balance->execute();if($balance->affected_rows!==1)throw new RuntimeException('Le solde de la caisse n’a pas pu être mis à jour.');$movementId=(int)$db->insert_id;$db->commit();
        }catch(Throwable $exception){$db->rollback();throw $exception;}
        JsonResponse::send(['success'=>true,'data'=>['mouvement_id'=>$movementId]],201);
    }

    if ($action === 'pay-supplier' && $method === 'POST') {
        $actor=AuthGuard::requireAuthenticated();if(!$actor||$actor['type']!=='user')JsonResponse::error('Action réservée à un utilisateur d’entreprise.',403);
        Authorization::requirePermission($actor,'modifier_caisse');
            $body=json_decode((string)file_get_contents('php://input'),true)?:[];$purchaseId=(int)($body['achat_id']??0);$cashId=(int)($body['caisse_id']??0);$bankId=isset($body['banque_id'])?(int)$body['banque_id']:0;$amount=round((float)($body['amount']??0),2);
        if($purchaseId<1||$amount<=0)JsonResponse::error('Approvisionnement et montant positif requis.',422);
        $db=Database::connection();$enterprise=(int)$actor['entreprise_id'];$userId=(int)$actor['id'];$db->begin_transaction();
        try{
            $purchaseQuery=$db->prepare("SELECT a.succursale_id,a.purchase_no,a.total_amount,a.amount_paid,a.monais,f.name AS supplier_name FROM achats a JOIN fournisseurs f ON f.fournisseur_id=a.fournisseur_id AND f.entreprise_id=a.entreprise_id WHERE a.achat_id=? AND a.entreprise_id=? AND a.movement_type='IN' AND a.status='RECEIVED' FOR UPDATE");$purchaseQuery->bind_param('ii',$purchaseId,$enterprise);$purchaseQuery->execute();$purchase=$purchaseQuery->get_result()->fetch_assoc();
            if(!$purchase)throw new RuntimeException('Dette fournisseur introuvable ou non validée.');
            if((int)($actor['succursale_id']??0)>0&&(int)$actor['succursale_id']!==(int)$purchase['succursale_id'])throw new RuntimeException('Accès limité à une autre succursale.');
            $due=round((float)$purchase['total_amount']-(float)$purchase['amount_paid'],2);if($amount>$due+0.009)throw new RuntimeException('Le paiement dépasse le solde dû ('.$due.').');
            $modeId=(int)($body['mode_paiement_id']??0);$reference=trim((string)($body['reference']??''));if(mb_strlen($reference,'UTF-8')>120)throw new RuntimeException('La référence de paiement est limitée à 120 caractères.');$modeQuery=$db->prepare("SELECT mode_paiement_id,code,requires_cash FROM modes_paiement WHERE mode_paiement_id=? AND is_active=1 AND code IN ('CASH','BANK','MOBILE_MONEY')");$modeQuery->bind_param('i',$modeId);$modeQuery->execute();$mode=$modeQuery->get_result()->fetch_assoc();if(!$mode)throw new RuntimeException('Mode de paiement indisponible.');
            if($cashId<1)throw new RuntimeException('Choisissez une caisse ouverte pour ce mode de paiement.');$cashQuery=$db->prepare("SELECT c.succursale_id,t.code,c.mode_paiement_id,c.banque_id,c.montant AS available_balance FROM caisses c JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id WHERE c.caisse_id=? AND c.entreprise_id=? AND c.statut='OUVERTE' FOR UPDATE");$cashQuery->bind_param('ii',$cashId,$enterprise);$cashQuery->execute();$cash=$cashQuery->get_result()->fetch_assoc();if(!$cash)throw new RuntimeException('Choisissez une caisse ouverte.');if((int)$cash['succursale_id']!==(int)$purchase['succursale_id'])throw new RuntimeException('La caisse doit appartenir à la succursale de l’approvisionnement.');if((string)$cash['code']!==(string)$purchase['monais'])throw new RuntimeException('La monnaie de la caisse ne correspond pas à la dette fournisseur.');if((int)$cash['mode_paiement_id']!==$modeId)throw new RuntimeException('Le mode de paiement ne correspond pas à la caisse choisie.');if($amount>(float)$cash['available_balance']+0.009)throw new RuntimeException('Solde insuffisant dans la caisse ou le compte sélectionné. Disponible : '.$cash['available_balance'].' '.$cash['code'].'.');$paymentBankId=null;if($mode['code']==='BANK'){if($bankId<1)throw new RuntimeException('Choisissez la banque concernée par cette opération.');if($cash['banque_id']!==null&&(int)$cash['banque_id']!==$bankId)throw new RuntimeException('La banque choisie ne correspond pas à la banque associée à cette caisse.');$bank=$db->prepare('SELECT banque_id FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1');$bank->bind_param('ii',$bankId,$enterprise);$bank->execute();if(!$bank->get_result()->fetch_assoc())throw new RuntimeException('La banque choisie est indisponible.');$paymentBankId=$bankId;}elseif($bankId>0)throw new RuntimeException('La banque ne peut être choisie que pour un paiement bancaire.');if((int)$mode['requires_cash']!==1&&$reference==='')throw new RuntimeException('La référence de paiement est obligatoire pour ce mode.');$paymentCashId=$cashId;
            $newPaid=round((float)$purchase['amount_paid']+$amount,2);$update=$db->prepare('UPDATE achats SET amount_paid=? WHERE achat_id=? AND entreprise_id=?');$update->bind_param('dii',$newPaid,$purchaseId,$enterprise);$update->execute();
            $payment=$db->prepare('INSERT INTO paiements_fournisseurs (entreprise_id,achat_id,mode_paiement_id,banque_id,caisse_id,user_id,amount,reference) VALUES (?,?,?,?,?,?,?,?)');$payment->bind_param('iiiiiids',$enterprise,$purchaseId,$modeId,$paymentBankId,$paymentCashId,$userId,$amount,$reference);$payment->execute();
            if($paymentCashId!==null){$cashUpdate=$db->prepare('UPDATE caisses SET montant=montant-? WHERE caisse_id=? AND entreprise_id=? AND statut="OUVERTE"');$cashUpdate->bind_param('dii',$amount,$paymentCashId,$enterprise);$cashUpdate->execute();if($cashUpdate->affected_rows!==1)throw new RuntimeException('Le solde de la caisse n’a pas pu être ajusté.');}
            if($paymentCashId!==null){$type='SORTIE';$reason='Paiement fournisseur '.$purchase['supplier_name'].' · '.$purchase['purchase_no'];$bankReference=(string)$reference;$movement=$db->prepare('INSERT INTO mouvements_caisse (entreprise_id,caisse_id,user_id,mode_paiement_id,banque_id,bank_reference,type,amount,reason,reference_id) VALUES (?,?,?,?,?,?,?,?,?,?)');$movement->bind_param('iiiiissdsi',$enterprise,$paymentCashId,$userId,$modeId,$paymentBankId,$bankReference,$type,$amount,$reason,$purchaseId);$movement->execute();}$db->commit();
        }catch(Throwable $exception){$db->rollback();throw $exception;}
        JsonResponse::send(['success'=>true,'message'=>'Paiement fournisseur enregistré.']);
    }

    if ($action === 'logout' && $method === 'POST') {
        Session::logout();
        JsonResponse::send(['success' => true, 'message' => 'Session fermée.']);
    }

    if ($action === 'me' && $method === 'GET') {
        $current = Session::current();
        JsonResponse::send(['success' => true, 'data' => $current ? $service->sessionProfile($current) : null]);
    }

    JsonResponse::error('Action d’authentification inconnue.', 404);
} catch (Throwable $exception) {
    $message = $exception->getMessage();
    $status = str_contains($message, 'Authentification requise') ? 401
        : (str_contains($message, 'Permission requise') || str_contains($message, 'Accès refusé') || str_contains($message, 'Accès limité') || str_contains($message, 'Seul un administrateur') ? 403
            : ($exception instanceof RuntimeException ? 422 : 500));
    JsonResponse::error($message, $status);
}
