--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    sessions
--  Submodule: sess_user_sessions
--  Purpose:   user sessions on the database
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
COL serial   FORMAT '999999'
COL username FORMAT a15
COL machine  FORMAT a35
COL server   FORMAT a15
COL osuser   FORMAT a10
COL program  FORMAT a30 WORD_WRAPPED
COL spid     FORMAT '99999' HEADING "OS_PID"

SELECT
	s.sid,
	s.serial#,
	s.username,
	s.machine,
	s.server,
	s.osuser,
	s.program,
	p.spid
FROM
    v$session s JOIN v$process p
ON
	s.paddr = p.addr AND type = 'USER'
ORDER BY
    spid;

--  ex: ts=4 sw=4 et filetype=sql
