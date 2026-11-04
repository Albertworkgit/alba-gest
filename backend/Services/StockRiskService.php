<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use AlbaStock\Core\Authorization;
use mysqli;
use RuntimeException;

final class StockRiskService
{
    private const HISTORY_DAYS = 90;
    private const TARGET_DAYS = 30;
    private const EXPIRY_DAYS = 90;

    public function __construct(private readonly mysqli $db) {}

    public function dashboard(array $actor, ?int $requestedBranchId): array
    {
        $enterpriseId = (int) $actor['entreprise_id'];
        $branchId = Authorization::branchId($actor, $requestedBranchId);
        $origins = Authorization::productOrigins($actor);
        $branches = $this->branches($actor, $enterpriseId);
        if ($branchId === null && $branches !== []) $branchId = (int) $branches[0]['succursale_id'];
        if ($branchId === null) throw new RuntimeException('Aucune succursale n’est disponible pour cette analyse.');
        $branchName = '';
        foreach ($branches as $branch) {
            if ((int) $branch['succursale_id'] === $branchId) $branchName = (string) $branch['name'];
        }
        if ($branchName === '') throw new RuntimeException('Succursale introuvable ou inaccessible.');

        $productsSql = 'SELECT p.produit_id, p.sku, p.name, p.fournisseur_id, p.cost_price, p.monais, p.est_perisable, p.created_at, f.name AS supplier_name, COALESCE(s.quantity, 0) AS stock_available, COALESCE(s.min_stock_level, 5) AS min_stock_level, COALESCE(pending.pending_quantity, 0) AS pending_quantity, COALESCE(pending_transfer_out.pending_quantity, 0) AS pending_transfer_out_quantity, u.name AS unit_name, u.symbole AS unit_abbreviation
            FROM produits p
            LEFT JOIN stocks s ON s.entreprise_id = p.entreprise_id AND s.produit_id = p.produit_id AND s.succursale_id = ?
            LEFT JOIN fournisseurs f ON f.fournisseur_id = p.fournisseur_id AND f.entreprise_id = p.entreprise_id
            LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id
            LEFT JOIN (
                SELECT inbound.product_id, SUM(inbound.pending_quantity) AS pending_quantity
                FROM (
                    SELECT d.produit_id AS product_id, SUM(d.quantity) AS pending_quantity
                    FROM achat_details d JOIN achats a ON a.achat_id = d.achat_id AND a.entreprise_id = d.entreprise_id
                    WHERE d.entreprise_id = ? AND a.succursale_id = ? AND a.movement_type = \'IN\' AND a.status = \'PENDING\'
                    GROUP BY d.produit_id
                    UNION ALL
                    SELECT t.produit_id AS product_id, SUM(t.quantity) AS pending_quantity
                    FROM transferts_stock t
                    JOIN produits transfer_product ON transfer_product.produit_id = t.produit_id AND transfer_product.entreprise_id = t.entreprise_id
                    JOIN succursales transfer_from ON transfer_from.succursale_id = t.succursale_from_id AND transfer_from.entreprise_id = t.entreprise_id
                    JOIN succursales transfer_to ON transfer_to.succursale_id = t.succursale_to_id AND transfer_to.entreprise_id = t.entreprise_id
                    WHERE t.entreprise_id = ? AND t.succursale_to_id = ? AND t.status = \'PENDING\'
                    GROUP BY t.produit_id
                ) inbound GROUP BY inbound.product_id
            ) pending ON pending.product_id = p.produit_id
            LEFT JOIN (
                SELECT t.produit_id, SUM(t.quantity) AS pending_quantity
                FROM transferts_stock t
                JOIN produits transfer_product ON transfer_product.produit_id = t.produit_id AND transfer_product.entreprise_id = t.entreprise_id
                JOIN succursales transfer_from ON transfer_from.succursale_id = t.succursale_from_id AND transfer_from.entreprise_id = t.entreprise_id
                JOIN succursales transfer_to ON transfer_to.succursale_id = t.succursale_to_id AND transfer_to.entreprise_id = t.entreprise_id
                WHERE t.entreprise_id = ? AND t.succursale_from_id = ? AND t.status = \'PENDING\'
                GROUP BY t.produit_id
            ) pending_transfer_out ON pending_transfer_out.produit_id = p.produit_id
            WHERE p.entreprise_id = ? AND p.is_active = 1';
        $productValues = [$branchId, $enterpriseId, $branchId, $enterpriseId, $branchId, $enterpriseId, $branchId, $enterpriseId];
        $productsSql .= $this->originCondition($origins, $productValues, 'p.succursale_origine_id');
        $productsSql .= ' ORDER BY p.name';
        $productsStatement = $this->db->prepare($productsSql);
        $this->bindValues($productsStatement, $productValues);
        $productsStatement->execute();
        $products = $productsStatement->get_result()->fetch_all(MYSQLI_ASSOC);

        $consumptionSql = 'SELECT m.produit_id,
                SUM(CASE
                    WHEN m.reference_type = \'VENTE\' AND m.movement_type = \'SORTIE\' AND v.status <> \'CANCELLED\' THEN m.quantity_moved
                    WHEN m.reference_type = \'SORTIE_STOCK\' AND m.movement_type = \'SORTIE\' AND a.status = \'RECEIVED\' THEN m.quantity_moved
                    ELSE 0
                END) AS consumed_quantity
            FROM mouvements_stock m
            LEFT JOIN ventes v ON m.reference_type = \'VENTE\' AND v.vente_id = m.reference_id AND v.entreprise_id = m.entreprise_id
            LEFT JOIN achats a ON m.reference_type = \'SORTIE_STOCK\' AND a.achat_id = m.reference_id AND a.entreprise_id = m.entreprise_id
            WHERE m.entreprise_id = ? AND m.succursale_id = ? AND m.movement_date >= DATE_SUB(NOW(), INTERVAL ' . self::HISTORY_DAYS . ' DAY)
            GROUP BY m.produit_id';
        $consumption = $this->db->prepare($consumptionSql);
        $consumption->bind_param('ii', $enterpriseId, $branchId);
        $consumption->execute();
        $consumptionByProduct = [];
        foreach ($consumption->get_result()->fetch_all(MYSQLI_ASSOC) as $row) {
            $consumptionByProduct[(int) $row['produit_id']] = (float) $row['consumed_quantity'];
        }

        $expirySql = 'SELECT d.produit_id, p.name AS product_name, p.sku, d.achat_detail_id AS lot_id, d.date_expiration, d.quantity - d.quantity_out AS quantity_remaining, DATEDIFF(d.date_expiration, CURDATE()) AS days_to_expiry
            FROM achat_details d
            JOIN achats a ON a.achat_id = d.achat_id AND a.entreprise_id = d.entreprise_id
            JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id
            WHERE d.entreprise_id = ? AND a.succursale_id = ? AND a.movement_type = \'IN\' AND a.status = \'RECEIVED\'
                AND d.date_expiration IS NOT NULL AND d.date_expiration <= DATE_ADD(CURDATE(), INTERVAL ' . self::EXPIRY_DAYS . ' DAY)
                AND d.quantity > d.quantity_out AND p.is_active = 1';
        $expiryValues = [$enterpriseId, $branchId];
        $expirySql .= $this->originCondition($origins, $expiryValues, 'p.succursale_origine_id');
        $expirySql .= ' ORDER BY d.date_expiration ASC, d.achat_detail_id ASC';
        $expiry = $this->db->prepare($expirySql);
        $this->bindValues($expiry, $expiryValues);
        $expiry->execute();
        $expiryLots = $expiry->get_result()->fetch_all(MYSQLI_ASSOC);

        $rows = [];
        $urgent = $critical = $overstock = $lowRotation = [];
        $expiryProducts = [];
        foreach ($expiryLots as $lot) $expiryProducts[(int) $lot['produit_id']] = true;
        foreach ($products as $product) {
            $productId = (int) $product['produit_id'];
            $quantity = (int) $product['stock_available'];
            $pendingQuantity = (int) $product['pending_quantity'];
            $pendingTransferOut = (int) $product['pending_transfer_out_quantity'];
            $forecastQuantity = max(0, $quantity - $pendingTransferOut);
            $consumed = $consumptionByProduct[$productId] ?? 0.0;
            $ageDays = max(1, min(self::HISTORY_DAYS, (int) floor((time() - strtotime((string) $product['created_at'])) / 86400)));
            $mad = $consumed / $ageDays;
            $cmm = $mad * 30.4375;
            $daysRemaining = $mad > 0 ? round($forecastQuantity / $mad, 1) : null;
            $recommended = $mad > 0
                ? max(0, (int) ceil(($mad * self::TARGET_DAYS) - $forecastQuantity - $pendingQuantity))
                : 0;
            $daysToCritical = $mad > 0 ? $forecastQuantity / $mad : null;
            $criticalStock = $forecastQuantity <= (int) $product['min_stock_level'];
            $risk = $criticalStock || ($daysToCritical !== null && $daysToCritical <= 7)
                ? 'urgent'
                : ($daysToCritical !== null && $daysToCritical <= 30 ? 'soon' : 'safe');
            $isOverstock = $mad > 0 && $forecastQuantity > $mad * 90;
            $isLowRotation = $ageDays >= self::HISTORY_DAYS && $cmm < 1 && $forecastQuantity > 0;
            $row = [
                'produit_id' => $productId,
                'sku' => (string) $product['sku'],
                'name' => (string) $product['name'],
                'branch_name' => $branchName,
                'unit_name' => (string) ($product['unit_name'] ?? ''),
                'unit_abbreviation' => (string) ($product['unit_abbreviation'] ?? ''),
                'supplier_id' => $product['fournisseur_id'] !== null ? (int) $product['fournisseur_id'] : null,
                'supplier_name' => (string) ($product['supplier_name'] ?? ''),
                'stock_available' => $quantity,
                'forecast_available_quantity' => $forecastQuantity,
                'min_stock_level' => (int) $product['min_stock_level'],
                'pending_quantity' => $pendingQuantity,
                'pending_transfer_out_quantity' => $pendingTransferOut,
                'mad' => round($mad, 4),
                'cmm' => round($cmm, 2),
                'days_remaining' => $daysRemaining,
                'recommended_quantity' => $recommended,
                'cost_price' => (float) $product['cost_price'],
                'currency' => (string) $product['monais'],
                'is_perishable' => (bool) $product['est_perisable'],
                'risk' => $risk,
                'critical' => $criticalStock,
                'overstock' => $isOverstock,
                'low_rotation' => $isLowRotation,
                'near_expiry' => isset($expiryProducts[$productId]),
                'history_days' => $ageDays,
            ];
            $rows[] = $row;
            if ($risk === 'urgent') $urgent[] = $row;
            if ($criticalStock) $critical[] = $row;
            if ($isOverstock) $overstock[] = $row;
            if ($isLowRotation) $lowRotation[] = $row;
        }

        $permissions = Authorization::permissions($actor);
        $canViewTreasury = in_array('*', $permissions, true) || in_array('voir_caisse', $permissions, true);
        $balances = $canViewTreasury ? $this->cashBalances($enterpriseId, $branchId) : [];
        $recommendedCosts = [];
        foreach ($rows as $row) {
            $currency = $row['currency'];
            $recommendedCosts[$currency] = ($recommendedCosts[$currency] ?? 0.0)
                + $row['recommended_quantity'] * $row['cost_price'];
        }
        $treasuryWarnings = [];
        foreach ($recommendedCosts as $currency => $amount) {
            if ($amount <= 0) continue;
            $available = $balances[$currency] ?? null;
            $treasuryWarnings[] = [
                'currency' => $currency,
                'estimated_amount' => round($amount, 2),
                'available_balance' => $available,
                'insufficient' => $canViewTreasury && ($available === null || $available < $amount),
            ];
        }

        return [
            'branch_id' => $branchId,
            'branches' => $branches,
            'history_days' => self::HISTORY_DAYS,
            'target_coverage_days' => self::TARGET_DAYS,
            'summary' => [
                'stockout_risks' => count(array_filter($rows, static fn(array $row): bool => $row['risk'] !== 'safe')),
                'critical_stock' => count($critical),
                'overstock' => count($overstock),
                'near_expiry' => count($expiryProducts),
                'low_rotation' => count($lowRotation),
                'recommended_products' => count(array_filter($rows, static fn(array $row): bool => $row['recommended_quantity'] > 0)),
            ],
            'rows' => $rows,
            'urgent' => $urgent,
            'critical' => $critical,
            'overstock' => $overstock,
            'low_rotation' => $lowRotation,
            'expiring_lots' => $expiryLots,
            'treasury' => ['access' => $canViewTreasury, 'cash_balances' => $balances, 'estimated_orders' => $treasuryWarnings],
        ];
    }

