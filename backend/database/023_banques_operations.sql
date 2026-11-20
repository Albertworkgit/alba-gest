CREATE TABLE IF NOT EXISTS banques (
    banque_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,
    account_number VARCHAR(80) NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_banque_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    UNIQUE KEY uq_banque_entreprise_compte (entreprise_id, name, account_number)
) ENGINE=InnoDB;

ALTER TABLE mouvements_caisse
    ADD COLUMN banque_id INT NULL AFTER mode_paiement_id,
    ADD COLUMN bank_reference VARCHAR(120) NULL AFTER banque_id,
    ADD CONSTRAINT fk_mouvement_caisse_banque FOREIGN KEY (banque_id) REFERENCES banques(banque_id) ON DELETE RESTRICT,
    ADD INDEX idx_mouvement_caisse_banque (banque_id, movement_date);

ALTER TABLE paiements_ventes
    ADD COLUMN banque_id INT NULL AFTER mode_paiement_id,
    ADD CONSTRAINT fk_paiement_vente_banque FOREIGN KEY (banque_id) REFERENCES banques(banque_id) ON DELETE RESTRICT;

ALTER TABLE paiements_fournisseurs
    ADD COLUMN banque_id INT NULL AFTER mode_paiement_id,
    ADD CONSTRAINT fk_paiement_fournisseur_banque FOREIGN KEY (banque_id) REFERENCES banques(banque_id) ON DELETE RESTRICT;
