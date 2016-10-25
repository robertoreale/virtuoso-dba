--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    sessions
--  Submodule: sess_sort_usage
--  Purpose:   sort usage per session
--  Tested:    XXX
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
SET LINE 180

COL inst_id    FORMAT '999999'
COL sid        FORMAT '999999'
COL tablespace FORMAT a15
COL contents   FORMAT a15
COL segtype    FORMAT a15
COL extents    FORMAT '999999'
COL blocks     FORMAT '999999'
COL mib        FORMAT '999999.99'


SELECT
    s.inst_id,
    s.sid,
    u.tablespace,
    u.contents,
    u.segtype,
    u.extents,
    u.blocks,
    u.blocks * p.value / 1048576  AS mib
FROM
    gv$session s,
    v$sort_usage u,
    v$system_parameter p
WHERE
    s.saddr = u.session_addr
AND
    UPPER(p.name) = 'DB_BLOCK_SIZE';

--  ex: ts=4 sw=4 et filetype=sql
