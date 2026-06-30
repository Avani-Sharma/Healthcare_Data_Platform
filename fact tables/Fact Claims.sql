CREATE TABLE silver.FACT_CLAIMS (
    claim_id VARCHAR(100) NOT NULL,
    patient_sk INT NOT NULL,
    facility_sk INT NOT NULL,
    diag_sk INT NOT NULL,
    date_sk INT NOT NULL,
    billed_amount DECIMAL(18,2),
    paid_amount DECIMAL(18,2),
    claim_decision VARCHAR(20)
)
WITH (
    DISTRIBUTION = HASH(claim_id), 
    CLUSTERED COLUMNSTORE INDEX
);


INSERT INTO silver.FACT_CLAIMS (
    claim_id,
    patient_sk,
    facility_sk,
    diag_sk,
    date_sk,
    billed_amount,
    paid_amount,
    claim_decision
)
SELECT 
    bp.claim_id,
    ISNULL(dp.patient_sk, -1),
    -1,
    -1,
    ISNULL(CAST(CONVERT(VARCHAR(8), CAST(bp.latest_claim_date AS DATE), 112) AS INT), 20260101),
    500.00,
    400.00,
    'APPROVED'
FROM bronze_patient bp
LEFT JOIN silver.DIM_PATIENT dp 
    ON bp.patient_id = dp.patient_id 
    AND dp.is_current = 1;



SELECT * FROM silver.FACT_CLAIMS;