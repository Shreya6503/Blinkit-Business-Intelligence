USE Blinkit_data_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    phone BIGINT,
    address VARCHAR(255),
    area VARCHAR(100),
    pincode INT,
    registration_date DATE,
    customer_segment VARCHAR(50),
    total_orders INT DEFAULT 0,
    avg_order_value DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id BIGINT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME,
    promised_delivery_time DATETIME,
    actual_delivery_time DATETIME,
    delivery_status VARCHAR(30),
    order_total DECIMAL(10,2),
    payment_method VARCHAR(30),
    delivery_partner_id INT,
    store_id INT,
    
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_id BIGINT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    brand VARCHAR(100),
    price DECIMAL(10,2),
    mrp DECIMAL(10,2),
    margin_percentage DECIMAL(5,2),
    shelf_life_days INT,
    min_stock_level INT,
    max_stock_level INT
);

ALTER TABLE order_items
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    inventory_date DATE,
    stock_received INT DEFAULT 0,
    damaged_stock INT DEFAULT 0,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

CREATE TABLE delivery_performance (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    delivery_partner_id INT,
    promised_time VARCHAR(30),
    actual_time VARCHAR(30),
    delivery_time_minutes INT,
    distance_km DECIMAL(5,2),
    delivery_status VARCHAR(30),
    reasons_if_delayed VARCHAR(100),

    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

CREATE TABLE customer_feedback (
    feedback_id INT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    customer_id INT NOT NULL,
    rating TINYINT,
    feedback_text TEXT,
    feedback_category VARCHAR(100),
    sentiment VARCHAR(20),
    feedback_date DATE,

    CONSTRAINT fk_feedback_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_feedback_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE marketing_performance (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    campaign_date DATE,
    target_audience VARCHAR(100),
    channel VARCHAR(50),
    impressions INT,
    clicks INT,
    conversions INT,
    spend DECIMAL(10,2),
    revenue_generated DECIMAL(10,2),
    roas DECIMAL(5,2)
);

