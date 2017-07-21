# Drawing

## Generate a histogram for the length of objects’ names

*Keywords*: formatting, analytic functions, aggregate functions, logical storage

    SELECT
        LENGTH(object_name),
        LPAD('#',
            CEIL(RATIO_TO_REPORT(
                APPROX_COUNT_DISTINCT(object_name)) OVER () * 100
            ),
            '#') AS histogram
    FROM
        dba_objects
    GROUP BY LENGTH(object_name)
    ORDER BY LENGTH(object_name);


## Build a histogram for the order of magnitude of segments’ sizes

*Keywords*: formatting, analytic functions, aggregate functions, physical storage

    SELECT
        DECODE(
            TRUNC(LOG(1024, bytes)),
            -- 0, 'bytes',
            1, 'KiB' ,
            2, 'MiB',
            3, 'GiB',
            4, 'TiB',
            5, 'PiB',
            6, 'EiB',
            7, 'ZiB',
            8, 'YiB',
            'UNKNOWN'
        )           AS order_of_magnitude,
        LPAD('#',
            CEIL(RATIO_TO_REPORT(
                APPROX_COUNT_DISTINCT(SEGMENT_NAME)) OVER () * 100
            ),
            '#')    AS histogram
    FROM
        dba_segments
    GROUP BY TRUNC(LOG(1024, bytes))
    ORDER BY TRUNC(LOG(1024, bytes));


## Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
