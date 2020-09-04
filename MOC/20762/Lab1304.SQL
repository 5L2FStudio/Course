-- 啟用CLR功能

sp_configure 'clr enabled', 1
GO
RECONFIGURE
GO

Alter Database DEMO Set TrustWorthy ON;
GO
