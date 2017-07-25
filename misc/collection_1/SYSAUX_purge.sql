select * from v$parameter where name like '%stat%';

SELECT  occupant_name "Item",
space_usage_kbytes/1048576 "Space Used (GB)",
schema_name "Schema",
move_procedure "Move Procedure"
FROM v$sysaux_occupants
WHERE occupant_name = 'SM/AWR'
ORDER BY 1;

select sysdate - a.sample_time ash,
sysdate - s.begin_interval_time snap,
c.RETENTION
from sys.wrm$_wr_control c,
(
select db.dbid,
min(w.sample_time) sample_time
from sys.v_$database db,
sys.Wrh$_active_session_history w
where w.dbid = db.dbid group by db.dbid
) a,
(
select db.dbid,
min(r.begin_interval_time) begin_interval_time
from sys.v_$database db,
sys.wrm$_snapshot r
where r.dbid = db.dbid
group by db.dbid
) s
where a.dbid = s.dbid
and c.dbid = a.dbid;


select dbid from v$database;

--3636925349

select extract( day from snap_interval) *24 *60
       + extract( hour from snap_interval) *60
       + extract( minute from snap_interval) snap_interval
       from wrm$_wr_control where dbid = 3636925349;
       
exec dbms_workload_repository.modify_snapshot_settings(interval=> 60, dbid => 3636925349);


select max(snap_id) max_snap
from wrm$_snapshot
where begin_interval_time
< (sysdate - (select retention
from wrm$_wr_control
where dbid = 3636925349));

select * from dba_hist_snapshot order by snap_id;

select d.dbid,w.snap_interval,w.retention from DBA_HIST_WR_CONTROL w, v$database d where w.dbid = d.dbid;

--EXEC dbms_workload_repository.drop_snapshot_range(low_snap_id=>17000, high_snap_id=>17429);

select * from v$session_longops order by start_time desc;

select 'alter index '||segment_name||' rebuild online parallel (degree 4);' from dba_segments where tablespace_name= 
'SYSAUX' and segment_name like 'WRH$_%' and segment_type='INDEX' order by segment_name;

select 'alter table '||segment_name||' move tablespace sysaux ;' from dba_segments 
where tablespace_name= 'SYSAUX' and segment_name like 'WRH$_%' and segment_type = 'TABLE'   order by segment_name;

select 'alter table '||table_name||' move partition '||partition_name||' tablespace sysaux;'
 from dba_tab_partitions where tablespace_name= 'SYSAUX' and table_name like 'WRH$_%'
order by table_name;

select 'alter index '||index_name||' rebuild partition '||partition_name||';' from dba_ind_partitions 
where tablespace_name= 'SYSAUX' and index_name like 'WRH$_%';

select * from dba_ind_partitions
where tablespace_name= 'SYSAUX' and index_name like 'WRH$_%';


select 'alter index '||index_name||' rebuild online parallel (degree 4);' from dba_indexes 
where status = 'UNUSABLE' and tablespace_name= 'SYSAUX'
and index_name like 'WRH$_%';