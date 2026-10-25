USE ecommerce_analytics;

-- Q23. What percentage of orders were cancelled?
SELECT 
    (SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS cancellation_rate_percentage
FROM orders;

-- Q24. Which payment methods are most frequently used?
SELECT 
    payment_method,
    COUNT(payment_id) AS usage_count
FROM payments
GROUP BY payment_method
ORDER BY usage_count DESC;

-- Q25. What is the value of successful, failed, pending, and refunded payments?
SELECT 
    payment_status,
    SUM(amount) AS total_payment_value
FROM payments
GROUP BY payment_status;

-- Q26. Which product categories show declining sales? (Quarter over Quarter comparison using CTEs)
WITH quarterly_category_sales AS (
    SELECT 
        p.category,
        QUARTER(o.order_date) AS sales_quarter,
        SUM(oi.quantity * oi.unit_price) AS q_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status != 'Cancelled'
    GROUP BY p.category, sales_quarter
)
SELECT 
    category,
    sales_quarter,
    q_sales
FROM quarterly_category_sales
ORDER BY category, sales_quarter;

-- Q27. What are the top three products within each category? (Using Window Function: ROW_NUMBER)
WITH ranked_products AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS product_sales,
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity * oi.unit_price) DESC) as rn
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY p.category, p.product_id, p.product_name
)
SELECT 
    category,
    product_name,
    product_sales
FROM ranked_products
WHERE rn <= 3;

-- Q28. Which customers contribute the most to total sales? (Pareto / Cumulative Contribution using Window Functions)
WITH customer_sales AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    total_spent,
    SUM(total_spent) OVER (ORDER BY total_spent DESC) AS cumulative_sales
FROM customer_sales
ORDER BY total_spent DESC;

-- Q29. What is the month-over-month sales growth rate? (Using Window Function: LAG)
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS current_month_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'Cancelled'
    GROUP BY sales_month
)
SELECT 
    sales_month,
    current_month_sales,
    LAG(current_month_sales, 1) OVER (ORDER BY sales_month) AS prior_month_sales,
    ((current_month_sales - LAG(current_month_sales, 1) OVER (ORDER BY sales_month)) / 
     LAG(current_month_sales, 1) OVER (ORDER BY sales_month)) * 100 AS mom_growth_percentage
FROM monthly_sales;

-- Q30. Summary of Critical Business Problems (Placeholder query for reporting aggregation)
SELECT 
    'Cancellation & Return Risks' AS problem_category,
    'High cancellation or return rates impacting net profitability' AS description
UNION ALL
SELECT 
    'Customer Churn' AS problem_category,
    'Dormant customer segments requiring targeted re-engagement' AS description;