-- Skye Liu
-- Data Management
-- SQL Assignment 3

USE AdventureWorks2014;

-- Problem 1
SELECT Name, 
	   CASE WHEN NAME IN (SELECT DISTINCT st.Name AS AwardWinners
						FROM Sales.SalesOrderHeader soh
						INNER JOIN Sales.SalesTerritory st
						ON soh.TerritoryID = st.TerritoryID
						WHERE DATEPART(year, soh.OrderDate) = 2013
						GROUP BY st.Name, 
									DATEPART(month, soh.OrderDate), 
									DATEPART(year, soh.OrderDate)
						HAVING SUM(soh.SubTotal) > 750000)
			 THEN 'No' 
			 ELSE 'Yes' END AS TrainingRequired
FROM Sales.SalesTerritory 
-- ¡¾Reminder¡¿Specify what should be in the code chunck

-- Problem 2, Part A
SELECT country.Name AS Country, 
	   state.Name AS StateProvince,
	   COUNT(header.SalesOrderID) AS NumberOfOrders
FROM Sales.SalesOrderHeader header
INNER JOIN Person.Address addr
ON addr.AddressID = header.ShipToAddressID
INNER JOIN Person.StateProvince state
ON state.StateProvinceID = addr.StateProvinceID
INNER JOIN Person.CountryRegion country
ON state.CountryRegionCode = country.CountryRegionCode
WHERE header.Status = 5
GROUP BY ROLLUP(country.Name, state.Name)
ORDER BY Country, StateProvince

-- Problem 2, Part B
SELECT country.Name AS Country, 
	   state.Name AS StateProvince,
	   COUNT(header.SalesOrderID) AS NumberOfOrders
FROM Sales.SalesOrderHeader header
INNER JOIN Person.Address addr
ON addr.AddressID = header.ShipToAddressID
INNER JOIN Person.StateProvince state
ON state.StateProvinceID = addr.StateProvinceID
INNER JOIN Person.CountryRegion country
ON state.CountryRegionCode = country.CountryRegionCode
WHERE header.Status = 5
GROUP BY ROLLUP (country.Name, state.Name)
HAVING COUNT(header.SalesOrderID) >= 100
ORDER BY Country, StateProvince

-- Problem 3
SELECT c.Name AS Category, 
		product.Name AS Product, 
		SUM(sod.OrderQty) AS NumberOfSoldUnits,
		RANK() OVER(PARTITION BY c.Name 
					ORDER BY SUM(sod.OrderQty) DESC) AS Ranking,
		NTILE(5) OVER(PARTITION BY c.Name 
					  ORDER BY SUM(sod.OrderQty) DESC) AS Quintile
FROM Sales.SalesOrderDetail sod
INNER JOIN Production.Product product
ON sod.ProductID = product.ProductID
INNER JOIN Production.ProductSubcategory subc
ON subc.ProductSubcategoryID = product.ProductSubcategoryID
INNER JOIN Production.ProductCategory c
ON subc.ProductCategoryID = c.ProductCategoryID
GROUP BY c.Name, product.Name