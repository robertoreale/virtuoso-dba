Set lines 200
Set pages 60
select to_char(sysdate -(LAST_CALL_ET/86400),'DD-MON-YY hh24:mi:ss') LAST_CALL, s.status, s.process,s.program, s.schemaname,
s.sid, s.serial#, p.spid, p.pid, s.osuser, S.machine, S.terminal, to_char(S.logon_time,'DD-MM-YYYY hh24.mi.ss') LOGON_TIME, 
U.username, S.ACTION, 
decode(S.command,
0, 'No command in progress.', 1, 'CREATE TABLE',
2, 'INSERT', 3, 'SELECT', 4, 'CREATE CLUSTER',
5, 'ALTER CLUSTER', 6, 'UPDATE', 7, 'DELETE') COMMAND, 
S.LOCKWAIT,
S.ROW_WAIT_OBJ#, 
S.ROW_WAIT_FILE#, 
S.ROW_WAIT_BLOCK#, 
S.ROW_WAIT_ROW#
from v$session S,
dba_users U,
v$process P
where P.ADDR = S.PADDR
and S.user# = U.user_id
and s.type ='USER'
and s.username is not null
and STATUS != 'INACTIVE'
and logon_time < sysdate -3
order by logon_time asc;









select job,broken,interval,failures,what from dba_jobs where job in (82,102);

************ RMAN ***********

Set lines 200
Set pages 60
select to_char(sysdate -(LAST_CALL_ET/86400),'DD-MON-YY hh24:mi:ss') LAST_CALL, s.status, s.process,s.program, s.schemaname,
s.sid, s.serial#, p.spid, p.pid, s.osuser, S.machine, S.terminal, to_char(S.logon_time,'DD-MM-YYYY hh24.mi.ss') LOGON_TIME, 
U.username, S.ACTION, 
decode(S.command,
0, 'No command in progress.', 1, 'CREATE TABLE',
2, 'INSERT', 3, 'SELECT', 4, 'CREATE CLUSTER',
5, 'ALTER CLUSTER', 6, 'UPDATE', 7, 'DELETE') COMMAND, 
S.LOCKWAIT,
S.ROW_WAIT_OBJ#, 
S.ROW_WAIT_FILE#, 
S.ROW_WAIT_BLOCK#, 
S.ROW_WAIT_ROW#
from v$session S,
dba_users U,
v$process P
where P.ADDR = S.PADDR
and S.user# = U.user_id
and s.type ='USER'
and s.username is not null
and s.program like 'rman%';

Set lines 200
Set pages 60
select /* Sessioni in attesa a causa di lock */
round(W.SECONDS_IN_WAIT / 60 / 60 / 24, 2) DAYS_IN_WAIT,
to_date(to_char(sysdate -(LAST_CALL_ET/86400), 'DD-MON-YY hh24:mi:ss'),'DD-MON-YY hh24:mi:ss') LAST_CALL_ET, s.status, 
s.program, s.schemaname, s.sid, s.serial#, p.spid, p.pid, s.osuser,S.machine, S.terminal,
to_char(S.logon_time, 'DD-MM-YYYY hh24.mi.ss') LOGON_TIME, 
S.status, U.username, 
W.EVENT
from v$session S,
dba_users U,
v$process P,
V$session_wait W
where P.ADDR = S.PADDR
and S.user# = U.user_id
and s.type ='USER'
and s.username is not null
and s.SID=W.SID
and W.EVENT like '%enqueue%'
order by 1 desc;
