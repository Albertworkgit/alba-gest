ALTER TABLE produits
    ADD COLUMN quantite_fractionnaire TINYINT(1) NOT NULL DEFAULT 0 AFTER est_perisable;

ALTER TABLE stocks
    MODIFY quantity DECIMAL(15,3) NOT NULL DEFAULT 0,
    MODIFY min_stock_level DECIMAL(15,3) NOT NULL DEFAULT 5;

ALTER TABLE achat_details
    MODIFY quantity DECIMAL(15,3) NOT NULL,
    MODIFY quantity_out DECIMAL(15,3) NOT NULL DEFAULT 0;

ALTER TABLE achat_detail_sorties
    MODIFY quantity DECIMAL(15,3) NOT NULL;

ALTER TABLE vente_details
    MODIFY quantity DECIMAL(15,3) NOT NULL;

ALTER TABLE vente_detail_lots
    MODIFY quantity DECIMAL(15,3) NOT NULL;

ALTER TABLE mouvements_stock
    MODIFY quantity_before DECIMAL(15,3) NOT NULL,
    MODIFY quantity_moved DECIMAL(15,3) NOT NULL DEFAULT 0,
    MODIFY quantity_after DECIMAL(15,3) NOT NULL;

ALTER TABLE transferts_stock
    MODIFY quantity DECIMAL(15,3) NOT NULL;

ALTER TABLE bon_commande_previsionnel_details
    MODIFY stock_disponible DECIMAL(15,3) NOT NULL,
    MODIFY quantite_recommandee DECIMAL(15,3) NOT NULL,
    MODIFY quantite_commande DECIMAL(15,3) NOT NULL;