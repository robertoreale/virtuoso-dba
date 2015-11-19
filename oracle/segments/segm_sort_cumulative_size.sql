--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    segments
--  Submodule: segm_sort_cumulative_size
--  Purpose:   cumulative size of sort segments
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

COL tablespace FORMAT a30
COL mib_total    HEADING "Total (MiB)"
COL mib_used     HEADING "Used (MiB)"
COL mib_free     HEADING "Free (MiB)"


SELECT
    ss.tablespace_name                                            AS tablespace,
    sf.mib_total                                                  AS mib_total,
    SUM(ss.used_blocks * sf.block_size) / 1048576                 AS mib_used,
    sf.mib_total - SUM(ss.used_blocks * sf.block_size) / 1048576  AS mib_free
FROM
    v$sort_segment ss
JOIN
    (
        SELECT
            ts.name                    AS tbs_name,
            tmpf.block_size            AS block_size,
            SUM(tmpf.bytes) / 1048576  AS mib_total
        FROM
            v$tablespace ts JOIN v$tempfile tmpf
        ON       ts.ts# = tmpf.ts#
        GROUP BY ts.name, tmpf.block_size
    ) sf
ON        ss.tablespace_name = sf.tbs_name
GROUP BY  ss.tablespace_name, sf.mib_total;

--  ex: ts=4 sw=4 et filetype=sql
