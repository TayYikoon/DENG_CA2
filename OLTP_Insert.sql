USE SPAI2A0104;

-- Insert into Employee table
BULK INSERT Employee
FROM 'C:\Users\obsid\OneDrive\Documents\DENG\CA2\CA2 DENG\Datasets\employee.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Check Employee table
SELECT * FROM Employee;

-- Insert into Customer table
BULK INSERT Customer
FROM 'C:\Users\obsid\OneDrive\Documents\DENG\CA2\CA2 DENG\Datasets\customer.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Check Customer table
SELECT * FROM Customer;

-- Insert into Dataset table
BULK INSERT Dataset
FROM 'C:\Users\obsid\OneDrive\Documents\DENG\CA2\CA2 DENG\Datasets\dataset.csv'  -- Assuming the correct file name is 'dataset.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Check Dataset table
SELECT * FROM Dataset;

-- Insert into ModelType table
BULK INSERT ModelType
FROM 'C:\Users\obsid\OneDrive\Documents\DENG\CA2\CA2 DENG\Datasets\type.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Check ModelType table
SELECT * FROM ModelType;

-- Insert into Model table
BULK INSERT Model
FROM 'C:\Users\obsid\OneDrive\Documents\DENG\CA2\CA2 DENG\Datasets\model.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Check Model table
SELECT * FROM Model;

-- Insert into Orders table
BULK INSERT Orders
FROM 'C:\Users\obsid\OneDrive\Documents\DENG\CA2\CA2 DENG\orders1.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

-- Check Orders table
SELECT * FROM Orders;