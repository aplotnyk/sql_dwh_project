-- Find the total Sales
SELECT SUM(sales_amount) as total_sales FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_items_sold FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_selling_price FROM gold.fact_sales;

-- Find the Total number of Orders
SELECT COUNT(DISTINCT order_number) AS orders_total FROM gold.fact_sales;

-- Find the Total number of Products

SELECT COUNT(DISTINCT product_id) AS products_total FROM gold.dim_products;
-- Find the Total number of Customers
SELECT COUNT(customer_id) AS customers_total FROM gold.dim_customers;

-- Find the Total number of Customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS customers_who_ordered FROM gold.fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' as measure_name, SUM(sales_amount) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' as measure_name, SUM(quantity) as measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' as measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr.Orders' as measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr.Products' as measure_name, COUNT(DISTINCT product_id) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total Nr.Customers' as measure_name, COUNT(customer_id) AS measure_value FROM gold.dim_customers
UNION ALL
SELECT 'Total Nr.Customers who ordered' as measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales;
