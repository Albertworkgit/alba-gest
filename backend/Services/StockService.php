<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;

final class StockService
{
    public function __construct(private readonly mysqli $db)
    {
    }

    /** Retourne les produits et leurs quantités, y compris ceux sans ligne de stock. */
    public function list(int $enterpriseId, ?int $branchId = null, ?int $page = null, int $perPage = 20): array
    {
        $sql = 'SELECT p.produit_id, p.sku, p.name, p.description, p.category_id, c.name AS category_name, p.fournisseur_id, p.unite_de_mesure, u.name AS unit_name, u.symbole AS unit_abbreviation, p.unit_price, p.cost_price, p.monais, p.is_active, st.stock_id, st.succursale_id, b.name AS branch_name, COALESCE(st.quantity, 0) AS quantity, COALESCE(st.min_stock_level, 5) AS min_stock_level, st.updated_at FROM produits p LEFT JOIN categories c ON c.category_id = p.category_id AND c.entreprise_id = p.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id LEFT JOIN stocks st ON st.produit_id = p.produit_id AND st.entreprise_id = p.entreprise_id' . ($branchId !== null ? ' AND st.succursale_id = ?' : '') . ' LEFT JOIN succursales b ON b.succursale_id = st.succursale_id AND b.entreprise_id = p.entreprise_id';
        if ($page !== null) $sql .= ' INNER JOIN (SELECT page_product.produit_id FROM produits page_product WHERE page_product.entreprise_id = ? AND page_product.is_active = 1 ORDER BY page_product.name ASC, page_product.produit_id ASC LIMIT ? OFFSET ?) page_products ON page_products.produit_id = p.produit_id';
        $sql .= ' WHERE p.entreprise_id = ? AND p.is_active = 1';
        $sql .= ' ORDER BY p.name ASC, b.name ASC';
        $offset = $page === null ? 0 : (max(1, $page) - 1) * $perPage;
        $statement = $this->db->prepare($sql);
        if ($page === null && $branchId === null) $statement->bind_param('i', $enterpriseId);
        elseif ($page === null) $statement->bind_param('ii', $branchId, $enterpriseId);
        elseif ($branchId === null) $statement->bind_param('iiii', $enterpriseId, $perPage, $offset, $enterpriseId);
        else $statement->bind_param('iiiii', $branchId, $enterpriseId, $perPage, $offset, $enterpriseId);
        $statement->execute();
        $result = $statement->get_result();
        $rows = $result ? $result->fetch_all(MYSQLI_ASSOC) : [];
        if ($page === null) return $rows;
        $count = $this->db->prepare('SELECT COUNT(*) AS total FROM produits WHERE entreprise_id = ? AND is_active = 1');
        $count->bind_param('i', $enterpriseId);
        $count->execute();
        $total = (int) ($count->get_result()->fetch_assoc()['total'] ?? 0);
        return ['rows' => $rows, 'pagination' => ['page' => max(1, $page), 'per_page' => $perPage, 'total' => $total, 'pages' => max(1, (int) ceil($total / $perPage))]];
    }

    /** Charge des totaux agrégés et seulement dix alertes, sans transférer tous les stocks au navigateur. */
    public function summary(int $enterpriseId, ?int $branchId = null): array
    {
        $productCount = $this->db->prepare('SELECT COUNT(*) AS total FROM produits WHERE entreprise_id = ? AND is_active = 1');
        $productCount->bind_param('i', $enterpriseId);
        $productCount->execute();
        $totalProducts = (int) ($productCount->get_result()->fetch_assoc()['total'] ?? 0);

        $filter = $branchId === null ? '' : ' AND st.succursale_id = ?';
        $groupSql = 'SELECT st.succursale_id, b.name AS branch_name, u.name AS unit_name, u.symbole AS unit_abbreviation, SUM(st.quantity) AS quantity, SUM(CASE WHEN st.quantity <= st.min_stock_level THEN 1 ELSE 0 END) AS alerts FROM stocks st JOIN produits p ON p.produit_id = st.produit_id AND p.entreprise_id = st.entreprise_id AND p.is_active = 1 JOIN succursales b ON b.succursale_id = st.succursale_id AND b.entreprise_id = st.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE st.entreprise_id = ?' . $filter . ' GROUP BY st.succursale_id, p.unite_de_mesure, u.name, u.symbole ORDER BY b.name, u.name';
        $groups = $this->db->prepare($groupSql);
        if ($branchId === null) $groups->bind_param('i', $enterpriseId);
        else $groups->bind_param('ii', $enterpriseId, $branchId);
        $groups->execute();
        $branchTotals = $groups->get_result()->fetch_all(MYSQLI_ASSOC);

        $alertFilter = $branchId === null ? '' : ' AND st.succursale_id = ?';
        $alertCount = $this->db->prepare('SELECT COUNT(*) AS total FROM produits p LEFT JOIN stocks st ON st.produit_id = p.produit_id AND st.entreprise_id = p.entreprise_id' . $alertFilter . ' WHERE p.entreprise_id = ? AND p.is_active = 1 AND COALESCE(st.quantity, 0) <= COALESCE(st.min_stock_level, 5)');
        if ($branchId === null) $alertCount->bind_param('i', $enterpriseId);
        else $alertCount->bind_param('ii', $branchId, $enterpriseId);
        $alertCount->execute();
        $totalAlerts = (int) ($alertCount->get_result()->fetch_assoc()['total'] ?? 0);

        $alertRows = $this->db->prepare('SELECT p.name, b.name AS branch_name, COALESCE(st.quantity, 0) AS quantity, COALESCE(st.min_stock_level, 5) AS min_stock_level, u.name AS unit_name, u.symbole AS unit_abbreviation FROM produits p LEFT JOIN stocks st ON st.produit_id = p.produit_id AND st.entreprise_id = p.entreprise_id' . $alertFilter . ' LEFT JOIN succursales b ON b.succursale_id = st.succursale_id AND b.entreprise_id = st.entreprise_id LEFT JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE p.entreprise_id = ? AND p.is_active = 1 AND COALESCE(st.quantity, 0) <= COALESCE(st.min_stock_level, 5) ORDER BY p.name, b.name LIMIT 10');
        if ($branchId === null) $alertRows->bind_param('i', $enterpriseId);
        else $alertRows->bind_param('ii', $branchId, $enterpriseId);
        $alertRows->execute();

        return [
            'products_count' => $totalProducts,
            'low_stock_count' => $totalAlerts,
            'low_stock_rows' => $alertRows->get_result()->fetch_all(MYSQLI_ASSOC),
            'branches' => $branchTotals,
        ];
    }

