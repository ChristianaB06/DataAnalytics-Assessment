SELECT
  usr.id AS owner_id,
  usr.name,
  COUNT(DISTINCT sav.id) AS savings_count,
  COUNT(DISTINCT pln.id) AS investment_count,
  ROUND(COALESCE(COALESCE(SUM(pln.amount), 0),  2) AS total_deposits
FROM users_customuser usr

-- Join only funded savings accounts
INNER JOIN savings_savingsaccount sav
  ON sav.owner_id = usr.id AND sav.amount > 0
  
-- Join only funded investment plans
INNER JOIN plans_plan pln
  ON pln.owner_id = usr.id AND pln.amount > 0 
GROUP BY usr.id, usr.name

-- Ensure each customer has at least one savings and one investment plan
HAVING savings_count > 0 AND investment_count > 0

-- Sort customers by total deposit value
ORDER BY total_deposits DESC;
