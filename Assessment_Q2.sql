
WITH transaction_data AS (
    SELECT 
        U.id AS user_id,
        COUNT(S.id) AS total_transactions,
        DATE_FORMAT(MIN(DATE(S.transaction_date)), '%Y-%m-01') AS transaction_first_month,
        DATE_FORMAT(MAX(DATE(S.transaction_date)), '%Y-%m-01') AS transaction_last_month
    FROM 
        users_customuser U
    JOIN 
        plans_plan P ON u.id = P.owner_id
    JOIN 
        savings_savingsaccount S ON S.plan_id = P.id
    WHERE 
        S.confirmed_amount > 0
    GROUP BY 
        U.id
), 
 transaction_frequency AS (
    SELECT 
        user_id,
        total_transactions,
        GREATEST(PERIOD_DIFF(DATE_FORMAT(transaction_last_month, '%Y%m'), DATE_FORMAT(transaction_first_month, '%Y%m')) + 1, 1) AS active_months,
        total_transactions * 1.0 / GREATEST(PERIOD_DIFF(DATE_FORMAT(transaction_last_month, '%Y%m'), DATE_FORMAT(transaction_first_month, '%Y%m')) + 1, 1) AS avg_transaction_per_month
    FROM 
        transaction_data
)

SELECT 
    CASE 
        WHEN avg_transaction_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transaction_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(user_id) AS customer_count,
    ROUND(AVG(avg_transaction_per_month), 1) AS avg_transactions_per_month
FROM 
    transaction_frequency
GROUP BY 
    frequency_category;