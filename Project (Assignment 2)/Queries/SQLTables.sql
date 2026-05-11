Create Database Brazilian_DW

USE Brazilian_DW

USE master
Drop database Brazilian_DW



-- DIMENSIONS --

CREATE TABLE Dim_Customer (
    customer_sk              INT IDENTITY(1,1) PRIMARY KEY,  -- surrogate key
    customer_id              NVARCHAR(50)  NOT NULL,          -- natural key (not unique: multiple versions)
    customer_unique_id       NVARCHAR(50),
    customer_zip_code_prefix NVARCHAR(5),
    customer_city            NVARCHAR(100),
    customer_state           NCHAR(2),
    effective_start_date     DATETIME      NOT NULL,
    effective_end_date       DATETIME      NULL,              -- NULL = current/active record
    is_current               BIT           NOT NULL DEFAULT 1
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
    order_id                      NVARCHAR(50) PRIMARY KEY,
    customer_sk                   INT,                         -- references surrogate key in Dim_Customer
    order_status                  NVARCHAR(20),
    order_purchase_timestamp      DATETIME,
    order_approved_at             DATETIME,
    order_delivered_carrier_date  DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    CONSTRAINT fk_customer FOREIGN KEY (customer_sk) REFERENCES Dim_Customer(customer_sk)
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


-- ============================================================
-- ETL CONTROL (WATERMARK) TABLE
-- Stores the last successful load timestamp per target table.
-- Used by Load_DW package for incremental extraction.
-- Seeded with epoch date so first run loads everything.
-- ============================================================

CREATE TABLE ETL_Control (
    table_name          NVARCHAR(100) PRIMARY KEY,
    last_load_timestamp DATETIME      NOT NULL DEFAULT '1900-01-01'
);

INSERT INTO ETL_Control (table_name, last_load_timestamp) VALUES
('Dim_Orders',       '1900-01-01'),
('Fact_Order_Items', '1900-01-01'),
('Fact_Payments',    '1900-01-01'),
('Fact_Reviews',     '1900-01-01');

-- 2 product categories present in olist_products_dataset.csv but missing from
-- product_category_name_translation.csv -- must exist in Dim_Category_Translation
-- before Dim_Product can be loaded (FK constraint fk_translator_languagage).
INSERT INTO Dim_Category_Translation (product_category_name, product_category_name_english) VALUES
('pc_gamer',                                       'pc_gamer'),
('portateis_cozinha_e_preparadores_de_alimentos',  'portable_kitchen_and_food_preparers');