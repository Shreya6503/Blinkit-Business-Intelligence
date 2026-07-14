USE Blinkit_data_analysis;

-- =====================================================
-- SECTION 1: SALES PERFORMANCE ANALYSIS
-- =====================================================

-- Total Revenue
SELECT 
    SUM(order_total) AS total_revenue
FROM
    orders;
-- Total Orders
SELECT 
    COUNT(*) AS total_orders
FROM
    orders;

-- Average Order Value (AOV)
-- The average amount of money a customer spend per order
SELECT
    ROUND(AVG(order_total),2) AS average_order_value
FROM orders;

-- Highest Order Value
SELECT
    MAX(order_total) AS highest_order
FROM orders;

-- Lowest Order Value
SELECT
    MIN(order_total) AS lowest_order
FROM orders;

-- Monthly Revenue
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    ROUND(SUM(order_total), 2) AS revenue
FROM
    orders
GROUP BY YEAR(order_date) , MONTH(order_date)
ORDER BY year;

-- Orders by Payment Method
SELECT
    payment_method,
    COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method
ORDER BY total_orders DESC;

-- Revenue by Payment Method
SELECT
    payment_method,
    ROUND(SUM(order_total),2) AS revenue
FROM orders
GROUP BY payment_method
ORDER BY revenue DESC;

-- Daily Orders
SELECT
    DATE(order_date) AS order_day,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE(order_date)
ORDER BY order_day;

-- Daily Revenue
SELECT
    DATE(order_date) AS order_day,
    ROUND(SUM(order_total),2) AS revenue
FROM orders
GROUP BY DATE(order_date)
ORDER BY order_day;

-- =====================================================
-- SECTION 2: CUSTOMER ANALYSIS
-- =====================================================

-- Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Customer Segmentation
SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment
ORDER BY total_customers DESC;

-- Top 10 Customers by Spending
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(o.order_total),2) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10;

--  Average Spending per Customer
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(AVG(o.order_total),2) AS average_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY average_spending DESC;

-- Customers with More Than One Order
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Average Orders per Customer
SELECT
    ROUND(COUNT(order_id) / COUNT(DISTINCT customer_id),2) AS avg_orders_per_customer
FROM orders;

-- Customers by Area
SELECT
    area,
    COUNT(*) AS total_customers
FROM customers
GROUP BY area
ORDER BY total_customers DESC;

-- Top 10 Areas by Revenue
SELECT
    c.area,
    ROUND(SUM(o.order_total),2) AS total_revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.area
ORDER BY total_revenue DESC
LIMIT 10;

-- Average Order Value by Customer Segment
SELECT
    c.customer_segment,
    ROUND(AVG(o.order_total),2) AS avg_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_segment
ORDER BY avg_order_value DESC;

-- Top 10 Customers by Number of Orders
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC
LIMIT 10;


-- =====================================================
-- SECTION 3: PRODUCT ANALYSIS
-- =====================================================

-- Total Number of Products
SELECT COUNT(*) AS total_products
FROM products;

-- Products by Category
SELECT
    category,
    COUNT(*) AS total_products
FROM products
GROUP BY category
ORDER BY total_products DESC;

-- Products by Brand
SELECT
    brand,
    COUNT(*) AS total_products
FROM products
GROUP BY brand
ORDER BY total_products DESC;

