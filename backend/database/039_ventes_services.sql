CREATE TABLE IF NOT EXISTS vente_service_details (
    vente_service_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    entreprise_id INT NOT NULL,
    vente_id INT NOT NULL,
    service_name VARCHAR(150) NOT NULL,
    quantity DECIMAL(12,3) NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    monais VARCHAR(10) NOT NULL,
    subtotal DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vente_service_detail_entreprise FOREIGN KEY (entreprise_id) REFERENCES entreprises(entreprise_id) ON DELETE CASCADE,
    CONSTRAINT fk_vente_service_detail_vente FOREIGN KEY (vente_id) REFERENCES ventes(vente_id) ON DELETE CASCADE,
    INDEX idx_vente_service_details_vente (entreprise_id, vente_id)
) ENGINE=InnoDB;
