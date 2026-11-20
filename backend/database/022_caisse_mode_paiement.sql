ALTER TABLE caisses
    ADD COLUMN mode_paiement_id INT NULL AFTER type_caisse_id,
    ADD CONSTRAINT fk_caisse_mode_paiement FOREIGN KEY (mode_paiement_id) REFERENCES modes_paiement(mode_paiement_id) ON DELETE RESTRICT,
    ADD INDEX idx_caisses_mode_ouverte (entreprise_id, succursale_id, type_caisse_id, mode_paiement_id, statut);

UPDATE caisses c
JOIN modes_paiement m ON m.code='CASH'
SET c.mode_paiement_id=m.mode_paiement_id
WHERE c.mode_paiement_id IS NULL;

ALTER TABLE caisses
    MODIFY mode_paiement_id INT NOT NULL;
