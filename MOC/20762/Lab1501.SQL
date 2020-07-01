SELECT DISTINCT unit_of_measure, unit_conversion_factor 
FROM sys.spatial_reference_systems;
GO

-- 計算兩點之間距離
DECLARE @g1 geometry; 
DECLARE @g2 geometry; 
SET @g1 = geometry::STGeomFromText('POINT(-88.0 44.5)', 4326); 
SET @g2 = geometry::STGeomFromText('POINT(-88.0 44.0)', 4326); 
SELECT @g1.STDistance(@g2) 
GO

-- 畫多邊型
DECLARE @Shape geometry;
SET @Shape = geometry::STGeomFromText('POLYGON ((10 10, 25 15, 35 15, 40 10, 10 10))',0);
SELECT @Shape;
GO


-- 圖型合併
DECLARE @Shape1 geometry;
DECLARE @Shape2 geometry;
SET @Shape1 = geometry::STGeomFromText('POLYGON ((10 10, 25 15, 35 15, 40 10, 10 10))',0);
SET @Shape2 = geometry::STGeomFromText('POLYGON ((10 10, 25 5, 35 5, 40 10, 10 10))',0);
SELECT @Shape1 
UNION ALL
SELECT @Shape2;
GO

-- 合併成為一個圖
DECLARE @Shape1 geometry;
DECLARE @Shape2 geometry;
SET @Shape1 = geometry::STGeomFromText('POLYGON ((10 10, 25 15, 35 15, 40 10, 10 10))',0);
SET @Shape2 = geometry::STGeomFromText('POLYGON ((10 10, 25 5, 35 5, 40 10, 10 10))',0);
SELECT @Shape1.STUnion(@Shape2);
GO


-- 計算距離
-- ( 經度 緯度 )
-- 台北 101 => 121.564914 25.033908
-- 台北火車站=> 121.517341 25.047926
DECLARE @NewYork geography;
DECLARE @LosAngeles geography;
-- ( 經度 緯度 )
SET @NewYork    = geography::STGeomFromText('POINT (-74.007339 40.726966)',4326);
SET @LosAngeles = geography::STGeomFromText('POINT (-118.24585 34.083375)',4326);
SELECT @NewYork.STDistance(@LosAngeles);
GO

-- 五角大廈
DECLARE @Pentagon geography;
SET @Pentagon = geography::STPolyFromText(
  'POLYGON(( -77.0532219483429 38.870863029297695,
             -77.05468297004701 38.87304314667469,
             -77.05788016319276 38.872800914712734,
             -77.05849170684814 38.870219840133124,
             -77.05556273460198 38.8690670969195,
             -77.0532219483429 38.870863029297695),
           ( -77.05582022666931 38.8702866652523,
             -77.0569360256195 38.870734733163644,
             -77.05673214773439 38.87170668418343,
             -77.0554769039154 38.871848684516294,
             -77.05491900444031 38.87097997215688,
             -77.05582022666931 38.8702866652523))',
           4326);
SELECT @Pentagon;
GO


-- 地理標記語言(Geography Markup Language, GML)係由開放式地理空間聯盟(Open Geospatial Consortium, OGC)發展，
-- 可以其開放之格式描述具有時間、空間及主題屬性之各類地理現象，以提升在使用者端之互操作性
DECLARE @Point geography;
SET @Point = geography::GeomFromGml('
  <Point xmlns="http://www.opengis.net/gml">
      <pos>12 50</pos>
  </Point>',4326);
SELECT @Point;
GO

-- 轉換為 GML
DECLARE @PanamaCanal geography;
SET @PanamaCanal 
  = geography::STLineFromText('LINESTRING( -79.909 9.339, -79.536 8.942 )',4326);
SELECT @PanamaCanal,@PanamaCanal.AsGml();
GO
