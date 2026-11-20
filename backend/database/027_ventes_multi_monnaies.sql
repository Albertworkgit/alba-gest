ALTER TABLE vente_details
    ADD COLUMN monais VARCHAR(10) NULL AFTER produit_id;

UPDATE vente_details d
JOIN produits p ON p.produit_id = d.produit_id AND p.entreprise_id = d.entreprise_id
SET d.monais = p.monais
WHERE d.monais IS NULL;

ALTER TABLE vente_details
    MODIFY COLUMN monais VARCHAR(10) NOT NULL;

ALTER TABLE paiements_ventes
    ADD COLUMN monais VARCHAR(10) NULL AFTER amount;

UPDATE paiements_ventes p
JOIN ventes v ON v.vente_id = p.vente_id AND v.entreprise_id = p.entreprise_id
SET p.monais = COALESCE(
    v.monais,
    (SELECT MIN(d.monais)
     FROM vente_details d
     WHERE d.vente_id = p.vente_id AND d.entreprise_id = p.entreprise_id)
)
WHERE p.monais IS NULL;

CREATE TABLE IF NOT EXISTS vente_totaux_monnaies (
    entreprise_id INT NOT NULL,
    vente_id INT NOT NULL,
    monais VARCHAR(10) NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    amount_paid DECIMAL(15,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (entreprise_id, vente_id, monais),
    KEY idx_vente_totaux_monnaies (entreprise_id, monais),
    CONSTRAINT fk_vente_totaux_entreprise FOREIGN KEY (entreprise_id)
        REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_vente_totaux_vente FOREIGN KEY (vente_id)
        REFERENCES ventes(vente_id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO vente_totaux_monnaies (entreprise_id, vente_id, monais, total_amount, amount_paid)
SELECT d.entreprise_id,
       d.vente_id,
       d.monais,
       SUM(d.subtotal),
       COALESCE(MAX(payment_totals.amount_paid), 0)
FROM vente_details d
LEFT JOIN (
    SELECT entreprise_id,
           vente_id,
           monais,
           SUM(CASE WHEN payment_type = 'PAYMENT' THEN amount ELSE -amount END) AS amount_paid
    FROM paiements_ventes
    GROUP BY entreprise_id, vente_id, monais
) payment_totals
    ON payment_totals.entreprise_id = d.entreprise_id
    AND payment_totals.vente_id = d.vente_id
    AND payment_totals.monais = d.monais
GROUP BY d.entreprise_id, d.vente_id, d.monais;