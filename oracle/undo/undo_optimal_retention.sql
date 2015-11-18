--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    undo
--  Submodule: undo_optimal_retention
--  Purpose:   compute optimal UNDO retention by the formula
--                                                 actual_undo_size
--               optimal_undo_retention = -----------------------------------
--                                        db_block_size * undo_blocks_per_sec
--  Reference: http://www.akadia.com/services/ora_optimize_undo.html
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

COL actual_undo_size   HEADING "Actual Undo Size [MiB]"
COL undo_retention     HEADING "Undo Retention [sec]" FORMAT a25
COL opt_undo_retention HEADING "Optimal Undo Retention [sec]"


SELECT
    a.undo_size / 1048576                                        AS actual_undo_size,
    SUBSTR(c.undo_retention, 1, 25)                              AS undo_retention,
    ROUND(a.undo_size / (d.db_block_size * b.blocks_per_sec))    AS opt_undo_retention
FROM
    (
        --  actual undo size
        SELECT
            SUM(v$df.bytes) undo_size
        FROM
            v$datafile   v$df
        JOIN
            v$tablespace v$ts  ON v$df.ts# = v$ts.ts#
        JOIN
            dba_tablespaces ts ON v$ts.name = ts.tablespace_name
        WHERE
            ts.contents = 'UNDO' AND ts.status = 'ONLINE'
    ) a,
    (
        --  undo blocks per second
        SELECT
            MAX(undoblks / ((end_time - begin_time) * 3600 * 24)) blocks_per_sec
        FROM
            v$undostat
    ) b,
    (
        SELECT
            value undo_retention
        FROM
            v$parameter
        WHERE
            name = 'undo_retention'
    ) c,
    (
        SELECT
            TO_NUMBER(value) db_block_size
        FROM
            v$parameter
        WHERE
            name = 'db_block_size'
    ) d;

--  ex: ts=4 sw=4 et filetype=sql
