
select 
      ogg.owner,
      ogg.object_type,
      ogg.object_name,
      ogg.created,
      ogg.tbs,
      to_char(ogg.MB) MBS,
      ogg.num_part, 
      to_char(sum(nvl2(dep.referenced_owner,1,0))) num_ref
from(
       select 
            o.owner,
            o.object_type,
            o.object_name,
            to_char(o.created,'DD-MM-YYYY-HH24.MI.SS') created,
            s.tablespace_name tbs,
            (sum(s.bytes)/1048576) MB,
            to_char(count(*)) num_part
      from dba_objects o,
             dba_segments s
      where 1=1
            and o.object_name=s.segment_name
            and o.owner=s.owner
            and not(o.owner='SYS')
            and o.object_type in ('TABLE','INDEX')
            --and o.created>trunc(sysdate)-120
      group by o.owner,o.object_type,o.object_name,o.created,s.tablespace_name
      ) ogg,
      dba_dependencies dep    
where     ogg.owner = dep.referenced_owner(+)
      and ogg.object_name = dep.referenced_name(+)
      and ogg.object_type = dep.referenced_type(+)
      and ogg.MB >= 1000
      --and ogg.tbs = 'TBS_L'
group by ogg.owner,
      ogg.object_type,
      ogg.object_name,
      ogg.created,
      ogg.tbs,
      ogg.MB,
      ogg.num_part
order by ogg.tbs, ogg.MB desc;


select * from dba_indexes where index_name = 'IDX_FT_OFF_ROW_ID'

select * from dba_ind_subpartitions where index_name = 'IDX_FT_OFF_ROW_ID'