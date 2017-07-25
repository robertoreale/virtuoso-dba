--sinonimi table view sequence type procedure package function

select count(*), object_type from dba_objects where owner = 'TFFUSR' and object_type = 'TABLE'
group by object_type;

select count(*) from dba_objects where object_type = 'SYNONYM' and object_name in
(select object_name from dba_objects where owner = 'TFFUSR' and object_type = 'TABLE') and owner = 'PUBLIC';

select 'create public synonym '||object_name||' for ENGUSR.'||object_name||';' from dba_objects where owner = 'ENGUSR' and object_type = 'FUNCTION' 
and object_name not in
(select object_name from dba_objects where object_type = 'SYNONYM' and object_name in
(select object_name from dba_objects where owner = 'ENGUSR' and object_type = 'FUNCTION') and owner = 'PUBLIC');

select count(*), segment_type, tablespace_name from dba_segments where owner = 'BPMUSR'
group by segment_type, tablespace_name order by segment_type;

select 'CONTEXT' tipo, index_name from dba_indexes where table_name like '%CTX%' and owner = 'GCPUSR';

select * from dba_lobs  where table_name like '%CTX%' and owner = 'GCPUSR'; 

select count(*), segment_type, nvl(tipo,'NORMAL'), tablespace_name from dba_segments a, 
(select 'CONTEXT' tipo, index_name obj from dba_indexes where table_name like '%CTX%' and owner = 'TFFMIT'
  union
 select 'CONTEXT' tipo, table_name obj from dba_lobs  where table_name like '%CTX%' and owner = 'TFFMIT'
 union
 select 'CONTEXT' tipo, segment_name obj from dba_lobs  where table_name like '%CTX%' and owner = 'TFFMIT') b
where a.segment_name = b.obj (+)
and a.owner = 'TFFMIT'
group by segment_type, tipo, tablespace_name order by segment_type;


--------11g
select count(*), tablespace_name, segment_created from dba_tables where owner = 'BE_WSPAC'
group by tablespace_name, segment_created order by tablespace_name;


select count(*), tablespace_name, segment_created from dba_indexes where owner = 'BE_WSPAC'
and index_type <> 'LOB'
group by tablespace_name, segment_created order by tablespace_name;

select count(*), tablespace_name, segment_created from dba_lobs where owner = 'BE_WSPAC'
group by tablespace_name, segment_created order by tablespace_name;

--------11g

select 'alter table BE_WSPAC.'||table_name||' move tablespace BE_WSPAC_DATA;' 
from dba_tables where owner = 'BE_WSPAC' and TABLESPACE_NAME = 'USERS';

select 'alter index BE_WSPAC.'||index_name||' rebuild tablespace BE_WSPAC_IDX;' 
from dba_indexes where owner = 'BE_WSPAC' and TABLESPACE_NAME = 'SYSTEM';

select 'alter table '||owner||'.'||table_name ||' move lob (' ||column_name||')' ||
' store as (tablespace BE_WSPAC_LOB);' a from dba_lobs where table_name in 
(select table_name from dba_tab_columns where owner='BE_WSPAC' and data_type like '%LOB%')
and tablespace_name = 'BE_WSPAC_IDX';

------------

select count(*), object_type, status from dba_objects where owner = 'ENGUSR'
group by object_type, status;

select 'alter index ENGUSR.'||segment_name||' rebuild tablespace ENG_IDX;' 
from dba_segments where owner = 'ENGUSR' and SEGMENT_TYPE = 'INDEX' and TABLESPACE_NAME = 'ENG_DATA';

select * from dba_segments where segment_type = 'TABLE' and tablespace_name = 'GCPTS02_DATA';

select 'alter table BE_WSPAC.'||segment_name||' move tablespace BE_WSPAC_DATA;' 
from dba_segments where owner = 'BE_WSPAC' and SEGMENT_TYPE = 'TABLE' and TABLESPACE_NAME = 'USERS';

select 'alter table '||owner||'.'||table_name ||' move lob (' ||column_name||')' ||
' store as (tablespace BE_WSPAC_LOB);' a from dba_lobs where segment_name in 
(select segment_name from dba_segments where tablespace_name='USERS' 
 and owner='BE_WSPAC' and segment_type='LOBSEGMENT');

