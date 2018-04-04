## Storing Objects

### List the top-n largest objects

*Keywords*: limiting query result, physical storage

    SELECT * FROM
    (
        SELECT
            owner,
            segment_name         AS segment,
            segment_type         AS type,
            tablespace_name      AS tablespace,
            bytes / 1024 / 1024  AS mib_total
        FROM dba_segments ORDER BY bytes DESC
    ) WHERE ROWNUM <= &n;

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
