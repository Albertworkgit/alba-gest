<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;

final class ProcurementService
{
    // Reçoit la connexion mysqli déjà ouverte par le noyau de l'application.
    public function __construct(private readonly mysqli $db)
    {
    }

    // Crée un achat et ajoute ses produits au stock de la succursale.
    public function createPurchase(array $actor, array $data): int
    {
        // Récupère et normalise les champs envoyés par le formulaire.
        $enterpriseId = (int) $actor['entreprise_id'];
        $branchId = (int) ($data['succursale_id'] ?? $actor['succursale_id'] ?? 0);
        if ($branchId < 1) {
            // Un compte de l'entreprise mère utilise automatiquement la première succursale créée.
            $defaultBranch = $this->db->prepare('SELECT succursale_id FROM succursales WHERE entreprise_id = ? ORDER BY est_sucursal_mere DESC, succursale_id ASC LIMIT 1');
            $defaultBranch->bind_param('i', $enterpriseId);
            $defaultBranch->execute();
            $defaultBranchRow = $defaultBranch->get_result()->fetch_assoc();
            $branchId = (int) ($defaultBranchRow['succursale_id'] ?? 0);
        }
        $supplierId = isset($data['fournisseur_id']) && $data['fournisseur_id'] !== '' ? (int) $data['fournisseur_id'] : null;
        $productId = (int) ($data['produit_id'] ?? 0);
        $userId = (int) $actor['id'];
        $purchaseNo = trim((string) ($data['purchase_no'] ?? ''));
        $quantity = (int) ($data['quantity'] ?? 0);
        $unitCost = (float) ($data['unit_cost'] ?? 0);
        $movementType = strtoupper((string) ($data['movement_type'] ?? 'IN'));
        $unitCostMode = strtoupper((string) ($data['unit_cost_mode'] ?? 'PRODUCT'));
        $exitReason = trim((string) ($data['motif_sortie'] ?? ''));
        $status = (string) ($data['status'] ?? 'RECEIVED');
        $expirationDate = trim((string) ($data['date_expiration'] ?? ''));

        // Vérifie les valeurs indispensables avant d'ouvrir la transaction.
        if ($branchId < 1) throw new RuntimeException('Créez une succursale avant de créer un approvisionnement pour l’entreprise mère.');
        if ($productId < 1 || $purchaseNo === '' || $quantity < 1 || $unitCost < 0) {
            throw new RuntimeException('Produit, référence et quantité sont obligatoires.');
        }
        if (!in_array($status, ['PENDING', 'RECEIVED', 'CANCELLED'], true)) {
            throw new RuntimeException('Statut d’approvisionnement invalide.');
        }
        if (!in_array($movementType, ['IN', 'OUT'], true)) {
            throw new RuntimeException('Choisissez une entrée ou une sortie de stock valide.');
        }
        if ($movementType !== 'OUT') $exitReason = '';
        if ($movementType === 'OUT') {
            if ($exitReason === '') throw new RuntimeException('Indiquez le motif de la sortie de stock.');
            $supplierId = null;
            $unitCost = 0;
        } elseif (!in_array($unitCostMode, ['PRODUCT', 'CUSTOM'], true)) {
            throw new RuntimeException('Choisissez le coût enregistré du produit ou un autre coût.');
        }

        // Vérifie que la succursale, le fournisseur et le produit appartiennent à l'entreprise.
        $check = $this->db->prepare('SELECT (SELECT COUNT(*) FROM succursales WHERE succursale_id = ? AND entreprise_id = ?) AS branch_ok, (SELECT COUNT(*) FROM produits WHERE produit_id = ? AND entreprise_id = ?) AS product_ok');
        $check->bind_param('iiii', $branchId, $enterpriseId, $productId, $enterpriseId);
        $check->execute();
        $ownership = $check->get_result()->fetch_assoc();
        if (!$ownership || !$ownership['branch_ok'] || !$ownership['product_ok']) {
            throw new RuntimeException('Une ressource ne correspond pas à votre entreprise.');
        }
        $product = $this->db->prepare('SELECT est_perisable, cost_price, monais FROM produits WHERE produit_id = ? AND entreprise_id = ? AND is_active = 1 LIMIT 1');
        $product->bind_param('ii', $productId, $enterpriseId);
        $product->execute();
        $productRow = $product->get_result()->fetch_assoc();
        if (!$productRow) throw new RuntimeException('Produit introuvable ou inactif.');
        $isPerishable = (int) $productRow['est_perisable'] === 1;
        if ($isPerishable && $movementType === 'IN') {
            $validExpiration = preg_match('/^\d{4}-\d{2}-\d{2}$/', $expirationDate) === 1
                && checkdate((int) substr($expirationDate, 5, 2), (int) substr($expirationDate, 8, 2), (int) substr($expirationDate, 0, 4));
            if (!$validExpiration) throw new RuntimeException('La date d’expiration est obligatoire pour l’entrée de ce produit périssable.');
            if ($expirationDate < date('Y-m-d')) throw new RuntimeException('La date d’expiration de l’entrée doit être aujourd’hui ou ultérieure.');
        }
        if ($movementType === 'IN') {
            $savedCost = (float) $productRow['cost_price'];
            if ($unitCostMode === 'PRODUCT') {
                if ($savedCost === 0.0) throw new RuntimeException('Le coût enregistré du produit est nul. Choisissez un coût d’entrée spécifique.');
                $unitCost = $savedCost;
            } elseif ($savedCost === 0.0 && $unitCost <= 0) {
                throw new RuntimeException('Saisissez un coût d’entrée supérieur à zéro pour ce produit.');
            }
        }
        if ($supplierId !== null) {
            $supplier = $this->db->prepare('SELECT fournisseur_id FROM fournisseurs WHERE fournisseur_id = ? AND entreprise_id = ? AND (succursale_id IS NULL OR succursale_id = ?) LIMIT 1');
            $supplier->bind_param('iii', $supplierId, $enterpriseId, $branchId);
            $supplier->execute();
            if (!$supplier->get_result()->fetch_assoc()) throw new RuntimeException('Le fournisseur ne correspond pas à votre entreprise.');
        }

        // Garantit que l'achat et la mise à jour du stock restent atomiques.
        $this->db->begin_transaction();
        try {
            $lotAllocations = [];
            if ($isPerishable && $movementType === 'OUT' && $status === 'RECEIVED') {
                $lotsQuery = $this->db->prepare('SELECT d.achat_detail_id, d.quantity, d.quantity_out, d.date_expiration FROM achat_details d JOIN achats a ON a.achat_id = d.achat_id AND a.entreprise_id = d.entreprise_id WHERE d.entreprise_id = ? AND d.produit_id = ? AND a.succursale_id = ? AND a.movement_type = \'IN\' AND a.status = \'RECEIVED\' AND d.date_expiration IS NOT NULL AND d.quantity > d.quantity_out ORDER BY d.date_expiration ASC, d.achat_detail_id ASC FOR UPDATE');
                $lotsQuery->bind_param('iii', $enterpriseId, $productId, $branchId);
                $lotsQuery->execute();
                $remainingToAllocate = $quantity;
                foreach ($lotsQuery->get_result()->fetch_all(MYSQLI_ASSOC) as $lot) {
                    $lotRemaining = (int) $lot['quantity'] - (int) $lot['quantity_out'];
                    $allocated = min($remainingToAllocate, $lotRemaining);
                    if ($allocated > 0) {
                        $lotAllocations[] = ['lot_detail_id' => (int) $lot['achat_detail_id'], 'quantity' => $allocated];
                        $remainingToAllocate -= $allocated;
                    }
                    if ($remainingToAllocate === 0) break;
                }
                if ($remainingToAllocate > 0) throw new RuntimeException('La quantité demandée dépasse le stock disponible dans les lots périssables de cette succursale.');
            }
            $total = $movementType === 'IN' ? $quantity * $unitCost : 0;
            $currency = $movementType === 'IN' ? (string) $productRow['monais'] : null;
            if ($supplierId === null) {
            $purchase = $this->db->prepare('INSERT INTO achats (entreprise_id, succursale_id, fournisseur_id, user_id, purchase_no, total_amount, monais, movement_type, motif_sortie, status, validation_date) VALUES (?, ?, NULL, ?, ?, ?, ?, ?, ?, ?, IF(? = \'RECEIVED\', NOW(), NULL))');
                $purchase->bind_param('iiisdsssss', $enterpriseId, $branchId, $userId, $purchaseNo, $total, $currency, $movementType, $exitReason, $status, $status);
            } else {
                $purchase = $this->db->prepare('INSERT INTO achats (entreprise_id, succursale_id, fournisseur_id, user_id, purchase_no, total_amount, monais, movement_type, motif_sortie, status, validation_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, IF(? = \'RECEIVED\', NOW(), NULL))');
                $purchase->bind_param('iiiisdsssss', $enterpriseId, $branchId, $supplierId, $userId, $purchaseNo, $total, $currency, $movementType, $exitReason, $status, $status);
            }
            $purchase->execute();
            $purchaseId = (int) $this->db->insert_id;

            $detailExpiration = $isPerishable && $movementType === 'IN' ? $expirationDate : null;
            $detail = $this->db->prepare('INSERT INTO achat_details (entreprise_id, achat_id, produit_id, quantity, date_expiration, unit_cost, subtotal) VALUES (?, ?, ?, ?, ?, ?, ?)');
            $detail->bind_param('iiiisdd', $enterpriseId, $purchaseId, $productId, $quantity, $detailExpiration, $unitCost, $total);
            $detail->execute();
            $purchaseDetailId = (int) $this->db->insert_id;

            if ($status === 'RECEIVED') {
                $stockBeforeQuery = $this->db->prepare('SELECT quantity FROM stocks WHERE entreprise_id = ? AND succursale_id = ? AND produit_id = ? FOR UPDATE');
                $stockBeforeQuery->bind_param('iii', $enterpriseId, $branchId, $productId);
                $stockBeforeQuery->execute();
                $stockBeforeRow = $stockBeforeQuery->get_result()->fetch_assoc();
                $quantityBefore = (int) ($stockBeforeRow['quantity'] ?? 0);
                if ($movementType === 'IN') {
                    $stock = $this->db->prepare('INSERT INTO stocks (entreprise_id, succursale_id, produit_id, quantity) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)');
                    $stock->bind_param('iiii', $enterpriseId, $branchId, $productId, $quantity);
                    $stock->execute();
                } else {
                    $stock = $this->db->prepare('UPDATE stocks SET quantity = quantity - ? WHERE entreprise_id = ? AND succursale_id = ? AND produit_id = ? AND quantity >= ?');
                    $stock->bind_param('iiiii', $quantity, $enterpriseId, $branchId, $productId, $quantity);
                    $stock->execute();
                    if ($stock->affected_rows !== 1) throw new RuntimeException('Stock insuffisant pour effectuer cette sortie.');
                    foreach ($lotAllocations as $allocationRow) {
                        $allocatedQuantity = $allocationRow['quantity'];
                        $lotDetailId = $allocationRow['lot_detail_id'];
                        $updateLot = $this->db->prepare('UPDATE achat_details SET quantity_out = quantity_out + ? WHERE achat_detail_id = ? AND entreprise_id = ? AND quantity - quantity_out >= ?');
                        $updateLot->bind_param('iiii', $allocatedQuantity, $lotDetailId, $enterpriseId, $allocatedQuantity);
                        $updateLot->execute();
                        if ($updateLot->affected_rows !== 1) throw new RuntimeException('Le lot a été modifié par une autre opération. Réessayez.');
                        $allocationStatement = $this->db->prepare('INSERT INTO achat_detail_sorties (entreprise_id, sortie_detail_id, lot_detail_id, quantity) VALUES (?, ?, ?, ?)');
                        $allocationStatement->bind_param('iiii', $enterpriseId, $purchaseDetailId, $lotDetailId, $allocatedQuantity);
                        $allocationStatement->execute();
                    }
                }
                $quantityAfter = $movementType === 'IN' ? $quantityBefore + $quantity : $quantityBefore - $quantity;
                $ledgerType = $movementType === 'IN' ? 'ENTREE' : 'SORTIE';
                $ledgerNote = $movementType === 'OUT' ? $exitReason : 'Bon d’approvisionnement ' . $purchaseNo;
                $ledger = $this->db->prepare('INSERT INTO mouvements_stock (entreprise_id, succursale_id, produit_id, user_id, movement_type, quantity_before, quantity_moved, quantity_after, reference_type, reference_id, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
                $referenceType = $movementType === 'OUT' ? 'SORTIE_STOCK' : 'APPROVISIONNEMENT';
                $ledger->bind_param('iiiisiiisis', $enterpriseId, $branchId, $productId, $userId, $ledgerType, $quantityBefore, $quantity, $quantityAfter, $referenceType, $purchaseId, $ledgerNote);
                $ledger->execute();
            }

            $this->db->commit();
            return $purchaseId;
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    // fonction pour mettre à jour le statut d'un approvisionnement existant
    public function updatePurchaseStatus(array $actor, int $purchaseId, string $newStatus): void
    {
        if (!in_array($newStatus, ['PENDING', 'RECEIVED', 'CANCELLED'], true)) throw new RuntimeException('Statut invalide.');
        $enterpriseId = (int) $actor['entreprise_id'];
        $this->db->begin_transaction();
        try {
            $query = $this->db->prepare('SELECT succursale_id, user_id, movement_type, status, validation_date FROM achats WHERE achat_id = ? AND entreprise_id = ? LIMIT 1 FOR UPDATE');
            $query->bind_param('ii', $purchaseId, $enterpriseId); $query->execute(); $purchase = $query->get_result()->fetch_assoc();
            if (!$purchase) throw new RuntimeException('Approvisionnement introuvable.');
            if ((int)($actor['succursale_id'] ?? 0) > 0 && (int)$actor['succursale_id'] !== (int)$purchase['succursale_id']) throw new RuntimeException('Accès limité à une autre succursale.');
            if ($purchase['status'] === $newStatus) { $this->db->commit(); return; }
            if ($purchase['status'] === 'RECEIVED' && $newStatus === 'CANCELLED') {
                if (empty($purchase['validation_date']) || time() - strtotime((string)$purchase['validation_date']) >= 172800) throw new RuntimeException('Un approvisionnement validé ne peut être annulé que pendant les 48 heures suivant sa validation.');
                $q = $this->db->prepare('SELECT d.achat_detail_id,d.produit_id,d.quantity,p.est_perisable FROM achat_details d JOIN produits p ON p.produit_id=d.produit_id AND p.entreprise_id=d.entreprise_id WHERE d.entreprise_id=? AND d.achat_id=? LIMIT 1 FOR UPDATE');
                $q->bind_param('ii',$enterpriseId,$purchaseId);$q->execute();$d=$q->get_result()->fetch_assoc();
                if (!$d) throw new RuntimeException('Détail de l’approvisionnement introuvable.');
                $branch=(int)$purchase['succursale_id'];$product=(int)$d['produit_id'];$quantity=(int)$d['quantity'];$user=(int)$actor['id'];
                $b=$this->db->prepare('SELECT quantity FROM stocks WHERE entreprise_id=? AND succursale_id=? AND produit_id=? FOR UPDATE');$b->bind_param('iii',$enterpriseId,$branch,$product);$b->execute();$before=(int)(($b->get_result()->fetch_assoc()['quantity']??0));
                if($purchase['movement_type']==='IN'){$st=$this->db->prepare('UPDATE stocks SET quantity=quantity-? WHERE entreprise_id=? AND succursale_id=? AND produit_id=? AND quantity>=?');$st->bind_param('iiiii',$quantity,$enterpriseId,$branch,$product,$quantity);$st->execute();if($st->affected_rows!==1)throw new RuntimeException('Le stock a déjà été consommé; annulation impossible sans régularisation.');}
                else{$st=$this->db->prepare('UPDATE stocks SET quantity=quantity+? WHERE entreprise_id=? AND succursale_id=? AND produit_id=?');$st->bind_param('iiii',$quantity,$enterpriseId,$branch,$product);$st->execute();}
                if($purchase['movement_type']==='OUT' && (int)$d['est_perisable']===1){$detailId=(int)$d['achat_detail_id'];$alloc=$this->db->prepare('SELECT lot_detail_id,quantity FROM achat_detail_sorties WHERE entreprise_id=? AND sortie_detail_id=? FOR UPDATE');$alloc->bind_param('ii',$enterpriseId,$detailId);$alloc->execute();foreach($alloc->get_result()->fetch_all(MYSQLI_ASSOC) as $lot){$lotId=(int)$lot['lot_detail_id'];$taken=(int)$lot['quantity'];$undo=$this->db->prepare('UPDATE achat_details SET quantity_out=GREATEST(0,quantity_out-?) WHERE entreprise_id=? AND achat_detail_id=?');$undo->bind_param('iii',$taken,$enterpriseId,$lotId);$undo->execute();}$del=$this->db->prepare('DELETE FROM achat_detail_sorties WHERE entreprise_id=? AND sortie_detail_id=?');$del->bind_param('ii',$enterpriseId,$detailId);$del->execute();}
                $after=$purchase['movement_type']==='IN'?$before-$quantity:$before+$quantity;$type=$purchase['movement_type']==='IN'?'SORTIE':'ENTREE';$ref='ANNULATION_APPROVISIONNEMENT';$note='Annulation dans les 48 h #' . $purchaseId;
                $m=$this->db->prepare('INSERT INTO mouvements_stock (entreprise_id,succursale_id,produit_id,user_id,movement_type,quantity_before,quantity_moved,quantity_after,reference_type,reference_id,note) VALUES (?,?,?,?,?,?,?,?,?,?,?)');$m->bind_param('iiiisiiisis',$enterpriseId,$branch,$product,$user,$type,$before,$quantity,$after,$ref,$purchaseId,$note);$m->execute();
            } elseif ($purchase['status'] !== 'PENDING') throw new RuntimeException('Un approvisionnement validé ou annulé ne peut pas être modifié.');
            if ($newStatus === 'RECEIVED') {
                $q = $this->db->prepare('SELECT d.achat_detail_id, d.produit_id, d.quantity, d.date_expiration, p.est_perisable FROM achat_details d JOIN produits p ON p.produit_id=d.produit_id AND p.entreprise_id=d.entreprise_id WHERE d.entreprise_id=? AND d.achat_id=? LIMIT 1 FOR UPDATE');
                $q->bind_param('ii', $enterpriseId, $purchaseId); $q->execute(); $d = $q->get_result()->fetch_assoc();
                if (!$d) throw new RuntimeException('Détail d’approvisionnement introuvable.');
                $branch=(int)$purchase['succursale_id']; $product=(int)$d['produit_id']; $quantity=(int)$d['quantity']; $user=(int)$actor['id'];
                if ((int)$d['est_perisable']===1 && $purchase['movement_type']==='IN' && (empty($d['date_expiration']) || $d['date_expiration'] < date('Y-m-d'))) throw new RuntimeException('Date d’expiration absente ou dépassée.');
                $allocations=[];
                if ((int)$d['est_perisable']===1 && $purchase['movement_type']==='OUT') {
                    $l=$this->db->prepare('SELECT d.achat_detail_id,d.quantity,d.quantity_out FROM achat_details d JOIN achats a ON a.achat_id=d.achat_id AND a.entreprise_id=d.entreprise_id WHERE d.entreprise_id=? AND d.produit_id=? AND a.succursale_id=? AND a.movement_type=\'IN\' AND a.status=\'RECEIVED\' AND d.date_expiration IS NOT NULL AND d.quantity>d.quantity_out ORDER BY d.date_expiration,d.achat_detail_id FOR UPDATE');
                    $l->bind_param('iii',$enterpriseId,$product,$branch); $l->execute(); $left=$quantity;
                    foreach($l->get_result()->fetch_all(MYSQLI_ASSOC) as $lot){$take=min($left,(int)$lot['quantity']-(int)$lot['quantity_out']);if($take>0){$allocations[]=[(int)$lot['achat_detail_id'],$take];$left-=$take;}if($left===0)break;}
                    if($left>0)throw new RuntimeException('Stock des lots périssables insuffisant.');
                }
                $b=$this->db->prepare('SELECT quantity FROM stocks WHERE entreprise_id=? AND succursale_id=? AND produit_id=? FOR UPDATE'); $b->bind_param('iii',$enterpriseId,$branch,$product);$b->execute();$before=(int)(($b->get_result()->fetch_assoc()['quantity']??0));
                if($purchase['movement_type']==='IN'){$st=$this->db->prepare('INSERT INTO stocks (entreprise_id,succursale_id,produit_id,quantity) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE quantity=quantity+VALUES(quantity)');$st->bind_param('iiii',$enterpriseId,$branch,$product,$quantity);$st->execute();}
                else{$st=$this->db->prepare('UPDATE stocks SET quantity=quantity-? WHERE entreprise_id=? AND succursale_id=? AND produit_id=? AND quantity>=?');$st->bind_param('iiiii',$quantity,$enterpriseId,$branch,$product,$quantity);$st->execute();if($st->affected_rows!==1)throw new RuntimeException('Stock insuffisant pour valider cette sortie.');foreach($allocations as [$lotId,$take]){$u=$this->db->prepare('UPDATE achat_details SET quantity_out=quantity_out+? WHERE achat_detail_id=? AND entreprise_id=?');$u->bind_param('iii',$take,$lotId,$enterpriseId);$u->execute();$ins=$this->db->prepare('INSERT INTO achat_detail_sorties (entreprise_id,sortie_detail_id,lot_detail_id,quantity) VALUES (?,?,?,?)');$detailId=(int)$d['achat_detail_id'];$ins->bind_param('iiii',$enterpriseId,$detailId,$lotId,$take);$ins->execute();}}
                $after=$purchase['movement_type']==='IN'?$before+$quantity:$before-$quantity; $type=$purchase['movement_type']==='IN'?'ENTREE':'SORTIE';$ref=$purchase['movement_type']==='IN'?'APPROVISIONNEMENT':'SORTIE_STOCK';$note='Approvisionnement validé #'.$purchaseId;
                $m=$this->db->prepare('INSERT INTO mouvements_stock (entreprise_id,succursale_id,produit_id,user_id,movement_type,quantity_before,quantity_moved,quantity_after,reference_type,reference_id,note) VALUES (?,?,?,?,?,?,?,?,?,?,?)');$m->bind_param('iiiisiiisis',$enterpriseId,$branch,$product,$user,$type,$before,$quantity,$after,$ref,$purchaseId,$note);$m->execute();
            }
            $oldStatus=(string)$purchase['status'];$u=$this->db->prepare('UPDATE achats SET status=?, validation_date=CASE WHEN ?=\'RECEIVED\' THEN NOW() WHEN ?=\'PENDING\' THEN NULL ELSE validation_date END WHERE achat_id=? AND entreprise_id=? AND status=?');$u->bind_param('sssiis',$newStatus,$newStatus,$newStatus,$purchaseId,$enterpriseId,$oldStatus);$u->execute();if($u->affected_rows!==1)throw new RuntimeException('Statut déjà modifié.');
            $this->db->commit();
        } catch (\Throwable $e) { $this->db->rollback(); throw $e; }
    }
}


