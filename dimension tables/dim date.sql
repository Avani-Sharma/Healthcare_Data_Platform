DROP TABLE silver.DIM_DATE;
-- Create Dimension Date Table
CREATE TABLE silver.DIM_DATE (
    date_sk INT NOT NULL,              
    calendar_date DATE NOT NULL,       
    year INT NOT NULL,                 
    month INT NOT NULL,                
    quarter INT NOT NULL,              
    month_name VARCHAR(20) NOT NULL,   
    is_holiday BIT NOT NULL DEFAULT 0, 
    CONSTRAINT PK_DIM_DATE PRIMARY KEY  NONCLUSTERED (date_sk) NOT ENFORCED
)
WITH (
    DISTRIBUTION = REPLICATE, 
    CLUSTERED COLUMNSTORE INDEX
);


-- Load Data into DIM_DATE
DECLARE @StartDate DATE = '2015-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WITH RowSource AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS RowNum
    FROM sys.objects a CROSS JOIN sys.objects b CROSS JOIN sys.objects c
),
DateSequence AS (
    SELECT DATEADD(DAY, RowNum, '2015-01-01') AS GeneratedDate
    FROM RowSource
    WHERE RowNum <= DATEDIFF(DAY, '2015-01-01', '2030-12-31')
)
INSERT INTO silver.DIM_DATE (
    date_sk,
    calendar_date,
    year,
    month,
    quarter,
    month_name,
    is_holiday
)
SELECT 
    CAST(CONVERT(VARCHAR(8), GeneratedDate, 112) AS INT),
    GeneratedDate,
    DATEPART(YEAR, GeneratedDate),
    DATEPART(MONTH, GeneratedDate),
    DATEPART(QUARTER, GeneratedDate),
    DATENAME(MONTH, GeneratedDate),
    CASE WHEN DATEPART(WEEKDAY, GeneratedDate) IN (1, 7) THEN 1 ELSE 0 END
FROM DateSequence;



-- verify loaded data 
SELECT * FROM silver.DIM_DATE;

