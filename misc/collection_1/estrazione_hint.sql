select distinct owner, name, line, case
when UPPER(text) like '%*+%NOPARALLEL%' then 'NOPARALLEL'
when UPPER(text) like '%*+%PARALLEL%8%' then 'PARALLEL 8'
when UPPER(text) like '%*+%PARALLEL%16%' then 'PARALLEL 16'
when UPPER(text) like '%*+%PARALLEL%32%' then 'PARALLEL 32'
when (UPPER(text) like '%*+%PARALLEL%' and not (UPPER(text) like '%8%' or
UPPER(text) like '%16%' or UPPER(text) like '%32%')) then 'PARALLEL'
else substr(UPPER(text), instr(UPPER(text), '*+') +2, 30)
end HINT
 from dba_source where owner in ('DWH_DM')
and type = 'PACKAGE BODY'
and UPPER(text)  like '%*+%'
and UPPER(text)  not like '%*+ APPEND *%'
and UPPER(text)  not like '%*+ APPEND  *%'
and UPPER(name)  like 'MP_%' 




select * from dba_source where owner = 'DWH_DM'
and line = '336'
and name = 'MP_FT_PRSP_CAMP_NO_CNTR'

select * from dba_source where line = 129

desc dba_source