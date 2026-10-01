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
        $sql = 'SELECT v.invoice_no, v.sale_date, v.total_amount, v.amount_paid, v.status, s.name AS succursale, c.name AS client FROM ventes v JOIN succursales s ON s.succursale_id = v.succursale_id AND s.entreprise_id = v.entreprise_id LEFT JOIN clients c ON c.client_id = v.client_id AND c.entreprise_id = v.entreprise_id WHERE v.entreprise_id = :enterprise_id';
        if ($branchId !== null) {
            $sql .= ' AND v.succursale_id = :branch_id';
        }
        $sql .= ' ORDER BY v.sale_date DESC';
        $sql = str_replace([':enterprise_id', ':branch_id'], ['?', '?'], $sql);
        $statement = $this->db->prepare($sql);
        if ($branchId === null) {
            $statement->bind_param('i', $enterpriseId);
        } else {
            $statement->bind_param('ii', $enterpriseId, $branchId);
        }
        $statement->execute();
        $result = $statement->get_result();
        return $result ? $result->fetch_all(MYSQLI_ASSOC) : [];
    }
}
