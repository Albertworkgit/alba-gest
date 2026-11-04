CREATE TABLE IF NOT EXISTS bons_commande_previsionnels (
    bon_previsionnel_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    succursale_id INT NOT NULL,
    user_id INT NOT NULL,
    reference VARCHAR(50) NOT NULL,
    status ENUM('DRAFT', 'TRANSMITTED', 'CANCELLED') NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transmitted_at DATETIME NULL,
    UNIQUE KEY uq_bon_previsionnel_reference (entreprise_id, reference),
    KEY idx_bon_previsionnel_branch (entreprise_id, succursale_id, status, created_at),
    CONSTRAINT fk_bon_previsionnel_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_bon_previsionnel_succursale FOREIGN KEY (succursale_id) REFERENCES succursales(succursale_id) ON DELETE CASCADE,
    CONSTRAINT fk_bon_previsionnel_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS bon_commande_previsionnel_details (
    detail_previsionnel_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    bon_previsionnel_id INT NOT NULL,
    produit_id INT NOT NULL,
    fournisseur_id INT NULL,
    stock_disponible INT NOT NULL,
    mad DECIMAL(15,4) NOT NULL DEFAULT 0,
    cmm DECIMAL(15,4) NOT NULL DEFAULT 0,
    quantite_recommandee INT NOT NULL,
    quantite_commande INT NOT NULL,
    unit_cost DECIMAL(15,2) NOT NULL DEFAULT 0,
    monais VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY idx_bon_previsionnel_details (entreprise_id, bon_previsionnel_id),
    CONSTRAINT fk_bon_previsionnel_detail_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_bon_previsionnel_detail_bon FOREIGN KEY (bon_previsionnel_id) REFERENCES bons_commande_previsionnels(bon_previsionnel_id) ON DELETE CASCADE,
    CONSTRAINT fk_bon_previsionnel_detail_produit FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE RESTRICT,
    CONSTRAINT fk_bon_previsionnel_detail_fournisseur FOREIGN KEY (fournisseur_id) REFERENCES fournisseurs(fournisseur_id) ON DELETE SET NULL
) ENGINE=InnoDB;
