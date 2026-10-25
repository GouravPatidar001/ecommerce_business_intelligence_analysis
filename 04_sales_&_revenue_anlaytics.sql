USE ecommerce_analytics;

-- Q1. How many orders were placed during the analysis period?
SELECT COUNT(*) AS total_orders 
FROM orders;

-- Q2. What is the total sales value (excluding cancelled orders)?
SELECT SUM(oi.quantity * oi.unit_price) AS total_sales_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled';

-- Q3. What is the average order value (AOV)?
SELECT 
    SUM(oi.quantity * oi.unit_price) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled';

-- Q4. Which months had the highest and lowest sales?
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'Cancelled'
GROUP BY sales_month
ORDER BY monthly_sales DESC;

-- Q5. Which product categories generated the highest sales?
SELECT 
    p.category,
    SUM(oi.quantity * oi.unit_price) AS category_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.category
ORDER BY category_sales DESC;

-- Q6. Which cities generated the most sales?
SELECT 
    c.city,
    SUM(oi.quantity * oi.unit_price) AS city_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'Cancelled'
GROUP BY c.city
ORDER BY city_sales DESC;

-- Q7. How many orders were completed, cancelled, or pending?
SELECT 
    status,
    COUNT(*) AS order_count
FROM orders
GROUP BY status;

-- Q8. What are the top 10 products by sales value?
SELECT 
    p.product_name,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS product_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY product_sales DESC
LIMIT 10;

-- Q9. How has monthly sales performance changed over time?
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'Cancelled'
GROUP BY sales_month
ORDER BY sales_month ASC;
