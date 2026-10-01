-- Ajoute le sens du mouvement aux approvisionnements existants.
ALTER TABLE achats
    ADD COLUMN movement_type ENUM('IN', 'OUT') NOT NULL DEFAULT 'IN' AFTER total_amount;
