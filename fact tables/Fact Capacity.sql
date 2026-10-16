CREATE TABLE silver.FACT_CAPACITY (
    facility_sk INT NOT NULL,
    date_sk INT NOT NULL,
    ward_type VARCHAR(50),
    staffed_beds INT,
    occupied_beds INT,
    occupancy_pct DECIMAL(5,2),
    nurse_fte DECIMAL(5,2)
)
WITH (
    DISTRIBUTION = HASH(facility_sk), 
    CLUSTERED COLUMNSTORE INDEX
);


INSERT INTO silver.FACT_CAPACITY (
    facility_sk,
    date_sk,
    ward_type,
    staffed_beds,
    occupied_beds,
    occupancy_pct,
    nurse_fte
)
SELECT 
    ISNULL(df.facility_sk, -1),
    CAST(CONVERT(VARCHAR(8), bh.fiscal_year_begin_date, 112) AS INT),
    'GENERAL',
    bh.number_of_beds,
    bh.total_days_total,
    bh.cost_to_charge_ratio,
    1.00
FROM bronze_hospital bh
LEFT JOIN silver.DIM_FACILITY df 
    ON bh.provider_ccn = df.facility_id 
    AND df.is_current = 1;



SELECT * FROM silver.FACT_CAPACITY;
