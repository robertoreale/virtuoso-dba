--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    dg
--  Submodule: dg_standby_logs_applied
--  Purpose:   basic info about applied logs at the standby site
--  Reference: https://mdinh.wordpress.com/2015/02/20/oracle-manual-standby-applying-log/
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

COL thrd     HEADING "Thread"
COL almax    HEADING "Last Seq Received"
COL lhmax    HEADING "Last Seq Applied"


SELECT
    al.thrd,
    almax,
    lhmax
FROM
    (
        SELECT
            thread#           AS thrd,
            MAX(sequence#)    AS almax
        FROM
            v$archived_log
        WHERE
            resetlogs_change# = (SELECT resetlogs_change# FROM v$database)
                AND applied = 'YES'
        GROUP BY
            thread#
    ) al,
    (
        SELECT
            thread#           AS thrd,
            MAX(sequence#)    AS lhmax
        FROM
            v$log_history
        WHERE
            first_time = (SELECT MAX(first_time) FROM v$log_history)
        GROUP BY
            thread#
    ) lh
WHERE
    al.thrd = lh.thrd;

--  ex: ts=4 sw=4 et filetype=sql
