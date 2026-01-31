/*
============================================================================
Quality Checks
============================================================================
Script Purpose:
	This script performs various quality checks to validate the integrity, 
  consistency and accuracy of the Gold Layer. It includes checks for:
		- Uniqueness of surrogate keys of the dimension tables
		- Referential integrity between fact and dimension tables
		- Validation of relationships in the data model for analytical purposes

Usage Notes:
	- Run these checks after loading the data for Silver Layer
	- Investigate and resolve any discrepancies found during the checks
============================================================================
*/

-- =================================================================
-- Checking gold.dim_customers
-- =================================================================
-- Check for Uniqueness of Product Key in gold.dim_customers
-- Expectation: No results
SELECT
	customer_key,
	COUNT(*) AS duplicate_cout
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- =================================================================
-- Checking gold.product_key
-- =================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results
SELECT
	product_key,
	COUNT(*) duplicate_cout
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- =================================================================
-- Checking gold.fact_sales
-- =================================================================
-- Check the data model connectivity between fact and dimensions
-- (sales records without matching dimension records)
-- Expectation: No Result
-- For future optimisation: Turn the fact_sales to the Table for better performance,
-- keep dimensions as views

SELECT *
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
	ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;


