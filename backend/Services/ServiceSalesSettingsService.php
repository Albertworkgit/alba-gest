<?php
declare(strict_types=1);

namespace AlbaStock\Services;

use mysqli;
use RuntimeException;
use AlbaStock\Core\Authorization;

final class ServiceSalesSettingsService
{
    public function __construct(private readonly mysqli $db) {}

    public function settings(array $actor): array
    {
        $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
        $enterprise = $this->db->prepare('SELECT vente_services_autorisee FROM entreprises WHERE entreprise_id = ? LIMIT 1');
        $enterprise->bind_param('i', $enterpriseId);
        $enterprise->execute();
        $enterpriseEnabled = (int) ($enterprise->get_result()->fetch_assoc()['vente_services_autorisee'] ?? 0) === 1;

        $currentBranchId = (int) ($actor['succursale_id'] ?? 0);
        $branchId = Authorization::canSeeAllBranches($actor) ? null : $currentBranchId;
        $sql = 'SELECT succursale_id, name, vente_services_autorisee FROM succursales WHERE entreprise_id = ?';
        if ($branchId !== null) $sql .= ' AND succursale_id = ?';
        $sql .= ' ORDER BY est_sucursal_mere DESC, succursale_id';
        $branchesQuery = $this->db->prepare($sql);
        if ($branchId === null) $branchesQuery->bind_param('i', $enterpriseId);
        else $branchesQuery->bind_param('ii', $enterpriseId, $branchId);
        $branchesQuery->execute();
        $branches = array_map(
            fn (array $branch): array => [
                'succursale_id' => (int) $branch['succursale_id'],
                'name' => (string) $branch['name'],
                'branch_enabled' => (bool) $branch['vente_services_autorisee'],
                'service_sales_allowed' => $enterpriseEnabled && (bool) $branch['vente_services_autorisee'],
                'is_current' => (int) $branch['succursale_id'] === $currentBranchId,
            ],
            $branchesQuery->get_result()->fetch_all(MYSQLI_ASSOC)
        );

        return [
            'enterprise_enabled' => $enterpriseEnabled,
            'branches' => $branches,
        ];
    }

    public function update(array $actor, array $data): array
    {
        $isCompanyAdmin = !empty($actor['is_company_admin']);
        $isBranchAdmin = !empty($actor['is_branch_admin']);
        if (!$isCompanyAdmin && !$isBranchAdmin) {
            throw new RuntimeException('Accès refusé : seuls les administrateurs peuvent modifier ce paramètre.');
        }

        $field = $isCompanyAdmin ? 'enterprise_enabled' : 'branch_enabled';
        if (!array_key_exists($field, $data) || !in_array($data[$field], [true, false, 0, 1, '0', '1'], true)) {
            throw new RuntimeException('La valeur du paramètre de vente de services est invalide.');
        }
        $enabled = in_array($data[$field], [true, 1, '1'], true) ? 1 : 0;

        if ($isCompanyAdmin) {
            $enterpriseId = (int) $actor['entreprise_id'];
            $statement = $this->db->prepare('UPDATE entreprises SET vente_services_autorisee = ? WHERE entreprise_id = ?');
            $statement->bind_param('ii', $enabled, $enterpriseId);
        } else {
            $enterpriseId = (int) $actor['entreprise_id'];
            $branchId = (int) ($actor['succursale_id'] ?? 0);
            if ($branchId < 1) throw new RuntimeException('Aucune succursale n’est associée à ce compte.');
            $statement = $this->db->prepare('UPDATE succursales SET vente_services_autorisee = ? WHERE entreprise_id = ? AND succursale_id = ?');
            $statement->bind_param('iii', $enabled, $enterpriseId, $branchId);
        }
        $statement->execute();

        return $this->settings($actor);
    }

    public function requireAllowed(int $enterpriseId, int $branchId): void
    {
        $statement = $this->db->prepare('SELECT e.vente_services_autorisee AS enterprise_enabled, s.vente_services_autorisee AS branch_enabled FROM entreprises e INNER JOIN succursales s ON s.entreprise_id = e.entreprise_id WHERE e.entreprise_id = ? AND s.succursale_id = ? LIMIT 1');
        $statement->bind_param('ii', $enterpriseId, $branchId);
        $statement->execute();
        $settings = $statement->get_result()->fetch_assoc();
        if (!$settings) throw new RuntimeException('Succursale invalide pour cette entreprise.');
        if (!(bool) $settings['enterprise_enabled'] || !(bool) $settings['branch_enabled']) {
            throw new RuntimeException('Accès refusé : la vente de services n’est pas autorisée pour cette entreprise ou cette succursale.');
        }
    }
}
