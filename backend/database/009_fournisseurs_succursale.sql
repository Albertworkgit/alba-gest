-- Ajoute le rattachement de succursale seulement s'il n'existe pas déjà.
SET @supplier_branch_column_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fournisseurs' AND COLUMN_NAME = 'succursale_id'
);
SET @supplier_branch_column_sql = IF(
    @supplier_branch_column_exists = 0,
    'ALTER TABLE fournisseurs ADD COLUMN succursale_id INT NULL AFTER entreprise_id',
    'SELECT 1'
);
PREPARE supplier_branch_column_statement FROM @supplier_branch_column_sql;
EXECUTE supplier_branch_column_statement;
DEALLOCATE PREPARE supplier_branch_column_statement;

-- Relie le rattachement à une succursale seulement si la clé étrangère manque.
SET @supplier_branch_fk_exists = (
    SELECT COUNT(*) FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fournisseurs'
      AND COLUMN_NAME = 'succursale_id' AND REFERENCED_TABLE_NAME = 'succursales'
);
SET @supplier_branch_fk_sql = IF(
    @supplier_branch_fk_exists = 0,
    'ALTER TABLE fournisseurs ADD CONSTRAINT fk_fournisseur_succursale FOREIGN KEY (succursale_id) REFERENCES succursales(succursale_id) ON DELETE SET NULL ON UPDATE CASCADE',
    'SELECT 1'
);
PREPARE supplier_branch_fk_statement FROM @supplier_branch_fk_sql;
EXECUTE supplier_branch_fk_statement;
DEALLOCATE PREPARE supplier_branch_fk_statement;
