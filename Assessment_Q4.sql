
USE adashi_staging;

SELECT 
    U.id AS customer_id,
    CONCAT(U.first_name, ' ', U.last_name) AS name,
    PERIOD_DIFF(DATE_FORMAT(CURRENT_DATE, '%Y%m'), DATE_FORMAT(U.date_joined, '%Y%m')) + 1 AS tenure_months, -- getting months since signups until now
    ROUND(SUM(S.confirmed_amount) / 100, 2) AS total_transactions, -- total trasaction per customer in naira
    ROUND(ROUND((SUM(S.confirmed_amount) / (PERIOD_DIFF(DATE_FORMAT(CURRENT_DATE, '%Y%m'), DATE_FORMAT(U.date_joined, '%Y%m')) + 1)) * 12 * 0.001, 2) / 100, 2) AS estimated_clv -- estimated_clv calclated in naira
FROM 
    users_customuser U
LEFT JOIN 
    savings_savingsaccount S ON U.id = S.owner_id
GROUP BY 
    U.id
ORDER BY 
    estimated_clv DESC;