USE [Source]
GO
-- 完整備份配合 COPY_ONLY 參數
BACKUP DATABASE [Source] TO DISK='E:\Backup\Source_Copy.BAK' WITH INIT, COPY_ONLY
GO
