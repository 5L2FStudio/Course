-- >> NOTE: 該範例必須在 SSMS 下使用 SQLCMD 模式執行. << --
:on error exit

:setvar MasterKeyPassword        "P@ssw0rd123"
:setvar CertificateName          "LabCertificate"
:setvar CertificateSubject       "LabCertificate"
:setvar EncryptionDatabase       "DEMO"

 
-- 1. 建立 Master Key
USE [master]
GO

-- 檢查 MASTER KEY 是否建立
SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##'
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$(MasterKeyPassword)';
--GO

-- 檢查憑證是否建立
SELECT * FROM sys.certificates
 
-- 2. 建立 Server 憑證
CREATE CERTIFICATE  $(CertificateName) 
    WITH SUBJECT = '$(CertificateSubject)',     EXPIRY_DATE = '12/30/2100'
GO
 
-- 3. 在欲加密的資料庫下建立資料庫加密憑證
USE [$(EncryptionDatabase)]
GO
CREATE DATABASE ENCRYPTION KEY
    WITH ALGORITHM = AES_128 ENCRYPTION BY SERVER CERTIFICATE $(CertificateName)
GO
 
-- 4. 設定資料庫加密
ALTER DATABASE $(EncryptionDatabase) 
    SET ENCRYPTION ON
GO
