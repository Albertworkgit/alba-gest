ALTER TABLE succursales
    ADD COLUMN partager_produits_mere TINYINT(1) NOT NULL DEFAULT 1 AFTER est_sucursal_mere;

ALTER TABLE produits
    ADD COLUMN succursale_origine_id INT NULL AFTER entreprise_id,
    ADD INDEX idx_produits_succursale_origine (entreprise_id, succursale_origine_id);

UPDATE produits p
JOIN succursales s ON s.entreprise_id = p.entreprise_id AND s.est_sucursal_mere = 1
SET p.succursale_origine_id = s.succursale_id
WHERE p.succursale_origine_id IS NULL;

UPDATE produits p
SET p.succursale_origine_id = (
    SELECT MIN(s.succursale_id)
    FROM succursales s
    WHERE s.entreprise_id = p.entreprise_id
)
WHERE p.succursale_origine_id IS NULL;
