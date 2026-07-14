use blinkit_data_analysis;
show tables;
SELECT COUNT(*) AS total_customers
FROM customers;
describe table customers;
SELECT *
FROM customers;
SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS products FROM products;
SELECT COUNT(*) AS orders FROM orders;
SELECT COUNT(*) AS order_items FROM order_items;
SELECT COUNT(*) AS inventory FROM inventory;
SELECT COUNT(*) AS delivery_performance FROM delivery_performance;
SELECT COUNT(*) AS customer_feedback FROM customer_feedback;
SELECT COUNT(*) AS marketing_performance FROM marketing_performance;
