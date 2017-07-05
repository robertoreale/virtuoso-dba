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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
