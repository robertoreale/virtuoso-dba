--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    sessions
--  Submodule: sess_io_info
--  Purpose:   lists some basic I/O statistics for each user session
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

COL status      FORMAT a10
COL oracle_user FORMAT a15
COL os_user     FORMAT a15 TRUNC
COL machine     FORMAT a15 TRUNC
COL program     FORMAT a15 TRUNC


SELECT
    s.sid                                           AS sid,
    s.serial#                                       AS serial#,
    p.spid                                          AS pid,
    s.status                                        AS status,
    to_char(logon_time, 'DD/MM/YYYY HH24:MI:SS')    AS logon_time,
    s.username                                      AS oracle_user,
    s.osuser                                        AS os_user,
    s.machine                                       AS machine,
    s.program                                       AS program,
    i.consistent_gets                               AS consistent_gets,
    i.physical_reads                                AS physical_reads
FROM
    v$session s JOIN v$sess_io i ON s.sid = i.sid
    LEFT JOIN v$session_wait   w ON s.sid = w.sid
    JOIN v$process p             ON s.paddr = p.addr
WHERE
    s.osuser IS NOT NULL AND s.username IS NOT NULL
ORDER BY
    sid, serial#;

--  ex: ts=4 sw=4 et filetype=sql
