ALTER TABLE users
    ADD COLUMN interface_theme VARCHAR(20) NULL DEFAULT NULL AFTER preferred_language;
