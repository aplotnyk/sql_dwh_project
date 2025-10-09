-- Analyze the yearly performance of products by comparing 
-- each product's sales to both its average sales performance
-- and the previous year's sales
WITH yps as (
	SELECT
		p.product_name,
		YEAR(s.order_date) as order_year,
		SUM(s.sales_amount) as current_sales
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
		ON s.product_key = p.product_key
	WHERE s.order_date IS NOT NULL
	GROUP BY YEAR(s.order_date), p.product_name
)
SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END AS avg_change,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS prev_year_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
	CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END AS py_change
FROM yps
ORDER BY product_name, order_year;
