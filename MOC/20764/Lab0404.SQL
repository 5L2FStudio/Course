-- 備份憑證，並指定憑證加密的 Private Key 和 密碼
BACKUP CERTIFICATE LabCertificate
    TO FILE = 'D:\TDE\SQLServerCertificateFile.CER'
    WITH PRIVATE KEY (FILE='D:\TDE\SQLServerCertificateFile.PVK',  ENCRYPTION BY PASSWORD='P@ssw0rd987')
GO


-- 在新電腦上也同樣先建立一個 Master Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssw0rd123';
GO
 
-- 從備份檔案中還原憑證
CREATE CERTIFICATE TaichungCertificate
    FROM FILE='D:\TDE\Temp\SQLServerCertificateFile.CER'
    WITH PRIVATE KEY (FILE = 'D:\TDE\Temp\SQLServerCertificateFile.PVK',  
    DECRYPTION BY PASSWORD='P@ssw0rd987')
GO
