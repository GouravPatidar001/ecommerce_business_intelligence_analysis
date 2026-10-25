USE ecommerce_analytics;

-- Q17. Which products generate the highest sales?
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_product_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_product_sales DESC;

-- Q18. Which products generate the highest estimated gross profit?
-- Formula: sum(quantity * (unit_price - cost_price))
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity * (oi.unit_price - p.cost_price)) AS estimated_gross_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY estimated_gross_profit DESC;

-- Q19. Which categories have the highest gross profit margins?
SELECT 
    p.category,
    SUM(oi.quantity * oi.unit_price) AS category_sales,
    SUM(oi.quantity * (oi.unit_price - p.cost_price)) AS category_profit,
    (SUM(oi.quantity * (oi.unit_price - p.cost_price)) / SUM(oi.quantity * oi.unit_price)) * 100 AS profit_margin_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.category
ORDER BY profit_margin_percentage DESC;

-- Q20. Which products have high sales but low profit margins?
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    (SUM(oi.quantity * (oi.unit_price - p.cost_price)) / SUM(oi.quantity * oi.unit_price)) * 100 AS profit_margin_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_sales DESC, profit_margin_percentage ASC;

-- Q21. Which products have the highest return rates?
-- Return Rate = (Total Units Returned / Total Units Sold) * 100
SELECT 
    p.product_id,
    p.product_name,
    COALESCE(SUM(oi.quantity), 0) AS total_sold,
    COALESCE(SUM(r_agg.returned_qty), 0) AS total_returned,
    (COALESCE(SUM(r_agg.returned_qty), 0) * 100.0 / NULLIF(SUM(oi.quantity), 0)) AS return_rate_percentage
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status != 'Cancelled'
LEFT JOIN (
    SELECT product_id, SUM(1) AS returned_qty -- assuming 1 row per return item instance
    FROM returns
    GROUP BY product_id
) r_agg ON p.product_id = r_agg.product_id
GROUP BY p.product_id, p.product_name
ORDER BY return_rate_percentage DESC;

-- Q22. What are the most common product return reasons?
SELECT 
    reason,
    COUNT(*) AS return_count
FROM returns
GROUP BY reason
ORDER BY return_count DESC;