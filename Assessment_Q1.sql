/*
Purpose_of_Query: This query identify customers who have both a savings
and an investment plan, the query output is ordered in descending order of 
individual customer total deposit.
*/

USE adashi_staging ;

SELECT 
    U.id AS owner_id,
    concat(U.first_name, ' ' ,U.last_name) AS name,
    COUNT(DISTINCT CASE 
        WHEN P.is_regular_savings = 1 THEN P.id 
        END) AS savings_count, -- count distinct savings plan
    COUNT(DISTINCT CASE 
        WHEN P.is_a_fund = 1 THEN P.id 
        END) AS investment_count, -- count distinct investment plan
    ROUND(SUM(S.confirmed_amount) / 100, 2) AS total_deposits -- deposits output in (naira)
FROM 
    users_customuser U
LEFT JOIN 
    plans_plan P ON u.id = P.owner_id
LEFT JOIN 
    savings_savingsaccount S ON S.plan_id = P.id 
WHERE 
    S.confirmed_amount > 0 -- filter for funded plans
GROUP BY 
    U.id, name
HAVING 
    COUNT(DISTINCT CASE 
        WHEN P.is_regular_savings = 1 THEN P.id 
        END) > 0 -- filter for at least one savings plan 
    AND COUNT(DISTINCT CASE 
        WHEN P.is_a_fund = 1 THEN P.id 
        END) > 0 -- filter for at least one investment plan
ORDER BY 
    total_deposits DESC;
