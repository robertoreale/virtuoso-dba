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


select * from v$access where owner = 'SDC_USROWN'

select * from dba_objects where object_name = 'PCK_MOTORE_MAIN'


select * from v$session where username = 'SDC_USROWN'


select * from dba_objects where object_name like '%ACCESS%'

select a.sid, b.owner ,a.object, b.table_name, b.tablespace_name
 from v$access a, dba_tables b where a.sid = 75 and a.type = 'TABLE'
and a.OBJECT = b.table_name



col file_name for a80
col tablespace_name for a24
set lines 200
set pages 999
select a.tablespace_name, a.file_name, a.bytes/1024/1024 MB_ATT,
a.MAXBYTES/1024/1024 MB_MAX,substr(a.AUTOEXTENSIBLE,1,1) AUTOEXT, b.status
from dba_data_files a, dba_tablespaces b
where a.TABLESPACE_NAME like UPPER('%&TBSP%')
and a.tablespace_name = b.tablespace_name;

select a.tablespace_name, a.mb_free, b.mb_att, (b.mb_att-a.mb_free) mb_occupato, b.mb_max, 
b.AUTOEXT from
(select TABLESPACE_NAME, sum(BYTES/1024/1024) MB_FREE from dba_free_space group by  TABLESPACE_NAME) a,
(select tablespace_name, sum(bytes/1024/1024) MB_ATT, sum(MAXBYTES/1024/1024) MB_MAX, substr(AUTOEXTENSIBLE,1,1) AUTOEXT 
from dba_data_files
where file_name like '%temp%'
group by tablespace_name, substr(AUTOEXTENSIBLE,1,1)) b
where a.tablespace_name=b.tablespace_name

desc dba_free_space

select a.tablespace_name, a.bytes/(1024*1024), a.maxbytes/(1024*1024), b.bytes/(1024*1024) free_mb, 
a.autoextensible from dba_data_files a,
dba_free_space b
where file_name like '/dbsdmspr04/dbsdmspr04_04%' 
and autoextensible = 'YES'
and a.tablespace_name = b.tablespace_name

select 'alter database datafile '''||file_name||''' autoextend off;' tablespace_name from dba_data_files 
where file_name like '/dbsdcprod/dbsdcprod17%' and autoextensible = 'YES'


