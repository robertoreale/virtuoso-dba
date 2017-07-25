--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    security
--  Submodule: sec_rec_granted_privs
--  Purpose:   lists ROLES, SYSTEM privileges and object privileges granted to
--             users; if a ROLE is found then it is checked recursively
--  Reference: http://www.petefinnigan.com/find_all_privs.sql
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
SET LINE 200

COL grantee      FORMAT a15 HEADING "Grantee" TRUNC
COL type         FORMAT a6  HEADING "Type"
COL privilege    FORMAT a30 HEADING "Privilege"
COL owner        FORMAT a15 HEADING "Table|Name" TRUNC
COL table_name   FORMAT a30 HEADING "Table|Name"
COL column_name  FORMAT a30 HEADING "Column|Name"
COL admin_option FORMAT a6  HEADING "Admin|Option"

BREAK ON username ON type


SELECT
    username          AS grantee,
    r.type            AS type,
    r.privilege       AS privilege,
    r.owner           AS owner,
    r.table_name      AS table_name,
    r.column_name     AS column_name,
    r.admin_option    AS admin_option
FROM
    dba_users u
JOIN
    (
        SELECT
            'ROLE'          AS type,
            grantee         AS grantee,
            granted_role    AS privilege,
            NULL            AS owner,
            NULL            AS table_name,
            NULL            AS column_name,
            admin_option    AS admin_option
        FROM
            dba_role_privs
        UNION SELECT
            'SYSTEM',
            grantee,
            privilege,
            NULL,
            NULL,
            NULL,
            admin_option
        FROM
            dba_sys_privs
        UNION SELECT
            'TABLE',
            grantee,
            privilege,
            owner,
            table_name,
            NULL,
            grantable
        FROM
            dba_tab_privs
        UNION SELECT
            'COLUMN',
            grantee,
            privilege,
            owner,
            table_name,
            column_name,
            grantable
        FROM
            dba_col_privs
    ) r
ON
    username = grantee
WHERE
    username NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP')
ORDER BY
    username, type;

--  ex: ts=4 sw=4 et filetype=sql
