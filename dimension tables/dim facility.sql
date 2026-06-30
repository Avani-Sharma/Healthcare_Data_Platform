-- Create Dimension Facility Table
CREATE TABLE silver.DIM_FACILITY (
    facility_sk INT NOT NULL IDENTITY(1,1),
    facility_id VARCHAR(50) NOT NULL,
    facility_name VARCHAR(200),
    street_address VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(10),
    zip_code VARCHAR(20),
    facility_type VARCHAR(20),
    eff_from DATE NOT NULL,
    eff_to DATE,
    is_current BIT NOT NULL DEFAULT 1,
    CONSTRAINT PK_DIM_FACILITY PRIMARY KEY NONCLUSTERED (facility_sk) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE, 
    CLUSTERED COLUMNSTORE INDEX
);


-- Load Data into DIM_FACILITY
INSERT INTO silver.DIM_FACILITY (
    facility_id,
    facility_name,
    street_address,
    city,
    state,
    zip_code,
    facility_type,
    eff_from,
    eff_to,
    is_current
)
SELECT DISTINCT
    provider_ccn,
    facility_name,
    street_address,
    city,
    state_code,
    zip_code,
    CASE 
        WHEN rural_versus_urban = 'R' THEN 'RURAL'
        WHEN rural_versus_urban = 'U' THEN 'URBAN'
        ELSE 'UNKNOWN'
    END,
    CAST(GETDATE() AS DATE), 
    NULL, 1
FROM bronze_hospital;


-- Verify Loaded Data
SELECT * FROM silver.DIM_FACILITY;
