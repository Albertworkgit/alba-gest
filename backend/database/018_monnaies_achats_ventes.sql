ALTER TABLE achats ADD COLUMN monais VARCHAR(10) NULL AFTER total_amount;
ALTER TABLE ventes ADD COLUMN monais VARCHAR(10) NULL AFTER total_amount;

UPDATE achats a
JOIN (
    SELECT ad.entreprise_id, ad.achat_id, MIN(p.monais) AS monais
    FROM achat_details ad
    JOIN produits p ON p.produit_id = ad.produit_id AND p.entreprise_id = ad.entreprise_id
    GROUP BY ad.entreprise_id, ad.achat_id
) currencies ON currencies.entreprise_id = a.entreprise_id AND currencies.achat_id = a.achat_id
SET a.monais = currencies.monais
WHERE a.monais IS NULL;

UPDATE ventes v
JOIN (
    SELECT vd.entreprise_id, vd.vente_id, MIN(p.monais) AS monais
    FROM vente_details vd
    JOIN produits p ON p.produit_id = vd.produit_id AND p.entreprise_id = vd.entreprise_id
    GROUP BY vd.entreprise_id, vd.vente_id
) currencies ON currencies.entreprise_id = v.entreprise_id AND currencies.vente_id = v.vente_id
SET v.monais = currencies.monais
WHERE v.monais IS NULL;
