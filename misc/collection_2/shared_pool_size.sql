Select s.name, s.bytes "Free Bytes",
Round((s.bytes/p.value)*100,2) "Perc Free",
p.value / (1024 * 1024) "SP Size MB", s.pool
from sys.v_$parameter p, sys.v_$sgastat s
where s.name = 'free memory'
and p.name = 'shared_pool_size';

select * from v$sgainfo


select POOL, round(bytes/1024/1024,0) FREE_MB 
from v$sgastat 
where name like '%free memory%';


select to_char(sysdate,'mm-dd-yyyy hh24:mi:ss'), name, bytes/(1024*1024)
from v$sgastat, dual
where pool like '%shared%' and name = 'free memory' order by bytes asc
;


select pool, name, sum(bytes) from v$sgastat
where pool like '%pool%'
group by rollup (pool, name);


select * from v$parameter where name like '%shared%'


select owner || '.' || name OBJECT 
         , type
         , to_char(sharable_mem/1024,'9,999.9') "SPACE(K)"
         , loads
         , executions execs
         , kept
from v$db_object_cache 
where type in ('FUNCTION','PACKAGE','PACKAGE BODY','PROCEDURE') and owner not in ('SYS') 
order by to_char(sharable_mem/1024,'9,999.9') desc;

