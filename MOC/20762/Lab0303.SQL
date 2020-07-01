create database CompressDB ;


-- 變更復原模式為簡單
ALTER DATABASE [CompressDB] SET RECOVERY SIMPLE;
GO


USE [CompressDB]
GO
 
-- 建立資料表
CREATE TABLE [BigTable]
(
    A1    INT,
    A2    NVARCHAR(10),
    A3    VARCHAR(10),
    A4    NCHAR(200),
)
GO
 
DECLARE @I INT;
DECLARE @J INT;
DECLARE @K INT;
 
 
SET @J = 0;
 
-- 產生一千萬筆的資料，為了避免交易記錄檔過大，每一萬筆資料放在一個 Transaction 內
SET NOCOUNT ON;
WHILE @J < 1000
BEGIN
    SET @I = 0;
    BEGIN TRAN
    WHILE @I < 10000 
    BEGIN
        SET @K = @J*10000+@I ;
        INSERT INTO [BigTable] ( A1,A2,A3,A4 ) VALUES ( @K, RIGHT('0000000000'+LTRIM(STR(@K)),10), RIGHT('0000000000'+LTRIM(STR(@K)),10), NEWID())
        SET @I += 1; 
    END    
    COMMIT
    SET @J += 1; 
END
GO

--
-- 估算壓縮效益
--
EXEC sys.sp_estimate_data_compression_savings  'dbo','BigTable',NULL,NULL,ROW;
exec sys.sp_estimate_data_compression_savings  'dbo','BigTable',NULL,NULL,PAGE;

--
-- 查看壓縮前資料表大小
--
select 
	OBJECT_NAME(object_id) tablename,page_count, page_count*8/1024 [size(mb)]
	from sys.dm_db_index_physical_stats( DB_ID(),OBJECT_ID('BigTable'),null,null,null )
GO

--
-- 設定壓縮模式為 PAGE
--
ALTER TABLE [dbo].[BigTable] REBUILD PARTITION = ALL
WITH ( DATA_COMPRESSION = PAGE )


--
-- 查看壓縮後資料表大小
--
select 
	OBJECT_NAME(object_id) tablename,page_count, page_count*8/1024 [size(mb)]
	from sys.dm_db_index_physical_stats( DB_ID(),OBJECT_ID('BigTable'),null,null,null )
GO
