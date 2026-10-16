-- create database 
create database healthcare_db;

-- use database
use healthcare_db;

-- create master key 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'avani2324sharma@12';

-- create managed identity credentials 
CREATE DATABASE SCOPED CREDENTIAL WorkspaceIdentity 
WITH IDENTITY = 'Managed Identity';

-- create external data source 
CREATE EXTERNAL DATA SOURCE external_source
WITH (
    LOCATION = 'abfss://healthcare-project@externalregex.dfs.core.windows.net/',
    CREDENTIAL = WorkspaceIdentity
);

-- create parquet file format  
CREATE EXTERNAL FILE FORMAT parquet_format
WITH (
    FORMAT_TYPE = PARQUET
);

-- create schema 
create schema bronze;

-- create external table
CREATE EXTERNAL TABLE healthcare_db.bronze.prescriber (
    Prscrbr_NPI VARCHAR(20),
    Prscrbr_Last_Org_Name VARCHAR(200),
    Prscrbr_First_Name VARCHAR(100),
    Prscrbr_City VARCHAR(100),
    Prscrbr_State_Abrvtn VARCHAR(10),
    Prscrbr_State_FIPS VARCHAR(10),
    Prscrbr_Type VARCHAR(150),
    Prscrbr_Type_Src VARCHAR(100), 
    Brnd_Name VARCHAR(200),
    Gnrc_Name VARCHAR(200),
    Tot_Clms BIGINT,
    Tot_30day_Fills DECIMAL(18,2),
    Tot_Day_Suply BIGINT,
    Tot_Drug_Cst DECIMAL(18,2),
    Tot_Benes INT,
    GE65_Sprsn_Flag VARCHAR(5),
    GE65_Tot_Clms INT,
    GE65_Tot_30day_Fills DECIMAL(18,2),
    GE65_Tot_Drug_Cst DECIMAL(18,2),
    GE65_Tot_Day_Suply BIGINT,
    GE65_Bene_Sprsn_Flag VARCHAR(5),
    GE65_Tot_Benes INT
)
WITH (
    LOCATION = 'Landing/prescriber/mup_data.parquet',       
    DATA_SOURCE = external_source,     
    FILE_FORMAT = parquet_format            
);

-- view the data 
SELECT * FROM healthcare_db.bronze.prescriber;