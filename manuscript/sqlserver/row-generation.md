## Row Generation

### Generate integer numbers from 1 to 65536 

*Reference*: http://dwaincsql.com/2014/03/30/calendar-tables-in-t-sql/

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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
