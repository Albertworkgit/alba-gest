<?php
declare(strict_types=1);

namespace AlbaStock\Services;

require_once __DIR__ . '/../Core/PhoneNumberNormalizer.php';

use AlbaStock\Core\PhoneNumberNormalizer;
use mysqli;
use RuntimeException;

final class CashDebtService
{
    public function __construct(private readonly mysqli $db)
    {
    }

    public function create(int $enterpriseId, int $userId, array $body, ?int $allowedBranchId): int
    {
        $cashId = (int) ($body['caisse_id'] ?? 0);
        $beneficiary = trim((string) ($body['beneficiaire'] ?? ''));
        $phone = PhoneNumberNormalizer::normalize((string) ($body['telephone'] ?? ''));
        $description = trim((string) ($body['description'] ?? ''));
        $amount = round((float) ($body['montant'] ?? 0), 2);
        $bankId = (int) ($body['banque_id'] ?? 0);
        $bankReference = trim((string) ($body['bank_reference'] ?? ''));

        if ($cashId < 1 || $beneficiary === '' || mb_strlen($beneficiary, 'UTF-8') > 120
            || mb_strlen($phone, 'UTF-8') > 43 || mb_strlen($description, 'UTF-8') > 500
            || !is_finite($amount) || $amount <= 0) {
            throw new RuntimeException('Caisse, bénéficiaire et montant positif requis. Vérifiez aussi les longueurs des champs.');
        }
        if (mb_strlen($bankReference, 'UTF-8') > 120) {
            throw new RuntimeException('La référence bancaire est limitée à 120 caractères.');
        }

        $this->db->begin_transaction();
        try {
            $cashQuery = $this->db->prepare("SELECT c.succursale_id,c.mode_paiement_id,c.banque_id,c.montant AS solde,m.code AS mode_code,t.code AS monais FROM caisses c JOIN modes_paiement m ON m.mode_paiement_id=c.mode_paiement_id JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id WHERE c.caisse_id=? AND c.entreprise_id=? AND c.statut='OUVERTE' FOR UPDATE");
            $cashQuery->bind_param('ii', $cashId, $enterpriseId);
            $cashQuery->execute();
            $cash = $cashQuery->get_result()->fetch_assoc();
            if (!$cash) throw new RuntimeException('Choisissez une caisse ouverte.');
            if ($allowedBranchId !== null && (int) $cash['succursale_id'] !== $allowedBranchId) {
                throw new RuntimeException('Accès limité à votre succursale.');
            }
            if ((float) $cash['solde'] < $amount - 0.009) {
                throw new RuntimeException('Solde insuffisant dans la caisse pour accorder ce prêt.');
            }
            $nullableBankId = null;
            $nullableBankReference = null;
            if ($cash['mode_code'] === 'BANK') {
                if ($bankId < 1 || $bankReference === '') {
                    throw new RuntimeException('Choisissez la banque et saisissez la référence de l’opération bancaire.');
                }
                if ($cash['banque_id'] !== null && (int) $cash['banque_id'] !== $bankId) {
                    throw new RuntimeException('La banque ne correspond pas à celle associée à cette caisse.');
                }
                $bank = $this->db->prepare('SELECT banque_id FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1');
                $bank->bind_param('ii', $bankId, $enterpriseId);
                $bank->execute();
                if (!$bank->get_result()->fetch_assoc()) throw new RuntimeException('La banque choisie est indisponible.');
                $nullableBankId = $bankId;
                $nullableBankReference = $bankReference;
            } elseif ($bankId > 0 || $bankReference !== '') {
                throw new RuntimeException('La banque et sa référence ne peuvent être utilisées qu’avec une caisse bancaire.');
            }

            $phoneValue = $phone !== '' ? $phone : null;
            $descriptionValue = $description !== '' ? $description : null;
            $insertDebt = $this->db->prepare('INSERT INTO dettes_caisse (entreprise_id,succursale_id,caisse_id,user_id,beneficiaire,telephone,description,monais,montant) VALUES (?,?,?,?,?,?,?,?,?)');
            $branchId = (int) $cash['succursale_id'];
            $currency = (string) $cash['monais'];
            $insertDebt->bind_param('iiiissssd', $enterpriseId, $branchId, $cashId, $userId, $beneficiary, $phoneValue, $descriptionValue, $currency, $amount);
            $insertDebt->execute();
            $debtId = (int) $this->db->insert_id;

            $movementType = 'SORTIE';
            $operation = 'PRET';
            $reason = 'Prêt accordé à ' . $beneficiary;
            $modeId = (int) $cash['mode_paiement_id'];
            $movement = $this->db->prepare('INSERT INTO mouvements_caisse (entreprise_id,caisse_id,user_id,mode_paiement_id,banque_id,bank_reference,type,amount,reason,dette_id,dette_operation) VALUES (?,?,?,?,?,?,?,?,?,?,?)');
            $movement->bind_param('iiiiissdsis', $enterpriseId, $cashId, $userId, $modeId, $nullableBankId, $nullableBankReference, $movementType, $amount, $reason, $debtId, $operation);
            $movement->execute();
            $movementId = (int) $this->db->insert_id;

            $link = $this->db->prepare('UPDATE dettes_caisse SET mouvement_id=? WHERE dette_id=? AND entreprise_id=?');
            $link->bind_param('iii', $movementId, $debtId, $enterpriseId);
            $link->execute();

            $delta = -$amount;
            $balance = $this->db->prepare("UPDATE caisses SET montant=montant+? WHERE caisse_id=? AND entreprise_id=? AND statut='OUVERTE'");
            $balance->bind_param('dii', $delta, $cashId, $enterpriseId);
            $balance->execute();
            if ($balance->affected_rows !== 1) throw new RuntimeException('Le solde de la caisse n’a pas pu être ajusté.');

            $this->db->commit();
            return $debtId;
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function pay(int $enterpriseId, int $userId, array $body, ?int $allowedBranchId): void
    {
        $debtId = (int) ($body['dette_id'] ?? 0);
        $cashId = (int) ($body['caisse_id'] ?? 0);
        $amount = round((float) ($body['montant'] ?? 0), 2);
        $receivedCurrency = strtoupper(trim((string) ($body['monais_recue'] ?? '')));
        $bankId = (int) ($body['banque_id'] ?? 0);
        $bankReference = trim((string) ($body['bank_reference'] ?? ''));

        if ($debtId < 1 || $cashId < 1 || $receivedCurrency === '' || !is_finite($amount) || $amount <= 0) {
            throw new RuntimeException('Dette, caisse, monnaie reçue et montant de remboursement positif requis.');
        }
        if (mb_strlen($bankReference, 'UTF-8') > 120) {
            throw new RuntimeException('La référence bancaire est limitée à 120 caractères.');
        }

        $this->db->begin_transaction();
        try {
            $debtQuery = $this->db->prepare('SELECT succursale_id,beneficiaire,monais,montant FROM dettes_caisse WHERE dette_id=? AND entreprise_id=? FOR UPDATE');
            $debtQuery->bind_param('ii', $debtId, $enterpriseId);
            $debtQuery->execute();
            $debt = $debtQuery->get_result()->fetch_assoc();
            if (!$debt) throw new RuntimeException('Dette introuvable dans votre entreprise.');
            if ($allowedBranchId !== null && (int) $debt['succursale_id'] !== $allowedBranchId) {
                throw new RuntimeException('Accès limité à votre succursale.');
            }
            $paidQuery = $this->db->prepare('SELECT COALESCE(SUM(montant),0) AS paye FROM paiements_dettes_caisse WHERE dette_id=? AND entreprise_id=?');
            $paidQuery->bind_param('ii', $debtId, $enterpriseId);
            $paidQuery->execute();
            $debt['paye'] = $paidQuery->get_result()->fetch_assoc()['paye'] ?? 0;
            $remaining = round((float) $debt['montant'] - (float) $debt['paye'], 2);
            if ($remaining <= 0) throw new RuntimeException('Cette dette est déjà entièrement remboursée.');

            $cashQuery = $this->db->prepare("SELECT c.succursale_id,c.mode_paiement_id,c.banque_id,c.montant AS solde,m.code AS mode_code,t.code AS monais FROM caisses c JOIN modes_paiement m ON m.mode_paiement_id=c.mode_paiement_id JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id WHERE c.caisse_id=? AND c.entreprise_id=? AND c.statut='OUVERTE' FOR UPDATE");
            $cashQuery->bind_param('ii', $cashId, $enterpriseId);
            $cashQuery->execute();
            $cash = $cashQuery->get_result()->fetch_assoc();
            if (!$cash) throw new RuntimeException('Choisissez une caisse ouverte.');
            if ((int) $cash['succursale_id'] !== (int) $debt['succursale_id']) {
                throw new RuntimeException('La caisse doit appartenir à la succursale où la dette a été enregistrée.');
            }
            if ((string) $cash['monais'] !== $receivedCurrency) throw new RuntimeException('La monnaie choisie ne correspond pas à celle de la caisse.');
            $exchangeRates = new ExchangeRateService($this->db);
            $appliedExchangeRate = $exchangeRates->rateToReference($enterpriseId, $receivedCurrency)
                / $exchangeRates->rateToReference($enterpriseId, (string) $debt['monais']);
            $amountApplied = round($amount * $appliedExchangeRate, 2);
            if ($amountApplied <= 0) throw new RuntimeException('Le montant converti est inférieur à la plus petite unité monétaire.');
            if ($amountApplied > $remaining + 0.009) {
                throw new RuntimeException('Le remboursement converti dépasse le solde restant de ' . $remaining . ' ' . $debt['monais'] . '.');
            }
            $cashBalance = round((float) $cash['solde'] + $amount, 2);
            if ($cashBalance > 9999999999999.99) throw new RuntimeException('Le solde de caisse dépasserait la capacité maximale autorisée.');

            $nullableBankId = null;
            $nullableBankReference = null;
            if ($cash['mode_code'] === 'BANK') {
                if ($bankId < 1 || $bankReference === '') {
                    throw new RuntimeException('Choisissez la banque et saisissez la référence de l’opération bancaire.');
                }
                if ($cash['banque_id'] !== null && (int) $cash['banque_id'] !== $bankId) {
                    throw new RuntimeException('La banque ne correspond pas à celle associée à cette caisse.');
                }
                $bank = $this->db->prepare('SELECT banque_id FROM banques WHERE banque_id=? AND entreprise_id=? AND is_active=1');
                $bank->bind_param('ii', $bankId, $enterpriseId);
                $bank->execute();
                if (!$bank->get_result()->fetch_assoc()) throw new RuntimeException('La banque choisie est indisponible.');
                $nullableBankId = $bankId;
                $nullableBankReference = $bankReference;
            } elseif ($bankId > 0 || $bankReference !== '') {
                throw new RuntimeException('La banque et sa référence ne peuvent être utilisées qu’avec une caisse bancaire.');
            }

            $movementType = 'ENTREE';
            $operation = 'REMBOURSEMENT';
            $reason = 'Remboursement de ' . $debt['beneficiaire'];
            $modeId = (int) $cash['mode_paiement_id'];
            $movement = $this->db->prepare('INSERT INTO mouvements_caisse (entreprise_id,caisse_id,user_id,mode_paiement_id,banque_id,bank_reference,type,amount,reason,dette_id,dette_operation) VALUES (?,?,?,?,?,?,?,?,?,?,?)');
            $movement->bind_param('iiiiissdsis', $enterpriseId, $cashId, $userId, $modeId, $nullableBankId, $nullableBankReference, $movementType, $amount, $reason, $debtId, $operation);
            $movement->execute();
            $movementId = (int) $this->db->insert_id;

            $payment = $this->db->prepare('INSERT INTO paiements_dettes_caisse (entreprise_id,dette_id,mouvement_id,montant,montant_recu,monais_recue,taux_change) VALUES (?,?,?,?,?,?,?)');
            $payment->bind_param('iiiddsd', $enterpriseId, $debtId, $movementId, $amountApplied, $amount, $receivedCurrency, $appliedExchangeRate);
            $payment->execute();

            $balance = $this->db->prepare("UPDATE caisses SET montant=? WHERE caisse_id=? AND entreprise_id=? AND statut='OUVERTE'");
            $balance->bind_param('dii', $cashBalance, $cashId, $enterpriseId);
            $balance->execute();
            if ($balance->affected_rows !== 1) throw new RuntimeException('Le solde de la caisse n’a pas pu être ajusté.');

            $this->db->commit();
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }
}
