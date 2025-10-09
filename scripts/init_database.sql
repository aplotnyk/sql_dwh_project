/*
==================================================================================================
Create Database and Schemas
==================================================================================================
Script Purpose:
	This script creates a new database named 'DataWarehouse' after checking if it already exists.
    If the database exists, it is dropped and recreated. Additionally, the script sets up 
    three schemas within the database: 'bronze', 'silver', and 'gold'.

Warning:
    Running this script will drop the entire 'DataWarehouse' database if it exists.
    All data in the database will be permanently deleted.
    Ensure you have proper backups before running this script
==================================================================================================
*/
USE master;
GO

-- Dropping and recreating the 'DataWarehouse database'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DEOP DATABASE DataWarehouse;
END;
GO

  
-- Creating Database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;
GO

-- Creating schemas
CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
