-- 刪除範例資料庫
IF DB_ID('SARGDEMO') IS NOT NULL DROP DATABASE [SARGDEMO];
GO 
 
-- 建立資料庫
CREATE DATABASE [SARGDEMO]
GO
 
-- 變更復原模式為簡單
ALTER DATABASE [SARGDEMO] SET RECOVERY SIMPLE;
GO
 
USE [SARGDEMO]
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
