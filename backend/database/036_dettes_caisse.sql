ALTER TABLE mouvements_caisse
    ADD COLUMN dette_id BIGINT NULL AFTER reference_id,
    ADD COLUMN dette_operation ENUM('PRET', 'REMBOURSEMENT') NULL AFTER dette_id,
    ADD INDEX idx_mouvements_caisse_dette (entreprise_id, dette_id, movement_date, mouvement_id);

CREATE TABLE IF NOT EXISTS dettes_caisse (
    dette_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    succursale_id INT NOT NULL,
    caisse_id INT NOT NULL,
    user_id INT NOT NULL,
    beneficiaire VARCHAR(120) NOT NULL,
    telephone VARCHAR(40) NULL,
    description VARCHAR(500) NULL,
    monais VARCHAR(10) NOT NULL,
    montant DECIMAL(15,2) NOT NULL,
    mouvement_id INT NULL,
    date_dette DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_dettes_caisse_mouvement (entreprise_id, mouvement_id),
    INDEX idx_dettes_caisse_page (entreprise_id, succursale_id, date_dette, dette_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS paiements_dettes_caisse (
    paiement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    dette_id BIGINT NOT NULL,
    mouvement_id INT NOT NULL,
    montant DECIMAL(15,2) NOT NULL,
    date_paiement DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_paiements_dettes_mouvement (entreprise_id, mouvement_id),
    INDEX idx_paiements_dettes_dette (entreprise_id, dette_id, date_paiement, paiement_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
