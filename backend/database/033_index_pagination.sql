-- Indexes pour les filtres entreprise/succursale et le tri des listes paginées.
ALTER TABLE succursales ADD INDEX idx_succursales_page (entreprise_id, succursale_id);
ALTER TABLE clients ADD INDEX idx_clients_page (entreprise_id, client_id);
ALTER TABLE roles ADD INDEX idx_roles_page (entreprise_id, role_id);
ALTER TABLE unites_mesure ADD INDEX idx_unites_page (entreprise_id, unite_mesure_id);

ALTER TABLE produits
    ADD INDEX idx_produits_page (entreprise_id, produit_id),
    ADD INDEX idx_produits_actifs_nom (entreprise_id, is_active, name, produit_id);

ALTER TABLE fournisseurs
    ADD INDEX idx_fournisseurs_page (entreprise_id, fournisseur_id),
    ADD INDEX idx_fournisseurs_succursale_page (entreprise_id, succursale_id, fournisseur_id);

ALTER TABLE users
    ADD INDEX idx_users_page (entreprise_id, user_id),
    ADD INDEX idx_users_succursale_page (entreprise_id, succursale_id, user_id);

ALTER TABLE caisses
    ADD INDEX idx_caisses_page (entreprise_id, caisse_id),
    ADD INDEX idx_caisses_succursale_date (entreprise_id, succursale_id, date_ouverture, caisse_id);

ALTER TABLE ventes
    ADD INDEX idx_ventes_page (entreprise_id, vente_id),
    ADD INDEX idx_ventes_succursale_date (entreprise_id, succursale_id, sale_date, vente_id),
    ADD INDEX idx_ventes_date (entreprise_id, sale_date, vente_id),
    ADD INDEX idx_ventes_pending_page (entreprise_id, status, succursale_id, sale_date, vente_id);

ALTER TABLE achats
    ADD INDEX idx_achats_page (entreprise_id, achat_id),
    ADD INDEX idx_achats_succursale_date (entreprise_id, succursale_id, purchase_date, achat_id),
    ADD INDEX idx_achats_status_date (entreprise_id, status, purchase_date, achat_id);

ALTER TABLE stocks ADD INDEX idx_stocks_product_branch (entreprise_id, produit_id, succursale_id);
ALTER TABLE vente_details ADD INDEX idx_vente_details_vente (entreprise_id, vente_id);
ALTER TABLE achat_details ADD INDEX idx_achat_details_achat (entreprise_id, achat_id);

ALTER TABLE mouvements_caisse
    ADD INDEX idx_mouvements_caisse_date (entreprise_id, movement_date, mouvement_id),
    ADD INDEX idx_mouvements_caisse_caisse_date (caisse_id, movement_date, mouvement_id);

ALTER TABLE ecritures_comptables
    ADD INDEX idx_ecritures_page (entreprise_id, statut, date_ecriture, ecriture_id);
