<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;

final class ReportService
{
    public function __construct(private readonly mysqli $db)
    {
    }

    public function sales(int $enterpriseId, ?int $branchId = null): array
    {
        $sql = 'SELECT v.vente_id, v.invoice_no, v.sale_date, v.total_amount, v.amount_paid, v.monais, v.status, s.name AS succursale, COALESCE(NULLIF(v.client_comptoir_name, \'\'), c.name) AS client, u.full_name AS seller_name, COALESCE(products.product_names, \'\') AS product_names FROM ventes v JOIN succursales s ON s.succursale_id = v.succursale_id AND s.entreprise_id = v.entreprise_id LEFT JOIN clients c ON c.client_id = v.client_id AND c.entreprise_id = v.entreprise_id LEFT JOIN users u ON u.user_id = v.user_id AND u.entreprise_id = v.entreprise_id LEFT JOIN (SELECT d.entreprise_id, d.vente_id, GROUP_CONCAT(DISTINCT p.name ORDER BY p.name SEPARATOR \', \') AS product_names FROM vente_details d JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id GROUP BY d.entreprise_id, d.vente_id) products ON products.entreprise_id = v.entreprise_id AND products.vente_id = v.vente_id WHERE v.entreprise_id = ?';
        if ($branchId !== null) {
            $sql .= ' AND v.succursale_id = ?';
        }
        $sql .= ' ORDER BY v.sale_date DESC';
        $statement = $this->db->prepare($sql);
        if ($branchId === null) {
            $statement->bind_param('i', $enterpriseId);
        } else {
            $statement->bind_param('ii', $enterpriseId, $branchId);
        }
        $statement->execute();
        $result = $statement->get_result();
        $sales = $result ? $result->fetch_all(MYSQLI_ASSOC) : [];
        if ($sales === []) {
            return $sales;
        }

        $saleIds = implode(',', array_map(static fn (array $sale): int => (int) $sale['vente_id'], $sales));
        $balances = $this->db->prepare('SELECT vente_id, monais, total_amount, amount_paid FROM vente_totaux_monnaies WHERE entreprise_id = ? AND vente_id IN (' . $saleIds . ') ORDER BY vente_id, monais');
        $balances->bind_param('i', $enterpriseId);
        $balances->execute();
        $balancesBySale = [];
        foreach ($balances->get_result()->fetch_all(MYSQLI_ASSOC) as $balance) {
            $balancesBySale[(int) $balance['vente_id']][] = $balance;
        }

        $payments = $this->db->prepare('SELECT vente_id, COALESCE(NULLIF(monais_facture, \'\'), monais) AS monais, SUM(CASE WHEN payment_type = \'REFUND\' THEN -COALESCE(amount_applied, amount) ELSE COALESCE(amount_applied, amount) END) AS amount_paid FROM paiements_ventes WHERE entreprise_id = ? AND vente_id IN (' . $saleIds . ') GROUP BY vente_id, COALESCE(NULLIF(monais_facture, \'\'), monais) ORDER BY vente_id, monais');
        $payments->bind_param('i', $enterpriseId);
        $payments->execute();
        $paymentsBySale = [];
        foreach ($payments->get_result()->fetch_all(MYSQLI_ASSOC) as $payment) {
            $paymentsBySale[(int) $payment['vente_id']][] = $payment;
        }

        foreach ($sales as &$sale) {
            $saleId = (int) $sale['vente_id'];
            $sale['currency_totals'] = $balancesBySale[$saleId] ?? [];
            $sale['paid_currency_totals'] = $paymentsBySale[$saleId] ?? [];
            if ($sale['currency_totals'] === [] && !empty($sale['monais'])) {
                $sale['currency_totals'][] = [
                    'monais' => $sale['monais'],
                    'total_amount' => $sale['total_amount'],
                    'amount_paid' => $sale['amount_paid'],
                ];
            }
            if ($sale['paid_currency_totals'] === []) {
                $sale['paid_currency_totals'] = array_values(array_filter(
                    array_map(
                        static fn (array $balance): array => ['monais' => $balance['monais'], 'amount_paid' => $balance['amount_paid']],
                        $sale['currency_totals']
                    ),
                    static fn (array $balance): bool => (float) $balance['amount_paid'] > 0
                ));
                if ($sale['paid_currency_totals'] === [] && !empty($sale['monais']) && (float) $sale['amount_paid'] > 0) {
                    $sale['paid_currency_totals'][] = [
                        'monais' => $sale['monais'],
                        'amount_paid' => $sale['amount_paid'],
                    ];
                }
            }
        }
        unset($sale);

        return $sales;
    }
}
