-- use database
use healthcare_db;

-- create csv file format 
CREATE EXTERNAL FILE FORMAT csv_file_format
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS (
        FIELD_TERMINATOR = ',',    
        STRING_DELIMITER = '"',     
        FIRST_ROW = 2               
    )
);

-- create external table 
CREATE EXTERNAL TABLE healthcare_db.bronze.patient (
    resourceType VARCHAR(50),
    Patientid VARCHAR(100),
    gender VARCHAR(20),
    birthDate VARCHAR(30),       
    age_band VARCHAR(30),
    patient_ref VARCHAR(100),
    latest_claim_date VARCHAR(50),
    insurance_cover_display VARCHAR(200),
    claim_id VARCHAR(100),
    insurance_tier VARCHAR(50)
)
WITH (
    LOCATION = 'Landing/patient/patient_insurance.csv',        
    DATA_SOURCE = external_source,                    
    FILE_FORMAT = csv_file_format                     
);

-- view the data 
select * FROM healthcare_db.bronze.patient;
