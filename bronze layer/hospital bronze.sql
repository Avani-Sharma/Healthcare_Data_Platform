-- 1. Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AvaniSharma@123';

-- 2. Database Scoped Credential
CREATE DATABASE SCOPED CREDENTIAL sas_crdn
WITH
    IDENTITY = 'SHARED ACCESS SIGNATURE',
    SECRET = 'SAS token';

-- 3. External Data Source
CREATE EXTERNAL DATA SOURCE hospital_strg
WITH
(
    LOCATION = 'abfss://healthcare-project@externalregex.dfs.core.windows.net/',
    CREDENTIAL = sas_crdn
);

-- 4. External File Format
CREATE EXTERNAL FILE FORMAT parquet_frmt
WITH
(
    FORMAT_TYPE = PARQUET
);


-- 5. External Table
CREATE EXTERNAL TABLE hospital_ext
(
    rpt_rec_num BIGINT,
    provider_ccn VARCHAR(10),
    facility_name VARCHAR(200),
    street_address VARCHAR(200),
    city VARCHAR(100),
    state_code VARCHAR(2),
    zip_code VARCHAR(10),
    county VARCHAR(100),
    medicare_cbsa_number INT,
    rural_versus_urban VARCHAR(1),
    fiscal_year_begin_date DATE,
    fiscal_year_end_date DATE,
    type_of_control VARCHAR(100),
    number_of_beds INT,
    total_bed_days_available INT,
    total_days_title_xviii INT,
    total_days_total INT,
    total_discharges_title_xviii INT,
    total_discharges_total INT,
    inpatient_revenue DECIMAL(18,2),
    outpatient_revenue DECIMAL(18,2),
    total_patient_revenue DECIMAL(18,2),
    less_contractual_allowance_and_discounts DECIMAL(18,2),
    net_patient_revenue DECIMAL(18,2),
    less_total_operating_expense DECIMAL(18,2),
    net_income_from_service_to_patients DECIMAL(18,2),
    net_income DECIMAL(18,2),
    drg_amounts_other_than_outlier_payments DECIMAL(18,2),
    total_ime_payment DECIMAL(18,2),
    allowable_dsh_percentage DECIMAL(10,4),
    cost_to_charge_ratio DECIMAL(10,4)
)
WITH
(
    LOCATION = 'Landing/hospital/hospital.parquet',
    DATA_SOURCE = hospital_strg,
    FILE_FORMAT = parquet_frmt
);

-- 6. Check data
SELECT * FROM hospital_ext;

-- 7. Bronze Table
CREATE TABLE bronze_hospital
WITH
(
    DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT
    rpt_rec_num,
    provider_ccn,
    facility_name,
    street_address,
    city,
    state_code,
    zip_code,
    county,
    medicare_cbsa_number,
    rural_versus_urban,
    fiscal_year_begin_date,
    fiscal_year_end_date,
    type_of_control,
    number_of_beds,
    total_bed_days_available,
    total_days_title_xviii,
    total_days_total,
    total_discharges_title_xviii,
    total_discharges_total,
    inpatient_revenue,
    outpatient_revenue,
    total_patient_revenue,
    less_contractual_allowance_and_discounts,
    net_patient_revenue,
    less_total_operating_expense,
    net_income_from_service_to_patients,
    net_income,
    drg_amounts_other_than_outlier_payments,
    total_ime_payment,
    allowable_dsh_percentage,
    cost_to_charge_ratio,
    'hospital.parquet' AS source_file,
    GETDATE() AS loaded_at
FROM hospital_ext;


-- 8. Verify
SELECT * FROM bronze_hospital;



