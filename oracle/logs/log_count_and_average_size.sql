--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    logs
--  Submodule: log_count_and_average_size
--  Purpose:   computes count of archived logs and their average size
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


SELECT
    lh.*,
    lg.*,
    ROUND(lh.archived# * lg.avg_mib)             AS daily_avg_mib
FROM
    (
        SELECT
            TO_CHAR(first_time, 'YYYY-MM-DD')    AS day,
            COUNT(1)                             AS archived#,
            MIN(recid)                           AS min#,
            MAX(recid)                           AS max# 
        FROM
            gv$log_history
        GROUP BY
            TO_CHAR(first_time, 'YYYY-MM-DD')
        ORDER BY 1 DESC
    ) lh,
    (
        SELECT
            COUNT(1)                             AS members#,
            MAX(bytes) / 1048576                 AS max_mib, 
            MIN(bytes) / 1048576                 AS min_mib,
            AVG(bytes) / 1048576                 AS avg_mib
        FROM
            gv$log
    ) lg;

--  ex: ts=4 sw=4 et filetype=sql
