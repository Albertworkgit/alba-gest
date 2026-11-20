-- Stocke les produits et quantités de chaque approvisionnement.
CREATE TABLE IF NOT EXISTS achat_details (
    achat_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    achat_id INT NOT NULL,
    produit_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(15,2) NOT NULL DEFAULT 0,
    subtotal DECIMAL(15,2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_achat_detail_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_achat_detail_achat FOREIGN KEY (achat_id) REFERENCES achats(achat_id) ON DELETE CASCADE,
    CONSTRAINT fk_achat_detail_produit FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE RESTRICT
) ENGINE=InnoDB;
