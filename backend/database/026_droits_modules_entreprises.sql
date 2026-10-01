CREATE TABLE IF NOT EXISTS entreprise_droits_modules (
    entreprise_id INT NOT NULL PRIMARY KEY,
    modules_autorises JSON NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_droits_modules_entreprise FOREIGN KEY (entreprise_id)
        REFERENCES entreprises(entreprise_id) ON DELETE CASCADE
) ENGINE=InnoDB;