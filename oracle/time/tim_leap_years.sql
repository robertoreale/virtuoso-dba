--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    time
--  Submodule: tim_leap_years
--  Purpose:   lists leap years from 1 AD
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
COL year    FORMAT 9999
COL is_leap FORMAT a7


SELECT
    year,
    CASE
        WHEN
            TO_CHAR(LAST_DAY(TO_DATE('0102'||TO_CHAR(year), 'DDMMYYYY')), 'DD') = '29'
        THEN
            'Y'
        ELSE
            'N'
    END is_leap
FROM
    (
        SELECT 1 AS year FROM DUAL
    ) t
--  cf. http://stackoverflow.com/questions/2847226/
MODEL
    DIMENSION BY (ROWNUM r)
    MEASURES (year)
    RULES ITERATE (9999)
        (
            year[ITERATION_NUMBER] = CV(r) + 1
        )
ORDER BY 1;

--  ex: ts=4 sw=4 et filetype=sql
