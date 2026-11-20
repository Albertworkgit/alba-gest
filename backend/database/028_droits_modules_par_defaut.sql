INSERT IGNORE INTO entreprise_droits_modules (entreprise_id, modules_autorises)
SELECT entreprise_id,
       JSON_ARRAY('stock', 'approvisionnements', 'ventes', 'caisse', 'comptabilite', 'utilisateurs', 'rapports', 'administration')
FROM entreprises;