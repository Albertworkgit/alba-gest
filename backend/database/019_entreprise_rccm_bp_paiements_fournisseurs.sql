ALTER TABLE entreprises
    ADD COLUMN rccm VARCHAR(100) NULL AFTER address,
    ADD COLUMN boite_postale VARCHAR(100) NULL AFTER rccm;

ALTER TABLE achats
    ADD COLUMN amount_paid DECIMAL(15,2) NOT NULL DEFAULT 0 AFTER total_amount;

CREATE TABLE IF NOT EXISTS paiements_fournisseurs (
    paiement_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    achat_id INT NOT NULL,
    caisse_id INT NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_paiement_fournisseur_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_paiement_fournisseur_achat FOREIGN KEY (achat_id) REFERENCES achats(achat_id) ON DELETE CASCADE,
    CONSTRAINT fk_paiement_fournisseur_caisse FOREIGN KEY (caisse_id) REFERENCES caisses(caisse_id) ON DELETE RESTRICT,
    INDEX idx_paiements_fournisseur_achat (entreprise_id, achat_id)
) ENGINE=InnoDB;
