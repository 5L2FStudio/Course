USE [Source]
GO

-- 亂數刪除 10 筆資料 (600~800 之間 )
DECLARE @PTR INT
SET @PTR = 0
WHILE @PTR < 10
BEGIN
  DELETE FROM [TestTable] WHERE [Field1] = ROUND( RAND()*200,0 ) + 600
  SET @PTR += 1
END 

SELECT COUNT(*) FROM [TestTable]
GO

-- 第一個差異備份
BACKUP DATABASE [Source] TO DISK = 'E:\Backup\Source_Diff.BAK' WITH INIT, DIFFERENTIAL
GO
