-- Partition Table 範例


--
-- 建立範例資料
--
create database [PartitionTest]
GO

--
-- 建立 4 個 FILEGROUP 
--
alter database [PartitionTest] add filegroup [PartitionTestFG201201];
alter database [PartitionTest] add filegroup [PartitionTestFG201202];
alter database [PartitionTest] add filegroup [PartitionTestFG201203];
alter database [PartitionTest] add filegroup [PartitionTestFG999999];

use [PartitionTest]
GO
declare @path nvarchar(128);
declare @PTR int ;
declare @ID  varchar(2)
declare @SQL VARCHAR(1000)

select @path=physical_name from sys.database_files where file_id =1

--
-- 每個 FileGroup 至少要指定一個檔案
--
set @PTR = 1
while @PTR < 4
begin
  set @ID = RIGHT('00'+LTRIM(STR(@PTR)),2 )
  set @SQL = 'alter database [PartitionTest] add file ( name=[PartitionTestFile2012'+@ID+'_1], filename="'+@path+'PartitionTestFile2012'+@ID+'_1.ndf", size=10MB ) to filegroup [PartitionTestFG2012'+@ID+']' ;
  exec( @SQL )
  set @PTR += 1
end 
set @SQL = 'alter database [PartitionTest] add file ( name=[PartitionTestFile999999_1], filename="'+@path+'PartitionTestFile'+@ID+'_1.ndf", size=10MB ) to filegroup [PartitionTestFG999999]' ;
exec( @SQL )
GO


--
-- 按照日期區分, 懶得考慮每月最後一天是哪一天, 先用字串混過去囉
--
create partition function pfPartitionTest(nvarchar(8)) 
    as range left for values (N'20120131', N'20120231', N'20120331');

-- 依據 Partition Function 建立 Partition Schema
create partition scheme psPartitionTest
as partition pfPartitionTest
TO ([PartitionTestFG201201], [PartitionTestFG201202], [PartitionTestFG201203], [PartitionTestFG999999]);
GO

--
-- 建立 Table 一開始就使用 Partition Schema
--
CREATE TABLE [dbo].[A](
    [A01] [nvarchar](4) NOT NULL,
    [A02] [nvarchar](8) NOT NULL,
    [A03] [nvarchar](10) NULL,
    [A04] [nvarchar](10) NULL,
 CONSTRAINT [PK_A] PRIMARY KEY CLUSTERED 
(
    [A02] ASC,
    [A01] ASC
)
) ON psPartitionTest(A02)

--
-- 建立一個檢查用的 Function
--
create function PartitionInfo( @tablename sysname ) returns table
as return
select 
OBJECT_NAME(p.object_id) as TableName
,p.partition_number as PartitionNumber
,prv_left.value as LowerBoundary
,prv_right.value as  UpperBoundary
,ps.name as PartitionScheme
,pf.name as PartitionFunction
,fg.name as FileGroupName
,CAST(p.used_page_count * 8.0 / 1024 AS NUMERIC(18,2)) AS UsedPages_MB
,p.row_count as Rows
from sys.dm_db_partition_stats p
inner join sys.indexes i ON i.object_id = p.object_id AND i.index_id = p.index_id
inner join sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
inner join sys.partition_functions pf ON ps.function_id = pf.function_id
inner join sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
inner join sys.filegroups fg ON fg.data_space_id = dds.data_space_id
left  join sys.partition_range_values prv_right ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
left  join sys.partition_range_values prv_left  ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
where
 p.object_id = OBJECT_ID(@tablename) and p.index_id < 2
GO
