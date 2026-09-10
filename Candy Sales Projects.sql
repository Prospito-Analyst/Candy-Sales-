
--Products Table
CREATE TABLE Dim_Products (     
    ProductID VARCHAR(20) NOT NULL PRIMARY KEY,
    Product_Name NVARCHAR(100) NOT NULL,
    DivisionID INT FOREIGN KEY REFERENCES Dim_Division(Division_ID),
    Factory_ID INT FOREIGN KEY REFERENCES Dim_Factory(Factory_ID),
    Unit_Price DECIMAL(10,2) NOT NULL,
    Unit_Cost DECIMAL (10,2) NOT NULL,
)

--Factory Table
CREATE TABLE Dim_Factory (
    Factory_ID INT IDENTITY(1,1) PRIMARY KEY,
    Factory NVARCHAR(100) NOT NULL,
    Latitude DECIMAL(10,2) NOT NULL,
    Longitude DECIMAL(10,2) NOT NULL
)

--Division Table
CREATE TABLE Dim_Division (
    Division_ID INT IDENTITY(1,1) PRIMARY KEY,
    Division NVARCHAR(20) NOT NULL 
)

--Location Table
CREATE TABLE Dim_Location ( 
    Location_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Country NVARCHAR(100) NOT NULL,
    [State] NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Region VARCHAR(100) NOT NULL
)

--Facts Sales Table
CREATE TABLE Facts_Sales (
    Sales_ID INT IDENTITY(1,1),
    Order_ID VARCHAR(100),
    Order_Date DATE NOT NULL,
    Ship_Date DATE NOT NULL,
    Ship_Mode NVARCHAR(20),
    CustomerID NVARCHAR(20),  
    Location_ID INT FOREIGN KEY REFERENCES Dim_Location(Location_ID),
    Division_ID INT FOREIGN KEY REFERENCES Dim_Division(Division_ID),
    ProductID VARCHAR(20) FOREIGN KEY REFERENCES Dim_Products(ProductID),
    Factory_ID INT FOREIGN KEY REFERENCES Dim_Factory(Factory_ID),
    Sales DECIMAL(10,2),
    Units INT,
    Gross_Profit DECIMAL(10,2),
    Cost DECIMAL(10,2)   
)

--Populate Products Table
INSERT INTO Dim_Products (ProductID,Product_Name,DivisionID,Factory_ID, Unit_Price,Unit_Cost)
    SELECT DISTINCT Product_ID,
        Product_Name,
        dd.Division_ID,
        df.Factory_ID,
        Unit_Price,
        Unit_Cost
    FROM Candy_Products cp 
        INNER JOIN Dim_Division dd ON dd.Division =  cp.Division
        INNER JOIN Dim_Factory df ON df.Factory = cp.Factory

--Populate Factory Table
INSERT INTO Dim_Factory (Factory,Latitude,Longitude)
    SELECT DISTINCT Factory,
        Latitude,
        Longitude
    FROM Candy_Factories

--Populate Division Table
INSERT INTO Dim_Division (Division)
    SELECT DISTINCT Division
    FROM Candy_Sales

--Populate Location Table
INSERT INTO Dim_Location (Country,[State],City,Region)
    SELECT DISTINCT Country_Region,
        State_Province,
        City,
        Region
    FROM Candy_Sales 

--Populate Facts Sales Table
INSERT INTO Facts_Sales (
    Order_ID,Order_Date,Ship_Date,Ship_Mode,CustomerID,
    Location_ID,Division_ID,ProductID,Factory_ID,Sales,
    Units,Gross_Profit,Cost
)
SELECT Order_ID,
    Order_Date,
    Ship_Date,
    Ship_Mode,
    Customer_ID,
    dl.Location_ID,
    dd.Division_ID,
    dp.ProductID,
    dp.Factory_ID,
    Sales,
    Units,
    Gross_Profit,
    Cost
FROM Candy_Sales cs 
INNER JOIN Dim_Division dd 
    ON dd.Division = cs.Division
INNER JOIN Dim_Products dp 
    ON dp.Product_Name = cs.Product_Name
INNER JOIN Dim_Factory df 
    ON df.Factory_ID = dp.Factory_ID
INNER JOIN Dim_Location dl 
    ON dl.Country = cs.Country_Region
        AND dl.[State] = cs.State_Province
        AND dl.City = cs.City
        AND dl.Region = cs.Region

--Validations
SELECT COUNT(*) 
FROM Dim_Products dp
LEFT JOIN Dim_Factory df ON dp.Factory_ID = df.Factory_ID
WHERE df.Factory_ID IS NULL

SELECT COUNT(*) AS OrphanedRows
FROM Facts_Sales fs
LEFT JOIN Dim_Location dl ON fs.Location_ID = dl.Location_ID
WHERE dl.Location_ID IS NULL

