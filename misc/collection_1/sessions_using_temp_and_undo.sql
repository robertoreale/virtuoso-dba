Execute the following query to determine who is using a UNDO Segment:

SELECT s.sid,s.serial#, NVL(s.username, 'None') orauser, 
s.program, r.name undoseg, t.used_ublk*TO_NUMBER(x.value)/1024 Undo 
 FROM sys.v_$rollname r, sys.v_$session s, sys.v_$transaction t, sys.v_$parameter x 
WHERE s.taddr = t.addr AND r.usn = t.xidusn(+) AND x.name = 'db_block_size';


Execute the following query to determine who is using a TEMP Segment:

--spazio libero nella temp
select TABLESPACE_NAME, BYTES_USED, BYTES_FREE from V$TEMP_SPACE_HEADER;

SELECT tablespace_name,
       total_blocks,
       used_blocks,
       free_blocks,
    total_blocks*8/1024 as total_MB,
    used_blocks*8/1024 as used_MB,
    free_blocks*8/1024 as free_MB
FROM   v$sort_segment;


SELECT b.tablespace, ROUND(((b.blocks*p.value)/1024/1024),2), a.sid, a.serial# SID_SERIAL, 
a.username, a.program FROM sys.v_$session a, sys.v_$sort_usage b, 
sys.v_$parameter p WHERE p.name = 'db_block_size' AND 
a.saddr = b.session_addr 
ORDER BY b.tablespace, b.blocks;

SELECT s.sid "SID",s.username "User",s.program "Program", u.tablespace "Tablespace",
u.contents "Contents", u.extents "Extents", u.blocks*8/1024 "Used Space in MB", q.sql_text "SQL TEXT",
a.object "Object", k.bytes/1024/1024 "Temp File Size"
FROM v$session s, v$sort_usage u, v$access a, dba_temp_files k, v$sql q
WHERE s.saddr=u.session_addr
and s.sql_address=q.address
and s.sid=a.sid
and u.tablespace=k.tablespace_name;

SELECT b.tablespace,
       ROUND(((b.blocks*p.value)/1024/1024),2)||'M' "SIZE",
       a.sid||','||a.serial# SID_SERIAL,
       a.username,
       a.program
  FROM sys.v_$session a,
       sys.v_$sort_usage b,
       sys.v_$parameter p
 WHERE p.name  = 'db_block_size'
   AND a.saddr = b.session_addr
ORDER BY b.tablespace, b.blocks; 
