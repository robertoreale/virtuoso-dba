--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    logs
--  Submodule: log_files_info
--  Purpose:   shows basic info about log files
--  Reference: http://dba.stackexchange.com/questions/21805/
--  Tested:    10g, 11g
--
--  Copyright (c) 2014-6 Roberto Reale
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
SET LINE 300
COL file_name FORMAT a60


SELECT
    lg.group#             AS group#,
    lg.thread#            AS thread#,
    lg.sequence#          AS sequence#,
    lg.archived           AS archived,
    lg.status             AS status,
    lf.member             AS file_name,
    lg.bytes / 1048576    AS file_size
FROM
    gv$log lg
JOIN
    gv$logfile lf
ON
    lg.group# = lf.group# 
ORDER BY
    lg.group# ASC;

--  ex: ts=4 sw=4 et filetype=sql
