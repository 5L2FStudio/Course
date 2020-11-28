USE [Source]
GO

-- 亂數刪除 10 筆資料 (800~1000 之間 )
DECLARE @PTR INT
SET @PTR = 0
WHILE @PTR < 10
BEGIN
  DELETE FROM [TestTable] WHERE [Field1] = ROUND( RAND()*200,0 ) + 800
  SET @PTR += 1
END 

SELECT COUNT(*) FROM [TestTable]
GO

-- 第四個交易紀錄備份，不能加入 INIT 
BACKUP LOG [Source] TO DISK = 'E:\Backup\Source_Log.BAK' 
GO
