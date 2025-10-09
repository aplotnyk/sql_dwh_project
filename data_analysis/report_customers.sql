/*
=====================================================================================
Customer Report
=====================================================================================
Purpose:
	- The report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transactional details
	2. Segments customers into categories (VIP, Regular, New) and age groups
	3. Aggregates customer-level metrics:
		- total orders;
		- total sales;
		- total quantity purchased;
		- total products;
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order);
		- average order value;
		- average monthly spend
=====================================================================================
*/
CREATE VIEW gold.report_customers AS
WITH base_query AS (
-- Base query: Retrieves core columns from sales and customers tables
	SELECT
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		DATEDIFF(year, c.birthdate, GETDATE()) AS age
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers AS c
			ON s.customer_key = c.customer_key
	WHERE order_date IS NOT NULL
),
cust_aggregation AS (
-- Customer Aggregations: Summarizes key metrics at the customer level
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order,
		DATEDIFF(month, MIN(order_date), MAX(order_date))AS cust_lifespan
	FROM base_query
	GROUP BY customer_key,
			 customer_number,
			 customer_name,
			 age
)
-- Combining all customer results into one output
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		 WHEN age BETWEEN 20 AND 29 THEN '20-29'
		 WHEN age BETWEEN 30 AND 39 THEN '30-39'
		 WHEN age BETWEEN 40 AND 49 THEN '40-49'
		 ELSE '50 and above'
	END AS age_group,
	CASE WHEN cust_lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		 WHEN cust_lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		 ELSE 'New'
	END AS cust_segment,
	last_order,
	DATEDIFF(month, last_order, GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	cust_lifespan,
	CASE WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders 
	END AS avg_order_value,
	CASE WHEN cust_lifespan = 0 THEN total_sales
		ELSE total_sales / cust_lifespan
	END AS avg_monthly_spend
FROM cust_aggregation
