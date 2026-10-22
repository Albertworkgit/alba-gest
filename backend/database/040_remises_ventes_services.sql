SET @add_service_discount_percent = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vente_service_details' AND COLUMN_NAME = 'discount_percent') = 0,
    'ALTER TABLE vente_service_details ADD COLUMN discount_percent DECIMAL(7,2) NOT NULL DEFAULT 0 AFTER unit_price',
    'SELECT 1'
);
PREPARE add_service_discount_percent_stmt FROM @add_service_discount_percent;
EXECUTE add_service_discount_percent_stmt;
DEALLOCATE PREPARE add_service_discount_percent_stmt;

SET @add_service_discount_amount = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'vente_service_details' AND COLUMN_NAME = 'discount_amount') = 0,
    'ALTER TABLE vente_service_details ADD COLUMN discount_amount DECIMAL(15,2) NOT NULL DEFAULT 0 AFTER discount_percent',
    'SELECT 1'
);
PREPARE add_service_discount_amount_stmt FROM @add_service_discount_amount;
EXECUTE add_service_discount_amount_stmt;
DEALLOCATE PREPARE add_service_discount_amount_stmt;