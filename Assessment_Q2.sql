-- Create CTE to Summarize user transactions
WITH user_txn_summary AS (
  SELECT
    usr.id AS user_id,
    
    -- Count total savings transactions per user
    COUNT(sav.id) AS total_txns,
    
    -- Calculate how many months the user's transactions span
    TIMESTAMPDIFF(MONTH, MIN(sav.transaction_date), MAX(sav.transaction_date)) + 1 AS active_months

  FROM users_customuser u
  JOIN savings_savingsaccount s
    ON sav.owner_id = usr.id  -- Join each user to their savings transactions
  GROUP BY usr.id           -- Group by user to get per-user summaries
),

-- Another CTE to Calculate frequency category per user
user_freq AS (
  SELECT
    user_id,
    total_txns,
    active_months,

    -- Compute the average number of transactions per month
    ROUND(total_txns / active_months, 2) AS avg_txn_per_month,

    -- Categorize users based on their frequency
    CASE
      WHEN total_txns / active_months >= 10 THEN 'High Frequency'
      WHEN total_txns / active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM user_txn_summary
)

-- Group and summarize the frequency categories
SELECT
  frequency_category,                        
  COUNT(user_id) AS customer_count,         
  ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month  
FROM user_freq
GROUP BY frequency_category
ORDER BY frequency_category;  