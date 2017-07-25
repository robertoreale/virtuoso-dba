select b.* from v$session a, v$session_longops b
where a.sid = b.sid
and a.serial# = b.serial#
and a.status = 'ACTIVE'
and a.osuser = 'Antonio'
and time_remaining > 0