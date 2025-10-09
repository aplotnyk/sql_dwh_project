/*
=====================================================================================
Product Report
=====================================================================================
Purpose:
	- The report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost
	2. Segments products by revenue to identify High-Performers, Mid-Range or Low-Performers
	3. Aggregates product-level metrics:
		- total orders;
		- total sales;
		- total quantity sold;
		- total customers (unique);
		- lifespan (in months);
	4. Calculates valuable KPIs:
		- recency (months since last sale);
		- average order revenue;
		- average monthly revenue;
=====================================================================================
*/
CREATE VIEW gold.report_products AS
WITH base_query AS (
-- Base query: Retrieves core columns from sales and products tables
	SELECT
		s.order_number,
		s.order_date,
		s.customer_key,
		s.sales_amount,
		s.quantity,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.product_cost
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products AS p
		ON s.product_key = p.product_key
	WHERE order_date IS NOT NULL
),
-- Product Aggregations: Summarizes key metrics at the product level
product_aggregations AS (
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		product_cost,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
		MAX(order_date) AS last_sale_date,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_qty_sold,
		ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)), 1) AS avg_selling_price
	FROM base_query
	GROUP BY product_key,
			 product_name,
			 category,
			 subcategory,
			 product_cost
)
-- Combining all product results into one output
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	product_cost,
	lifespan,
	last_sale_date,
	DATEDIFF(month, last_sale_date, GETDATE()) AS recency_months,
	CASE
		WHEN total_sales > 5000 THEN 'High-Performer'
		WHEN total_sales >= 1000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	total_orders,
	total_customers,
	total_sales,
	total_qty_sold,
	avg_selling_price,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS average_order_revenue,
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS average_monthly_revenue
FROM product_aggregations
