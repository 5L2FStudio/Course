CREATE TABLE Items
(
	ID		INT Primary Key,
	Name	NVARCHAR(20)
)

INSERT INTO Items VALUES ( 10 , 'AAA'), ( 20 , 'BBB' )


CREATE TABLE SaleDetails
(
	ID	NVARCHAR(10)	PRIMARY KEY,
	OrderDate	DATE,
	ItemID		INT
)

ALTER TABLE dbo.SaleDetails ADD CONSTRAINT
	FK_SaleDetails_Items FOREIGN KEY ( ItemID ) REFERENCES dbo.Items ( ID ) 
	
GO


-- OK
INSERT INTO SaleDetails( ID,OrderDate,ItemID)
	VALUES ( '200222001', GETDATE(), 10 )

-- ERROR
INSERT INTO SaleDetails( ID,OrderDate,ItemID)
	VALUES ( '200222002', GETDATE(), 30 )


--
-- 手動變更 Items 的 ID 
--
SELECT * FROM Items
SELECT * FROM SaleDetails

BEGIN TRAN
	DECLARE @OLD INT = 10
	DECLARE @NEW INT = 15	
	UPDATE SaleDetails SET ItemID = NULL WHERE ItemID = @OLD ;
	UPDATE Items SET ID = @NEW WHERE ID = @OLD ;
	UPDATE SaleDetails SET ItemID = @NEW WHERE ItemID IS NULL ;
COMMIT

SELECT * FROM Items
SELECT * FROM SaleDetails

--
-- 設定 FK 為 CASCADE
--
ALTER TABLE dbo.SaleDetails
	DROP CONSTRAINT FK_SaleDetails_Items

ALTER TABLE dbo.SaleDetails ADD CONSTRAINT
	FK_SaleDetails_Items FOREIGN KEY ( ItemID ) REFERENCES dbo.Items ( ID ) 
	 ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 

UPDATE Items SET ID = 10 WHERE ID = 15 ;

SELECT * FROM Items
SELECT * FROM SaleDetails
