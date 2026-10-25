USE ecommerce_analytics;

-- Q10. Who are the top 10 customers by total spending?
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'Cancelled'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spent DESC
LIMIT 10;

-- Q11. Which customers placed more than five orders?
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders_placed
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status != 'Cancelled'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 5;

-- Q12. Which cities have the largest customer base?
SELECT 
    city,
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;

-- Q13. How many new customers signed up each month?
SELECT 
    DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
    COUNT(customer_id) AS new_customers_count
FROM customers
GROUP BY signup_month
ORDER BY signup_month ASC;

-- Q14. What percentage of customers made repeat purchases?
SELECT 
    (SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS repeat_purchase_percentage
FROM (
    SELECT c.customer_id, COUNT(o.order_id) AS order_count
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status != 'Cancelled'
    GROUP BY c.customer_id
) AS customer_orders;

-- Q15. Which customers have not purchased in the last 90 days?
SELECT 
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING last_order_date < DATE_SUB('2026-04-15', INTERVAL 90 DAY)
   OR last_order_date IS NULL;

-- Q16. Which customers have the highest average order value (AOV)?
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id) AS customer_aov
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'Cancelled'
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_aov DESC
LIMIT 10;

