select /*+ RULE*/
owner, segment_name table_name, 
segment_type, 
round(bytes/1024,2) table_kb, num_rows, 
blocks, empty_blocks, hwm highwater_mark, 
avg_used_blocks, 
greatest(round(100 * (nvl(hwm - avg_used_blocks,0) / greatest(nvl(hwm,1),1) ),2),0) block_inefficiency, 
chain_pct, 
o_tablespace_name tablespace_name 
from 
(select 
a.owner owner, 
segment_name, 
segment_type, 
bytes, 
num_rows, 
a.blocks blocks, 
b.empty_blocks empty_blocks, 
a.blocks - b.empty_blocks - 1 hwm, 
decode(round((b.avg_row_len * num_rows * 
(1 + (pct_free/100))) / 
c.blocksize,0),0,1,round((b.avg_row_len * num_rows * 
(1 + (pct_free/100))) / c.blocksize,0)) + 2 
avg_used_blocks, 
round(100 * (nvl(b.chain_cnt,0) / 
greatest(nvl(b.num_rows,1),1)),2) 
chain_pct, 
a.extents extents, 
round(100 * (a.extents / a.max_extents),2) max_extent_pct, 
a.max_extents max_extents, 
b.next_extent next_extent, 
b.tablespace_name o_tablespace_name 
from 
sys.dba_segments a, sys.dba_all_tables b, sys.ts$ c 
where 
( a.owner = b.owner and a.owner = 'RUUSR' and b.tablespace_name = 'RU_DATA' ) and 
a.segment_name = b.table_name and
( ( segment_type = 'TABLE' ) ) and 
b.tablespace_name = c.name 
union all 
select 
a.owner owner, 
segment_name || '.' || b.partition_name, 
segment_type, 
bytes, 
b.num_rows, 
a.blocks blocks, 
b.empty_blocks empty_blocks, 
a.blocks - b.empty_blocks - 1 hwm, 
decode(round((b.avg_row_len * b.num_rows * (1 + 
(b.pct_free/100))) / 
c.blocksize,0),0,1,round((b.avg_row_len * b.num_rows * 
(1 + (b.pct_free/100))) / c.blocksize,0)) + 2 
avg_used_blocks, 
round(100 * (nvl(b.chain_cnt,0) / 
greatest(nvl(b.num_rows,1),1)),2) 
chain_pct, 
a.extents extents, 
round(100 * (a.extents / a.max_extents),2) max_extent_pct, 
a.max_extents max_extents, 
b.next_extent, 
b.tablespace_name o_tablespace_name 
from sys.dba_segments a, 
sys.dba_tab_partitions b, 
sys.ts$ c, 
sys.dba_tables d 
where 
( a.owner = b.table_owner and a.owner = 'RUUSR' and b.tablespace_name = 'RU_DATA' ) and 
( segment_name = b.table_name ) and 
( ( segment_type = 'TABLE PARTITION' ) ) and 
b.tablespace_name = c.name and 
d.owner = b.table_owner and 
d.table_name = b.table_name and 
a.partition_name = b.partition_name), 
( select 
tablespace_name f_tablespace_name, 
max(bytes) max_free_space 
from sys.dba_free_space 
group by tablespace_name) 
where 
f_tablespace_name = o_tablespace_name and 
greatest(round(100 * (nvl(hwm - avg_used_blocks,0) / greatest(nvl(hwm,1),1) ),2),0) > 25 
order by 4 desc, 1 asc,2 asc 
