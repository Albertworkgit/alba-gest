ALTER TABLE achat_details
    ADD COLUMN IF NOT EXISTS date_expiration DATE NULL AFTER quantity,
    ADD COLUMN IF NOT EXISTS quantity_out INT NOT NULL DEFAULT 0 AFTER date_expiration;

CREATE TABLE IF NOT EXISTS achat_detail_sorties (
    sortie_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    sortie_detail_id INT NOT NULL,
    lot_detail_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_sortie_lot (entreprise_id, lot_detail_id),
    CONSTRAINT fk_sortie_detail_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_sortie_detail_achat_detail FOREIGN KEY (sortie_detail_id) REFERENCES achat_details(achat_detail_id) ON DELETE CASCADE,
    CONSTRAINT fk_sortie_detail_lot FOREIGN KEY (lot_detail_id) REFERENCES achat_details(achat_detail_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

SET @migration_date_lot_sql = IF(
    EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'produits'
          AND column_name = 'date_expiration'
    ),
    'UPDATE achat_details ad JOIN achats a ON a.achat_id = ad.achat_id AND a.entreprise_id = ad.entreprise_id JOIN produits p ON p.produit_id = ad.produit_id AND p.entreprise_id = ad.entreprise_id SET ad.date_expiration = p.date_expiration WHERE ad.date_expiration IS NULL AND p.est_perisable = 1 AND p.date_expiration IS NOT NULL AND a.movement_type = ''IN''',
    'SELECT 1'
);
PREPARE migration_date_lot FROM @migration_date_lot_sql;
EXECUTE migration_date_lot;
DEALLOCATE PREPARE migration_date_lot;

SET @suppression_date_produit_sql = IF(
    EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'produits'
          AND column_name = 'date_expiration'
    ),
    'ALTER TABLE produits DROP COLUMN date_expiration',
    'SELECT 1'
);
PREPARE suppression_date_produit FROM @suppression_date_produit_sql;
EXECUTE suppression_date_produit;
DEALLOCATE PREPARE suppression_date_produit;