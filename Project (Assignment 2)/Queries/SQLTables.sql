Create Database Brazilian_DW

USE Brazilian_DW



-- DIMENSIONS --



CREATE TABLE Dim_Customer (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- NOTE: zip_code_prefix has duplicates in the source CSV so it cannot be a simple PK.
-- A surrogate key is used as PK. In SSIS, deduplicate by zip_code_prefix (GROUP BY, take MIN lat/lng)
-- before loading so each zip appears only once, then you may also keep the surrogate approach.
CREATE TABLE Dim_Geolocation (
    geo_sk INT IDENTITY(1,1) PRIMARY KEY,
    zip_code_prefix VARCHAR(5),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    city VARCHAR(100),
    state VARCHAR(2)
);

CREATE TABLE Dim_Orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id)
);

CREATE TABLE Dim_Category_Translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);
CREATE TABLE Dim_Product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100), -- Removed the extra comma here
	CONSTRAINT fk_translator_languagage FOREIGN KEY (product_category_name) REFERENCES  Dim_Category_Translation(product_category_name)

);

-- seller_state is intentionally omitted: accessible via JOIN to Dim_Geolocation through seller_zip_code_prefix.
CREATE TABLE Dim_Sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(100)
    -- FK to Dim_Geolocation removed because geo_sk is a surrogate; join on zip_code_prefix at query time.
);


-- FACT TABLES --

CREATE TABLE Fact_Order_Items (
    fact_item_sk INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(50),
    order_item_id INT, 
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES Dim_Orders(order_id),
    CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id),
    CONSTRAINT fk_order_items_seller FOREIGN KEY (seller_id) REFERENCES Dim_Sellers(seller_id)
);

-- payment_date does not exist in the source CSV.
-- It is derived in SSIS via a Lookup on Dim_Orders (order_id -> order_purchase_timestamp).
CREATE TABLE Fact_Payments (
    fact_payment_sk INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10, 2),
    payment_date DATETIME,
    CONSTRAINT fk_order_pay FOREIGN KEY (order_id) REFERENCES Dim_Orders(order_id)
);

CREATE TABLE Fact_Reviews (
    fact_review_sk INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_creation_date DATETIME,
    CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) REFERENCES Dim_Orders(order_id)
);
