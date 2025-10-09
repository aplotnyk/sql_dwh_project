-- Part-to-whole(proportional) analysis
-- Which categories contribute the most to overall sales?
WITH sc AS (
	SELECT
		p.category,
		SUM(s.sales_amount) as sales_in_cat
	FROM gold.fact_sales AS s
	LEFT JOIN gold.dim_products AS p
			ON s.product_key = p.product_key
	GROUP BY p.category)
SELECT 
	category,
	sales_in_cat,
	SUM(sales_in_cat) OVER () AS total_sales,
	CONCAT(ROUND((CAST(sales_in_cat AS FLOAT) / SUM(sales_in_cat) OVER ()) * 100, 2), ' %') AS pct_from_total_sales
FROM sc
ORDER BY sales_in_cat DESC;
