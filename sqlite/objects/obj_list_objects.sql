--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQLite
--  Module:    objects
--  Submodule: obj_list_objects
--  Purpose:   describes all tables and views defined in the current database
--  Reference: https://www.sqlite.org/cvstrac/wiki?p=InformationSchema
--  Tested:    3.7.17
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


.headers on
.mode column


SELECT
    'main'      AS TABLE_CATALOG,
    'sqlite'    AS TABLE_SCHEMA,
    tbl_name    AS TABLE_NAME,
    CASE
        WHEN type = 'table' THEN 'BASE TABLE'
        WHEN type = 'view'  THEN 'VIEW'
    END         AS TABLE_TYPE,
    sql         AS TABLE_SOURCE
FROM
    sqlite_master
WHERE
    type IN ('table', 'view') AND tbl_name NOT LIKE 'INFORMATION_SCHEMA_%'
ORDER BY
    table_type,
    table_name;

--  ex: ts=4 sw=4 et filetype=sql
