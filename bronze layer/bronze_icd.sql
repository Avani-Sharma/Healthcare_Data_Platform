-- use database
use healthcare_db;

-- create parquet file format  
CREATE EXTERNAL FILE FORMAT parquet_format
WITH (
    FORMAT_TYPE = PARQUET
);

-- create external table 
CREATE EXTERNAL TABLE healthcare_db.bronze.icd (
    icd_code VARCHAR(20),        
    description VARCHAR(250) 
)
WITH (
    LOCATION = 'Landing/icd/icd10cm_codes_2025.parquet',       
    DATA_SOURCE = external_source,     
    FILE_FORMAT = parquet_format       
);

-- view the data
select * from healthcare_db.bronze.icd;