## First Steps

--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    PostgreSQL
--  Module:    dbs
--  Submodule: db_size
--  Purpose:   shows the size of all the databases
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
    datname,
    PG_SIZE_PRETTY(PG_DATABASE_SIZE(datname))
FROM
    pg_database
ORDER BY
    PG_DATABASE_SIZE(datname) DESC;

--  ex: ts=4 sw=4 et filetype=sql
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
--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    PostgreSQL
--  Module:    stats
--  Submodule: st_cache_hits
--  Purpose:   displays cache hit rates
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
    SUM(heap_blks_read)                                                AS heap_read,
    SUM(heap_blks_hit)                                                 AS heap_hit,
    (SUM(heap_blks_hit) - SUM(heap_blks_read)) / SUM(heap_blks_hit)    AS ratio
FROM
    pg_statio_user_tables;

--  ex: ts=4 sw=4 et filetype=sql
--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    PostgreSQL
--  Module:    stats
--  Submodule: st_idx_blks_hits
--  Purpose:   how many index blocks are in cache?
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
    SUM(idx_blks_read)                                              AS idx_read,
    SUM(idx_blks_hit)                                               AS idx_hit,
    (SUM(idx_blks_hit) - SUM(idx_blks_read)) / SUM(idx_blks_hit)    AS ratio
FROM
    pg_statio_user_indexes;

--  ex: ts=4 sw=4 et filetype=sql
--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    PostgreSQL
--  Module:    stats
--  Submodule: st_table_idx_usage
--  Purpose:   displays table index usage rates
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
    relname                                   AS relname,
    100 * idx_scan / (seq_scan + idx_scan)    AS percent_of_times_index_used,
    n_live_tup                                AS rows_in_table
FROM
    pg_stat_user_tables 
ORDER BY
    n_live_tup DESC;

--  ex: ts=4 sw=4 et filetype=sql
<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
