ALTER TABLE paiements_dettes_caisse
    ADD COLUMN montant_recu DECIMAL(15,2) NULL AFTER montant,
    ADD COLUMN monais_recue VARCHAR(10) NULL AFTER montant_recu,
    ADD COLUMN taux_change DECIMAL(20,10) NOT NULL DEFAULT 1 AFTER monais_recue;

UPDATE paiements_dettes_caisse p
JOIN dettes_caisse d
    ON d.dette_id = p.dette_id
    AND d.entreprise_id = p.entreprise_id
SET p.montant_recu = p.montant,
    p.monais_recue = d.monais,
    p.taux_change = 1
WHERE p.monais_recue IS NULL OR p.montant_recu IS NULL;

ALTER TABLE paiements_dettes_caisse
    MODIFY COLUMN montant_recu DECIMAL(15,2) NOT NULL,
    MODIFY COLUMN monais_recue VARCHAR(10) NOT NULL,
    MODIFY COLUMN taux_change DECIMAL(20,10) NOT NULL;
