-- Create Dimension physician Table
CREATE TABLE silver.DIM_PHYSICIAN (
    physician_sk INT NOT NULL IDENTITY(1,1),      
    physician_id BIGINT NOT NULL,                
    physician_name VARCHAR(250),                 
    specialty VARCHAR(100),                     
    state VARCHAR(10),                          
    eff_from DATE NOT NULL,                       
    eff_to DATE,                                
    is_current BIT NOT NULL DEFAULT 1,                               
    CONSTRAINT PK_DIM_PHYSICIAN PRIMARY KEY NONCLUSTERED (physician_sk) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE, 
    CLUSTERED COLUMNSTORE INDEX
);

-- Load Data into DIM_PHYSICIAN
INSERT INTO silver.DIM_PHYSICIAN (
    physician_id,
    physician_name,
    specialty,
    state,
    eff_from,
    eff_to,
    is_current
)
SELECT DISTINCT
    Prscrbr_NPI AS physician_id,
    ISNULL(Prscrbr_First_Name, '') + ' ' + ISNULL(Prscrbr_Last_Org_Name, '') AS physician_name,
    Prscrbr_Type AS specialty,
    Prscrbr_State_Abrvtn AS state,
    CAST(GETDATE() AS DATE) AS eff_from, 
    NULL AS eff_to,         
    1 AS is_current  
FROM bronze_prescriber; 

-- Verify Loaded Data
SELECT * FROM silver.DIM_PHYSICIAN;
