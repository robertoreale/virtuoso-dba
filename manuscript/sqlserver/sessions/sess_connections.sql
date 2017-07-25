--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    sessions
--  Submodule: sess_connections
--  Purpose:   sessions <-> connections
--  Tested:    2012
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


USE master
GO

SELECT
    conn.session_id,
    sess.loginame,
    sess.login_time,
    sess.hostname,
    conn.client_net_address,
    conn.client_tcp_port,
    conn.local_net_address,
    conn.local_tcp_port,
    sess.program_name,
    sess.net_library,
    conn.encrypt_option
FROM
    sys.sysprocesses         sess
INNER JOIN
    sys.dm_exec_connections  conn
ON
    sess.spid = conn.session_id;

--  ex: ts=4 sw=4 et filetype=sql