## Time Functions

### Show database growth from backups

*Keywords*: time functions, aggregate functions

*Reference*: http://www.sqlskills.com/blogs/erin/trending-database-growth-from-backups/

    USE master
    GO

    SELECT
        database_name                                [Database],
        DATEPART(year, backup_start_date)            [Year],
        DATEPART(month, backup_start_date)           [Month],
        AVG(backup_size / 1048576)                   [Backup Size MiB],
        AVG(compressed_backup_size / 1048576)        [Compressed Backup Size MiB],
        AVG(backup_size / compressed_backup_size)    [Compression Ratio]
    FROM
        msdb.dbo.backupset
    WHERE
        type = 'D'
    GROUP BY
        database_name,
        DATEPART(year,  backup_start_date),
        DATEPART(month, backup_start_date)
    ORDER BY
        database_name,
        DATEPART(year,  backup_start_date),
        DATEPART(month, backup_start_date);


### Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
