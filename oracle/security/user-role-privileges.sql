--
--  Roles and privileges granted to a user
--
--  Tested on: 11g
--

--  System privileges for a user

SELECT PRIVILEGE
  FROM sys.dba_sys_privs
 WHERE grantee = <theUser>
UNION
SELECT PRIVILEGE 
  FROM dba_role_privs rp JOIN role_sys_privs rsp ON (rp.granted_role = rsp.role)
 WHERE rp.grantee = <theUser>
 ORDER BY 1;

--  Direct grants to tables/views

SELECT owner, table_name, select_priv, insert_priv, delete_priv, update_priv, references_priv, alter_priv, index_priv 
  FROM table_privileges
 WHERE grantee = <theUser>
 ORDER BY owner, table_name;

--  Indirect grants to tables/views

SELECT DISTINCT owner, table_name, PRIVILEGE 
  FROM dba_role_privs rp JOIN role_tab_privs rtp ON (rp.granted_role = rtp.role)
 WHERE rp.grantee = <theUser>
 ORDER BY owner, table_name;
