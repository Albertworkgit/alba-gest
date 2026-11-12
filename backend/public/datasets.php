<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';
require_once __DIR__ . '/../Core/DatasetSpreadsheet.php';

use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Core\Database;
use AlbaStock\Core\DatasetSpreadsheet;
use AlbaStock\Core\JsonResponse;
$method = $_SERVER['REQUEST_METHOD'];
$action = trim((string) ($_GET['action'] ?? ''));
$db = null;
$transaction = false;

try {
    $actor = AuthGuard::requireAuthenticated();
    $db = Database::connection();
    $isSuperAdmin = ($actor['type'] ?? '') === 'super_admin';

    if ($isSuperAdmin) {
        if ($method === 'GET' && $action === 'template') {
            DatasetSpreadsheet::download('modele-jeu-de-donnees', spreadsheetRows([
                ['type' => 'category', 'name' => 'Boissons', 'description' => 'Catégorie de démonstration'],
                ['type' => 'unit', 'name' => 'Litre', 'unit_symbol' => 'L'],
                ['type' => 'product', 'name' => 'Eau minérale', 'reference' => 'EAU-001', 'category' => 'Boissons', 'unit' => 'Litre', 'unit_symbol' => 'L', 'sale_price' => '1.50', 'cost_price' => '1.00'],
            ]));
        }
        if ($method === 'GET' && $action === 'source-enterprises') {
            $result = $db->query('SELECT entreprise_id, name, activity_type FROM entreprises ORDER BY name');
            JsonResponse::send(['success' => true, 'data' => $result->fetch_all(MYSQLI_ASSOC)]);
        }
        if ($method === 'GET' && $action === 'export') {
            exportDataset($db, (int) ($_GET['id'] ?? 0), (int) ($_GET['version_id'] ?? 0));
        }
        if ($method === 'GET' && $action === 'export-xlsx') {
            exportDatasetXlsx($db, (int) ($_GET['id'] ?? 0), (int) ($_GET['version_id'] ?? 0));
        }
        if ($method === 'POST' && $action === 'preview-csv') {
            previewCsv();
        }
        if ($method === 'DELETE' && $action === 'delete') {
            $body = json_decode((string) file_get_contents('php://input'), true);
            if (!is_array($body)) JsonResponse::error('Corps JSON invalide.', 400);
            deleteInactiveDataset($db, (int) ($body['id'] ?? 0));
        }
        if ($method === 'GET') {
            $datasetId = (int) ($_GET['id'] ?? 0);
            JsonResponse::send(['success' => true, 'data' => $datasetId > 0
                ? datasetDetails($db, $datasetId, true)
                : datasetList($db, null, true)]);
        }
        if (in_array($method, ['POST', 'PUT', 'PATCH'], true)) {
            $body = json_decode((string) file_get_contents('php://input'), true);
            if (!is_array($body)) JsonResponse::error('Corps JSON invalide.', 400);
            if ($action === 'from-enterprise' && $method === 'POST') {
                $result = datasetFromEnterprise($db, $actor, $body);
                JsonResponse::send(['success' => true, 'data' => $result], 201);
            }
            if ($action === 'status') {
                $id = (int) ($body['id'] ?? 0);
                $active = filter_var($body['is_active'] ?? null, FILTER_VALIDATE_BOOL, FILTER_NULL_ON_FAILURE);
                if ($id < 1 || $active === null) JsonResponse::error('Jeu de données et statut valides requis.', 422);
                if ($active) {
                    $versionQuery = $db->prepare('SELECT jeu_donnees_version_id FROM jeux_donnees_versions WHERE jeu_donnees_id = ? ORDER BY version_number DESC LIMIT 1');
                    $versionQuery->bind_param('i', $id);
                    $versionQuery->execute();
                    $version = $versionQuery->get_result()->fetch_assoc();
                    if (!$version || versionItems($db, (int) $version['jeu_donnees_version_id']) === []) {
                        JsonResponse::error('Enregistrez au moins une ligne valide avant de publier ce jeu de données.', 422);
                    }
                }
                $statement = $db->prepare('UPDATE jeux_donnees SET is_active = ? WHERE jeu_donnees_id = ?');
                $activeInt = $active ? 1 : 0;
                $statement->bind_param('ii', $activeInt, $id);
                $statement->execute();
                if ($statement->affected_rows === 0 && !datasetExists($db, $id)) JsonResponse::error('Jeu de données introuvable.', 404);
                JsonResponse::send(['success' => true, 'message' => 'Statut mis à jour.']);
            }
            if ($action !== '') JsonResponse::error('Action inconnue.', 404);
            $result = saveDataset($db, $actor, $body);
            JsonResponse::send(['success' => true, 'data' => $result], $method === 'POST' ? 201 : 200);
        }
        JsonResponse::error('Méthode HTTP non supportée.', 405);
    }

    if (($actor['type'] ?? '') !== 'user') JsonResponse::error('Authentification requise.', 401);
    Authorization::requirePermission($actor, 'voir_stock');
    $enterpriseId = (int) ($actor['entreprise_id'] ?? 0);
    if ($enterpriseId < 1) JsonResponse::error('Entreprise introuvable.', 403);
    $activityQuery = $db->prepare('SELECT activity_type FROM entreprises WHERE entreprise_id = ? LIMIT 1');
    $activityQuery->bind_param('i', $enterpriseId);
    $activityQuery->execute();
    $activityType = (string) ($activityQuery->get_result()->fetch_assoc()['activity_type'] ?? 'other');

    if ($method === 'GET' && $action === 'history') {
        $historySql = 'SELECT i.importation_id, i.jeu_donnees_id, i.jeu_donnees_version_id, i.succursale_id, i.branch_name, i.user_name, i.resultat_json, i.created_at, d.name AS dataset_name, v.version_number FROM jeux_donnees_importations i JOIN jeux_donnees d ON d.jeu_donnees_id = i.jeu_donnees_id JOIN jeux_donnees_versions v ON v.jeu_donnees_version_id = i.jeu_donnees_version_id WHERE i.entreprise_id = ?';
        if (Authorization::canSeeAllBranches($actor)) {
            $statement = $db->prepare($historySql . ' ORDER BY i.created_at DESC LIMIT 100');
            $statement->bind_param('i', $enterpriseId);
        } else {
            $historySql .= ' AND i.succursale_id = ?';
            $statement = $db->prepare($historySql . ' ORDER BY i.created_at DESC LIMIT 100');
            $actorBranchId = (int) ($actor['succursale_id'] ?? 0);
            $statement->bind_param('ii', $enterpriseId, $actorBranchId);
        }
        $statement->execute();
        $rows = $statement->get_result()->fetch_all(MYSQLI_ASSOC);
        foreach ($rows as &$row) $row['resultat'] = json_decode((string) $row['resultat_json'], true) ?: [];
        unset($row);
        JsonResponse::send(['success' => true, 'data' => $rows]);
    }
    if ($method === 'GET' && $action === 'references') {
        $referenceSql = 'SELECT r.reference_type, r.name, r.details_json, r.created_at, s.name AS branch_name FROM jeux_donnees_references r JOIN succursales s ON s.succursale_id = r.succursale_id AND s.entreprise_id = r.entreprise_id WHERE r.entreprise_id = ?';
        if (!Authorization::canSeeAllBranches($actor)) {
            $referenceSql .= ' AND r.succursale_id = ?';
            $referenceQuery = $db->prepare($referenceSql . ' ORDER BY r.created_at DESC LIMIT 500');
            $actorBranchId = (int) ($actor['succursale_id'] ?? 0);
            $referenceQuery->bind_param('ii', $enterpriseId, $actorBranchId);
        } else {
            $referenceQuery = $db->prepare($referenceSql . ' ORDER BY r.created_at DESC LIMIT 500');
            $referenceQuery->bind_param('i', $enterpriseId);
        }
        $referenceQuery->execute();
        $references = $referenceQuery->get_result()->fetch_all(MYSQLI_ASSOC);
        foreach ($references as &$reference) $reference['details'] = json_decode((string) $reference['details_json'], true) ?: [];
        unset($reference);
        JsonResponse::send(['success' => true, 'data' => $references]);
    }
    if ($method === 'GET') {
        $datasetId = (int) ($_GET['id'] ?? 0);
        if ($action === 'export') {
            exportDataset($db, $datasetId, (int) ($_GET['version_id'] ?? 0), false, $activityType);
        }
        if ($action === 'export-xlsx') {
            exportDatasetXlsx($db, $datasetId, (int) ($_GET['version_id'] ?? 0), false, $activityType);
        }
        if ($datasetId > 0) {
            $dataset = datasetDetails($db, $datasetId, false, $activityType);
            JsonResponse::send(['success' => true, 'data' => $dataset]);
        }
        $sector = sectorForActivity($activityType);
        JsonResponse::send(['success' => true, 'data' => datasetList($db, $sector, false)]);
    }
    if ($method === 'POST' && $action === 'import') {
        if (empty($actor['is_company_admin'])) JsonResponse::error('Seul l’administrateur de l’entreprise peut importer un jeu de données.', 403);
        Authorization::requirePermission($actor, 'modifier_stock');
        importDataset($db, $actor, $enterpriseId);
    }
    JsonResponse::error('Méthode HTTP non supportée.', 405);
} catch (Throwable $exception) {
    if ($transaction && $db instanceof mysqli) {
        try { $db->rollback(); } catch (Throwable) { /* La transaction a pu être annulée par le serveur. */ }
    }
    if ($exception instanceof mysqli_sql_exception) JsonResponse::error(JsonResponse::messageFor($exception), 500);
    if (str_starts_with($exception->getMessage(), 'Accès refusé') || str_starts_with($exception->getMessage(), 'Seul l’administrateur')) {
        JsonResponse::error($exception->getMessage(), 403);
    }
    if (str_starts_with($exception->getMessage(), 'Authentification requise')) JsonResponse::error($exception->getMessage(), 401);
    JsonResponse::error($exception->getMessage(), 422);
}

