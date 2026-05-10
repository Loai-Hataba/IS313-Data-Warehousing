Create Database Brazilian_DW

USE Brazilian_DW

USE master
Drop database Brazilian_DW

-- DIMENSIONS --

CREATE TABLE Dim_Customer (
    customer_id NVARCHAR(50) PRIMARY KEY,
    customer_unique_id NVARCHAR(50),
    customer_zip_code_prefix NVARCHAR(5),
    customer_city NVARCHAR(100),
    customer_state NCHAR(2)
);

-- NOTE: zip_code_prefix has duplicates in the source CSV so it cannot be a simple PK.
-- A surrogate key is used as PK. In SSIS, deduplicate by zip_code_prefix (GROUP BY, take MIN lat/lng)
-- before loading so each zip appears only once, then you may also keep the surrogate approach.
CREATE TABLE Dim_Geolocation (
    geo_sk INT IDENTITY(1,1) PRIMARY KEY,
    zip_code_prefix NVARCHAR(5),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    city NVARCHAR(100),
    state NVARCHAR(2)
);

CREATE TABLE Dim_Orders (
    order_id NVARCHAR(50) PRIMARY KEY,
    customer_id NVARCHAR(50),
    order_status NVARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id)
);

CREATE TABLE Dim_Category_Translation (
    product_category_name NVARCHAR(100) PRIMARY KEY,
    product_category_name_english NVARCHAR(100)
);
CREATE TABLE Dim_Product (
    product_id NVARCHAR(50) PRIMARY KEY,
    product_category_name NVARCHAR(100), -- Removed the extra comma here
	CONSTRAINT fk_translator_languagage FOREIGN KEY (product_category_name) REFERENCES  Dim_Category_Translation(product_category_name)

);

-- seller_state is intentionally omitted: accessible via JOIN to Dim_Geolocation through seller_zip_code_prefix.
CREATE TABLE Dim_Sellers (
    seller_id NVARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix NVARCHAR(5),
    seller_city NVARCHAR(100)
    -- FK to Dim_Geolocation removed because geo_sk is a surrogate; join on zip_code_prefix at query time.
);


-- FACT TABLES --

CREATE TABLE Fact_Order_Items (
    fact_item_sk INT IDENTITY(1,1) PRIMARY KEY,
    order_id NVARCHAR(50),
    order_item_id INT, 
    product_id NVARCHAR(50),
    seller_id NVARCHAR(50),
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
    order_id NVARCHAR(50),
    payment_sequential INT,
    payment_type NVARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10, 2),
    payment_date DATETIME,
    CONSTRAINT fk_order_pay FOREIGN KEY (order_id) REFERENCES Dim_Orders(order_id)
);

CREATE TABLE Fact_Reviews (
    fact_review_sk INT IDENTITY(1,1) PRIMARY KEY,
    order_id NVARCHAR(50),
    review_score INT,
    review_creation_date DATETIME,
    CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) REFERENCES Dim_Orders(order_id)
);


use Brazilian_DW

SELECT 'Dim_Customer' AS tbl, COUNT(*) AS cnt FROM Dim_Customer UNION ALL
SELECT 'Dim_Geolocation', COUNT(*) FROM Dim_Geolocation UNION ALL
SELECT 'Dim_Orders', COUNT(*) FROM Dim_Orders UNION ALL
SELECT 'Fact_Order_Items', COUNT(*) FROM Fact_Order_Items UNION ALL
SELECT 'Fact_Payments', COUNT(*) FROM Fact_Payments UNION ALL
SELECT 'Fact_Reviews', COUNT(*) FROM Fact_Reviews;


SELECT 'Dim_Product' AS tbl, COUNT(*) AS cnt FROM Dim_Product UNION ALL
SELECT 'Dim_Sellers', COUNT(*) FROM Dim_Sellers UNION ALL
SELECT 'Dim_Category_Translation', COUNT(*) FROM Dim_Category_Translation;