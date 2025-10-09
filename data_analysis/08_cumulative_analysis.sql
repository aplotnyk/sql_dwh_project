-- Calculate the total sales per month + 
-- the running total of sales for each year
WITH ms as (
	SELECT
		DATETRUNC(month, order_date) as order_date,
		SUM(sales_amount) as total_sales_month
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(month, order_date)
)
SELECT 
	order_date as order_month,
	total_sales_month,
	SUM(total_sales_month) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date)
FROM ms;
