<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;

final class ExchangeRateService
{
    public function __construct(private readonly mysqli $db)
    {
    }

    public function list(int $enterpriseId): array
    {
        $referenceQuery = $this->db->prepare('SELECT monais FROM entreprise_monnaie_reference WHERE entreprise_id=? LIMIT 1');
        $referenceQuery->bind_param('i', $enterpriseId);
        $referenceQuery->execute();
        $referenceCurrency = $referenceQuery->get_result()->fetch_assoc()['monais'] ?? null;

        $currencyResult = $this->db->query('SELECT type_monais,description FROM tb_monais ORDER BY type_monais');
        $ratesQuery = $this->db->prepare('SELECT monais,taux_vers_reference,updated_at FROM taux_change WHERE entreprise_id=? ORDER BY monais');
        $ratesQuery->bind_param('i', $enterpriseId);
        $ratesQuery->execute();
        $rates = $ratesQuery->get_result()->fetch_all(MYSQLI_ASSOC);
        if ($referenceCurrency !== null) {
            array_unshift($rates, ['monais' => $referenceCurrency, 'taux_vers_reference' => '1.0000000000', 'updated_at' => null]);
        }
        return [
            'reference_currency' => $referenceCurrency,
            'currencies' => $currencyResult->fetch_all(MYSQLI_ASSOC),
            'rates' => $rates,
        ];
    }

