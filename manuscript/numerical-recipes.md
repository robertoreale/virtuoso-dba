## Numerical Recipes

### Calculate the sum of a geometric series

*Keywords*: CONNECT BY, numerical recipes

    SELECT SUM(POWER(2, -level)) sum FROM dual CONNECT BY level < &n;


### Solve Besel's problem

*Keywords*: CONNECT BY, numerical recipes

    SELECT
        SUM(POWER(level, -2))    sum,
        POWER(ATAN(1)*4, 2) / 6  pi_squared_over_six
    FROM
        dual
    CONNECT BY level < &n;


### Generate Fibonacci sequence

*Keywords*: recursive CTE, numerical recipes

*Reference*: http://www.codeproject.com/Tips/815840/Fibonacci-sequence-in-Oracle-using-sinqle-SQL-stat

At least 11g R2 is required for the recursive CTE to work.


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
                n < &m
        )
    SELECT
        f_n                       AS nth_fibonacci_number
    FROM
        fibonacci;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->