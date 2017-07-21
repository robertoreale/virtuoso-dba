# Time Functions

## Show the first and last day of the current month

*Keywords*: time functions

    SELECT
        TRUNC(SYSDATE, 'MONTH')   first_day_curr_month,
        TRUNC(LAST_DAY(SYSDATE))  last_day_curr_month
    FROM
        dual;


## Show the first and last day of the current month

*Keywords*: time functions

*Reference*: http://viralpatel.net/blogs/useful-oracle-queries/

    SELECT
        TRUNC(SYSDATE, 'YEAR')                      first_day_curr_year,
        ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 12) - 1  last_day_curr_year
    FROM
        dual;


## Show the maximum possible date

*Keywords*: time functions

*Reference*: http://stackoverflow.com/questions/687510/

December 31, 9999 CE, one second to midnight.

    SELECT
        TO_CHAR(
            TO_DATE('9999-12-31', 'YYYY-MM-DD')
            + (1 - 1/24/60/60),
        'DD-MON-YYYY hh12:mi:ss AD') AS latest_date
    FROM
        dual;


## Show the minimum possible date

*Keywords*: time functions

*Reference*: http://stackoverflow.com/questions/687510/, Oracle bug 106242

    SELECT 
        TO_CHAR(TO_DATE(1, 'J'), 'DD-MON-YYYY hh12:mi:ss AD') AS earliest_date
    FROM
        dual;


## List leap years from 1 AD

*Keywords*: time functions

    SELECT
        level AS year
    FROM
        dual
    WHERE TO_CHAR(LAST_DAY(TO_DATE('0102'||TO_CHAR(level), 'DDMMYYYY')), 'DD') = '29'
    CONNECT BY LEVEL < 10000;


## Count audit records for the last hour

*Keywords*: time functions, audit

    SELECT
        COUNT(*)  AS count_last_hour
    FROM
        sys.aud$
    WHERE
        CAST((FROM_TZ(ntimestamp#, '00:00') AT local) AS date)
            < SYSDATE - INTERVAL '1' HOUR;


## Calculate the calendar date of Easter, from 1583 to 2999

*Keywords*: time functions, multiple WITH clauses

*Reference*: http://www.adp-gmbh.ch/ora/plsql/calendar.html

    WITH
        t0 AS
            (
                SELECT
                    LEVEL + 1582 AS year
                FROM
                    dual
                CONNECT BY LEVEL <= 2299 - 1582
            ),
        t1 AS
        (
            SELECT
                year,
                CASE
                    WHEN year < 1700 THEN 22
                    WHEN year < 1900 THEN 23
                    WHEN year < 2200 THEN 24
                    ELSE 25
                END AS m,
                CASE
                    WHEN year < 1700 THEN 2
                    WHEN year < 1800 THEN 3
                    WHEN year < 1900 THEN 4
                    WHEN year < 2100 THEN 5
                    WHEN year < 2200 THEN 6
                    ELSE 0
                END AS n,
                MOD(year, 19) AS a,
                MOD(year, 4)  AS b,
                MOD(year, 7)  AS c
            FROM
                t0
        ),
        t2 AS
        (
            SELECT
                year, m, n, a, b, c,
                MOD(19 * a + m, 30) AS d
            FROM
                t1
        ),
        t3 AS
        (
            SELECT
                year, m, n, a, b, c, d,
                MOD(2 * b + 4 * c + 6 * d + n, 7) AS e
            FROM
                t2
        ),
        t4 AS
        (
            SELECT
                year, m, n, a, b, c, d, e,
                22 + d + e AS day,
                3          AS month
            FROM
                t3
        ),
        t5 AS
        (
            SELECT
                year, m, n, a, b, c, d, e,
                CASE
                    WHEN day > 31 THEN day - 31
                    ELSE day
                END AS day,
                CASE
                    WHEN day > 31 THEN month + 1
                    ELSE month
                END AS month
            FROM
                t4
        ),
        t6 AS
        (
            SELECT
                year,
                CASE
                    WHEN day = 26 AND month = 4 THEN 19
                    WHEN day = 25 AND month = 4 AND d = 28 AND e = 6 AND a > 10 THEN 18
                    ELSE day
                END AS day,
                month
            FROM
                t5
        ),
        t7 AS
        (
            SELECT
                year,
                TO_DATE(
                    TO_CHAR(day,    '00'  ) ||
                    TO_CHAR(month,  '00'  ) ||
                    TO_CHAR(year,   '0000'),
                    'DDMMYYYY'
                ) AS easter_sunday
            FROM
                t6
        )
    SELECT
        year                  AS year,
        easter_sunday - 52    AS jeudi_gras,
        easter_sunday - 48    AS carnival_monday,
        easter_sunday - 47    AS mardi_gras,
        easter_sunday - 46    AS ash_wednesday,
        easter_sunday - 7     AS palm_sunday,
        easter_sunday - 3     AS maundy_thursday,
        easter_sunday - 2     AS good_friday,
        easter_sunday - 1     AS holy_saturday,
        easter_sunday         AS easter_sunday,
        easter_sunday + 1     AS easter_monday,
        easter_sunday + 39    AS ascension_of_christ,
        easter_sunday + 49    AS whitsunday,
        easter_sunday + 50    AS whitmonday,
        easter_sunday + 60    AS corpus_christi
    FROM
        t7;


## Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
