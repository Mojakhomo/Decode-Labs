CREATE DATABASE DataAnalyticsProject3;

USE DataAnalyticsProject3;

SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

-- Query 1.1: View Sample Data
-- Let's first understand what our data looks like
SELECT TOP 10 *
FROM [Dataset for Data Analytics];


-- Query 1.2: Check Total Records
-- How many orders do we have?
SELECT COUNT(*) AS TotalOrders
FROM [Dataset for Data Analytics];


--Query 1.3: Understand Data Types
-- Check column structures
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Dataset for Data Analytics';


--Query 1.4: Check for NULLs and Data Quality
-- Check for missing values in 'key' columns
SELECT 
    COUNT(*) AS TotalRows,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS MissingProduct,
    SUM(CASE WHEN TotalPrice IS NULL THEN 1 ELSE 0 END) AS MissingTotalPrice,
    SUM(CASE WHEN OrderStatus IS NULL THEN 1 ELSE 0 END) AS MissingOrderStatus
FROM [Dataset for Data Analytics];


-- Query 1.5: Data Distribution Overview
-- What's the distribution of order statuses?
SELECT 
    OrderStatus,
    COUNT(*) AS NumberOfOrders,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS Percentage
FROM [Dataset for Data Analytics]
GROUP BY OrderStatus
ORDER BY NumberOfOrders DESC;


-- 3. PRODUCT REVENUE (TOP 10)
SELECT TOP 10
    Product,
    SUM(TotalPrice) AS TotalRevenue,
    COUNT(*) AS Orders,
    AVG(TotalPrice) AS AvgValue
FROM [Dataset for Data Analytics]
WHERE OrderStatus IN ('Shipped', 'Delivered')
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 4. MONTHLY REVENUE 2024
SELECT 
    MONTH(Date) AS Month,
    SUM(TotalPrice) AS Revenue
FROM [Dataset for Data Analytics]
WHERE YEAR(Date) = 2024 AND OrderStatus IN ('Shipped', 'Delivered')
GROUP BY MONTH(Date)
ORDER BY Month;


-- 5. TOP 10 CUSTOMERS
SELECT TOP 10
    CustomerID,
    SUM(TotalPrice) AS TotalSpent,
    COUNT(*) AS Orders
FROM [Dataset for Data Analytics]
WHERE OrderStatus IN ('Shipped', 'Delivered')
GROUP BY CustomerID
ORDER BY TotalSpent DESC;


-- Payment Method Success Rate..
SELECT 
    PaymentMethod,
    COUNT(*) AS Total,
    SUM(CASE WHEN OrderStatus IN ('Shipped', 'Delivered') THEN 1 ELSE 0 END) AS Successful,
    CAST(SUM(CASE WHEN OrderStatus IN ('Shipped', 'Delivered') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS SuccessRate
FROM [Dataset for Data Analytics]
GROUP BY PaymentMethod
ORDER BY SuccessRate DESC;

-- 8. REFERRAL SOURCE PERFORMANCE
SELECT 
    ReferralSource,
    COUNT(*) AS Orders,
    SUM(TotalPrice) AS Revenue,
    AVG(TotalPrice) AS AvgValue
FROM [Dataset for Data Analytics]
WHERE OrderStatus IN ('Shipped', 'Delivered') AND ReferralSource != ''
GROUP BY ReferralSource
ORDER BY Revenue DESC;


-- 9. RETURN RATE BY PRODUCT
SELECT 
    Product,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN OrderStatus = 'Returned' THEN 1 ELSE 0 END) AS Returns,
    CAST(SUM(CASE WHEN OrderStatus = 'Returned' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS ReturnRate
FROM [Dataset for Data Analytics]
GROUP BY Product
HAVING COUNT(*) > 5
ORDER BY ReturnRate DESC;

-- 10. YEAR-OVER-YEAR SUMMARY
SELECT 
    YEAR(Date) AS Year,
    COUNT(*) AS Orders,
    SUM(TotalPrice) AS Revenue,
    AVG(TotalPrice) AS AvgOrderValue
FROM [Dataset for Data Analytics]
WHERE OrderStatus IN ('Shipped', 'Delivered')
GROUP BY YEAR(Date)
ORDER BY Year;