    public function orders(array $actor, ?int $requestedBranchId): array
    {
        $enterpriseId = (int) $actor['entreprise_id'];
        $branchId = Authorization::branchId($actor, $requestedBranchId);
        $statement = $this->db->prepare('SELECT o.bon_previsionnel_id, o.reference, o.status, o.created_at, o.transmitted_at, b.name AS branch_name, COUNT(d.detail_previsionnel_id) AS item_count
            FROM bons_commande_previsionnels o
            JOIN succursales b ON b.succursale_id = o.succursale_id AND b.entreprise_id = o.entreprise_id
            LEFT JOIN bon_commande_previsionnel_details d ON d.bon_previsionnel_id = o.bon_previsionnel_id AND d.entreprise_id = o.entreprise_id
            WHERE o.entreprise_id = ? AND (? IS NULL OR o.succursale_id = ?)
            GROUP BY o.bon_previsionnel_id ORDER BY o.created_at DESC LIMIT 20');
        $statement->bind_param('iii', $enterpriseId, $branchId, $branchId);
        $statement->execute();
        $orders = $statement->get_result()->fetch_all(MYSQLI_ASSOC);
        $itemsQuery = $this->db->prepare('SELECT d.produit_id, d.fournisseur_id, d.stock_disponible, d.mad, d.cmm, d.quantite_recommandee, d.quantite_commande, d.unit_cost, d.monais, p.sku, p.name AS product_name, f.name AS supplier_name FROM bon_commande_previsionnel_details d JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id LEFT JOIN fournisseurs f ON f.fournisseur_id = d.fournisseur_id AND f.entreprise_id = d.entreprise_id WHERE d.entreprise_id = ? AND d.bon_previsionnel_id = ? ORDER BY p.name');
        foreach ($orders as &$order) {
            $orderId = (int) $order['bon_previsionnel_id'];
            $itemsQuery->bind_param('ii', $enterpriseId, $orderId);
            $itemsQuery->execute();
            $items = $itemsQuery->get_result()->fetch_all(MYSQLI_ASSOC);
            $totals = [];
            foreach ($items as $item) {
                $currency = (string) $item['monais'];
                $totals[$currency] = ($totals[$currency] ?? 0.0) + (float) $item['quantite_commande'] * (float) $item['unit_cost'];
            }
            $order['items'] = $items;
            $order['estimated_totals'] = $totals;
        }
        unset($order);
        return $orders;
    }

    public function createOrder(array $actor, int $branchId, array $items): array
    {
        $enterpriseId = (int) $actor['entreprise_id'];
        $userId = (int) $actor['id'];
        $branchId = Authorization::branchId($actor, $branchId) ?? 0;
        if ($branchId < 1 || $items === [] || count($items) > 200) {
            throw new RuntimeException('Sélectionnez une succursale et au moins un produit (200 maximum).');
        }
        $analysis = $this->dashboard($actor, $branchId);
        $currentRows = [];
        foreach ($analysis['rows'] as $row) $currentRows[$row['produit_id']] = $row;
        $seenProducts = [];
        $this->db->begin_transaction();
        try {
            $order = $this->db->prepare('INSERT INTO bons_commande_previsionnels (entreprise_id, succursale_id, user_id, reference) VALUES (?, ?, ?, ?)');
            $reference = 'PREV-' . date('Ymd') . '-' . bin2hex(random_bytes(3));
            $order->bind_param('iiis', $enterpriseId, $branchId, $userId, $reference);
            $order->execute();
            $orderId = (int) $this->db->insert_id;
            $reference = 'PREV-' . date('Ymd') . '-' . $orderId;
            $updateReference = $this->db->prepare('UPDATE bons_commande_previsionnels SET reference = ? WHERE bon_previsionnel_id = ? AND entreprise_id = ?');
            $updateReference->bind_param('sii', $reference, $orderId, $enterpriseId);
            $updateReference->execute();

            foreach ($items as $item) {
                if (!is_array($item)) throw new RuntimeException('Ligne de commande invalide.');
                $productId = (int) ($item['product_id'] ?? 0);
                $quantity = filter_var($item['quantity'] ?? null, FILTER_VALIDATE_INT);
                $supplierId = isset($item['supplier_id']) && $item['supplier_id'] !== '' ? (int) $item['supplier_id'] : null;
                $unitCost = filter_var($item['unit_cost'] ?? null, FILTER_VALIDATE_FLOAT);
                $current = $currentRows[$productId] ?? null;
                if (!$current || $quantity === false || $quantity < 1 || $unitCost === false || $unitCost < 0) {
                    throw new RuntimeException('Produit, quantité ou coût invalide dans le bon prévisionnel.');
                }
                if (isset($seenProducts[$productId])) throw new RuntimeException('Un produit ne peut apparaître qu’une fois dans un bon prévisionnel.');
                $seenProducts[$productId] = true;
                if ($supplierId !== null) {
                    $supplier = $this->db->prepare('SELECT fournisseur_id FROM fournisseurs WHERE fournisseur_id = ? AND entreprise_id = ? AND (succursale_id IS NULL OR succursale_id = ?) LIMIT 1');
                    $supplier->bind_param('iii', $supplierId, $enterpriseId, $branchId);
                    $supplier->execute();
                    if (!$supplier->get_result()->fetch_assoc()) throw new RuntimeException('Un fournisseur ne correspond pas à cette succursale.');
                }
                $insert = $this->db->prepare('INSERT INTO bon_commande_previsionnel_details (entreprise_id, bon_previsionnel_id, produit_id, fournisseur_id, stock_disponible, mad, cmm, quantite_recommandee, quantite_commande, unit_cost, monais) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
                $stock = $current['stock_available'];
                $mad = $current['mad'];
                $cmm = $current['cmm'];
                $recommended = $current['recommended_quantity'];
                $currency = $current['currency'];
                $insert->bind_param('iiiiiddiids', $enterpriseId, $orderId, $productId, $supplierId, $stock, $mad, $cmm, $recommended, $quantity, $unitCost, $currency);
                $insert->execute();
            }
            $this->db->commit();
            return ['bon_previsionnel_id' => $orderId, 'reference' => $reference];
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    public function transmitOrder(array $actor, int $orderId): array
    {
        $enterpriseId = (int) $actor['entreprise_id'];
        $userId = (int) $actor['id'];
        $query = $this->db->prepare('SELECT bon_previsionnel_id, succursale_id, reference, status FROM bons_commande_previsionnels WHERE bon_previsionnel_id = ? AND entreprise_id = ? LIMIT 1 FOR UPDATE');
        $this->db->begin_transaction();
        try {
            $query->bind_param('ii', $orderId, $enterpriseId);
            $query->execute();
            $order = $query->get_result()->fetch_assoc();
            if (!$order || $order['status'] !== 'DRAFT') throw new RuntimeException('Bon prévisionnel introuvable ou déjà transmis.');
            $branchId = Authorization::branchId($actor, (int) $order['succursale_id']);
            if ($branchId === null) throw new RuntimeException('Succursale requise pour transmettre la commande.');
            $branchCheck = $this->db->prepare('SELECT succursale_id FROM succursales WHERE succursale_id = ? AND entreprise_id = ? LIMIT 1');
            $branchCheck->bind_param('ii', $branchId, $enterpriseId);
            $branchCheck->execute();
            if (!$branchCheck->get_result()->fetch_assoc()) throw new RuntimeException('Succursale introuvable.');

            $lines = $this->db->prepare('SELECT d.produit_id, d.fournisseur_id, d.quantite_commande, d.unit_cost, d.monais, p.est_perisable, p.succursale_origine_id
                FROM bon_commande_previsionnel_details d JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id
                WHERE d.entreprise_id = ? AND d.bon_previsionnel_id = ? FOR UPDATE');
            $lines->bind_param('ii', $enterpriseId, $orderId);
            $lines->execute();
            $orderLines = $lines->get_result()->fetch_all(MYSQLI_ASSOC);
            if ($orderLines === []) throw new RuntimeException('Le bon ne contient aucun produit.');

            foreach ($orderLines as $index => $line) {
                if (!Authorization::canUseProductFromBranch($actor, (int) $line['succursale_origine_id'])) {
                    throw new RuntimeException('Accès limité à votre succursale : un produit du bon n’est plus accessible.');
                }
                $quantity = (int) $line['quantite_commande'];
                $unitCost = (float) $line['unit_cost'];
                if ($quantity < 1 || $unitCost <= 0) {
                    throw new RuntimeException('Un coût d’achat supérieur à zéro est requis avant de transmettre le bon.');
                }
                if ($line['fournisseur_id'] !== null) {
                    $supplierId = (int) $line['fournisseur_id'];
                    $supplier = $this->db->prepare('SELECT fournisseur_id FROM fournisseurs WHERE fournisseur_id = ? AND entreprise_id = ? AND (succursale_id IS NULL OR succursale_id = ?) LIMIT 1');
                    $supplier->bind_param('iii', $supplierId, $enterpriseId, $branchId);
                    $supplier->execute();
                    if (!$supplier->get_result()->fetch_assoc()) throw new RuntimeException('Un fournisseur du bon n’est plus disponible pour cette succursale.');
                }
                $purchaseNo = $order['reference'] . '-' . str_pad((string) ($index + 1), 3, '0', STR_PAD_LEFT);
                $total = $quantity * $unitCost;
                $supplierId = $line['fournisseur_id'] !== null ? (int) $line['fournisseur_id'] : null;
                if ($supplierId === null) {
                    $purchase = $this->db->prepare('INSERT INTO achats (entreprise_id, succursale_id, fournisseur_id, user_id, purchase_no, total_amount, monais, movement_type, status) VALUES (?, ?, NULL, ?, ?, ?, ?, \'IN\', \'PENDING\')');
                    $purchase->bind_param('iiisds', $enterpriseId, $branchId, $userId, $purchaseNo, $total, $line['monais']);
                } else {
                    $purchase = $this->db->prepare('INSERT INTO achats (entreprise_id, succursale_id, fournisseur_id, user_id, purchase_no, total_amount, monais, movement_type, status) VALUES (?, ?, ?, ?, ?, ?, ?, \'IN\', \'PENDING\')');
                    $purchase->bind_param('iiiisds', $enterpriseId, $branchId, $supplierId, $userId, $purchaseNo, $total, $line['monais']);
                }
                $purchase->execute();
                $purchaseId = (int) $this->db->insert_id;
                $subtotal = $total;
                $detail = $this->db->prepare('INSERT INTO achat_details (entreprise_id, achat_id, produit_id, quantity, date_expiration, unit_cost, subtotal) VALUES (?, ?, ?, ?, NULL, ?, ?)');
                $detail->bind_param('iiiidd', $enterpriseId, $purchaseId, $line['produit_id'], $quantity, $unitCost, $subtotal);
                $detail->execute();
            }
            $update = $this->db->prepare('UPDATE bons_commande_previsionnels SET status = \'TRANSMITTED\', transmitted_at = NOW() WHERE bon_previsionnel_id = ? AND entreprise_id = ? AND status = \'DRAFT\'');
            $update->bind_param('ii', $orderId, $enterpriseId);
            $update->execute();
            if ($update->affected_rows !== 1) throw new RuntimeException('Le bon a déjà été transmis.');
            $this->db->commit();
            return ['reference' => (string) $order['reference'], 'purchase_count' => count($orderLines)];
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }

    private function branches(array $actor, int $enterpriseId): array
    {
        $sql = 'SELECT succursale_id, name FROM succursales WHERE entreprise_id = ?';
        $values = [$enterpriseId];
        if (!Authorization::canSeeAllBranches($actor)) {
            $sql .= ' AND succursale_id = ?';
            $values[] = (int) $actor['succursale_id'];
        }
        $sql .= ' ORDER BY est_sucursal_mere DESC, name';
        $statement = $this->db->prepare($sql);
        $this->bindValues($statement, $values);
        $statement->execute();
        return $statement->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    private function cashBalances(int $enterpriseId, int $branchId): array
    {
        $statement = $this->db->prepare('SELECT t.code AS currency, SUM(c.montant) AS available_balance FROM caisses c JOIN types_caisses t ON t.type_caisse_id = c.type_caisse_id AND t.entreprise_id = c.entreprise_id WHERE c.entreprise_id = ? AND c.succursale_id = ? AND c.statut = \'OUVERTE\' GROUP BY t.code');
        $statement->bind_param('ii', $enterpriseId, $branchId);
        $statement->execute();
        $balances = [];
        foreach ($statement->get_result()->fetch_all(MYSQLI_ASSOC) as $row) {
            $balances[(string) $row['currency']] = (float) $row['available_balance'];
        }
        return $balances;
    }

    private function originCondition(?array $origins, array &$values, string $column): string
    {
        if ($origins === null) return '';
        if ($origins === []) return ' AND 1 = 0';
        $values = [...$values, ...$origins];
        return ' AND ' . $column . ' IN (' . implode(', ', array_fill(0, count($origins), '?')) . ')';
    }

    private function bindValues(\mysqli_stmt $statement, array $values): void
    {
        if ($values === []) return;
        $types = '';
        foreach ($values as $value) $types .= is_int($value) ? 'i' : (is_float($value) ? 'd' : 's');
        $references = [$types];
        foreach ($values as $key => &$value) $references[] = &$value;
        $statement->bind_param(...$references);
    }
}
