-- Ajoute le symbole aux unités des bases déjà migrées.
ALTER TABLE unites_mesure
    ADD COLUMN IF NOT EXISTS symbole VARCHAR(15) NOT NULL DEFAULT '';

-- Copie les abréviations existantes si l'ancienne colonne est présente.
SET @copie_ancien_symbole_sql = IF(
    EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema = DATABASE()
          AND table_name = 'unites_mesure'
          AND column_name = 'abbreviation'
    ),
    'UPDATE unites_mesure SET symbole = abbreviation WHERE symbole = '''' AND abbreviation <> ''''',
    'SELECT 1'
);
PREPARE copie_ancien_symbole FROM @copie_ancien_symbole_sql;
EXECUTE copie_ancien_symbole;
DEALLOCATE PREPARE copie_ancien_symbole;
