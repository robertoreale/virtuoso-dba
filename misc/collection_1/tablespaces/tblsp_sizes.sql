--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    tablespaces
--  Submodule: tblsp_sizes
--  Purpose:   gets the total, used and free sizes of tablespaces
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

COL tablespace FORMAT a30        HEADING "Tablespace"
COL total      FORMAT 9999999999 HEADING "Total Space (MiB)"
COL used       FORMAT 9999999999 HEADING "Used Space (MiB)"
COL free       FORMAT 9999999999 HEADING "Free Space (MiB)"
COL largest    FORMAT 9999999999 HEADING "Largest Segment (MiB)"
COL pct_used   FORMAT 999D99     HEADING "% Used"


SELECT
    NVL(b.tablespace, NVL(a.tablespace, 'UNKNOWN'))         AS tablespace,
    alloc_space                                             AS total,
    alloc_space - NVL(free_space, 0)                        AS used,
    NVL(free_space, 0)                                      AS free,
    (
        (alloc_space - NVL(free_space, 0)) / alloc_space
    ) * 100                                                 AS pct_used,
    NVL(largest, 0)                                         AS largest
FROM
    (
        SELECT
            SUM(bytes) / 1048576    AS free_space,
            MAX(bytes) / 1048576    AS largest,
            tablespace_name         AS tablespace
        FROM
            sys.dba_free_space
        GROUP BY
            tablespace_name
    ) a
LEFT JOIN
    (
        SELECT
            SUM(bytes) / 1048576    AS alloc_space,
            tablespace_name         AS tablespace
        FROM
            sys.dba_data_files
        GROUP BY
            tablespace_name
    ) b
ON
    a.tablespace = b.tablespace;

--  ex: ts=4 sw=4 et filetype=sql
