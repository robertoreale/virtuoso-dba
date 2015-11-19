--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    sessions
--  Submodule: sess_blocking_user_pairs
--  Purpose:   blocking and blocked users, with their sessions
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

COL blocking FORMAT a40
COL blocked  FORMAT a40


SELECT
    s1.username || '@' || s1.machine || ' (' || s1.sid || ')' AS blocking,
    s2.username || '@' || s2.machine || ' (' || s2.sid || ')' AS blocked
FROM
    v$lock l1 JOIN v$lock l2 USING (id1, id2)
    JOIN v$session s1 ON l1.sid = s1.sid
    JOIN v$session s2 ON l2.sid = s2.sid
WHERE
    l1.block = 1 AND l2.request > 0;

--  ex: ts=4 sw=4 et filetype=sql
