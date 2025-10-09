-- Which 5 products generate the highest revenue?
SELECT TOP 5 p.product_name, SUM(s.sales_amount) as total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT * FROM (
	SELECT 
		p.product_name, 
		SUM(s.sales_amount) as total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
		ON s.product_key = p.product_key
	GROUP BY p.product_name) t
WHERE rank_products <= 5;


-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5 p.product_name, SUM(s.sales_amount) as total_revenue
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_products AS p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT * FROM (
	SELECT 
		c.customer_id,
		c.first_name,
		c.last_name, 
		SUM(s.sales_amount) as total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(s.sales_amount) DESC) AS rank_customers
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
		ON s.customer_key = c.customer_key
	GROUP BY 		c.customer_id,
					c.first_name,
					c.last_name) t
WHERE rank_customers <= 10;

-- Find the 3 customers with fewest orders placed
SELECT * FROM (
	SELECT 
		c.customer_id,
		c.first_name,
		c.last_name, 
		COUNT(DISTINCT s.order_number) as total_orders,
		ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT s.order_number)) AS customers_rank
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_customers AS c
		ON s.customer_key = c.customer_key
	GROUP BY 		c.customer_id,
					c.first_name,
					c.last_name) t
WHERE customers_rank <= 3;

SELECT TOP 3
		c.customer_key,
		c.first_name,
		c.last_name,
		COUNT(DISTINCT s.order_number) as total_orders
FROM gold.fact_sales AS s
LEFT JOIN gold.dim_customers AS c
	ON s.customer_key = c.customer_key	
GROUP BY 		c.customer_key,
				c.first_name,
				c.last_name
ORDER BY total_orders;
