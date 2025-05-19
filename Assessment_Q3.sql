-- Savings Accounts with No Recent Transactions 
SELECT
  sav.plan_id,                     
  sav.owner_id,                    
  'Savings' AS type,               
  MAX(sav.transaction_date) AS last_transaction_date, 
  DATEDIFF(CURDATE(), MAX(sav.transaction_date)) AS inactivity_days  -- Days since last transaction
FROM savings_savingsaccount sav
GROUP BY sav.plan_id, sav.owner_id
HAVING MAX(sav.transaction_date) <= DATE_SUB(CURDATE(), INTERVAL 365 DAY)  -- Only include savings inactive for 1+ year

UNION

-- Investment Plans with No Transactions or Inactive 
SELECT
  pln.id AS plan_id,              
  pln.owner_id,                  
  'Investment' AS type,          
  MAX(sav.transaction_date) AS last_transaction_date,  -- Last known transaction date on the plan (if any)
  DATEDIFF(CURDATE(), MAX(sav.transaction_date)) AS inactivity_days  -- Days since last activity
FROM plans_plan pln
LEFT JOIN savings_savingsaccount sav
  ON sav.plan_id = pln.id         
GROUP BY pln.id, pln.owner_id
HAVING MAX(sav.transaction_date) IS NULL  -- No transactions ever
   OR MAX(sav.transaction_date) <= DATE_SUB(CURDATE(), INTERVAL 365 DAY);  -- Or transactions are older than 1 year
