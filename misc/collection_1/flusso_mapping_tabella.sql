select table_name, stale_stats, last_analyzed 
from dba_tab_statistics 
where owner= 'DWH_DDS' -- or table_name = <table name>
and stale_stats = 'YES'
order by last_analyzed desc

select table_name, stale_stats, last_analyzed 
from dba_tab_statistics 
where owner= 'DWH_ODS' -- or table_name = <table name>
and table_name not like 'BIN$%'
and last_analyzed is null


select vs.nome, dep.name, dep.REFERENCED_OWNER, dep.REFERENCED_NAME from vs_owb_flows_objects vs, dba_dependencies@DWH_DM15K dep
where vs.nome = dep.name
and vs.task = 'WF_LOAD_CNTR_OFF'
and vs.tipo = 'Mapping'
and dep.referenced_type = 'TABLE'


--tabelle stale
select owner, table_name, stale_stats, last_analyzed 
from dba_tab_statistics@DWH_DM15K 
where stale_stats = 'YES'
and table_name in (select dep.REFERENCED_NAME from vs_owb_flows_objects vs, dba_dependencies@DWH_DM15K dep
where vs.nome = dep.name
and vs.task = 'WF_LOAD_CNTR_OFF'
and vs.tipo = 'Mapping'
and dep.referenced_type = 'TABLE')
order by last_analyzed desc


select owner, table_name, stale_stats, last_analyzed 
from dba_tab_statistics@DWH_DM15K 
where table_name not like 'BIN$%'
and last_analyzed is null
and table_name in (select dep.REFERENCED_NAME from vs_owb_flows_objects vs, dba_dependencies@DWH_DM15K dep
where vs.nome = dep.name
and vs.task = 'WF_LOAD_CNTR_OFF'
and vs.tipo = 'Mapping'
and dep.referenced_type = 'TABLE')
