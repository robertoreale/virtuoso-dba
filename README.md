# The Virtuoso DBA

![the Virtuoso DBA](manuscript/images/title_page.jpg)


# License Notice

This book is for sale at http://leanpub.com/virtuosodba.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>

This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.


# Table of Contents

<!-- toc -->

- [Introduction](#introduction)
- [First Steps](#first-steps)
  * [Show database role (primary, standby, etc.)](#show-database-role-primary-standby-etc)
  * [Show database block size](#show-database-block-size)
  * [List user Data Pump jobs](#list-user-data-pump-jobs)
  * [Calculate the average number of redo log switches per hour](#calculate-the-average-number-of-redo-log-switches-per-hour)
  * [List the top-n largest segments](#list-the-top-n-largest-segments)
  * [Show the total, used, and free space database-wise](#show-the-total-used-and-free-space-database-wise)
  * [Display the findings discovered by all advisors in the database](#display-the-findings-discovered-by-all-advisors-in-the-database)
  * [Associate blocking and blocked sessions](#associate-blocking-and-blocked-sessions)
  * [Calculate the size of the temporary tablespaces](#calculate-the-size-of-the-temporary-tablespaces)
  * [Calculate the high-water and excess allocated size for datafiles](#calculate-the-high-water-and-excess-allocated-size-for-datafiles)
  * [Display parent-child pairs between tables, based on reference constraints](#display-parent-child-pairs-between-tables-based-on-reference-constraints)
  * [Compute a count of archived logs and their average size](#compute-a-count-of-archived-logs-and-their-average-size)
  * [Calculate a fragmentation factor for tablespaces](#calculate-a-fragmentation-factor-for-tablespaces)
  * [Count number of segments for each order of magnitude](#count-number-of-segments-for-each-order-of-magnitude)
  * [Give basic info about lob segments](#give-basic-info-about-lob-segments)
  * [Sort the object types by their average name length](#sort-the-object-types-by-their-average-name-length)
  * [Count memory resize operations, by component and type](#count-memory-resize-operations-by-component-and-type)
  * [List some basic I/O statistics for each user session](#list-some-basic-io-statistics-for-each-user-session)
  * [List some basic CPU statistics for each user session](#list-some-basic-cpu-statistics-for-each-user-session)
  * [Show the instance name and number and the schema or database user name relative to the current session](#show-the-instance-name-and-number-and-the-schema-or-database-user-name-relative-to-the-current-session)
- [String Manipulation](#string-manipulation)
  * [Count the client sessions with a FQDN](#count-the-client-sessions-with-a-fqdn)
  * [Calculate the edit distance between a table name and the names of dependent indexes](#calculate-the-edit-distance-between-a-table-name-and-the-names-of-dependent-indexes)
  * [Get the number of total waits for each event type, with pretty formatting](#get-the-number-of-total-waits-for-each-event-type-with-pretty-formatting)
- [Data Analytics](#data-analytics)
  * [Rank all the tables in the system based on their cardinality](#rank-all-the-tables-in-the-system-based-on-their-cardinality)
  * [List the objects in the recycle bin, sorting by the version](#list-the-objects-in-the-recycle-bin-sorting-by-the-version)
  * [Show I/O stats on datafiles](#show-io-stats-on-datafiles)
  * [Show the progressive growth in backup sets](#show-the-progressive-growth-in-backup-sets)
  * [List statspack snapshots](#list-statspack-snapshots)
  * [List top-10 CPU-intensive queries](#list-top-10-cpu-intensive-queries)
  * [Show how much is tablespace usage growing](#show-how-much-is-tablespace-usage-growing)
- [Graphs and Trees](#graphs-and-trees)
  * [List all users to which a given role is granted, even indirectly](#list-all-users-to-which-a-given-role-is-granted-even-indirectly)
  * [Display reference graph between tables](#display-reference-graph-between-tables)
- [Grouping & Reporting](#grouping--reporting)
  * [Count the data files for each tablespaces and for each filesystem location](#count-the-data-files-for-each-tablespaces-and-for-each-filesystem-location)
- [Drawing](#drawing)
  * [Generate a histogram for the length of objects’ names](#generate-a-histogram-for-the-length-of-objects-names)
  * [Build a histogram for the order of magnitude of segments’ sizes](#build-a-histogram-for-the-order-of-magnitude-of-segments-sizes)
- [Time Functions](#time-functions)
  * [Show the first and last day of the current month](#show-the-first-and-last-day-of-the-current-month)
  * [Show the first and last day of the current month](#show-the-first-and-last-day-of-the-current-month-1)
  * [Show the maximum possible date](#show-the-maximum-possible-date)
  * [Show the minimum possible date](#show-the-minimum-possible-date)
  * [List leap years from 1 AD](#list-leap-years-from-1-ad)
  * [Count audit records for the last hour](#count-audit-records-for-the-last-hour)
  * [Calculate the calendar date of Easter, from 1583 to 2999](#calculate-the-calendar-date-of-easter-from-1583-to-2999)
- [Numerical Recipes](#numerical-recipes)
  * [Calculate the sum of a geometric series](#calculate-the-sum-of-a-geometric-series)
  * [Solve Besel's problem](#solve-besels-problem)
  * [Generate Fibonacci sequence](#generate-fibonacci-sequence)
  * [Verify that the sum of the reciprocals of factorials converge to e](#verify-that-the-sum-of-the-reciprocals-of-factorials-converge-to-e)
  * [Verify that the sum of the reciprocals of factorials converge to e, alternative method](#verify-that-the-sum-of-the-reciprocals-of-factorials-converge-to-e-alternative-method)
  * [Verify that the cosine function has a fixed point](#verify-that-the-cosine-function-has-a-fixed-point)
- [XML Database 101](#xml-database-101)
  * [Return the total number of installed patches](#return-the-total-number-of-installed-patches)
  * [List user passwords (hashed, of course...)](#list-user-passwords-hashed-of-course)
  * [Return patch details such as patch and inventory location](#return-patch-details-such-as-patch-and-inventory-location)
  * [Show patch inventory](#show-patch-inventory)
  * [Show patch inventory, part 2](#show-patch-inventory-part-2)
  * [Show bugs fixed by each installed patch](#show-bugs-fixed-by-each-installed-patch)
- [Enter Imperative Thinking](#enter-imperative-thinking)
  * [Show all Oracle error codes and messages](#show-all-oracle-error-codes-and-messages)
- [A Stochastic World](#a-stochastic-world)
  * [Verify the law of large numbers](#verify-the-law-of-large-numbers)
  * [For each tablespace T, find the probability of segments in T to be smaller than or equal to a given size](#for-each-tablespace-t-find-the-probability-of-segments-in-t-to-be-smaller-than-or-equal-to-a-given-size)
- [Internals](#internals)
  * [Count the number of trace files generated each day](#count-the-number-of-trace-files-generated-each-day)
  * [Display hidden/undocumented initialization parameters](#display-hiddenundocumented-initialization-parameters)
  * [Display the number of ASM allocated and free allocation units](#display-the-number-of-asm-allocated-and-free-allocation-units)
  * [Display the count of allocation units per ASM file by file alias (for metadata only)](#display-the-count-of-allocation-units-per-asm-file-by-file-alias-for-metadata-only)
  * [Display the count of allocation units per ASM file by file alias](#display-the-count-of-allocation-units-per-asm-file-by-file-alias)
  * [Show file utilization](#show-file-utilization)

<!-- tocstop -->

# Introduction

Working as a DBA requires improving skills in at least two key areas: SQL and database administration.  Usually the paths to do so are separate: in this book we will try to unify them in a coherent manner.

# First Steps

## Show database role (primary, standby, etc.)

*Keywords*: dynamic views, data guard

    SELECT database_role FROM gv$database;


## Show database block size

*Keywords*: dynamic views, parameters

    SELECT
        inst_id,
        TO_NUMBER(value)  AS db_block_size
    FROM
        gv$parameter
    WHERE
        name = 'db_block_size';
    

## List user Data Pump jobs

*Keywords*: LIKE, data pump

    SELECT
        owner_name,
        job_name,
        operation,
        job_mode,
        state,
        attached_sessions
    FROM
        dba_datapump_jobs
    WHERE
        job_name NOT LIKE 'BIN$%';


## Calculate the average number of redo log switches per hour

*Keywords*: dynamic views, aggregate functions

    SELECT
        inst_id,
        thread#,
        TRUNC(first_time)              AS day,
        COUNT(*)                       AS switches,
        COUNT(*) / 24                  AS avg_switches_per_hour
    FROM
        gv$loghist
    GROUP BY
        inst_id,
        thread#,
        TRUNC(first_time)
    ORDER BY
        day;


## List the top-n largest segments

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


## Show the total, used, and free space database-wise

*Keywords*: subqueries, physical storage

    SELECT
        alloc_space                 AS alloc_space,
        alloc_space - free_space    AS used_space,
        free_space                  AS free_space
    FROM
        (
            SELECT
                (SELECT SUM(bytes / 1024 / 1024) from dba_data_files)   AS alloc_space,
                (SELECT SUM(bytes / 1024 / 1024) from dba_free_space)   AS free_space
            FROM dual
        );


## Display the findings discovered by all advisors in the database

*Keywords*: addm, nested queries

    SELECT
        f.type,
        t.execution_start,
        t.execution_end,
        t.status,
        f.impact,
        f.impact_type,
        f.message
    FROM
        dba_advisor_findings f
    JOIN
        dba_advisor_tasks    t  ON f.task_id = t.task_id
    WHERE
        (
            --  Oracle Bug 12347332
            (
                SELECT
                    version
                FROM
                    product_component_version
                WHERE
                    product LIKE 'Oracle Database%'
            )
                NOT LIKE '10.2.0.5%'
            OR f.message 
                <> 'Significant virtual memory paging was detected on the host operating system.'
        );


## Associate blocking and blocked sessions

*Keywords*: self join, locking

    SELECT
        l1.sid AS blocking,
        l2.sid AS blocked
    FROM
        gv$lock l1 JOIN gv$lock l2 USING (id1, id2)
    WHERE
        l1.block = 1 AND l2.request > 0;


## Calculate the size of the temporary tablespaces

*Keywords*: aggregate functions, dynamic views, logical storage

    SELECT
        inst_id,
        ts.name,
        tmpf.block_size,
        SUM(tmpf.bytes) AS bytes
    FROM
        gv$tablespace ts
    JOIN
        gv$tempfile tmpf
    USING
        (inst_id, ts#)
    GROUP BY
        inst_id, ts.name, tmpf.block_size;


## Calculate the high-water and excess allocated size for datafiles

*Keywords*: WITH clause, NVL, aggregate functions, physical storage

    WITH
        pars AS
            (
                -- block size in MiB
                SELECT
                    TO_NUMBER(value) / 1024 / 1024  AS block_size_mib
                FROM
                -- no need to use gv$parameter here
                    v$parameter
                WHERE
                    name = 'db_block_size'
            )
    SELECT
        file_name,
        blocks                 * pars.block_size_mib  AS file_size,
        NVL(hwm, 1)            * pars.block_size_mib  AS high_water_mark,
        (blocks - NVL(hwm, 1)) * pars.block_size_mib  AS excess
    FROM
        pars,
        dba_data_files df
    JOIN
        (
            SELECT
                file_id,
                MAX(block_id + blocks - 1)  AS hwm
            FROM
                dba_extents
            GROUP BY
                file_id
        ) ext
    USING (file_id);


## Display parent-child pairs between tables, based on reference constraints

*Keywords*: WITH clause, constraints

    WITH
        constraints AS 
            (
                SELECT
                    *
                FROM
                    all_constraints
                WHERE
                    status = 'ENABLED' AND constraint_type IN ('P','R')
            )
    SELECT DISTINCT
        c1.owner         AS owner,
        c1.table_name    AS table_name,
        c2.owner         AS parent_owner,
        c2.table_name    AS parent_table_name
    FROM
        constraints  c1
    JOIN
        constraints  c2 ON c1.r_constraint_name = c2.constraint_name
    ORDER BY
        1, 2, 3, 4;


## Compute a count of archived logs and their average size

*Keywords*: dynamic views, WITH clause

    WITH
        lh AS (
            SELECT
                TO_CHAR(first_time, 'YYYY-MM-DD')    AS day,
                COUNT(1)                             AS archived#,
                MIN(recid)                           AS min#,
                MAX(recid)                           AS max# 
            FROM
                gv$log_history
            GROUP BY
                TO_CHAR(first_time, 'YYYY-MM-DD')
            ORDER BY 1 DESC
        ),
        lg AS (
            SELECT
                COUNT(1)                             AS members#,
                MAX(bytes) / 1024 / 1024             AS max_size, 
                MIN(bytes) / 1024 / 1024             AS min_size,
                AVG(bytes) / 1024 / 1024             AS avg_size
            FROM
                gv$log
        )
    SELECT
        lh.*,
        lg.*,
        ROUND(lh.archived# * lg.avg_size)             AS daily_avg_size
    FROM
        lh, lg;


## Calculate a fragmentation factor for tablespaces

*Keywords*: aggregate functions, logical storage

The fragmentation column gives an overall score with respect to how badly a
tablespace is fragmented; a 100% score indicates no fragmentation at all.

It is calculated according to the following formula:

                ___________      
              \/max(blocks)      
                         
    1 - ------------------------ 
                         
                    =====        
         4_______   \            
        \/blocks#    >    blocks 
                    /            
                    =====        
 
Cf. the book *Oracle Performance Troubleshooting*, by Robin Schumacher.

    SELECT
        tablespace_name               AS tablespace,
        COUNT(*)                      AS free_chunks,
        NVL(MAX(bytes) / 1048576, 0)  AS largest_chunk,
        100 * (
            1 - NVL(SQRT(MAX(blocks) / (SQRT(SQRT(COUNT(blocks))) * SUM(blocks))), 0)
        )                             AS fragmentation
    FROM
        dba_free_space
    GROUP BY
        tablespace_name;


## Count number of segments for each order of magnitude

*Keywords*: DECODE function, analytic functions

IEC prefixes are used.

    SELECT
    DECODE(
        TRUNC(LOG(1024, bytes)), 
        -- 0, 'bytes',
        1, 'KiB' ,
        2, 'MiB',
        3, 'GiB',
        4, 'TiB',
        5, 'PiB',
        6, 'EiB',
        7, 'ZiB',
        8, 'YiB',
        'UNKNOWN') AS order_of_magnitude,
        count(*) count
    FROM
        dba_segments
    GROUP BY TRUNC(LOG(1024, bytes))
    ORDER BY TRUNC(LOG(1024, bytes));


## Give basic info about lob segments

*Keywords*: aggregate functions, lobs

    SELECT
        lob.owner,
        lob.table_name,
        lob.column_name,
        segment_name,
        SUM(seg.bytes) / 1024  AS segment_size
    FROM
        dba_segments seg
    JOIN
        dba_lobs     lob
    USING (segment_name)
    WHERE
        segment_name LIKE 'SYS_LOB%'
    GROUP BY
        lob.owner,
        lob.table_name,
        lob.column_name,
        segment_name;


## Sort the object types by their average name length

*Keywords*: aggregate functions, string functions

    SELECT
        object_type,
        AVG(LENGTH(object_name)) avg_name_length
    FROM
        dba_objects
    GROUP BY
        object_type
    ORDER BY
        AVG(LENGTH(object_name)) DESC;


## Count memory resize operations, by component and type

*Keywords*: DECODE, dynamic views

    SELECT
        component,
        DECODE(
            SIGN(final_size - initial_size),
             1, 'GROW',
             0, 'NO OP',
            -1, 'SHRINK',
                'UNKNOWN'
        ) operation,
        COUNT(*) count
    FROM
        gv$memory_resize_ops 
    GROUP BY component, SIGN(final_size - initial_size)
    ORDER BY component;


## List some basic I/O statistics for each user session

*Keywords*: dynamic views, outer join

    SELECT
        s.inst_id,
        s.sid,
        s.serial#,
        p.spid,
        s.status,
        logon_time,
        s.username,
        s.osuser,
        s.machine,
        s.program,
        i.consistent_gets,
        i.physical_reads
    FROM
        gv$session s
        JOIN gv$sess_io i            ON s.inst_id = i.inst_id AND s.sid   = i.sid
        LEFT JOIN gv$session_wait w  ON s.inst_id = w.inst_id AND s.sid   = w.sid
        JOIN gv$process p            ON s.inst_id = p.inst_id AND s.paddr = p.addr
    WHERE
        s.osuser IS NOT NULL AND s.username IS NOT NULL
    ORDER BY
        inst_id, sid, serial#;
        

## List some basic CPU statistics for each user session

*Keywords*: dynamic views, outer join

    SELECT
        s.inst_id,
        s.sid,
        s.serial#,
        p.spid,
        s.status,
        logon_time,
        s.username,
        w.seconds_in_wait,
        name AS parameter,
        value
    FROM
        gv$session s
        JOIN gv$sess_io i            ON s.inst_id = i.inst_id AND s.sid   = i.sid
        LEFT JOIN gv$session_wait w  ON s.inst_id = w.inst_id AND s.sid   = w.sid
        JOIN gv$process p            ON s.inst_id = p.inst_id AND s.paddr = p.addr
        JOIN gv$sesstat t            ON s.inst_id = t.inst_id AND s.sid   = t.sid
        JOIN gv$statname n           USING (statistic#)
    WHERE
        (w.event IS NULL OR 'SQL*Net message from client' = w.event)
        AND s.osuser   IS NOT NULL
        AND s.username IS NOT NULL
        AND n.name     LIKE '%cpu%'
    ORDER BY
        inst_id, sid, serial#, parameter;


## Show the instance name and number and the schema or database user name relative to the current session

*Keywords*: WITH clause, SYS_CONTEXT

    WITH
        ctx AS
            (
                SELECT
                    SYS_CONTEXT('USERENV', 'INSTANCE_NAME') AS instance_name,
                    SYS_CONTEXT('USERENV', 'SESSION_USER')  AS session_user
                FROM
                    dual
            )
    SELECT 
        ctx.instance_name,
        i.instance_number,
        ctx.session_user
    FROM
        ctx
    JOIN
        gv$instance i ON UPPER(ctx.instance_name) = UPPER(i.instance_name);

# String Manipulation

## Count the client sessions with a FQDN

*Keywords*: regular expressions, dynamic views

Assume a FQDN has the form N_1.N_2.....N_t, where t > 1 and each N_i can contain lowercase letters, numbers and the dash.
 
    SELECT
        machine
    FROM
        gv$session
    WHERE
        REGEXP_LIKE(machine, '^([[:alnum:]]+\.)+[[:alnum:]-]+$');


## Calculate the edit distance between a table name and the names of dependent indexes

*Keywords*: edit distance for strings

    SELECT
        owner,
        table_name,
        index_name,
        UTL_MATCH.EDIT_DISTANCE(table_name, index_name) edit_distance
    FROM
        dba_indexes
    WHERE
        generated = 'N';


## Get the number of total waits for each event type, with pretty formatting

*Keywords*: formatting, analytic functions, dynamic views

    WITH se AS (
      SELECT event ev, total_waits tw FROM v$system_event
    )
    SELECT
      RPAD(ev, MAX(LENGTH(ev)+2) OVER (), '.') ||
      LPAD(tw, MAX(LENGTH(tw)+2) OVER (), '.') total_waits_per_event_type
    FROM
        se;


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
    
    
## Show the progressive growth in backup sets

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
            TRUNC(completion_time, 'DAY')                       completion_day,
            SUM(bytes)                                          cumu_size,
            NTILE(100) OVER (ORDER BY device_type, SUM(bytes))  percentile
        FROM
            v$backup_piece_details  -- gv$backup_piece_details does not exist
        GROUP BY
            device_type, TRUNC(completion_time, 'DAY')
    )
    WHERE
        percentile BETWEEN 10 AND 90;


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


## List top-10 CPU-intensive queries

*References*: https://community.oracle.com/thread/1101381

    WITH
        snaps AS
            (
                SELECT
                    dbid                                                             AS dbid,
                    instance_number                                                  AS instance_number,
                    trunc(snap_time, 'DAY')                                          AS snap_day,
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
        bg      buffer_gets,
        ex      executions,
        ct      cpu_time,
        et      elapsed_time,
        rp      rows_processed,
        dr      disk_reads,
        pc      parse_calls,
        iv      invalidations,
        ld      loads,
        gpe     gets_per_execs
    FROM
        top_n
    WHERE
        nr <= &m;


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


# Graphs and Trees

## List all users to which a given role is granted, even indirectly

*Keywords*: hierarchical queries, security

    SELECT 
        grantee
    FROM
        dba_role_privs
    CONNECT BY prior grantee = granted_role
    START WITH granted_role = '&role'
    INTERSECT
    SELECT
        username
    FROM
        dba_users;


## Display reference graph between tables

*Keywords*: hierarchical queries, constraints

    WITH
        constraints AS 
            (
                SELECT
                    *
                FROM
                    dba_constraints
                WHERE
                    status = 'ENABLED' AND constraint_type IN ('P','R')
            ),
        constraint_tree AS
            (
                SELECT DISTINCT
                    c1.owner || '.' || c1.table_name 
                        AS table_name,
                    NVL2(c2.table_name, c2.owner || '.' || c2.table_name, NULL)
                        AS parent_table_name
                FROM
                    constraints c1
                LEFT OUTER JOIN
                    constraints c2
                ON c1.r_constraint_name = c2.constraint_name
            )
    SELECT
        level AS depth,
        SYS_CONNECT_BY_PATH(table_name, '->') AS path
    FROM
        constraint_tree
    WHERE
        LEVEL > 1 AND CONNECT_BY_ISLEAF = 1
    START WITH
        parent_table_name IS NULL
    CONNECT BY
        NOCYCLE parent_table_name = PRIOR table_name
    ORDER BY
        depth, path;


# Grouping & Reporting

## Count the data files for each tablespaces and for each filesystem location

*Keywords*: grouping, regular expressions

Assume a Unix filesystem, don’t follow symlinks.  Moreover, generate subtotals for each of the two dimensions (*scil*. tablespace and filesystem location).
 
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


# Drawing

## Generate a histogram for the length of objects’ names

*Keywords*: formatting, analytic functions, aggregate functions, logical storage

    SELECT
        LENGTH(object_name),
        LPAD('#',
            CEIL(RATIO_TO_REPORT(
                APPROX_COUNT_DISTINCT(object_name)) OVER () * 100
            ),
            '#') AS histogram
    FROM
        dba_objects
    GROUP BY LENGTH(object_name)
    ORDER BY LENGTH(object_name);


## Build a histogram for the order of magnitude of segments’ sizes

*Keywords*: formatting, analytic functions, aggregate functions, physical storage

    SELECT
        DECODE(
            TRUNC(LOG(1024, bytes)),
            -- 0, 'bytes',
            1, 'KiB' ,
            2, 'MiB',
            3, 'GiB',
            4, 'TiB',
            5, 'PiB',
            6, 'EiB',
            7, 'ZiB',
            8, 'YiB',
            'UNKNOWN'
        )           AS order_of_magnitude,
        LPAD('#',
            CEIL(RATIO_TO_REPORT(
                APPROX_COUNT_DISTINCT(SEGMENT_NAME)) OVER () * 100
            ),
            '#')    AS histogram
    FROM
        dba_segments
    GROUP BY TRUNC(LOG(1024, bytes))
    ORDER BY TRUNC(LOG(1024, bytes));


# Time Functions

## Show the first and last day of the current month

*Keywords*: time functions

    SELECT
        TRUNC(SYSDATE, 'MONTH')   first_day_curr_month,
        TRUNC(LAST_DAY(SYSDATE))  last_day_curr_month
    FROM
        dual;


## Show the first and last day of the current month

*Keywords*: time functions

*Reference*: http://viralpatel.net/blogs/useful-oracle-queries/

    SELECT
        TRUNC(SYSDATE, 'YEAR')                      first_day_curr_year,
        ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 12) - 1  last_day_curr_year
    FROM
        dual;


## Show the maximum possible date

*Keywords*: time functions

*Reference*: http://stackoverflow.com/questions/687510/

December 31, 9999 CE, one second to midnight.

    SELECT
        TO_CHAR(
            TO_DATE('9999-12-31', 'YYYY-MM-DD')
            + (1 - 1/24/60/60),
        'DD-MON-YYYY hh12:mi:ss AD') AS latest_date
    FROM
        dual;


## Show the minimum possible date

*Keywords*: time functions

*Reference*: http://stackoverflow.com/questions/687510/, Oracle bug 106242

    SELECT 
        TO_CHAR(TO_DATE(1, 'J'), 'DD-MON-YYYY hh12:mi:ss AD') AS earliest_date
    FROM
        dual;


## List leap years from 1 AD

*Keywords*: time functions

    SELECT
        level AS year
    FROM
        dual
    WHERE TO_CHAR(LAST_DAY(TO_DATE('0102'||TO_CHAR(level), 'DDMMYYYY')), 'DD') = '29'
    CONNECT BY LEVEL < 10000;


## Count audit records for the last hour

*Keywords*: time functions, audit

    SELECT
        COUNT(*)  AS count_last_hour
    FROM
        sys.aud$
    WHERE
        CAST((FROM_TZ(ntimestamp#, '00:00') AT local) AS date)
            < SYSDATE - INTERVAL '1' HOUR;


## Calculate the calendar date of Easter, from 1583 to 2999

*Keywords*: time functions, multiple WITH clauses

*Reference*: http://www.adp-gmbh.ch/ora/plsql/calendar.html

    WITH
        t0 AS
            (
                SELECT
                    LEVEL + 1582 AS year
                FROM
                    dual
                CONNECT BY LEVEL <= 2299 - 1582
            ),
        t1 AS
        (
            SELECT
                year,
                CASE
                    WHEN year < 1700 THEN 22
                    WHEN year < 1900 THEN 23
                    WHEN year < 2200 THEN 24
                    ELSE 25
                END AS m,
                CASE
                    WHEN year < 1700 THEN 2
                    WHEN year < 1800 THEN 3
                    WHEN year < 1900 THEN 4
                    WHEN year < 2100 THEN 5
                    WHEN year < 2200 THEN 6
                    ELSE 0
                END AS n,
                MOD(year, 19) AS a,
                MOD(year, 4)  AS b,
                MOD(year, 7)  AS c
            FROM
                t0
        ),
        t2 AS
        (
            SELECT
                year, m, n, a, b, c,
                MOD(19 * a + m, 30) AS d
            FROM
                t1
        ),
        t3 AS
        (
            SELECT
                year, m, n, a, b, c, d,
                MOD(2 * b + 4 * c + 6 * d + n, 7) AS e
            FROM
                t2
        ),
        t4 AS
        (
            SELECT
                year, m, n, a, b, c, d, e,
                22 + d + e AS day,
                3          AS month
            FROM
                t3
        ),
        t5 AS
        (
            SELECT
                year, m, n, a, b, c, d, e,
                CASE
                    WHEN day > 31 THEN day - 31
                    ELSE day
                END AS day,
                CASE
                    WHEN day > 31 THEN month + 1
                    ELSE month
                END AS month
            FROM
                t4
        ),
        t6 AS
        (
            SELECT
                year,
                CASE
                    WHEN day = 26 AND month = 4 THEN 19
                    WHEN day = 25 AND month = 4 AND d = 28 AND e = 6 AND a > 10 THEN 18
                    ELSE day
                END AS day,
                month
            FROM
                t5
        ),
        t7 AS
        (
            SELECT
                year,
                TO_DATE(
                    TO_CHAR(day,    '00'  ) ||
                    TO_CHAR(month,  '00'  ) ||
                    TO_CHAR(year,   '0000'),
                    'DDMMYYYY'
                ) AS easter_sunday
            FROM
                t6
        )
    SELECT
        year                  AS year,
        easter_sunday - 52    AS jeudi_gras,
        easter_sunday - 48    AS carnival_monday,
        easter_sunday - 47    AS mardi_gras,
        easter_sunday - 46    AS ash_wednesday,
        easter_sunday - 7     AS palm_sunday,
        easter_sunday - 3     AS maundy_thursday,
        easter_sunday - 2     AS good_friday,
        easter_sunday - 1     AS holy_saturday,
        easter_sunday         AS easter_sunday,
        easter_sunday + 1     AS easter_monday,
        easter_sunday + 39    AS ascension_of_christ,
        easter_sunday + 49    AS whitsunday,
        easter_sunday + 50    AS whitmonday,
        easter_sunday + 60    AS corpus_christi
    FROM
        t7;


# Numerical Recipes

## Calculate the sum of a geometric series

*Keywords*: CONNECT BY, numerical recipes

    SELECT SUM(POWER(2, -level)) sum FROM dual CONNECT BY level < &n;


## Solve Besel's problem

*Keywords*: CONNECT BY, numerical recipes

    SELECT
        SUM(POWER(level, -2))    sum,
        POWER(ATAN(1)*4, 2) / 6  pi_squared_over_six
    FROM
        dual
    CONNECT BY level < &n;


## Generate Fibonacci sequence

*Keywords*: recursive CTE, numerical recipes

*Reference*: http://www.codeproject.com/Tips/815840/Fibonacci-sequence-in-Oracle-using-sinqle-SQL-stat

At least 11g R2 is required for the recursive CTE to work.

    WITH fibonacci(n, f_n, f_n_next) AS
        (
            SELECT            --  base case
                1                 AS n,
                0                 AS f_n,
                1                 AS f_n_next
            FROM
                dual
            UNION ALL SELECT  --  recursive definition
                n + 1             AS n,
                f_n_next          AS f_n,
                f_n + f_n_next    AS f_n_next
            FROM
                fibonacci
            WHERE
                n < &m
        )
    SELECT
        f_n                       AS nth_fibonacci_number
    FROM
        fibonacci;


## Verify that the sum of the reciprocals of factorials converge to e

*Keywords*: recursive CTE, numerical recipes

    WITH factorial(n, f_n) AS
        (
            SELECT            --  base case
                1                 AS n,
                1                 AS f_n
            FROM
                dual
            UNION ALL SELECT  --  recursive definition
                n + 1             AS n,
                f_n * (n + 1)     AS f_n
            FROM
                factorial
            WHERE
                n < 50
        )
    SELECT
        1 + sum(1 / f_n) - exp(1)  AS error
    FROM
        factorial;


## Verify that the sum of the reciprocals of factorials converge to e, alternative method

*Keywords*: doubly increasing sequence, non-equi join

    WITH
        seq AS (
            SELECT level n FROM dual CONNECT BY level < &m
        )
    SELECT
        1 + SUM(1 / EXP(SUM(LN(s2.n)))) - EXP(1) AS error
    FROM
        seq s1 JOIN seq s2 ON s2.n <= s1.n
    GROUP BY
        s1.n;


## Verify that the cosine function has a fixed point

*Keywords*: recursive CTE, numerical recipes, analytic functions, random values

A fixed point is a point x_0 such that x_0 = cos(x_0).

    WITH iter(x, cos_x, n) AS 
        (
            SELECT
                s.r      AS x,
                COS(s.r) AS cos_x,
                1        AS n
            FROM
                dual,
                (SELECT DBMS_RANDOM.VALUE(0, 1) r FROM dual) s
            UNION ALL
            SELECT
                COS(x)      AS x,
                COS(COS(x)) AS cos_x,
                n + 1       AS N
            FROM
                iter
            WHERE
                n < &m
        )
    SELECT
        x,
        cos_x,
        ABS(cos_x - LAG(cos_x) OVER (ORDER BY n)) distance
    FROM
        iter;


# XML Database 101

## Return the total number of installed patches

*Keywords*: XML database, patches

    SELECT
        EXTRACTVALUE(DBMS_QOPATCH.GET_OPATCH_COUNT, '/patchCountInfo')
    FROM
        dual;


## List user passwords (hashed, of course...)

*Keywords*: XML database, security

From 11g onwards, password hashes do not appear in dba_users anymore.  Of course they are still visible in sys.user$, but we can do better...

    SELECT
        username,
        EXTRACT(
            XMLTYPE(
                DBMS_METADATA.GET_XML('USER', username)),
                '//USER_T/PASSWORD/text()'
            ).getStringVal()  AS  password_hash
    FROM
        dba_users;


## Return patch details such as patch and inventory location

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/info.sql

    SELECT 
        XMLSERIALIZE(
            DOCUMENT DBMS_QOPATCH.GET_OPATCH_INSTALL_INFO AS CLOB INDENT SIZE = 2
        ) AS info 
    FROM
        dual;


## Show patch inventory

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/lsinventory.sql

    SELECT
        XMLTRANSFORM(
            DBMS_QOPATCH.GET_OPATCH_LSINVENTORY, DBMS_QOPATCH.GET_OPATCH_XSLT
        ).GetClobVal() AS lsinventory
    FROM
        dual;


## Show patch inventory, part 2

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/patches.sql

    WITH opatch AS (
        SELECT DBMS_QOPATCH.GET_OPATCH_LSINVENTORY patch_output FROM dual
    )
    SELECT
        patches.*
    FROM
        opatch,
        XMLTABLE(
            'InventoryInstance/patches/*'
            PASSING opatch.patch_output
            COLUMNS
                patch_id     NUMBER       PATH 'patchID',
                patch_uid    NUMBER       PATH 'uniquePatchID',
                description  VARCHAR2(80) PATH 'patchDescription',
                applied_date VARCHAR2(30) PATH 'appliedDate',
                sql_patch    VARCHAR2(8)  PATH 'sqlPatch',
                rollbackable VARCHAR2(8)  PATH 'rollbackable'
        ) patches;


## Show bugs fixed by each installed patch

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/bugs_fixed.sql

    WITH bugs AS (
        SELECT
            id,
            description
        FROM XMLTABLE(
            '/bugInfo/bugs/bug'
            PASSING DBMS_QOPATCH.GET_OPATCH_BUGS
            COLUMNS
                id          NUMBER PATH '@id',
                description VARCHAR2(100) PATH 'description'
        )
    )
    SELECT * FROM bugs;


# Enter Imperative Thinking

## Show all Oracle error codes and messages

*Keywords*: LIKE, CONNECT BY, function in WITH clause, SQLERRM

*Reference*: https://stackoverflow.com/questions/11892043/

    WITH
        FUNCTION ora_code_desc(p_code IN VARCHAR2) RETURN VARCHAR2
        IS
        BEGIN
            RETURN SQLERRM(SUBSTR(p_code, 4));
        END;
    SELECT
        ora_code_desc('ORA-'||level) FROM dual
    WHERE
        ora_code_desc('ORA-'||level) NOT LIKE '%Message '||level||' not found%'
    CONNECT BY LEVEL < 100000;


# A Stochastic World

## Verify the law of large numbers

*Keywords*: CONNECT BY, analytic functions, random values, subqueries, ODCI
functions, TABLE function, numerical recipes

Verify the law of large numbers by rolling a die n times, with n >> 0 

    SELECT
        (
            SELECT
                AVG(ROUND(DBMS_RANDOM.VALUE(1, 6)))
            FROM
                dual
            CONNECT BY LEVEL < &n
        ) sample_average,
        (
            SELECT AVG(column_value) FROM TABLE(ODCINUMBERLIST(1,2,3,4,5,6))
        ) expected_value
    FROM
        dual;


## For each tablespace T, find the probability of segments in T to be smaller than or equal to a given size

*Keywords*: probability distributions, logical storage

    SELECT
        tablespace_name, 
        CUME_DIST(&size) WITHIN GROUP (ORDER BY bytes) probability
    FROM
        dba_segments
    GROUP BY
        tablespace_name;


# Internals

## Count the number of trace files generated each day

*Keywords*: x$ interface

    SELECT
        TRUNC(creation_time, 'DAY') day,
        COUNT(*) count
    FROM x$dbgdirext
        WHERE
            type = 2 AND logical_file LIKE '%.trc'
        GROUP BY TRUNC(creation_time, 'DAY')
        ORDER BY 2 DESC;


## Display hidden/undocumented initialization parameters

*Keywords*: DECODE function, x$ interface

*Reference*: http://www.oracle-training.cc/oracle_tips_hidden_parameters.htm

    SELECT
        i.ksppinm                AS name,
        cv.ksppstvl              AS value,
        cv.ksppstdf              AS def,
        DECODE
            (
                i.ksppity,
                1, 'boolean',
                2, 'string',
                3, 'number',
                4, 'file',
                i.ksppity
            )                    AS type,
        i.ksppdesc               AS description
    FROM
        sys.x$ksppi i JOIN sys.x$ksppcv cv USING (indx)
    WHERE
        i.ksppinm LIKE '\_%' ESCAPE '\'
    ORDER BY
        name;


## Display the number of ASM allocated and free allocation units

*Keywords*: PIVOT emulation, x$ interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        group_kfdat                                       AS group#,
        number_kfdat                                      AS disk#,
        --  emulate the PIVOT functions which is missing in 10g
        SUM(CASE WHEN v_kfdat = 'V' THEN 1 ELSE 0 END)    AS alloc_au,
        SUM(CASE WHEN v_kfdat = 'F' THEN 1 ELSE 0 END)    AS free_au
    FROM
        x$kfdat
    GROUP BY
        group_kfdat, number_kfdat;


## Display the count of allocation units per ASM file by file alias (for metadata only)

*Keywords*: x$interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        COUNT(xnum_kffxp)    AS au_count,
        number_kffxp         AS file#,
        group_kffxp          AS dg#
    FROM
        x$kffxp
    WHERE
        number_kffxp < 256
    GROUP BY
        number_kffxp, group_kffxp
    ORDER BY
        COUNT(xnum_kffxp);


## Display the count of allocation units per ASM file by file alias

*Keywords*: x$interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        group_kffxp,
        number_kffxp,
        name,
        COUNT(*) count
    FROM
        x$kffxp
    JOIN
        v$asm_alias
    ON
        group_kffxp = group_number AND number_kffxp = file_number
    GROUP BY
        group_kffxp, number_kffxp, name
    ORDER BY
        group_kffxp, number_kffxp;


## Show file utilization

*Keywords*: x$interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        f.group_number,
        f.file_number,
        bytes,
        space,
        a.name
    FROM
        v$asm_file f
    JOIN
        v$asm_alias a
    ON
        f.group_number = a.group_number AND f.file_number = a.file_number
    ORDER BY
        f.group_number, f.file_number;