SELECT COUNT(*) AS FactRows FROM Facts_Sales
SELECT COUNT(*) AS RawRows FROM Candy_Sales



--Analysis
--1. Revenue/Profit
SELECT 
    DATEPART(YEAR,Order_Date) AS Year,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit
FROM Facts_Sales
GROUP BY DATEPART(YEAR,Order_Date)
ORDER BY SUM(Sales) DESC 

--2. Location Analysis
--Revenue/Profit by Country
SELECT 
    dl.Country,
    DATEPART(YEAR,Order_Date) AS Year,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit
FROM Facts_Sales fs 
JOIN Dim_Location dl ON dl.Location_ID = fs.Location_ID 
WHERE Order_Date >= '2024-01-01' AND Order_Date <= '2024-12-31'
GROUP BY DATEPART(YEAR,Order_Date), Country
ORDER BY SUM(Sales) DESC 

--3. Revenue/Profit 
--State
SELECT 
    dl.[State],
    DATEPART(YEAR,Order_Date) AS Year,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit
FROM Facts_Sales fs 
JOIN Dim_Location dl ON dl.Location_ID = fs.Location_ID 
WHERE Order_Date >= '2024-01-01' AND Order_Date <= '2024-12-31'
GROUP BY DATEPART(YEAR,Order_Date), [State]
ORDER BY SUM(Sales) DESC

--Region
SELECT 
    dl.Region,
    DATEPART(YEAR,Order_Date) AS Year,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit
FROM Facts_Sales fs 
JOIN Dim_Location dl ON dl.Location_ID = fs.Location_ID 
WHERE Order_Date >= '2024-01-01' AND Order_Date <= '2024-12-31'
GROUP BY DATEPART(YEAR,Order_Date), Region
ORDER BY SUM(Sales) DESC

--City
SELECT 
    dl.City,
    DATEPART(YEAR,Order_Date) AS Year,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit
FROM Facts_Sales fs 
JOIN Dim_Location dl ON dl.Location_ID = fs.Location_ID 
WHERE Order_Date >= '2024-01-01' AND Order_Date <= '2024-12-31'
GROUP BY DATEPART(YEAR,Order_Date), City
ORDER BY SUM(Sales) DESC

--Preferred Product Division/Category and Their Revenue Generated
SELECT 
    dd.Division,
    DATEPART(YEAR,Order_Date) AS Year,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit,
    COUNT(Order_ID) AS total_orders
FROM Facts_Sales fs 
JOIN Dim_Division dd ON dd.Division_ID = fs.Division_ID
WHERE Order_Date >= '2024-01-01' AND Order_Date <= '2024-12-31'
GROUP BY DATEPART(YEAR,Order_Date),dd.Division
ORDER BY SUM(Sales) DESC

--Products Revenue Generated
SELECT 
    dp.ProductID,
    DATEPART(YEAR,Order_Date) AS Year,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit,
    COUNT(Order_ID) AS total_orders
FROM Facts_Sales fs 
JOIN Dim_Products dp ON dp.ProductID = fs.ProductID
WHERE Order_Date >= '2024-01-01' AND Order_Date <= '2024-12-31'
GROUP BY DATEPART(YEAR,Order_Date),dp.ProductID
ORDER BY SUM(Sales) DESC

--Overall Monthly Revenue,Profit,Orders 
WITH t1 AS (
SELECT 
    DATEPART(MONTH,Order_Date) AS Month,
    SUM(Sales) AS Total_revenue,
    SUM(Gross_Profit) AS Total_Profit,
    COUNT(Order_ID) AS total_orders
FROM Facts_Sales 
GROUP BY DATEPART(MONTH,Order_Date)

)
SELECT 
    Month,
    Total_revenue AS curr_rev,
    LAG(Total_revenue,1) OVER (ORDER BY Month) AS Prev_revenue,
    Total_revenue - (LAG(Total_revenue,1) OVER (ORDER BY Month)) AS rev_diff,
    Total_Profit AS Curr_Profit,
    LAG(Total_Profit,1) OVER (ORDER BY Month) AS Prev_Profit,
    Total_Profit - (LAG(Total_Profit,1) OVER (ORDER BY Month)) AS profit_diff,
    Total_orders AS curr_orders,
    LAG(Total_orders,1) OVER (ORDER BY Month) AS Prev_Orders,
    Total_orders - (LAG(Total_orders,1) OVER (ORDER BY Month)) AS Orders_diff
FROM t1

--Preffered Ship Mode
SELECT  
    Ship_Mode,
    COUNT(DISTINCT Order_ID) AS orders,
    SUM(Sales) AS Revenue
FROM Facts_Sales
GROUP BY Ship_Mode
ORDER BY orders DESC

--Factory Revenue Generated
SELECT  
    df.Factory,
    SUM(Sales) AS Revenue
FROM Facts_Sales fs  
JOIN Dim_Factory df ON df.Factory_ID = fs.Factory_ID
GROUP BY df.Factory
ORDER BY SUM(Sales) DESC

