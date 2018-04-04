## Storing Objects

### List the top-10 largest objects

*Keywords*: limiting query result, physical storage

How to list the top 10 largest objects?

As long as physical storage is concerned, Oracle has the concept of segments, where each segment is a set of extents allocated for a specific database object (a table, an index, ...). The data about all the segments in the database can be accessed in the `dba_segments` view.

MariaDB, on the other hand, lacks the concept of segments. Information about an object size can be gathered by accessing the `tables` view in the `information_schema` database.


**Oracle version**

    SELECT * FROM
    (
        SELECT
            owner                AS schema,
            segment_name         AS object_name,
            segment_type         AS object_type,
            bytes / 1024 / 1024  AS mib_total
        FROM dba_segments ORDER BY bytes DESC
    ) WHERE ROWNUM <= 10;


**MariaDB version**

    SELECT 
         table_schema                                           AS `schema`,
         table_name                                             AS `object_name`,
         'TABLE'                                                AS `object_type`,
         round(((data_length + index_length) / 1024 / 1024), 2) AS `mib_total`
    FROM
        information_schema.tables 
    ORDER BY
        (data_length + index_length) DESC
    LIMIT 10;

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
