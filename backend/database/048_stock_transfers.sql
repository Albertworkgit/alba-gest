CREATE TABLE IF NOT EXISTS transferts_stock (
    transfert_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    produit_id INT NOT NULL,
    succursale_from_id INT NOT NULL COMMENT 'Source',
    succursale_to_id INT NOT NULL COMMENT 'Destination',
    quantity INT NOT NULL,
    transfer_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'COMPLETED',
    notes TEXT DEFAULT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_transfert_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_transfert_from FOREIGN KEY (succursale_from_id) REFERENCES succursales(succursale_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_transfert_produit FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_transfert_to FOREIGN KEY (succursale_to_id) REFERENCES succursales(succursale_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