--Repeated Customers
SELECT 
    COUNT(DISTINCT CASE WHEN OrderCount > 1 THEN CustomerID END) AS RepeatCustomers,
    COUNT(DISTINCT CustomerID) AS TotalCustomers,
    CAST(COUNT(DISTINCT CASE WHEN OrderCount > 1 THEN CustomerID END) * 100.0 
         / COUNT(DISTINCT CustomerID) AS DECIMAL(5,2)) AS RepeatCustomerPct
FROM (
    SELECT CustomerID, COUNT(DISTINCT Order_ID) AS OrderCount
    FROM Facts_Sales
    GROUP BY CustomerID
) AS CustomerOrders;


--Top Repeated Customers
SELECT TOP 20
    CustomerID,
    COUNT(DISTINCT Order_ID) AS TotalOrders,
    MIN(Order_Date) AS FirstOrderDate,
    MAX(Order_Date) AS LastOrderDate,
    DATEDIFF(DAY, MIN(Order_Date), MAX(Order_Date)) AS CustomerLifespanDays,
    SUM(Sales) AS LifetimeRevenue
FROM Facts_Sales
GROUP BY CustomerID
HAVING COUNT(DISTINCT Order_ID) > 1
ORDER BY TotalOrders DESC, LifetimeRevenue DESC;

--Purchase Patterns
--Time between Orders, are they regular?
WITH CustomerOrderDates AS (
    SELECT 
        CustomerID,
        Order_Date,
        LAG(Order_Date) OVER (PARTITION BY CustomerID ORDER BY Order_Date) AS PrevOrderDate
    FROM (
        SELECT DISTINCT CustomerID, Order_Date FROM Facts_Sales
    ) AS DistinctOrders
)
SELECT 
    CustomerID,
    COUNT(*) AS NumberOfRepeatOrders,
    AVG(DATEDIFF(DAY, PrevOrderDate, Order_Date)) AS AvgDaysBetweenOrders,
    MIN(DATEDIFF(DAY, PrevOrderDate, Order_Date)) AS MinDaysBetweenOrders,
    MAX(DATEDIFF(DAY, PrevOrderDate, Order_Date)) AS MaxDaysBetweenOrders
FROM CustomerOrderDates
WHERE PrevOrderDate IS NOT NULL
GROUP BY CustomerID
HAVING COUNT(*) >= 2 -- at least 3 orders total
ORDER BY AvgDaysBetweenOrders;

--Favourite Division/Product per Customer
WITH CustomerProductRank AS (
    SELECT 
        fs.CustomerID,
        dp.Product_Name,
        dd.Division,
        COUNT(DISTINCT fs.Order_ID) AS TimesOrdered,
        SUM(fs.Units) AS TotalUnits,
        ROW_NUMBER() OVER (PARTITION BY fs.CustomerID ORDER BY COUNT(DISTINCT fs.Order_ID) DESC) AS ProductRank
    FROM Facts_Sales fs
    INNER JOIN Dim_Products dp ON fs.ProductID = dp.ProductID
    INNER JOIN Dim_Division dd ON fs.Division_ID = dd.Division_ID
    GROUP BY fs.CustomerID, dp.Product_Name, dd.Division
)
SELECT 
    CustomerID,
    Product_Name AS FavoriteProduct,
    Division,
    TimesOrdered,
    TotalUnits
FROM CustomerProductRank
WHERE ProductRank = 1 AND TimesOrdered > 1
ORDER BY TimesOrdered DESC;

--Do they buy the same stuff or mix it up?
SELECT 
    CustomerID,
    COUNT(DISTINCT Order_ID) AS TotalOrders,
    COUNT(DISTINCT ProductID) AS UniqueProductsBought,
    CAST(COUNT(DISTINCT ProductID) * 1.0 / COUNT(DISTINCT Order_ID) AS DECIMAL(5,2)) AS ProductsPerOrderRatio
FROM Facts_Sales
GROUP BY CustomerID
HAVING COUNT(DISTINCT Order_ID) > 1
ORDER BY UniqueProductsBought DESC;

--What day or Month do they usually buy?
SELECT 
    CustomerID,
    DATENAME(WEEKDAY, Order_Date) AS DayOfWeek,
    DATENAME(MONTH, Order_Date) AS MonthName,
    COUNT(DISTINCT Order_ID) AS OrderCount
FROM Facts_Sales
WHERE CustomerID IN (
    -- filter to only repeat customers so the result isn't huge
    SELECT CustomerID FROM Facts_Sales 
    GROUP BY CustomerID 
    HAVING COUNT(DISTINCT Order_ID) > 1
)
GROUP BY CustomerID, DATENAME(WEEKDAY, Order_Date), DATENAME(MONTH, Order_Date)
ORDER BY CustomerID, OrderCount DESC;