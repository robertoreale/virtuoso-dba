--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    datafiles
--  Submodule: df_io_stats
--  Purpose:   shows I/O stats on datafiles
--  Tested:    11g
--
--  Copyright (c) 2016 Roberto Reale
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
SET LINESIZE 160

COL name        HEADING "File Name" FORMAT a50 TRUNCATED
COL phyrds      HEADING "Physical Reads"
COL phywrts     HEADING "Physical Writes"
COL phyrds_pct  HEADING "Read %"
COL phywrts_pct HEADING "Write %"
COL blkio       HEADING "Block I/O's"


SELECT
    name,
    phyrds,
    phywrts,
    ROUND(phyrds  * 100 / tot.phys_reads, 2) AS phyrds_pct,
    ROUND(phywrts * 100 / tot.phys_wrts,  2) AS phywrts_pct,
    fs.phyblkrd + fs.phyblkwrt               AS blkio
FROM
    (
        SELECT
            SUM(phyrds)  AS phys_reads,
            SUM(phywrts) AS phys_wrts
        FROM
            v$filestat
    ) tot,
    v$datafile df,
    v$filestat fs
WHERE
    df.FILE# = fs.FILE#
ORDER BY
    fs.phyblkrd + fs.phyblkwrt DESC;

--  ex: ts=4 sw=4 et filetype=sql
