CREATE TABLE IF NOT EXISTS modes_paiement (
    mode_paiement_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(80) NOT NULL,
    requires_cash TINYINT(1) NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO modes_paiement (code,name,requires_cash,is_active)
VALUES ('CASH','Caisse',1,1),('MOBILE_MONEY','Mobile Money',0,1),('BANK','Banque',0,1)
ON DUPLICATE KEY UPDATE name=VALUES(name),requires_cash=VALUES(requires_cash),is_active=1;

UPDATE modes_paiement
SET is_active=0
WHERE code NOT IN ('CASH','BANK','MOBILE_MONEY');

CREATE TABLE IF NOT EXISTS paiements_ventes (
    paiement_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    vente_id INT NOT NULL,
    mode_paiement_id INT NOT NULL,
    caisse_id INT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    reference VARCHAR(120) NULL,
    payment_type ENUM('PAYMENT','REFUND') NOT NULL DEFAULT 'PAYMENT',
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_paiement_vente_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_paiement_vente_vente FOREIGN KEY (vente_id) REFERENCES ventes(vente_id) ON DELETE CASCADE,
    CONSTRAINT fk_paiement_vente_mode FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(mode_paiement_id) ON DELETE RESTRICT,
    CONSTRAINT fk_paiement_vente_caisse FOREIGN KEY (caisse_id) REFERENCES caisses(caisse_id) ON DELETE SET NULL,
    INDEX idx_paiements_ventes (entreprise_id,vente_id)
) ENGINE=InnoDB;

ALTER TABLE paiements_fournisseurs
    MODIFY caisse_id INT NULL,
    ADD COLUMN mode_paiement_id INT NULL AFTER achat_id,
    ADD COLUMN reference VARCHAR(120) NULL AFTER amount,
    ADD CONSTRAINT fk_paiement_fournisseur_mode FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(mode_paiement_id) ON DELETE RESTRICT;

ALTER TABLE mouvements_caisse
    ADD COLUMN mode_paiement_id INT NULL AFTER user_id,
    ADD CONSTRAINT fk_mouvement_caisse_mode FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(mode_paiement_id) ON DELETE RESTRICT;

UPDATE mouvements_caisse SET mode_paiement_id=(SELECT mode_paiement_id FROM modes_paiement WHERE code='CASH' LIMIT 1) WHERE mode_paiement_id IS NULL;
UPDATE paiements_fournisseurs SET mode_paiement_id=(SELECT mode_paiement_id FROM modes_paiement WHERE code='CASH' LIMIT 1) WHERE mode_paiement_id IS NULL;
