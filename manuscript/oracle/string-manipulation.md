## String Manipulation

### Calculate the minimum, median, and maximum edit distances between a table's name and the names of its indexes

*Keywords*: edit distance for strings, ROLLUP

    SELECT
        owner,
        table_name,
           MIN(UTL_MATCH.EDIT_DISTANCE(table_name, index_name)) min_edit_distance,
        MEDIAN(UTL_MATCH.EDIT_DISTANCE(table_name, index_name)) median_edit_distance,
           MAX(UTL_MATCH.EDIT_DISTANCE(table_name, index_name)) max_edit_distance
    FROM
        dba_indexes
    GROUP BY ROLLUP (owner, table_name)
    ORDER BY         owner, table_name;


### Get the number of total waits for each event type, with pretty formatting

*Keywords*: formatting, analytic functions, dynamic views

    WITH se AS (
      SELECT event ev, total_waits tw FROM v$system_event
    )
    SELECT
      RPAD(ev, MAX(LENGTH(ev)+2) OVER (), '.') ||
      LPAD(tw, MAX(LENGTH(tw)+2) OVER (), '.') total_waits_per_event_type
    FROM
        se;

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
