CREATE TABLE IF NOT EXISTS jeux_donnees (
    jeu_donnees_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NULL,
    secteur_activite VARCHAR(40) NOT NULL,
    categorie VARCHAR(80) NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    created_by INT NOT NULL,
    created_by_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_jeux_donnees_catalogue (is_active, secteur_activite, categorie)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS jeux_donnees_versions (
    jeu_donnees_version_id INT AUTO_INCREMENT PRIMARY KEY,
    jeu_donnees_id INT NOT NULL,
    version_number INT NOT NULL,
    items_json LONGTEXT NOT NULL,
    created_by INT NOT NULL,
    created_by_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_jeu_donnees_version (jeu_donnees_id, version_number),
    CONSTRAINT fk_jeu_donnees_version_parent FOREIGN KEY (jeu_donnees_id)
        REFERENCES jeux_donnees(jeu_donnees_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_jeu_donnees_version_creator (created_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS jeux_donnees_importations (
    importation_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    jeu_donnees_id INT NOT NULL,
    jeu_donnees_version_id INT NOT NULL,
    entreprise_id INT NOT NULL,
    succursale_id INT NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    user_id INT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    resultat_json LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_jeu_import_entreprise (entreprise_id, created_at),
    CONSTRAINT fk_jeu_import_dataset FOREIGN KEY (jeu_donnees_id)
        REFERENCES jeux_donnees(jeu_donnees_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_jeu_import_version FOREIGN KEY (jeu_donnees_version_id)
        REFERENCES jeux_donnees_versions(jeu_donnees_version_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_jeu_import_entreprise FOREIGN KEY (entreprise_id)
        REFERENCES entreprises(entreprise_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_jeu_import_user (user_id),
    INDEX idx_jeu_import_branch (succursale_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS jeux_donnees_references (
    reference_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    succursale_id INT NOT NULL,
    jeu_donnees_id INT NOT NULL,
    jeu_donnees_version_id INT NOT NULL,
    user_id INT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    reference_type VARCHAR(30) NOT NULL,
    name VARCHAR(120) NOT NULL,
    details_json LONGTEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_dataset_reference (entreprise_id, succursale_id, reference_type, name),
    INDEX idx_dataset_reference_scope (entreprise_id, succursale_id, reference_type),
    CONSTRAINT fk_dataset_reference_enterprise FOREIGN KEY (entreprise_id)
        REFERENCES entreprises(entreprise_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dataset_reference_branch FOREIGN KEY (succursale_id)
        REFERENCES succursales(succursale_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_dataset_reference_dataset FOREIGN KEY (jeu_donnees_id)
        REFERENCES jeux_donnees(jeu_donnees_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_dataset_reference_version FOREIGN KEY (jeu_donnees_version_id)
        REFERENCES jeux_donnees_versions(jeu_donnees_version_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_dataset_reference_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
