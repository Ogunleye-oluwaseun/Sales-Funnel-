-- Create Database
CREATE DATABASE end_to_end

USE end_to_end;

-- Insert Data into the table
CREATE TABLE user_events(
	event_id INT,
	user_id INT,
	event_type VARCHAR(50),
	event_date DATE,
	product_id INT,
	amount DECIMAL,
	traffic_source VARCHAR(50)
);

BULK INSERT dbo.user_events
FROM "C:\Users\DELL\Downloads\user_events.csv"
WITH (
FIRSTROW = 2,
FIELDTERMINATOR = ',',
TABLOCK 
);

SELECT * 
FROM user_events;

-- Define sales funnel and different stages of the funnel
WITH funnel_stages as (
SELECT
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
	COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
	COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
	COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
FROM user_events
)
SELECT * FROM funnel_stages;

-- Conversion rates through the funnel
WITH funnel_stages as (
SELECT
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
	COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
	COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
	COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
FROM user_events
)
SELECT
stage_1_views, stage_2_cart,
ROUND(stage_2_cart * 100 / stage_1_views,2) AS view_to_cart_rate,

stage_3_checkout,
ROUND(stage_3_checkout * 100 / stage_2_cart,2) AS cart_to_checkout_rate,

stage_4_payment,
ROUND(stage_4_payment * 100/ stage_3_checkout,2) AS checkout_to_payment_rate,

stage_5_purchase,
ROUND(stage_5_purchase * 100 / stage_4_payment,2) AS payment_to_purchase_rate,

ROUND(stage_5_purchase * 100 / stage_1_views, 2) AS overall_conversion_rate
FROM funnel_stages;


-- Funnel By Source
with source_funnel as (
SELECT 
	traffic_source,
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
	COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS carts,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchases
FROM user_events
GROUP BY traffic_source
)
SELECT
traffic_source, views, carts, purchases,
ROUND(carts * 100/ views, 2) AS cart_conversion_rate,
ROUND(purchases * 100 / carts,2) AS purchase_conversion_rate
FROM source_funnel
ORDER BY purchases DESC;

-- Time to conversion Analysis
with user_journey AS(
SELECT user_id,
MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
FROM user_events
GROUP BY user_id
HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END ) IS NOT NULL
)
SELECT 
	COUNT(*) AS converted_users,
	AVG(DATEDIFF(MINUTE, view_time,cart_time )) as avg_view_to_cart_minutes,
	AVG(DATEDIFF(MINUTE, cart_time,purchase_time )) as avg_cart_to_purchase_minutes,
	AVG(DATEDIFF(MINUTE,view_time, purchase_time )) as avg_total_journey_minutes
FROM user_journey;


-- Revenue Funnel Analysis
with funnel_revenue as (
	SELECT
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
	COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
	SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,
	COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders
FROM user_events
)
SELECT 
total_visitors,
total_buyers,
total_revenue,
total_revenue / total_orders AS avg_order_value,
total_revenue / total_buyers AS revenue_per_buyer,
total_revenue / total_visitors AS revenue_per_visitor
FROM funnel_revenue;