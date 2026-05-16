-- ============================================================
-- STAGING (STG) DATABASE -- CREATE TABLE SCRIPTS
-- Run these in a separate STG database (or a stg schema).
-- All columns are NVARCHAR to absorb raw CSV data without
-- type errors. No FK constraints, no NOT NULL.
-- ============================================================
DROP DATABASE STG_Brazilian_DW
USE MASTER
Create database STG_Brazilian_DW

use STG_Brazilian_DW


-- 1. olist_customers_dataset.csv
--drop table STG_Customers
--select * from STG_Customers
--SELECT customer_id, COUNT(*) AS duplicate_count
--FROM STG_Customers1
--GROUP BY customer_id
--HAVING COUNT(*) > 1;

-- In STG_Brazilian_DW
SELECT customer_unique_id, COUNT(*) as cnt
FROM stg_customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

SELECT customer_id, COUNT(*) AS duplicate_count
FROM STG_Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

update stg_customers set customer_city = 'giza' where customer_id = 'fadbb3709178fc513abc1b2670aa1ad2'

select * from stg_customers

CREATE TABLE STG_Customers (
    customer_id NVARCHAR(50) PRIMARY KEY,
    customer_unique_id NVARCHAR(50),
    customer_zip_code_prefix NVARCHAR(5),
    customer_city NVARCHAR(100),
    customer_state NVARCHAR(2)
);

-- 2. olist_geolocation_dataset.csv
CREATE TABLE STG_Geolocation (
    geolocation_zip_code_prefix NVARCHAR(5),
    geolocation_lat NVARCHAR(30),
    geolocation_lng NVARCHAR(30),
    geolocation_city NVARCHAR(100),
    geolocation_state NVARCHAR(2)
);

-- 3. olist_order_items_dataset.csv
CREATE TABLE STG_OrderItems (
    order_id NVARCHAR(50),
    order_item_id NVARCHAR(10),
    product_id NVARCHAR(50),
    seller_id NVARCHAR(50),
    shipping_limit_date NVARCHAR(30),
    price NVARCHAR(20),
    freight_value NVARCHAR(20)
);

-- 4. olist_order_payments_dataset.csv
CREATE TABLE STG_OrderPayments (
    order_id NVARCHAR(50),
    payment_sequential NVARCHAR(10),
    payment_type NVARCHAR(30),
    payment_installments NVARCHAR(10),
    payment_value NVARCHAR(20)
);

-- 5. olist_order_reviews_dataset.csv
CREATE TABLE STG_OrderReviews (
    review_id NVARCHAR(50),
    order_id NVARCHAR(50),
    review_score NVARCHAR(5),
    review_comment_title NVARCHAR(255),
    review_comment_message NVARCHAR(MAX),
    review_creation_date NVARCHAR(30),
    review_answer_timestamp NVARCHAR(30)
);

-- 6. olist_orders_dataset.csv
CREATE TABLE STG_Orders (
    order_id NVARCHAR(50),
    customer_id NVARCHAR(50),
    order_status NVARCHAR(20),
    order_purchase_timestamp NVARCHAR(30),
    order_approved_at NVARCHAR(30),
    order_delivered_carrier_date NVARCHAR(30),
    order_delivered_customer_date NVARCHAR(30),
    order_estimated_delivery_date NVARCHAR(30)
);
SELECT order_id, COUNT(*) AS duplicate_count
FROM STG_Orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- 7. olist_products_dataset.csv
-- Physical attributes (weight, size, photos) are intentionally omitted from Dim_Product.
-- They are loaded here in full so they are available if needed later.
CREATE TABLE STG_Products (
    product_id NVARCHAR(50),
    product_category_name NVARCHAR(100),
    product_name_lenght NVARCHAR(10),
    product_description_lenght NVARCHAR(10),
    product_photos_qty NVARCHAR(10),
    product_weight_g NVARCHAR(15),
    product_length_cm NVARCHAR(10),
    product_height_cm NVARCHAR(10),
    product_width_cm NVARCHAR(10)
);

-- 8. olist_sellers_dataset.csv
-- seller_state is loaded here even though it is omitted from Dim_Sellers
-- (state is accessible via Dim_Geolocation JOIN on seller_zip_code_prefix).
CREATE TABLE STG_Sellers (
    seller_id NVARCHAR(50),
    seller_zip_code_prefix NVARCHAR(5),
    seller_city NVARCHAR(100),
    seller_state NVARCHAR(2)
);

-- 9. product_category_name_translation.csv
CREATE TABLE STG_CategoryTranslation (
    product_category_name NVARCHAR(100),
    product_category_name_english NVARCHAR(100)
);


