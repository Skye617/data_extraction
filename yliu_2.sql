-- Skye Liu
-- Data Management
-- SQL Assignment 2

USE AdventureWorks2014;

-- Problem 1, Part A 
SELECT st.Name AS Territory, 
		CAST(ROUND(SUM(soh.SubTotal), 0) AS int) AS SalesTotal
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
GROUP BY st.Name
ORDER BY SalesTotal DESC

-- Problem 1, Part B
SELECT  st.Name AS Territory,  
		DATEPART(month, soh.OrderDate) AS Month, 
		DATEPART(year, soh.OrderDate) AS Year,
		CAST(ROUND(SUM(soh.SubTotal),0)AS int) AS SalesRevenue
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
WHERE DATEPART(year, soh.OrderDate) = 2013
GROUP BY st.Name, 
			DATEPART(month, soh.OrderDate), 
			DATEPART(year, soh.OrderDate)
ORDER BY Territory, Month

-- Problem 1, Part C
SELECT DISTINCT st.Name AS AwardWinners
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
WHERE DATEPART(year, soh.OrderDate) = 2013
GROUP BY st.Name, 
			DATEPART(month, soh.OrderDate), 
			DATEPART(year, soh.OrderDate)
HAVING SUM(soh.SubTotal) > 750000
ORDER BY AwardWinners

-- Problem 1, Part D
SELECT DISTINCT st.Name AS ToTrain
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID

EXCEPT

SELECT DISTINCT st.Name
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID
WHERE DATEPART(year, soh.OrderDate) = 2013
GROUP BY st.Name, 
			DATEPART(month, soh.OrderDate), 
			DATEPART(year, soh.OrderDate)
HAVING SUM(soh.SubTotal) > 750000
ORDER BY st.Name

-- Problem 2, Part A
SELECT pp.Name, SUM(sod.OrderQty) AS TotalSalesVolumn
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail sod
ON pp.ProductID = sod.ProductID
WHERE pp.FinishedGoodsFlag = 1
GROUP BY pp.Name
HAVING SUM(sod.OrderQty) < 50
ORDER BY TotalSalesVolumn

-- Problem 2, Part B
SELECT DISTINCT pcr.Name, 
		MAX(sstr.TaxRate) AS MaximumTaxRate
FROM Sales.SalesTaxRate sstr
INNER JOIN Person.StateProvince psp
ON sstr.StateProvinceID = psp.StateProvinceID
INNER JOIN Person.CountryRegion pcr
ON psp.CountryRegionCode = pcr.CountryRegionCode
GROUP BY pcr.Name
ORDER BY MaximumTaxRate DESC

-- Problem 2, Part C
SELECT DISTINCT ss.Name AS StoreName, 
		sst.Name AS TerritoryName
FROM Sales.Store ss
INNER JOIN Sales.Customer sc
ON ss.BusinessEntityID = sc.StoreID
INNER JOIN Sales.SalesTerritory sst
ON sst.TerritoryID = sc.TerritoryID
INNER JOIN Sales.SalesOrderHeader ssoh
-- ON ssoh.TerritoryID = sst.TerritoryID
ON ssoh.CustomerID = sc.CustomerID
INNER JOIN Sales.SalesOrderDetail ssod
ON ssoh.SalesOrderID = ssod.SalesOrderID
INNER JOIN Production.Product pp
ON pp.ProductID = ssod.ProductID
WHERE ssoh.ShipDate BETWEEN '2014-02-01' AND '2014-02-05'
		AND pp.Name LIKE '%helmet%'
ORDER BY sst.Name, ss.Name


/* 
¡¾Question¡¿91, why cannot????
¡¾Reminder¡¿Check data to decide join key instead of name. 

SELECT DISTINCT ss.Name AS StoreName, 
				sst.Name AS TerritoryName
FROM Sales.Store ss
INNER JOIN Sales.SalesPerson ssp
ON ss.BusinessEntityID = ssp.BusinessEntityID
INNER JOIN Sales.SalesTerritory sst
ON sst.TerritoryID = ssp.TerritoryID
INNER JOIN Sales.SalesOrderHeader ssoh
ON ssoh.TerritoryID = sst.TerritoryID
WHERE ssoh.ShipDate BETWEEN 2014-02-01 AND 2014-02-05
ORDER BY sst.Name, ss.Name
*/

