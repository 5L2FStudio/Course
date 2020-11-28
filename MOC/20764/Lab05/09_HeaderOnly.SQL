-- 取得完整備份檔、差異備份和交易紀錄備份檔內的備份資訊
RESTORE HEADERONLY FROM DISK = 'E:\Backup\Source_Full.BAK'
RESTORE HEADERONLY FROM DISK = 'E:\Backup\Source_DIFF.BAK'
RESTORE HEADERONLY FROM DISK = 'E:\Backup\Source_Log.BAK'
GO
