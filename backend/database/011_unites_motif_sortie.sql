-- Ajoute les unités de mesure propres à chaque entreprise et le motif des sorties.
CREATE TABLE IF NOT EXISTS unites_mesure (
    unite_mesure_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    symbole VARCHAR(15) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_unite_entreprise_name (entreprise_id, name),
    CONSTRAINT fk_unite_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

ALTER TABLE produits
    ADD COLUMN IF NOT EXISTS unite_de_mesure INT NULL AFTER monais;

ALTER TABLE achats
    ADD COLUMN IF NOT EXISTS motif_sortie VARCHAR(255) NULL AFTER movement_type;

-- Crée une unité générique pour les produits déjà présents.
INSERT INTO unites_mesure (entreprise_id, name, symbole)
SELECT e.entreprise_id, 'Unité', 'u'
FROM entreprises e
WHERE NOT EXISTS (
    SELECT 1 FROM unites_mesure u
    WHERE u.entreprise_id = e.entreprise_id AND u.name = 'Unité'
);

UPDATE produits p
JOIN unites_mesure u ON u.entreprise_id = p.entreprise_id AND u.name = 'Unité'
SET p.unite_de_mesure = u.unite_mesure_id
WHERE p.unite_de_mesure IS NULL;
