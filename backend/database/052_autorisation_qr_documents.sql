ALTER TABLE entreprises
    ADD COLUMN qr_codes_enabled TINYINT(1) NOT NULL DEFAULT 0;

ALTER TABLE succursales
    ADD COLUMN qr_codes_enabled TINYINT(1) NOT NULL DEFAULT 0;