--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    PostgreSQL
--  Module:    queries
--  Submodule: qry_basic_stats
--  Purpose:   show running queries
--  Reference: https://gist.github.com/rgreenjr/3637525
--  Tested:    9.2.13
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


SELECT
    pid,
    AGE(query_start, CLOCK_TIMESTAMP()),
    usename,
    query 
FROM
    pg_stat_activity 
WHERE
    query <> '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%' 
ORDER BY
    query_start DESC;

--  ex: ts=4 sw=4 et filetype=sql
