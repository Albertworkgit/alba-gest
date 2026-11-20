ALTER TABLE users
    ADD COLUMN preferred_language VARCHAR(5) NOT NULL DEFAULT 'fr' AFTER is_active;

ALTER TABLE super_admins
    ADD COLUMN preferred_language VARCHAR(5) NOT NULL DEFAULT 'fr' AFTER is_active;
