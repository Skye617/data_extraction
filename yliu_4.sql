-- Skye Liu
-- Data Management
-- SQL Assignment 4

USE ADW;

-- Problem 1
SELECT dr.ResellerName, 
		dg.EnglishCountryRegionName, 
		dpc.EnglishProductCategoryName,
		SUM(frs.SalesAmount) AS TotalSalesAmount, 
		dc.CurrencyName 
FROM FactResellerSales frs
INNER JOIN DimReseller dr
ON frs.ResellerKey = dr.ResellerKey
INNER JOIN DimGeography dg
ON dg.GeographyKey = dr.GeographyKey
INNER JOIN DimProduct dp
ON dp.ProductKey = frs.ProductKey
INNER JOIN DimProductSubcategory dps
ON dps.ProductSubcategoryKey = dp.ProductSubcategoryKey
INNER JOIN DimProductCategory dpc
ON dpc.ProductCategoryKey = dps.ProductCategoryKey
INNER JOIN DimCurrency dc
ON frs.CurrencyKey = dc.CurrencyKey
INNER JOIN DimPromotion dpro
ON frs.PromotionKey = dpro.PromotionKey
WHERE dpro.PromotionKey = 13 -- Touring-3000 promotion
GROUP BY dr.ResellerName, 
		dg.EnglishCountryRegionName, 
		dpc.EnglishProductCategoryName,
		dc.CurrencyName 
ORDER BY TotalSalesAmount DESC


-- Problem 2
SELECT dg.City,
		CASE WHEN dg.StateProvinceName IS NOT NULL
			THEN dg.StateProvinceName
			ELSE 'Subtotal'
			END AS 'StateProvinceName', 
		SUM(frs.SalesAmount) AS TotalSalesAmount 
FROM FactResellerSales frs
INNER JOIN DimReseller dr
ON frs.ResellerKey = dr.ResellerKey
INNER JOIN DimGeography dg
ON dg.GeographyKey = dr.GeographyKey
INNER JOIN DimCurrency dc
ON frs.CurrencyKey = dc.CurrencyKey
WHERE dc.CurrencyAlternateKey = 'EUR'
GROUP BY ROLLUP(dg.City, dg.StateProvinceName)
ORDER BY dg.City 

-- Problem 3
SELECT dc.CurrencyName, 
		ROUND(SUM(frs.SalesAmount),2) AS TotalSalesAmount
FROM FactResellerSales frs
INNER JOIN DimCurrency dc
ON frs.CurrencyKey = dc.CurrencyKey
GROUP BY dc.CurrencyName
ORDER BY TotalSalesAmount DESC

-- Problem 4
SELECT Formed.FiscalYear, 
		Formed.EnglishPromotionName,
		Formed.[2] AS FiscalQ2, 
		Formed.[3] AS FiscalQ3
FROM
	(SELECT dpro.EnglishPromotionName, 
		dd.FiscalYear, 
		dd.FiscalQuarter, 
		SUM(frs.SalesAmount) AS TotalSalesAmount
	FROM FactResellerSales frs
	INNER JOIN DimPromotion dpro
	ON dpro.PromotionKey = frs.PromotionKey
	INNER JOIN DimDate dd
	ON dd.DateKey = frs.OrderDateKey
	WHERE dpro.PromotionKey = 13 
			OR dpro.PromotionKey = 14
	GROUP BY dpro.EnglishPromotionName, 
			dd.FiscalYear, 
			dd.FiscalQuarter) AS Base
PIVOT (
	SUM(TotalSalesAmount)
	FOR FiscalQuarter
	IN ([2],[3])
) AS Formed

-- Problem 5
SELECT Formed.FiscalYear, 
		Formed.EnglishPromotionName,
		CASE WHEN Formed.[2] IS NULL 
				THEN 0
				ELSE Formed.[2]
				END AS FiscalQ2, 
		CASE WHEN Formed.[3] IS NULL 
				THEN 0 
				ELSE Formed.[3]
				END AS FiscalQ3
FROM
	(SELECT dpro.EnglishPromotionName, 
		dd.FiscalYear, 
		dd.FiscalQuarter, 
		SUM(fis.SalesAmount) AS TotalSalesAmount
	FROM FactInternetSales fis
	INNER JOIN DimPromotion dpro
	ON dpro.PromotionKey = fis.PromotionKey
	INNER JOIN DimDate dd
	ON dd.DateKey = fis.OrderDateKey
	WHERE dpro.PromotionKey = 13 
			OR dpro.PromotionKey = 14
	GROUP BY dpro.EnglishPromotionName, 
			dd.FiscalYear, 
			dd.FiscalQuarter) AS Base
PIVOT (
	SUM(TotalSalesAmount)
	FOR FiscalQuarter
	IN ([2],[3])
) AS Formed