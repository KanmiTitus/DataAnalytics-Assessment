/*
Purpose_of_query: This query find all active accounts savings or investments
with no transactions in the last 1 year (365 days). It is ordered in descending 
order of inactivity days.

*/

USE adashi_staging;

SELECT 
    P.id AS plan_id,
    P.owner_id AS owner_id,
    CASE 
        WHEN P.is_regular_savings = 1 THEN 'Savings'
        WHEN P.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type, -- Categorize account type in understandable output, using the necessary datapoints
    DATE(MAX(S.transaction_date)) AS last_transaction_date, -- maximum transaction date
    DATEDIFF(CURDATE(), MAX(S.transaction_date)) AS inactivity_days -- account inactive days without inflow
FROM 
    plans_plan P
LEFT JOIN 
    savings_savingsaccount S 
    ON P.id = S.plan_id AND S.confirmed_amount > 0 -- filter for actual meaningful amount of inflows
WHERE 
    (P.is_regular_savings = 1 OR P.is_a_fund = 1)
GROUP BY 
    P.id, P.owner_id, type
HAVING 
    MAX(S.transaction_date) IS NULL OR DATEDIFF(CURDATE(), MAX(S.transaction_date)) > 365 -- filter for over a year
ORDER BY 
    inactivity_days DESC;
