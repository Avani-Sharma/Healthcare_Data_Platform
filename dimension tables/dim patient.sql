-- Create Silver Schema
CREATE SCHEMA silver;

-- Create Dimension Patient Table
CREATE TABLE silver.DIM_PATIENT (
    patient_sk INT NOT NULL IDENTITY(1,1),
    patient_id VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    birth_date DATE,
    age_band VARCHAR(10),
    insurance_tier VARCHAR(50),
    eff_from DATE NOT NULL,
    eff_to DATE,
    is_current BIT NOT NULL DEFAULT 1,
    source_file VARCHAR(255),
    loaded_at DATETIME,
    CONSTRAINT PK_DIM_PATIENT PRIMARY KEY NONCLUSTERED (patient_sk) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE, 
    CLUSTERED COLUMNSTORE INDEX
);


-- Load Data into DIM_PATIENT
INSERT INTO silver.DIM_PATIENT (
    patient_id,
    gender,
    birth_date,
    age_band,
    insurance_tier,
    eff_from,
    eff_to,
    is_current,
    source_file,
    loaded_at
)
SELECT 
    patient_id,
    gender,
    CAST(birth_date AS DATE) AS birth_date,
    age_band,               
    insurance_tier,          
    CAST(GETDATE() AS DATE) AS eff_from, 
    NULL AS eff_to,         
    1 AS is_current,         
    'patient.csv' AS source_file, 
    GETDATE() AS loaded_at   
FROM bronze_patient;             


-- Verify Loaded Data
SELECT  * FROM silver.DIM_PATIENT;
