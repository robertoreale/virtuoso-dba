-- 
-- List of PRIV and ROLE in hierarchical view
-- 
-- Tested on: 10g, 11g
--
set line 150
select lpad(' ', 2*level) || granted_role "User, his roles and privileges" from (
select null grantee, username granted_role from dba_users where username like upper('<USERNAME>')
union select grantee, granted_role from dba_role_privs
union select grantee, privilege from dba_sys_privs)
start with grantee is null connect by grantee = prior granted_role
/
