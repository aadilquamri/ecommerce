select * from customers;

CREATE TABLE fact_orders AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    oi.product_id,
    p.product_category_name,
    oi.price,
    oi.freight_value,
    pay.payment_type,
    pay.payment_installments,
    pay.payment_value,
    oi.seller_id,
    s.seller_city,
    s.seller_state
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN payments pay ON o.order_id = pay.order_id
LEFT JOIN sellers s ON oi.seller_id = s.seller_id;


ALTER TABLE fact_orders
ADD COLUMN delivery_delay_days INT,
ADD COLUMN purchase_day_of_week INT,
ADD COLUMN purchase_hour INT;


UPDATE fact_orders
SET delivery_delay_days = 
    EXTRACT(DAY FROM (CAST(order_delivered_customer_date AS TIMESTAMP) - 
	CAST(order_estimated_delivery_date AS TIMESTAMP))),
    purchase_day_of_week = EXTRACT(DOW FROM CAST(order_purchase_timestamp AS TIMESTAMP)),
    purchase_hour = EXTRACT(HOUR FROM CAST(order_purchase_timestamp AS TIMESTAMP));


SELECT COUNT(*) FROM fact_orders;

CREATE TABLE stg_orders_cleaned AS
SELECT
    order_id,
    customer_id,
    order_status,
    CAST(order_purchase_timestamp AS TIMESTAMP) AS order_purchase_timestamp,
    CAST(order_approved_at AS TIMESTAMP) AS order_approved_at,
    CAST(order_delivered_carrier_date AS TIMESTAMP) AS order_delivered_carrier_date,
    CAST(order_delivered_customer_date AS TIMESTAMP) AS order_delivered_customer_date,
    CAST(order_estimated_delivery_date AS TIMESTAMP) AS order_estimated_delivery_date
FROM orders
WHERE order_id IS NOT NULL;

CREATE TABLE stg_customers_cleaned AS
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    INITCAP(customer_city) AS customer_city,
    UPPER(customer_state) AS customer_state
FROM customers
WHERE customer_id IS NOT NULL;

CREATE TABLE stg_products_cleaned AS
SELECT
    product_id,
    product_category_name,
    COALESCE(product_name_length, 0) AS product_name_length,
    COALESCE(product_description_length, 0) AS product_description_length,
    COALESCE(product_photos_qty, 0) AS product_photos_qty,
    COALESCE(product_weight_g, 0) AS product_weight_g,
    COALESCE(product_length_cm, 0) AS product_length_cm,
    COALESCE(product_height_cm, 0) AS product_height_cm,
    COALESCE(product_width_cm, 0) AS product_width_cm
FROM products
WHERE product_id IS NOT NULL;

CREATE TABLE stg_order_items_cleaned AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_date,
    price,
    freight_value
FROM order_items
WHERE price > 0;


CREATE TABLE stg_payments_cleaned AS
SELECT
    order_id,
    payment_type,
    COALESCE(payment_installments, 0) AS payment_installments,
    payment_value
FROM payments
WHERE payment_value > 0;

CREATE TABLE stg_reviews_cleaned AS
SELECT
    review_id,
    order_id,
    review_score,
    COALESCE(review_comment_message, '') AS review_comment_message,
    CAST(review_creation_date AS TIMESTAMP) AS review_creation_date
FROM reviews;


CREATE TABLE stg_sellers_cleaned AS
SELECT DISTINCT
    seller_id,
    INITCAP(seller_city) AS seller_city,
    UPPER(seller_state) AS seller_state
FROM sellers;

CREATE TABLE stg_geolocation_cleaned AS
SELECT DISTINCT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM geolocation;

CREATE TABLE fact_orders_cleaned AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    oi.product_id,
    p.product_category_name,
    oi.price,
    oi.freight_value,
    pay.payment_type,
    pay.payment_installments,
    pay.payment_value,
    oi.seller_id,
    s.seller_city,
    s.seller_state
FROM stg_orders_cleaned o
LEFT JOIN stg_customers_cleaned c ON o.customer_id = c.customer_id
LEFT JOIN stg_order_items_cleaned oi ON o.order_id = oi.order_id
LEFT JOIN stg_products_cleaned p ON oi.product_id = p.product_id
LEFT JOIN stg_payments_cleaned pay ON o.order_id = pay.order_id
LEFT JOIN stg_sellers_cleaned s ON oi.seller_id = s.seller_id;

select * from fact_orders_cleaned limit 5;

ALTER TABLE fact_orders_cleaned
ADD COLUMN delivery_delay_days INT,
ADD COLUMN is_late INT,
ADD COLUMN purchase_day_of_week INT,
ADD COLUMN purchase_hour INT;

UPDATE fact_orders_cleaned
SET 
    delivery_delay_days = 
        CASE 
            WHEN order_delivered_customer_date IS NULL THEN NULL
            ELSE EXTRACT(DAY FROM (order_delivered_customer_date - order_estimated_delivery_date))
        END,
    is_late =
        CASE 
            WHEN order_delivered_customer_date IS NULL THEN NULL
            WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
            ELSE 0
        END,
    purchase_day_of_week = EXTRACT(DOW FROM order_purchase_timestamp),
    purchase_hour = EXTRACT(HOUR FROM order_purchase_timestamp);


SELECT COUNT(*) FROM fact_orders_cleaned;

SELECT 
    COUNT(*) FILTER (WHERE is_late IS NULL) AS missing_target,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product
FROM fact_orders_cleaned;

select * from fact_orders_cleaned limit 5;
