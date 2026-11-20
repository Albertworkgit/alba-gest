ALTER TABLE entreprises
    ADD COLUMN vente_services_autorisee TINYINT(1) NOT NULL DEFAULT 1;

ALTER TABLE succursales
    ADD COLUMN vente_services_autorisee TINYINT(1) NOT NULL DEFAULT 1;
