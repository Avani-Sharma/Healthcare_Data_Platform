-- use database
use healthcare_db;

-- create parquet file format  
CREATE EXTERNAL FILE FORMAT parquet_format
WITH (
    FORMAT_TYPE = PARQUET
);

-- create external table 
CREATE EXTERNAL TABLE healthcare_db.bronze.hospital (
    rpt_rec_num VARCHAR(50),
    Provider_CCN VARCHAR(20),
    Facility_Name VARCHAR(200),
    Street_Address VARCHAR(200),
    City VARCHAR(100),
    State_Code VARCHAR(10),
    Zip_Code VARCHAR(20),
    County VARCHAR(100),
    Medicare_CBSA_Number VARCHAR(50), 
    Rural_versus_Urban VARCHAR(5),
    Fiscal_Year_Begin_Date VARCHAR(30),
    Fiscal_Year_End_Date VARCHAR(30),
    Type_Of_Control VARCHAR(100),
    Number_of_Beds VARCHAR(50),                  
    Total_Bed_Days_Available VARCHAR(50),        
    Total_Days_Title_XVIII VARCHAR(50),          
    Total_Days_Total VARCHAR(50),               
    Total_Discharges_Title_XVIII VARCHAR(50),    
    Total_Discharges_Total VARCHAR(50),          
    Inpatient_Revenue VARCHAR(50),
    Outpatient_Revenue VARCHAR(50),
    Total_Patient_Revenue VARCHAR(50),
    Less_Contractual_Allowance VARCHAR(50),
    Net_Patient_Revenue VARCHAR(50),
    Less_Total_Operating_Expense VARCHAR(50),
    Net_Income_from_Service_to_Patients VARCHAR(50),
    Net_Income VARCHAR(50),
    DRG_Amounts_Other_Than_Outlier_Payments VARCHAR(50),
    Total_IME_Payment VARCHAR(50),
    Allowable_DSH_Percentage VARCHAR(50),        
    Cost_To_Charge_Ratio VARCHAR(50)             
)
WITH (
    LOCATION = 'Landing/hospital/CostReport_2022_Final.parquet',       
    DATA_SOURCE = external_source,     
    FILE_FORMAT = parquet_format       
);

-- view the data
select * from healthcare_db.bronze.hospital;

