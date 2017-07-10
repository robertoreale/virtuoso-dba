# Drawing

## Generate a histogram for the length of objects’ names

*Keywords*: formatting, analytic functions, aggregate functions

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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
