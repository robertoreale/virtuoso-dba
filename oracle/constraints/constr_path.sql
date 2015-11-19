--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    constraints
--  Submodule: constr_path
--  Purpose:   displays reference graph between tables
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
COL path FORMAT a100 WORD_WRAPPED


WITH constraints AS 
    (
        SELECT
            *
        FROM
            all_constraints
        WHERE
            status = 'ENABLED' AND constraint_type IN ('P','R')
    ),
constraint_tree AS
    (
        SELECT DISTINCT
            c1.owner || '.' || c1.table_name 
                AS table_name,
            NVL2(c2.table_name, c2.owner || '.' || c2.table_name, NULL)
                AS parent_table_name
        FROM
            constraints c1
        LEFT OUTER JOIN
            constraints c2
        ON c1.r_constraint_name = c2.constraint_name
    )
SELECT
    SYS_CONNECT_BY_PATH(table_name, ' -> ') AS path
FROM
    constraint_tree
WHERE
    LEVEL > 1 AND CONNECT_BY_ISLEAF = 1
START WITH
    parent_table_name IS NULL
CONNECT BY
    NOCYCLE parent_table_name = PRIOR table_name
ORDER BY
    path;

--  ex: ts=4 sw=4 et filetype=sql
