## Grouping and Reporting

### Count the data files for each tablespaces and for each filesystem location

*Keywords*: grouping, regular expressions

Assume a Unix filesystem, donât follow symlinks.  Moreover, generate subtotals for each of the two dimensions (*scil*. tablespace and filesystem location).
 
    WITH df AS (
        SELECT
            tablespace_name,
            REGEXP_REPLACE(file_name, '/[^/]+$', '') dirname,
            REGEXP_SUBSTR (file_name, '/[^/]+$')     basename
        FROM
            dba_data_files
    )
    SELECT
        tablespace_name,
        dirname         path,
        COUNT(basename) file_count
    from
        df
    GROUP BY CUBE(tablespace_name, dirname)
    ORDER BY tablespace_name, dirname;


### Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