function datasetExists(mysqli $db, int $id): bool
{
    $statement = $db->prepare('SELECT jeu_donnees_id FROM jeux_donnees WHERE jeu_donnees_id = ? LIMIT 1');
    $statement->bind_param('i', $id);
    $statement->execute();
    return (bool) $statement->get_result()->fetch_assoc();
}

function deleteInactiveDataset(mysqli $db, int $datasetId): never
{
    global $transaction;
    if ($datasetId < 1) JsonResponse::error('Jeu de données invalide.', 422);

    $db->begin_transaction();
    $transaction = true;
    $datasetQuery = $db->prepare('SELECT is_active FROM jeux_donnees WHERE jeu_donnees_id = ? FOR UPDATE');
    $datasetQuery->bind_param('i', $datasetId);
    $datasetQuery->execute();
    $dataset = $datasetQuery->get_result()->fetch_assoc();
    if (!$dataset) {
        $db->rollback();
        $transaction = false;
        JsonResponse::error('Jeu de données introuvable.', 404);
    }
    if ((int) $dataset['is_active'] !== 0) {
        $db->rollback();
        $transaction = false;
        JsonResponse::error('Seuls les jeux de données inactifs peuvent être supprimés.', 409);
    }

    $usageQuery = $db->prepare('SELECT (SELECT COUNT(*) FROM jeux_donnees_importations WHERE jeu_donnees_id = ?) + (SELECT COUNT(*) FROM jeux_donnees_references WHERE jeu_donnees_id = ?) AS usage_count');
    $usageQuery->bind_param('ii', $datasetId, $datasetId);
    $usageQuery->execute();
    $usageCount = (int) $usageQuery->get_result()->fetch_assoc()['usage_count'];
    if ($usageCount > 0) {
        $db->rollback();
        $transaction = false;
        JsonResponse::error('Ce jeu ne peut pas être supprimé, car il possède un historique d’importation ou des références utilisées par des entreprises.', 409);
    }

    $deleteQuery = $db->prepare('DELETE FROM jeux_donnees WHERE jeu_donnees_id = ? AND is_active = 0');
    $deleteQuery->bind_param('i', $datasetId);
    $deleteQuery->execute();
    if ($deleteQuery->affected_rows !== 1) {
        $db->rollback();
        $transaction = false;
        JsonResponse::error('Le jeu a changé de statut ou est introuvable. Actualisez la liste puis réessayez.', 409);
    }

    $db->commit();
    $transaction = false;
    JsonResponse::send(['success' => true, 'message' => 'Jeu de données supprimé.']);
}

