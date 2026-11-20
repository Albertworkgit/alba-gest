CREATE TABLE IF NOT EXISTS entreprise_monnaie_reference (
    entreprise_id INT NOT NULL PRIMARY KEY,
    monais VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_monnaie_reference_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_monnaie_reference_code FOREIGN KEY (monais) REFERENCES tb_monais(type_monais) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS taux_change (
    taux_change_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    monais VARCHAR(20) NOT NULL,
    taux_vers_reference DECIMAL(20,10) NOT NULL,
    updated_by INT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_taux_change_entreprise_monnaie (entreprise_id, monais),
    CONSTRAINT fk_taux_change_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_taux_change_code FOREIGN KEY (monais) REFERENCES tb_monais(type_monais) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_taux_change_user FOREIGN KEY (updated_by) REFERENCES users(user_id) ON DELETE SET NULL,
    CHECK (taux_vers_reference > 0)
) ENGINE=InnoDB;

ALTER TABLE paiements_ventes
    ADD COLUMN amount_applied DECIMAL(15,2) NULL AFTER amount,
    ADD COLUMN monais_facture VARCHAR(20) NULL AFTER monais,
    ADD COLUMN exchange_rate DECIMAL(20,10) NULL AFTER monais_facture;

UPDATE paiements_ventes
SET amount_applied = amount,
    monais_facture = monais,
    exchange_rate = 1
WHERE amount_applied IS NULL
   OR monais_facture IS NULL
   OR exchange_rate IS NULL;
