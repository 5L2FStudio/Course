select name, sid , password_hash 
--'CREATE LOGIN ['+name+'] WITH PASSWORD = ' + cast(password_hash as varchar ) + ' HASHED , SID = ' + cast(sid as varchar )
from sys.sql_logins　where is_disabled=0

select --name, sid , password_hash 
'CREATE LOGIN ['+name+'] WITH PASSWORD = ' + convert(varchar(256),password_hash,1  ) + ' HASHED , SID = ' + convert(varchar,sid,1  )
from sys.sql_logins　where is_disabled=0


select r.name as Role, m.name as Principal
from sys.server_role_members rm
inner join sys.server_principals r on rm.role_principal_id = r.principal_id and r.type = 'R'
inner join sys.server_principals m on rm.member_principal_id = m.principal_id 

select * from sys.server_role_members

select * from sys.server_principals
