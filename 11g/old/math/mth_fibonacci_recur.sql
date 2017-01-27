--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    math
--  Submodule: mth_fibonacci_recur
--  Purpose:   generate Fibonacci sequence (OEIS A000045), recursive version
--  Reference: http://www.codeproject.com/Tips/815840/Fibonacci-sequence-in-Oracle-using-sinqle-SQL-stat
--  Note:      at least 11g R2 is required for the recursive CTE to work
--  Tested:    11g R2
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

CLEAR COLUMN
COL nth_fibonacci_number FORMAT 9999999999999999999999999 HEADING "n-th Fibonacci number"


WITH fibonacci(n, f_n, f_n_next) AS
    (
        SELECT            --  base case
            1                 AS n,
            0                 AS f_n,
            1                 AS f_n_next
        FROM
            dual
        UNION ALL SELECT  --  recursive definition
            n + 1             AS n,
            f_n_next          AS f_n,
            f_n + f_n_next    AS f_n_next
        FROM
            fibonacci
        WHERE
            n < 100
    )
SELECT
    f_n                       AS nth_fibonacci_number
FROM
    fibonacci;

--  ex: ts=4 sw=4 et filetype=sql
