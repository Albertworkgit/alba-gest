ALTER TABLE ecritures_comptables
    MODIFY COLUMN statut ENUM('BROUILLON', 'VALIDEE', 'ANNULEE') NOT NULL DEFAULT 'VALIDEE';

CREATE TABLE IF NOT EXISTS demandes_annulation_ecritures (
    demande_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    ecriture_id BIGINT NOT NULL,
    demandeur_id INT NULL,
    motif VARCHAR(500) NOT NULL,
    statut ENUM('EN_ATTENTE', 'APPROUVEE', 'REFUSEE') NOT NULL DEFAULT 'EN_ATTENTE',
    decision_par INT NULL,
    motif_decision VARCHAR(500) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    decision_at DATETIME NULL,
    KEY idx_demande_annulation_statut (entreprise_id, statut, created_at),
    KEY idx_demande_annulation_ecriture (entreprise_id, ecriture_id, statut),
    CONSTRAINT fk_demande_annulation_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_demande_annulation_ecriture FOREIGN KEY (ecriture_id) REFERENCES ecritures_comptables(ecriture_id) ON DELETE CASCADE,
    CONSTRAINT fk_demande_annulation_demandeur FOREIGN KEY (demandeur_id) REFERENCES users(user_id) ON DELETE SET NULL,
    CONSTRAINT fk_demande_annulation_decisionnaire FOREIGN KEY (decision_par) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;