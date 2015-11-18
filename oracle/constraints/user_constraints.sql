--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    constraints
--  Submodule: constr_xref_table
--  Purpose:   list foreign constraints associated to their reference columns
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

BREAK ON source_owner ON source_constraint_name

COL source_owner            FORMAT a10 TRUNC
COL source_constraint_name  FORMAT a20 TRUNC
COL source_table_name       FORMAT a20 TRUNC
COL source_column_name      FORMAT a30 TRUNC
COL target_owner            FORMAT a10 TRUNC
COL target_table_name       FORMAT a20 TRUNC
COL target_column_name      FORMAT a20 TRUNC


SELECT
    c.owner              AS source_owner,
    c.constraint_name    AS source_constraint_name,
    cc1.table_name       AS source_table_name,
    cc1.column_name      AS source_column_name,
    cc2.owner            AS target_owner,
    cc2.table_name       AS target_table_name,
    cc2.column_name      AS target_column_name
FROM
    all_constraints  c
JOIN
    all_cons_columns cc1
ON
    c.constraint_name = cc1.constraint_name
JOIN
    all_cons_columns cc2
ON
    c.r_constraint_name = cc2.constraint_name AND cc1.position = cc2.position
ORDER BY
    c.owner, c.constraint_name;

--  ex: ts=4 sw=4 et filetype=sql
