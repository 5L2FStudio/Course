-- 建立範例資料庫
CREATE DATABASE [Source]
 ON  PRIMARY 
( NAME = 'Source'    , FILENAME = 'E:\DB\Source.MDF' , SIZE = 40MB , FILEGROWTH = 10MB )
 LOG ON 
( NAME = 'Source_log', FILENAME = 'E:\DB\Source.LDF' , SIZE = 10MB , FILEGROWTH = 10MB )
GO

-- 設定 Recovery Mode 為簡單模式
ALTER DATABASE [Source] SET Recovery Simple
Go

-- 設定 Recovery Mode 為完整模式
ALTER DATABASE [Source] SET Recovery Full
Go
