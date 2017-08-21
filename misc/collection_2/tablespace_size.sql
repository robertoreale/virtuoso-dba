set lines 300
col file_name for a60

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
and a.TABLESPACE_NAME like '%RMAN%'
order by a.TABLESPACE_NAME, b.BYTES desc;