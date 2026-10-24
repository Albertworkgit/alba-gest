CREATE TABLE IF NOT EXISTS super_admin_notification_settings (
    setting_id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
    registration_email VARCHAR(150) NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT IGNORE INTO super_admin_notification_settings (setting_id, registration_email)
VALUES (1, NULL);
