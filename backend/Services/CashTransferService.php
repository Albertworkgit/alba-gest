<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;

final class CashTransferService
{
    public function __construct(
        private readonly mysqli $db,
        private readonly ExchangeRateService $exchangeRates
    ) {
    }

    public function quote(int $enterpriseId, int $sourceCashId, int $targetCashId, float $amount, ?int $branchId): array
    {
        $this->validateRequest($sourceCashId, $targetCashId, $amount);
        $amount = round($amount, 2);
        if ($amount <= 0) throw new RuntimeException('Le montant doit être supérieur à zéro.');
        $boxes = $this->cashboxes($enterpriseId, $sourceCashId, $targetCashId, $branchId, false);
        return $this->calculate($enterpriseId, $boxes[$sourceCashId], $boxes[$targetCashId], $amount);
    }

    public function transfer(int $enterpriseId, int $userId, int $sourceCashId, int $targetCashId, float $amount, ?int $branchId): array
    {
        $this->validateRequest($sourceCashId, $targetCashId, $amount);
        $amount = round($amount, 2);
        if ($amount <= 0) throw new RuntimeException('Le montant doit être supérieur à zéro.');

        $this->db->begin_transaction();
        try {
            $boxes = $this->cashboxes($enterpriseId, $sourceCashId, $targetCashId, $branchId, true);
            $source = $boxes[$sourceCashId];
            $target = $boxes[$targetCashId];
            $quote = $this->calculate($enterpriseId, $source, $target, $amount);
            if ((float) $source['balance'] < $amount - 0.009) {
                throw new RuntimeException('Le solde de la caisse source est insuffisant.');
            }

            $sourceReason = sprintf(
                'Conversion vers caisse #%d : %s %s -> %s %s (taux %s)',
                $targetCashId,
                number_format($amount, 2, '.', ''),
                $source['currency'],
                number_format($quote['converted_amount'], 2, '.', ''),
                $target['currency'],
                number_format($quote['rate'], 10, '.', '')
            );
            $targetReason = sprintf(
                'Conversion depuis caisse #%d : %s %s -> %s %s (taux %s)',
                $sourceCashId,
                number_format($amount, 2, '.', ''),
                $source['currency'],
                number_format($quote['converted_amount'], 2, '.', ''),
                $target['currency'],
                number_format($quote['rate'], 10, '.', '')
            );
            $sourceMovementId = $this->insertMovement($enterpriseId, $userId, $source, 'SORTIE', $amount, $sourceReason);
            $targetMovementId = $this->insertMovement($enterpriseId, $userId, $target, 'ENTREE', $quote['converted_amount'], $targetReason);

            $link = $this->db->prepare('UPDATE mouvements_caisse SET reference_id=CASE mouvement_id WHEN ? THEN ? WHEN ? THEN ? END WHERE entreprise_id=? AND mouvement_id IN (?,?)');
            $link->bind_param('iiiiiii', $sourceMovementId, $targetMovementId, $targetMovementId, $sourceMovementId, $enterpriseId, $sourceMovementId, $targetMovementId);
            $link->execute();
            if ($link->affected_rows !== 2) throw new RuntimeException('Les mouvements liés du transfert n’ont pas pu être enregistrés.');

            $sourceDelta = -$amount;
            $this->updateBalance($enterpriseId, $sourceCashId, $sourceDelta);
            $this->updateBalance($enterpriseId, $targetCashId, $quote['converted_amount']);
            $this->db->commit();

            return [
                'source_mouvement_id' => $sourceMovementId,
                'target_mouvement_id' => $targetMovementId,
                'source_amount' => $amount,
                'source_currency' => $source['currency'],
                ...$quote,
            ];
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    private function validateRequest(int $sourceCashId, int $targetCashId, float $amount): void
    {
        if ($sourceCashId < 1 || $targetCashId < 1 || $sourceCashId === $targetCashId) {
            throw new RuntimeException('Sélectionnez deux caisses ouvertes différentes.');
        }
        if (!is_finite($amount) || $amount <= 0 || $amount > 9999999999999.99) {
            throw new RuntimeException('Saisissez un montant positif valide.');
        }
    }

    private function cashboxes(int $enterpriseId, int $sourceCashId, int $targetCashId, ?int $branchId, bool $lock): array
    {
        $sql = "SELECT c.caisse_id,c.succursale_id,c.mode_paiement_id,c.banque_id,c.montant AS balance,t.code AS currency FROM caisses c JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id WHERE c.entreprise_id=? AND c.caisse_id IN (?,?) AND c.statut='OUVERTE'";
        if ($branchId !== null) $sql .= ' AND c.succursale_id=?';
        $sql .= ' ORDER BY c.caisse_id' . ($lock ? ' FOR UPDATE' : '');
        $query = $this->db->prepare($sql);
        if ($branchId === null) $query->bind_param('iii', $enterpriseId, $sourceCashId, $targetCashId);
        else $query->bind_param('iiii', $enterpriseId, $sourceCashId, $targetCashId, $branchId);
        $query->execute();
        $boxes = [];
        foreach ($query->get_result()->fetch_all(MYSQLI_ASSOC) as $box) {
            $boxes[(int) $box['caisse_id']] = $box;
        }
        if (count($boxes) !== 2) throw new RuntimeException('Les deux caisses doivent être ouvertes et accessibles.');
        if ($boxes[$sourceCashId]['currency'] === $boxes[$targetCashId]['currency']) {
            throw new RuntimeException('Choisissez deux caisses de monnaies différentes pour effectuer une conversion.');
        }
        return $boxes;
    }

    private function calculate(int $enterpriseId, array $source, array $target, float $amount): array
    {
        $sourceRate = $this->exchangeRates->rateToReference($enterpriseId, (string) $source['currency']);
        $targetRate = $this->exchangeRates->rateToReference($enterpriseId, (string) $target['currency']);
        $rate = $sourceRate / $targetRate;
        $convertedAmount = round($amount * $rate, 2);
        if (!is_finite($convertedAmount) || $convertedAmount <= 0 || $convertedAmount > 9999999999999.99) {
            throw new RuntimeException('Le montant converti est nul ou dépasse la limite autorisée.');
        }
        return [
            'converted_amount' => $convertedAmount,
            'target_currency' => (string) $target['currency'],
            'rate' => $rate,
            'reference_amount' => round($amount * $sourceRate, 2),
        ];
    }

    private function insertMovement(int $enterpriseId, int $userId, array $cashbox, string $type, float $amount, string $reason): int
    {
        $cashId = (int) $cashbox['caisse_id'];
        $modeId = (int) $cashbox['mode_paiement_id'];
        $bankId = $cashbox['banque_id'] !== null ? (int) $cashbox['banque_id'] : null;
        $query = $this->db->prepare('INSERT INTO mouvements_caisse (entreprise_id,caisse_id,user_id,mode_paiement_id,banque_id,type,amount,reason) VALUES (?,?,?,?,?,?,?,?)');
        $query->bind_param('iiiiisds', $enterpriseId, $cashId, $userId, $modeId, $bankId, $type, $amount, $reason);
        $query->execute();
        return (int) $this->db->insert_id;
    }

    private function updateBalance(int $enterpriseId, int $cashId, float $delta): void
    {
        $query = $this->db->prepare("UPDATE caisses SET montant=montant+? WHERE caisse_id=? AND entreprise_id=? AND statut='OUVERTE'");
        $query->bind_param('dii', $delta, $cashId, $enterpriseId);
        $query->execute();
        if ($query->affected_rows !== 1) throw new RuntimeException('Le solde d’une caisse n’a pas pu être mis à jour.');
    }
}
