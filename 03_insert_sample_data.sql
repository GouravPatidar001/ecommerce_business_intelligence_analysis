USE ecommerce_analytics;

-- 1. Insert Customers
INSERT INTO customers (customer_name, city, signup_date) VALUES
('Aarav Sharma', 'Mumbai', '2026-01-10'),
('Priya Verma', 'Bangalore', '2026-01-15'),
('Rahul Gupta', 'Delhi', '2026-02-01'),
('Sneha Patel', 'Ahmedabad', '2026-02-10'),
('Amit Kumar', 'Kolkata', '2026-03-05');

-- 2. Insert Products
INSERT INTO products (product_name, category, cost_price) VALUES
('Wireless Mouse', 'Electronics', 400.00),
('Mechanical Keyboard', 'Electronics', 1200.00),
('Running Shoes', 'Sports', 1500.00),
('Cotton T-Shirt', 'Apparel', 300.00),
('Bluetooth Speaker', 'Electronics', 1800.00);

-- 3. Insert Orders
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2026-03-10 14:30:00', 'Completed'),
(2, '2026-03-12 11:15:00', 'Completed'),
(3, '2026-03-15 16:45:00', 'Cancelled'),
(1, '2026-04-02 09:20:00', 'Completed'),
(4, '2026-04-05 18:10:00', 'Pending');

-- 4. Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 750.00),    -- 2 Wireless Mice for Order 1
(1, 4, 3, 500.00),    -- 3 T-Shirts for Order 1
(2, 2, 1, 2200.00),   -- 1 Keyboard for Order 2
(3, 3, 1, 2500.00),   -- 1 Shoes for Order 3 (Cancelled order)
(4, 5, 1, 3000.00),   -- 1 Speaker for Order 4
(5, 4, 2, 500.00);    -- 2 T-Shirts for Order 5

-- 5. Insert Payments
INSERT INTO payments (order_id, payment_method, amount, payment_status) VALUES
(1, 'Credit Card', 3000.00, 'Success'),
(2, 'UPI', 2200.00, 'Success'),
(3, 'UPI', 2500.00, 'Refunded'),
(4, 'Credit Card', 3000.00, 'Success'),
(5, 'Debit Card', 1000.00, 'Pending');

-- 6. Insert Returns
INSERT INTO returns (order_id, product_id, return_date, reason) VALUES
(1, 4, '2026-03-14', 'Wrong size delivered');