-- Find the date of the first and last order
SELECT 
	MIN(order_date) as first_order_date,  
	MAX(order_date) as last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) as order_range_years
FROM gold.fact_sales;

-- Find the youngest and the oldest customer
SELECT 
	MIN(birthdate) as youngest_cust,
	DATEDIFF(year, MAX(birthdate), GETDATE()) as youngest_age,
	MAX(birthdate) as oldest_cust,
	DATEDIFF(year, MIN(birthdate), GETDATE()) as oldest_age,
	DATEDIFF(year, MIN(birthdate), MAX(birthdate)) as age_range_years
FROM gold.dim_customers;
