-- Skye Liu
-- Data Management
-- SQL Assignment 1

USE AdventureWorks2014;

-- Problem 1, Part A 
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
ORDER BY JobTitle


-- Problem 1, Part B

SELECT DISTINCT JobTitle AS ManagerialTitle
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' 
	OR JobTitle LIKE '%Supervisor%'
	OR JobTitle LIKE 'Chief%'
	OR JobTitle LIKE '%Vice President%'
ORDER BY JobTitle

-- ¡¾Error¡¿check the returned data!! as it might have unexpected results
-- ¡¾Question¡¿any ways to make the codes more efficient??


-- Problem 1, Part C

SELECT COUNT(*) AS Managers
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' 
	OR JobTitle LIKE '%Supervisor%'
	OR JobTitle LIKE 'Chief%'
	OR JobTitle LIKE '%Vice President%'

/*¡¾Error¡¿
SELECT COUNT(*) AS Managers
FROM HumanResources.Employee
WHERE JobTitle = ManagerialTitle */
-- ¡¾Question¡¿Can't I manipulate the column I just created? because it wasn't stored?


-- Problem 1, Part D

SELECT BusinessEntityID AS EmployeeID, 
		JobTitle, 
		BirthDate
FROM HumanResources.Employee
WHERE DATEDIFF(year, BirthDate, GETDATE()) >= 60
ORDER BY BirthDate DESC


-- Problem 1, Part E

SELECT BusinessEntityID AS EmployeeID, 
		JobTitle, 
		BirthDate, 
		HireDate, 
		CAST(GETDATE() 
	        - CAST(HireDate as datetime)
			as int)/365 AS EmploymentYears
FROM HumanResources.Employee
WHERE DATEDIFF(year, BirthDate, GETDATE()) >= 60
		AND CAST(GETDATE() 
	        - CAST(HireDate as datetime)
			as int)/365 >= 7
ORDER BY HireDate ASC

-- ¡¾Error¡¿I can't use the variable I just created? I can only repreat??
-- ¡¾Question¡¿Do I still need to show Birthday? It seems useless here. 
-- ¡¾Question¡¿Is there a way to manipulate the data set I just retrieved without repeating codes? 
-- ¡¾Question¡¿the problem asks for full years employment, 
--  so I can't simply use datediff(year, ...) as it doesn't consider month difference right? 


-- Problem 2, Part A

SELECT Name, ListPrice, SafetyStockLevel
FROM Production.Product
WHERE FinishedGoodsFlag = 1
		AND SellEndDate IS NULL
ORDER BY SafetyStockLevel ASC, Name ASC

-- ¡¾Error¡¿Check for null!!!!


-- Problem 2, Part B

SELECT Name, Color
FROM Production.Product
WHERE Name LIKE '%yellow%' 
		AND (Color <> 'yellow'
		OR Color is NULL)
ORDER BY Name

-- ¡¾Error¡¿Check for null!!!!
-- ¡¾Question¡¿For string comparison, not equal to is both "<>" and "!=", or only "<>" ???


-- Problem 2, Part C

SELECT Name, SellStartDate
FROM Production.Product
WHERE SellStartDate > '2013-01-01'
	AND SellStartDate < '2013-05-31'
ORDER BY Name

-- ¡¾Error¡¿use '' to include date info
-- ¡¾Question¡¿what's the cast result of date?


-- Problem 2, Part D

SELECT Name, 
		SellStartDate, 
		DATEPART(weekday, SellStartDate) AS DayoftheWeek
FROM Production.Product
WHERE DATEPART(weekday, SellStartDate) >= 4
ORDER BY SellStartDate ASC, Name ASC

/*¡¾Error¡¿
1) weekday in DATEPART is expressed as numbers instead of texts. 
2) Sunday is the 1st day of the week. */
