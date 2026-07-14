use blinkit_data_analysis;
-- ============================================
-- 1. Row Count Validation
-- ============================================
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL
SELECT 'delivery_performance', COUNT(*) FROM delivery_performance
UNION ALL
SELECT 'customer_feedback', COUNT(*) FROM customer_feedback
UNION ALL
SELECT 'marketing_performance', COUNT(*) FROM marketing_performance;

-- ============================================
-- 2. Duplicate Checks
-- ============================================
-- Customers
SELECT customer_id, COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
-- Products
SELECT product_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
-- Orders
SELECT order_id, COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- Customer Feedback
SELECT feedback_id, COUNT(*) AS duplicate_count
FROM customer_feedback
GROUP BY feedback_id
HAVING COUNT(*) > 1;
-- Marketing Performance
SELECT campaign_id, COUNT(*) AS duplicate_count
FROM marketing_performance
GROUP BY campaign_id
HAVING COUNT(*) > 1;


-- ============================================
-- 2. Missing Value Checks
-- ============================================
-- Customers
SELECT
    SUM(customer_name IS NULL) AS missing_customer_name,
    SUM(email IS NULL) AS missing_email,
    SUM(phone IS NULL) AS missing_phone,
    SUM(area IS NULL) AS missing_area
FROM customers;

-- Products
SELECT
    SUM(product_name IS NULL) AS missing_product_name,
    SUM(category IS NULL) AS missing_category,
    SUM(price IS NULL) AS missing_price,
    SUM(brand IS NULL) AS missing_brand
FROM products;

-- Orders
SELECT
    SUM(customer_id IS NULL) AS missing_customer,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(order_total IS NULL) AS missing_order_total
FROM orders;

-- Customer Feedback
SELECT
    SUM(rating IS NULL) AS missing_rating,
    SUM(sentiment IS NULL) AS missing_sentiment
FROM customer_feedback;


-- ============================================
-- 4. Foreign Key Validation
-- ============================================

-- Orders → Customers
SELECT COUNT(*) AS invalid_customer_records
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Order Items → Orders
SELECT COUNT(*) AS invalid_orders
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Order Items → Products
SELECT COUNT(*) AS invalid_products
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Inventory → Products
SELECT COUNT(*) AS invalid_inventory_products
FROM inventory i
LEFT JOIN products p
ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Delivery Performance → Orders
SELECT COUNT(*) AS invalid_delivery_orders
FROM delivery_performance d
LEFT JOIN orders o
ON d.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Customer Feedback → Orders
SELECT COUNT(*) AS invalid_feedback_orders
FROM customer_feedback cf
LEFT JOIN orders o
ON cf.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ============================================
-- 5. Business Rule Validation
-- ============================================

-- Ratings between 1 and 5
SELECT rating 
FROM customer_feedback
WHERE rating NOT BETWEEN 1 AND 5;

-- Product Price
SELECT *
FROM products
WHERE price <= 0;

-- MRP should be greater than or equal to Price
SELECT *
FROM products
WHERE mrp < price;

-- Order Total
SELECT *
FROM orders
WHERE order_total <= 0;

-- Quantity
SELECT *
FROM order_items
WHERE quantity <= 0;

-- Damaged Stock
SELECT *
FROM inventory
WHERE damaged_stock > stock_received;