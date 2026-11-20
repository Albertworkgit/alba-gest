-- Marque la succursale principale de chaque entreprise.
ALTER TABLE succursales
    ADD COLUMN est_sucursal_mere TINYINT(1) NOT NULL DEFAULT 0 AFTER code;

-- Attribue le statut mère à la plus ancienne succursale déjà enregistrée par entreprise.
UPDATE succursales AS s
JOIN (
    SELECT entreprise_id, MIN(succursale_id) AS succursale_id
    FROM succursales
    GROUP BY entreprise_id
) AS principale ON principale.succursale_id = s.succursale_id
SET s.est_sucursal_mere = 1;
