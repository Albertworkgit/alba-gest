ALTER TABLE vente_details
    ADD COLUMN discount_percent DECIMAL(5,2) NOT NULL DEFAULT 0 AFTER unit_price,
    ADD COLUMN discount_amount DECIMAL(15,2) NOT NULL DEFAULT 0 AFTER subtotal;

ALTER TABLE ventes
    ADD COLUMN cancellation_date DATETIME NULL AFTER status;

CREATE TABLE IF NOT EXISTS vente_detail_lots (
    vente_detail_lot_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    vente_detail_id INT NOT NULL,
    achat_detail_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vente_lot_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_vente_lot_detail FOREIGN KEY (vente_detail_id) REFERENCES vente_details(vente_detail_id) ON DELETE CASCADE,
    CONSTRAINT fk_vente_lot_achat_detail FOREIGN KEY (achat_detail_id) REFERENCES achat_details(achat_detail_id) ON DELETE RESTRICT,
    INDEX idx_vente_detail_lots (entreprise_id, vente_detail_id)
) ENGINE=InnoDB;
