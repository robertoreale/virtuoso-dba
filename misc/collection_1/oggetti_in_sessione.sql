select * from v$instance

select * from v$session where sid = '75' and serial# = '22491'

EXECUTE dbms_system.set_sql_trace_in_session ('75', '22491', FALSE); 

exec dbms_session.

select s.sid||','||s.serial#, 
       s.USERNAME,
       s.last_call_et seconds_since_active, 
       s.status, 
       s.sql_address, 
       s.program
from v$session s
where s.sid = '75'


select * from dba_users where username = 'SDC_USR'


select * from v$access where owner = 'SDC_USROWN'  and type = 'INDEX'

select * from dba_objects where object_name = 'PCK_MOTORE_MAIN'


select * from v$session where username = 'SDC_USROWN'


select * from dba_objects where object_name like '%ACCESS%'

select a.sid, b.owner ,a.object, b.table_name, b.tablespace_name
 from v$access a, dba_tables b where a.sid = 75 and a.type = 'TABLE'
and a.OBJECT = b.table_name
and b.table_name = 'SALA_AF'

select a.sid, b.owner ,a.object, b.table_name, b.tablespace_name
 from v$access a, dba_tables b where a.object = 'FACT' and a.type = 'TABLE'
and a.OBJECT = b.table_name



select a.sid, b.owner ,a.object, b.table_name, b.tablespace_name
 from v$access a, dba_indexes b where a.type = 'INDEX'
and a.OBJECT = b.index_name
and b.index_name = 'FK_SALA_AF_EDIFICIO_CENTRALE'


select username, status, sid, serial#, command, sql_address from
v$session where sid in (
select a.sid
from v$access a, dba_tables b where a.type = 'TABLE'
and a.OBJECT = b.table_name
and b.table_name = 'SALA_AF') and status = 'ACTIVE';
