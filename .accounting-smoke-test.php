<?php
declare(strict_types=1);

require_once __DIR__ . '/backend/Core/Database.php';
require_once __DIR__ . '/backend/Services/AccountingService.php';

use AlbaStock\Core\Database;
use AlbaStock\Services\AccountingService;

$db = Database::connection();
$enterpriseId = 6;
$userQuery = $db->prepare('SELECT user_id FROM users WHERE entreprise_id=? ORDER BY user_id LIMIT 1');
$userQuery->bind_param('i', $enterpriseId);
$userQuery->execute();
$userId = (int) ($userQuery->get_result()->fetch_assoc()['user_id'] ?? 0);
$currency = (string) ($db->query('SELECT type_monais FROM tb_monais ORDER BY type_monais LIMIT 1')->fetch_assoc()['type_monais'] ?? '');
if ($userId < 1 || $currency === '') throw new RuntimeException('Utilisateur de test ou monnaie introuvable.');

$suffix = strtoupper(bin2hex(random_bytes(4)));
$accountIds = [];
$entryId = 0;

try {
    $service = new AccountingService($db);
    $debitId = $service->createAccount($enterpriseId, [
        'code' => 'T' . $suffix . 'D',
        'intitule' => 'Test temporaire debit',
        'classe' => 1,
        'nature' => 'DEBIT',
    ]);
    $accountIds[] = $debitId;
    $creditId = $service->createAccount($enterpriseId, [
        'code' => 'T' . $suffix . 'C',
        'intitule' => 'Test temporaire credit',
        'classe' => 1,
        'nature' => 'CREDIT',
    ]);
    $accountIds[] = $creditId;

    $reference = 'TEST-' . $suffix;
    $date = date('Y-m-d');
    $entryId = $service->createEntry($enterpriseId, $userId, [
        'date_ecriture' => $date,
        'journal_code' => 'TST',
        'reference' => $reference,
        'libelle' => 'Test comptabilite automatise',
        'monnaie' => $currency,
        'lines' => [
            ['compte_id' => $debitId, 'libelle' => 'Debit test', 'debit' => 125.50, 'credit' => 0],
            ['compte_id' => $creditId, 'libelle' => 'Credit test', 'debit' => 0, 'credit' => 125.50],
        ],
    ]);

    $entries = $service->entries($enterpriseId, $date, $date, $currency);
    $found = false;
    foreach ($entries as $entry) {
        if ($entry['reference'] === $reference) $found = true;
    }
    if (!$found) throw new RuntimeException('Ecriture temporaire absente du journal.');

    foreach (['journal', 'grand-livre', 'balance', 'bilan', 'resultat', 'flux-tresorerie', 'annexes'] as $type) {
        $accountFilter = $type === 'grand-livre' ? $debitId : null;
        $service->report($enterpriseId, $type, $date, $date, $currency, $accountFilter);
    }
    echo "AccountingService smoke passed: accounts, balanced entry, journal, and 7 reports.\n";
} finally {
    if ($entryId > 0) {
        $delete = $db->prepare('DELETE FROM ecritures_comptables WHERE ecriture_id=? AND entreprise_id=?');
        $delete->bind_param('ii', $entryId, $enterpriseId);
        $delete->execute();
    }
    foreach ($accountIds as $accountId) {
        $delete = $db->prepare('DELETE FROM comptes_comptables WHERE compte_id=? AND entreprise_id=?');
        $delete->bind_param('ii', $accountId, $enterpriseId);
        $delete->execute();
    }
}