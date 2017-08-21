SELECT TO_CHAR (s.SID) || ',' || TO_CHAR (s.serial#) sid_serial, s.osuser,
NVL (s.username, 'None') orauser, s.program, r.NAME undoseg,
t.used_ublk * TO_NUMBER (x.VALUE) / (1024*1024) || 'M' "Undo"
FROM SYS.v_$rollname r,
SYS.v_$session s,
SYS.v_$transaction t,
SYS.v_$parameter x
WHERE s.taddr = t.addr 
AND r.usn = t.xidusn(+) 
AND x.NAME = 'db_block_size'
order by osuser;

SELECT DISTINCT STATUS, SUM(BYTES), COUNT(*) 
FROM DBA_UNDO_EXTENTS GROUP BY STATUS; 

SELECT d.undo_size/(1024*1024) "ACTUAL UNDO SIZE [MByte]",
	           SUBSTR(e.value,1,25) "UNDO RETENTION [Sec]",
	           (TO_NUMBER(e.value) * TO_NUMBER(f.value) *
	           g.undo_block_per_sec) / (1024*1024)
	          "NEEDED UNDO SIZE [MByte]"
	      FROM (
	      SELECT SUM(a.bytes) undo_size
	                 FROM v$datafile a,
	                  v$tablespace b,
	                 dba_tablespaces c
	          WHERE c.contents = 'UNDO'
	            AND c.status = 'ONLINE'
	            AND b.name = c.tablespace_name
	            AND a.ts# = b.ts#
	         ) d,
	        v$parameter e,
	         v$parameter f,	        
           (
	         SELECT MAX(undoblks/((end_time-begin_time)*3600*24))
	           undo_block_per_sec
	           FROM v$undostat
	         ) g
	   WHERE e.name = 'undo_retention'
	    AND f.name = 'db_block_size';


