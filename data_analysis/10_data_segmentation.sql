-- Segment products into cost ranges and count
-- how many products fall into each segment
WITH product_segments AS (
	SELECT
		product_key,
		product_name,
		product_cost,
		CASE WHEN product_cost < 100 THEN 'Below 100'
			WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products)
SELECT 
	cost_range,
	COUNT(product_key) as total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Group customers into 3 segments based on their spending behavior:
	- VIP: cust. with at least 12m of history and spending > 5,000EUR
	- Regular: cust. with at least 12m of history but spending <= 5,000EUR
	- New: cust. with a lifespan < 12m
   And find the total number of customers by each group
*/
WITH cust_ord_ls as (
	SELECT  c.customer_key,
			SUM(s.sales_amount) AS total_orders_amount,
			MIN(s.order_date) AS cust_first_order,
			MAX(s.order_date) AS cust_last_order,
			DATEDIFF (month, MIN(s.order_date), MAX(s.order_date)) AS cust_lifespan
	FROM gold.dim_customers AS c
	LEFT JOIN gold.fact_sales AS s 
		ON s.customer_key = c.customer_key
	GROUP BY c.customer_key
),
cust_segments AS (
	SELECT 
		customer_key,
		CASE WHEN cust_lifespan >= 12 AND total_orders_amount > 5000 THEN 'VIP'
			 WHEN cust_lifespan >= 12 AND total_orders_amount <= 5000 THEN 'Regular'
			 ELSE 'New'
		END as cust_segment
	FROM cust_ord_ls 
) 
SELECT 
	cust_segment,
	COUNT(customer_key) as total_customers
FROM cust_segments
GROUP BY cust_segment;
