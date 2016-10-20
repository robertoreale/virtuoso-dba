--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    logs
--  Submodule: log_switches_breakdown
--  Purpose:   full and average number of log switches, day by day
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

COL switches              FORMAT "9999"
COL total_size_mib        FORMAT "999999.99"
COL avg_switches_per_hour FORMAT "9999.99"


SELECT
    TRUNC(first_time)              AS day,
    COUNT(*)                       AS switches,
    COUNT(*) * log_size / 1048576  AS total_size_mib,
    COUNT(*) / 24                  AS avg_switches_per_hour
FROM
    v$loghist,
    (
        SELECT AVG(bytes) AS log_size FROM v$log
    )
GROUP BY
    TRUNC(first_time),
    log_size
ORDER BY
    day;

--  ex: ts=4 sw=4 et filetype=sql
