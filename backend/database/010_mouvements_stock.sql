-- Conserve les mouvements pour les fiches de stock et les justificatifs imprimables.
CREATE TABLE IF NOT EXISTS mouvements_stock (
    mouvement_stock_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    succursale_id INT NOT NULL,
    produit_id INT NOT NULL,
    user_id INT NULL,
    movement_type ENUM('ENTREE','SORTIE','AJUSTEMENT') NOT NULL,
    quantity_before INT NOT NULL,
    quantity_moved INT NOT NULL DEFAULT 0,
    quantity_after INT NOT NULL,
    reference_type VARCHAR(30) NOT NULL,
    reference_id INT NULL,
    note VARCHAR(255) NULL,
    movement_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mouvement_stock_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mouvement_stock_succursale FOREIGN KEY (succursale_id) REFERENCES succursales(succursale_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mouvement_stock_produit FOREIGN KEY (produit_id) REFERENCES produits(produit_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_mouvement_stock_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_mouvement_stock_ledger (entreprise_id, succursale_id, produit_id, movement_date)
) ENGINE=InnoDB;
