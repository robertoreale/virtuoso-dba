select distinct c.schemaname from v$access a, dba_objects b, v$session c
where a.OBJECT=b.OBJECT_NAME
and b.STATUS = 'INVALID'
and a.sid=c.sid