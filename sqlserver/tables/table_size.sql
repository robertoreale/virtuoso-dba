--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    SQL Server
--  Module:    tables
--  Submodule: tbl_sizes
--  Purpose:   sizes of tables
--  Tested:    2012
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
    tbl.name                                            [Table Name],
    scm.name                                            [Schema Name],
    prt.rows                                            [Row Counts],
    8 *  SUM(alu.total_pages)                           [Total Size (KiB)],
    8 *  SUM(alu.used_pages)                            [Used Size (KiB)],
    8 * (SUM(alu.total_pages) - SUM(alu.used_pages))    [Free Size (KiB)]
FROM
    sys.tables tbl
INNER JOIN
    sys.indexes idx ON tbl.object_id = idx.object_id
INNER JOIN
    sys.partitions prt
    ON idx.object_id = prt.object_id AND idx.index_id = prt.index_id
INNER JOIN
    sys.allocation_units alu ON prt.partition_id = alu.container_id
LEFT OUTER JOIN
    sys.schemas scm ON tbl.schema_id = scm.schema_id
GROUP BY
    tbl.name, scm.name, prt.rows;

--  ex: ts=4 sw=4 et filetype=sql
