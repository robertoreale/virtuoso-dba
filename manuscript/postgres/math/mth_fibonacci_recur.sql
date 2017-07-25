--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    PostgreSQL
--  Module:    math
--  Submodule: mth_fibonacci_recur
--  Purpose:   generate Fibonacci sequence (OEIS A000045), recursive version
--  Reference: http://old.storytotell.org/blog/2009/08/12/fibonacci-in-postgresql.html
--  Note:      the NUMERIC type is mandatory when doing arbitrary-precision math
--  Tested:    9.2.13
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


WITH RECURSIVE fibonacci(f_n, f_n_prev) AS
    (
        SELECT
            1,
            0
        UNION SELECT
            1 :: NUMERIC,
            1 :: NUMERIC
        UNION SELECT
            f_n + f_n_prev,
            f_n
        FROM
            fibonacci
    )
SELECT
    f_n AS nth_fibonacci_number
FROM
    fibonacci
LIMIT 100;

--  ex: ts=4 sw=4 et filetype=sql