-- Top 10 Best-Selling Products
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Top 10 Highest Revenue Products
SELECT
    p.product_id,
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price),2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Revenue by Category
SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price),2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Revenue by Brand
SELECT
    p.brand,
    ROUND(SUM(oi.quantity * oi.unit_price),2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.brand
ORDER BY total_revenue DESC;

-- Average Product Price by Category
SELECT
    category,
    ROUND(AVG(price),2) AS average_price
FROM products
GROUP BY category
ORDER BY average_price DESC;

-- Products with Highest Margin
SELECT
    product_id,
    product_name,
    margin_percentage
FROM products
ORDER BY margin_percentage DESC
LIMIT 10;

-- Products Below Minimum Stock Level
SELECT
    p.product_id,
    p.product_name,
    i.stock_received,
    p.min_stock_level
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
WHERE i.stock_received < p.min_stock_level
ORDER BY i.stock_received ASC;

-- =====================================================
-- SECTION 3: PRODUCT ANALYSIS
-- =====================================================
-- Total Deliveries
SELECT COUNT(*) AS total_deliveries
FROM delivery_performance;

-- Delivery Status Distribution
SELECT
    delivery_status,
    COUNT(*) AS total_deliveries
FROM delivery_performance
GROUP BY delivery_status
ORDER BY total_deliveries DESC;

-- Average Delivery Time
SELECT
    ROUND(AVG(delivery_time_minutes),2) AS average_delivery_time
FROM delivery_performance;

-- Fastest Delivery  
SELECT
    MIN(delivery_time_minutes) AS fastest_delivery
FROM delivery_performance
WHERE delivery_time_minutes > 0;

-- Slowest Delivery
SELECT
    MAX(delivery_time_minutes) AS slowest_delivery
FROM delivery_performance;

-- Average Delivery Time by Partner
SELECT
    delivery_partner_id,
    ROUND(AVG(delivery_time_minutes),2) AS avg_delivery_time
FROM delivery_performance
WHERE delivery_time_minutes > 0
GROUP BY delivery_partner_id
ORDER BY avg_delivery_time;

-- Average Delivery Distance
SELECT
    ROUND(AVG(distance_km),2) AS average_distance
FROM delivery_performance;

-- Delay Reasons
SELECT
    reasons_if_delayed,
    COUNT(*) AS total_occurrences
FROM delivery_performance
WHERE reasons_if_delayed IS NOT NULL
GROUP BY reasons_if_delayed
ORDER BY total_occurrences DESC;

-- Average Delivery Time by Status
SELECT
    delivery_status,
    ROUND(AVG(delivery_time_minutes),2) AS avg_delivery_time
FROM delivery_performance
GROUP BY delivery_status;

-- Long Distance Deliveries
SELECT
    delivery_id,
    distance_km
FROM delivery_performance
WHERE distance_km >
(
    SELECT AVG(distance_km)
    FROM delivery_performance
);

-- =====================================================
-- SECTION 5: MARKETING & INVENTORY ANALYSIS
-- =====================================================
-- Marketing Analysis
-- Total Marketing Spend
SELECT
    ROUND(SUM(spend),2) AS total_marketing_spend
FROM marketing_performance;

-- Total Revenue Generated
SELECT
    ROUND(SUM(revenue_generated),2) AS total_revenue_generated
FROM marketing_performance;

-- Best Marketing Channel
SELECT
    channel,
    ROUND(SUM(revenue_generated),2) AS total_revenue
FROM marketing_performance
GROUP BY channel
ORDER BY total_revenue DESC;

-- Highest ROAS Campaign
-- ROAS = Return On Ad Spend
SELECT
    campaign_name,
    roas
FROM marketing_performance
ORDER BY roas DESC
LIMIT 10;

-- Conversion Rate by Channel
SELECT
    channel,
    ROUND(
        SUM(conversions) * 100.0 /
        SUM(clicks),2
    ) AS conversion_rate
FROM marketing_performance
GROUP BY channel
ORDER BY conversion_rate DESC;

-- Inventory Analysis
-- Total Stock Received
SELECT
    SUM(stock_received) AS total_stock
FROM inventory;

-- Total Damaged Stock
SELECT
    SUM(damaged_stock) AS total_damaged_stock
FROM inventory;

-- Top 10 Products with Highest Damaged Stock
SELECT
    p.product_name,
    SUM(i.damaged_stock) AS total_damaged
FROM inventory i
JOIN products p
ON i.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_damaged DESC
LIMIT 10;

-- Products Below Minimum Stock Level
WITH latest_inventory AS
(
    SELECT
        product_id,
        MAX(inventory_date) AS latest_date
    FROM inventory
    GROUP BY product_id
)

SELECT
    p.product_name,
    i.stock_received,
    p.min_stock_level
FROM inventory i

JOIN latest_inventory l
ON i.product_id = l.product_id
AND i.inventory_date = l.latest_date

JOIN products p
ON i.product_id = p.product_id

WHERE i.stock_received < p.min_stock_level;