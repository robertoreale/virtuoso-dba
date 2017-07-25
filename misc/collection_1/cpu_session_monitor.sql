/* Formatted on 2010/12/23 10:47 (Formatter Plus v4.8.8) */
SELECT   ss.username, ss.logon_time, ss.status, ss.osuser, ss.machine, ss.program, se.SID, p.spid, VALUE / 100 cpu_usage_seconds
    FROM v$session ss, v$sesstat se, v$statname sn, v$process p
   WHERE se.statistic# = sn.statistic#
     AND ss.paddr = p.addr
     AND NAME LIKE '%CPU used by this session%'
     AND se.SID = ss.SID
     AND ss.status = 'ACTIVE'
     AND ss.username IS NOT NULL
ORDER BY cpu_usage_seconds DESC;


select * from v$session


--valore percentuale
SELECT   ss.username, ss.logon_time, ss.status, ss.osuser, ss.machine, ss.program, se.SID, p.spid, round((value/(select sum(VALUE) from v$session s, v$sesstat p, v$statname n
where p.statistic# = n.statistic#
and s.sid = p.sid
and name LIKE '%CPU used by this session%')), 4) * 100 cpu_usage_seconds
    FROM v$session ss, v$sesstat se, v$statname sn, v$process p
   WHERE se.statistic# = sn.statistic#
     AND ss.paddr = p.addr
     AND NAME LIKE '%CPU used by this session%'
     AND se.SID = ss.SID
     AND ss.status = 'ACTIVE'
     AND ss.username IS NOT NULL
ORDER BY cpu_usage_seconds DESC;

--per modulo
select a.sid, a.value cpu_time, c.module
from v$sesstat a, v$statname b, (select count(*) conta, session_id, module from v$active_session_history
group by session_id, module) c
where a.statistic# = b.statistic#
and a.sid = c.session_id
and a.value <> 0
and b.name like '%CPU used by this session%'
order by cpu_TIME DESC;


select round(sum(a.value)/4549230 * 100, 1) cpu_time, c.module
from v$sesstat a, v$statname b, (select count(*) conta, session_id, module from v$active_session_history
group by session_id, module) c
where a.statistic# = b.statistic#
and a.sid = c.session_id
and a.value <> 0
and b.name like '%CPU used by this session%'
group by module
order by cpu_TIME DESC;