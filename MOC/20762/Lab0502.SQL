SELECT TOP 10 * FROM BigTable

--1 確定 Index
SELECT object_name(i.object_id) tablename,i.* 
FROM sys.indexes i
JOIN sys.tables t ON i.object_id=t.object_id
GO

--2. 查看執行計畫
DECLARE @KEY INT = CAST(RAND() * 1000000 AS int)
SET STATISTICS IO,TIME ON
SELECT * FROM BigTable WHERE A1 = @KEY
SET STATISTICS IO,TIME OFF

--(1 個資料列受到影響)
--資料表 'BigTable'。掃描計數 5，邏輯讀取 666675，實體讀取 0，頁面伺服器讀取 0，讀取前讀取 0，頁面伺服器讀取前讀取 0，LOB 邏輯讀取 0，LOB 實體讀取 0，LOB 頁面伺服器讀取 0，LOB 讀取前讀取 0，LOB 頁面伺服器讀取前讀取 0。

-- SQL Server 執行次數: 
--，CPU 時間 = 1171 ms，經過時間 = 311 ms。


-- 建立 Cluster Index 並測試相關數據
CREATE CLUSTERED INDEX IX_BigTable ON dbo.BigTable(	A1) 
GO

SELECT object_name(i.object_id) tablename,i.* 
FROM sys.indexes i
JOIN sys.tables t ON i.object_id=t.object_id
GO

DECLARE @KEY INT = CAST(RAND() * 1000000 AS int)
SET STATISTICS IO,TIME ON
SELECT * FROM BigTable WHERE A1 = @KEY
SET STATISTICS IO,TIME OFF

--SQL Server 剖析與編譯時間: 
--   CPU 時間 = 0 ms，經過時間 = 0 ms。

--(1 個資料列受到影響)
--資料表 'BigTable'。掃描計數 1，邏輯讀取 4     

-- SQL Server 執行次數: 
--，CPU 時間 = 0 ms，經過時間 = 0 ms。

CREATE NONCLUSTERED INDEX IX_BigTable_A2 ON dbo.BigTable(A2) 
GO

DECLARE @KEY NVARCHAR(10);
SET @KEY = RIGHT('0000000000' + CAST( CAST(RAND() * 1000000 AS INT ) AS NVARCHAR),10)
PRINT @KEY
SELECT * FROM BigTable WHERE A2 = @KEY

SET @KEY = RIGHT('0000000000' + CAST( CAST(RAND() * 1000000 AS INT ) AS NVARCHAR),10)
SELECT A2 FROM BigTable WHERE A2 = @KEY


SET @KEY = RIGHT('0000000000' + CAST( CAST(RAND() * 1000000 AS INT ) AS NVARCHAR),10)
SELECT A1 FROM BigTable WHERE A2 = @KEY
