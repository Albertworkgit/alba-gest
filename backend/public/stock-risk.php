<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Services/StockRiskService.php';

use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Core\Database;
use AlbaStock\Core\JsonResponse;
use AlbaStock\Services\StockRiskService;

try {
    $actor = AuthGuard::requireAuthenticated();
    if (($actor['type'] ?? '') !== 'user') JsonResponse::error('Action réservée aux utilisateurs d’entreprise.', 403);
    Authorization::requireModule($actor, 'stock_risk');
    Authorization::requirePermission($actor, 'voir_risques_stock');

    $service = new StockRiskService(Database::connection());
    $method = $_SERVER['REQUEST_METHOD'];
    $action = (string) ($_GET['action'] ?? 'dashboard');
    $requestedBranch = isset($_GET['succursale_id']) ? (int) $_GET['succursale_id'] : null;

    if ($method === 'GET' && $action === 'dashboard') {
        JsonResponse::send(['success' => true, 'data' => $service->dashboard($actor, $requestedBranch)]);
    }
    if ($method === 'GET' && $action === 'orders') {
        Authorization::requireAnyPermission($actor, ['voir_risques_stock', 'voir_approvisionnements', 'creer_approvisionnements']);
        JsonResponse::send(['success' => true, 'data' => $service->orders($actor, $requestedBranch)]);
    }
    if ($method === 'POST' && $action === 'orders') {
        Authorization::requirePermission($actor, 'creer_approvisionnements');
        $body = json_decode((string) file_get_contents('php://input'), true);
        if (!is_array($body) || !is_array($body['items'] ?? null)) JsonResponse::error('Contenu du bon prévisionnel invalide.', 400);
        $result = $service->createOrder($actor, (int) ($body['succursale_id'] ?? 0), $body['items']);
        JsonResponse::send(['success' => true, 'data' => $result], 201);
    }
    if ($method === 'POST' && $action === 'transmit') {
        Authorization::requirePermission($actor, 'creer_approvisionnements');
        $body = json_decode((string) file_get_contents('php://input'), true);
        if (!is_array($body)) JsonResponse::error('Contenu du bon prévisionnel invalide.', 400);
        $result = $service->transmitOrder($actor, (int) ($body['bon_previsionnel_id'] ?? 0));
        JsonResponse::send(['success' => true, 'data' => $result]);
    }
    JsonResponse::error('Action de gestion des risques inconnue.', 404);
} catch (Throwable $exception) {
    $message = $exception->getMessage();
    $status = str_contains($message, 'Authentification requise') ? 401
        : (str_contains($message, 'Permission requise') || str_contains($message, 'Accès refusé') || str_contains($message, 'Accès limité') ? 403
            : ($exception instanceof mysqli_sql_exception ? 500 : 422));
    JsonResponse::error(JsonResponse::messageFor($exception), $status);
}
