CREATE TABLE silver.FACT_DRUG_SPEND (
    physician_sk INT NOT NULL,
    facility_sk INT NOT NULL,
    date_sk INT NOT NULL,
    total_claims INT,
    total_drug_cost DECIMAL(18,2),
    total_benes INT
)
WITH (
    DISTRIBUTION = HASH(physician_sk), 
    CLUSTERED COLUMNSTORE INDEX
);



INSERT INTO silver.FACT_DRUG_SPEND (
    physician_sk,
    facility_sk,
    date_sk,
    total_claims,
    total_drug_cost,
    total_benes
)
SELECT 
    ISNULL(dp.physician_sk, -1),
    -1,
    20260101,
    bp.Tot_Clms,
    bp.Tot_Drug_Cst,
    bp.Tot_Benes
FROM bronze_prescriber bp
LEFT JOIN silver.DIM_PHYSICIAN dp 
    ON bp.Prscrbr_NPI = dp.physician_id 
    AND dp.is_current = 1;



SELECT * FROM silver.FACT_DRUG_SPEND;
