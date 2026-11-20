<?php
declare(strict_types=1);

require_once __DIR__ . '/../Core/Database.php';
require_once __DIR__ . '/../Core/JsonResponse.php';
require_once __DIR__ . '/../Core/Session.php';
require_once __DIR__ . '/../Core/AuthGuard.php';
require_once __DIR__ . '/../Core/Authorization.php';

use AlbaStock\Core\AuthGuard;
use AlbaStock\Core\Authorization;
use AlbaStock\Core\Database;
use AlbaStock\Core\JsonResponse;

try {
    if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') JsonResponse::error('Méthode non autorisée.', 405);
    $actor = AuthGuard::requireAuthenticated();
    if (($actor['type'] ?? '') !== 'user' || empty($actor['is_company_admin'])) JsonResponse::error('Action réservée à l’administrateur de l’entreprise.', 403);
    $body = json_decode((string) file_get_contents('php://input'), true);
    if (!is_array($body)) JsonResponse::error('Corps JSON invalide.', 400);
    $module = (string) ($body['module'] ?? '');
    $from = (string) ($body['from'] ?? '');
    $to = (string) ($body['to'] ?? '');
    $modules = [
        'ventes' => 'ventes', 'approvisionnements' => 'approvisionnements', 'caisse' => 'caisse',
        'stock' => 'stock', 'comptabilite' => 'comptabilite',
    ];
    if (!isset($modules[$module])) JsonResponse::error('Module de nettoyage inconnu.', 422);
    foreach ([$from, $to] as $date) {
        $parsed = DateTimeImmutable::createFromFormat('!Y-m-d', $date);
        if (!$parsed || $parsed->format('Y-m-d') !== $date) JsonResponse::error('Dates invalides.', 422);
    }
    if ($from > $to) JsonResponse::error('La date de début doit précéder la date de fin.', 422);
    Authorization::requireModule($actor, $modules[$module]);
    $db = Database::connection();
    $enterpriseId = (int) $actor['entreprise_id'];
    $db->begin_transaction();
    $removed = 0;
    $delete = static function (string $sql, string $types, array $values) use ($db, &$removed): void {
        $statement = $db->prepare($sql);
        $bind = [$types];
        foreach ($values as $key => &$value) $bind[] = &$value;
        call_user_func_array([$statement, 'bind_param'], $bind);
        $statement->execute();
        $removed += $statement->affected_rows;
    };
    $range = [$enterpriseId, $from . ' 00:00:00', $to . ' 23:59:59'];
    if ($module === 'ventes') {
        $idsQuery = $db->prepare('SELECT vente_id FROM ventes WHERE entreprise_id=? AND sale_date BETWEEN ? AND ?');
        $enterpriseParam = $range[0]; $fromParam = $range[1]; $toParam = $range[2];
        $idsQuery->bind_param('iss', $enterpriseParam, $fromParam, $toParam); $idsQuery->execute();
        $ids = array_map('intval', array_column($idsQuery->get_result()->fetch_all(MYSQLI_ASSOC), 'vente_id'));
        if ($ids) {
            $marks = implode(',', array_fill(0, count($ids), '?'));
            $args = array_merge([$enterpriseId], $ids); $types = 'i' . str_repeat('i', count($ids));
            foreach ([
                "DELETE FROM vente_detail_lots WHERE entreprise_id=? AND vente_detail_id IN (SELECT vente_detail_id FROM vente_details WHERE entreprise_id=? AND vente_id IN ($marks))",
                "DELETE FROM paiements_ventes WHERE entreprise_id=? AND vente_id IN ($marks)",
                "DELETE FROM vente_totaux_monnaies WHERE entreprise_id=? AND vente_id IN ($marks)",
                "DELETE FROM mouvements_stock WHERE entreprise_id=? AND reference_type='VENTE' AND reference_id IN ($marks)",
                "DELETE FROM mouvements_caisse WHERE entreprise_id=? AND reference_id IN ($marks) AND reason LIKE 'Paiement vente%'",
                "DELETE FROM vente_details WHERE entreprise_id=? AND vente_id IN ($marks)",
                "DELETE FROM ventes WHERE entreprise_id=? AND vente_id IN ($marks)",
            ] as $sql) {
                // First statement has a nested enterprise placeholder for both tables.
                $params = str_contains($sql, 'vente_detail_lots') ? array_merge([$enterpriseId, $enterpriseId], $ids) : $args;
                $bindTypes = str_contains($sql, 'vente_detail_lots') ? 'ii' . str_repeat('i', count($ids)) : $types;
                $delete($sql, $bindTypes, $params);
            }
        }
    } elseif ($module === 'approvisionnements') {
        $idsQuery = $db->prepare('SELECT achat_id FROM achats WHERE entreprise_id=? AND purchase_date BETWEEN ? AND ?');
        $enterpriseParam = $range[0]; $fromParam = $range[1]; $toParam = $range[2];
        $idsQuery->bind_param('iss', $enterpriseParam, $fromParam, $toParam); $idsQuery->execute();
        $ids = array_map('intval', array_column($idsQuery->get_result()->fetch_all(MYSQLI_ASSOC), 'achat_id'));
        if ($ids) {
            $marks = implode(',', array_fill(0, count($ids), '?')); $args = array_merge([$enterpriseId], $ids); $types = 'i' . str_repeat('i', count($ids));
            foreach ([
                "DELETE FROM achat_detail_sorties WHERE entreprise_id=? AND (sortie_detail_id IN (SELECT achat_detail_id FROM achat_details WHERE entreprise_id=? AND achat_id IN ($marks)) OR lot_detail_id IN (SELECT achat_detail_id FROM achat_details WHERE entreprise_id=? AND achat_id IN ($marks)))",
                "DELETE FROM vente_detail_lots WHERE entreprise_id=? AND achat_detail_id IN (SELECT achat_detail_id FROM achat_details WHERE entreprise_id=? AND achat_id IN ($marks))",
                "DELETE FROM paiements_fournisseurs WHERE entreprise_id=? AND achat_id IN ($marks)",
                "DELETE FROM mouvements_caisse WHERE entreprise_id=? AND reference_id IN ($marks) AND reason LIKE 'Paiement fournisseur%'",
                "DELETE FROM mouvements_stock WHERE entreprise_id=? AND reference_type='APPROVISIONNEMENT' AND reference_id IN ($marks)",
                "DELETE FROM achat_details WHERE entreprise_id=? AND achat_id IN ($marks)",
                "DELETE FROM achats WHERE entreprise_id=? AND achat_id IN ($marks)",
            ] as $idx => $sql) {
                if ($idx === 0) { $params = array_merge([$enterpriseId,$enterpriseId],$ids,[$enterpriseId],$ids); $bindTypes='ii'.str_repeat('i',count($ids)).'i'.str_repeat('i',count($ids)); }
                elseif ($idx === 1) { $params=array_merge([$enterpriseId,$enterpriseId],$ids); $bindTypes='ii'.str_repeat('i',count($ids)); }
                else { $params=$args; $bindTypes=$types; }
                $delete($sql,$bindTypes,$params);
            }
        }
    } elseif ($module === 'stock') {
        $delete('DELETE FROM mouvements_stock WHERE entreprise_id=? AND movement_date BETWEEN ? AND ?', 'iss', $range);
    } elseif ($module === 'caisse') {
        $delete('DELETE FROM demandes_annulation_mouvements_caisse WHERE entreprise_id=? AND mouvement_id IN (SELECT mouvement_id FROM mouvements_caisse WHERE entreprise_id=? AND movement_date BETWEEN ? AND ?)', 'iiss', [$enterpriseId,$enterpriseId,$range[1],$range[2]]);
        $delete('DELETE FROM mouvements_caisse WHERE entreprise_id=? AND movement_date BETWEEN ? AND ?', 'iss', $range);
    } else {
        $delete('DELETE FROM lignes_ecritures_comptables WHERE entreprise_id=? AND ecriture_id IN (SELECT ecriture_id FROM ecritures_comptables WHERE entreprise_id=? AND date_ecriture BETWEEN ? AND ?)', 'iiss', [$enterpriseId,$enterpriseId,$from,$to]);
        $delete('DELETE FROM demandes_annulation_ecritures WHERE entreprise_id=? AND ecriture_id IN (SELECT ecriture_id FROM ecritures_comptables WHERE entreprise_id=? AND date_ecriture BETWEEN ? AND ?)', 'iiss', [$enterpriseId,$enterpriseId,$from,$to]);
        $delete('DELETE FROM ecritures_comptables WHERE entreprise_id=? AND date_ecriture BETWEEN ? AND ?', 'iss', [$enterpriseId,$from,$to]);
    }
    $db->commit();
    JsonResponse::send(['success' => true, 'data' => ['deleted' => $removed]]);
} catch (Throwable $exception) {
    if (isset($db) && $db->connect_errno === 0) $db->rollback();
    $message = $exception->getMessage();
    JsonResponse::error(JsonResponse::messageFor($exception), str_contains($message, 'Accès refusé') ? 403 : 422);
}
