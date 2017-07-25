set echo on
select 'alter index ' || index_owner ||'.'|| index_name || ' REBUILD PARTITION ' || partition_name || ';' from dba_ind_partitions
where  STATUS like 'INVALID' or STATUS like 'UNUSABLE';

select 'alter index '||OWNER||'.'||INDEX_NAME||' rebuild storage (initial 0) ;'
from dba_indexes
where STATUS like 'INVALID' or STATUS like 'UNUSABLE';

select 'alter index ' || index_owner ||'.' || index_name || ' REBUILD SUBPARTITION ' || subpartition_name || ';' from dba_ind_subpartitions
where STATUS like 'INVALID' or STATUS like 'UNUSABLE';