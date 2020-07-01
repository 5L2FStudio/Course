--
-- 測試　Partition Table
--
USE [PartitionTest]
GO

-- 放些 Demo 資料
insert into A values
( '0001', '20120101' , '1', '1' ),
( '0002', '20120102' , '2', '2' ),
( '0003', '20120201' , '3', '3' ),
( '0004', '20120202' , '4', '4' ),
( '0005', '20120203' , '4', '4' ),
( '0006', '20120301' , '5', '5' ),
( '0007', '20120302' , '6', '6' )


-- 利用 UDF 來檢查 Partition 資料存放狀況
select * from dbo.PartitionInfo('dbo.A')
GO

--
-- 分割舊的資料區增加新的 FG
--
declare @path nvarchar(128);
declare @ID  varchar(2)
declare @SQL VARCHAR(1000)

select @path=physical_name from sys.database_files where file_id =1

-- 產生一個四月的檔案群組
set @ID = '04'
set @SQL = 'alter database [PartitionTest] add filegroup [PartitionTestFG2012'+@ID+']' ;
print @SQL
exec( @SQL )
-- 產生一個四月的資料檔案
set @SQL = 'alter database [PartitionTest] add file ( name=[PartitionTestFile'+@ID+'_1], filename="'+@path+'PartitionTestFile'+@ID+'_1.ndf", size=10MB ) to filegroup [PartitionTestFG2012'+@ID+']' ;
print @SQL
exec( @SQL )
-- 變更 Partition Schema 指定新的資料群組是 PartitionTestFG201204
set @SQL = 'alter partition scheme [psPartitionTest] next used [PartitionTestFG2012'+@ID+']' ;
-- 變更 Partition Function 
print @SQL
exec( @SQL )
set @SQL = 'alter partition function [pfPartitionTest]() split range ( 2012'+@ID+'31 )';
print @SQL
exec( @SQL )
GO

--
-- 放入四月份資料
--
insert into A values
( '1001', '20120401' , 'X', 'Y' ),
( '1002', '20120402' , 'X', 'Y' ),
( '1003', '20120403' , 'X', 'Y' ),
( '1004', '20120404' , 'X', 'Y' )

-- 檢查資料
select * from dbo.PartitionInfo('dbo.A')
GO

--
-- 建立一個同樣跟三月份資料同在一個檔案群組的 Table
--
CREATE TABLE MOCK_A_PartitionTestFG201203(
    [A01] [nvarchar](4) NOT NULL,
    [A02] [nvarchar](8) NOT NULL,
    [A03] [nvarchar](10) NULL,
    [A04] [nvarchar](10) NULL,
    PRIMARY KEY CLUSTERED (    [A02] ASC,    [A01] ASC)
) ON PartitionTestFG201203
GO

--
-- 把資料搬移到仿造的 Table 上
--
alter table A switch partition 3 to MOCK_A_PartitionTestFG201203
GO

--
-- 模擬合併
-- 
CREATE TABLE MOCK_A_PartitionTestFG201201(
    [A01] [nvarchar](4) NOT NULL,
    [A02] [nvarchar](8) NOT NULL,
    [A03] [nvarchar](10) NULL,
    [A04] [nvarchar](10) NULL,
    PRIMARY KEY CLUSTERED (    [A02] ASC,    [A01] ASC)
) ON PartitionTestFG201201
GO

alter table A switch partition 1 to MOCK_A_PartitionTestFG201201
GO
--
-- 把 Partition 1 給取消
--
alter partition function pfPartitionTest() merge range ( 20120131 )

select * from [dbo].[PartitionInfo]('dbo.A')

drop table MOCK_A_PartitionTestFG201201
-- 依序刪除，先刪除檔案再刪除 FG
use [master]
GO
alter database [PartitionTest] remove file [PartitionTestFile201201_1]
alter database [PartitionTest] remove filegroup PartitionTestFG201201
