--
--  CPU intensive SQL
--


with snaps as
     (select dbid
      ,      instance_number
      ,      to_char(snap_time,'DD/MM/YYYY') snap_day
      ,      snap_id start_snap
      ,      lead(snap_id) over (order by snap_time) stop_snap
      ,      to_char(snap_time,'HH24:MI') start_time
      ,      lead(to_char(snap_time,'HH24:MI')) over (order by snap_time) stop_time
      from   stats$snapshot
      where  snap_id   between :start_snap 
                           and :stop_snap
      and    dbid            = :dbid
      and    instance_number = :instance
      )
,    work as
     (select 
             s.snap_day
      ,      s.start_snap
      ,      s.stop_snap
      ,      s.start_time
      ,      s.stop_time
      ,      e.hash_value
      ,      e.module
      ,      e.text_subset
      ,      sum(e.buffer_gets - nvl(b.buffer_gets,0)) gets
      ,      sum(e.executions - nvl(b.executions,0)) execs
      ,      sum(e.cpu_time - nvl(b.cpu_time,0)) cpu
      ,      sum(e.elapsed_time - nvl(b.elapsed_time,0)) elp
      ,      sum(e.rows_processed - nvl(b.rows_processed,0)) "rows"
      ,      sum(e.disk_reads - nvl(b.disk_reads,0)) reads
      ,      sum(e.parse_calls - nvl(b.parse_calls,0)) prse
      ,      sum(e.invalidations - nvl(b.invalidations,0)) vld
      ,      sum(e.loads - nvl(b.loads,0)) lds
      from   snaps s
      ,      stats$sql_summary e
      ,      stats$sql_summary b
      where  s.stop_snap is not null
      and    b.snap_id         = s.start_snap
      and    b.dbid            = e.dbid
      and    b.instance_number = e.instance_number
      and    b.hash_value      = e.hash_value
      and    b.address         = e.address
      and    b.text_subset     = e.text_subset
      and    e.snap_id         = s.stop_snap
      and    e.dbid            = s.dbid
      and    e.instance_number = s.instance_number
      and    e.executions      > nvl(b.executions,0)
      group by 
             s.snap_day
      ,      s.start_snap
      ,      s.stop_snap
      ,      s.start_time
      ,      s.stop_time
      ,      e.hash_value
      ,      e.module
      ,      e.text_subset)
,    top_n as
     (select w.*
      ,      gets/execs
      ,      row_number() over (partition by start_snap order by cpu desc) rn
      from   work w
      --where  module = :module
      )
select *
from   top_n
where  rn <= 5
;








select s.username “Oracle User”,s.osuser “OS User”,i.consistent_gets “Consistent Gets”,
i.physical_reads “Physical Reads”,s.status “Status”,s.sid “SID”,s.serial# “Serial#”,
s.machine “Machine”,s.program “Program”,to_char(logon_time, ‘DD/MM/YYYY HH24:MI:SS’) “Logon Time”,
w.seconds_in_wait “Idle Time”, P.SPID “PROC”,
name “Stat CPU”, value
from v$session s, v$sess_io i, v$session_wait w, V$PROCESS P, v$statname n, v$sesstat t
where s.sid = i.sid
and s.sid = w.sid (+)
and ‘SQL*Net message from client’ = w.event(+)
and s.osuser is not null
and s.username is not null
and s.paddr=p.addr
and n.statistic# = t.statistic#
and n.name like ‘%cpu%’
and t.SID = s.sid
order by 6 asc, 3 desc, 4 desc;

