-- 記得先調整資料庫選項
IF OBJECT_ID('dbo.DEMO2', 'U') IS NOT NULL
  DROP TABLE dbo.DEMO2
GO

CREATE TABLE dbo.DEMO2 AS FILETABLE
  WITH
  (
    FILETABLE_DIRECTORY = 'DEMO2_filetable',
    FILETABLE_COLLATE_FILENAME = Chinese_Taiwan_Stroke_CI_AS  -- database_default
  )
GO
