set long 200000 pages 1000 lines 131
column DDL format a121 word_wrapped
SELECT DBMS_METADATA.GET_DDL('USER', USERNAME) || '/' DDL
FROM DBA_USERS where username = 'ALFA_EDITOR'
UNION ALL
SELECT DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT', USERNAME) || '/' DDL
FROM DBA_USERS where exists (select 'x' from dba_role_privs drp where
drp.grantee = dba_users.username) and username = 'ALFA_EDITOR'
UNION ALL
SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT', USERNAME) || '/' DDL FROM 
DBA_USERS where exists (select 'x' from dba_role_privs drp where
drp.grantee = dba_users.username) and username = 'ALFA_EDITOR'
UNION ALL
SELECT DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT', USERNAME) || '/' DDL FROM 
DBA_USERS where exists (select 'x' from dba_tab_privs dtp where
dtp.grantee = dba_users.username) and username = 'ALFA_EDITOR';

select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||decode(grantable, 'YES', ' with grant option;', ';')
 from dba_tab_privs where grantor = 'ZTDSTG';


select count(*) from dba_tab_privs where grantor = 'ZTDSTG';


GRANT SELECT ON "SYS"."OBJ$" TO "TFFMIT";
GRANT SELECT ON "SYS"."V_$SESSION" TO "TFFMIT";
GRANT SELECT ON "SYS"."V_$LOCKED_OBJECT" TO "TFFMIT";
GRANT SELECT ON "SYS"."V_$RESOURCE" TO "TFFMIT";
GRANT SELECT ON "SYS"."V_$LOCK" TO "TFFMIT";
GRANT SELECT ON "SYS"."V_$MYSTAT" TO "TFFMIT";
GRANT EXECUTE ON "SYS"."DBMS_LOCK" TO "TFFMIT";