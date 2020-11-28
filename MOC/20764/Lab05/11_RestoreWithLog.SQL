-- 還原完整備份 ( 加入 NORECOVERY )
RESTORE DATABASE [Target] FROM  DISK = 'E:\Backup\Source_Full.BAK' WITH NORECOVERY, 
  MOVE 'Source'     TO 'E:\DB\Target.mdf',  
  MOVE 'Source_log' TO 'E:\DB\Target.ldf'
GO

-- 檢查資料庫的狀態
SELECT name,state_desc FROM sys.databases where name like 'Target%'
GO

-- 還原交易紀錄
RESTORE LOG [Target] FROM  DISK = 'E:\Backup\Source_Log.BAK' WITH  FILE = 1,  NORECOVERY
GO
RESTORE LOG [Target] FROM  DISK = 'E:\Backup\Source_Log.BAK' WITH  FILE = 2,  NORECOVERY
GO
RESTORE LOG [Target] FROM  DISK = 'E:\Backup\Source_Log.BAK' WITH  FILE = 3,  NORECOVERY
GO
RESTORE LOG [Target] FROM  DISK = 'E:\Backup\Source_Log.BAK' WITH  FILE = 4,  RECOVERY
GO
