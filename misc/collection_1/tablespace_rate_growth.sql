SELECT to_date(TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY') days 
, ts.tsname
, max(round((tsu.tablespace_size* dt.block_size )/(1024*1024*1024), 2) ) cur_size_GB
, max((round((tsu.tablespace_size* dt.block_size )/(1024*1024*1024)) ) - (round((tsu.tablespace_usedsize* dt.block_size )/(1024*1024*1024), 2))) free_GB
FROM DBA_HIST_TBSPC_SPACE_USAGE tsu
, DBA_HIST_TABLESPACE_STAT ts
, DBA_TABLESPACES dt 
, DBA_HIST_SNAPSHOT sp
, DBA_HIST_SEG_STAT st
WHERE tsu.tablespace_id= ts.ts#
AND ts.tsname = dt.tablespace_name
AND tsu.snap_id = st.snap_id
AND st.snap_id = sp.snap_id
AND st.ts# = ts.ts#
AND sp.begin_interval_time > sysdate - 14
GROUP BY to_date(TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY'), ts.tsname
ORDER BY ts.tsname, days desc;

SELECT to_date(TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY') days 
, ts.tsname
, max(round((tsu.tablespace_size* dt.block_size )/(1024*1024*1024), 2) ) cur_size_GB
, max((round((tsu.tablespace_size* dt.block_size )/(1024*1024*1024)) ) - (round((tsu.tablespace_usedsize* dt.block_size )/(1024*1024*1024), 2))) free_GB,
max(case when sto.object_name like 'BCK%' then sto.object_name
              when sto.object_name like 'APPO%' then sto.object_name
              else null
         end) tmp_obj_name,
max(case when sto.object_name like 'BCK%' then round(st.space_allocated_total/(1024*1024*1024),2)
              when sto.object_name like 'APPO%' then round(st.space_allocated_total/(1024*1024*1024),2)
              else 0
         end) tmp_obj_space_GB
FROM DBA_HIST_TBSPC_SPACE_USAGE tsu
, DBA_HIST_TABLESPACE_STAT ts
, DBA_TABLESPACES dt 
, DBA_HIST_SNAPSHOT sp
, DBA_HIST_SEG_STAT st
, DBA_HIST_SEG_STAT_OBJ sto
WHERE tsu.tablespace_id= ts.ts#
AND ts.tsname = dt.tablespace_name
AND tsu.snap_id = st.snap_id
AND ts.tsname NOT IN ('SYSAUX','SYSTEM', 'TOOLS', 'USERS')
AND st.snap_id = sp.snap_id
AND st.ts# = ts.ts#
AND st.ts# = sto.ts#
AND st.obj# = sto.obj#
AND st.dataobj#= sto.dataobj#
AND ts.tsname = 'TBS_A'
AND sto.object_type not in ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB')
AND sp.begin_interval_time > sysdate - 7
GROUP BY to_date(TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY'), ts.tsname
ORDER BY ts.tsname, days desc;


select * from DBA_HIST_SNAPSHOT

select * from DBA_HIST_TBSPC_SPACE_USAGE

select * from dba_hist_snapshot

select * from DBA_HIST_SEG_STAT_OBJ

select * from DBA_HIST_SEG_STAT

select * from dba_tablespaces

select * from dba_tables


select to_date(TO_CHAR (c.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY'),
a.snap_id, b.object_name, a.space_allocated_total/(1024*1024*1024) 
from DBA_HIST_SEG_STAT a,  DBA_HIST_SEG_STAT_OBJ b, DBA_HIST_SNAPSHOT c,
dba_dependencies d
where a.ts# = b.ts#
and a.obj#= b.obj#
and a.dataobj#= b.dataobj#
and c.SNAP_ID = a.SNAP_ID
and b.owner = d.REFERENCED_OWNER (+)
and b.object_name = d.referenced_name (+)
and d.referenced_name is null
and b.tablespace_name = 'TBS_A'
AND b.object_type not in ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB')
--AND (b.object_name like '%BCK%' or b.object_name like '%APPO%')
AND c.begin_interval_time > sysdate - 8
order by to_date(TO_CHAR (c.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY') desc

select * from dba_recyclebin where original_name = 'BCK_DW_HIST_OFFERTA_OPEN'

select * from dba_tab_subpartitions where table_name = 'DW_HIST_OFFERTA'


and (b.object_name like '%BCK%' or b.object_name like '%APPO%')

select * from dba_objects where object_name like 'DBA_HIST%'

select * from DBA_HIST_SNAPSHOT

select * from DBA_HIST_TBSPC_SPACE_USAGE

select * from DBA_HIST_TABLESPACE_STAT

select * from dba_hist_seg_stat_obj

select * from dba_recyclebin


select * from dba_dependencies where referenced_owner = 'DWH_DM' and referenced_name = 'FT_ESIGENZE_DETT'
