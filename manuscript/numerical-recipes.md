# Numerical Recipes

## Calculate the sum of a geometric series

*Keywords*: CONNECT BY, numerical recipes

    SELECT SUM(POWER(2, -level)) sum FROM dual CONNECT BY level < &n;


## Solve Besel's problem

*Keywords*: CONNECT BY, numerical recipes

    SELECT
        SUM(POWER(level, -2))    sum,
        POWER(ATAN(1)*4, 2) / 6  pi_squared_over_six
    FROM
        dual
    CONNECT BY level < &n;


## Generate Fibonacci sequence

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


## Verify that the sum of the reciprocals of factorials converge to `e'?

*Keywords*: recursive CTE, numerical recipes

    WITH factorial(n, f_n) AS
        (
            SELECT            --  base case
                1                 AS n,
                1                 AS f_n
            FROM
                dual
            UNION ALL SELECT  --  recursive definition
                n + 1             AS n,
                f_n * (n + 1)          AS f_n
            FROM
                factorial
            WHERE
                n < 50
        )
    SELECT
        1 + sum(1 / f_n) - exp(1)  AS error
    FROM
        factorial;


## Verify that the cosine function has a fixed point

*Keywords*: recursive CTE, numerical recipes, analytic functions, random values

A fixed point is a point x_0 such that x_0 = cos(x_0).

    WITH iter(x, cos_x, n) AS 
        (
            SELECT
                s.r      AS x,
                COS(s.r) AS cos_x,
                1        AS n
            FROM
                dual,
                (SELECT DBMS_RANDOM.VALUE(0, 1) r FROM dual) s
            UNION ALL
            SELECT
                COS(x)      AS x,
                COS(COS(x)) AS cos_x,
                n + 1       AS N
            FROM
                iter
            WHERE
                n < &m
        )
    SELECT
        x,
        cos_x,
        ABS(cos_x - LAG(cos_x) OVER (ORDER BY n)) distance
    FROM
        iter;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
