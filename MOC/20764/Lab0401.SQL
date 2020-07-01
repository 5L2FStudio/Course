USE [tempdb]
GO

/*
建立資料表存放 DDL TRIGGER 的資料
*/
CREATE TABLE [dbo].[ChangeLogin_Log](
    [ActionTime] [datetime] NULL DEFAULT (getdate()),
    [Username] [nvarchar](100) NULL,
    [EventType] [nvarchar](100) NULL,
    [Data] [xml] NULL
) 
GO


/*
建立 DDL TRIGGER for Server
相關事件可參考 https://docs.microsoft.com/zh-tw/sql/relational-databases/triggers/ddl-events?view=sql-server-ver15
*/
CREATE TRIGGER [ChangeLogin] ON ALL SERVER 
AFTER CREATE_LOGIN,ALTER_LOGIN,DROP_LOGIN
AS
    DECLARE @data xml = eventdata();
    BEGIN 
        INSERT INTO [tempdb]..ChangeLogin_Log(Username,EventType,Data )
        VALUES
            ( CURRENT_USER,
              @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'),
              @data )
    END
GO

/*
建立 LOGON TRIGGER for Server
*/
CREATE TRIGGER [USER_LOGON] ON ALL SERVER 
FOR LOGON  
AS  
BEGIN  
    DECLARE @data xml = eventdata();
    BEGIN 
		-- ORIGINAL_LOGIN()
        INSERT INTO [tempdb]..ChangeLogin_Log(Username,EventType,Data )
        VALUES
            ( CURRENT_USER,
              @data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'),
              @data )
		-- ROLLBACK;  
	END
END;

-- 刪除
DROP TRIGGER [ChangeLogin] ON ALL SERVER 
DROP TRIGGER [USER_LOGON] ON ALL SERVER 
GO


-- 參考網址 https://dotblogs.com.tw/jamesfu/2015/04/25/auditloginchange
