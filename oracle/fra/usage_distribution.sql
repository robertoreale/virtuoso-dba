-- 
-- Distribution of usage in recovery destination
-- 
-- Tested on: 10g, 11g
--

-- Short info about ARCH
archive log list;
-- natural number
set line 200
col name format a50

select name, SPACE_LIMIT/1024/1024 as "Space Limit MBs", SPACE_USED/1024/1024 as "Space Used MBs", 
SPACE_RECLAIMABLE/1024/1024 as "Space Usable MBs", NUMBER_OF_FILES as Files 
from v$recovery_file_dest;

-- Percentage

set line 200
select * from V_$RECOVERY_AREA_USAGE;
