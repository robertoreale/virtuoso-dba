--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    security
--  Submodule: sec_hierarc_priv_roles_users
--  Purpose:   shows the system privileges in relation to roles that have been
--             granted this privilege and users that have been granted either
--             this privilege or a role
--  Reference: http://www.adp-gmbh.ch/ora/misc/recursively_list_privilege.html
--  Tested:    10g, 11g
--
--  Copyright (c) 2014-5 Roberto Reale
--  
--  Permission is hereby granted, free of charge, to any person obtaining a
--  copy of this software and associated documentation files (the "Software"),
--  to deal in the Software without restriction, including without limitation
--  the rights to use, copy, modify, merge, publish, distribute, sublicense,
--  and/or sell copies of the Software, and to permit persons to whom the
--  Software is furnished to do so, subject to the following conditions:
--  
--  The above copyright notice and this permission notice shall be included in
--  all copies or substantial portions of the Software.
--  
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--  DEALINGS IN THE SOFTWARE.
-- 
--------------------------------------------------------------------------------

CLEAR COLUMN

COL priv_roles_and_users FORMAT a80 HEADING "Privileges to roles and users"


SELECT
    LPAD(' ', 2 * LEVEL) || c    AS priv_roles_and_users
FROM
    (
        SELECT 
            NULL          AS p, 
            name          AS c
        FROM 
            system_privilege_map
        UNION SELECT  -- the roles-to-roles relationship
            granted_role  AS p,
            grantee       AS c
        FROM
            dba_role_privs
        UNION SELECT  -- the roles-to-privileges relationship
            privilege     AS p,
            grantee       AS c
        FROM
            dba_sys_privs
    )
START WITH p IS NULL CONNECT BY p = PRIOR c;

--  ex: ts=4 sw=4 et filetype=sql
