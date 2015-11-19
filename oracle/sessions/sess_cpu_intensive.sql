--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    sessions
--  Submodule: sess_cpu_intensive
--  Purpose:   shows sessions with highest CPU usage
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

COL sid      FORMAT '999999'
COL serial#  FORMAT '999999'
COL spid     FORMAT '99999'
COL cpu_sec  FORMAT '999,999.9999'


SELECT
    s.sid             AS sid,
    s.serial#         AS serial#,
    p.spid            AS os_pid,
    s.osuser          AS os_user,
    s.module          AS module,
    st.value / 100    AS cpu_sec
FROM
    v$session s JOIN v$process p ON s.paddr = p.addr
    JOIN v$sesstat  st ON s.sid = st.sid
    JOIN v$statname sn USING (statistic#)
WHERE
    sn.name = 'CPU used by this session'     -- CPU
    AND s.last_call_et < 1800                -- active within last 1/2 hour
    AND s.logon_time > (SYSDATE - 240/1440)  -- sessions logged on within 4 hours
ORDER BY st.value DESC;

--  ex: ts=4 sw=4 et filetype=sql
