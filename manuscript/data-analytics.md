# Data Analytics

## Rank all the tables in the system based on their cardinality

*Keywords*: analytical functions

We partition the result set by tablespace.

    SELECT
        tablespace_name,
        owner,
        table_name,
        num_rows,
        RANK() OVER (
            PARTITION BY tablespace_name ORDER BY num_rows DESC
        ) AS rank
    FROM
        dba_tables
    WHERE
        num_rows IS NOT NULL
    ORDER BY
        tablespace_name;


## List the objects in the recycle bin, sorting by the version

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


## Show I/O stats on datafiles

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
        df.file# = fs.file#
    ORDER BY
        fs.phyblkrd + fs.phyblkwrt DESC;
    
    
## List statspack snapshots

*Keywords*: analytics functions, statspack

    SELECT
        dbid                                                             AS dbid,
        instance_number                                                  AS instance_number,
        trunc(snap_time, 'DAY')                                          AS snap_day,
        snap_id                                                          AS start_snap,
        LEAD(snap_id) OVER (ORDER BY snap_time)                          AS stop_snap,
        TO_CHAR(snap_time, 'HH24:MI')                                    AS start_time,
        LEAD(TO_CHAR(snap_time, 'HH24:MI')) OVER (ORDER BY snap_time)    AS stop_time
    FROM
        stats$snapshot;


## XXX
select
device_type,
completion_day,
cumu_size,
cumu_size/lag(cumu_size) over (order by device_type, completion_day) ratio
from (
select
  device_type,
  trunc(completion_time, 'DAY') completion_day,
  sum(bytes) cumu_size,
  ntile(100) over (order by device_type, sum(bytes)) percentile
from v$backup_piece_details group by device_type,  trunc(completion_time, 'DAY'))
where percentile between 10 and 90;


## List top-10 CPU-intensive queries

*References*: https://community.oracle.com/thread/1101381

    WITH snaps AS
        (
            SELECT
                dbid                                                             AS dbid,
                instance_number                                                  AS instance_number,
                TO_CHAR(snap_time, 'DD/MM/YYYY')                                 AS snap_day,
                snap_id                                                          AS start_snap,
                LEAD(snap_id) OVER (ORDER BY snap_time)                          AS stop_snap,
                TO_CHAR(snap_time, 'HH24:MI')                                    AS start_time,
                LEAD(TO_CHAR(snap_time, 'HH24:MI')) OVER (ORDER BY snap_time)    AS stop_time
            FROM
                stats$snapshot
        ),
    work AS
        (
            SELECT 
                s.snap_day                                              AS snap_day,
                s.start_snap                                            AS start_snap,
                s.stop_snap                                             AS stop_snap,
                s.start_time                                            AS start_time,
                s.stop_time                                             AS stop_time,
                ss1.hash_value                                          AS hash_value,
                ss1.module                                              AS module,
                ss1.text_subset                                         AS text_subset,
                SUM(ss1.buffer_gets    - NVL(ss2.buffer_gets, 0))       AS bg,
                SUM(ss1.executions     - NVL(ss2.executions, 0))        AS ex,
                SUM(ss1.cpu_time       - NVL(ss2.cpu_time, 0))          AS ct,
                SUM(ss1.elapsed_time   - NVL(ss2.elapsed_time, 0))      AS et,
                SUM(ss1.rows_processed - NVL(ss2.rows_processed, 0))    AS rp,
                SUM(ss1.disk_reads     - NVL(ss2.disk_reads, 0))        AS dr,
                SUM(ss1.parse_calls    - NVL(ss2.parse_calls, 0))       AS pc,
                SUM(ss1.invalidations  - NVL(ss2.invalidations, 0))     AS iv,
                SUM(ss1.loads          - NVL(ss2.loads, 0))             AS ld
            FROM
                snaps s
            JOIN
                stats$sql_summary ss1
            ON
                       ss1.snap_id         = s.stop_snap
                AND    ss1.dbid            = s.dbid
                AND    ss1.instance_number = s.instance_number
            JOIN
                stats$sql_summary ss2
            ON
                       ss2.snap_id         = s.start_snap
                AND    ss2.dbid            = ss1.dbid
                AND    ss2.instance_number = ss1.instance_number
                AND    ss2.hash_value      = ss1.hash_value
                AND    ss2.address         = ss1.address
                AND    ss2.text_subset     = ss1.text_subset
                AND    ss1.executions      > NVL(ss2.executions, 0)
            WHERE
                s.stop_snap IS NOT NULL
            GROUP BY 
                s.snap_day,
                s.start_snap,
                s.stop_snap,
                s.start_time,
                s.stop_time,
                ss1.hash_value,
                ss1.module,
                ss1.text_subset
        ),
    top_n AS
        (
            SELECT
                w.*,
                bg / ex    AS gpe,
                ROW_NUMBER() OVER
                    (
                        PARTITION BY start_snap ORDER BY ct DESC
                    )      AS nr
            FROM
                work w
        )
    SELECT
        snap_day,
        start_snap,
        stop_snap,
        start_time,
        stop_time,
        hash_value,
        module,
        text_subset,
        bg,    -- buffer gets
        ex,    -- executions
        ct,    -- cpu time
        et,    -- elapsed time
        rp,    -- rows processed
        dr,    -- disk reads
        pc,    -- parse calls
        iv,    -- invalidations
        ld,    -- loads
        gpe    -- gets per execs
    FROM
        top_n
    WHERE
        nr <= 10;


## Show how much is tablespace usage growing

*Keywords*: regression models, dynamic views, logical storage

    SELECT
        d.name db,
        t.name tablespace_name,
        REGR_SLOPE(tablespace_usedsize, snap_id) usage_growth
    FROM
        dba_hist_tbspc_space_usage h=
        JOIN gv$database d USING(dbid)
        JOIN gv$tablespace t ON (h.tablespace_id = t.ts#)
    GROUP BY
        d.name, t.name
    ORDER BY
        db, tablespace_name;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
