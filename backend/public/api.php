<?php
declare(strict_types=1);

require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Repositories/CrudRepository.php';

use AlbaStock\Core\JsonResponse;
use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Repositories\CrudRepository;

$resource = trim((string) ($_GET['resource'] ?? ''), '/');
// La configuration serveur décide quelles tables et colonnes sont accessibles via cette API.
$configuration = ALBA_STOCK_ALLOWED_RESOURCES[$resource] ?? null;
if ($configuration === null) {
    JsonResponse::error('Ressource API inconnue.', 404);
}
if ($resource === 'stocks') {
    JsonResponse::error('Utilisez stock.php pour consulter ou ajuster les quantités.', 410);
}
if ($resource === 'ventes' && in_array($_SERVER['REQUEST_METHOD'], ['POST','PUT','PATCH','DELETE'], true)) {
    JsonResponse::error('Utilisez le circuit de vente pour créer ou annuler une facture afin de synchroniser le stock et la caisse.', 405);
}
if ($resource === 'users' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    JsonResponse::error('Utilisez auth.php?action=list-users pour consulter les utilisateurs sans exposer leurs mots de passe.', 410);
}

$productCreationTransaction = false;
$mainBranchTransaction = false;
try {
    // L'accès à la base et la session sont maintenant dans try afin que leurs erreurs restent JSON.
    $repository = new CrudRepository($configuration['table'], $configuration['key'], $configuration['columns']);
    $authenticatedUser = AuthGuard::requireAuthenticated();
    $enterpriseId = AuthGuard::enterpriseId($authenticatedUser);
    $branchId = isset($_GET['succursale_id']) ? (int) $_GET['succursale_id'] : null;
    $method = $_SERVER['REQUEST_METHOD'];
    $id = isset($_GET['id']) ? (int) $_GET['id'] : null;
    $body = json_decode((string) file_get_contents('php://input'), true) ?: [];

    // Les unités sont un référentiel de l'entreprise, administré par son compte propriétaire.
    if ($resource === 'unites_mesure' && $method !== 'GET'
        && ($authenticatedUser['type'] === 'super_admin' || empty($authenticatedUser['is_company_admin']))) {
        JsonResponse::error('Seul l’administrateur de l’entreprise peut gérer les unités de mesure.', 403);
    }
    if ($resource === 'unites_mesure' && in_array($method, ['POST', 'PUT', 'PATCH'], true)) {
        foreach (['name' => 50, 'symbole' => 15] as $field => $maximumLength) {
            if ($method === 'POST' && trim((string) ($body[$field] ?? '')) === '') {
                JsonResponse::error('Le nom de l’unité et son symbole sont obligatoires.', 422);
            }
            if (array_key_exists($field, $body)) {
                $body[$field] = trim((string) $body[$field]);
                if ($body[$field] === '' || mb_strlen($body[$field], 'UTF-8') > $maximumLength) {
                    JsonResponse::error('Le nom ou le symbole de l’unité est vide ou trop long.', 422);
                }
            }
        }
    }
    if ($resource === 'unites_mesure' && $method === 'DELETE' && $id !== null) {
        $usage = AlbaStock\Core\Database::connection()->prepare('SELECT COUNT(*) AS total FROM produits WHERE entreprise_id = ? AND unite_de_mesure = ?');
        $usage->bind_param('ii', $enterpriseId, $id);
        $usage->execute();
        if ((int) ($usage->get_result()->fetch_assoc()['total'] ?? 0) > 0) {
            JsonResponse::error('Cette unité est utilisée par des produits. Réaffectez ces produits avant de la supprimer.', 409);
        }
    }

    // Chaque lecture/écriture exige le droit associé à la ressource et à la méthode HTTP.
    $accountingPermissions = Authorization::permissions($authenticatedUser);
    if (($resource === 'achats' || $resource === 'ventes') && $method === 'GET'
        && Authorization::moduleAllowed($authenticatedUser, 'comptabilite')
        && (in_array('*', $accountingPermissions, true) || in_array('voir_comptabilite', $accountingPermissions, true))) {
        // La comptabilité peut consulter les données source nécessaires à ses totaux sans gérer les opérations.
    } elseif ($resource === 'unites_mesure' && $method === 'GET') {
        // Les unités doivent être lisibles pour sélectionner une unité dans un formulaire de produit.
        Authorization::requireAnyPermission($authenticatedUser, ['voir_stock', 'creer_produit', 'modifier_produit']);
    } elseif ($resource === 'roles' && $method === 'GET') {
        Authorization::requireAnyPermission($authenticatedUser, ['voir_roles', 'gerer_roles', 'gerer_utilisateurs']);
    } else {
        Authorization::requirePermission($authenticatedUser, Authorization::resourcePermission($resource, $method));
    }
    if ($resource === 'succursales' && in_array($method, ['POST', 'PUT', 'PATCH'], true)
        && (int) ($body['est_sucursal_mere'] ?? 0) === 1) {
        // Une entreprise ne garde qu'une succursale mère, modifiée dans la même transaction.
        AlbaStock\Core\Database::connection()->begin_transaction();
        $mainBranchTransaction = true;
        $resetMainBranch = AlbaStock\Core\Database::connection()->prepare('UPDATE succursales SET est_sucursal_mere = 0 WHERE entreprise_id = ?');
        $resetMainBranch->bind_param('i', $enterpriseId);
        $resetMainBranch->execute();
    }
    $branchScopedResources = ['users', 'stocks', 'achats', 'caisses', 'ventes', 'mouvements-caisse', 'transferts-stock', 'fournisseurs'];
    // Les ressources de succursale sont limitées au point de vente de l'utilisateur si son rôle en définit un.
    if (in_array($resource, $branchScopedResources, true)) {
        $branchId = Authorization::branchId($authenticatedUser, $branchId);
        if ($method === 'POST' && $branchId !== null) {
            if (isset($body['succursale_id']) && (int) $body['succursale_id'] !== $branchId) {
                JsonResponse::error('Accès limité à votre succursale.', 403);
            }
            $body['succursale_id'] = $branchId;
        }
    }
    if ($resource === 'fournisseurs' && in_array($method, ['POST', 'PUT', 'PATCH'], true)
        && !empty($body['succursale_id'])) {
        $supplierBranchId = (int) $body['succursale_id'];
        $branchCheck = AlbaStock\Core\Database::connection()->prepare('SELECT succursale_id FROM succursales WHERE succursale_id = ? AND entreprise_id = ? LIMIT 1');
        $branchCheck->bind_param('ii', $supplierBranchId, $enterpriseId);
        $branchCheck->execute();
        if (!$branchCheck->get_result()->fetch_assoc()) JsonResponse::error('La succursale du fournisseur ne correspond pas à votre entreprise.', 422);
    }
    if ($resource === 'produits' && in_array($method, ['POST', 'PUT', 'PATCH'], true)) {
        if ($method === 'POST') {
            $threshold = filter_var($body['min_stock_level'] ?? 5, FILTER_VALIDATE_INT);
            if ($threshold === false || $threshold < 0) JsonResponse::error('Le seuil d’alerte doit être un entier positif ou nul.', 422);
            $body['min_stock_level'] = $threshold;
        }
        if ($method === 'POST' || array_key_exists('unite_de_mesure', $body)) {
            $unitId = (int) ($body['unite_de_mesure'] ?? 0);
            $unitCheck = AlbaStock\Core\Database::connection()->prepare('SELECT unite_mesure_id FROM unites_mesure WHERE unite_mesure_id = ? AND entreprise_id = ? LIMIT 1');
            $unitCheck->bind_param('ii', $unitId, $enterpriseId);
            $unitCheck->execute();
            if (!$unitCheck->get_result()->fetch_assoc()) JsonResponse::error('Choisissez une unité de mesure de votre entreprise.', 422);
            $body['unite_de_mesure'] = $unitId;
        }
        if ($method === 'POST' || array_key_exists('monais', $body)) {
            $currencyCode = trim((string) ($body['monais'] ?? ''));
            if ($currencyCode === '') {
                JsonResponse::error('Choisissez la monnaie du prix du produit.', 422);
            }
            // N'accepte qu'une monnaie créée par le super administrateur.
            $currencyStatement = AlbaStock\Core\Database::connection()->prepare('SELECT type_monais FROM tb_monais WHERE type_monais = ? LIMIT 1');
            $currencyStatement->bind_param('s', $currencyCode);
            $currencyStatement->execute();
            if (!$currencyStatement->get_result()->fetch_assoc()) {
                JsonResponse::error('La monnaie choisie n’existe pas dans la liste des monnaies autorisées.', 422);
            }
            $body['monais'] = $currencyCode;
        }
    }
    if ($resource === 'users' && $method === 'POST') {
        JsonResponse::error('Utilisez l’action create-user pour créer un utilisateur avec un mot de passe sécurisé.', 405);
    }
    if ($resource === 'caisses' && in_array($method, ['POST', 'PUT', 'PATCH'], true)) {
        JsonResponse::error('Ouvrez ou clôturez une caisse avec les actions dédiées afin de vérifier son mode, sa monnaie et son statut.', 405);
    }
    if ($resource === 'produits' && $method === 'POST') {
        AlbaStock\Core\Database::connection()->begin_transaction();
        $productCreationTransaction = true;
    }
    if ($method === 'GET' && !$id && isset($_GET['page'])) {
        $page = max(1, (int) $_GET['page']);
        $perPage = min(100, max(1, (int) ($_GET['per_page'] ?? 10)));
        $pageResult = $repository->paginate($enterpriseId, in_array($resource, $branchScopedResources, true) ? $branchId : null, $page, $perPage);
        JsonResponse::send(['success' => true, 'data' => $pageResult['rows'], 'pagination' => $pageResult['pagination']]);
    }
    $result = match ($method) {
        'GET' => $id ? $repository->find($enterpriseId, $id, in_array($resource, $branchScopedResources, true) ? $branchId : null) : $repository->all($enterpriseId, $branchId),
        'POST' => ['id' => $repository->create($enterpriseId, $body)],
        'PUT', 'PATCH' => $id ? ['updated' => $repository->update($enterpriseId, $id, $body, in_array($resource, $branchScopedResources, true) ? $branchId : null)] : JsonResponse::error('Identifiant requis.', 422),
        'DELETE' => $id ? ['deleted' => $repository->delete($enterpriseId, $id, in_array($resource, $branchScopedResources, true) ? $branchId : null)] : JsonResponse::error('Identifiant requis.', 422),
        default => JsonResponse::error('Méthode HTTP non supportée.', 405),
    };
    if ($resource === 'produits' && $method === 'POST') {
        // Associe le nouveau produit à la succursale de session sans demander ce choix au formulaire.
        $assignedBranchId = (int) ($authenticatedUser['succursale_id'] ?? 0);
        $productId = (int) $result['id'];
        $db = AlbaStock\Core\Database::connection();
        if ($assignedBranchId > 0) $branches = [$assignedBranchId];
        else {
            $branchQuery = $db->prepare('SELECT succursale_id FROM succursales WHERE entreprise_id = ?');
            $branchQuery->bind_param('i', $enterpriseId);
            $branchQuery->execute();
            $branches = array_map('intval', array_column($branchQuery->get_result()->fetch_all(MYSQLI_ASSOC), 'succursale_id'));
        }
        $threshold = (int) $body['min_stock_level'];
        $stock = $db->prepare('INSERT INTO stocks (entreprise_id, succursale_id, produit_id, quantity, min_stock_level) VALUES (?, ?, ?, 0, ?)');
        foreach ($branches as $branch) { $stock->bind_param('iiii', $enterpriseId, $branch, $productId, $threshold); $stock->execute(); }
    }
    if ($productCreationTransaction || $mainBranchTransaction) AlbaStock\Core\Database::connection()->commit();
    JsonResponse::send(['success' => true, 'data' => $result]);
} catch (Throwable $exception) {
    if ($mainBranchTransaction) {
        try { AlbaStock\Core\Database::connection()->rollback(); } catch (Throwable) { /* La transaction de succursale mère a pu être annulée par MySQL. */ }
    }
    if ($productCreationTransaction) {
        try { AlbaStock\Core\Database::connection()->rollback(); } catch (Throwable) { /* La transaction a pu déjà être annulée par MySQL. */ }
    }
    // Les erreurs de permission deviennent 403; l'API renvoie toujours une réponse JSON structurée.
    $message = $exception->getMessage();
    $status = str_contains($message, 'Authentification requise') ? 401
        : (str_contains($message, 'Permission requise') || str_contains($message, 'Accès refusé') || str_contains($message, 'Accès limité') ? 403 : 500);
    JsonResponse::error($message, $status);
}
