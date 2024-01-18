-- 1. Get number of monthly active customers.
SELECT COUNT(DISTINCT customer_id) AS monthly_active_customers
FROM payment
WHERE DATE_FORMAT(payment_date, '%Y-%m') = 'yyyy-mm';

-- 2. Active users in the previous month.
SELECT COUNT(DISTINCT customer_id) AS active_users_previous_month
FROM payment
WHERE YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
    AND MONTH(payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH);
    
-- 3. Percentage change in the number of active customers.
SELECT 
    ((current_active_customers - previous_active_customers) / previous_active_customers) * 100 AS percentage_change
FROM
    (SELECT 
        COUNT(DISTINCT customer_id) AS current_active_customers
    FROM
        payment
    WHERE
        YEAR(payment_date) = YEAR(CURRENT_DATE)
        AND MONTH(payment_date) = MONTH(CURRENT_DATE)) AS curr,
    (SELECT 
        COUNT(DISTINCT customer_id) AS previous_active_customers
    FROM
        payment
    WHERE
        YEAR(payment_date) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
        AND MONTH(payment_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)) AS prev;
        
-- 4. Retained customers every month.
SELECT 
    MONTH(p1.payment_date) AS month,
    COUNT(DISTINCT p1.customer_id) AS retained_customers
FROM
    payment p1
JOIN
    payment p2 ON p1.customer_id = p2.customer_id
    AND YEAR(p2.payment_date) = YEAR(p1.payment_date - INTERVAL 1 MONTH)
    AND MONTH(p2.payment_date) = MONTH(p1.payment_date - INTERVAL 1 MONTH)
GROUP BY
    MONTH(p1.payment_date);