<?php
declare(strict_types=1);

require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Services/StockService.php';

use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Core\Database;
use AlbaStock\Core\JsonResponse;
use AlbaStock\Services\StockService;

try {
    // Authentifie l'appel et récupère l'entreprise depuis la session, jamais depuis le formulaire.
    $actor = AuthGuard::requireAuthenticated();
    $enterpriseId = AuthGuard::enterpriseId($actor);
    $branchId = isset($_GET['succursale_id']) ? (int) $_GET['succursale_id'] : null;
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    $service = new StockService(Database::connection());

    if ($method === 'GET') {
        // La consultation du catalogue stock est indépendante du droit de modification.
        Authorization::requirePermission($actor, 'voir_stock');
        $branchId = Authorization::branchId($actor, $branchId);
        if (isset($_GET['page'])) {
            $page = max(1, (int) $_GET['page']);
            $perPage = min(100, max(1, (int) ($_GET['per_page'] ?? 10)));
            $pageResult = $service->list($enterpriseId, $branchId, $page, $perPage);
            JsonResponse::send(['success' => true, 'data' => $pageResult['rows'], 'pagination' => $pageResult['pagination']]);
        }
        JsonResponse::send(['success' => true, 'data' => $service->list($enterpriseId, $branchId)]);
    }

    if ($method !== 'POST') JsonResponse::error('Méthode HTTP non supportée.', 405);
    // Les ajustements exigent un droit distinct de la simple consultation.
    Authorization::requirePermission($actor, 'modifier_stock');
    $body = json_decode((string) file_get_contents('php://input'), true);
    if (!is_array($body)) JsonResponse::error('Corps JSON invalide.', 400);

    // Un utilisateur de succursale ne peut ni choisir ni modifier une autre succursale.
    $requestedBranchId = isset($body['succursale_id']) ? (int) $body['succursale_id'] : $branchId;
    $branchId = Authorization::branchId($actor, $requestedBranchId);
    if ($branchId === null) JsonResponse::error('La succursale est obligatoire.', 422);

    $result = $service->adjust(
        $enterpriseId,
        $branchId,
        (int) ($body['produit_id'] ?? 0),
        (string) ($body['operation'] ?? ''),
        (int) ($body['quantity'] ?? -1),
        array_key_exists('min_stock_level', $body) ? (int) $body['min_stock_level'] : null,
        (int) ($actor['id'] ?? 0)
    );
    JsonResponse::send(['success' => true, 'data' => $result]);
} catch (\RuntimeException $exception) {
    // Renvoie un statut HTTP adapté pour distinguer session, permission et saisie invalide.
    $message = $exception->getMessage();
    $status = str_contains($message, 'Authentification requise') ? 401
        : (str_contains($message, 'Permission requise') || str_contains($message, 'Accès refusé') || str_contains($message, 'Accès limité') ? 403 : 422);
    JsonResponse::error($message, $status);
} catch (\Throwable $exception) {
    JsonResponse::error($exception->getMessage(), 500);
}
