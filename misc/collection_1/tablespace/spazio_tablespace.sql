--query per oggetti

column owner        format a20
column object_type  format a30
column object_name  format a40
select 
  o.owner  ,o.object_name
  ,o.object_type
from sys_objects s
  ,dba_objects o
  ,dba_data_files df
where df.file_id = s.header_file
  and o.object_id = s.object_id
  and df.tablespace_name = 'TEMP';




set lines 200
col OWNER for a12
col SEGMENT_NAME for a32
col SEGMENT_TYPE for a16
col TABLESPACE_NAME for a16
col partition_name for a16
select OWNER, SEGMENT_NAME, SEGMENT_TYPE, BYTES/1024/1024 MB_ATT,
       NEXT_EXTENT/1024/1024 MB_NEXT, PARTITION_NAME, TABLESPACE_NAME, EXTENTS, MAX_EXTENTS
from dba_segments
where SEGMENT_NAME = '&NOME_SEG';



col file_name for a70
col tablespace_name for a24
set lines 200
set pages 999
select a.tablespace_name, a.file_id, a.file_name, a.bytes/(1024*1024) MB_ATT,
a.MAXBYTES/(1024*1024) MB_MAX,substr(a.AUTOEXTENSIBLE,1,1) AUTOEXT, b.status
from dba_data_files a, dba_tablespaces b
where a.TABLESPACE_NAME like UPPER('%&TBSP%')
and a.tablespace_name = b.tablespace_name;

---like UPPER('%&TBSP%')

select a.tablespace_name, b.file_name, a.mb_free, b.mb_att, (b.mb_att-a.mb_free) mb_occupato, b.mb_max, 
b.AUTOEXT from
(select TABLESPACE_NAME, file_id, sum(BYTES/1024/1024) MB_FREE from dba_free_space group by  TABLESPACE_NAME,
file_id) a,
(select tablespace_name, file_name, file_id, sum(bytes/1024/1024) MB_ATT, sum(MAXBYTES/1024/1024) MB_MAX, 
substr(AUTOEXTENSIBLE,1,1) AUTOEXT from dba_data_files
group by tablespace_name, file_name, file_id, substr(AUTOEXTENSIBLE,1,1)) b
where a.file_id=b.file_id
and a.TABLESPACE_NAME like UPPER('%&TBSP%');

col file_name for a90
col tablespace_name for a30
set lines 300
set pages 999
select file_name, TABLESPACE_NAME, bytes/(1024*1024), AUTOEXTENSIBLE, MAXBYTES/(1024*1024)
from dba_data_files where file_name like '&file_name%'
and AUTOEXTENSIBLE = 'YES'
order by TABLESPACE_NAME;

col file_name for a90
col tablespace_name for a30
col file_name for a30
select substr(file_name, 1,25) file_name, TABLESPACE_NAME, bytes/(1024*1024), AUTOEXTENSIBLE, MAXBYTES/(1024*1024)
from dba_data_files where TABLESPACE_NAME like '%&nome_tblsp%'
order by TABLESPACE_NAME

----dimensione database
col "Database Size" format a20
col "Free space" format a20
col "Used space" format a20
select  round(sum(used.bytes) / 1024 / 1024 / 1024 ) || ' GB' "Database Size"
,       round(sum(used.bytes) / 1024 / 1024 / 1024 ) - 
        round(free.p / 1024 / 1024 / 1024) || ' GB' "Used space"
,       round(free.p / 1024 / 1024 / 1024) || ' GB' "Free space"
from    (select bytes
        from    v$datafile
        union   all
        select  bytes
        from    v$tempfile
        union   all
        select bytes
        from    v$log) used
,       (select sum(bytes) as p
        from dba_free_space) free
group by free.p
/

