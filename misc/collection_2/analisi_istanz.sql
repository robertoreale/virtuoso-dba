SELECT (SELECT ROUND(AVG(BYTES) / 1024 / 1024, 2) FROM V$LOG) AS "Redo size (MB)",
ROUND((20 / AVERAGE_PERIOD) * (SELECT AVG(BYTES)FROM V$LOG) / 1024 / 1024, 2) AS "Recommended Size (MB)" FROM 
(SELECT AVG((NEXT_TIME - FIRST_TIME) * 24 * 60) AS AVERAGE_PERIOD 
FROM V$ARCHIVED_LOG WHERE FIRST_TIME > SYSDATE - 3 AND FIRST_TIME
BETWEEN to_date('2013-02-17 00:00', 'YYYY-MM-DD HH24:MI') AND to_date('2013-02-17 23:59', 'YYYY-MM-DD HH24:MI'));

select * from V$ARCHIVED_LOG order by first_time desc;


select    a.TABLESPACE_NAME, a.file_name,
    round(a.BYTES/(1024*1024*1024), 1) GB_used,
    round(b.BYTES/(1024*1024*1024), 1) GB_free,
    round(b.largest/(1024*1024*1024), 1) largest,
    round(((a.BYTES-b.BYTES)/a.BYTES)*100,2) percent_used,
    a.increment_by,
    a.AUTOEXTENSIBLE,
    a.MAXBYTES/(1024*1024) max_bytes_mb--,
    --round(((a.BYTES-b.BYTES)/a.MAXBYTES)*100,2) percent_used_max
from     
    (
        select     TABLESPACE_NAME, file_name, file_id,
            sum(BYTES) BYTES,
            AUTOEXTENSIBLE,
            MAXBYTES,
            increment_by
        from     dba_data_files 
        group     by TABLESPACE_NAME, file_name, file_id,
                     AUTOEXTENSIBLE,
                     MAXBYTES,
                     increment_by
    )
    a,
    (
        select     TABLESPACE_NAME, file_id,
            sum(BYTES) BYTES ,
            max(BYTES) largest 
        from     dba_free_space 
        group     by TABLESPACE_NAME, file_id
    )
    b
where     a.file_id=b.file_id (+)
--and a.TABLESPACE_NAME like '%ASCOT%'
order by a.TABLESPACE_NAME, b.BYTES desc;