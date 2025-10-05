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
