## First Steps

### Show aggregated size per schema per engine

*Reference*: http://code.openark.org/blog/mysql/useful-database-analysis-queries-with-information_schema

    SELECT
        table_schema,
        engine,
        COUNT(*)                          AS tables,
        SUM(data_length + index_length)   AS size,
        SUM(index_length)                 AS index_size
    FROM
        information_schema.tables
    WHERE
        table_schema NOT IN ('mysql', 'INFORMATION_SCHEMA') AND engine IS NOT NULL
    GROUP BY
        table_schema, engine;

### Show aggregated index size per table

*Reference*: http://code.openark.org/blog/mysql/useful-database-analysis-queries-with-information_schema

    SELECT
        table_schema,
        table_name,
        engine, 
        SUM(data_length + index_length)   AS size,
        SUM(index_length)                 AS index_size
    FROM
        information_schema.tables
    WHERE
        table_schema NOT IN ('mysql', 'INFORMATION_SCHEMA') AND ENGINE IS NOT NULL
    GROUP BY
        table_schema, table_name;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
