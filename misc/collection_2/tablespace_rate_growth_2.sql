SELECT to_date(TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY') days 
, ts.tsname
, max(round((tsu.tablespace_size* dt.block_size )/(1024*1024*1024), 2) ) cur_size_GB
, max((round((tsu.tablespace_size* dt.block_size )/(1024*1024*1024)) ) - (round((tsu.tablespace_usedsize* dt.block_size )/(1024*1024*1024), 2))) free_GB,
max(case when sto.object_name like 'BCK%' then sto.object_name
              when sto.object_name like 'APPO%' then sto.object_name
              when d.referenced_name is null then sto.object_name||'(not referenced object)'
              else null
         end) tmp_obj_name,
max(case when sto.object_name like 'BCK%' then round(st.space_allocated_total/(1024*1024*1024),2)
              when sto.object_name like 'APPO%' then round(st.space_allocated_total/(1024*1024*1024),2)
              when d.referenced_name is null then round(st.space_allocated_total/(1024*1024*1024),2)
              else 0
         end) tmp_obj_space_GB
FROM DBA_HIST_TBSPC_SPACE_USAGE tsu
, DBA_HIST_TABLESPACE_STAT ts
, DBA_TABLESPACES dt 
, DBA_HIST_SNAPSHOT sp
, DBA_HIST_SEG_STAT st
, DBA_HIST_SEG_STAT_OBJ sto
, DBA_DEPENDENCIES d
WHERE tsu.tablespace_id= ts.ts#
AND ts.tsname = dt.tablespace_name
AND tsu.snap_id = st.snap_id
AND ts.tsname NOT IN ('SYSAUX','SYSTEM', 'TOOLS', 'USERS')
AND st.snap_id = sp.snap_id
AND st.ts# = ts.ts#
AND st.ts# = sto.ts#
AND st.obj# = sto.obj#
AND st.dataobj#= sto.dataobj#
and sto.owner = d.REFERENCED_OWNER (+)
and sto.object_name = d.referenced_name (+)
--and d.referenced_name is null
AND ts.tsname = 'TBS_A'
and sto.object_type not in ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB')
AND sp.begin_interval_time > sysdate - 8
GROUP BY to_date(TO_CHAR (sp.begin_interval_time,'DD-MM-YYYY'), 'DD-MM-YYYY'), ts.tsname
ORDER BY ts.tsname, days desc;



select * from dba_dependencies where referenced_owner = 'DWH_DM' and referenced_name = 'FT_ESIGENZE_DETT'


select bytes/(1024*1024*1024) from dba_segments where segment_name = 'APPO_ULPD_S_NOTE_ORDER'