function spreadsheetRows(array $items): array
{
    $keys = ['type', 'name', 'reference', 'description', 'category', 'unit', 'unit_symbol', 'sale_price', 'cost_price', 'currency', 'perishable'];
    $rows = [['Type', 'Nom', 'Référence', 'Description', 'Catégorie', 'Unité', 'Symbole unité', 'Prix de vente', 'Prix de revient', 'Monnaie', 'Périssable']];
    foreach ($items as $item) {
        $rows[] = array_map(static fn (string $key): mixed => $item[$key] ?? '', $keys);
    }
    return $rows;
}

function datasetFromEnterprise(mysqli $db, array $actor, array $body): array
{
    $enterpriseId = (int) ($body['entreprise_id'] ?? 0);
    $name = trim((string) ($body['name'] ?? ''));
    $category = trim((string) ($body['categorie'] ?? 'Catalogue importé'));
    $description = trim((string) ($body['description'] ?? ''));
    if ($enterpriseId < 1 || $name === '') throw new RuntimeException('Choisissez une entreprise source et donnez un nom au jeu de données.');
    $sourceQuery = $db->prepare('SELECT name, activity_type FROM entreprises WHERE entreprise_id = ? LIMIT 1');
    $sourceQuery->bind_param('i', $enterpriseId);
    $sourceQuery->execute();
    $source = $sourceQuery->get_result()->fetch_assoc();
    if (!$source) throw new RuntimeException('Entreprise source introuvable.');
    $sector = sectorForActivity((string) $source['activity_type']);
    $items = [];
    $categories = $db->prepare('SELECT name FROM categories WHERE entreprise_id = ? ORDER BY name');
    $categories->bind_param('i', $enterpriseId);
    $categories->execute();
    foreach ($categories->get_result()->fetch_all(MYSQLI_ASSOC) as $row) {
        $items[] = ['type' => 'category', 'name' => $row['name']];
    }
    $units = $db->prepare('SELECT name, symbole FROM unites_mesure WHERE entreprise_id = ? ORDER BY name');
    $units->bind_param('i', $enterpriseId);
    $units->execute();
    foreach ($units->get_result()->fetch_all(MYSQLI_ASSOC) as $row) {
        $items[] = ['type' => 'unit', 'name' => $row['name'], 'unit_symbol' => $row['symbole']];
    }
    $products = $db->prepare('SELECT p.sku, p.name, p.unit_price, p.monais, p.est_perisable, c.name AS category_name, u.name AS unit_name, u.symbole AS unit_symbol FROM produits p LEFT JOIN categories c ON c.category_id = p.category_id AND c.entreprise_id = p.entreprise_id INNER JOIN unites_mesure u ON u.unite_mesure_id = p.unite_de_mesure AND u.entreprise_id = p.entreprise_id WHERE p.entreprise_id = ? AND p.is_active = 1 AND p.cost_price <= 0 AND p.sku <> \'\' ORDER BY p.name, p.sku LIMIT 5001');
    $products->bind_param('i', $enterpriseId);
    $products->execute();
    foreach ($products->get_result()->fetch_all(MYSQLI_ASSOC) as $row) {
        $items[] = [
            'type' => 'product',
            'name' => $row['name'],
            'reference' => $row['sku'],
            'description' => '',
            'category' => $row['category_name'] ?? '',
            'unit' => $row['unit_name'] ?? '',
            'unit_symbol' => $row['unit_symbol'] ?? '',
            'sale_price' => $row['unit_price'],
            'cost_price' => 0,
            'currency' => $row['monais'],
            'perishable' => (int) $row['est_perisable'],
        ];
    }
    if (count($items) > 5000) {
        throw new RuntimeException('Le catalogue source dépasse 5 000 lignes. Réduisez le catalogue avant de générer un jeu de données.');
    }
    if (!$items) throw new RuntimeException('Cette entreprise ne possède aucune catégorie, unité ou produit actif sans prix de revient à exporter.');
    $dataset = saveDataset($db, $actor, [
        'name' => $name,
        'description' => $description !== '' ? $description : 'Catalogue de référence généré depuis les catégories, unités et produits disponibles.',
        'secteur_activite' => $sector,
        'categorie' => $category,
        'items' => $items,
    ]);
    $dataset['source_enterprise'] = $source['name'];
    $dataset['counts'] = [
        'categories' => count(array_filter($items, static fn (array $item): bool => $item['type'] === 'category')),
        'units' => count(array_filter($items, static fn (array $item): bool => $item['type'] === 'unit')),
        'products' => count(array_filter($items, static fn (array $item): bool => $item['type'] === 'product')),
    ];
    return $dataset;
}

function datasetList(mysqli $db, ?string $sector, bool $includeInactive): array
{
    if ($sector !== null) {
        $statement = $db->prepare('SELECT d.jeu_donnees_id, d.name, d.description, d.secteur_activite, d.categorie, d.is_active, d.created_at, d.updated_at, d.created_by AS creator_id, d.created_by_name AS creator_name, v.jeu_donnees_version_id, v.version_number, JSON_LENGTH(v.items_json) AS item_count FROM jeux_donnees d JOIN jeux_donnees_versions v ON v.jeu_donnees_id = d.jeu_donnees_id AND v.version_number = (SELECT MAX(v2.version_number) FROM jeux_donnees_versions v2 WHERE v2.jeu_donnees_id = d.jeu_donnees_id) WHERE d.is_active = 1 AND d.secteur_activite IN (?, \'all\') ORDER BY (d.secteur_activite = ?) DESC, d.updated_at DESC');
        $statement->bind_param('ss', $sector, $sector);
    } elseif ($includeInactive) {
        $statement = $db->prepare('SELECT d.jeu_donnees_id, d.name, d.description, d.secteur_activite, d.categorie, d.is_active, d.created_at, d.updated_at, d.created_by AS creator_id, d.created_by_name AS creator_name, v.jeu_donnees_version_id, v.version_number, JSON_LENGTH(v.items_json) AS item_count FROM jeux_donnees d LEFT JOIN jeux_donnees_versions v ON v.jeu_donnees_id = d.jeu_donnees_id AND v.version_number = (SELECT MAX(v2.version_number) FROM jeux_donnees_versions v2 WHERE v2.jeu_donnees_id = d.jeu_donnees_id) ORDER BY d.updated_at DESC');
    } else {
        throw new RuntimeException('Secteur d’activité requis.');
    }
    $statement->execute();
    $rows = $statement->get_result()->fetch_all(MYSQLI_ASSOC);
    foreach ($rows as &$row) $row['item_count'] = (int) ($row['item_count'] ?? 0);
    unset($row);
    return $rows;
}

