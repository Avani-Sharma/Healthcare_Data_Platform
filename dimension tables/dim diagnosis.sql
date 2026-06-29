-- Create Dimension Diagnosis Table
CREATE TABLE silver.DIM_DIAGNOSIS (
    diag_sk INT NOT NULL IDENTITY(1,1),
    diag_code VARCHAR(20) NOT NULL,
    diag_description VARCHAR(500),
    chapter CHAR(1),
    severity_tier VARCHAR(10),
    eff_from DATE NOT NULL,
    eff_to DATE,
    is_current BIT NOT NULL DEFAULT 1,
    source_file VARCHAR(255),
    loaded_at DATETIME,
    CONSTRAINT PK_DIM_DIAGNOSIS PRIMARY KEY NONCLUSTERED (diag_sk) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE, 
    CLUSTERED COLUMNSTORE INDEX
);

-- Load Data into DIM_DIAGNOSIS
INSERT INTO silver.DIM_DIAGNOSIS (
    diag_code,
    diag_description,
    chapter,
    severity_tier,
    eff_from,
    eff_to,
    is_current,
    source_file,
    loaded_at
)
SELECT DISTINCT
    ICD_Code,
    ICD_Description,
    LEFT(ICD_Code, 1),
    CASE 
        WHEN LEFT(ICD_Code, 1) BETWEEN 'A' AND 'M' THEN 'HIGH'
        WHEN LEFT(ICD_Code, 1) BETWEEN 'N' AND 'Z' THEN 'MED'
        ELSE 'LOW'
    END,
    CAST(GETDATE() AS DATE), 
    NULL,         
    1,         
    'icd.csv',
    GETDATE()   
FROM Bronze_ICD;


-- verify loaded data 
SELECT * FROM silver.DIM_DIAGNOSIS;

