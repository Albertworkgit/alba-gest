-- Aligne les bases existantes sur sql_bdd.txt : un produit non périssable n'a pas de date.
ALTER TABLE produits
    MODIFY COLUMN date_expiration DATE NULL DEFAULT NULL;
