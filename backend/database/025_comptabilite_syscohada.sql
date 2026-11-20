CREATE TABLE IF NOT EXISTS comptes_comptables (
    compte_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    code VARCHAR(20) NOT NULL,
    intitule VARCHAR(160) NOT NULL,
    classe TINYINT UNSIGNED NOT NULL,
    nature ENUM('DEBIT','CREDIT') NOT NULL,
    parent_id INT NULL,
    is_system TINYINT(1) NOT NULL DEFAULT 0,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_compte_entreprise_code (entreprise_id, code),
    KEY idx_compte_parent (entreprise_id, parent_id),
    CONSTRAINT fk_compte_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_compte_parent FOREIGN KEY (parent_id) REFERENCES comptes_comptables(compte_id) ON DELETE SET NULL,
    CHECK (classe BETWEEN 1 AND 9)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ecritures_comptables (
    ecriture_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    date_ecriture DATE NOT NULL,
    journal_code VARCHAR(12) NOT NULL,
    reference VARCHAR(120) NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    monnaie VARCHAR(10) NOT NULL,
    source_type VARCHAR(40) NULL,
    source_id BIGINT NULL,
    statut ENUM('BROUILLON','VALIDEE') NOT NULL DEFAULT 'VALIDEE',
    user_id INT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_ecriture_source (entreprise_id, source_type, source_id),
    KEY idx_ecriture_date (entreprise_id, monnaie, date_ecriture, journal_code),
    CONSTRAINT fk_ecriture_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_ecriture_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS lignes_ecritures_comptables (
    ligne_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    ecriture_id BIGINT NOT NULL,
    compte_id INT NOT NULL,
    libelle VARCHAR(255) NOT NULL,
    debit DECIMAL(18,2) NOT NULL DEFAULT 0,
    credit DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_ligne_ecriture (entreprise_id, ecriture_id),
    KEY idx_ligne_compte (entreprise_id, compte_id, ecriture_id),
    CONSTRAINT fk_ligne_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_ecriture FOREIGN KEY (ecriture_id) REFERENCES ecritures_comptables(ecriture_id) ON DELETE CASCADE,
    CONSTRAINT fk_ligne_compte FOREIGN KEY (compte_id) REFERENCES comptes_comptables(compte_id) ON DELETE RESTRICT,
    CHECK (debit >= 0 AND credit >= 0),
    CHECK (NOT (debit > 0 AND credit > 0))
) ENGINE=InnoDB;
