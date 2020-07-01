-- 先開啟 Configuration Manager 設定 FileStream
EXEC sp_configure

EXEC sp_configure 'filestream access level', 2

RECONFIGURE

EXEC sp_configure 'filestream access level'


-- 建立資料庫時加入 FileStream
--
-- 錯誤的示範
CREATE TABLE dbo.T1
	(
	F1 int NOT NULL PRIMARY KEY, 
	F2 varbinary(MAX) FILESTREAM NULL 
	)  
GO

-- 正確的案例
CREATE TABLE dbo.Table_1
	(
	F0 uniqueidentifier ROWGUIDCOL NOT NULL UNIQUE,
	F1 int NOT NULL PRIMARY KEY, 
	F2 varbinary(MAX) FILESTREAM NULL 
	)  
GO
	
DECLARE @DATA VARCHAR(MAX)
SET @DATA =
'兄弟10：4大勝悍將。（記者廖耀東攝）

〔記者吳清正／台中報導〕中信兄弟張志豪、詹子賢、蘇緯達和高宇杰，砲轟富邦悍將先發投手索沙，自辦熱身賽10:4大勝。

張志豪1局下率先轟出2分砲，2出局後詹子賢打出陽春彈，取得3:0領先。第3局岳東華、張志豪和林智勝連續安打再下一城，蘇緯達再轟出2分砲，第4局首名打者高宇杰也開轟，將比數拉開到比7:2，悍將2分也是由高國麟和蔣智賢全壘打所攻下。

〔記者吳清正／台中報導〕原本不常被全壘打的富邦悍將索沙，今天在自辦熱身賽對中信兄弟先發卻被打到驚呆了，投4局就被轟出4支全壘打，被轟頻率是去年球季的17倍。

索沙去年季中轉投韓職之前，先發12場投86.2局被擊出5支全壘打，平均17.3局才被1轟，今天卻好像全壘打大賽的餵球投手。

兄弟張志豪1局下率先轟出2分砲，詹子賢再補上陽春彈，第3局蘇緯達打出2分全壘打，第4局首名打者高宇杰也開轟，取得7:2領先，悍將的2分也是靠高國麟和蔣智賢全壘打攻下。'

INSERT INTO Table_1( F0, F1 , F2 ) VALUES ( newid (), 1 , CAST(@DATA AS VARBINARY(max)))
GO


SELECT * FROM Table_1

-- 到 FileStream 目錄下開啟檔案內容

-- 建立對照組
CREATE TABLE dbo.Table_2
	(
	F0 uniqueidentifier ROWGUIDCOL NOT NULL UNIQUE,
	F1 int NOT NULL PRIMARY KEY, 
	F2 varbinary(MAX) NULL 
	)  
GO


DECLARE @DATA VARCHAR(MAX)
SET @DATA =
'兄弟10：4大勝悍將。（記者廖耀東攝）
〔記者吳清正／台中報導〕中信兄弟張志豪、詹子賢、蘇緯達和高宇杰，砲轟富邦悍將先發投手索沙，自辦熱身賽10:4大勝。
張志豪1局下率先轟出2分砲，2出局後詹子賢打出陽春彈，取得3:0領先。第3局岳東華、張志豪和林智勝連續安打再下一城，蘇緯達再轟出2分砲，第4局首名打者高宇杰也開轟，將比數拉開到比7:2，悍將2分也是由高國麟和蔣智賢全壘打所攻下。
〔記者吳清正／台中報導〕原本不常被全壘打的富邦悍將索沙，今天在自辦熱身賽對中信兄弟先發卻被打到驚呆了，投4局就被轟出4支全壘打，被轟頻率是去年球季的17倍。
索沙去年季中轉投韓職之前，先發12場投86.2局被擊出5支全壘打，平均17.3局才被1轟，今天卻好像全壘打大賽的餵球投手。
兄弟張志豪1局下率先轟出2分砲，詹子賢再補上陽春彈，第3局蘇緯達打出2分全壘打，第4局首名打者高宇杰也開轟，取得7:2領先，悍將的2分也是靠高國麟和蔣智賢全壘打攻下。'

INSERT INTO Table_2( F0, F1 , F2 ) VALUES ( newid (), 1 , CAST(@DATA AS VARBINARY(max)))
GO


select OBJECT_NAME(object_id),* from sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'DETAILED') 
where OBJECT_NAME(object_id) LIKE 'Table%' 
GO
