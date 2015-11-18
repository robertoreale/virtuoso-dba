-- 
--Report historic tablespaces usage
-- 
-- @tested on: 10g, 11g

select NAME,RTIME,TABLESPACE_SIZE/1024/1024,TABLESPACE_MAXSIZE/1024/1024,TABLESPACE_USEDSIZE/1024/1024
from dba_hist_tbspc_space_usage,v$tablespace where TABLESPACE_ID=TS# order by 1,2
/
