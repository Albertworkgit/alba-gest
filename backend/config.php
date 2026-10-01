<?php
declare(strict_types=1);

const ALBA_STOCK_ENTERPRISE_ID = 1;
const ALBA_STOCK_ALLOWED_RESOURCES = [
    'succursales' => ['table' => 'succursales', 'key' => 'succursale_id', 'columns' => ['name', 'code', 'est_sucursal_mere', 'address', 'phone']],
    'clients' => ['table' => 'clients', 'key' => 'client_id', 'columns' => ['name', 'email', 'phone', 'address']],
    'fournisseurs' => ['table' => 'fournisseurs', 'key' => 'fournisseur_id', 'columns' => ['succursale_id', 'name', 'contact_name', 'email', 'phone', 'address']],
    'roles' => ['table' => 'roles', 'key' => 'role_id', 'columns' => ['role_name', 'permissions', 'description']],
    'users' => ['table' => 'users', 'key' => 'user_id', 'columns' => ['succursale_id', 'role_id', 'username', 'email', 'full_name', 'is_active']],
    'categories' => ['table' => 'categories', 'key' => 'category_id', 'columns' => ['name', 'description']],
    'unites_mesure' => ['table' => 'unites_mesure', 'key' => 'unite_mesure_id', 'columns' => ['name', 'symbole']],
    'produits' => ['table' => 'produits', 'key' => 'produit_id', 'columns' => ['category_id', 'fournisseur_id', 'unite_de_mesure', 'sku', 'name', 'description', 'unit_price', 'cost_price', 'monais', 'est_perisable', 'is_active']],
    'stocks' => ['table' => 'stocks', 'key' => 'stock_id', 'columns' => ['succursale_id', 'produit_id', 'quantity', 'min_stock_level']],
    'types-caisses' => ['table' => 'types_caisses', 'key' => 'type_caisse_id', 'columns' => ['code', 'name', 'symbole', 'description', 'is_active']],
    'caisses' => ['table' => 'caisses', 'key' => 'caisse_id', 'columns' => ['succursale_id', 'type_caisse_id', 'user_id', 'name', 'date_ouverture', 'date_fermeture', 'solde_ouverture', 'montant', 'solde_fermeture', 'statut']],
    'ventes' => ['table' => 'ventes', 'key' => 'vente_id', 'columns' => ['succursale_id', 'caisse_id', 'user_id', 'client_id', 'invoice_no', 'sale_date', 'total_amount', 'monais', 'amount_paid', 'status']],
    'achats' => ['table' => 'achats', 'key' => 'achat_id', 'columns' => ['succursale_id', 'fournisseur_id', 'user_id', 'purchase_no', 'purchase_date', 'total_amount', 'monais', 'movement_type', 'status']],
];
