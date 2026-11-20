CREATE TABLE IF NOT EXISTS super_admin_notification_emails (
    email VARCHAR(150) NOT NULL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT IGNORE INTO super_admin_notification_emails (email)
SELECT LOWER(TRIM(registration_email))
FROM super_admin_notification_settings
WHERE setting_id = 1
    AND registration_email IS NOT NULL
    AND TRIM(registration_email) <> '';
