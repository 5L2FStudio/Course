USE [master]
GO

-- 完整備份資料庫
BACKUP DATABASE [Source] TO DISK = 'E:\Backup\Source_Full.BAK' WITH INIT
GO

-- 檢查備份檔是否 OK
RESTORE VERIFYONLY FROM DISK = 'E:\Backup\Source_Full.BAK'
GO

-- 列出備份檔案內包含哪些資料庫檔案
RESTORE FILELISTONLY FROM DISK = 'E:\Backup\Source_Full.BAK'
GO

-- 列出備份檔的備份資訊
RESTORE HEADERONLY FROM DISK = 'E:\Backup\Source_Full.BAK'
GO