function datasetDetails(mysqli $db, int $id, bool $includeInactive, ?string $activityType = null): array
{
    if ($id < 1) throw new RuntimeException('Identifiant de jeu de données invalide.');
    $sql = 'SELECT d.jeu_donnees_id, d.name, d.description, d.secteur_activite, d.categorie, d.is_active, d.created_by, d.created_by_name AS creator_name, d.created_at, d.updated_at, v.jeu_donnees_version_id, v.version_number, v.created_at AS version_created_at FROM jeux_donnees d JOIN jeux_donnees_versions v ON v.jeu_donnees_id = d.jeu_donnees_id WHERE d.jeu_donnees_id = ?';
    if (!$includeInactive) $sql .= ' AND d.is_active = 1';
    $sql .= ' ORDER BY v.version_number DESC';
    $statement = $db->prepare($sql);
    $statement->bind_param('i', $id);
    $statement->execute();
    $rows = $statement->get_result()->fetch_all(MYSQLI_ASSOC);
    if (!$rows) throw new RuntimeException('Jeu de données introuvable ou inactif.');
    $dataset = $rows[0];
    if (!$includeInactive && !in_array($dataset['secteur_activite'], [sectorForActivity($activityType ?? 'other'), 'all'], true)) {
        throw new RuntimeException('Ce jeu de données ne correspond pas au secteur d’activité de votre entreprise.');
    }
    $dataset['versions'] = array_map(static fn (array $row): array => [
        'jeu_donnees_version_id' => (int) $row['jeu_donnees_version_id'],
        'version_number' => (int) $row['version_number'],
        'created_at' => $row['version_created_at'],
    ], $rows);
    $versionId = (int) ($_GET['version_id'] ?? $dataset['jeu_donnees_version_id']);
    $items = versionItems($db, $versionId);
    if (!in_array($versionId, array_column($dataset['versions'], 'jeu_donnees_version_id'), true)) {
        throw new RuntimeException('Version du jeu de données introuvable.');
    }
    $dataset['selected_version_id'] = $versionId;
    $dataset['items'] = $items;
    unset($dataset['created_by'], $dataset['version_created_at']);
    return $dataset;
}

function versionItems(mysqli $db, int $versionId): array
{
    $statement = $db->prepare('SELECT items_json FROM jeux_donnees_versions WHERE jeu_donnees_version_id = ? LIMIT 1');
    $statement->bind_param('i', $versionId);
    $statement->execute();
    $row = $statement->get_result()->fetch_assoc();
    if (!$row) return [];
    $items = json_decode((string) $row['items_json'], true);
    return is_array($items) ? $items : [];
}

