ALTER TABLE caisses
    ADD COLUMN montant DECIMAL(15,2) NOT NULL DEFAULT 0 COMMENT 'Solde courant réel de la caisse' AFTER solde_ouverture;

UPDATE caisses c
SET montant = c.solde_ouverture + COALESCE((
    SELECT SUM(CASE
        WHEN m.type = 'ENTREE' THEN m.amount
        ELSE -m.amount
    END)
    FROM mouvements_caisse m
    WHERE m.caisse_id = c.caisse_id
      AND m.entreprise_id = c.entreprise_id
), 0);

UPDATE caisses
SET solde_fermeture = montant
WHERE statut = 'FERMEE';
