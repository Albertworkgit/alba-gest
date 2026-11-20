-- Date de validation distincte de la date de création, renseignée uniquement à la réception.
ALTER TABLE achats ADD COLUMN validation_date DATETIME NULL AFTER purchase_date;
UPDATE achats SET validation_date = purchase_date WHERE status = 'RECEIVED' AND validation_date IS NULL;
