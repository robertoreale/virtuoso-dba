## Time Functions

### List leap years from 1 AD

*Keywords*: time functions

    SELECT
        level AS year
    FROM
        dual
    WHERE TO_CHAR(LAST_DAY(TO_DATE('0102'||TO_CHAR(level), 'DDMMYYYY')), 'DD') = '29'
    CONNECT BY LEVEL < 10000;


### Count audit records for the last hour

*Keywords*: time functions, audit

    SELECT
        COUNT(*)  AS count_last_hour
    FROM
        sys.aud$
    WHERE
        CAST((FROM_TZ(ntimestamp##, '00:00') AT local) AS date)
            < SYSDATE - INTERVAL '1' HOUR;


### Count log file switches, day by day, hour by hour

*Keywords*: time functions, PIVOT, dynamic views

    SELECT * FROM
        (
            SELECT
                TRUNC(first_time, 'DDD') day,
                EXTRACT(hour FROM CAST(first_time AS TIMESTAMP)) hour
            FROM
                gv$log_history
        )
    PIVOT
        (
            COUNT(hour) FOR hour IN
                (
                    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                    13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
                )
        );



<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
