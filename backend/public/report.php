<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Services/ReportService.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Core/AuthGuard.php';

use AlbaStock\Core\Database;
use AlbaStock\Services\ReportService;
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
$db = Database::connection();
$companyQuery = $db->prepare('SELECT name, logo FROM entreprises WHERE entreprise_id = ? LIMIT 1');
$companyQuery->bind_param('i', $enterpriseId);
$companyQuery->execute();
$company = $companyQuery->get_result()->fetch_assoc() ?: ['name' => 'ALBA-GEST', 'logo' => null];
$companyName = htmlspecialchars((string) $company['name'], ENT_QUOTES, 'UTF-8');
$logoUrl = !empty($company['logo']) ? '../../' . ltrim((string) $company['logo'], '/') : '';
$rows = (new ReportService($db))->sales($enterpriseId, $branchId);
$showBranchColumn = $branchId === null;
$currencies = [];
$reportTotals = [];
foreach ($rows as $row) {
    foreach (array_merge($row['currency_totals'], $row['paid_currency_totals']) as $balance) {
        $currency = strtoupper(trim((string) ($balance['monais'] ?? '')));
        if ($currency === '') {
            continue;
        }
        $currencies[$currency] = true;
        $reportTotals[$currency] ??= ['total' => 0.0, 'paid' => 0.0];
    }
    foreach ($row['currency_totals'] as $balance) {
        $currency = strtoupper(trim((string) $balance['monais']));
        if ($currency !== '') {
            $reportTotals[$currency]['total'] += (float) $balance['total_amount'];
        }
    }
    foreach ($row['paid_currency_totals'] as $balance) {
        $currency = strtoupper(trim((string) $balance['monais']));
        if ($currency !== '') {
            $reportTotals[$currency]['paid'] += (float) $balance['amount_paid'];
        }
    }
}
$currencies = array_keys($currencies);
sort($currencies);
$statusLabels = [
    'PENDING' => 'En attente',
    'PAID' => 'Payée',
    'PARTIAL' => 'Partiellement payée',
    'CANCELLED' => 'Annulée',
];
header('Content-Type: text/html; charset=utf-8');
?>
<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Rapport des ventes - <?= $companyName ?></title>
    <style>
        body{font-family:Arial,sans-serif;margin:32px;color:#1d2926}
        .report-heading{display:flex;align-items:center;gap:18px;border-bottom:2px solid #147c70;padding-bottom:12px}
        h1{color:#147c70}
        .company-logo{max-width:100px;max-height:80px;object-fit:contain}
        table{width:100%;border-collapse:collapse;margin-top:24px}
        th,td{border:1px solid #dfe7e2;padding:9px;text-align:left}
        th{background:#e5f2ed}
        @media print{button{display:none}}
    </style>
</head>
<body>
    <button onclick="window.print()">Imprimer</button>
    <header class="report-heading">
        <?php if ($logoUrl !== ''): ?><img class="company-logo" src="<?= htmlspecialchars($logoUrl, ENT_QUOTES, 'UTF-8') ?>" alt="Logo <?= $companyName ?>"><?php endif; ?>
        <div><h1>Rapport des ventes</h1><p><?= $companyName ?> · <?= date('d/m/Y H:i') ?></p></div>
    </header>
    <table>
        <thead><tr><th>Facture</th><th>Date</th><?php if ($showBranchColumn): ?><th>Succursale</th><?php endif; ?><th>Client</th><th>Vendeur</th><th>Produits</th><?php foreach ($currencies as $currency): ?><th>Total · <?= htmlspecialchars($currency, ENT_QUOTES, 'UTF-8') ?></th><th>Payé · <?= htmlspecialchars($currency, ENT_QUOTES, 'UTF-8') ?></th><?php endforeach; ?><th>Statut</th></tr></thead>
        <tbody>
            <?php foreach ($rows as $row): ?>
                <tr>
                    <td><?= htmlspecialchars((string) $row['invoice_no'], ENT_QUOTES, 'UTF-8') ?></td>
                    <td><?= htmlspecialchars((string) $row['sale_date'], ENT_QUOTES, 'UTF-8') ?></td>
                    <?php if ($showBranchColumn): ?><td><?= htmlspecialchars((string) $row['succursale'], ENT_QUOTES, 'UTF-8') ?></td><?php endif; ?>
                    <td><?= htmlspecialchars((string) ($row['client'] ?? '-'), ENT_QUOTES, 'UTF-8') ?></td>
                    <td><?= htmlspecialchars((string) ($row['seller_name'] ?? '-'), ENT_QUOTES, 'UTF-8') ?></td>
                    <td><?= htmlspecialchars((string) ($row['product_names'] ?: '—'), ENT_QUOTES, 'UTF-8') ?></td>
                    <?php
                    $saleTotals = [];
                    foreach ($row['currency_totals'] as $balance) {
                        $saleTotals[strtoupper(trim((string) $balance['monais']))] = (float) $balance['total_amount'];
                    }
                    $salePayments = [];
                    foreach ($row['paid_currency_totals'] as $balance) {
                        $salePayments[strtoupper(trim((string) $balance['monais']))] = (float) $balance['amount_paid'];
                    }
                    ?>
                    <?php foreach ($currencies as $currency): ?>
                        <td><?= isset($saleTotals[$currency]) ? htmlspecialchars(number_format($saleTotals[$currency], 2, ',', ' ') . ' ' . $currency, ENT_QUOTES, 'UTF-8') : '—' ?></td>
                        <td><?= isset($salePayments[$currency]) ? htmlspecialchars(number_format($salePayments[$currency], 2, ',', ' ') . ' ' . $currency, ENT_QUOTES, 'UTF-8') : '—' ?></td>
                    <?php endforeach; ?>
                    <td><?= htmlspecialchars($statusLabels[(string) $row['status']] ?? (string) $row['status'], ENT_QUOTES, 'UTF-8') ?></td>
                </tr>
            <?php endforeach; ?>
            <?php if ($rows !== []): ?>
                <tr><th colspan="<?= 5 + ($showBranchColumn ? 1 : 0) ?>">TOTAL</th>
                    <?php foreach ($currencies as $currency): ?>
                        <th><?= htmlspecialchars(number_format($reportTotals[$currency]['total'], 2, ',', ' ') . ' ' . $currency, ENT_QUOTES, 'UTF-8') ?></th>
                        <th><?= htmlspecialchars(number_format($reportTotals[$currency]['paid'], 2, ',', ' ') . ' ' . $currency, ENT_QUOTES, 'UTF-8') ?></th>
                    <?php endforeach; ?>
                    <th></th>
                </tr>
            <?php endif; ?>
        </tbody>
    </table>
</body>
</html>
