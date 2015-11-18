--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    constraints
--  Submodule: constr_parenting
--  Purpose:   parent-child pairs between tables, based on reference constraints
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

COL owner             FORMAT a15
COL table_name        FORMAT a30
COL parent_owner      FORMAT a15
COL parent_table_name FORMAT a30


WITH constraints AS 
    (
        SELECT
            *
        FROM
            dba_constraints
        WHERE
            status = 'ENABLED' AND constraint_type IN ('P','R')
    )
SELECT DISTINCT
    c1.owner         AS owner,
    c1.table_name    AS table_name,
    c2.owner         AS parent_owner,
    c2.table_name    AS parent_table_name
FROM
    constraints  c1
LEFT OUTER JOIN
    constraints  c2
ON c1.r_constraint_name = c2.constraint_name;

--  ex: ts=4 sw=4 et filetype=sql
