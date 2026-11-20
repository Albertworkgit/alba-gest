INSERT INTO modes_paiement (code,name,requires_cash,is_active)
VALUES ('CASH','Caisse',1,1),('BANK','Banque',0,1),('MOBILE_MONEY','Mobile Money',0,1)
ON DUPLICATE KEY UPDATE name=VALUES(name),requires_cash=VALUES(requires_cash),is_active=1;

UPDATE modes_paiement
SET is_active=0
WHERE code NOT IN ('CASH','BANK','MOBILE_MONEY');
