ALTER TABLE entreprises
    ADD COLUMN max_succursales INT NOT NULL DEFAULT 2 AFTER cachet;

UPDATE entreprises AS e
SET e.max_succursales = GREATEST(
    2,
    (SELECT COUNT(*) FROM succursales AS s WHERE s.entreprise_id = e.entreprise_id)
);
