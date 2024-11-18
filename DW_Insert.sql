USE SPAIDW2A0104;

-- Insert data into the Time dimension table
DECLARE @StartDate DATETIME = '20200101'
DECLARE @EndDate DATETIME = '20240101'

DECLARE @curDate DATE;

SET @curDate = @StartDate;

WHILE @curDate <= @EndDate 
BEGIN
    INSERT INTO Time (Date, Day, Month, Quarter, Year, DayOfWeek)
    SELECT 
        @curDate AS Date,
        DAY(@curDate) AS Day,
        MONTH(@curDate) AS Month,
        DATEPART(QUARTER, @curDate) AS Quarter,
        YEAR(@curDate) AS Year,
        LEFT(DATENAME(WEEKDAY, @curDate), 3) AS DayOfWeek;

    -- Increment @curDate by 1 day
    SET @curDate = DATEADD(DAY, 1, @curDate);
END

-- Check Time dimension
SELECT * FROM SPAIDW2A0104..Time

-- Insert data into the Customer dimension table
INSERT INTO
	SPAIDW2A0104..Customer
SELECT
	*
FROM SPAI2A0104..Customer

-- Check Customer dimension
SELECT * FROM SPAIDW2A0104..Customer

-- Insert data into the Employee dimension table
INSERT INTO
	SPAIDW2A0104..Employee
SELECT
	*
FROM SPAI2A0104..Employee

-- Check Employee dimension
SELECT * FROM SPAIDW2A0104..Employee

-- Insert data into the Order dimension table
INSERT INTO
	SPAIDW2A0104..[Order]
SELECT
	OrderID, RequiredAcc, OrderDate
FROM SPAI2A0104..Orders

-- Check Order dimension
SELECT * FROM SPAIDW2A0104..[Order]

-- Insert data into the Dataset dimension table
INSERT INTO 
	SPAIDW2A0104..Dataset
SELECT
	*
FROM SPAI2A0104..Dataset

-- Check Dataset dimension
SELECT * FROM SPAIDW2A0104..Dataset

-- Insert data into the ModelType dimension table
INSERT INTO 
	SPAIDW2A0104..ModelType
SELECT
	*
FROM SPAI2A0104..ModelType

-- Check ModelType dimension
SELECT * FROM SPAIDW2A0104..ModelType

-- Insert data into the Model dimension table
INSERT INTO 
	SPAIDW2A0104..Model
SELECT
	ModelID, ModelCode, TrainingDate, Accuracy
FROM SPAI2A0104..Model

-- Check Model dimension
SELECT * FROM SPAIDW2A0104..Model

-- Insert data into the OrderFacts fact table
INSERT INTO OrderFacts (OrderSK, TimeSK, CustomerSK, EmployeeSK, ModelSK, DatasetSK, Price)
SELECT 
    o.OrderSK,
    t.TimeSK,
    c.CustomerSK,
    e.EmployeeSK,
    m.ModelSK,
    d.DatasetSK,
    src_o.Price
FROM 
    [Order] o
    INNER JOIN SPAI2A0104..Orders src_o ON o.OrderID = src_o.OrderID
    INNER JOIN Time t ON t.Date = src_o.CompletionDate
    INNER JOIN Customer c ON src_o.CustomerID = c.CustomerID
    INNER JOIN Employee e ON src_o.EmployeeID = e.EmployeeID
    INNER JOIN Model m ON src_o.ModelID = m.ModelID
    INNER JOIN SPAI2A0104..Model olm ON src_o.ModelID = olm.ModelID
    INNER JOIN Dataset d ON olm.DatasetID = d.DatasetID;

-- Check OrderFacts fact table
SELECT * FROM SPAIDW2A0104..OrderFacts