--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    queries
--  Submodule: qry_basic_stats
--  Purpose:   basic aggregate performance statistics for cached query plans
--  Reference: http://viralpatel.net/blogs/useful-oracle-queries/
--  Tested:    10g, 11g
--
--  Copyright (c) 2015 Roberto Reale
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

COL sql_text FORMAT a50 TRUNCATE


SELECT
    sql_text                                                    AS sql_text,
    TRUNC(disk_reads / DECODE(executions, 0, 1, executions))    AS reads_per_execution,
    buffer_gets                                                 AS buffer_gets,
    disk_reads                                                  AS disk_reads,
    executions                                                  AS executions,
    sorts                                                       AS sorts,
    address                                                     AS address
FROM
    v$sqlarea;

--  ex: ts=4 sw=4 et filetype=sql
