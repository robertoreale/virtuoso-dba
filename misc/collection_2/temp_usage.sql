SELECT   A.tablespace_name tablespace, D.mb_total,
         SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_used,
         D.mb_total - SUM (A.used_blocks * D.block_size) / 1024 / 1024 mb_free
FROM     v$sort_segment A,
         (
         SELECT   B.name, C.block_size, SUM (C.bytes) / 1024 / 1024 mb_total
         FROM     v$tablespace B, v$tempfile C
         WHERE    B.ts#= C.ts#
         GROUP BY B.name, C.block_size
         ) D
WHERE    A.tablespace_name = D.name
GROUP by A.tablespace_name, D.mb_total;


SELECT   S.sid || ',' || S.serial# sid_serial, S.username, S.osuser, P.spid, S.module,
         S.program, SUM (T.blocks) * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
         COUNT(*) sort_ops, s.sql_id
FROM     v$sort_usage T, v$session S, dba_tablespaces TBS, v$process P
WHERE    T.session_addr = S.saddr
AND      S.paddr = P.addr
AND      T.tablespace = TBS.tablespace_name
GROUP BY S.sid, S.serial#, S.username, S.osuser, P.spid, S.module,
         S.program, TBS.block_size, T.tablespace,  s.sql_id
ORDER BY osuser, sid_serial;

159 mb 5nt7t0r0cqmn9
1407 mb 3ykq4p55sv7s8
464 mb dxythzq65bm9u


SELECT   S.sid || ',' || S.serial# sid_serial, S.username,
         T.blocks * TBS.block_size / 1024 / 1024 mb_used, T.tablespace,
         T.sqladdr address, Q.hash_value, Q.sql_text
FROM     v$sort_usage T, v$session S, v$sqlarea Q, dba_tablespaces TBS
WHERE    T.session_addr = S.saddr
AND      T.sqladdr = Q.address (+)
AND      T.tablespace = TBS.tablespace_name
ORDER BY S.sid;





SELECT b.tablespace, 
ROUND(((b.blocks*p.value)/(1024*1024)),2) M, a.sid, 
a.serial#,  a.username, a.program 
FROM v$session a, v$sort_usage b, v$parameter p 
WHERE p.name = 'db_block_size' AND a.saddr = b.session_addr
order by ROUND(((b.blocks*p.value)/(1024*1024)),2) desc


select b.tablespace,b.segfile#,b.segblk#,b.blocks,a.sid,a.serial#,a.username,a.osuser,a.status
from V$SESSION a,V$SORT_USAGE b where a.saddr = b.session_addr order by b.tablespace,b.segfile#,b.segblk#,b.blocks;


select * from dba_users

select b.username, c.sql_id, a.module, sum(c.TEMP_SPACE)/(1024*1024) space
from DBA_HIST_ACTIVE_SESS_HISTORY a, dba_users b, DBA_HIST_SQL_PLAN c
where a.user_id = b.user_id
and a.SQL_ID = c.sql_id
and a.sample_time > to_date('2012/06/13 07:00', 'YYYY/MM/DD HH24:MI')
and a.sample_time < to_date('2012/06/13 09:00', 'YYYY/MM/DD HH24:MI')
and temp_space is not null
group by b.username, c.sql_id, a.module
order by sum(c.TEMP_SPACE)/(1024*1024);


select b.username, a.sql_id, a.module, sum(a.TEMP_SPACE_ALLOCATED)/(1024*1024) space
from v$active_session_history a, dba_users b
where a.user_id = b.user_id
and a.sample_time > to_date('2012/06/05 15:00', 'YYYY/MM/DD HH24:MI')
and a.sample_time < to_date('2012/06/05 16:00', 'YYYY/MM/DD HH24:MI')
and TEMP_SPACE_ALLOCATED is not null
group by b.username, a.sql_id, a.module
order by sum(a.TEMP_SPACE_ALLOCATED)/(1024*1024) desc;


select * from DBA_HIST_SQLTEXT where sql_id = 'dxythzq65bm9u'

3ykq4p55sv7s8


where sample_time > sysdate -1/24


 where temp_space is not null








