# Numerical Recipes

## Generate the English alphabet

*Keywords*: CONNECT BY, ASCII

    SELECT
        CHR(rownum + 64) letter
    FROM
        (
            SELECT level FROM dual CONNECT BY level < 27
        );


## Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
