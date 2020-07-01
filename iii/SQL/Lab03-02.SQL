-- CTE
WITH t (customerid,lastorderdate) AS 
(SELECT customerid,max(orderdate) FROM sales.SalesOrderHeader
 WHERE customerid=27604 
 GROUP BY customerid)
SELECT * from sales.salesorderheader soh
INNER JOIN t ON soh.customerid=t.customerid AND soh.orderdate=t.lastorderdate
GO

--Temp table
CREATE TABLE #temptable (customerid [int] NOT NULL PRIMARY KEY,lastorderdate [datetime] NULL);
INSERT INTO #temptable
SELECT customerid,max(orderdate) lastorderdate FROM sales.SalesOrderHeader
 WHERE customerid=27604
 GROUP BY customerid;
SELECT * from sales.salesorderheader soh
INNER JOIN #temptable t ON soh.customerid=t.customerid AND soh.orderdate=t.lastorderdate
drop table #temptable
GO

--Table variable
DECLARE @tablevariable TABLE (customerid [int] NOT NULL PRIMARY KEY,lastorderdate [datetime] NULL);
INSERT INTO @tablevariable
SELECT customerid,max(orderdate) lastorderdate FROM sales.SalesOrderHeader
 WHERE customerid=27604
 GROUP BY customerid;
SELECT * from sales.salesorderheader soh
INNER JOIN @tablevariable t ON soh.customerid=t.customerid AND soh.orderdate=t.lastorderdate
GO