select 'alter table '||owner||'.'||table_name ||' move lob (' ||column_name||')' ||
' store as (tablespace BE_WSPAC_LOB);' a from dba_lobs where table_name in 
(select table_name from dba_tab_columns where owner='BE_WSPAC' and data_type like '%BLOB%')
and tablespace_name = 'USERS';



select a.owner, a.TABLE_NAME, a.column_name, a.TABLESPACE_NAME, b.data_type from dba_lobs a, dba_tab_columns b
where a.table_name=b.table_name and a.column_name=b.column_name
and a.owner='ENGUSR';

SELECT 'alter index BE_WSPAC.'||index_name||' rebuild;'
  FROM dba_indexes
 WHERE status = 'UNUSABLE'
and owner = 'BE_WSPAC';

SELECT 'conteggio indici' Descrizione,
       TO_CHAR (COUNT (DISTINCT index_name)) nome_indice,
       ' ' as "Indici o partiz UNUSABLE" 
  FROM dba_indexes
 WHERE status = 'UNUSABLE'
UNION ALL
SELECT 'conteggio indici partizionati',
       TO_CHAR (COUNT (DISTINCT index_name)),
       ' '  as "Indici o partiz UNUSABLE"
  FROM dba_ind_partitions
 WHERE status = 'UNUSABLE'
UNION ALL
SELECT 'conteggio indici subpartizionati',
       TO_CHAR (COUNT (DISTINCT index_name)),
       ' '  as "Indici o partiz UNUSABLE"
  FROM dba_ind_subpartitions
 WHERE status = 'UNUSABLE'
UNION ALL
SELECT DISTINCT index_owner,
                index_name,
                TO_CHAR (COUNT (index_name))
           FROM dba_ind_partitions
          WHERE status = 'UNUSABLE'
          group by index_owner,index_name
UNION ALL
SELECT DISTINCT index_owner,
                index_name,
                TO_CHAR (COUNT (index_name))
           FROM dba_ind_subpartitions
          WHERE status = 'UNUSABLE'
          group by index_owner,index_name
UNION ALL
SELECT DISTINCT owner,
                index_name,
                TO_CHAR (COUNT (index_name))
           FROM dba_indexes
          WHERE status = 'UNUSABLE'
          group by owner,index_name;
          
          
select * from dba_roles where role like '%GCP%';


select 'grant select on ENGUSR.'||object_name||' to ROLEENGR;' from dba_objects 
where owner = 'ENGUSR' and object_type in ('TABLE', 'VIEW', 'SEQUENCE')
and object_name not in (select table_name from dba_tab_privs where grantee = 'ROLEENGR'
and privilege = 'SELECT' and grantor = 'ENGUSR') and object_name not like '%CTX%';

select 'grant insert, delete, update on ENGUSR.'||object_name||' to ROLEENGW;' from dba_objects 
where owner = 'ENGUSR' and object_type in ('TABLE', 'VIEW')
and object_name not in (select table_name from dba_tab_privs where grantee = 'ROLEENGW'
and privilege in ('DELETE', 'UPDATE', 'INSERT') and grantor = 'ENGUSR') and object_name not like '%CTX%';

select 'grant execute on ENGUSR.'||object_name||' to ROLEENGW;' from dba_objects 
where owner = 'ENGUSR' and object_type in ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'TYPE')
and object_name not in (select table_name from dba_tab_privs where grantee = 'ROLEENGW'
and privilege in ('EXECUTE') and grantor = 'ENGUSR') and object_name not like '%CTX%';

select b.owner, a.privilege, a.grantee, b.object_type, b.object_name from dba_tab_privs a, dba_objects b where a.table_name = b.object_name
and b.owner = 'ENGUSR'
and b.object_type in ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'TYPE')
order by b.object_type;


select owner, constraint_name,table_name,index_owner,index_name
from dba_constraints
where (index_owner,index_name) in (select owner,index_name from dba_indexes
 where tablespace_name='BPM_TABLESPACE');


select a.constraint_name, a.index_name, a.R_CONSTRAINT_NAME, b.tablespace_name from dba_constraints a, dba_indexes b where a.R_CONSTRAINT_NAME in
 (select CONSTRAINT_NAME from dba_constraints where owner='BPMUSR' ) --and a.CONSTRAINT_TYPE='R'
and a.R_CONSTRAINT_NAME = b.index_name; 


