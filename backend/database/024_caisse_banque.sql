ALTER TABLE caisses
    ADD COLUMN banque_id INT NULL AFTER mode_paiement_id,
    ADD CONSTRAINT fk_caisse_banque FOREIGN KEY (banque_id) REFERENCES banques(banque_id) ON DELETE RESTRICT,
    ADD INDEX idx_caisses_banque (entreprise_id, banque_id);
