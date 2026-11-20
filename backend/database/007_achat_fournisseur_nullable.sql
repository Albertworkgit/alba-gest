-- Rend le fournisseur facultatif pour les mouvements de stock sans fournisseur.
ALTER TABLE achats
    MODIFY COLUMN fournisseur_id INT NULL;
