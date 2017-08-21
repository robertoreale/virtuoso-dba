select * from dba_jobs where job = 925616

select * from v$instance

select b.*, a.serial#, a.username from v$session a,
(select l1.sid, s.username, ' IS BLOCKING ', l2.sid sid_blocked
from v$lock l1, v$lock l2, v$session s         
where l1.block =1 and l2.request > 0
and l1.id1=l2.id1                 
and l1.id2=l2.id2
and l1.sid = s.sid) b
where sid_blocked = a.sid;

--query per killare sessioni lockanti
select 'alter system kill session '''||a.sid||','||a.serial#||''' immediate;' from v$session a,
(select l1.sid sid_blocking, s.username, ' IS BLOCKING ', l2.sid sid_blocked
from v$lock l1, v$lock l2, v$session s         
where l1.block =1 and l2.request > 0
and l1.id1=l2.id1                 
and l1.id2=l2.id2
and l1.sid = s.sid) b
where sid_blocking = a.sid;

select a.*, b.* from v$locked_object a, dba_objects b
where a.OBJECT_ID = b.OBJECT_ID

desc v$lock

select * from v$session where sid = 232

select a.sql_fulltext, b.username from v$sql a, v$session b
where a.SQL_ID = b.SQL_ID
and b.sid = 158

desc v$sql

select * from dba_users where username = 'NDBIF_NDC'

select * from dba_objects where object_name = 'IS_PARAMETRO_COMPONENTE'

select * from dba_tab_privs where table_name = 'IS_PARAMETRO_COMPONENTE'

select * from dba_role_privs where grantee = 'NDBIF_NDC';

select distinct a.sample_time, a.session_id, a.session_serial#, a.sql_id, a.blocking_session, a.blocking_session_serial#, a.user_id
from dba_hist_active_sess_history a
where  blocking_session is not null
and a.user_id <> 0
and a.sample_time > sysdate - 4
order by a.sample_time desc;


select * from dba_hist_active_sess_history where session_id = 585 and session_serial# = 34186
and sample_time between to_date('26/09/2012 04:30', 'DD/MM/YYYY HH24:MI') 
and to_date('26/09/2012 05:00', 'DD/MM/YYYY HH24:MI')
order by sample_time desc;

select * 
  from ( select a.sql_id,
                a.sample_time,
                count(*)
                over (partition by a.blocking_session, a.user_id, a.program)
                     cpt,
                ROW_NUMBER ()
                over (partition by a.blocking_session, a.user_id, a.program
                      order by blocking_session, a.user_id, a.program)
                      rn,
                a.blocking_session, 
                a.user_id, 
                a.program,
                a.machine,
                s.sql_text
          from  sys.WRH$_ACTIVE_SESSION_HISTORY a, sys.wrh$_sqltext s
        where   a.sql_id = s.sql_id
                and blocking_session_serial# <> 0
                and a.user_id <> 0
                and a.sample_time between to_date('31/10/2012 12:00', 'DD/MM/YYYY HH24:MI') 
and to_date('31/10/2012 14:30', 'DD/MM/YYYY HH24:MI')
        order by a.sample_time)
  where rn = 1;