select 'alter database datafile '''||b.file_name||''' resize '||(b.bytes/1024/1024 - trunc(a.BYTES/1024/1024))||'m;', b.bytes/1024/1024
from dba_free_space a, dba_data_files b
where a.TABLESPACE_NAME not like '%rbs%'
and b.file_name like '%RU1ITP0/indx0001%'
and a.file_id = b.file_id 
and AUTOEXTENSIBLE='YES'
and a.BYTES/1024/1024 > 1
order by b.file_name;
