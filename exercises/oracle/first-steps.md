## First Steps

### List foreign constraints associated to their reference columns.

    SELECT
        c.owner              AS source_owner,
        c.constraint_name    AS source_constraint_name,
        cc1.table_name       AS source_table_name,
        cc1.column_name      AS source_column_name,
        cc2.owner            AS target_owner,
        cc2.table_name       AS target_table_name,
        cc2.column_name      AS target_column_name
    FROM
        all_constraints  c
    JOIN
        all_cons_columns cc1
    ON
        c.constraint_name = cc1.constraint_name
    JOIN
        all_cons_columns cc2
    ON
        c.r_constraint_name = cc2.constraint_name AND cc1.position = cc2.position
    ORDER BY
        c.owner, c.constraint_name;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
