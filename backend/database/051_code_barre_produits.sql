ALTER TABLE produits
    ADD COLUMN code_barre VARCHAR(100) NULL DEFAULT NULL AFTER sku,
    ADD UNIQUE KEY uq_produits_code_barre (entreprise_id, code_barre);