    public function setReference(int $enterpriseId, string $currency): void
    {
        $currency = $this->validateCurrency($currency);
        $this->db->begin_transaction();
        try {
            $currentQuery = $this->db->prepare('SELECT monais FROM entreprise_monnaie_reference WHERE entreprise_id=? LIMIT 1 FOR UPDATE');
            $currentQuery->bind_param('i', $enterpriseId);
            $currentQuery->execute();
            $current = $currentQuery->get_result()->fetch_assoc();
            if ($current && (string) $current['monais'] !== $currency) {
                $ratesQuery = $this->db->prepare('SELECT COUNT(*) AS total FROM taux_change WHERE entreprise_id=?');
                $ratesQuery->bind_param('i', $enterpriseId);
                $ratesQuery->execute();
                if ((int) ($ratesQuery->get_result()->fetch_assoc()['total'] ?? 0) > 0) {
                    throw new RuntimeException('Supprimez les taux de change enregistrés avant de changer la monnaie de référence.');
                }
                $update = $this->db->prepare('UPDATE entreprise_monnaie_reference SET monais=? WHERE entreprise_id=?');
                $update->bind_param('si', $currency, $enterpriseId);
                $update->execute();
            } elseif (!$current) {
                $insert = $this->db->prepare('INSERT INTO entreprise_monnaie_reference (entreprise_id,monais) VALUES (?,?)');
                $insert->bind_param('is', $enterpriseId, $currency);
                $insert->execute();
            }
            $this->db->commit();
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function deleteReference(int $enterpriseId): void
    {
        $this->db->begin_transaction();
        try {
            $referenceQuery = $this->db->prepare('SELECT monais FROM entreprise_monnaie_reference WHERE entreprise_id=? LIMIT 1 FOR UPDATE');
            $referenceQuery->bind_param('i', $enterpriseId);
            $referenceQuery->execute();
            if (!$referenceQuery->get_result()->fetch_assoc()) {
                throw new RuntimeException('Aucune monnaie de référence n’est configurée.');
            }

            $ratesQuery = $this->db->prepare('SELECT COUNT(*) AS total FROM taux_change WHERE entreprise_id=?');
            $ratesQuery->bind_param('i', $enterpriseId);
            $ratesQuery->execute();
            if ((int) ($ratesQuery->get_result()->fetch_assoc()['total'] ?? 0) > 0) {
                throw new RuntimeException('Supprimez d’abord les taux de change enregistrés avant de supprimer la monnaie de référence.');
            }

            $delete = $this->db->prepare('DELETE FROM entreprise_monnaie_reference WHERE entreprise_id=?');
            $delete->bind_param('i', $enterpriseId);
            $delete->execute();
            $this->db->commit();
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function saveRate(int $enterpriseId, string $currency, float $rate, int $userId, bool $updateOnly): void
    {
        $currency = $this->validateCurrency($currency);
        if (!is_finite($rate) || $rate <= 0 || $rate > 1000000000000) {
            throw new RuntimeException('Le taux doit être un nombre positif valide.');
        }
        $referenceCurrency = $this->referenceCurrency($enterpriseId);
        if ($referenceCurrency === null) {
            throw new RuntimeException('Choisissez d’abord la monnaie de référence de l’entreprise.');
        }
        if ($currency === $referenceCurrency) {
            throw new RuntimeException('La monnaie de référence a toujours un taux égal à 1 et ne peut pas être modifiée.');
        }

        $exists = $this->db->prepare('SELECT monais FROM taux_change WHERE entreprise_id=? AND monais=? LIMIT 1');
        $exists->bind_param('is', $enterpriseId, $currency);
        $exists->execute();
        $alreadyExists = (bool) $exists->get_result()->fetch_assoc();
        if ($updateOnly && !$alreadyExists) {
            throw new RuntimeException('Aucun taux de change n’existe pour cette monnaie.');
        }
        if (!$updateOnly && $alreadyExists) {
            throw new RuntimeException('Un taux de change existe déjà pour cette monnaie. Modifiez-le plutôt.');
        }

        if ($updateOnly) {
            $statement = $this->db->prepare('UPDATE taux_change SET taux_vers_reference=?,updated_by=?,updated_at=CURRENT_TIMESTAMP WHERE entreprise_id=? AND monais=?');
            $statement->bind_param('diis', $rate, $userId, $enterpriseId, $currency);
        } else {
            $statement = $this->db->prepare('INSERT INTO taux_change (entreprise_id,monais,taux_vers_reference,updated_by) VALUES (?,?,?,?)');
            $statement->bind_param('isdi', $enterpriseId, $currency, $rate, $userId);
        }
        $statement->execute();
    }

    public function deleteRate(int $enterpriseId, string $currency): void
    {
        $currency = $this->validateCurrency($currency);
        if ($currency === $this->referenceCurrency($enterpriseId)) {
            throw new RuntimeException('La monnaie de référence ne peut pas être supprimée.');
        }
        $statement = $this->db->prepare('DELETE FROM taux_change WHERE entreprise_id=? AND monais=?');
        $statement->bind_param('is', $enterpriseId, $currency);
        $statement->execute();
        if ($statement->affected_rows !== 1) {
            throw new RuntimeException('Aucun taux de change n’existe pour cette monnaie.');
        }
    }

    public function rateToReference(int $enterpriseId, string $currency): float
    {
        $currency = $this->validateCurrency($currency);
        if ($currency === $this->referenceCurrency($enterpriseId)) return 1.0;
        $statement = $this->db->prepare('SELECT taux_vers_reference FROM taux_change WHERE entreprise_id=? AND monais=? LIMIT 1');
        $statement->bind_param('is', $enterpriseId, $currency);
        $statement->execute();
        $rate = $statement->get_result()->fetch_assoc()['taux_vers_reference'] ?? null;
        if ($rate === null) {
            throw new RuntimeException('Aucun taux de change configuré pour la monnaie ' . $currency . '.');
        }
        return (float) $rate;
    }

    private function referenceCurrency(int $enterpriseId): ?string
    {
        $query = $this->db->prepare('SELECT monais FROM entreprise_monnaie_reference WHERE entreprise_id=? LIMIT 1');
        $query->bind_param('i', $enterpriseId);
        $query->execute();
        $currency = $query->get_result()->fetch_assoc()['monais'] ?? null;
        return $currency === null ? null : (string) $currency;
    }

    private function validateCurrency(string $currency): string
    {
        $currency = strtoupper(trim($currency));
        if ($currency === '' || strlen($currency) > 20) {
            throw new RuntimeException('Sélectionnez une monnaie valide.');
        }
        $query = $this->db->prepare('SELECT type_monais FROM tb_monais WHERE type_monais=? LIMIT 1');
        $query->bind_param('s', $currency);
        $query->execute();
        if (!$query->get_result()->fetch_assoc()) {
            throw new RuntimeException('Cette monnaie n’est pas disponible dans le catalogue.');
        }
        return $currency;
    }
}
