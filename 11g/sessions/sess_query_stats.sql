--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    sessions
--  Submodule: sess_query_info
--  Purpose:   elapsed time and SQL text of queries, per session
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

COL sid      FORMAT 999
COL username FORMAT a15 TRUNC
COL machine  FORMAT a15 TRUNC
COL sql_text FORMAT a80 WORD_WRAPPED
COL elapsed  FORMAT a8

SET LINE 200
BREAK ON sid ON serial# ON sql_id ON status ON username ON machine ON elapsed


SELECT
    sid                                  AS sid,
    serial#                              AS serial#,
    sql_id                               AS sql_id,
    status                               AS status,
    nvl(username, 'ORACLE PROC')         AS username,
    machine                              AS machine,
    hours||':'||minutes||':'||seconds    AS elapsed,
    sql_text                             AS sql_text
FROM
    (
        SELECT
            s.sid                                                    AS sid,
            s.serial#                                                AS serial#,
            username                                                 AS username,
            status                                                   AS status,
            machine                                                  AS machine,
            sql.sql_id                                               AS sql_id,
            sql_text                                                 AS sql_text,
            piece                                                    AS piece,
            --  the next 3 lines convert seconds to hh:mm:ss
            --  from 12c onwards why not to use a WITH FUNCTION clause?
            TO_CHAR(TRUNC(last_call_et / 3600), 'FM9900')            AS hours,
            TO_CHAR(TRUNC(MOD(last_call_et ,3600) / 60),'FM00')      AS minutes,
            TO_CHAR(MOD(last_call_et, 60), 'FM00')                   AS seconds
        FROM
            v$session s JOIN v$sqltext sql 
        ON
            s.sql_address = sql.address AND s.sql_hash_value = sql.hash_value
    )
ORDER BY
    sid, serial#, sql_id, piece;

--  ex: ts=4 sw=4 et filetype=sql
