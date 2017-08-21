select * from dba_tab_privs where (table_name like 'V_$%' or table_name like '%$%')
and grantee not in ('PUBLIC', 'SYSTEM', 'SYS', 'SELECT_CATALOG_ROLE');

select * from dba_tab_privs where (table_name like 'V_$%' or table_name like '%$%')
and grantee not in ('PUBLIC', 'SYSTEM', 'SYS', 'SELECT_CATALOG_ROLE')
and grantor in ('SYS', 'SYSTEM');

select * from dba_tab_privs where 
grantee not in ('PUBLIC', 'SYSTEM', 'SYS', 'SELECT_CATALOG_ROLE', 'DELETE_CATALOG_ROLE',
'DBA', 'EXP_FULL_DATABASE', 'EXECUTE_CATALOG_ROLE', 'GATHER_SYSTEM_STATISTICS', 'LOGSTDBY_ADMINISTRATOR',
'IMP_FULL_DATABASE', 'AQ_ADMINISTRATOR_ROLE', 'AQ_USER_ROLE', 'OUTLN', 'HS_ADMIN_ROLE',
'OEM_MONITOR', 'WMSYS', 'WM_ADMIN_ROLE', 'XDB', 'QUEST_SPC_APP_PRIV', 'CK_ORACLE_REPOS_OWNER', 'ORDSYS',
'MDSYS', 'CTXSYS', 'QUEST', 'ADM_PARALLEL_EXECUTE_TASK', 'APPQOSSYS', 'DATAPUMP_IMP_FULL_DATABASE', 'DBFS_ROLE',
'EXFSYS', 'DATAPUMP_EXP_FULL_DATABASE', 'HS_ADMIN_EXECUTE_ROLE', 'HS_ADMIN_SELECT_ROLE', 'SYSMAN',
'APEX_030200', 'OLAPSYS', 'OLAP_XS_ADMIN', 'ORACLE_OCM', 'ORDPLUGINS', 'OWB$CLIENT', 'OWBSYS', 'DBSNMP',
'XDBADMIN')
and grantor in ('SYS', 'SYSTEM')
order by grantee;

select 'grant '||privilege||' on '||table_name||' to '||grantee||decode(grantable, 'NO', ';', 'YES', ' with grant option;') from dba_tab_privs where 
grantee not in ('PUBLIC', 'SYSTEM', 'SYS', 'SELECT_CATALOG_ROLE', 'DELETE_CATALOG_ROLE',
'DBA', 'EXP_FULL_DATABASE', 'EXECUTE_CATALOG_ROLE', 'GATHER_SYSTEM_STATISTICS', 'LOGSTDBY_ADMINISTRATOR',
'IMP_FULL_DATABASE', 'AQ_ADMINISTRATOR_ROLE', 'AQ_USER_ROLE', 'OUTLN', 'HS_ADMIN_ROLE',
'OEM_MONITOR', 'WMSYS', 'WM_ADMIN_ROLE', 'XDB', 'QUEST_SPC_APP_PRIV', 'CK_ORACLE_REPOS_OWNER', 'ORDSYS',
'MDSYS', 'CTXSYS', 'QUEST', 'ADM_PARALLEL_EXECUTE_TASK', 'APPQOSSYS', 'DATAPUMP_IMP_FULL_DATABASE', 'DBFS_ROLE',
'EXFSYS', 'DATAPUMP_EXP_FULL_DATABASE', 'HS_ADMIN_EXECUTE_ROLE', 'HS_ADMIN_SELECT_ROLE', 'SYSMAN',
'APEX_030200', 'OLAPSYS', 'OLAP_XS_ADMIN', 'ORACLE_OCM', 'ORDPLUGINS', 'OWB$CLIENT', 'OWBSYS', 'DBSNMP',
'XDBADMIN')
and grantor in ('SYS', 'SYSTEM')
order by grantee;

select * from dba_users order by username;

select * from dba_registry;

select sum(bytes)/(1024*1024), tablespace_name from dba_segments
group by tablespace_name
order by tablespace_name;

select count(*), object_type, status from dba_objects
where owner = 'DEM'
group by object_type, status
order by object_type, status;

select count(*), object_type, status from dba_objects
group by object_type, status
order by status, object_type;


drop database link mylink;

create database link
  mylink
connect to
  system
identified by so12mee0
using '  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = sue05p2)(PORT = 1525))
    )
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = SISV9I)
    )
  )
';

select sysdate from dual@mylink;

select a.num-b.num, a.owner from
(select count(*) num, owner from dba_objects@mylink
group by owner
order by owner) a, 
(select count(*) num, owner from dba_objects
group by owner
order by owner) b
where a.owner=b.owner
and a.num-b.num <> 0;


select count(*), object_type from dba_objects
where owner = 'DELFERRARO_M'
group by object_type
order by object_type;