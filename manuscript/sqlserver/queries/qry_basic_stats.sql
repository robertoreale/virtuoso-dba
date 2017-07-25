--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    queries
--  Submodule: qry_basic_stats
--  Purpose:   basic aggregate performance statistics for cached query plans
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


USE master
GO

SELECT DISTINCT TOP 10
    sql.text                                                         [Query Text],
    stats.execution_count                                            [Execution Count],
    stats.max_elapsed_time                                           [Max Elapsed Time],
    ISNULL(stats.total_elapsed_time
           / stats.execution_count, 0)                               [Avg Elapsed Time],
    stats.creation_time                                              [Plan Compiled On],
    ISNULL(stats.execution_count
           / DATEDIFF(second, stats.creation_time, GETDATE()), 0)    [Frequency]
FROM
    sys.dm_exec_query_stats stats
CROSS APPLY
    sys.dm_exec_sql_text(stats.sql_handle) sql
ORDER BY
    stats.max_elapsed_time DESC;

--  ex: ts=4 sw=4 et filetype=sql
