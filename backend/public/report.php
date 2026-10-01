<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Services/ReportService.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Core/AuthGuard.php';

use AlbaStock\Core\Database;
use AlbaStock\Services\ReportService;
use AlbaStock\Core\Session;
use AlbaStock\Core\Authorization;
use AlbaStock\Core\AuthGuard;

try {
	$user = AuthGuard::requireAuthenticated();
	Authorization::requirePermission($user, 'voir_rapports');
} catch (\RuntimeException $exception) {
	$message = $exception->getMessage();
	http_response_code(str_contains($message, 'Authentification requise') ? 401 : 403);
	header('Content-Type: text/plain; charset=utf-8');
	echo htmlspecialchars($message, ENT_QUOTES, 'UTF-8');
	exit;
}
$enterpriseId = AuthGuard::enterpriseId($user);
$branchId = isset($_GET['succursale_id']) ? (int) $_GET['succursale_id'] : null;
$branchId = Authorization::branchId($user, $branchId);
$companyQuery = Database::connection()->prepare('SELECT name, logo FROM entreprises WHERE entreprise_id = ? LIMIT 1');
$companyQuery->bind_param('i', $enterpriseId);
$companyQuery->execute();
$company = $companyQuery->get_result()->fetch_assoc() ?: ['name' => 'ALBA-STOCK', 'logo' => null];
$companyName = htmlspecialchars((string) $company['name'], ENT_QUOTES, 'UTF-8');
$logoUrl = !empty($company['logo']) ? '../../' . ltrim((string) $company['logo'], '/') : '';
$rows = (new ReportService(Database::connection()))->sales($enterpriseId, $branchId);
$showBranchColumn = $branchId === null;
header('Content-Type: text/html; charset=utf-8');
?>
<!doctype html><html lang="fr"><head><meta charset="utf-8"><title>Rapport des ventes - <?= $companyName ?></title><style>body{font-family:Arial,sans-serif;margin:32px;color:#1d2926}.report-heading{display:flex;align-items:center;gap:18px;border-bottom:2px solid #147c70;padding-bottom:12px}h1{color:#147c70}.company-logo{max-width:100px;max-height:80px;object-fit:contain}table{width:100%;border-collapse:collapse;margin-top:24px}th,td{border:1px solid #dfe7e2;padding:9px;text-align:left}th{background:#e5f2ed}@media print{button{display:none}}</style></head><body><button onclick="window.print()">Imprimer</button><header class="report-heading"><?php if ($logoUrl !== ''): ?><img class="company-logo" src="<?= htmlspecialchars($logoUrl, ENT_QUOTES, 'UTF-8') ?>" alt="Logo <?= $companyName ?>"><?php endif; ?><div><h1>Rapport des ventes</h1><p><?= $companyName ?> · <?= date('d/m/Y H:i') ?></p></div></header><table><thead><tr><th>Facture</th><th>Date</th><?php if ($showBranchColumn): ?><th>Succursale</th><?php endif; ?><th>Client</th><th>Total</th><th>Statut</th></tr></thead><tbody><?php foreach ($rows as $row): ?><tr><td><?= htmlspecialchars((string) $row['invoice_no']) ?></td><td><?= htmlspecialchars((string) $row['sale_date']) ?></td><?php if ($showBranchColumn): ?><td><?= htmlspecialchars((string) $row['succursale']) ?></td><?php endif; ?><td><?= htmlspecialchars((string) ($row['client'] ?? '-')) ?></td><td><?= htmlspecialchars((string) $row['total_amount']) ?></td><td><?= htmlspecialchars((string) $row['status']) ?></td></tr><?php endforeach; ?></tbody></table></body></html>
