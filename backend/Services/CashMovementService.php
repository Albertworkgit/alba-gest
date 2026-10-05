<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;

final class CashMovementService
{
    public function __construct(private readonly mysqli $db)
    {
    }

    public function requestCancellation(int $enterpriseId, int $userId, int $movementId, string $reason, ?int $branchId): int
    {
        $reason = trim($reason);
        if ($movementId < 1 || $reason === '' || mb_strlen($reason, 'UTF-8') > 500) {
            throw new RuntimeException('Une opération valide et un motif de 1 à 500 caractères sont requis.');
        }

        $this->db->begin_transaction();
        try {
            $sql = 'SELECT m.type,m.amount,m.reference_id,c.statut FROM mouvements_caisse m JOIN caisses c ON c.caisse_id=m.caisse_id AND c.entreprise_id=m.entreprise_id WHERE m.entreprise_id=? AND m.mouvement_id=?';
            if ($branchId !== null) $sql .= ' AND c.succursale_id=?';
            $sql .= ' LIMIT 1 FOR UPDATE';
            $movement = $this->db->prepare($sql);
            if ($branchId === null) $movement->bind_param('ii', $enterpriseId, $movementId);
            else $movement->bind_param('iii', $enterpriseId, $movementId, $branchId);
            $movement->execute();
            $row = $movement->get_result()->fetch_assoc();
            if (!$row) throw new RuntimeException('Opération de caisse introuvable dans votre périmètre.');
            if ($row['reference_id'] !== null) throw new RuntimeException('Les paiements liés à une vente ou à un fournisseur doivent être annulés depuis leur document.');
            if ($row['statut'] !== 'OUVERTE') throw new RuntimeException('Seules les opérations d’une caisse ouverte peuvent faire l’objet d’une demande.');

            $previous = $this->db->prepare('SELECT statut FROM demandes_annulation_mouvements_caisse WHERE entreprise_id=? AND mouvement_id=? AND statut IN (\'EN_ATTENTE\',\'APPROUVEE\') ORDER BY demande_id DESC LIMIT 1');
            $previous->bind_param('ii', $enterpriseId, $movementId);
            $previous->execute();
            $previousRow = $previous->get_result()->fetch_assoc();
            if ($previousRow) {
                $message = $previousRow['statut'] === 'APPROUVEE' ? 'Cette opération est déjà annulée.' : 'Une demande est déjà en attente pour cette opération.';
                throw new RuntimeException($message);
            }

            $status = 'EN_ATTENTE';
            $insert = $this->db->prepare('INSERT INTO demandes_annulation_mouvements_caisse (entreprise_id,mouvement_id,demandeur_id,motif,statut) VALUES (?,?,?,?,?)');
            $insert->bind_param('iiiss', $enterpriseId, $movementId, $userId, $reason, $status);
            $insert->execute();
            $requestId = (int) $this->db->insert_id;
            $this->db->commit();
            return $requestId;
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function cancellationRequests(int $enterpriseId): array
    {
        $query = $this->db->prepare('SELECT r.demande_id,r.mouvement_id,r.motif,r.created_at,m.movement_date,m.type,m.amount,m.reason,c.name AS cash_name,t.code AS currency,u.full_name AS demandeur FROM demandes_annulation_mouvements_caisse r JOIN mouvements_caisse m ON m.mouvement_id=r.mouvement_id AND m.entreprise_id=r.entreprise_id JOIN caisses c ON c.caisse_id=m.caisse_id AND c.entreprise_id=m.entreprise_id JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id LEFT JOIN users u ON u.user_id=r.demandeur_id WHERE r.entreprise_id=? AND r.statut=\'EN_ATTENTE\' ORDER BY r.created_at,r.demande_id');
        $query->bind_param('i', $enterpriseId);
        $query->execute();
        return $query->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    public function decideCancellation(int $enterpriseId, int $adminId, int $requestId, bool $approve, string $decisionReason = ''): void
    {
        $decisionReason = trim($decisionReason);
        if ($requestId < 1 || mb_strlen($decisionReason, 'UTF-8') > 500) throw new RuntimeException('Décision ou demande invalide.');

        $this->db->begin_transaction();
        try {
            $request = $this->db->prepare('SELECT mouvement_id FROM demandes_annulation_mouvements_caisse WHERE entreprise_id=? AND demande_id=? AND statut=\'EN_ATTENTE\' LIMIT 1 FOR UPDATE');
            $request->bind_param('ii', $enterpriseId, $requestId);
            $request->execute();
            $requestRow = $request->get_result()->fetch_assoc();
            if (!$requestRow) throw new RuntimeException('Cette demande est introuvable ou a déjà été traitée.');

            $movementId = (int) $requestRow['mouvement_id'];
            $movement = $this->db->prepare('SELECT m.caisse_id,m.mode_paiement_id,m.banque_id,m.type,m.amount,m.reference_id,c.montant,c.statut AS caisse_statut FROM mouvements_caisse m JOIN caisses c ON c.caisse_id=m.caisse_id AND c.entreprise_id=m.entreprise_id WHERE m.entreprise_id=? AND m.mouvement_id=? LIMIT 1 FOR UPDATE');
            $movement->bind_param('ii', $enterpriseId, $movementId);
            $movement->execute();
            $original = $movement->get_result()->fetch_assoc();
            if (!$original || $original['reference_id'] !== null) throw new RuntimeException('Cette opération n’est plus annulable individuellement.');
            if ($approve && $original['caisse_statut'] !== 'OUVERTE') throw new RuntimeException('La caisse est fermée; ouvrez-la avant d’approuver l’annulation.');

            $compensationId = null;
            if ($approve) {
                $amount = (float) $original['amount'];
                $reversalType = $original['type'] === 'ENTREE' ? 'SORTIE' : 'ENTREE';
                if ($reversalType === 'SORTIE' && (float) $original['montant'] < $amount - 0.009) {
                    throw new RuntimeException('Le solde de la caisse est insuffisant pour compenser cette entrée.');
                }

                $cashId = (int) $original['caisse_id'];
                $modeId = $original['mode_paiement_id'] !== null ? (int) $original['mode_paiement_id'] : null;
                $bankId = $original['banque_id'] !== null ? (int) $original['banque_id'] : null;
                $bankReference = null;
                $reason = 'Annulation approuvée de l’opération #' . $movementId;
                $insert = $this->db->prepare('INSERT INTO mouvements_caisse (entreprise_id,caisse_id,user_id,mode_paiement_id,banque_id,bank_reference,type,amount,reason,reference_id) VALUES (?,?,?,?,?,?,?,?,?,?)');
                $insert->bind_param('iiiiissdsi', $enterpriseId, $cashId, $adminId, $modeId, $bankId, $bankReference, $reversalType, $amount, $reason, $movementId);
                $insert->execute();
                $compensationId = (int) $this->db->insert_id;

                $delta = $reversalType === 'ENTREE' ? $amount : -$amount;
                $balance = $this->db->prepare('UPDATE caisses SET montant=montant+? WHERE caisse_id=? AND entreprise_id=? AND statut=\'OUVERTE\'');
                $balance->bind_param('dii', $delta, $cashId, $enterpriseId);
                $balance->execute();
                if ($balance->affected_rows !== 1) throw new RuntimeException('Le solde de la caisse n’a pas pu être ajusté.');
            }

            $status = $approve ? 'APPROUVEE' : 'REFUSEE';
            $update = $this->db->prepare('UPDATE demandes_annulation_mouvements_caisse SET statut=?,decision_par=?,motif_decision=?,mouvement_compensation_id=?,decision_at=NOW() WHERE entreprise_id=? AND demande_id=? AND statut=\'EN_ATTENTE\'');
            $update->bind_param('sisiii', $status, $adminId, $decisionReason, $compensationId, $enterpriseId, $requestId);
            $update->execute();
            if ($update->affected_rows !== 1) throw new RuntimeException('La décision n’a pas pu être enregistrée.');
            $this->db->commit();
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }
}