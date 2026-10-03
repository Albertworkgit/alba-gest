<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Services/AccountingService.php';

use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Core\Database;
use AlbaStock\Core\JsonResponse;                                                                                                                                                                                                                                                                                                                                                                                                                                                 
use AlbaStock\Services\AccountingService;

try {
    $user = AuthGuard::requireAuthenticated();
    $enterpriseId = AuthGuard::enterpriseId($user);
    $action = (string) ($_GET['action'] ?? '');
    $branchId = Authorization::branchId($user, isset($_GET['succursale_id']) ? (int) $_GET['succursale_id'] : null);
    $db = Database::connection();
    $accountingService = new AccountingService($db);
    $attachCurrencyTotals = static function (array $sales) use ($db, $enterpriseId): array {
        if ($sales === []) return $sales;
        $saleIds = array_values(array_filter(array_unique(array_map('intval', array_column($sales, 'vente_id'))), static fn (int $id): bool => $id > 0));
        if ($saleIds === []) return $sales;
        $idList = implode(',', $saleIds);
        $query = $db->prepare('SELECT vente_id,monais,total_amount,amount_paid FROM vente_totaux_monnaies WHERE entreprise_id=? AND vente_id IN (' . $idList . ') ORDER BY vente_id,monais');
        $query->bind_param('i', $enterpriseId);
        $query->execute();
        $totalsBySale = [];
        foreach ($query->get_result()->fetch_all(MYSQLI_ASSOC) as $total) {
            $totalsBySale[(int) $total['vente_id']][] = $total;
        }
        foreach ($sales as &$sale) {
            $sale['currency_totals'] = $totalsBySale[(int) $sale['vente_id']] ?? [];
            if ($sale['currency_totals'] === [] && !empty($sale['monais'])) {
                $sale['currency_totals'][] = ['monais' => $sale['monais'], 'total_amount' => $sale['total_amount'], 'amount_paid' => $sale['amount_paid']];
            }
        }
        unset($sale);
        return $sales;
    };

    if ($action === 'accounting-accounts') {
        $accountingService = new AccountingService($db);
        if ($_SERVER['REQUEST_METHOD'] === 'GET') {
            Authorization::requirePermission($user, 'voir_comptabilite');
            JsonResponse::send(['success' => true, 'data' => $accountingService->accounts($enterpriseId)]);
        }
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            Authorization::requirePermission($user, 'modifier_comptabilite');
            $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
            $accountId = $accountingService->createAccount($enterpriseId, $body);
            JsonResponse::send(['success' => true, 'data' => ['compte_id' => $accountId]], 201);
        }
        JsonResponse::error('Méthode non autorisée pour le plan comptable.', 405);
    }

    if ($action === 'accounting-account' && in_array($_SERVER['REQUEST_METHOD'], ['PATCH', 'PUT'], true)) {
        Authorization::requirePermission($user, 'modifier_comptabilite');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $accountingService->updateAccount($enterpriseId, (int) ($_GET['compte_id'] ?? 0), $body);
        JsonResponse::send(['success' => true, 'message' => 'Compte comptable mis à jour.']);
    }

    if ($action === 'accounting-entries' && $_SERVER['REQUEST_METHOD'] === 'GET') {
        Authorization::requirePermission($user, 'voir_comptabilite');
        $from = trim((string) ($_GET['date_debut'] ?? ''));
        $to = trim((string) ($_GET['date_fin'] ?? ''));
        $currency = strtoupper(trim((string) ($_GET['monnaie'] ?? '')));
        JsonResponse::send(['success' => true, 'data' => $accountingService->entries($enterpriseId, $from, $to, $currency)]);
    }

    if ($action === 'accounting-entry' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        Authorization::requirePermission($user, 'creer_comptabilite');
        $body = json_decode((string) file_get_contents('php://input'), true) ?: [];
        $entryId = $accountingService->createEntry($enterpriseId, (int) ($user['id'] ?? 0), $body);
        JsonResponse::send(['success' => true, 'data' => ['ecriture_id' => $entryId]], 201);
    }

    if ($action === 'accounting-report' && $_SERVER['REQUEST_METHOD'] === 'GET') {
        Authorization::requirePermission($user, 'voir_comptabilite');
        $report = $accountingService->report(
            $enterpriseId,
            trim((string) ($_GET['type'] ?? '')),
            trim((string) ($_GET['date_debut'] ?? '')),
            trim((string) ($_GET['date_fin'] ?? '')),
            strtoupper(trim((string) ($_GET['monnaie'] ?? ''))),
            isset($_GET['compte_id']) ? (int) $_GET['compte_id'] : null
        );
        JsonResponse::send(['success' => true, 'data' => $report]);
    }

    if ($action === 'expiring-stock') {
        Authorization::requirePermission($user, 'voir_stock');
        $days = min(90, max(1, (int) ($_GET['jours'] ?? 30)));
        $sql = 'SELECT d.achat_detail_id AS lot_detail_id, d.date_expiration, d.quantity, d.quantity_out, (d.quantity - d.quantity_out) AS remaining_quantity, a.achat_id, a.purchase_no, a.succursale_id, s.name AS branch_name, p.produit_id, p.name AS product_name, p.sku, u.name AS unit_name, u.symbole AS unit_symbol, DATEDIFF(d.date_expiration, CURDATE()) AS days_remaining FROM achat_details d JOIN achats a ON a.achat_id = d.achat_id AND a.entreprise_id = d.entreprise_id JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id JOIN succursales s ON s.succursale_id = a.succursale_id AND s.entreprise_id = a.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE d.entreprise_id = ? AND p.est_perisable = 1 AND d.date_expiration IS NOT NULL AND d.quantity > d.quantity_out AND a.movement_type = \'IN\' AND a.status = \'RECEIVED\' AND d.date_expiration <= DATE_ADD(CURDATE(), INTERVAL ? DAY)';
        if ($branchId !== null) $sql .= ' AND a.succursale_id = ?';
        $sql .= ' ORDER BY d.date_expiration ASC, p.name ASC';
        $query = $db->prepare($sql);
        if ($branchId === null) $query->bind_param('ii', $enterpriseId, $days);
        else $query->bind_param('iii', $enterpriseId, $days, $branchId);
        $query->execute();
        JsonResponse::send(['success' => true, 'data' => $query->get_result()->fetch_all(MYSQLI_ASSOC)]);
    }

    if ($action === 'perishable-lots') {
        Authorization::requirePermission($user, 'voir_approvisionnements');
        $productId = (int) ($_GET['produit_id'] ?? 0);
        $requestedBranch = isset($_GET['succursale_id']) ? (int) $_GET['succursale_id'] : $branchId;
        $requestedBranch = Authorization::branchId($user, $requestedBranch);
        if ($productId < 1) JsonResponse::error('Produit invalide.', 422);
        $sql = 'SELECT d.achat_detail_id AS lot_detail_id, d.date_expiration, d.quantity, d.quantity_out, (d.quantity - d.quantity_out) AS remaining_quantity, a.purchase_no FROM achat_details d JOIN achats a ON a.achat_id = d.achat_id AND a.entreprise_id = d.entreprise_id JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id WHERE d.entreprise_id = ? AND d.produit_id = ? AND p.est_perisable = 1 AND d.date_expiration IS NOT NULL AND d.quantity > d.quantity_out AND a.movement_type = \'IN\' AND a.status = \'RECEIVED\'';
        if ($requestedBranch !== null) $sql .= ' AND a.succursale_id = ?';
        $sql .= ' ORDER BY d.date_expiration ASC, d.achat_detail_id ASC';
        $query = $db->prepare($sql);
        if ($requestedBranch === null) $query->bind_param('ii', $enterpriseId, $productId);
        else $query->bind_param('iii', $enterpriseId, $productId, $requestedBranch);
        $query->execute();
        JsonResponse::send(['success' => true, 'data' => $query->get_result()->fetch_all(MYSQLI_ASSOC)]);
    }

    if ($action === 'payment-journal') {
        Authorization::requireAnyPermission($user,['voir_caisse','modifier_caisse']);
        $branchFilter=$branchId!==null?' AND x.succursale_id=?':'';
        $sql="SELECT x.payment_date,x.payment_mode,x.reference,x.amount,x.document_no,x.operation,x.vente_id,x.branch_name,x.monais FROM (SELECT p.payment_date,m.name AS payment_mode,p.reference,p.amount,v.invoice_no AS document_no,'Vente' AS operation,v.vente_id AS vente_id,v.succursale_id,s.name AS branch_name,p.monais FROM paiements_ventes p JOIN modes_paiement m ON m.mode_paiement_id=p.mode_paiement_id JOIN ventes v ON v.vente_id=p.vente_id AND v.entreprise_id=p.entreprise_id JOIN succursales s ON s.succursale_id=v.succursale_id AND s.entreprise_id=v.entreprise_id WHERE p.entreprise_id=? AND p.payment_type='PAYMENT' AND m.requires_cash=0 UNION ALL SELECT p.payment_date,m.name AS payment_mode,p.reference,p.amount,a.purchase_no AS document_no,'Fournisseur' AS operation,NULL AS vente_id,a.succursale_id,s.name AS branch_name,a.monais FROM paiements_fournisseurs p JOIN modes_paiement m ON m.mode_paiement_id=p.mode_paiement_id JOIN achats a ON a.achat_id=p.achat_id AND a.entreprise_id=p.entreprise_id JOIN succursales s ON s.succursale_id=a.succursale_id AND s.entreprise_id=a.entreprise_id WHERE p.entreprise_id=? AND m.requires_cash=0) x WHERE 1=1".$branchFilter.' ORDER BY x.payment_date DESC LIMIT 100';
        $query=$db->prepare($sql);
        if($branchId===null)$query->bind_param('ii',$enterpriseId,$enterpriseId);else$query->bind_param('iii',$enterpriseId,$enterpriseId,$branchId);
        $query->execute();JsonResponse::send(['success'=>true,'data'=>$query->get_result()->fetch_all(MYSQLI_ASSOC)]);
    }

    if ($action === 'supplier-debts') {
        Authorization::requireAnyPermission($user, ['voir_approvisionnements', 'voir_comptabilite']);
        $sql = "SELECT a.achat_id,a.purchase_no,a.purchase_date,a.total_amount,a.amount_paid,a.monais,a.succursale_id,s.name AS branch_name,f.name AS supplier_name FROM achats a JOIN succursales s ON s.succursale_id=a.succursale_id AND s.entreprise_id=a.entreprise_id JOIN fournisseurs f ON f.fournisseur_id=a.fournisseur_id AND f.entreprise_id=a.entreprise_id WHERE a.entreprise_id=? AND a.movement_type='IN' AND a.status='RECEIVED' AND a.amount_paid<a.total_amount";
        if ($branchId !== null) $sql .= ' AND a.succursale_id=?';
        $sql .= ' ORDER BY a.purchase_date,a.achat_id';
        $query=$db->prepare($sql);
        if ($branchId === null) $query->bind_param('i',$enterpriseId); else $query->bind_param('ii',$enterpriseId,$branchId);
        $query->execute();
        JsonResponse::send(['success'=>true,'data'=>$query->get_result()->fetch_all(MYSQLI_ASSOC)]);
    }

    if ($action === 'cash-movements') {
        Authorization::requirePermission($user,'voir_caisse');
        $page=max(1,(int)($_GET['page']??1));$perPage=min(100,max(1,(int)($_GET['per_page']??10)));$offset=($page-1)*$perPage;
        $where='m.entreprise_id=?'.($branchId!==null?' AND c.succursale_id=?':'');
        $count=$db->prepare('SELECT COUNT(*) AS total FROM mouvements_caisse m JOIN caisses c ON c.caisse_id=m.caisse_id WHERE '.$where);
        if($branchId===null)$count->bind_param('i',$enterpriseId);else$count->bind_param('ii',$enterpriseId,$branchId);$count->execute();$total=(int)($count->get_result()->fetch_assoc()['total']??0);
        $summaryBranchFilter=$branchId!==null?' AND c.succursale_id=?':'';
        $summarySql='SELECT t.code AS monais,COALESCE(SUM(mov.entrees),0) AS entrees,COALESCE(SUM(mov.sorties),0) AS sorties,COALESCE(SUM(CASE WHEN c.statut="OUVERTE" THEN c.montant ELSE 0 END),0) AS solde,COALESCE(SUM(mov.operations),0) AS operations FROM caisses c JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id LEFT JOIN (SELECT entreprise_id,caisse_id,SUM(CASE WHEN type="ENTREE" THEN amount ELSE 0 END) AS entrees,SUM(CASE WHEN type="SORTIE" THEN amount ELSE 0 END) AS sorties,COUNT(*) AS operations FROM mouvements_caisse WHERE entreprise_id=? GROUP BY entreprise_id,caisse_id) mov ON mov.caisse_id=c.caisse_id AND mov.entreprise_id=c.entreprise_id WHERE c.entreprise_id=?'.$summaryBranchFilter.' GROUP BY t.code ORDER BY t.code';
        $summary=$db->prepare($summarySql);if($branchId===null)$summary->bind_param('ii',$enterpriseId,$enterpriseId);else$summary->bind_param('iii',$enterpriseId,$enterpriseId,$branchId);$summary->execute();$summaryRows=$summary->get_result()->fetch_all(MYSQLI_ASSOC);
        $sql='SELECT m.mouvement_id,m.type,m.amount,m.reason,m.reference_id,m.bank_reference,m.movement_date,pm.name AS payment_mode,b.name AS bank_name,c.name AS cash_name,t.code AS monais,t.symbole AS currency_symbol,u.full_name AS cashier,sv.vente_id AS vente_id,sv.invoice_no AS invoice_no FROM mouvements_caisse m JOIN caisses c ON c.caisse_id=m.caisse_id JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id LEFT JOIN modes_paiement pm ON pm.mode_paiement_id=m.mode_paiement_id LEFT JOIN banques b ON b.banque_id=m.banque_id LEFT JOIN users u ON u.user_id=m.user_id LEFT JOIN ventes sv ON sv.vente_id=m.reference_id AND sv.entreprise_id=m.entreprise_id AND m.reason LIKE \'Paiement vente %\' WHERE '.$where.' ORDER BY m.movement_date DESC,m.mouvement_id DESC LIMIT ? OFFSET ?';
        $q=$db->prepare($sql);if($branchId===null)$q->bind_param('iii',$enterpriseId,$perPage,$offset);else$q->bind_param('iiii',$enterpriseId,$branchId,$perPage,$offset);$q->execute();
        JsonResponse::send(['success'=>true,'data'=>$q->get_result()->fetch_all(MYSQLI_ASSOC),'summary'=>$summaryRows,'pagination'=>['page'=>$page,'per_page'=>$perPage,'total'=>$total,'pages'=>max(1,(int)ceil($total/$perPage))]]);
    }

    if ($action === 'bank-operations') {
        Authorization::requirePermission($user,'voir_caisse');$bankId=(int)($_GET['banque_id']??0);if($bankId<1)JsonResponse::error('Sélectionnez une banque.',422);$scope=($branchId!==null?' AND c.succursale_id=?':'');$summarySql='SELECT t.code AS monais,SUM(CASE WHEN m.type="ENTREE" THEN m.amount ELSE 0 END) AS entrees,SUM(CASE WHEN m.type="SORTIE" THEN m.amount ELSE 0 END) AS sorties,SUM(CASE WHEN m.type="ENTREE" THEN m.amount ELSE -m.amount END) AS solde,COUNT(*) AS operations FROM mouvements_caisse m JOIN caisses c ON c.caisse_id=m.caisse_id AND c.entreprise_id=m.entreprise_id JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id WHERE m.entreprise_id=? AND m.banque_id=?'.$scope.' GROUP BY t.code ORDER BY t.code';$summary=$db->prepare($summarySql);if($branchId===null)$summary->bind_param('ii',$enterpriseId,$bankId);else$summary->bind_param('iii',$enterpriseId,$bankId,$branchId);$summary->execute();$summaryRows=$summary->get_result()->fetch_all(MYSQLI_ASSOC);$sql='SELECT m.mouvement_id,m.movement_date,m.type,m.amount,m.reason,m.bank_reference,m.reference_id,b.name AS bank_name,c.name AS cash_name,t.code AS monais,s.name AS branch_name,pm.name AS payment_mode FROM mouvements_caisse m JOIN banques b ON b.banque_id=m.banque_id AND b.entreprise_id=m.entreprise_id JOIN caisses c ON c.caisse_id=m.caisse_id AND c.entreprise_id=m.entreprise_id JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id JOIN succursales s ON s.succursale_id=c.succursale_id AND s.entreprise_id=c.entreprise_id LEFT JOIN modes_paiement pm ON pm.mode_paiement_id=m.mode_paiement_id WHERE m.entreprise_id=? AND m.banque_id=?'.$scope.' ORDER BY m.movement_date DESC,m.mouvement_id DESC LIMIT 250';$query=$db->prepare($sql);if($branchId===null)$query->bind_param('ii',$enterpriseId,$bankId);else$query->bind_param('iii',$enterpriseId,$bankId,$branchId);$query->execute();JsonResponse::send(['success'=>true,'data'=>['summary'=>$summaryRows,'operations'=>$query->get_result()->fetch_all(MYSQLI_ASSOC)]]);
    }

    if ($action === 'cashboxes-list') {
        Authorization::requireAnyPermission($user,['voir_caisse','modifier_caisse']);$page=max(1,(int)($_GET['page']??1));$perPage=min(100,max(1,(int)($_GET['per_page']??10)));$offset=($page-1)*$perPage;$where='c.entreprise_id=?'.($branchId!==null?' AND c.succursale_id=?':'');$count=$db->prepare('SELECT COUNT(*) AS total FROM caisses c WHERE '.$where);if($branchId===null)$count->bind_param('i',$enterpriseId);else$count->bind_param('ii',$enterpriseId,$branchId);$count->execute();$total=(int)($count->get_result()->fetch_assoc()['total']??0);$sql='SELECT c.caisse_id,c.succursale_id,c.name,c.mode_paiement_id,c.banque_id,b.name AS bank_name,pm.name AS payment_mode,pm.code AS payment_mode_code,c.date_ouverture,c.solde_ouverture,c.montant AS solde_courant,c.solde_fermeture,c.statut,t.code AS monais,t.name AS currency_name,t.symbole AS currency_symbol FROM caisses c JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id JOIN modes_paiement pm ON pm.mode_paiement_id=c.mode_paiement_id LEFT JOIN banques b ON b.banque_id=c.banque_id AND b.entreprise_id=c.entreprise_id WHERE '.$where.' ORDER BY c.date_ouverture DESC,c.caisse_id DESC LIMIT ? OFFSET ?';$q=$db->prepare($sql);if($branchId===null)$q->bind_param('iii',$enterpriseId,$perPage,$offset);else$q->bind_param('iiii',$enterpriseId,$branchId,$perPage,$offset);$q->execute();JsonResponse::send(['success'=>true,'data'=>$q->get_result()->fetch_all(MYSQLI_ASSOC),'pagination'=>['page'=>$page,'per_page'=>$perPage,'total'=>$total,'pages'=>max(1,(int)ceil($total / $perPage))]]);
    }

    
    if ($action === 'sale-catalog') {
        Authorization::requireAnyPermission($user,['voir_ventes','creer_ventes']);
        $requested=(int)($_GET['succursale_id']??0);$targetBranch=Authorization::branchId($user,$requested>0?$requested:null);
        if($targetBranch===null){$branchQuery=$db->prepare('SELECT succursale_id FROM succursales WHERE entreprise_id=? ORDER BY est_sucursal_mere DESC,succursale_id LIMIT 1');$branchQuery->bind_param('i',$enterpriseId);$branchQuery->execute();$targetBranch=(int)($branchQuery->get_result()->fetch_assoc()['succursale_id']??0);}
        $products=$db->prepare('SELECT p.produit_id,p.name,p.sku,p.unit_price,p.monais,p.est_perisable,p.unite_de_mesure,u.name AS unit_name,u.symbole AS unit_symbol,CASE WHEN p.est_perisable=1 THEN COALESCE(lots.available_quantity,0) ELSE COALESCE(st.quantity,0) END AS quantity FROM produits p LEFT JOIN unites_mesure u ON u.unite_mesure_id=p.unite_de_mesure AND u.entreprise_id=p.entreprise_id LEFT JOIN stocks st ON st.produit_id=p.produit_id AND st.entreprise_id=p.entreprise_id AND st.succursale_id=? LEFT JOIN (SELECT a.entreprise_id,a.succursale_id,d.produit_id,SUM(d.quantity-d.quantity_out) AS available_quantity FROM achat_details d JOIN achats a ON a.achat_id=d.achat_id AND a.entreprise_id=d.entreprise_id WHERE a.movement_type=\'IN\' AND a.status=\'RECEIVED\' AND d.date_expiration>=CURDATE() GROUP BY a.entreprise_id,a.succursale_id,d.produit_id) lots ON lots.entreprise_id=p.entreprise_id AND lots.produit_id=p.produit_id AND lots.succursale_id=? WHERE p.entreprise_id=? AND p.is_active=1 ORDER BY p.name');$products->bind_param('iii',$targetBranch,$targetBranch,$enterpriseId);$products->execute();$productRows=$products->get_result()->fetch_all(MYSQLI_ASSOC);
        $cash=$db->prepare("SELECT c.caisse_id,c.name,t.code AS monais,t.symbole AS currency_symbol,c.montant AS solde_courant FROM caisses c JOIN types_caisses t ON t.type_caisse_id=c.type_caisse_id AND t.entreprise_id=c.entreprise_id WHERE c.entreprise_id=? AND c.succursale_id=? AND c.statut='OUVERTE' ORDER BY c.caisse_id DESC");$cash->bind_param('ii',$enterpriseId,$targetBranch);$cash->execute();$cashRows=$cash->get_result()->fetch_all(MYSQLI_ASSOC);$clients=$db->prepare('SELECT client_id,name FROM clients WHERE entreprise_id=? ORDER BY name');$clients->bind_param('i',$enterpriseId);$clients->execute();$clientRows=$clients->get_result()->fetch_all(MYSQLI_ASSOC);
        JsonResponse::send(['success'=>true,'data'=>['succursale_id'=>$targetBranch,'products'=>$productRows,'cashboxes'=>$cashRows,'clients'=>$clientRows]]);
    }

    if ($action === 'sales-list') {
        Authorization::requirePermission($user,'voir_ventes');$page=max(1,(int)($_GET['page']??1));$perPage=min(100,max(1,(int)($_GET['per_page']??10)));$offset=($page-1)*$perPage;
        $where='v.entreprise_id=?'.($branchId!==null?' AND v.succursale_id=?':'');$count=$db->prepare('SELECT COUNT(*) AS total FROM ventes v WHERE '.$where);if($branchId===null)$count->bind_param('i',$enterpriseId);else$count->bind_param('ii',$enterpriseId,$branchId);$count->execute();$total=(int)($count->get_result()->fetch_assoc()['total']??0);
        $sql='SELECT v.vente_id,v.invoice_no,v.sale_date,v.total_amount,v.monais,v.amount_paid,v.status,v.succursale_id,s.name AS branch_name,COALESCE(NULLIF(v.client_comptoir_name, \'\'),c.name) AS client_name,u.full_name AS cashier,COALESCE(d.item_count,0) AS item_count FROM ventes v JOIN succursales s ON s.succursale_id=v.succursale_id AND s.entreprise_id=v.entreprise_id LEFT JOIN clients c ON c.client_id=v.client_id AND c.entreprise_id=v.entreprise_id LEFT JOIN users u ON u.user_id=v.user_id AND u.entreprise_id=v.entreprise_id LEFT JOIN (SELECT entreprise_id,vente_id,SUM(quantity) AS item_count FROM vente_details GROUP BY entreprise_id,vente_id) d ON d.entreprise_id=v.entreprise_id AND d.vente_id=v.vente_id WHERE '.$where.' ORDER BY v.sale_date DESC,v.vente_id DESC LIMIT ? OFFSET ?';$query=$db->prepare($sql);if($branchId===null)$query->bind_param('iii',$enterpriseId,$perPage,$offset);else$query->bind_param('iiii',$enterpriseId,$branchId,$perPage,$offset);$query->execute();$salesRows=$attachCurrencyTotals($query->get_result()->fetch_all(MYSQLI_ASSOC));JsonResponse::send(['success'=>true,'data'=>$salesRows,'pagination'=>['page'=>$page,'per_page'=>$perPage,'total'=>$total,'pages'=>max(1,(int)ceil($total/$perPage))]]);
    }

    if ($action === 'pending-sales') {
        Authorization::requirePermission($user,'modifier_caisse');$page=max(1,(int)($_GET['page']??1));$perPage=min(100,max(1,(int)($_GET['per_page']??10)));$offset=($page-1)*$perPage;$where="v.entreprise_id=? AND v.status IN ('PENDING','PARTIAL')".($branchId!==null?' AND v.succursale_id=?':'');$count=$db->prepare('SELECT COUNT(*) AS total FROM ventes v WHERE '.$where);if($branchId===null)$count->bind_param('i',$enterpriseId);else$count->bind_param('ii',$enterpriseId,$branchId);$count->execute();$total=(int)($count->get_result()->fetch_assoc()['total']??0);$sql='SELECT v.vente_id,v.invoice_no,v.sale_date,v.total_amount,v.amount_paid,v.monais,v.status,v.succursale_id,COALESCE(NULLIF(v.client_comptoir_name, \'\'),cl.name) AS client_name,u.full_name AS seller FROM ventes v LEFT JOIN clients cl ON cl.client_id=v.client_id AND cl.entreprise_id=v.entreprise_id LEFT JOIN users u ON u.user_id=v.user_id AND u.entreprise_id=v.entreprise_id WHERE '.$where.' ORDER BY v.sale_date ASC,v.vente_id ASC LIMIT ? OFFSET ?';$q=$db->prepare($sql);if($branchId===null)$q->bind_param('iii',$enterpriseId,$perPage,$offset);else$q->bind_param('iiii',$enterpriseId,$branchId,$perPage,$offset);$q->execute();$salesRows=$attachCurrencyTotals($q->get_result()->fetch_all(MYSQLI_ASSOC));JsonResponse::send(['success'=>true,'data'=>$salesRows,'pagination'=>['page'=>$page,'per_page'=>$perPage,'total'=>$total,'pages'=>max(1,(int)ceil($total/$perPage))]]);
    }

    if ($action === 'procurement-list') {
        Authorization::requirePermission($user, 'voir_approvisionnements');
        $sql = 'SELECT a.achat_id, a.purchase_no, a.purchase_date, a.validation_date, a.total_amount, a.movement_type, a.motif_sortie, a.status, a.fournisseur_id, f.name AS supplier_name, s.name AS branch_name, COALESCE(d.total_quantity, 0) AS total_quantity, d.unit_name, d.unit_abbreviation, d.monais FROM achats a JOIN succursales s ON s.succursale_id = a.succursale_id AND s.entreprise_id = a.entreprise_id LEFT JOIN fournisseurs f ON f.fournisseur_id = a.fournisseur_id AND f.entreprise_id = a.entreprise_id LEFT JOIN (SELECT ad.entreprise_id, ad.achat_id, SUM(ad.quantity) AS total_quantity, MAX(u.name) AS unit_name, MAX(u.symbole) AS unit_abbreviation, MAX(p.monais) AS monais FROM achat_details ad JOIN produits p ON p.produit_id = ad.produit_id AND p.entreprise_id = ad.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id GROUP BY ad.entreprise_id, ad.achat_id) d ON d.entreprise_id = a.entreprise_id AND d.achat_id = a.achat_id WHERE a.entreprise_id = ?';
        if ($branchId !== null) $sql .= ' AND a.succursale_id = ?';
        $countSql = 'SELECT COUNT(*) AS total FROM achats a WHERE a.entreprise_id = ?' . ($branchId !== null ? ' AND a.succursale_id = ?' : '');
        $countQuery = $db->prepare($countSql);
        if ($branchId === null) $countQuery->bind_param('i', $enterpriseId); else $countQuery->bind_param('ii', $enterpriseId, $branchId);
        $countQuery->execute();
        $total = (int) ($countQuery->get_result()->fetch_assoc()['total'] ?? 0);
        $paged = isset($_GET['page']);
        $page = max(1, (int) ($_GET['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($_GET['per_page'] ?? 10)));
        $offset = ($page - 1) * $perPage;
        $sql .= ' ORDER BY a.purchase_date DESC, a.achat_id DESC' . ($paged ? ' LIMIT ? OFFSET ?' : '');
        $query = $db->prepare($sql);
        if ($branchId === null && $paged) $query->bind_param('iii', $enterpriseId, $perPage, $offset);
        elseif ($branchId !== null && $paged) $query->bind_param('iiii', $enterpriseId, $branchId, $perPage, $offset);
        elseif ($branchId === null) $query->bind_param('i', $enterpriseId);
        else $query->bind_param('ii', $enterpriseId, $branchId);
        $query->execute();
        $response = ['success' => true, 'data' => $query->get_result()->fetch_all(MYSQLI_ASSOC)];
        if ($response['data'] !== []) {
            $purchaseIds = implode(',', array_map(static fn (array $row): int => (int) $row['achat_id'], $response['data']));
            $lotQuery = $db->prepare('SELECT achat_id, MAX(date_expiration) AS date_expiration, SUM(quantity_out) AS quantity_out, SUM(quantity) AS lot_quantity FROM achat_details WHERE entreprise_id = ? AND achat_id IN (' . $purchaseIds . ') GROUP BY achat_id');
            $lotQuery->bind_param('i', $enterpriseId);
            $lotQuery->execute();
            $lotSummaries = [];
            foreach ($lotQuery->get_result()->fetch_all(MYSQLI_ASSOC) as $lotSummary) $lotSummaries[(int) $lotSummary['achat_id']] = $lotSummary;
            foreach ($response['data'] as &$purchaseRow) {
                $lotSummary = $lotSummaries[(int) $purchaseRow['achat_id']] ?? [];
                $purchaseRow['date_expiration'] = $lotSummary['date_expiration'] ?? null;
                $purchaseRow['quantity_out'] = (int) ($lotSummary['quantity_out'] ?? 0);
                $purchaseRow['remaining_quantity'] = $purchaseRow['date_expiration'] !== null
                    ? max(0, (int) ($lotSummary['lot_quantity'] ?? 0) - (int) $purchaseRow['quantity_out'])
                    : null;
            }
            unset($purchaseRow);
        }
        if ($paged) $response['pagination'] = ['page' => $page, 'per_page' => $perPage, 'total' => $total, 'pages' => max(1, (int) ceil($total / $perPage))];
        JsonResponse::send($response);
    }

    if ($action === 'stock-card') {
        Authorization::requirePermission($user, 'voir_stock');
        $productId = (int) ($_GET['produit_id'] ?? 0);
        if ($productId < 1) JsonResponse::error('Identifiant produit invalide.', 422);
        $productQuery = $db->prepare('SELECT p.produit_id, p.sku, p.name, p.unit_price, p.cost_price, p.monais, u.name AS unit_name, u.symbole AS unit_abbreviation FROM produits p LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE p.entreprise_id = ? AND p.produit_id = ? LIMIT 1');
        $productQuery->bind_param('ii', $enterpriseId, $productId);
        $productQuery->execute();
        $product = $productQuery->get_result()->fetch_assoc();
        if (!$product) JsonResponse::error('Produit introuvable dans votre entreprise.', 404);

        $sql = 'SELECT m.movement_date, m.movement_type, m.quantity_before, m.quantity_moved, m.quantity_after, m.reference_type, m.reference_id, m.note, s.succursale_id AS branch_id, s.name AS branch_name FROM mouvements_stock m JOIN succursales s ON s.succursale_id = m.succursale_id WHERE m.entreprise_id = ? AND m.produit_id = ?';
        if ($branchId !== null) $sql .= ' AND m.succursale_id = ?';
        $sql .= ' ORDER BY m.movement_date ASC, m.mouvement_stock_id ASC';
        $movements = $db->prepare($sql);
        if ($branchId === null) $movements->bind_param('ii', $enterpriseId, $productId);
        else $movements->bind_param('iii', $enterpriseId, $productId, $branchId);
        $movements->execute();
        $rows = $movements->get_result()->fetch_all(MYSQLI_ASSOC);
        $branchQuantities = [];
        $historicalStockMax = 0;
        foreach ($rows as $row) {
            $branchIdForMax = (int) $row['branch_id'];
            $branchQuantities[$branchIdForMax] ??= (int) $row['quantity_before'];
            $historicalStockMax = max($historicalStockMax, array_sum($branchQuantities));
            $branchQuantities[$branchIdForMax] = (int) $row['quantity_after'];
            $historicalStockMax = max($historicalStockMax, array_sum($branchQuantities));
        }

        // Les dates et la recherche sont appliquées avant de construire la fiche imprimable.
        $dateFrom = (string) ($_GET['date_debut'] ?? '');
        $dateTo = (string) ($_GET['date_fin'] ?? '');
        $search = mb_strtolower(trim((string) ($_GET['recherche'] ?? '')), 'UTF-8');
        $validDate = static fn (string $date): bool => $date === '' || (preg_match('/^\d{4}-\d{2}-\d{2}$/', $date) === 1 && checkdate((int) substr($date, 5, 2), (int) substr($date, 8, 2), (int) substr($date, 0, 4)));
        if (!$validDate($dateFrom) || !$validDate($dateTo) || ($dateFrom !== '' && $dateTo !== '' && $dateFrom > $dateTo)) {
            JsonResponse::error('Format de date invalide pour le rapport.', 422);
        }
        $rows = array_values(array_filter($rows, static function (array $row) use ($dateFrom, $dateTo, $search): bool {
            $day = substr((string) $row['movement_date'], 0, 10);
            if ($dateFrom !== '' && $day < $dateFrom) return false;
            if ($dateTo !== '' && $day > $dateTo) return false;
            if ($search === '') return true;
            $haystack = mb_strtolower(implode(' ', array_map('strval', [$row['branch_name'], $row['movement_type'], $row['reference_type'], $row['note']])), 'UTF-8');
            return str_contains($haystack, $search);
        }));

        $costSql = "SELECT 'APPROVISIONNEMENT' AS reference_type, a.achat_id AS reference_id, SUM(d.quantity * d.unit_cost) / NULLIF(SUM(d.quantity), 0) AS unit_cost
            FROM achats a JOIN achat_details d ON d.achat_id = a.achat_id AND d.entreprise_id = a.entreprise_id
            WHERE a.entreprise_id = ? AND d.produit_id = ? AND a.movement_type = 'IN' AND a.status = 'RECEIVED' GROUP BY a.achat_id
            UNION ALL
            SELECT 'ANNULATION_APPROVISIONNEMENT', a.achat_id, SUM(d.quantity * d.unit_cost) / NULLIF(SUM(d.quantity), 0)
            FROM achats a JOIN achat_details d ON d.achat_id = a.achat_id AND d.entreprise_id = a.entreprise_id
            WHERE a.entreprise_id = ? AND d.produit_id = ? AND a.movement_type = 'IN' GROUP BY a.achat_id
            UNION ALL
            SELECT 'SORTIE_STOCK', out_a.achat_id, SUM(allocation.quantity * source_detail.unit_cost) / NULLIF(SUM(allocation.quantity), 0)
            FROM achat_detail_sorties allocation JOIN achat_details out_detail ON out_detail.achat_detail_id = allocation.sortie_detail_id AND out_detail.entreprise_id = allocation.entreprise_id JOIN achats out_a ON out_a.achat_id = out_detail.achat_id AND out_a.entreprise_id = out_detail.entreprise_id JOIN achat_details source_detail ON source_detail.achat_detail_id = allocation.lot_detail_id AND source_detail.entreprise_id = allocation.entreprise_id
            WHERE allocation.entreprise_id = ? AND out_detail.produit_id = ? GROUP BY out_a.achat_id
            UNION ALL
            SELECT 'VENTE', v.vente_id, SUM(allocation.quantity * source_detail.unit_cost) / NULLIF(SUM(allocation.quantity), 0)
            FROM vente_detail_lots allocation JOIN vente_details vd ON vd.vente_detail_id = allocation.vente_detail_id AND vd.entreprise_id = allocation.entreprise_id JOIN ventes v ON v.vente_id = vd.vente_id AND v.entreprise_id = vd.entreprise_id JOIN achat_details source_detail ON source_detail.achat_detail_id = allocation.achat_detail_id AND source_detail.entreprise_id = allocation.entreprise_id
            WHERE allocation.entreprise_id = ? AND vd.produit_id = ? GROUP BY v.vente_id
            UNION ALL
            SELECT 'ANNULATION_VENTE', v.vente_id, SUM(allocation.quantity * source_detail.unit_cost) / NULLIF(SUM(allocation.quantity), 0)
            FROM vente_detail_lots allocation JOIN vente_details vd ON vd.vente_detail_id = allocation.vente_detail_id AND vd.entreprise_id = allocation.entreprise_id JOIN ventes v ON v.vente_id = vd.vente_id AND v.entreprise_id = vd.entreprise_id JOIN achat_details source_detail ON source_detail.achat_detail_id = allocation.achat_detail_id AND source_detail.entreprise_id = allocation.entreprise_id
            WHERE allocation.entreprise_id = ? AND vd.produit_id = ? GROUP BY v.vente_id";
        $costQuery = $db->prepare($costSql);
        $costQuery->bind_param('iiiiiiiiii', $enterpriseId, $productId, $enterpriseId, $productId, $enterpriseId, $productId, $enterpriseId, $productId, $enterpriseId, $productId);
        $costQuery->execute();
        $movementCosts = [];
        foreach ($costQuery->get_result()->fetch_all(MYSQLI_ASSOC) as $movementCost) {
            $movementCosts[$movementCost['reference_type'] . ':' . $movementCost['reference_id']] = (float) $movementCost['unit_cost'];
        }
        foreach ($rows as &$row) {
            $costKey = $row['reference_type'] . ':' . $row['reference_id'];
            $row['unit_cost'] = $movementCosts[$costKey] ?? (float) $product['cost_price'];
        }
        unset($row);

        $stockSql = 'SELECT st.quantity, st.min_stock_level, s.name AS branch_name FROM stocks st JOIN succursales s ON s.succursale_id = st.succursale_id WHERE st.entreprise_id = ? AND st.produit_id = ?';
        if ($branchId !== null) $stockSql .= ' AND st.succursale_id = ?';
        $stockSql .= ' ORDER BY s.name';
        $stockQuery = $db->prepare($stockSql);
        if ($branchId === null) $stockQuery->bind_param('ii', $enterpriseId, $productId);
        else $stockQuery->bind_param('iii', $enterpriseId, $productId, $branchId);
        $stockQuery->execute();
        $balances = $stockQuery->get_result()->fetch_all(MYSQLI_ASSOC);
        $currentStock = array_sum(array_map(static fn (array $balance): int => (int) $balance['quantity'], $balances));
        JsonResponse::send(['success' => true, 'data' => ['product' => $product, 'movements' => $rows, 'balances' => $balances, 'stock_max' => max($historicalStockMax, $currentStock)]]);
    }

    if ($action === 'stock-movements-products') {
        Authorization::requireAnyPermission($user, ['voir_stock', 'voir_approvisionnements']);
        $page = max(1, (int) ($_GET['page'] ?? 1));
        $perPage = min(100, max(1, (int) ($_GET['per_page'] ?? 10)));
        $offset = ($page - 1) * $perPage;
        $countProducts = $db->prepare('SELECT COUNT(*) AS total FROM produits WHERE entreprise_id = ? AND is_active = 1');
        $countProducts->bind_param('i', $enterpriseId);
        $countProducts->execute();
        $totalProducts = (int) ($countProducts->get_result()->fetch_assoc()['total'] ?? 0);
        $productsQuery = $db->prepare('SELECT p.produit_id, p.name, p.sku, p.est_perisable, u.name AS unit_name, u.symbole AS unit_symbol FROM produits p LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE p.entreprise_id = ? AND p.is_active = 1 ORDER BY p.name, p.produit_id LIMIT ? OFFSET ?');
        $productsQuery->bind_param('iii', $enterpriseId, $perPage, $offset);
        $productsQuery->execute();
        JsonResponse::send(['success' => true, 'data' => $productsQuery->get_result()->fetch_all(MYSQLI_ASSOC), 'pagination' => ['page' => $page, 'per_page' => $perPage, 'total' => $totalProducts, 'pages' => max(1, (int) ceil($totalProducts / $perPage))]]);
    }

    if ($action === 'stock-movements-report') {
        Authorization::requireAnyPermission($user, ['voir_stock', 'voir_approvisionnements']);
        $rawProductIds = array_filter(explode(',', (string) ($_GET['produits'] ?? '')), static fn (string $value): bool => $value !== '');
        if ($rawProductIds === [] || count($rawProductIds) > 100) JsonResponse::error('Sélectionnez entre 1 et 100 produits.', 422);
        foreach ($rawProductIds as $rawId) {
            if (!ctype_digit($rawId) || (int) $rawId < 1) JsonResponse::error('La sélection des produits est invalide.', 422);
        }
        $productIds = array_values(array_unique(array_map('intval', $rawProductIds)));
        $dateFrom = trim((string) ($_GET['date_debut'] ?? ''));
        $dateTo = trim((string) ($_GET['date_fin'] ?? ''));
        $validDate = static fn (string $date): bool => $date === '' || (preg_match('/^\d{4}-\d{2}-\d{2}$/', $date) === 1 && checkdate((int) substr($date, 5, 2), (int) substr($date, 8, 2), (int) substr($date, 0, 4)));
        if (!$validDate($dateFrom) || !$validDate($dateTo) || ($dateFrom !== '' && $dateTo !== '' && $dateFrom > $dateTo)) {
            JsonResponse::error('La période sélectionnée est invalide.', 422);
        }

        $productIdList = implode(',', $productIds);
        $productQuery = $db->prepare('SELECT p.produit_id, p.name, p.sku, p.est_perisable, u.name AS unit_name, u.symbole AS unit_symbol FROM produits p LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE p.entreprise_id = ? AND p.produit_id IN (' . $productIdList . ') ORDER BY p.name');
        $productQuery->bind_param('i', $enterpriseId);
        $productQuery->execute();
        $products = $productQuery->get_result()->fetch_all(MYSQLI_ASSOC);
        if (count($products) !== count($productIds)) JsonResponse::error('Un produit sélectionné ne correspond pas à votre entreprise.', 404);

        $lotSql = "(
            SELECT a.entreprise_id, 'APPROVISIONNEMENT' AS movement_reference_type, a.achat_id AS reference_id, d.produit_id, d.achat_detail_id AS lot_id, d.date_expiration, d.quantity, d.unit_cost
            FROM achats a JOIN achat_details d ON d.achat_id=a.achat_id AND d.entreprise_id=a.entreprise_id
            WHERE a.movement_type='IN' AND a.status='RECEIVED'
            UNION ALL
            SELECT out_a.entreprise_id, 'SORTIE_STOCK', out_a.achat_id, out_detail.produit_id, source_detail.achat_detail_id, source_detail.date_expiration, allocation.quantity, source_detail.unit_cost
            FROM achat_detail_sorties allocation JOIN achat_details out_detail ON out_detail.achat_detail_id=allocation.sortie_detail_id AND out_detail.entreprise_id=allocation.entreprise_id JOIN achats out_a ON out_a.achat_id=out_detail.achat_id AND out_a.entreprise_id=out_detail.entreprise_id JOIN achat_details source_detail ON source_detail.achat_detail_id=allocation.lot_detail_id AND source_detail.entreprise_id=allocation.entreprise_id
            UNION ALL
            SELECT v.entreprise_id, 'VENTE', v.vente_id, vd.produit_id, source_detail.achat_detail_id, source_detail.date_expiration, allocation.quantity, source_detail.unit_cost
            FROM vente_detail_lots allocation JOIN vente_details vd ON vd.vente_detail_id=allocation.vente_detail_id AND vd.entreprise_id=allocation.entreprise_id JOIN ventes v ON v.vente_id=vd.vente_id AND v.entreprise_id=vd.entreprise_id JOIN achat_details source_detail ON source_detail.achat_detail_id=allocation.achat_detail_id AND source_detail.entreprise_id=allocation.entreprise_id
            UNION ALL
            SELECT v.entreprise_id, 'ANNULATION_VENTE', v.vente_id, vd.produit_id, source_detail.achat_detail_id, source_detail.date_expiration, allocation.quantity, source_detail.unit_cost
            FROM vente_detail_lots allocation JOIN vente_details vd ON vd.vente_detail_id=allocation.vente_detail_id AND vd.entreprise_id=allocation.entreprise_id JOIN ventes v ON v.vente_id=vd.vente_id AND v.entreprise_id=vd.entreprise_id JOIN achat_details source_detail ON source_detail.achat_detail_id=allocation.achat_detail_id AND source_detail.entreprise_id=allocation.entreprise_id
        )";
        $sql = 'SELECT m.produit_id, p.name AS product_name, p.sku, p.monais, p.est_perisable, u.name AS unit_name, u.symbole AS unit_symbol, m.movement_date, m.movement_type, m.quantity_before, m.quantity_moved, m.quantity_after, m.reference_type, m.reference_id, CASE WHEN m.movement_type="ENTREE" AND m.reference_type="APPROVISIONNEMENT" THEN COALESCE(f.name,"Fournisseur") WHEN m.movement_type="SORTIE" AND m.reference_type="SORTIE_STOCK" THEN COALESCE(NULLIF(a.motif_sortie,""),m.note,"Sortie stock") WHEN m.reference_type="VENTE" THEN "Vente" WHEN m.reference_type="ANNULATION_VENTE" THEN "Retour vente" ELSE NULL END AS origin_motif, CASE WHEN m.reference_type="AJUSTEMENT" THEN m.note WHEN m.reference_type="SORTIE_STOCK" AND NULLIF(a.motif_sortie,"") IS NOT NULL AND m.note<>a.motif_sortie THEN m.note WHEN m.reference_type NOT IN ("APPROVISIONNEMENT","SORTIE_STOCK","VENTE","ANNULATION_VENTE") THEN m.note ELSE NULL END AS observation, COALESCE(a.purchase_no,v.invoice_no,CONCAT(m.reference_type,IF(m.reference_id IS NULL,"",CONCAT(" #",m.reference_id)))) AS reference_label, CASE WHEN p.est_perisable=1 THEN lots.lot_labels ELSE NULL END AS lot_label, CASE WHEN p.est_perisable=1 THEN lots.expiration_dates ELSE NULL END AS expiration_dates, COALESCE(lots.total_cost/NULLIF(lots.lot_quantity,0),p.cost_price,0) AS unit_cost, s.name AS branch_name FROM mouvements_stock m JOIN produits p ON p.produit_id = m.produit_id AND p.entreprise_id = m.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id JOIN succursales s ON s.succursale_id = m.succursale_id LEFT JOIN achats a ON a.achat_id=m.reference_id AND a.entreprise_id=m.entreprise_id AND m.reference_type IN ("APPROVISIONNEMENT","SORTIE_STOCK") LEFT JOIN fournisseurs f ON f.fournisseur_id=a.fournisseur_id AND f.entreprise_id=a.entreprise_id LEFT JOIN ventes v ON v.vente_id=m.reference_id AND v.entreprise_id=m.entreprise_id AND m.reference_type IN ("VENTE","ANNULATION_VENTE") LEFT JOIN (SELECT entreprise_id,movement_reference_type,reference_id,produit_id,GROUP_CONCAT(DISTINCT CONCAT("LOT-",lot_id) ORDER BY lot_id SEPARATOR ", ") AS lot_labels,GROUP_CONCAT(DISTINCT DATE_FORMAT(date_expiration,"%d/%m/%Y") ORDER BY date_expiration SEPARATOR ", ") AS expiration_dates,SUM(quantity) AS lot_quantity,SUM(quantity*unit_cost) AS total_cost FROM ' . $lotSql . ' lot_allocations GROUP BY entreprise_id,movement_reference_type,reference_id,produit_id) lots ON lots.entreprise_id=m.entreprise_id AND lots.movement_reference_type=m.reference_type AND lots.reference_id=m.reference_id AND lots.produit_id=m.produit_id WHERE m.entreprise_id = ? AND m.produit_id IN (' . $productIdList . ')';
        $parameters = [$enterpriseId];
        $types = 'i';
        if ($branchId !== null) { $sql .= ' AND m.succursale_id = ?'; $parameters[] = $branchId; $types .= 'i'; }
        if ($dateFrom !== '') { $sql .= ' AND m.movement_date >= ?'; $parameters[] = $dateFrom . ' 00:00:00'; $types .= 's'; }
        if ($dateTo !== '') { $sql .= ' AND m.movement_date < DATE_ADD(?, INTERVAL 1 DAY)'; $parameters[] = $dateTo . ' 00:00:00'; $types .= 's'; }
        $sql .= ' ORDER BY p.name, m.movement_date, m.mouvement_stock_id';
        $movementQuery = $db->prepare($sql);
        $bindValues = static function (mysqli_stmt $statement, string $parameterTypes, array &$values): void {
            $references = [$parameterTypes];
            foreach ($values as &$value) $references[] = &$value;
            $statement->bind_param(...$references);
        };
        $bindValues($movementQuery, $types, $parameters);
        $movementQuery->execute();
        $movements = $movementQuery->get_result()->fetch_all(MYSQLI_ASSOC);

        $totals = ['entrees' => 0, 'sorties' => 0, 'ajustements' => 0, 'variation_ajustements' => 0, 'operations' => count($movements), 'solde_net' => 0];
        $productTotals = [];
        foreach ($products as $product) {
            $productTotals[(int) $product['produit_id']] = ['produit_id' => (int) $product['produit_id'], 'name' => $product['name'], 'sku' => $product['sku'], 'unit_name' => $product['unit_name'], 'unit_symbol' => $product['unit_symbol'], 'entrees' => 0, 'sorties' => 0, 'ajustements' => 0, 'variation_ajustements' => 0, 'operations' => 0, 'solde_net' => 0];
        }
        foreach ($movements as $movement) {
            $quantity = (int) $movement['quantity_moved'];
            $key = (int) $movement['produit_id'];
            $productTotals[$key]['operations']++;
            if ($movement['movement_type'] === 'ENTREE') { $totals['entrees'] += $quantity; $productTotals[$key]['entrees'] += $quantity; }
            elseif ($movement['movement_type'] === 'SORTIE') { $totals['sorties'] += $quantity; $productTotals[$key]['sorties'] += $quantity; }
            else {
                $adjustment = (int) $movement['quantity_after'] - (int) $movement['quantity_before'];
                $totals['ajustements'] += $quantity;
                $totals['variation_ajustements'] += $adjustment;
                $productTotals[$key]['ajustements'] += $quantity;
                $productTotals[$key]['variation_ajustements'] += $adjustment;
            }
        }
        $totals['solde_net'] = $totals['entrees'] - $totals['sorties'] + $totals['variation_ajustements'];
        foreach ($productTotals as &$productTotal) $productTotal['solde_net'] = $productTotal['entrees'] - $productTotal['sorties'] + $productTotal['variation_ajustements'];
        unset($productTotal);
        JsonResponse::send(['success' => true, 'data' => ['products' => $products, 'movements' => $movements, 'totals' => $totals, 'product_totals' => array_values($productTotals), 'date_debut' => $dateFrom, 'date_fin' => $dateTo]]);
    }

    if ($action === 'sale-receipt') {
        Authorization::requireAnyPermission($user, ['voir_ventes', 'voir_caisse', 'modifier_caisse']);
        $saleId=(int)($_GET['vente_id']??0); if($saleId<1)JsonResponse::error('Identifiant de vente invalide.',422);
        $sql='SELECT v.vente_id,v.invoice_no,v.sale_date,v.total_amount,v.monais,v.amount_paid,v.status,v.succursale_id,s.name AS branch_name,COALESCE(NULLIF(v.client_comptoir_name, \'\'),c.name) AS client_name,u.full_name AS cashier FROM ventes v JOIN succursales s ON s.succursale_id=v.succursale_id AND s.entreprise_id=v.entreprise_id LEFT JOIN clients c ON c.client_id=v.client_id AND c.entreprise_id=v.entreprise_id LEFT JOIN users u ON u.user_id=v.user_id AND u.entreprise_id=v.entreprise_id WHERE v.entreprise_id=? AND v.vente_id=?';
        if($branchId!==null)$sql.=' AND v.succursale_id=?';$saleQuery=$db->prepare($sql);if($branchId===null)$saleQuery->bind_param('ii',$enterpriseId,$saleId);else$saleQuery->bind_param('iii',$enterpriseId,$saleId,$branchId);$saleQuery->execute();$sale=$saleQuery->get_result()->fetch_assoc();if(!$sale)JsonResponse::error('Vente introuvable dans votre périmètre.',404);
        $details=$db->prepare('SELECT d.quantity,d.unit_price,d.discount_percent,d.discount_amount,d.subtotal,d.monais,p.sku,p.name AS product_name,u.symbole AS unit_symbol,u.name AS unit_name FROM vente_details d JOIN produits p ON p.produit_id=d.produit_id AND p.entreprise_id=d.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id=p.unite_de_mesure AND u.entreprise_id=p.entreprise_id WHERE d.entreprise_id=? AND d.vente_id=? ORDER BY d.vente_detail_id');$details->bind_param('ii',$enterpriseId,$saleId);$details->execute();$detailRows=$details->get_result()->fetch_all(MYSQLI_ASSOC);$payments=$db->prepare('SELECT m.name AS payment_mode,b.name AS bank_name,p.payment_type,p.amount,p.monais,p.reference,p.payment_date FROM paiements_ventes p JOIN modes_paiement m ON m.mode_paiement_id=p.mode_paiement_id LEFT JOIN banques b ON b.banque_id=p.banque_id AND b.entreprise_id=p.entreprise_id WHERE p.entreprise_id=? AND p.vente_id=? ORDER BY p.payment_date,p.paiement_id');$payments->bind_param('ii',$enterpriseId,$saleId);$payments->execute();$paymentRows=$payments->get_result()->fetch_all(MYSQLI_ASSOC);$sale['currency_totals']=$attachCurrencyTotals([$sale])[0]['currency_totals']??[];JsonResponse::send(['success'=>true,'data'=>['sale'=>$sale,'details'=>$detailRows,'payments'=>$paymentRows]]);
    }

    if ($action === 'purchase-voucher') {
        Authorization::requirePermission($user, 'voir_approvisionnements');
        $purchaseId = (int) ($_GET['achat_id'] ?? 0);
        if ($purchaseId < 1) JsonResponse::error('Identifiant d’approvisionnement invalide.', 422);
        $sql = 'SELECT a.achat_id, a.purchase_no, a.purchase_date, a.total_amount, a.movement_type, a.motif_sortie, a.status, f.name AS supplier_name, f.contact_name AS supplier_contact, f.phone AS supplier_phone, s.name AS branch_name FROM achats a JOIN succursales s ON s.succursale_id = a.succursale_id AND s.entreprise_id = a.entreprise_id LEFT JOIN fournisseurs f ON f.fournisseur_id = a.fournisseur_id AND f.entreprise_id = a.entreprise_id WHERE a.entreprise_id = ? AND a.achat_id = ?';
        if ($branchId !== null) $sql .= ' AND a.succursale_id = ?';
        $sql .= ' LIMIT 1';
        $purchaseQuery = $db->prepare($sql);
        if ($branchId === null) $purchaseQuery->bind_param('ii', $enterpriseId, $purchaseId);
        else $purchaseQuery->bind_param('iii', $enterpriseId, $purchaseId, $branchId);
        $purchaseQuery->execute();
        $purchase = $purchaseQuery->get_result()->fetch_assoc();
        if (!$purchase) JsonResponse::error('Approvisionnement introuvable dans votre périmètre.', 404);

        $details = $db->prepare('SELECT d.quantity, d.quantity_out, d.date_expiration, d.unit_cost, d.subtotal, p.sku, p.name AS product_name, p.monais, u.name AS unit_name, u.symbole AS unit_abbreviation FROM achat_details d JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE d.entreprise_id = ? AND d.achat_id = ? ORDER BY d.achat_detail_id');
        $details->bind_param('ii', $enterpriseId, $purchaseId);
        $details->execute();
        $detailRows = $details->get_result()->fetch_all(MYSQLI_ASSOC);
        $allocations = [];
        if ($purchase['movement_type'] === 'OUT') {
            $allocationQuery = $db->prepare('SELECT source_detail.date_expiration, source_purchase.purchase_no, allocation.quantity, p.name AS product_name, p.sku, u.name AS unit_name, u.symbole AS unit_abbreviation FROM achat_detail_sorties allocation JOIN achat_details output_detail ON output_detail.achat_detail_id = allocation.sortie_detail_id AND output_detail.entreprise_id = allocation.entreprise_id JOIN achat_details source_detail ON source_detail.achat_detail_id = allocation.lot_detail_id AND source_detail.entreprise_id = allocation.entreprise_id JOIN achats source_purchase ON source_purchase.achat_id = source_detail.achat_id AND source_purchase.entreprise_id = source_detail.entreprise_id JOIN produits p ON p.produit_id = output_detail.produit_id AND p.entreprise_id = output_detail.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE allocation.entreprise_id = ? AND output_detail.achat_id = ? ORDER BY source_detail.date_expiration ASC, source_detail.achat_detail_id ASC');
            $allocationQuery->bind_param('ii', $enterpriseId, $purchaseId);
            $allocationQuery->execute();
            $allocations = $allocationQuery->get_result()->fetch_all(MYSQLI_ASSOC);
        }
        JsonResponse::send(['success' => true, 'data' => ['purchase' => $purchase, 'details' => $detailRows, 'allocations' => $allocations]]);
    }

    JsonResponse::error('Type de rapport inconnu.', 404);
} catch (Throwable $exception) {
    $message = $exception->getMessage();
    $status = str_contains($message, 'Authentification requise') ? 401
        : (str_contains($message, 'Permission requise') || str_contains($message, 'Accès refusé') || str_contains($message, 'Accès limité') ? 403 : 500);
    JsonResponse::error($message, $status);
}
