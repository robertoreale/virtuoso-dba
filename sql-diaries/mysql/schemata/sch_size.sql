--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    MySQL
--  Module:    schemata
--  Submodule: sch_size
--  Purpose:   aggregated size per schema per engine
--  Reference: http://code.openark.org/blog/mysql/useful-database-analysis-queries-with-information_schema
--  Tested:    MariaDB 10
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


SELECT
    table_schema,
    engine,
    COUNT(*)                          AS tables,
    SUM(data_length + index_length)   AS size,
    SUM(index_length)                 AS index_size
FROM
    information_schema.tables
WHERE
    table_schema NOT IN ('mysql', 'INFORMATION_SCHEMA') AND engine IS NOT NULL
GROUP BY
    table_schema, engine;

--  ex: ts=4 sw=4 et filetype=sql
