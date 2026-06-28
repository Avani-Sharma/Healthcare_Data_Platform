-- Create Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AvaniSharma@123';


-- Create SAS Credential for accessing ADLS Gen2
CREATE DATABASE SCOPED CREDENTIAL icd_sas_cred
WITH
    IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = 'SAS token';


-- Create External Data Source 
CREATE EXTERNAL DATA SOURCE icd_source
WITH (
    LOCATION = 'abfss://healthcare-project@externalregex.dfs.core.windows.net/',
    CREDENTIAL = icd_sas_cred
);


-- CSV File Format
CREATE EXTERNAL FILE FORMAT icd_csv_format
WITH (
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2
    )
);


-- Create External Table over CSV file
CREATE EXTERNAL TABLE ext_icd (
    ICD_Code VARCHAR(20),
    ICD_Description VARCHAR(500)
)
WITH (
    LOCATION = 'Landing/icd/icd.csv',
    DATA_SOURCE = icd_source,
    FILE_FORMAT = icd_csv_format
);


-- View data from external CSV file
SELECT * FROM ext_icd;


-- Create Bronze Layer table
CREATE TABLE Bronze_ICD (
    ICD_Code VARCHAR(20),
    ICD_Description VARCHAR(500),
    File_Name VARCHAR(200),
    Load_Timestamp DATETIME
);


-- Load data from External Table into Bronze Layer
INSERT INTO Bronze_ICD
SELECT
    ICD_Code,
    ICD_Description,
    'icd.csv',
    GETDATE()
FROM ext_icd;


-- Verify Bronze Layer data
SELECT * FROM Bronze_ICD;




-- External Table
DROP EXTERNAL TABLE ext_icd;
-- Bronze Table
DROP TABLE bronze_ICD;
-- External File Format
DROP EXTERNAL FILE FORMAT icd_csv_format;
-- External Data Source
DROP EXTERNAL DATA SOURCE icd_source;
-- Database Scoped Credential
DROP DATABASE SCOPED CREDENTIAL icd_sas_cred;