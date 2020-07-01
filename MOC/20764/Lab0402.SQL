CREATE DATABASE [TEST]
GO

USE [TEST]
GO

/*
建立 Temporal 測試資料表
1. 要有 PK
2. 時間是 DATETIME2
3. 可選擇是否要 HIDDEN
4. HISTORY_TABLE 不指定系統會自動產生
*/
CREATE TABLE DemoTemporal_History
( 
	ID	INT NOT NULL,
	Product	NVARCHAR(50),
	Price	NUMERIC(10,2),
	SysStartDateTime DATETIME2 NOT NULL,
	SysDueDateTime	 DATETIME2 NOT NULL,
);

CREATE TABLE DemoTemporal
( 
	ID	INT	PRIMARY KEY,
	Product	NVARCHAR(50),
	Price	NUMERIC(10,2),
	SysStartDateTime DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
	SysDueDateTime	 DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
    PERIOD FOR SYSTEM_TIME (SysStartDateTime,SysDueDateTime)  
) WITH(SYSTEM_VERSIONING = ON (HISTORY_TABLE=dbo.DemoTemporal_History) );
GO

-------------------------------------------------------------------------------
/*
異動資料觀察變化
*/
INSERT INTO [dbo].[DemoTemporal] (ID,Product,Price)
 VALUES ( 1 , 'A', 10 ),( 2 , 'B', 20 )
GO

SELECT * FROM DemoTemporal
GO

SELECT * FROM DemoTemporal_History
GO

UPDATE DemoTemporal SET Price = 15 WHERE ID = 1
DELETE DemoTemporal WHERE ID = 2
GO

SELECT * FROM DemoTemporal
GO

SELECT * FROM DemoTemporal_History
GO
--------------------------------------------------------------------------------
/*
按照上課時間調整
*/
WAITFOR TIME '22:10';

UPDATE [dbo].DemoTemporal 
	SET Price = Price + 5
	WHERE ID = 1

WAITFOR DELAY '00:02'

UPDATE [dbo].DemoTemporal 
	SET Price = Price + 5
	WHERE ID > 1

WAITFOR DELAY '00:02'

DELETE [dbo].DemoTemporal 
	WHERE ID = 1

WAITFOR DELAY '00:02'

DELETE [dbo].DemoTemporal 
	WHERE ID > 1

SELECT [ID]
      ,[Product]
      ,[Price]
      ,switchoffset([SysStartDateTime],'+08:00') [SysStartDateTime]
      ,switchoffset([SysDueDateTime]  ,'+08:00') [SysDueDateTime]
  FROM DemoTemporal_History
GO



SELECT * 
	FROM [dbo].DemoTemporal 
	FOR SYSTEM_TIME AS OF '2015-09-20 14:15:00' 
GO

DECLARE @PointInTime DATETIME2
SET @PointInTime = DATEADD( hh, -8, '2015-09-20 22:15:00' )
SELECT * 
	FROM [dbo].DemoTemporal 
	FOR SYSTEM_TIME AS OF @PointInTime
GO

DECLARE @PointInTimeStart DATETIME2, @PointInTimeEnd DATETIME2
SET @PointInTimeStart = DATEADD( hh, -8, '2015-09-20 22:10:00' )
SET @PointInTimeEnd   = DATEADD( hh, -8, '2015-09-20 22:15:00' )
SELECT * 
	FROM [dbo].DemoTemporal 
	FOR SYSTEM_TIME FROM @PointInTimeStart TO @PointInTimeEnd

SELECT * 
	FROM [dbo].DemoTemporal 
	FOR SYSTEM_TIME CONTAINED IN( @PointInTimeStart,@PointInTimeEnd)
GO

-- 參考資料 https://dotblogs.com.tw/jamesfu/2015/09/21/temporal
