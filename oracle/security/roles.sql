-- System privileges for a user:

SELECT PRIVILEGE
  FROM sys.dba_sys_privs
 WHERE grantee = <theUser>
UNION
SELECT PRIVILEGE 
  FROM dba_role_privs rp JOIN role_sys_privs rsp ON (rp.granted_role = rsp.role)
 WHERE rp.grantee = <theUser>
 ORDER BY 1;
