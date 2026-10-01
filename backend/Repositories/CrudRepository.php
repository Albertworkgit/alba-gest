<?php
declare(strict_types=1);

namespace AlbaStock\Repositories;

use AlbaStock\Core\Database;
use InvalidArgumentException;
use mysqli;
use mysqli_stmt;

/** Accès SQL générique, limité à une table et à des colonnes configurées côté serveur. */
final class CrudRepository
{
    private mysqli $db;

    public function __construct(
        private readonly string $table,
        private readonly string $primaryKey,
        private readonly array $allowedColumns
    ) {
        $this->assertIdentifier($table);
        $this->assertIdentifier($primaryKey);
        foreach ($allowedColumns as $column) {
            $this->assertIdentifier($column);
        }
        $this->db = Database::connection();
    }

    /** Retourne les lignes de l'entreprise et applique le filtre de succursale s'il existe. */
    public function all(int $enterpriseId, ?int $branchId = null): array
    {
        $sql = "SELECT * FROM `{$this->table}` WHERE entreprise_id = ?";
        if ($branchId !== null) {
            $sql .= $this->table === 'fournisseurs'
                ? ' AND (succursale_id = ? OR succursale_id IS NULL)'
                : ' AND succursale_id = ?';
        }
        $sql .= " ORDER BY `{$this->primaryKey}` DESC";
        $statement = $this->db->prepare($sql);
        $types = $branchId === null ? 'i' : 'ii';
        $values = $branchId === null ? [$enterpriseId] : [$enterpriseId, $branchId];
        $this->bind($statement, $types, $values);
        $statement->execute();
        return $this->rows($statement);
    }

    /** Retourne une page de résultats et le total sans charger toute la table en mémoire. */
    public function paginate(int $enterpriseId, ?int $branchId, int $page, int $perPage): array
    {
        $where = ' WHERE entreprise_id = ?';
        if ($branchId !== null) $where .= $this->table === 'fournisseurs'
            ? ' AND (succursale_id = ? OR succursale_id IS NULL)'
            : ' AND succursale_id = ?';
        $count = $this->db->prepare("SELECT COUNT(*) AS total FROM `{$this->table}`{$where}");
        if ($branchId === null) $count->bind_param('i', $enterpriseId);
        else $count->bind_param('ii', $enterpriseId, $branchId);
        $count->execute();
        $total = (int) ($count->get_result()->fetch_assoc()['total'] ?? 0);
        $offset = ($page - 1) * $perPage;
        $sql = "SELECT * FROM `{$this->table}`{$where} ORDER BY `{$this->primaryKey}` DESC LIMIT ? OFFSET ?";
        $statement = $this->db->prepare($sql);
        if ($branchId === null) $statement->bind_param('iii', $enterpriseId, $perPage, $offset);
        else $statement->bind_param('iiii', $enterpriseId, $branchId, $perPage, $offset);
        $statement->execute();
        return ['rows' => $this->rows($statement), 'pagination' => ['page' => $page, 'per_page' => $perPage, 'total' => $total, 'pages' => max(1, (int) ceil($total / $perPage))]];
    }

    /** Cherche un enregistrement sans jamais sortir du périmètre de l'entreprise/succursale. */
    public function find(int $enterpriseId, int $id, ?int $branchId = null): ?array
    {
        $sql = "SELECT * FROM `{$this->table}` WHERE entreprise_id = ? AND `{$this->primaryKey}` = ?";
        if ($branchId !== null) $sql .= ' AND succursale_id = ?';
        $sql .= ' LIMIT 1';
        $statement = $this->db->prepare($sql);
        if ($branchId === null) $statement->bind_param('ii', $enterpriseId, $id);
        else $statement->bind_param('iii', $enterpriseId, $id, $branchId);
        $statement->execute();
        $rows = $this->rows($statement);
        $row = $rows[0] ?? null;
        return $row ?: null;
    }

    /** Crée une ligne uniquement avec les champs explicitement autorisés dans config.php. */
    public function create(int $enterpriseId, array $data): int
    {
        $data = $this->filter($data);
        $data['entreprise_id'] = $enterpriseId;
        $columns = array_keys($data);
        $names = implode(', ', array_map(fn (string $column): string => "`{$column}`", $columns));
        $parameters = implode(', ', array_fill(0, count($columns), '?'));
        $statement = $this->db->prepare("INSERT INTO `{$this->table}` ({$names}) VALUES ({$parameters})");
        $values = array_values($data);
        $this->bind($statement, $this->types($values), $values);
        $statement->execute();
        return (int) $this->db->insert_id;
    }

    /** Modifie une ligne de l'entreprise et ajoute la succursale autorisée au filtre SQL. */
    public function update(int $enterpriseId, int $id, array $data, ?int $branchId = null): bool
    {
        $data = $this->filter($data);
        if ($data === []) {
            return false;
        }
        $assignments = implode(', ', array_map(fn (string $column): string => "`{$column}` = ?", array_keys($data)));
        $values = array_values($data);
        $values[] = $enterpriseId;
        $values[] = $id;
        $sql = "UPDATE `{$this->table}` SET {$assignments} WHERE entreprise_id = ? AND `{$this->primaryKey}` = ?";
        if ($branchId !== null) { $sql .= ' AND succursale_id = ?'; $values[] = $branchId; }
        $statement = $this->db->prepare($sql);
        $this->bind($statement, $this->types($values), $values);
        $statement->execute();
        return $statement->affected_rows > 0;
    }

    /** Supprime une ligne seulement dans le périmètre d'accès déterminé par le serveur. */
    public function delete(int $enterpriseId, int $id, ?int $branchId = null): bool
    {
        $sql = "DELETE FROM `{$this->table}` WHERE entreprise_id = ? AND `{$this->primaryKey}` = ?";
        if ($branchId !== null) $sql .= ' AND succursale_id = ?';
        $statement = $this->db->prepare($sql);
        if ($branchId === null) $statement->bind_param('ii', $enterpriseId, $id);
        else $statement->bind_param('iii', $enterpriseId, $id, $branchId);
        $statement->execute();
        return $statement->affected_rows > 0;
    }

    /** Ignore les champs arbitraires envoyés par le navigateur. */
    private function filter(array $data): array
    {
        return array_filter($data, fn (string $key): bool => in_array($key, $this->allowedColumns, true), ARRAY_FILTER_USE_KEY);
    }

    /** Empêche qu'un nom SQL dynamique contienne du code SQL. */
    private function assertIdentifier(string $identifier): void
    {
        if (!preg_match('/^[a-zA-Z_][a-zA-Z0-9_]*$/', $identifier)) {
            throw new InvalidArgumentException('Identifiant SQL invalide.');
        }
    }

    /** Calcule les types mysqli correspondant aux valeurs à lier. */
    private function types(array $values): string
    {
        return implode('', array_map(static fn (mixed $value): string => is_int($value) ? 'i' : (is_float($value) ? 'd' : 's'), $values));
    }

    /** Passe les paramètres par référence, exigence de mysqli_stmt::bind_param. */
    private function bind(mysqli_stmt $statement, string $types, array &$values): void
    {
        $references = [$types];
        foreach ($values as $key => &$value) {
            $references[] = &$value;
        }
        $statement->bind_param(...$references);
    }

    /** Convertit un résultat SQL en tableau associatif. */
    private function rows(mysqli_stmt $statement): array
    {
        $result = $statement->get_result();
        return $result ? $result->fetch_all(MYSQLI_ASSOC) : [];
    }
}
