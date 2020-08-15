-- Step 1: Open a new query window to the tempdb database

USE tempdb;
GO

-- Step 2: Create the dbo.Opportunity table
-- 建立範例資料表
CREATE TABLE dbo.Opportunity
( 
  OpportunityID int NOT NULL,
  Requirements nvarchar(50) NOT NULL,
  ReceivedDate date NOT NULL,
  LikelyClosingDate date NULL,
  SalespersonID int NULL,
  Rating int NOT NULL
);

-- Step 3: Populate the table with 2 rows
-- 填入兩筆資料
INSERT INTO dbo.Opportunity 
  (OpportunityID, Requirements, ReceivedDate, LikelyClosingDate,
   SalespersonID,Rating)
VALUES (1,'n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9),
       (2,'n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 37,2);

-- Step 4: Try to omit a value for OpportunityID. This will
--         fail as a column that is defined as NOT NULL needs a value.
-- 故意塞入資料不給 KEY 值造成異常

INSERT dbo.Opportunity 
  (Requirements, ReceivedDate, 
   LikelyClosingDate, SalespersonID,Rating)
VALUES ('n.d.', SYSDATETIME(), DATEADD(month,1,SYSDATETIME()), 34,9);

-- Step 5: Create a table with a uniqueidentifier data type
-- 測試 Identity , NewID 和 NewSequentialID 的使用時機
CREATE TABLE dbo.TestGuid
(
  id INT NOT NULL IDENTITY(1,1),
  [Guid1] UNIQUEIDENTIFIER NOT NULL,
  [Guid2] UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID()
);

-- Step 6: Add 3 rows using the NEWID() function.				
-- 利用 NEWID() 產生 Guid
INSERT INTO dbo.TestGuid ([Guid1]) 
VALUES (NEWID()),(NEWID()),(NEWID());

-- Step 7: Examine the resulting rows
SELECT * FROM dbo.TestGuid;

-- Step 8: Clean up by dropping the tables

DROP TABLE dbo.Opportunity;
DROP TABLE dbo.TestGuid;
