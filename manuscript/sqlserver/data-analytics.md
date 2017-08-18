## Data Analytics

### Show info about the last restore operation, for each database

*Keywords*: analytical functions

*Reference*: dba.stackexchange.com/questions/33703

    USE master
    GO

    WITH LastRestores AS
        (
            SELECT
                db.name,
                db.create_date,
                rhist.restore_date,
                rhist.destination_database_name,
                rhist.backup_set_id,
                rhist.restore_history_id,
                rownum = ROW_NUMBER() OVER (
                    PARTITION BY db.name ORDER BY rhist.restore_date DESC
                )
            FROM
                sys.databases db
            LEFT OUTER JOIN
                msdb.dbo.restorehistory rhist
            ON rhist.destination_database_name = db.name
        )
    SELECT
        name                         [Database],
        create_date                  [Creation Date],
        restore_date                 [Restore Date],
        destination_database_name    [Destination],
        backup_set_id                [Backup Set ID],
        restore_history_id           [Restore History ID]
    FROM LastRestores
        WHERE rownum = 1;


### Identife database growth rates from backups

*Keywords*: analytical functions

*Reference*: https://www.mssqltips.com/sqlservertip/3690/

    USE master
    GO

    SELECT DISTINCT
        hist.database_name                                    [Database Name],
        AVG(hist.[Backup Size (MiB)] - hist.[Previous Backup Size (MiB)]) OVER
            (
                PARTITION BY hist.database_name
            )                                                 [Avg Size Diff From Previous (MiB)],
        MAX(hist.[Backup Size (MiB)] - hist.[Previous Backup Size (MiB)]) OVER
            (
                PARTITION BY hist.database_name
            )                                                 [Max Size Diff From Previous (MiB)],
        MIN(hist.[Backup Size (MiB)] - hist.[Previous Backup Size (MiB)]) OVER
            (
                PARTITION BY hist.database_name
            )                                                 [Min Size Diff From Previous (MiB)],
        hist.[Sample Size]                                    [Sample Size]
    FROM 
        (
            SELECT
                database_name,
                COUNT(*) OVER (PARTITION BY database_name)    [Sample Size],
                CAST((backup_size / 1048576) AS INT)          [Backup Size (MiB)],
                CAST ((LAG(backup_size) OVER
                    (
                        PARTITION BY database_name ORDER BY backup_start_date
                    ) / 1048576) AS INT)                      [Previous Backup Size (MiB)]
            FROM 
                msdb..backupset
            WHERE
                type = 'D'  --full backup
        ) AS hist
    ORDER BY
        [Avg Size Diff From Previous (MiB)] DESC;


### Exercises


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
