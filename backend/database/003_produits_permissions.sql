-- Ajoute la gestion des produits périssables.
ALTER TABLE produits
    ADD COLUMN IF NOT EXISTS est_perisable TINYINT(1) NOT NULL DEFAULT 0 AFTER cost_price,
    ADD COLUMN IF NOT EXISTS date_expiration DATE NULL AFTER est_perisable;

-- Exemple de permissions pour un rôle administrateur d'entreprise.
-- Les rôles existants peuvent être mis à jour depuis l'interface de gestion des rôles.
-- Valeurs conseillées : voir_stock, creer_produit, modifier_produit,
-- gerer_utilisateurs, gerer_roles, gerer_approvisionnements,
-- voir_rapports, toutes_succursales.
UPDATE roles
SET permissions = '["*", "toutes_succursales"]'
WHERE role_name = 'Administrateur' AND (permissions IS NULL OR permissions = '');
