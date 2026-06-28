-- 1. Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AvaniSharma@123';

-- 2. Database Scoped Credential
CREATE DATABASE SCOPED CREDENTIAL sas_crdntl
WITH
    IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = 'SAS token';

-- 3. External Data Source
CREATE EXTERNAL DATA SOURCE prescriber_strg
WITH
(
    LOCATION = 'abfss://healthcare-project@externalregex.dfs.core.windows.net/',
    CREDENTIAL = sas_crdntl
);

-- 4. External File Format
CREATE EXTERNAL FILE FORMAT format_parquet
WITH
(
    FORMAT_TYPE = PARQUET
);


-- 5. External Table
CREATE EXTERNAL TABLE prescriber_ext
(
    Prscrbr_NPI BIGINT,
    Prscrbr_Last_Org_Name VARCHAR(100),
    Prscrbr_First_Name VARCHAR(100),
    Prscrbr_City VARCHAR(100),
    Prscrbr_State_Abrvtn VARCHAR(2),
    Prscrbr_State_FIPS INT,
    Prscrbr_Type VARCHAR(100),
    Prscrbr_Type_Src VARCHAR(50),
    Brnd_Name VARCHAR(100),
    Gnrc_Name VARCHAR(100),
    Tot_Clms INT,
    Tot_30day_Fills DECIMAL(18,1),
    Tot_Day_Suply INT,
    Tot_Drug_Cst DECIMAL(18,2),
    Tot_Benes INT,
    GE65_Sprsn_Flag CHAR(1),
    GE65_Tot_Clms INT,
    GE65_Tot_30day_Fills DECIMAL(18,1),
    GE65_Tot_Drug_Cst DECIMAL(18,2),
    GE65_Tot_Day_Suply INT,
    GE65_Bene_Sprsn_Flag CHAR(1),
    GE65_Tot_Benes INT
)
WITH
(
    LOCATION = 'Landing/prescriber/mup_data.parquet',
    DATA_SOURCE = hospital_strg,
    FILE_FORMAT = parquet_format
);

-- 6. Check data
SELECT * FROM prescriber_ext;

-- 7. Bronze Table
CREATE TABLE bronze_prescriber
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT
    Prscrbr_NPI,
    Prscrbr_Last_Org_Name,
    Prscrbr_First_Name,
    Prscrbr_City,
    Prscrbr_State_Abrvtn,
    Prscrbr_State_FIPS,
    Prscrbr_Type,
    Prscrbr_Type_Src,
    Brnd_Name,
    Gnrc_Name,
    Tot_Clms,
    Tot_30day_Fills,
    Tot_Day_Suply,
    Tot_Drug_Cst,
    Tot_Benes,
    GE65_Sprsn_Flag,
    GE65_Tot_Clms,
    GE65_Tot_30day_Fills,
    GE65_Tot_Drug_Cst,
    GE65_Tot_Day_Suply,
    GE65_Bene_Sprsn_Flag,
    GE65_Tot_Benes,
    'prescriber.parquet' AS source_file,
    GETDATE() AS loaded_at
FROM prescriber_ext;

-- 8. Verify
SELECT * FROM bronze_prescriber;


