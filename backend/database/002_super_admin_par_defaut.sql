-- Exécuter après 001_authentification.sql.
-- Le mot de passe est hashé avec password_hash(), jamais stocké en clair.
-- Générer le hash avec : php -r "echo password_hash('supadmin1234', PASSWORD_DEFAULT), PHP_EOL;"
INSERT INTO super_admins (email, password_hash, full_name)
VALUES ('admin@gmail.com', '$2y$10$0HOmG7bF5gbXQqmXRDGa7ONEA6QtgJtEktt4qgJ4maGwrJLzU4ni2', 'Super administrateur')
ON DUPLICATE KEY UPDATE email = VALUES(email);
