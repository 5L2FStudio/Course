--1
declare @xmlDoc xml;

set @xmlDoc='<book id="0001">
<title>C Program</title>
<author>David</author>
<price>21</price>
</book>'

select @xmlDoc

-- 使用query(xquery) 查詢
select @xmlDoc.query('/book/title')

-- 使用value(xquery, dataType) 查詢
select @xmlDoc.value('(/book/title)[1]', 'nvarchar(max)')

-- 查詢屬性值
select @xmlDoc.value('(/book/@id)[1]', 'nvarchar(max)')
