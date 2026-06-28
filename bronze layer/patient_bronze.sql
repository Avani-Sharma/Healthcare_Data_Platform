-- 1. Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AvaniSharma@123';

-- 2. Database Scoped Credential
CREATE DATABASE SCOPED CREDENTIAL sas_cred
WITH
    IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = 'SAS token';

-- 3. External Data Source
CREATE EXTERNAL DATA SOURCE patient_strg
WITH
(
    LOCATION = 'abfss://healthcare-project@externalregex.dfs.core.windows.net/',
    CREDENTIAL = sas_cred
);

-- 4. External File Format
CREATE EXTERNAL FILE FORMAT csv_frmt
WITH
(
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS
    (
        FIELD_TERMINATOR = ',',
        STRING_DELIMITER = '"',
        FIRST_ROW = 2
    )
);


-- 5. External Table
CREATE EXTERNAL TABLE patient_ext
(
    patient_id VARCHAR(100),
    gender VARCHAR(20),
    birth_date DATE,
    age_band VARCHAR(20),
    patient_ref VARCHAR(100),
    latest_claim_date VARCHAR(50),
    insurance_cover_display VARCHAR(100),
    claim_id VARCHAR(100),
    insurance_tier VARCHAR(50)
)
WITH
(
    LOCATION = 'Landing/patient/patient.csv',
    DATA_SOURCE = patient_strg,
    FILE_FORMAT = csv_frmt
);

-- 6. Check data
SELECT * FROM patient_ext;

-- 7. Bronze Table
CREATE TABLE bronze_patient
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT
    patient_id,
    gender,
    birth_date,
    age_band,
    patient_ref,
    latest_claim_date,
    insurance_cover_display,
    claim_id,
    insurance_tier,
    'patient.csv' AS source_file,
    GETDATE() AS loaded_at
FROM patient_ext;

-- 8. Verify
SELECT * FROM bronze_patient;




-- External Table
DROP EXTERNAL TABLE patient_ext;
-- Bronze Table
DROP TABLE bronze_patient;
-- External File Format
DROP EXTERNAL FILE FORMAT csv_frmt;
-- External Data Source
DROP EXTERNAL DATA SOURCE patient_strg;
-- Database Scoped Credential
DROP DATABASE SCOPED CREDENTIAL sas_cred;