    /** Ajoute, retire ou définit une quantité en une transaction. */
    public function adjust(int $enterpriseId, int $branchId, int $productId, string $operation, int $quantity, ?int $minimum = null, int $userId = 0): array
    {
        if ($branchId < 1 || $productId < 1 || $quantity < 0 || !in_array($operation, ['increase', 'decrease', 'set'], true)) {
            throw new RuntimeException('Succursale, produit, opération ou quantité invalide.');
        }

        $this->db->begin_transaction();
        try {
            $ownership = $this->db->prepare('SELECT (SELECT COUNT(*) FROM succursales WHERE succursale_id = ? AND entreprise_id = ?) AS branch_ok, (SELECT COUNT(*) FROM produits WHERE produit_id = ? AND entreprise_id = ? AND is_active = 1) AS product_ok');
            $ownership->bind_param('iiii', $branchId, $enterpriseId, $productId, $enterpriseId);
            $ownership->execute();
            $valid = $ownership->get_result()->fetch_assoc();
            if (!$valid || (int) $valid['branch_ok'] !== 1 || (int) $valid['product_ok'] !== 1) {
                throw new RuntimeException('Le produit ou la succursale ne correspond pas à votre entreprise.');
            }

            $lookup = $this->db->prepare('SELECT stock_id, quantity, min_stock_level FROM stocks WHERE entreprise_id = ? AND succursale_id = ? AND produit_id = ? FOR UPDATE');
            $lookup->bind_param('iii', $enterpriseId, $branchId, $productId);
            $lookup->execute();
            $current = $lookup->get_result()->fetch_assoc();
            $oldQuantity = (int) ($current['quantity'] ?? 0);
            $newQuantity = match ($operation) {
                'increase' => $oldQuantity + $quantity,
                'decrease' => $oldQuantity - $quantity,
                default => $quantity,
            };
            if ($newQuantity < 0) throw new RuntimeException('Stock insuffisant : la quantité ne peut pas devenir négative.');

            $minimumLevel = $minimum ?? (int) ($current['min_stock_level'] ?? 5);
            if ($minimumLevel < 0) throw new RuntimeException('Le seuil minimum doit être positif ou nul.');
            if ($current) {
                $update = $this->db->prepare('UPDATE stocks SET quantity = ?, min_stock_level = ? WHERE stock_id = ? AND entreprise_id = ?');
                $stockId = (int) $current['stock_id'];
                $update->bind_param('iiii', $newQuantity, $minimumLevel, $stockId, $enterpriseId);
                $update->execute();
            } else {
                $insert = $this->db->prepare('INSERT INTO stocks (entreprise_id, succursale_id, produit_id, quantity, min_stock_level) VALUES (?, ?, ?, ?, ?)');
                $insert->bind_param('iiiii', $enterpriseId, $branchId, $productId, $newQuantity, $minimumLevel);
                $insert->execute();
            }

            // Enregistre chaque ajustement afin qu'il apparaisse sur la fiche de stock.
            $movedQuantity = abs($newQuantity - $oldQuantity);
            $note = 'Ajustement manuel : ' . $operation;
            $movementType = 'AJUSTEMENT';
            $movement = $this->db->prepare('INSERT INTO mouvements_stock (entreprise_id, succursale_id, produit_id, user_id, movement_type, quantity_before, quantity_moved, quantity_after, reference_type, note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
            $referenceType = 'AJUSTEMENT';
            $movement->bind_param('iiiisiiiss', $enterpriseId, $branchId, $productId, $userId, $movementType, $oldQuantity, $movedQuantity, $newQuantity, $referenceType, $note);
            $movement->execute();

            $this->db->commit();
            return ['produit_id' => $productId, 'succursale_id' => $branchId, 'previous_quantity' => $oldQuantity, 'quantity' => $newQuantity, 'min_stock_level' => $minimumLevel];
        } catch (\Throwable $exception) {
            $this->db->rollback();
            throw $exception;
        }
    }
}
