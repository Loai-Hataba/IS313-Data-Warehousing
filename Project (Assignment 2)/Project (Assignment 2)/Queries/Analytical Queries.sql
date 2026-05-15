USE Brazilian_DW


--Revenue by Product Category per Month

SELECT 
    YEAR(o.order_purchase_timestamp)        AS order_year,
    MONTH(o.order_purchase_timestamp)       AS order_month,
    ct.product_category_name_english        AS category,
    COUNT(DISTINCT fi.order_id)             AS total_orders,
    SUM(fi.price)                           AS total_revenue,
    SUM(fi.freight_value)                   AS total_freight,
    SUM(fi.price + fi.freight_value)        AS total_with_freight
FROM Fact_Order_Items fi
JOIN Dim_Orders o        ON fi.order_id   = o.order_id
JOIN Dim_Product p       ON fi.product_id = p.product_id
JOIN Dim_Category_Translation ct ON p.product_category_name = ct.product_category_name
GROUP BY 
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    ct.product_category_name_english
ORDER BY order_year, order_month, total_revenue DESC;





--Payment Method Analysis

SELECT 
    payment_type,
    COUNT(*)                                AS total_transactions,
    COUNT(DISTINCT order_id)                AS total_orders,
    SUM(payment_value)                      AS total_revenue,
    AVG(payment_value)                      AS avg_payment_value,
    AVG(CAST(payment_installments AS FLOAT)) AS avg_installments,
    MAX(payment_installments)               AS max_installments
FROM Fact_Payments
GROUP BY payment_type
ORDER BY total_revenue DESC;




--Review Score by Seller

SELECT 
    s.seller_id,
    s.seller_city,
    COUNT(r.fact_review_sk)                  AS total_reviews,
    AVG(CAST(r.review_score AS FLOAT))       AS avg_review_score,
    SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END) AS five_star_reviews,
    SUM(CASE WHEN r.review_score <= 2 THEN 1 ELSE 0 END) AS bad_reviews
FROM Fact_Reviews r
JOIN Dim_Orders o    ON r.order_id  = o.order_id
JOIN Fact_Order_Items fi ON o.order_id = fi.order_id
JOIN Dim_Sellers s   ON fi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city
HAVING COUNT(r.fact_review_sk) >= 10
ORDER BY avg_review_score DESC;