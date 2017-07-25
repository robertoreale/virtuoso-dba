## First Steps

### Show the size of all the databases

*Keywords*: 

*Reference*: https://gist.github.com/rgreenjr/3637525

    SELECT
        datname,
        PG_SIZE_PRETTY(PG_DATABASE_SIZE(datname))
    FROM
        pg_database
    ORDER BY
        PG_DATABASE_SIZE(datname) DESC;


### Display cache hit rates

*Keywords*: aggregate functions

*Reference*: https://gist.github.com/rgreenjr/3637525

    SELECT
        SUM(heap_blks_read)                                                AS heap_read,
        SUM(heap_blks_hit)                                                 AS heap_hit,
        (SUM(heap_blks_hit) - SUM(heap_blks_read)) / SUM(heap_blks_hit)    AS ratio
    FROM
        pg_statio_user_tables;


### Count index blocks in cache

*Keywords*: aggregate functions

*Reference*: https://gist.github.com/rgreenjr/3637525

    SELECT
        SUM(idx_blks_read)                                              AS idx_read,
        SUM(idx_blks_hit)                                               AS idx_hit,
        (SUM(idx_blks_hit) - SUM(idx_blks_read)) / SUM(idx_blks_hit)    AS ratio
    FROM
        pg_statio_user_indexes;


### Display table index usage rates

*Reference*: https://gist.github.com/rgreenjr/3637525

    SELECT
        relname                                   AS relname,
        100 * idx_scan / (seq_scan + idx_scan)    AS percent_of_times_index_used,
        n_live_tup                                AS rows_in_table
    FROM
        pg_stat_user_tables 
    ORDER BY
        n_live_tup DESC;


### Show running queries

*Reference*: https://gist.github.com/rgreenjr/3637525

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


### Generate the Fibonacci sequence, recursively

*Reference*: http://old.storytotell.org/blog/2009/08/12/fibonacci-in-postgresql.html

The NUMERIC type is mandatory when doing arbitrary-precision math.

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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
