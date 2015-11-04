--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    indexes
--  Submodule: idx_last_rebuild
--  Purpose:   last rebuild time for indexes
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

COL owner     FORMAT a10
COL name      FORMAT a30
COL temporary FORMAT a9


SELECT
    dbo.owner                                    AS owner,
    dbi.index_name                               AS name,
    dbo.created                                  AS created,
    dbo.last_ddl_time                            AS rebuilt,
    --  "Indexes can be created on temporary tables.  They are also temporary
    --  and the data in the index has the same session or transaction scope as
    --  the data in the underlying table."
    --                                   (Oracle Database Administrator's Guide) 
    DECODE(dbt.temporary, 'Y', 'TBL+', '')
        ||DECODE(dbi.temporary, 'Y', 'IDX', '')  AS temporary
FROM
    dba_objects dbo
JOIN
    dba_indexes dbi
        ON (dbo.owner = dbi.owner AND dbo.object_name = dbi.index_name)
JOIN
    dba_tables  dbt 
        ON (dbi.owner = dbo.owner AND dbi.table_name = dbt.table_name)
WHERE
    object_type = 'INDEX';


--  ex: ts=4 sw=4 et filetype=sql
