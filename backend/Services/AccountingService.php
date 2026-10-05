<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use DateTimeImmutable;
use mysqli;
use mysqli_stmt;
use RuntimeException;

final class AccountingService
{
    public function __construct(private readonly mysqli $db)
    {
    }

    public function accounts(int $enterpriseId): array
    {
        $query = $this->db->prepare('SELECT c.compte_id,c.code,c.intitule,c.classe,c.nature,c.parent_id,p.code AS parent_code,p.intitule AS parent_intitule,c.is_system,c.is_active FROM comptes_comptables c LEFT JOIN comptes_comptables p ON p.compte_id=c.parent_id AND p.entreprise_id=c.entreprise_id WHERE c.entreprise_id=? ORDER BY c.code');
        $query->bind_param('i', $enterpriseId);
        $query->execute();
        return $query->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function createAccount(int $enterpriseId, array $data): int
    {
        $code = strtoupper(trim((string) ($data['code'] ?? '')));
        $title = trim((string) ($data['intitule'] ?? ''));
        $class = (int) ($data['classe'] ?? 0);
        $nature = strtoupper(trim((string) ($data['nature'] ?? '')));
        $parentId = isset($data['parent_id']) && $data['parent_id'] !== '' ? (int) $data['parent_id'] : null;
        if (!preg_match('/^[A-Z0-9.-]{1,20}$/', $code) || $title === '' || mb_strlen($title, 'UTF-8') > 160 || $class < 1 || $class > 9 || !in_array($nature, ['DEBIT', 'CREDIT'], true)) {
            throw new RuntimeException('Code, intitulé, classe (1 à 9) et nature du compte sont obligatoires.');
        }
        if ($parentId !== null) $this->assertAccount($enterpriseId, $parentId, false);
        $insert = $this->db->prepare('INSERT INTO comptes_comptables (entreprise_id,code,intitule,classe,nature,parent_id) VALUES (?,?,?,?,?,?)');
        $insert->bind_param('issisi', $enterpriseId, $code, $title, $class, $nature, $parentId);
        $insert->execute();
        return (int) $this->db->insert_id;
    }

    public function updateAccount(int $enterpriseId, int $accountId, array $data): void
    {
        $title = trim((string) ($data['intitule'] ?? ''));
        $nature = strtoupper(trim((string) ($data['nature'] ?? '')));
        $active = !empty($data['is_active']) ? 1 : 0;
        if ($accountId < 1 || $title === '' || mb_strlen($title, 'UTF-8') > 160 || !in_array($nature, ['DEBIT', 'CREDIT'], true)) {
            throw new RuntimeException('Intitulé, nature et compte valides sont requis.');
        }
        $update = $this->db->prepare('UPDATE comptes_comptables SET intitule=?,nature=?,is_active=? WHERE compte_id=? AND entreprise_id=? AND is_system=0');
        $update->bind_param('ssiii', $title, $nature, $active, $accountId, $enterpriseId);
        $update->execute();
        if ($update->affected_rows === 0) {
            $this->assertAccount($enterpriseId, $accountId, false);
            $check = $this->db->prepare('SELECT is_system FROM comptes_comptables WHERE compte_id=? AND entreprise_id=?');
            $check->bind_param('ii', $accountId, $enterpriseId);
            $check->execute();
            if ((int) $check->get_result()->fetch_assoc()['is_system'] === 1) throw new RuntimeException('Un compte système ne peut pas être modifié.');
        }
    }

    public function deleteAccount(int $enterpriseId, int $accountId): void
    {
        if ($accountId < 1) throw new RuntimeException('Compte comptable invalide.');
        $account = $this->db->prepare('SELECT is_system FROM comptes_comptables WHERE compte_id=? AND entreprise_id=? LIMIT 1');
        $account->bind_param('ii', $accountId, $enterpriseId);
        $account->execute();
        $row = $account->get_result()->fetch_assoc();
        if (!$row) throw new RuntimeException('Compte comptable introuvable.');
        if ((int) $row['is_system'] === 1) throw new RuntimeException('Un compte système ne peut pas être supprimé.');

        $children = $this->db->prepare('SELECT compte_id FROM comptes_comptables WHERE entreprise_id=? AND parent_id=? LIMIT 1');
        $children->bind_param('ii', $enterpriseId, $accountId);
        $children->execute();
        if ($children->get_result()->fetch_assoc()) throw new RuntimeException('Ce compte possède des sous-comptes; réaffectez-les avant de le supprimer.');

        $usage = $this->db->prepare('SELECT ligne_id FROM lignes_ecritures_comptables WHERE entreprise_id=? AND compte_id=? LIMIT 1');
        $usage->bind_param('ii', $enterpriseId, $accountId);
        $usage->execute();
        if ($usage->get_result()->fetch_assoc()) throw new RuntimeException('Ce compte est utilisé dans des écritures et ne peut pas être supprimé.');

        $delete = $this->db->prepare('DELETE FROM comptes_comptables WHERE compte_id=? AND entreprise_id=? AND is_system=0');
        $delete->bind_param('ii', $accountId, $enterpriseId);
        $delete->execute();
        if ($delete->affected_rows !== 1) throw new RuntimeException('Suppression du compte impossible.');
    }

    public function createEntry(int $enterpriseId, int $userId, array $data): int
    {
        $date = trim((string) ($data['date_ecriture'] ?? ''));
        $journal = strtoupper(trim((string) ($data['journal_code'] ?? '')));
        $reference = trim((string) ($data['reference'] ?? ''));
        $label = trim((string) ($data['libelle'] ?? ''));
        $currency = strtoupper(trim((string) ($data['monnaie'] ?? '')));
        $lines = $data['lines'] ?? [];
        if (!$this->isDate($date) || !preg_match('/^[A-Z0-9_-]{1,12}$/', $journal) || $reference === '' || mb_strlen($reference, 'UTF-8') > 120 || $label === '' || mb_strlen($label, 'UTF-8') > 255 || $currency === '' || !is_array($lines) || count($lines) < 2) {
            throw new RuntimeException('Date, journal, référence, libellé, monnaie et au moins deux lignes sont requis.');
        }
        $this->assertCurrency($currency);

        $preparedLines = [];
        $debitTotal = 0.0;
        $creditTotal = 0.0;
        foreach ($lines as $line) {
            if (!is_array($line)) throw new RuntimeException('Une ligne d’écriture est invalide.');
            $accountId = (int) ($line['compte_id'] ?? 0);
            $lineLabel = trim((string) ($line['libelle'] ?? $label));
            $debit = round((float) ($line['debit'] ?? 0), 2);
            $credit = round((float) ($line['credit'] ?? 0), 2);
            if ($accountId < 1 || $lineLabel === '' || mb_strlen($lineLabel, 'UTF-8') > 255 || !is_finite($debit) || !is_finite($credit) || $debit < 0 || $credit < 0 || ($debit > 0 && $credit > 0) || ($debit === 0.0 && $credit === 0.0)) {
                throw new RuntimeException('Chaque ligne doit avoir un compte et un montant au débit ou au crédit.');
            }
            $this->assertAccount($enterpriseId, $accountId, true);
            $debitTotal = round($debitTotal + $debit, 2);
            $creditTotal = round($creditTotal + $credit, 2);
            $preparedLines[] = ['compte_id' => $accountId, 'libelle' => $lineLabel, 'debit' => $debit, 'credit' => $credit];
        }
        if ($debitTotal <= 0 || abs($debitTotal - $creditTotal) > 0.009) {
            throw new RuntimeException('L’écriture doit être équilibrée : le total débit doit égaler le total crédit.');
        }

        $this->db->begin_transaction();
        try {
            $status = 'VALIDEE';
            $entry = $this->db->prepare('INSERT INTO ecritures_comptables (entreprise_id,date_ecriture,journal_code,reference,libelle,monnaie,statut,user_id) VALUES (?,?,?,?,?,?,?,?)');
            $entry->bind_param('issssssi', $enterpriseId, $date, $journal, $reference, $label, $currency, $status, $userId);
            $entry->execute();
            $entryId = (int) $this->db->insert_id;
            $lineInsert = $this->db->prepare('INSERT INTO lignes_ecritures_comptables (entreprise_id,ecriture_id,compte_id,libelle,debit,credit) VALUES (?,?,?,?,?,?)');
            foreach ($preparedLines as $line) {
                $lineInsert->bind_param('iiisdd', $enterpriseId, $entryId, $line['compte_id'], $line['libelle'], $line['debit'], $line['credit']);
                $lineInsert->execute();
            }
            $this->db->commit();
            return $entryId;
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function entries(int $enterpriseId, string $from, string $to, string $currency): array
    {
        $this->validatePeriod($from, $to, $currency);
        $query = $this->db->prepare('SELECT e.ecriture_id,e.date_ecriture,e.journal_code,e.reference,e.libelle,e.monnaie,e.statut,u.full_name AS auteur,MAX(r.demande_id) AS annulation_demande_id,MAX(r.motif) AS annulation_motif,COUNT(l.ligne_id) AS line_count,SUM(l.debit) AS debit_total,SUM(l.credit) AS credit_total FROM ecritures_comptables e JOIN lignes_ecritures_comptables l ON l.ecriture_id=e.ecriture_id AND l.entreprise_id=e.entreprise_id LEFT JOIN users u ON u.user_id=e.user_id AND u.entreprise_id=e.entreprise_id LEFT JOIN demandes_annulation_ecritures r ON r.entreprise_id=e.entreprise_id AND r.ecriture_id=e.ecriture_id AND r.statut=\'EN_ATTENTE\' WHERE e.entreprise_id=? AND e.statut=\'VALIDEE\' AND e.date_ecriture BETWEEN ? AND ? AND e.monnaie=? GROUP BY e.ecriture_id ORDER BY e.date_ecriture DESC,e.ecriture_id DESC');
        $query->bind_param('isss', $enterpriseId, $from, $to, $currency);
        $query->execute();
        return $query->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function requestEntryCancellation(int $enterpriseId, int $userId, int $entryId, string $reason): int
    {
        $reason = trim($reason);
        if ($entryId < 1 || $reason === '' || mb_strlen($reason, 'UTF-8') > 500) {
            throw new RuntimeException('Une écriture valide et un motif de 1 à 500 caractères sont requis.');
        }

        $this->db->begin_transaction();
        try {
            $entry = $this->db->prepare('SELECT ecriture_id FROM ecritures_comptables WHERE entreprise_id=? AND ecriture_id=? AND statut=\'VALIDEE\' LIMIT 1 FOR UPDATE');
            $entry->bind_param('ii', $enterpriseId, $entryId);
            $entry->execute();
            if (!$entry->get_result()->fetch_assoc()) throw new RuntimeException('Cette écriture n’est pas disponible pour une demande d’annulation.');

            $pending = $this->db->prepare('SELECT demande_id FROM demandes_annulation_ecritures WHERE entreprise_id=? AND ecriture_id=? AND statut=\'EN_ATTENTE\' LIMIT 1');
            $pending->bind_param('ii', $enterpriseId, $entryId);
            $pending->execute();
            if ($pending->get_result()->fetch_assoc()) throw new RuntimeException('Une demande d’annulation est déjà en attente pour cette écriture.');

            $status = 'EN_ATTENTE';
            $insert = $this->db->prepare('INSERT INTO demandes_annulation_ecritures (entreprise_id,ecriture_id,demandeur_id,motif,statut) VALUES (?,?,?,?,?)');
            $insert->bind_param('iiiss', $enterpriseId, $entryId, $userId, $reason, $status);
            $insert->execute();
            $requestId = (int) $this->db->insert_id;
            $this->db->commit();
            return $requestId;
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function entryCancellationRequests(int $enterpriseId): array
    {
        $query = $this->db->prepare('SELECT r.demande_id,r.ecriture_id,r.motif,r.created_at,e.date_ecriture,e.journal_code,e.reference,e.libelle,e.monnaie,u.full_name AS demandeur FROM demandes_annulation_ecritures r JOIN ecritures_comptables e ON e.ecriture_id=r.ecriture_id AND e.entreprise_id=r.entreprise_id LEFT JOIN users u ON u.user_id=r.demandeur_id WHERE r.entreprise_id=? AND r.statut=\'EN_ATTENTE\' ORDER BY r.created_at,r.demande_id');
        $query->bind_param('i', $enterpriseId);
        $query->execute();
        return $query->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function decideEntryCancellation(int $enterpriseId, int $adminId, int $requestId, bool $approve, string $decisionReason = ''): void
    {
        $decisionReason = trim($decisionReason);
        if ($requestId < 1 || mb_strlen($decisionReason, 'UTF-8') > 500) throw new RuntimeException('Décision ou demande invalide.');

        $this->db->begin_transaction();
        try {
            $request = $this->db->prepare('SELECT ecriture_id FROM demandes_annulation_ecritures WHERE entreprise_id=? AND demande_id=? AND statut=\'EN_ATTENTE\' LIMIT 1 FOR UPDATE');
            $request->bind_param('ii', $enterpriseId, $requestId);
            $request->execute();
            $row = $request->get_result()->fetch_assoc();
            if (!$row) throw new RuntimeException('Cette demande est introuvable ou a déjà été traitée.');

            if ($approve) {
                $entryId = (int) $row['ecriture_id'];
                $cancel = $this->db->prepare('UPDATE ecritures_comptables SET statut=\'ANNULEE\' WHERE entreprise_id=? AND ecriture_id=? AND statut=\'VALIDEE\'');
                $cancel->bind_param('ii', $enterpriseId, $entryId);
                $cancel->execute();
                if ($cancel->affected_rows !== 1) throw new RuntimeException('L’écriture ne peut plus être annulée.');
            }

            $status = $approve ? 'APPROUVEE' : 'REFUSEE';
            $update = $this->db->prepare('UPDATE demandes_annulation_ecritures SET statut=?,decision_par=?,motif_decision=?,decision_at=NOW() WHERE entreprise_id=? AND demande_id=? AND statut=\'EN_ATTENTE\'');
            $update->bind_param('sisii', $status, $adminId, $decisionReason, $enterpriseId, $requestId);
            $update->execute();
            if ($update->affected_rows !== 1) throw new RuntimeException('La décision n’a pas pu être enregistrée.');
            $this->db->commit();
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function report(int $enterpriseId, string $type, string $from, string $to, string $currency, ?int $accountId = null): array
    {
        $allowedReports = ['journal', 'grand-livre', 'balance', 'bilan', 'resultat', 'flux-tresorerie', 'annexes'];
        if (!in_array($type, $allowedReports, true)) throw new RuntimeException('État comptable inconnu.');
        $this->validatePeriod($from, $to, $currency);
        if ($type === 'grand-livre') {
            if ($accountId === null || $accountId < 1) throw new RuntimeException('Sélectionnez un compte pour consulter le grand livre.');
            $this->assertAccount($enterpriseId, $accountId, false);
        }

        $queryFrom = $type === 'bilan' || $type === 'annexes' ? '0001-01-01' : $from;
        $rows = $this->reportRows($enterpriseId, $queryFrom, $to, $currency, $accountId);
        $summary = $this->accountSummary($rows);
        $reportData = match ($type) {
            'journal' => ['rows' => $rows, 'totals' => $this->totals($rows)],
            'grand-livre' => $this->ledgerReport($enterpriseId, $accountId, $from, $currency, $rows),
            'balance' => ['rows' => $this->trialBalance($enterpriseId, $summary, $from, $currency), 'totals' => $this->summaryTotals($summary)],
            'bilan' => ['rows' => array_values(array_filter($summary, static fn (array $row): bool => in_array((int) $row['classe'], [1, 2, 3, 4, 5], true))), 'totals' => $this->summaryTotals($summary)],
            'resultat' => $this->incomeStatement($summary),
            'flux-tresorerie' => $this->cashFlow($rows),
            'annexes' => ['rows' => $summary, 'totals' => $this->summaryTotals($summary)],
        };
        return ['type' => $type, 'date_debut' => $from, 'date_fin' => $to, 'monnaie' => $currency] + $reportData;
    }

    private function reportRows(int $enterpriseId, string $from, string $to, string $currency, ?int $accountId): array
    {
        $sql = 'SELECT e.ecriture_id,e.date_ecriture,e.journal_code,e.reference,e.libelle AS ecriture_libelle,e.monnaie,l.ligne_id,l.libelle,l.debit,l.credit,c.compte_id,c.code AS compte_code,c.intitule AS compte_intitule,c.classe,c.nature FROM ecritures_comptables e JOIN lignes_ecritures_comptables l ON l.ecriture_id=e.ecriture_id AND l.entreprise_id=e.entreprise_id JOIN comptes_comptables c ON c.compte_id=l.compte_id AND c.entreprise_id=l.entreprise_id WHERE e.entreprise_id=? AND e.statut=\'VALIDEE\' AND e.date_ecriture BETWEEN ? AND ? AND e.monnaie=?';
        $values = [$enterpriseId, $from, $to, $currency];
        $types = 'isss';
        if ($accountId !== null) {
            $sql .= ' AND c.compte_id=?';
            $values[] = $accountId;
            $types .= 'i';
        }
        $sql .= ' ORDER BY e.date_ecriture,e.journal_code,e.ecriture_id,l.ligne_id LIMIT 20001';
        $query = $this->db->prepare($sql);
        $this->bind($query, $types, $values);
        $query->execute();
        $rows = $query->get_result()->fetch_all(MYSQLI_ASSOC);
        if (count($rows) > 20000) throw new RuntimeException('La période contient plus de 20 000 lignes. Réduisez la période pour consulter cet état.');
        return $rows;
    }

    private function accountSummary(array $rows): array
    {
        $summary = [];
        foreach ($rows as $row) {
            $id = (int) $row['compte_id'];
            if (!isset($summary[$id])) {
                $summary[$id] = ['compte_id' => $id, 'code' => $row['compte_code'], 'intitule' => $row['compte_intitule'], 'classe' => (int) $row['classe'], 'nature' => $row['nature'], 'debit' => 0.0, 'credit' => 0.0];
            }
            $summary[$id]['debit'] = round($summary[$id]['debit'] + (float) $row['debit'], 2);
            $summary[$id]['credit'] = round($summary[$id]['credit'] + (float) $row['credit'], 2);
        }
        return array_values($summary);
    }

    private function trialBalance(int $enterpriseId, array $periodSummary, string $from, string $currency): array
    {
        $accounts = $this->accounts($enterpriseId);
        $summaryById = [];
        foreach ($periodSummary as $row) $summaryById[(int) $row['compte_id']] = $row;
        $openingQuery = $this->db->prepare('SELECT l.compte_id,SUM(l.debit) AS debit,SUM(l.credit) AS credit FROM ecritures_comptables e JOIN lignes_ecritures_comptables l ON l.ecriture_id=e.ecriture_id AND l.entreprise_id=e.entreprise_id WHERE e.entreprise_id=? AND e.statut=\'VALIDEE\' AND e.monnaie=? AND e.date_ecriture<? GROUP BY l.compte_id');
        $openingQuery->bind_param('iss', $enterpriseId, $currency, $from);
        $openingQuery->execute();
        $openingById = [];
        foreach ($openingQuery->get_result()->fetch_all(MYSQLI_ASSOC) as $row) $openingById[(int) $row['compte_id']] = $row;
        $result = [];
        foreach ($accounts as $account) {
            $id = (int) $account['compte_id'];
            $opening = $openingById[$id] ?? ['debit' => 0, 'credit' => 0];
            $period = $summaryById[$id] ?? ['debit' => 0, 'credit' => 0];
            $openingNet = round((float) $opening['debit'] - (float) $opening['credit'], 2);
            $movementDebit = (float) $period['debit'];
            $movementCredit = (float) $period['credit'];
            $closingNet = round($openingNet + $movementDebit - $movementCredit, 2);
            $result[] = $account + ['ouverture_debit' => max(0, $openingNet), 'ouverture_credit' => max(0, -$openingNet), 'debit_periode' => $movementDebit, 'credit_periode' => $movementCredit, 'solde_debit' => max(0, $closingNet), 'solde_credit' => max(0, -$closingNet)];
        }
        return $result;
    }

    private function ledgerReport(int $enterpriseId, int $accountId, string $from, string $currency, array $rows): array
    {
        $openingQuery = $this->db->prepare('SELECT COALESCE(SUM(l.debit),0) AS debit,COALESCE(SUM(l.credit),0) AS credit FROM ecritures_comptables e JOIN lignes_ecritures_comptables l ON l.ecriture_id=e.ecriture_id AND l.entreprise_id=e.entreprise_id WHERE e.entreprise_id=? AND l.compte_id=? AND e.statut=\'VALIDEE\' AND e.monnaie=? AND e.date_ecriture<?');
        $openingQuery->bind_param('iiss', $enterpriseId, $accountId, $currency, $from);
        $openingQuery->execute();
        $opening = $openingQuery->get_result()->fetch_assoc();
        $balance = round((float) $opening['debit'] - (float) $opening['credit'], 2);
        foreach ($rows as &$row) {
            $balance = round($balance + (float) $row['debit'] - (float) $row['credit'], 2);
            $row['solde_cumulatif'] = $balance;
        }
        unset($row);
        return ['ouverture' => $opening, 'rows' => $rows, 'totals' => $this->totals($rows), 'solde_cloture' => $balance];
    }

    private function incomeStatement(array $summary): array
    {
        $expenses = array_values(array_filter($summary, static fn (array $row): bool => $row['classe'] === 6));
        $income = array_values(array_filter($summary, static fn (array $row): bool => $row['classe'] === 7));
        $expenseTotal = array_sum(array_map(static fn (array $row): float => max(0, (float) $row['debit'] - (float) $row['credit']), $expenses));
        $incomeTotal = array_sum(array_map(static fn (array $row): float => max(0, (float) $row['credit'] - (float) $row['debit']), $income));
        return ['charges' => $expenses, 'produits' => $income, 'total_charges' => round($expenseTotal, 2), 'total_produits' => round($incomeTotal, 2), 'resultat_net' => round($incomeTotal - $expenseTotal, 2)];
    }

    private function cashFlow(array $rows): array
    {
        $cashRows = array_values(array_filter($rows, static fn (array $row): bool => (int) $row['classe'] === 5));
        $inflows = array_sum(array_map(static fn (array $row): float => (float) $row['debit'], $cashRows));
        $outflows = array_sum(array_map(static fn (array $row): float => (float) $row['credit'], $cashRows));
        return ['rows' => $cashRows, 'total_entrees' => round($inflows, 2), 'total_sorties' => round($outflows, 2), 'variation_nette' => round($inflows - $outflows, 2)];
    }

    private function totals(array $rows): array
    {
        return ['debit' => round(array_sum(array_map(static fn (array $row): float => (float) $row['debit'], $rows)), 2), 'credit' => round(array_sum(array_map(static fn (array $row): float => (float) $row['credit'], $rows)), 2)];
    }

    private function summaryTotals(array $rows): array
    {
        return ['debit' => round(array_sum(array_column($rows, 'debit')), 2), 'credit' => round(array_sum(array_column($rows, 'credit')), 2)];
    }

    private function assertAccount(int $enterpriseId, int $accountId, bool $requireActive): void
    {
        $sql = 'SELECT compte_id FROM comptes_comptables WHERE compte_id=? AND entreprise_id=?' . ($requireActive ? ' AND is_active=1' : '') . ' LIMIT 1';
        $query = $this->db->prepare($sql);
        $query->bind_param('ii', $accountId, $enterpriseId);
        $query->execute();
        if (!$query->get_result()->fetch_assoc()) throw new RuntimeException('Compte comptable introuvable, inactif ou étranger à votre entreprise.');
    }

    private function assertCurrency(string $currency): void
    {
        $query = $this->db->prepare('SELECT type_monais FROM tb_monais WHERE type_monais=? LIMIT 1');
        $query->bind_param('s', $currency);
        $query->execute();
        if (!$query->get_result()->fetch_assoc()) throw new RuntimeException('Monnaie comptable inconnue.');
    }

    private function validatePeriod(string $from, string $to, string $currency): void
    {
        if (!$this->isDate($from) || !$this->isDate($to) || $from > $to || $currency === '') throw new RuntimeException('Période ou monnaie comptable invalide.');
        $this->assertCurrency($currency);
    }

    private function isDate(string $date): bool
    {
        $parsed = DateTimeImmutable::createFromFormat('!Y-m-d', $date);
        return $parsed !== false && $parsed->format('Y-m-d') === $date;
    }

    private function bind(mysqli_stmt $statement, string $types, array &$values): void
    {
        $references = [$types];
        foreach ($values as &$value) $references[] = &$value;
        $statement->bind_param(...$references);
    }
}