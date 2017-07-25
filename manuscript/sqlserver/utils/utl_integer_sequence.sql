--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    utils
--  Submodule: utl_integer_sequence
--  Purpose:   generates sequence numbers from 1 to 65536 
--  Reference: http://dwaincsql.com/2014/03/30/calendar-tables-in-t-sql/
--  Credits:   Itzik Ben-Gen
--  Tested:    2012
--
--  Copyright (c) 2015 Roberto Reale
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


WITH 
    e1(n)  AS (SELECT 1 UNION ALL SELECT 1), --2 rows
    e2(n)  AS (SELECT 1 FROM e1 a, e1 b),    --4 rows
    e4(n)  AS (SELECT 1 FROM e2 a, e2 b),    --16 rows
    e8(n)  AS (SELECT 1 FROM e4 a, e4 b),    --256 rows
    e16(n) AS (SELECT 1 FROM e8 a, e8 b)     --65536 rows
SELECT
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL))  [n]
FROM
    e16;

--  ex: ts=4 sw=4 et filetype=sql
