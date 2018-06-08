## Numerical Recipes

### Generate Fibonacci sequence (OEIS A000045), recursive version

*Reference*: http://stackoverflow.com/questions/21746100/

    DECLARE @Nmax INT;
    SET @Nmax = 1000000000;

    WITH fibonacci(PrevN, N) AS
        (
            SELECT
                0, 1
            UNION ALL SELECT
                N, PrevN + N
            FROM
                fibonacci
            WHERE
                N < @Nmax
        )
    SELECT PrevN [n-th Fibonacci number] FROM fibonacci
    OPTION (MAXRECURSION 0);


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