function saveDataset(mysqli $db, array $actor, array $body): array
{
    $name = trim((string) ($body['name'] ?? ''));
    $description = trim((string) ($body['description'] ?? ''));
    $sector = trim((string) ($body['secteur_activite'] ?? ''));
    $category = trim((string) ($body['categorie'] ?? ''));
    $items = $body['items'] ?? null;
    $allowedSectors = ['commerce_general', 'pharmacie', 'alimentation_boissons', 'quincaillerie', 'materiaux_construction', 'agriculture', 'informatique_electronique', 'habillement', 'transport_logistique', 'industrie', 'autres', 'all'];
    if ($name === '' || mb_strlen($name, 'UTF-8') > 150 || mb_strlen($description, 'UTF-8') > 10000
        || !in_array($sector, $allowedSectors, true) || $category === '' || mb_strlen($category, 'UTF-8') > 80) {
        throw new RuntimeException('Nom, secteur et catégorie valides requis (description limitée à 10 000 caractères).');
    }
    $items = validateItems($items);
    if (!$items) throw new RuntimeException('Ajoutez au moins une ligne valide au jeu de données.');
    if (count($items) > 5000) throw new RuntimeException('Un jeu de données ne peut pas dépasser 5 000 lignes.');
    if (strlen(json_encode($items, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR)) > 8 * 1024 * 1024) {
        throw new RuntimeException('Le contenu du jeu de données dépasse 8 Mo.');
    }
    $seen = [];
    foreach ($items as $index => $item) {
        $keys = $item['type'] === 'product'
            ? ['product-reference:' . mb_strtolower($item['reference'], 'UTF-8')]
            : [$item['type'] . ':' . mb_strtolower($item['name'], 'UTF-8')];
        foreach ($keys as $key) {
            if (isset($seen[$key])) throw new RuntimeException('Doublon détecté aux lignes ' . $seen[$key] . ' et ' . ($index + 1) . '.');
            $seen[$key] = $index + 1;
        }
    }
    $creatorId = (int) ($actor['id'] ?? 0);
    $creatorName = mb_substr(trim((string) ($actor['full_name'] ?? $actor['email'] ?? 'Super administrateur')), 0, 100, 'UTF-8');
    $datasetId = (int) ($body['jeu_donnees_id'] ?? 0);
    $db->begin_transaction();
    try {
        if ($datasetId > 0) {
            $lock = $db->prepare('SELECT jeu_donnees_id FROM jeux_donnees WHERE jeu_donnees_id = ? FOR UPDATE');
            $lock->bind_param('i', $datasetId);
            $lock->execute();
            if (!$lock->get_result()->fetch_assoc()) throw new RuntimeException('Jeu de données introuvable.');
            $update = $db->prepare('UPDATE jeux_donnees SET name = ?, description = ?, secteur_activite = ?, categorie = ?, is_active = 0 WHERE jeu_donnees_id = ?');
            $update->bind_param('ssssi', $name, $description, $sector, $category, $datasetId);
            $update->execute();
            $version = $db->prepare('SELECT COALESCE(MAX(version_number), 0) + 1 AS next_version FROM jeux_donnees_versions WHERE jeu_donnees_id = ?');
            $version->bind_param('i', $datasetId);
            $version->execute();
            $nextVersion = (int) $version->get_result()->fetch_assoc()['next_version'];
        } else {
            $insert = $db->prepare('INSERT INTO jeux_donnees (name, description, secteur_activite, categorie, is_active, created_by, created_by_name) VALUES (?, ?, ?, ?, 0, ?, ?)');
            $insert->bind_param('ssssis', $name, $description, $sector, $category, $creatorId, $creatorName);
            $insert->execute();
            $datasetId = (int) $db->insert_id;
            $nextVersion = 1;
        }
        $json = json_encode($items, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
        $insertVersion = $db->prepare('INSERT INTO jeux_donnees_versions (jeu_donnees_id, version_number, items_json, created_by, created_by_name) VALUES (?, ?, ?, ?, ?)');
        $insertVersion->bind_param('iisis', $datasetId, $nextVersion, $json, $creatorId, $creatorName);
        $insertVersion->execute();
        $versionId = (int) $db->insert_id;
        $db->commit();
        return ['jeu_donnees_id' => $datasetId, 'jeu_donnees_version_id' => $versionId, 'version_number' => $nextVersion];
    } catch (Throwable $exception) {
        $db->rollback();
        throw $exception;
    }
}

function validateItems(mixed $items): array
{
    if (!is_array($items)) throw new RuntimeException('Les lignes du jeu de données sont invalides.');
    $allowedTypes = ['category', 'unit', 'product', 'service', 'supplier', 'subcategory', 'brand', 'product_type', 'common'];
    $clean = [];
    foreach ($items as $index => $item) {
        if (!is_array($item)) throw new RuntimeException('Ligne ' . ($index + 1) . ' invalide.');
        $type = trim((string) ($item['type'] ?? ''));
        $name = trim((string) ($item['name'] ?? ''));
        if (!in_array($type, $allowedTypes, true) || $name === '' || mb_strlen($name, 'UTF-8') > 150) {
            throw new RuntimeException('Ligne ' . ($index + 1) . ' : type ou nom invalide.');
        }
        $reference = trim((string) ($item['reference'] ?? ''));
        $unit = trim((string) ($item['unit'] ?? ''));
        $unitSymbol = trim((string) ($item['unit_symbol'] ?? ''));
        $typeNameLimit = match ($type) {
            'category', 'supplier' => 100,
            'unit' => 50,
            'service', 'subcategory', 'brand', 'product_type', 'common' => 120,
            default => 150,
        };
        if (mb_strlen($name, 'UTF-8') > $typeNameLimit) {
            throw new RuntimeException('Ligne ' . ($index + 1) . ' : le nom dépasse la longueur autorisée pour ce type.');
        }
        if ($type === 'product' && ($reference === '' || mb_strlen($reference, 'UTF-8') > 50 || $unit === '')) {
            throw new RuntimeException('Ligne ' . ($index + 1) . ' : un produit doit avoir une référence (50 caractères maximum) et une unité.');
        }
        if ($type === 'supplier' && mb_strlen($name, 'UTF-8') > 100) {
            throw new RuntimeException('Ligne ' . ($index + 1) . ' : le nom du fournisseur dépasse 100 caractères.');
        }
        if (mb_strlen($unit, 'UTF-8') > 50 || mb_strlen($unitSymbol, 'UTF-8') > 15
            || mb_strlen(trim((string) ($item['category'] ?? '')), 'UTF-8') > 100
            || mb_strlen($reference, 'UTF-8') > 100) {
            throw new RuntimeException('Ligne ' . ($index + 1) . ' : une référence, une catégorie ou une unité dépasse la longueur autorisée.');
        }
        $clean[] = [
            'type' => $type,
            'name' => $name,
            'reference' => $reference,
            'description' => trim((string) ($item['description'] ?? '')),
            'category' => trim((string) ($item['category'] ?? '')),
            'unit' => $unit,
            'unit_symbol' => $unitSymbol,
            'sale_price' => validMoney($item['sale_price'] ?? 0, 'prix de vente'),
            'cost_price' => validMoney($item['cost_price'] ?? 0, 'coût'),
            'currency' => strtoupper(trim((string) ($item['currency'] ?? ''))),
            'perishable' => !empty($item['perishable']) ? 1 : 0,
        ];
        if (mb_strlen($clean[count($clean) - 1]['description'], 'UTF-8') > 2000) throw new RuntimeException('Description trop longue à la ligne ' . ($index + 1) . '.');
    }
    return $clean;
}

function validMoney(mixed $value, string $label): float
{
    if ($value === '' || $value === null) return 0.0;
    $normalized = str_contains((string) $value, ',') && !str_contains((string) $value, '.')
        ? str_replace(',', '.', (string) $value)
        : (string) $value;
    if (!is_numeric($normalized) || (float) $normalized < 0 || !is_finite((float) $normalized)) {
        throw new RuntimeException('Valeur ' . $label . ' invalide.');
    }
    return (float) $normalized;
}

function previewCsv(): never
{
    if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) JsonResponse::error('Sélectionnez un fichier Excel ou CSV valide.', 422);
    $file = $_FILES['file'];
    $isExcel = strtolower(pathinfo((string) ($file['name'] ?? ''), PATHINFO_EXTENSION)) === 'xlsx';
    if ((int) $file['size'] > ($isExcel ? 10 : 5) * 1024 * 1024) JsonResponse::error('Le fichier dépasse la taille maximale autorisée.', 413);
    if ($isExcel) {
        $rows = DatasetSpreadsheet::read($file['tmp_name']);
        $delimiter = 'xlsx';
    } else {
        $handle = fopen($file['tmp_name'], 'rb');
        if ($handle === false) JsonResponse::error('Lecture du fichier CSV impossible.', 422);
        $firstLine = fgets($handle);
        if ($firstLine === false) JsonResponse::error('Le fichier CSV est vide.', 422);
        $delimiter = substr_count($firstLine, ';') > substr_count($firstLine, ',') ? ';' : ',';
        rewind($handle);
        $rows = [];
        while (($row = fgetcsv($handle, 0, $delimiter, '"', '\\')) !== false) $rows[] = $row;
        fclose($handle);
    }
    if (!$rows || !is_array($rows[0])) JsonResponse::error('En-têtes introuvables dans le fichier.', 422);
    $headers = array_map(static fn ($value): string => trim(preg_replace('/^\xEF\xBB\xBF/', '', (string) $value)), $rows[0]);
    $aliases = ['type de donnée' => 'type', 'type de donnee' => 'type', 'nom' => 'name', 'référence' => 'reference', 'reference' => 'reference', 'description' => 'description', 'catégorie' => 'category', 'categorie' => 'category', 'unité' => 'unit', 'unite' => 'unit', 'symbole unité' => 'unit_symbol', 'symbole unite' => 'unit_symbol', 'prix de vente' => 'sale_price', 'prix de revient' => 'cost_price', "prix d'achat" => 'cost_price', 'prix d’achat' => 'cost_price', 'coût' => 'cost_price', 'cout' => 'cost_price', 'monnaie' => 'currency', 'périssable' => 'perishable', 'perissable' => 'perishable'];
    $normalized = [];
    foreach ($headers as $index => $header) {
        $key = mb_strtolower(trim($header), 'UTF-8');
        $normalized[$index] = $aliases[$key] ?? $key;
    }
    if (!in_array('type', $normalized, true) || !in_array('name', $normalized, true)) {
        JsonResponse::error('Les colonnes Type et Nom sont obligatoires. Téléchargez le modèle Excel pour consulter les colonnes attendues.', 422);
    }
    $items = [];
    foreach (array_slice($rows, 1) as $rowIndex => $values) {
        $rowNumber = $rowIndex + 2;
        if (!is_array($values)) continue;
        if (count(array_filter($values, static fn ($value): bool => trim((string) $value) !== '')) === 0) continue;
        if (count($items) >= 5000) JsonResponse::error('Le fichier ne peut pas dépasser 5 000 lignes.', 413);
        $item = array_fill_keys(['type', 'name', 'reference', 'description', 'category', 'unit', 'unit_symbol', 'sale_price', 'cost_price', 'currency', 'perishable'], '');
        foreach ($normalized as $index => $key) if (array_key_exists($key, $item)) $item[$key] = trim((string) ($values[$index] ?? ''));
        $item['type'] = match (mb_strtolower($item['type'], 'UTF-8')) {
            'catégorie', 'categorie' => 'category',
            'unité', 'unite' => 'unit',
            'produit' => 'product',
            'fournisseur' => 'supplier',
            'sous-catégorie', 'sous-categorie' => 'subcategory',
            'marque' => 'brand',
            'type de produit' => 'product_type',
            'information commune' => 'common',
            default => strtolower($item['type']),
        };
        $item['perishable'] = in_array(mb_strtolower($item['perishable']), ['1', 'oui', 'yes', 'true'], true) ? 1 : 0;
        $item['_source_row'] = $rowNumber;
        $items[] = $item;
    }
    $validated = [];
    $errors = [];
    foreach ($items as $item) {
        $sourceRow = $item['_source_row'];
        unset($item['_source_row']);
        try {
            $validated[] = validateItems([$item])[0] + ['_source_row' => $sourceRow];
        } catch (Throwable $exception) {
            $errors[] = ['row' => $sourceRow, 'message' => $exception->getMessage()];
            $validated[] = $item + ['_source_row' => $sourceRow, '_error' => $exception->getMessage()];
        }
    }
    $seen = [];
    foreach ($validated as $index => $item) {
        $keys = $item['type'] === 'product' && $item['reference'] !== ''
            ? ['product-reference:' . mb_strtolower($item['reference'], 'UTF-8')]
            : [$item['type'] . ':' . mb_strtolower($item['name'], 'UTF-8')];
        foreach ($keys as $key) {
            if (isset($seen[$key])) {
                $errors[] = ['row' => $item['_source_row'], 'message' => 'Doublon détecté avec la ligne ' . $seen[$key] . '.'];
                $validated[$index]['_error'] = 'Doublon détecté avec la ligne ' . $seen[$key] . '.';
                break;
            }
            $seen[$key] = $item['_source_row'];
        }
    }
    JsonResponse::send(['success' => true, 'data' => ['items' => $validated, 'errors' => $errors, 'delimiter' => $delimiter]]);
}

