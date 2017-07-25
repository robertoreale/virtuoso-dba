set lines 130

select count(*), segment_type, tablespace_name from dba_segments
where owner = 'IBKUSERPROFILE' group by segment_type, tablespace_name;

  COUNT(*) SEGMENT_TYPE       TABLESPACE_NAME
---------- ------------------ ------------------------------
        38 LOBSEGMENT         IBKCORPORATE_LOB
         3 LOBINDEX           IBKCORPORATE_DTA
        77 TABLE              IBKCORPORATE_DTA
         3 TABLE              IBKAPPLOOKUP_DTA
       197 INDEX              IBKCORPORATE_IDX
        38 LOBINDEX           IBKCORPORATE_LOB
         3 LOBSEGMENT         IBKCORPORATE_DTA
        18 INDEX              IBKCORPORATE_DTA

8 rows selected.

select 'alter index IBKUSERPROFILE.'||segment_name||' rebuild tablespace IBKGEN_IDX;' 
from dba_segments where owner = 'IBKUSERPROFILE' and SEGMENT_TYPE = 'INDEX' and TABLESPACE_NAME = 'IBKAPP_DTA';

col a for a300

select 'alter table '||owner||'.'||table_name ||' move lob (' ||column_name||')' ||
'store as (tablespace IBKAPP_LOB);' a from dba_lobs where segment_name in 
(select segment_name from dba_segments where tablespace_name='IBKAPP_DTA' 
 and owner='IBKUSERPROFILE' and segment_type='LOBSEGMENT');


IBKUSERAPP
IBKCBI
IBKUSERPROFILE

