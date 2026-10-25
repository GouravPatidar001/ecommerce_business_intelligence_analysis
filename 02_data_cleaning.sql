show databases;
use ecommerce_analytics;

-- 1. Check for Duplicate Customers (by name and signup date)
SELECT customer_name, signup_date, COUNT(*) as duplicate_count
FROM customers
GROUP BY customer_name, signup_date
HAVING COUNT(*) > 1;

-- 2. Identify Missing Values / Null Checks in Critical Fields
SELECT 
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS missing_customer_names,
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS missing_cities,
    SUM(CASE WHEN signup_date IS NULL THEN 1 ELSE 0 END) AS missing_signup_dates
FROM customers;

-- 3. Sanity Check: Identify Invalid Financials (Negative or Zero Unit Prices / Quantities)
SELECT order_item_id, order_id, product_id, quantity, unit_price
FROM order_items
WHERE quantity <= 0 OR unit_price <= 0;

-- 4. Check for Orphaned Order Items (Items referencing a non-existent order)
SELECT oi.order_item_id, oi.order_id
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 5. Standardize Order Status Values (Check for inconsistencies like 'Complete' vs 'Completed')
SELECT status, COUNT(*) as status_count
FROM orders
GROUP BY status;

-- 6. Date Consistency Check: Ensure orders do not precede customer signup dates
select o.order_id, c.signup_date, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date < c.signup_date;

