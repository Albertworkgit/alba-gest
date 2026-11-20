ALTER TABLE entreprises
    ADD COLUMN activity_type VARCHAR(30) NOT NULL DEFAULT 'commercial' AFTER name,
    ADD COLUMN theme_color VARCHAR(20) NOT NULL DEFAULT 'teal' AFTER activity_type;
