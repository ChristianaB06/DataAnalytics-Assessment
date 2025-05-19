# DataAnalytics-Assessment

Pre Assessment: The data was loaded to a Mysql DB instance. The sqldump contained a database called adashi_staging and the following tables;
plans_plan
savings_savingsaccount
users_customuser
withdrawals_withdrawal



1. High-Value Customers with Multiple Products

Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.


What was done:

Queried the users_customuser, savings_savingsaccount, and plans_plan tables.
Counted the number of funded savings accounts (confirmed_amount > 0) and funded investment plans (amount > 0 AND is_fixed_investment = 1) per customer.
Calculated total deposits by adding savings and investment amounts.
Filtered customers who had both products and sorted by total deposits (descending).

2. Transaction Frequency Analysis

Task: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)


What was done:

Used savings_savingsaccount to count transactions per user.
Calculated active months by finding the time span between first and last transaction.
Computed average monthly frequency and categorized customers using CASE logic.
Aggregated by category to show customer count and average frequency per group.


3. Account Inactivity alert

Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .

What was done:

Queried savings_savingsaccount to identify savings plans with no recent transactions.
Queried plans_plan (LEFT JOIN with savings_savingsaccount) to identify investment plans with no transactions or only old ones.
Used DATEDIFF() to compute inactivity days, and filtered for inactivity ≥ 365 days.
Unified both result sets using UNION with a type label ("Savings" or "Investment").

4. Customer Lifetime Value (CLV) Estimate

Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
      Account tenure (months since signup)
      Total transactions
      Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
      Order by estimated CLV from highest to lowest


What was done:

Calculated account tenure using date_joined.
Counted savings transactions and computed the average profit per transaction (0.1% of amount).
Applied the CLV formula for each customer.
Filtered out accounts with tenure = 0 to avoid divide-by-zero errors.
Sorted results by estimated CLV in descending order.

