USE [Source]
GO

-- 關閉資料筆數的訊息
SET NOCOUNT ON

-- 建立範例資料表
CREATE TABLE [TestTable] ( [Field1] int )
GO

-- 建立 1000 筆測試資料
DECLARE @PTR INT
SET @PTR = 0
WHILE @PTR < 1000
BEGIN
  INSERT INTO [TestTable] VALUES ( @PTR )
  SET @PTR += 1
END 
