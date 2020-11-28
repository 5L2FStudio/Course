SE [Source]
GO

SET NOCOUNT ON
GO

-- 亂數刪除 10 筆資料 ( 0~200 之間 )
DECLARE @PTR INT
SET @PTR = 0
WHILE @PTR < 10
BEGIN
  DELETE FROM [TestTable] WHERE [Field1] = ROUND( RAND()*200,0 )
  SET @PTR += 1
END 

SELECT COUNT(*) FROM [TestTable]
GO

-- 第一個交易紀錄備份檔案
BACKUP LOG [Source] TO DISK = 'E:\Backup\Source_Log.BAK' WITH INIT
GO

-- 亂數刪除 10 筆資料 (200~400 之間 )
DECLARE @PTR INT
SET @PTR = 0
WHILE @PTR < 10
BEGIN
  DELETE FROM [TestTable] WHERE [Field1] = ROUND( RAND()*200,0 ) + 200
  SET @PTR += 1
END 

SELECT COUNT(*) FROM [TestTable]
GO

-- 第二個交易紀錄備份，不能加入 INIT 
BACKUP LOG [Source] TO DISK = 'E:\Backup\Source_Log.BAK' 
GO

-- 亂數刪除 10 筆資料 (400~600 之間 )
DECLARE @PTR INT
SET @PTR = 0
WHILE @PTR < 10
BEGIN
  DELETE FROM [TestTable] WHERE [Field1] = ROUND( RAND()*200,0 ) + 400
  SET @PTR += 1
END 

SELECT COUNT(*) FROM [TestTable]
GO

-- 第三個交易紀錄備份，不能加入 INIT 
BACKUP LOG [Source] TO DISK = 'E:\Backup\Source_Log.BAK' 
GO
