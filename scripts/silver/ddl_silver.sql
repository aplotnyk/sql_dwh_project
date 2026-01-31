/*
====================================================================
DDL Script: Create Silver Tables
====================================================================
Script Purpose:
  The script creates tables in the 'silver' schema, dropping 
  existing tables if they already exist.
  Run the script to re-define the DDL structure of 'silver' Tables'
====================================================================
*/
  
IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
cid NVARCHAR(50),
cntry NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
cid NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50) 
);
GO

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- ====================================================================
-- CREATE INDEXES FOR PERFORMANCE OPTIMIZATION
-- ====================================================================

-- Indexes for crm_cust_info (used in JOINs by gold.dim_customers)
CREATE INDEX IX_crm_cust_info_cst_id 
ON silver.crm_cust_info(cst_id);

CREATE INDEX IX_crm_cust_info_cst_key 
ON silver.crm_cust_info(cst_key);

-- Indexes for crm_prd_info (used in JOINs by gold.dim_products)
CREATE INDEX IX_crm_prd_info_prd_id 
ON silver.crm_prd_info(prd_id);

CREATE INDEX IX_crm_prd_info_prd_key 
ON silver.crm_prd_info(prd_key);

CREATE INDEX IX_crm_prd_info_cat_id 
ON silver.crm_prd_info(cat_id);

-- Indexes for crm_sales_details (fact table source)
CREATE INDEX IX_crm_sales_details_sls_cust_id 
ON silver.crm_sales_details(sls_cust_id);

CREATE INDEX IX_crm_sales_details_sls_prd_key 
ON silver.crm_sales_details(sls_prd_key);

CREATE INDEX IX_crm_sales_details_sls_order_dt 
ON silver.crm_sales_details(sls_order_dt);

-- Indexes for ERP tables (used in JOINs)
CREATE INDEX IX_erp_cust_az12_cid 
ON silver.erp_cust_az12(cid);

CREATE INDEX IX_erp_loc_a101_cid 
ON silver.erp_loc_a101(cid);

CREATE INDEX IX_erp_px_cat_g1v2_id 
ON silver.erp_px_cat_g1v2(id);
