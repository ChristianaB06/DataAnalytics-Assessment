-- Estimate CLV for each customer based on their transaction volume and tenure

SELECT
  usr.id AS customer_id,                            
  usr.name,                                         
  TIMESTAMPDIFF(MONTH, usr.date_joined, CURDATE()) AS tenure_months,  -- Months since account signup
  COUNT(sav.id) AS total_transactions,              -- Total number of savings transactions
  ROUND(
    -- computing for CLV with formula: (Txns per month) * 12 * avg profit per txn
    (COUNT(sav.id) / TIMESTAMPDIFF(MONTH, usr.date_joined, CURDATE())) * 12 *
    AVG(sav.amount * 0.001),                        
    2
  ) AS estimated_clv
FROM users_customuser usr
JOIN savings_savingsaccount sav
  ON sav.owner_id = usr.id                          
WHERE usr.date_joined IS NOT NULL                   
GROUP BY usr.id, usr.name, usr.date_joined
HAVING tenure_months > 0                            
ORDER BY estimated_clv DESC;                        