function importDataset(mysqli $db, array $actor, int $enterpriseId): never
{
    global $transaction;
    $body = json_decode((string) file_get_contents('php://input'), true);
    if (!is_array($body)) JsonResponse::error('Corps JSON invalide.', 400);
    $versionId = (int) ($body['version_id'] ?? 0);
    $selected = $body['selected_items'] ?? [];
    $requestedBranch = isset($body['succursale_id']) ? (int) $body['succursale_id'] : null;
    if ($versionId < 1 || !is_array($selected) || !$selected) JsonResponse::error('Choisissez une version et au moins une ligne à importer.', 422);
    $branchId = Authorization::branchId($actor, $requestedBranch);
    if (!$branchId && !empty($actor['succursale_id'])) $branchId = (int) $actor['succursale_id'];
    if (!$branchId) {
        $main = $db->prepare('SELECT succursale_id FROM succursales WHERE entreprise_id = ? ORDER BY est_sucursal_mere DESC, succursale_id LIMIT 1');
        $main->bind_param('i', $enterpriseId);
        $main->execute();
        $branchId = (int) ($main->get_result()->fetch_assoc()['succursale_id'] ?? 0);
    }
    if ($branchId < 1) JsonResponse::error('Aucune succursale disponible pour cet import.', 422);
    $branchCheck = $db->prepare('SELECT succursale_id FROM succursales WHERE succursale_id = ? AND entreprise_id = ? LIMIT 1');
    $branchCheck->bind_param('ii', $branchId, $enterpriseId);
    $branchCheck->execute();
    if (!$branchCheck->get_result()->fetch_assoc()) JsonResponse::error('Succursale invalide pour cette entreprise.', 403);

    $versionQuery = $db->prepare('SELECT v.jeu_donnees_id, v.items_json, d.name, d.secteur_activite, d.is_active, e.activity_type FROM jeux_donnees_versions v JOIN jeux_donnees d ON d.jeu_donnees_id = v.jeu_donnees_id JOIN entreprises e ON e.entreprise_id = ? WHERE v.jeu_donnees_version_id = ? AND d.is_active = 1 LIMIT 1');
    $versionQuery->bind_param('ii', $enterpriseId, $versionId);
    $versionQuery->execute();
    $source = $versionQuery->get_result()->fetch_assoc();
    if (!$source) JsonResponse::error('Version introuvable ou inactive.', 404);
    if (!in_array($source['secteur_activite'], [sectorForActivity((string) $source['activity_type']), 'all'], true)) {
        JsonResponse::error('Ce jeu de données ne correspond pas au secteur d’activité de votre entreprise.', 403);
    }
    $items = json_decode((string) $source['items_json'], true);
    if (!is_array($items)) throw new RuntimeException('Contenu du jeu de données invalide.');
    $selected = array_values(array_unique(array_filter(array_map('intval', $selected), static fn (int $index): bool => $index >= 0 && isset($items[$index]))));
    if (!$selected) JsonResponse::error('Aucune ligne valide sélectionnée.', 422);

    $datasetId = (int) $source['jeu_donnees_id'];
    $userId = (int) ($actor['id'] ?? 0);
    $userName = mb_substr(trim((string) ($actor['full_name'] ?? $actor['email'] ?? 'Utilisateur')), 0, 100, 'UTF-8');
    $db->begin_transaction();
    $transaction = true;
    $counts = ['category' => 0, 'unit' => 0, 'product' => 0, 'supplier' => 0, 'reference' => 0, 'duplicates' => 0];
    $categoryMap = [];
    $unitMap = [];
    foreach ($selected as $index) {
        $item = $items[$index];
        if (!is_array($item)) throw new RuntimeException('Ligne source invalide.');
        $type = (string) ($item['type'] ?? '');
        if (!in_array($type, ['category', 'unit'], true)) continue;
        $name = trim((string) ($item['name'] ?? ''));
        if ($name === '') throw new RuntimeException('Une ligne sélectionnée ne possède pas de nom.');
        if ($type === 'category') {
            $existing = $db->prepare('SELECT category_id FROM categories WHERE entreprise_id = ? AND name = ? LIMIT 1');
            $existing->bind_param('is', $enterpriseId, $name);
            $existing->execute();
            $found = $existing->get_result()->fetch_assoc();
            if ($found) { $categoryMap[mb_strtolower($name, 'UTF-8')] = (int) $found['category_id']; $counts['duplicates']++; continue; }
            $description = trim((string) ($item['description'] ?? ''));
            $insert = $db->prepare('INSERT INTO categories (entreprise_id, name, description) VALUES (?, ?, ?)');
            $insert->bind_param('iss', $enterpriseId, $name, $description);
            $insert->execute();
            $categoryMap[mb_strtolower($name, 'UTF-8')] = (int) $db->insert_id;
            $counts['category']++;
        } else {
            $existing = $db->prepare('SELECT unite_mesure_id FROM unites_mesure WHERE entreprise_id = ? AND name = ? LIMIT 1');
            $existing->bind_param('is', $enterpriseId, $name);
            $existing->execute();
            $found = $existing->get_result()->fetch_assoc();
            if ($found) { $unitMap[mb_strtolower($name, 'UTF-8')] = (int) $found['unite_mesure_id']; $counts['duplicates']++; continue; }
            $symbol = trim((string) ($item['unit_symbol'] ?? ''));
            if ($symbol === '') $symbol = $name;
            $insert = $db->prepare('INSERT INTO unites_mesure (entreprise_id, name, symbole) VALUES (?, ?, ?)');
            $insert->bind_param('iss', $enterpriseId, $name, $symbol);
            $insert->execute();
            $unitMap[mb_strtolower($name, 'UTF-8')] = (int) $db->insert_id;
            $counts['unit']++;
        }
    }

    $currencyQuery = $db->query('SELECT type_monais FROM tb_monais ORDER BY type_monais');
    $currencies = array_column($currencyQuery->fetch_all(MYSQLI_ASSOC), 'type_monais');
    $defaultCurrency = (string) ($currencies[0] ?? '');
    foreach ($selected as $index) {
        $item = $items[$index];
        $type = (string) ($item['type'] ?? '');
        if ($type === 'category' || $type === 'unit') continue;
        if ($type === 'product') {
            $sku = trim((string) ($item['reference'] ?? ''));
            $name = trim((string) ($item['name'] ?? ''));
            if ($sku === '' || $name === '') throw new RuntimeException('Chaque produit importé doit avoir un nom et une référence.');
                $duplicate = $db->prepare('SELECT produit_id FROM produits WHERE entreprise_id = ? AND sku = ? LIMIT 1');
                $duplicate->bind_param('is', $enterpriseId, $sku);
            $duplicate->execute();
            if ($duplicate->get_result()->fetch_assoc()) { $counts['duplicates']++; continue; }
            $categoryId = null;
            $categoryName = trim((string) ($item['category'] ?? ''));
            if ($categoryName !== '') {
                $categoryId = $categoryMap[mb_strtolower($categoryName, 'UTF-8')] ?? null;
                if ($categoryId === null) {
                    $query = $db->prepare('SELECT category_id FROM categories WHERE entreprise_id = ? AND name = ? LIMIT 1');
                    $query->bind_param('is', $enterpriseId, $categoryName);
                    $query->execute();
                    $categoryId = ($query->get_result()->fetch_assoc()['category_id'] ?? null);
                }
                if (!$categoryId) throw new RuntimeException("Catégorie « {$categoryName} » introuvable. Importez d’abord la catégorie.");
            }
            $unitName = trim((string) ($item['unit'] ?? ''));
            $unitId = $unitName === '' ? null : ($unitMap[mb_strtolower($unitName, 'UTF-8')] ?? null);
            if ($unitName !== '' && !$unitId) {
                $query = $db->prepare('SELECT unite_mesure_id FROM unites_mesure WHERE entreprise_id = ? AND name = ? LIMIT 1');
                $query->bind_param('is', $enterpriseId, $unitName);
                $query->execute();
                $unitId = $query->get_result()->fetch_assoc()['unite_mesure_id'] ?? null;
            }
            if (!$unitId) throw new RuntimeException("Unité « {$unitName} » introuvable. Importez d’abord l’unité.");
            $currency = strtoupper(trim((string) ($item['currency'] ?? '')));
            if ($currency === '') $currency = $defaultCurrency;
            if (!in_array($currency, $currencies, true)) throw new RuntimeException("Monnaie « {$currency} » non autorisée. Configurez-la dans la liste des monnaies avant l’import.");
            $description = trim((string) ($item['description'] ?? ''));
            $salePrice = (float) ($item['sale_price'] ?? 0);
            $costPrice = (float) ($item['cost_price'] ?? 0);
            $perishable = !empty($item['perishable']) ? 1 : 0;
            $insert = $db->prepare('INSERT INTO produits (entreprise_id, succursale_origine_id, category_id, fournisseur_id, unite_de_mesure, sku, name, description, unit_price, cost_price, monais, est_perisable, quantite_fractionnaire, is_active) VALUES (?, ?, ?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, 0, 1)');
            $insert->bind_param('iiiisssddsi', $enterpriseId, $branchId, $categoryId, $unitId, $sku, $name, $description, $salePrice, $costPrice, $currency, $perishable);
            $insert->execute();
            $productId = (int) $db->insert_id;
            $stock = $db->prepare('INSERT INTO stocks (entreprise_id, succursale_id, produit_id, quantity, min_stock_level) VALUES (?, ?, ?, 0, 5)');
            $stock->bind_param('iii', $enterpriseId, $branchId, $productId);
            $stock->execute();
            $counts['product']++;
        } elseif ($type === 'supplier') {
            $name = trim((string) ($item['name'] ?? ''));
            $duplicate = $db->prepare('SELECT fournisseur_id FROM fournisseurs WHERE entreprise_id = ? AND name = ? AND (succursale_id IS NULL OR succursale_id = ?) LIMIT 1');
            $duplicate->bind_param('isi', $enterpriseId, $name, $branchId);
            $duplicate->execute();
            if ($duplicate->get_result()->fetch_assoc()) { $counts['duplicates']++; continue; }
            $insert = $db->prepare('INSERT INTO fournisseurs (entreprise_id, succursale_id, name) VALUES (?, ?, ?)');
            $insert->bind_param('iis', $enterpriseId, $branchId, $name);
            $insert->execute();
            $counts['supplier']++;
        } else {
            $referenceType = trim($type);
            $referenceName = trim((string) ($item['name'] ?? ''));
            $duplicate = $db->prepare('SELECT reference_id FROM jeux_donnees_references WHERE entreprise_id = ? AND succursale_id = ? AND reference_type = ? AND name = ? LIMIT 1');
            $duplicate->bind_param('iiss', $enterpriseId, $branchId, $referenceType, $referenceName);
            $duplicate->execute();
            if ($duplicate->get_result()->fetch_assoc()) { $counts['duplicates']++; continue; }
            $details = json_encode($item, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
            $referenceInsert = $db->prepare('INSERT INTO jeux_donnees_references (entreprise_id, succursale_id, jeu_donnees_id, jeu_donnees_version_id, user_id, user_name, reference_type, name, details_json) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');
            $referenceInsert->bind_param('iiiiissss', $enterpriseId, $branchId, $datasetId, $versionId, $userId, $userName, $referenceType, $referenceName, $details);
            $referenceInsert->execute();
            $counts['reference']++;
        }
    }
    $resultJson = json_encode($counts, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
    $branchNameQuery = $db->prepare('SELECT name FROM succursales WHERE succursale_id = ? AND entreprise_id = ? LIMIT 1');
    $branchNameQuery->bind_param('ii', $branchId, $enterpriseId);
    $branchNameQuery->execute();
    $branchName = (string) ($branchNameQuery->get_result()->fetch_assoc()['name'] ?? '');
    $log = $db->prepare('INSERT INTO jeux_donnees_importations (jeu_donnees_id, jeu_donnees_version_id, entreprise_id, succursale_id, branch_name, user_id, user_name, resultat_json) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');
    $log->bind_param('iiiisiss', $datasetId, $versionId, $enterpriseId, $branchId, $branchName, $userId, $userName, $resultJson);
    $log->execute();
    $db->commit();
    $transaction = false;
    JsonResponse::send(['success' => true, 'data' => ['counts' => $counts, 'importation_id' => (int) $db->insert_id]]);
}

function sectorForActivity(string $activity): string
{
    return match ($activity) {
        'pharmaceutical' => 'pharmacie',
        'commercial' => 'commerce_general',
        'other' => 'autres',
        default => $activity,
    };
}

function exportDataset(mysqli $db, int $datasetId, int $versionId, bool $includeInactive = true, ?string $activityType = null): never
{
    $dataset = datasetDetails($db, $datasetId, $includeInactive, $activityType);
    if ($versionId > 0) {
        $versionIds = array_column($dataset['versions'], 'jeu_donnees_version_id');
        if (!in_array($versionId, $versionIds, true)) JsonResponse::error('Version introuvable.', 404);
        $dataset['items'] = versionItems($db, $versionId);
    }
    $filename = preg_replace('/[^A-Za-z0-9_-]+/', '-', (string) $dataset['name']) ?: 'jeu-de-donnees';
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="' . $filename . '.csv"');
    header('Cache-Control: no-store');
    $out = fopen('php://output', 'wb');
    if ($out === false) throw new RuntimeException('Création du fichier CSV impossible.');
    fwrite($out, "\xEF\xBB\xBF");
    fputcsv($out, ['type', 'name', 'reference', 'description', 'category', 'unit', 'unit_symbol', 'sale_price', 'cost_price', 'currency', 'perishable'], ';', '"', '\\');
    foreach ($dataset['items'] as $item) {
        $values = array_map(static fn (string $key): mixed => $item[$key] ?? '', ['type', 'name', 'reference', 'description', 'category', 'unit', 'unit_symbol', 'sale_price', 'cost_price', 'currency', 'perishable']);
        $values = array_map(static function (mixed $value): mixed {
            if (is_string($value) && preg_match('/^[\s]*[=+\-@]/u', $value)) return "'" . $value;
            return $value;
        }, $values);
        fputcsv($out, $values, ';', '"', '\\');
    }
    fclose($out);
    exit;
}

function exportDatasetXlsx(mysqli $db, int $datasetId, int $versionId, bool $includeInactive = true, ?string $activityType = null): never
{
    $dataset = datasetDetails($db, $datasetId, $includeInactive, $activityType);
    if ($versionId > 0) {
        $versionIds = array_column($dataset['versions'], 'jeu_donnees_version_id');
        if (!in_array($versionId, $versionIds, true)) JsonResponse::error('Version introuvable.', 404);
        $dataset['items'] = versionItems($db, $versionId);
    }
    $filename = preg_replace('/[^A-Za-z0-9_-]+/', '-', (string) $dataset['name']) ?: 'jeu-de-donnees';
    DatasetSpreadsheet::download($filename, spreadsheetRows($dataset['items']));
}
