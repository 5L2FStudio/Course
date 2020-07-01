--
-- 建立時序資料表 ( 有隱藏欄位 )
--
CREATE TABLE DemoTemporal
( 
	ID	INT	PRIMARY KEY,
	Product	NVARCHAR(50),
	Price	NUMERIC(10,2),
	SysStartDateTime DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
	SysDueDateTime	 DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
    PERIOD FOR SYSTEM_TIME (SysStartDateTime,SysDueDateTime)  
) WITH(SYSTEM_VERSIONING = ON);


SELECT * FROM DemoTemporal
GO

SELECT * FROM sys.tables
GO

--
-- 展示自訂歷史資料表
--
CREATE SCHEMA history
GO

CREATE TABLE dbo.DemoTemporal2
( 
	ID	INT	PRIMARY KEY,
	Product	NVARCHAR(50),
	Price	NUMERIC(10,2),
	SysStartDateTime DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
	SysDueDateTime	 DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
    PERIOD FOR SYSTEM_TIME (SysStartDateTime,SysDueDateTime)  
) 
GO

CREATE TABLE history.DemoTemporal2
( 
	ID	INT	NOT NULL,
	Product	NVARCHAR(50),
	Price	NUMERIC(10,2),
	SysStartDateTime DATETIME2 NOT NULL,
	SysDueDateTime	 DATETIME2 NOT NULL,
) 
GO

ALTER TABLE DemoTemporal2 
	SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE=history.DemoTemporal2))
GO

-- 
-- 加入範例資料展示時序表功能
--
INSERT INTO [dbo].[DemoTemporal2] (ID,Product,Price)
 VALUES ( 1 , 'A', 10 ),( 2 , 'B', 20 )
GO

SELECT * FROM DemoTemporal2;
GO

SELECT * FROM history.DemoTemporal2;
GO

--
-- 異動資料呈現時序表功能
--
UPDATE DemoTemporal2 SET Price = 15 WHERE ID = 1
DELETE DemoTemporal2 WHERE ID = 2
GO

SELECT * FROM DemoTemporal2
GO

SELECT * FROM [history].[DemoTemporal2]
GO

GO

--
-- 轉換時間時區
--
SELECT [ID]
      ,[Product]
      ,[Price]
      ,switchoffset([SysStartDateTime],'+08:00') [SysStartDateTime]
      ,switchoffset([SysDueDateTime]  ,'+08:00') [SysDueDateTime]
  FROM [history].[DemoTemporal2];
  
--  
-- SYSTEM_TIME AS OF 展示
--
SELECT * 
	FROM [dbo].[DemoTemporal2] 
	FOR SYSTEM_TIME AS OF '2015-09-20 14:15:00' 
GO

--  
-- SYSTEM_TIME AS OF 展示
--
DECLARE @PointInTime DATETIME2
SET @PointInTime = DATEADD( hh, -8, '2015-09-20 22:15:00' )
SELECT * 
	FROM [dbo].[DemoTemporal2] 
	FOR SYSTEM_TIME AS OF @PointInTime
GO

-- AS OF <date_time>
-- FROM <start_date_time> TO <end_date_time>
-- BETWEEN <start_date_time> AND <end_date_time>
-- CONTAINED IN (<start_date_time> , <end_date_time>)
-- ALL

--
-- 變更時序表的欄位
--
BEGIN TRAN
    ALTER TABLE [dbo].[DemoTemporal2] SET (SYSTEM_VERSIONING = OFF);
    ALTER TABLE [DemoTemporal2] ADD Qty INT ;
    ALTER TABLE [history].[DemoTemporal2] ADD Qty INT ;
    ALTER TABLE [dbo].[DemoTemporal2]
    SET
         (
            SYSTEM_VERSIONING = ON
           ( HISTORY_TABLE = [history].[DemoTemporal2])
         );
COMMIT ;
