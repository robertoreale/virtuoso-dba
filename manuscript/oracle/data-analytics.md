## Data Analytics

### List the objects in the recycle bin, sorting by the version

*Keywords*: analytical functions

    SELECT
        original_name,
        type,
        object_name,
        droptime,
        RANK() OVER (
            PARTITION BY original_name, type ORDER BY droptime DESC
        ) obj_version,
        can_purge
    FROM
        dba_recyclebin;


### Show I/O stats on datafiles

*Keywords*: dynamic views, analytical functions

    SELECT
        name,
        phyrds,
        phywrts,
        ROUND(RATIO_TO_REPORT(phyrds)  OVER () * 100, 2) AS phyrds_pct,
        ROUND(RATIO_TO_REPORT(phywrts) OVER () * 100, 2) AS phyrds_pct,
        fs.phyblkrd + fs.phyblkwrt                       AS blkio
    FROM
        gv$datafile df,
        gv$filestat fs
    WHERE
        df.file## = fs.file#
    ORDER BY
        fs.phyblkrd + fs.phyblkwrt DESC;
    
    
### Show the progressive growth in backup sets

*Keywords*: analytics functions, aggregate functions, dynamic views, rman

We use percentiles to exclude outliers.

    SELECT
        device_type,
        completion_day,
        cumu_size,
        cumu_size / LAG(cumu_size) OVER (
            ORDER BY device_type, completion_day
        ) AS ratio
    FROM (
        SELECT
            device_type,
            TRUNC(completion_time, 'DDD')                       completion_day,
            SUM(bytes)                                          cumu_size,
            NTILE(100) OVER (ORDER BY device_type, SUM(bytes))  percentile
        FROM
            v$backup_piece_details  -- gv$backup_piece_details does not exist
        GROUP BY
            device_type, TRUNC(completion_time, 'DDD')
    )
    WHERE
        percentile BETWEEN 10 AND 90;


### For each schema, calculate the correlation between the size of the tables both in bytes and as a product rows times columns

*Keywords*: aggregate functions, subqueries, logical and physical storage

    SELECT
        owner,
        CORR(bytes, num_rows * num_cols)
    FROM
        (
            SELECT
                t1.owner,
                t1.table_name,
                t1.num_rows,
                t2.num_cols,
                s.bytes
            FROM
                dba_tables t1
            JOIN
                (
                    SELECT
                        owner,
                        table_name,
                        COUNT(*) num_cols
                    FROM
                        dba_tab_columns
                    GROUP BY
                        owner, table_name
                ) t2
            ON t1.owner = t2.owner AND t1.table_name = t2.table_name
            JOIN
                dba_segments s
            ON
                    t1.owner       = s.owner
                AND t1.table_name  = s.segment_name
                AND s.segment_type = 'TABLE'
        )
    GROUP BY owner
    ORDER BY owner;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
