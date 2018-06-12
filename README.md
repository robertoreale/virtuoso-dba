# Introduction

Working as a DBA requires improving skills in at least two key areas: SQL and database administration.  Usually the paths to do so are separate: in this book we will try to unify them in a coherent manner.

Solved exercises can be found at https://github.com/robertoreale/virtuosodba/blob/master/EXERCISES.md.

# First Steps


## First Steps

### Calculate the average number of redo log switches per hour

*Keywords*: dynamic views, aggregate functions

    SELECT
        inst_id,
        thread##,
        TRUNC(first_time)              AS day,
        COUNT(*)                       AS switches,
        COUNT(*) / 24                  AS avg_switches_per_hour
    FROM
        gv$loghist
    GROUP BY
        inst_id,
        thread##,
        TRUNC(first_time)
    ORDER BY
        day;


### Show the total, used, and free space database-wise

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


### Show total allocated blocks and possibile shrinkage for data files

*Keywords*: subqueries, physical storage

    SELECT
        file_name,
        hwm,
        blocks            AS total_blocks,
        blocks - hwm + 1  AS shrinkage_possible
    FROM
        dba_data_files df,
        (
            SELECT
                file_id,
                MAX(block_id + blocks) hwm
            FROM
                dba_extents c GROUP BY file_id
        ) de
    WHERE
        df.file_id = dd.file_id
    ORDER BY
        shrinkage_possible;
   
   
### Display the findings discovered by all advisors in the database

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


### Associate blocking and blocked sessions

*Keywords*: self join, locking

    SELECT
        l1.sid AS blocking,
        l2.sid AS blocked
    FROM
        gv$lock l1 JOIN gv$lock l2 USING (id1, id2)
    WHERE
        l1.block = 1 AND l2.request > 0;


### Calculate the size of the temporary tablespaces

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
        (inst_id, ts##)
    GROUP BY
        inst_id, ts.name, tmpf.block_size;


### Calculate the high-water and excess allocated size for datafiles

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


### Display parent-child pairs between tables, based on reference constraints

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


### Compute a count of archived logs and their average size

*Keywords*: dynamic views, WITH clause

    WITH
        lh AS (
            SELECT
                TO_CHAR(first_time, 'YYYY-MM-DD')    AS day,
                COUNT(1)                             AS archived##,
                MIN(recid)                           AS min##,
                MAX(recid)                           AS max## 
            FROM
                gv$log_history
            GROUP BY
                TO_CHAR(first_time, 'YYYY-MM-DD')
            ORDER BY 1 DESC
        ),
        lg AS (
            SELECT
                COUNT(1)                             AS members##,
                MAX(bytes) / 1024 / 1024             AS max_size, 
                MIN(bytes) / 1024 / 1024             AS min_size,
                AVG(bytes) / 1024 / 1024             AS avg_size
            FROM
                gv$log
        )
    SELECT
        lh.*,
        lg.*,
        ROUND(lh.archived## * lg.avg_size)             AS daily_avg_size
    FROM
        lh, lg;


### Count number of segments for each order of magnitude

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


## Show locked objects

*Keywords*: DECODE

    SELECT
        lo.session_id                        AS sid,
        NVL(lo.oracle_username, '(oracle)')  AS username,
        o.owner                              AS object_owner,
        o.object_name,
        DECODE(
            lo.locked_mode,
            0, 'None',
            1, 'Null (NULL)',
            2, 'Row-S (SS)',
            3, 'Row-X (SX)',
            4, 'Share (S)',
            5, 'S/Row-X (SSX)',
            6, 'Exclusive (X)',
            lo.locked_mode)                  AS locked_mode,
        lo.os_user_name
    FROM
        dba_objects      o,
        gv$locked_object lo
    WHERE
        o.object_id = lo.object_id
    ORDER BY 1, 2, 3, 4;


### Show last rebuild time for indexes

*Keywords*: DECODE

    SELECT
        dbo.owner                                    AS owner,
        dbi.index_name                               AS name,
        dbo.created                                  AS created,
        dbo.last_ddl_time                            AS rebuilt,
        --  "Indexes can be created on temporary tables.  They are also temporary
        --  and the data in the index has the same session or transaction scope as
        --  the data in the underlying table."
        --                                   (Oracle Database Administrator's Guide) 
        DECODE(dbt.temporary, 'Y', 'TBL+', '')
            ||DECODE(dbi.temporary, 'Y', 'IDX', '')  AS temporary
    FROM
        dba_objects dbo
    JOIN
        dba_indexes dbi
            ON (dbo.owner = dbi.owner AND dbo.object_name = dbi.index_name)
    JOIN
        dba_tables  dbt 
            ON (dbi.owner = dbo.owner AND dbi.table_name = dbt.table_name)
    WHERE
        object_type = 'INDEX';


### Give basic info about lob segments

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


### Count memory resize operations, by component and type

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


### Show active sessions with SQL text

*Keywords*: dynamic views, IN operator

    SELECT
        s.sid,
        s.serial##,
        sql.sql_text,
        s.username,
        s.machine
    FROM
        gv$sqltext sql
    JOIN
        gv$session s ON s.sql_address = sql.address
    WHERE
        s.sid IN
            (
                SELECT
                    sid
                FROM
                    v$session
                WHERE
                    last_call_et > 5 AND status = 'ACTIVE'
            )
    ORDER BY
        s.sid, sql.piece;


### List some basic I/O statistics for each user session

*Keywords*: dynamic views, outer join

    SELECT
        s.inst_id,
        s.sid,
        s.serial##,
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
        inst_id, sid, serial##;
        

### List some basic CPU statistics for each user session

*Keywords*: dynamic views, outer join

    SELECT
        s.inst_id,
        s.sid,
        s.serial##,
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
        JOIN gv$statname n           USING (statistic##)
    WHERE
        (w.event IS NULL OR 'SQL*Net message from client' = w.event)
        AND s.osuser   IS NOT NULL
        AND s.username IS NOT NULL
        AND n.name     LIKE '%cpu%'
    ORDER BY
        inst_id, sid, serial##, parameter;


### Show the instance name and number and the schema or database user name relative to the current session

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


# Oracle Database


## String Manipulation

### Calculate the minimum, median, and maximum edit distances between a table's name and the names of its indexes

*Keywords*: edit distance for strings, ROLLUP

    SELECT
        owner,
        table_name,
           MIN(UTL_MATCH.EDIT_DISTANCE(table_name, index_name)) min_edit_distance,
        MEDIAN(UTL_MATCH.EDIT_DISTANCE(table_name, index_name)) median_edit_distance,
           MAX(UTL_MATCH.EDIT_DISTANCE(table_name, index_name)) max_edit_distance
    FROM
        dba_indexes
    GROUP BY ROLLUP (owner, table_name)
    ORDER BY         owner, table_name;


### Get the number of total waits for each event type, with pretty formatting

*Keywords*: formatting, analytic functions, dynamic views

    WITH se AS (
      SELECT event ev, total_waits tw FROM v$system_event
    )
    SELECT
      RPAD(ev, MAX(LENGTH(ev)+2) OVER (), '.') ||
      LPAD(tw, MAX(LENGTH(tw)+2) OVER (), '.') total_waits_per_event_type
    FROM
        se;

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


## Graphs and Trees

### List all users to which a given role is granted, even indirectly

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


### List privileges granted to each user, even indirectly

*Keywords*: hierarchical queries, security

    SELECT
        level,
        u1.name grantee,
        u2.name privilege,
        SYS_CONNECT_BY_PATH(u1.name, '/') path
    FROM
        sysauth$ sa
    JOIN
        user$ u1 ON (u1.user## = grantee#)
    JOIN
        user$ u2 ON (u2.user## = sa.privilege#)
    CONNECT BY PRIOR privilege## = grantee#
    ORDER BY level, grantee, privilege;


### Display reference graph between tables

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


### Exercises

## Drawing

### Generate a histogram for the length of objects’ names

*Keywords*: formatting, analytic functions, aggregate functions, logical storage

    SELECT
        LENGTH(object_name),
        LPAD('##',
            CEIL(RATIO_TO_REPORT(
                APPROX_COUNT_DISTINCT(object_name)) OVER () * 100
            ),
            '##') AS histogram
    FROM
        dba_objects
    GROUP BY LENGTH(object_name)
    ORDER BY LENGTH(object_name);


### Build a histogram for the order of magnitude of segments’ sizes

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
        LPAD('##',
            CEIL(RATIO_TO_REPORT(
                APPROX_COUNT_DISTINCT(SEGMENT_NAME)) OVER () * 100
            ),
            '##')    AS histogram
    FROM
        dba_segments
    GROUP BY TRUNC(LOG(1024, bytes))
    ORDER BY TRUNC(LOG(1024, bytes));


### Exercises

## Time Functions

### Show the first and last day of the current month

*Keywords*: time functions

    SELECT
        TRUNC(SYSDATE, 'MONTH')   first_day_curr_month,
        TRUNC(LAST_DAY(SYSDATE))  last_day_curr_month
    FROM
        dual;


### Show the first and last day of the current year

*Keywords*: time functions

*Reference*: http://viralpatel.net/blogs/useful-oracle-queries/

    SELECT
        TRUNC(SYSDATE, 'YEAR')                      first_day_curr_year,
        ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), 12) - 1  last_day_curr_year
    FROM
        dual;


### Show the maximum possible date

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


### Show the minimum possible date

*Keywords*: time functions

*Reference*: http://stackoverflow.com/questions/687510/, Oracle bug 106242

    SELECT 
        TO_CHAR(TO_DATE(1, 'J'), 'DD-MON-YYYY hh12:mi:ss AD') AS earliest_date
    FROM
        dual;


### List leap years from 1 AD

*Keywords*: time functions

    SELECT
        level AS year
    FROM
        dual
    WHERE TO_CHAR(LAST_DAY(TO_DATE('0102'||TO_CHAR(level), 'DDMMYYYY')), 'DD') = '29'
    CONNECT BY LEVEL < 10000;


### Count audit records for the last hour

*Keywords*: time functions, audit

    SELECT
        COUNT(*)  AS count_last_hour
    FROM
        sys.aud$
    WHERE
        CAST((FROM_TZ(ntimestamp##, '00:00') AT local) AS date)
            < SYSDATE - INTERVAL '1' HOUR;


### Count log file switches, day by day, hour by hour

*Keywords*: time functions, PIVOT, dynamic views

    SELECT * FROM
        (
            SELECT
                TRUNC(first_time, 'DDD') day,
                EXTRACT(hour FROM CAST(first_time AS TIMESTAMP)) hour
            FROM
                gv$log_history
        )
    PIVOT
        (
            COUNT(hour) FOR hour IN
                (
                    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                    13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
                )
        );


### Calculate the calendar date of Easter, from 1583 to 2999

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


### Exercises

## Row Generation

### List all integers between 00 and FF, hexadecimal

*Keywords*: CONNECT BY, TO_CHAR

    SELECT TO_CHAR(level - 1, '0X') AS n FROM dual CONNECT BY level <= 256;


### List all integers between 00000000 and 11111111, hexadecimal

*Keywords*: CONNECT BY, DECODE, bitwise operations

    SELECT 
        DECODE(BITAND(level - 1, 128), 128, '1', '0') ||
        DECODE(BITAND(level - 1,  64),  64, '1', '0') ||
        DECODE(BITAND(level - 1,  32),  32, '1', '0') ||
        DECODE(BITAND(level - 1,  16),  16, '1', '0') ||
        DECODE(BITAND(level - 1,   8),   8, '1', '0') ||
        DECODE(BITAND(level - 1,   4),   4, '1', '0') ||
        DECODE(BITAND(level - 1,   2),   2, '1', '0') ||
        DECODE(BITAND(level - 1,   1),   1, '1', '0') AS n
    FROM
        dual
    CONNECT BY level <= 256;


### Generate the integers between 1 and 256

*Keywords*: GROUP BY CUBE

*Reference*: https://technology.amis.nl/2005/02/11/courtesy-of-tom-kyte-generating-rows-in-sql-with-the-cube-statement-no-dummy-table-or-table-function-required/

    SELECT
        rownum
    FROM
        (
            SELECT 1 FROM dual GROUP BY CUBE (1,2,3,4,5,6,7,8)
        );


### Generate the integers between 1 and 100, in random order

*Keywords*: CONNECT BY, DBMS_RANDOM

    SELECT
        level
    FROM
        dual
    CONNECT BY LEVEL < 100
    ORDER BY DBMS_RANDOM.VALUE;


### Generate the English alphabet

*Keywords*: CONNECT BY, ASCII

    SELECT
        CHR(rownum + 64) letter
    FROM
        (
            SELECT level FROM dual CONNECT BY level < 27
        );


### Print the Sonnet XVIII by Shakespeare

*Keywords*: UNPIVOT

*Reference*: http://www.oracle.com/technetwork/articles/sql/11g-pivot-097235.html

    SELECT
        sonnet_18
    FROM
        (
            (
                SELECT
                    'Shall I compare thee to a summer''s day?'              AS q1_v1,
                    'Thou art more lovely and more temperate:'              AS q1_v2,
                    'Rough winds do shake the darling buds of May,'         AS q1_v3,
                    'And summer''s lease hath all too short a date'         AS q1_v4,
                    -- 
                    'Sometime too hot the eye of heaven shines,'            AS q2_v1,
                    'And often is his gold complexion dimm''d;'             AS q2_v2,
                    'And every fair from fair sometime declines,'           AS q2_v3,
                    'By chance, or nature''s changing course, untrimm''d:'  AS q2_v4,
                    --
                    'But thy eternal summer shall not fade,'                AS q3_v1,
                    'Nor lose possession of that fair thou ow''st;'         AS q3_v2,
                    'Nor shall Death brag thou wander''st in his shade,'    AS q3_v3,
                    'When in eternal lines to time thou grow''st:'          AS q3_v4,
                    --
                    'So long as men can breathe, or eyes can see,'          AS c_v1,
                    'So long lives this, and this gives life to thee.'      AS c_v2
                FROM
                    dual
            )
            UNPIVOT
            (
                sonnet_18 FOR verse IN
                    (
                        q1_v1, q1_v2, q1_v3, q1_v4,
                        q2_v1, q2_v2, q2_v3, q2_v4,
                        q3_v1, q3_v2, q3_v3, q3_v4,
                        c_v1, c_v2
                    )
            )
        );


### List the next seven week days

*Keywords*: JSON

*Reference*: https://technology.amis.nl/2016/09/20/next-step-in-row-generation-in-oracle-database-12c-sql-using-json_table/

    SELECT
        TO_CHAR(rownum + SYSDATE, 'DAY') day
    FROM
        (
            SELECT
                rws.rn
            FROM
                JSON_TABLE('[' || RPAD('1', -1 + 2 * (7), ',1') || ']', '$[*]'
                COLUMNS ("rn" PATH '$')
            ) rws
        )  days;


### Exercises

## Numerical Recipes

### Solve Besel's problem

*Keywords*: CONNECT BY, numerical recipes

    SELECT
        SUM(POWER(level, -2))    sum,
        POWER(ATAN(1)*4, 2) / 6  pi_squared_over_six
    FROM
        dual
    CONNECT BY level < &n;


### Generate Fibonacci sequence

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


### Verify that the sum of the reciprocals of factorials converge to e

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


### Verify that the sum of the reciprocals of factorials converge to e, alternative method

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


### Verify that the cosine function has a fixed point

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


### Exercises

## Enter Imperative Thinking

### Show all Oracle error codes and messages

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


### Exercises

## The MODEL Clause

### Generate the even integers between -100 and 100, inclusive

*Keywords*: MODEL

*Reference*: http://www.orafaq.com/wiki/Oracle_Row_Generator_Techniques

    SELECT
        n
    FROM
        dual
    WHERE
        1 = 2
    MODEL
        DIMENSION BY (0 AS key)
        MEASURES     (0 AS n)
        RULES UPSERT 
        (
            n [FOR key FROM -100 TO 100 INCREMENT 2] = CV(key)
        );


### Exercises

## A Stochastic World

### Verify the law of large numbers

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


### For each tablespace T, find the probability of segments in T to be smaller than or equal to a given size

*Keywords*: probability distributions, logical storage

    SELECT
        tablespace_name, 
        CUME_DIST(&size) WITHIN GROUP (ORDER BY bytes) probability
    FROM
        dba_segments
    GROUP BY
        tablespace_name;


### Exercises

# SQL Server


## First Steps

### Show blocked sessions

*Keywords*: system tables

    USE master
    GO

    SELECT *
        FROM sys.sysprocesses
        WHERE blocked > 0;


### Show how many physical and logical cpus are available on the system

*Keywords*: system tables

    USE master
    GO

    SELECT
        cpu_count / hyperthread_ratio   [Physical CPUs],
        cpu_count                       [Logical CPUs]
    FROM sys.dm_os_sys_info;


### Show staleness of index statistics

*Keywords*: system tables, join, statistics

    SELECT
        tbl.name                                   [Table Name],
        idx.name                                   [Index Name],
        STATS_DATE(idx.object_id, idx.index_id)    [Last Updated]
    FROM 
        sys.indexes idx
    INNER JOIN 
        sys.tables  tbl
    ON idx.object_id = tbl.object_id;


### Show active sessions per user

*Keywords*: system tables, group by

    USE master
    GO

    SELECT 
        DB_NAME(dbid)  [Database],
        loginame       [Login Name],
        COUNT(dbid)    [Session Count]
    FROM
        sys.sysprocesses
    WHERE 
        dbid > 0
    GROUP BY 
        dbid, loginame;


### Correlate sessions with connections

*Keywords*: system tables, JOIN

    USE master
    GO

    SELECT
        conn.session_id,
        sess.loginame,
        sess.login_time,
        sess.hostname,
        conn.client_net_address,
        conn.client_tcp_port,
        conn.local_net_address,
        conn.local_tcp_port,
        sess.program_name,
        sess.net_library,
        conn.encrypt_option
    FROM
        sys.sysprocesses         sess
    INNER JOIN
        sys.dm_exec_connections  conn
    ON
        sess.spid = conn.session_id;


### Show sizes of tables

*Keywords*: aggregate functions

    SELECT
        tbl.name                                            [Table Name],
        scm.name                                            [Schema Name],
        prt.rows                                            [Row Counts],
        8 *  SUM(alu.total_pages)                           [Total Size (KiB)],
        8 *  SUM(alu.used_pages)                            [Used Size (KiB)],
        8 * (SUM(alu.total_pages) - SUM(alu.used_pages))    [Free Size (KiB)]
    FROM
        sys.tables tbl
    INNER JOIN
        sys.indexes idx ON tbl.object_id = idx.object_id
    INNER JOIN
        sys.partitions prt
        ON idx.object_id = prt.object_id AND idx.index_id = prt.index_id
    INNER JOIN
        sys.allocation_units alu ON prt.partition_id = alu.container_id
    LEFT OUTER JOIN
        sys.schemas scm ON tbl.schema_id = scm.schema_id
    GROUP BY
        tbl.name, scm.name, prt.rows;


### Show the sizes of every object in a database

*Keywords*: aggregate functions

*Reference*: http://stackoverflow.com/questions/2094436/


    SELECT
        t.name                            [Table Name],
        i.name                            [Index Name],
        SUM(p.rows)                       [Row Count],
        SUM(au.total_pages)               [Total Pages], 
        SUM(au.used_pages)                [Used Pages], 
        SUM(au.data_pages)                [Data Pages],
        SUM(au.total_pages) * 8 / 1024    [TotalSpace (MiB)], 
        SUM(au.used_pages)  * 8 / 1024    [UsedSpace (MiB)], 
        SUM(au.data_pages)  * 8 / 1024    [DataSpace (MiB)]
    FROM 
        sys.tables t
    INNER JOIN      
        sys.indexes i           ON t.object_id = i.object_id
    INNER JOIN 
        sys.partitions p        ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN 
        sys.allocation_units au ON p.partition_id = au.container_id
    GROUP BY 
        t.name, i.object_id, i.index_id, i.name 
    ORDER BY 
        OBJECT_NAME(i.object_id);


### Show transaction isolation level for each session

*Keywords*: CASE

    USE master
    GO

    SELECT
        session_id                         [Session ID],
        CASE transaction_isolation_level
            WHEN 0 THEN 'Unspecified'
            WHEN 1 THEN 'ReadUncommitted'
            WHEN 2 THEN 'ReadCommitted'
            WHEN 3 THEN 'Repeatable'
            WHEN 4 THEN 'Serializable'
            WHEN 5 THEN 'Snapshot'
        END                                [Transaction Isolation Level]
    FROM sys.dm_exec_sessions;


### Show database files as stored in the master database

*Keywords*: CASE

    USE master
    GO

    SELECT
        DB_NAME(database_id)                          [Database],
        name                                          [Logical Name],
        physical_name                                 [Physical Name],
        CAST((size) / 8192.0 AS DECIMAL(18,2))        [Size (MiB)],
        CASE
            WHEN type_desc = 'ROWS' THEN 'Data File(s)'
            WHEN type_desc = 'LOG'  THEN 'Log File(s)'
            ELSE type_desc
        END                                           [Type],
        state_desc                                    [Online State]
    FROM
        sys.master_files;


### Show auto-growth settings for data and log files

*Keywords*: CASE

*Reference*: http://www.handsonsqlserver.com/how-to-view-the-database-auto-growth-settings-and-correct-them/

    USE master
    GO

    SELECT
        --  database name
        DB_NAME(database_id)                          [Database],
        --  file logical name
        name                                          [Logical Name],
        --  file type
        CASE
            WHEN type_desc = 'ROWS' THEN 'Data File(s)'
            WHEN type_desc = 'LOG'  THEN 'Log File(s)'
            ELSE type_desc
        END                                           [Type],
        --  online state
        state_desc                                    [Online State],
        --  file size
        CONVERT(DECIMAL, size) / 128                  [File Size (MiB)],
        --  is file growth a percentage?
        CASE is_percent_growth
            WHEN 1 THEN 'YES' ELSE 'NO'
        END                                           [File Growth is %],
        --  file growth increment
        CASE is_percent_growth
            WHEN 1 THEN CONVERT(VARCHAR, growth) + '%'
         -- WHEN 0 THEN CONVERT(VARCHAR, growth / 128) + ' MiB'
        END AS                                        [Auto-growth Increment],
        --  file auto-growth increment
        CASE is_percent_growth
            WHEN 1 THEN (((CONVERT(DECIMAL, size) * growth) / 100) * 8) / 1024
            WHEN 0 THEN (CONVERT(DECIMAL, growth) * 8) / 1024
        END AS                                        [Auto-growth Increment (Mib)],
        --  file maximum size
        CASE max_size
            WHEN  0 THEN 'No growth is allowed'
            WHEN -1 THEN 'File will grow until the disk is full'
            ELSE CONVERT(VARCHAR, max_size)
        END AS                                        [File Max Size],
        --  file physical name
        physical_name                                 [File Physical Name]
    FROM
        sys.master_files;


### Exercises


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

## Numerical Recipes

### Generate Fibonacci sequence (OEIS A000045), recursive version

*Reference*: http://stackoverflow.com/questions/21746100/

    DECLARE @Nmax INT;
    SET @Nmax = 1000000000;

    WITH fibonacci(PrevN, N) AS
        (
            SELECT
                0, 1
            UNION ALL SELECT
                N, PrevN + N
            FROM
                fibonacci
            WHERE
                N < @Nmax
        )
    SELECT PrevN [n-th Fibonacci number] FROM fibonacci
    OPTION (MAXRECURSION 0);


## Enter Imperative Thinking

### Return information about each request that is executing within the database server, including the SQL text

*Keywords*: CROSS APPLY

    USE master
    GO

    SELECT
        req.session_id            [Session ID],
        req.status                [Status],
        req.command               [Command],
        req.cpu_time              [CPU Time],
        req.total_elapsed_time    [Elapsed Time],
        sqltext.text              [SQL Text]
    FROM
        sys.dm_exec_requests             req
    CROSS APPLY
        sys.dm_exec_sql_text(sql_handle) sqltext;


### Show last execution time of all queries

*Keywords*: CROSS APPLY

    USE master
    GO

    SELECT
        stats.last_execution_time    [Last Exec Time],
        sql.text                     [Query Text],
        DB_NAME(sql.dbid)            [Database]
    FROM
        sys.dm_exec_query_stats stats
    CROSS APPLY
        sys.dm_exec_sql_text(stats.sql_handle) sql;


### Show last executed queries by session

*Keywords*: JOIN, CROSS APPLY

    USE master
    GO

    SELECT
        conn.session_id    [Session ID],
        sql.text           [Query Text],
        sess.login_name    [Login Name],
        sess.login_time    [Login Time],
        sess.status        [Session Status]
    FROM
        sys.dm_exec_connections conn
    INNER JOIN
        sys.dm_exec_sessions    sess 
    ON
        conn.session_id = sess.session_id
    CROSS APPLY
        sys.dm_exec_sql_text(most_recent_sql_handle) sql;


### Show basic aggregate performance statistics for cached query plans

*Keywords*: JOIN, CROSS APPLY, time functions

    USE master
    GO

    SELECT DISTINCT TOP 10
        sql.text                                                         [Query Text],
        stats.execution_count                                            [Execution Count],
        stats.max_elapsed_time                                           [Max Elapsed Time],
        ISNULL(stats.total_elapsed_time
               / stats.execution_count, 0)                               [Avg Elapsed Time],
        stats.creation_time                                              [Plan Compiled On],
        ISNULL(stats.execution_count
               / DATEDIFF(second, stats.creation_time, GETDATE()), 0)    [Frequency]
    FROM
        sys.dm_exec_query_stats stats
    CROSS APPLY
        sys.dm_exec_sql_text(stats.sql_handle) sql
    ORDER BY
        stats.max_elapsed_time DESC;


### Capture object deletion events

*Keywords*: cross apply

*Reference*: Robert Pearl, Healthy SQL, p. 350

    USE master
    GO

    SELECT
        [LoginName],
        [HostName],
        [StartTime],
        [ObjectName],
        [TextData]
    FROM
        sys.trace_events te
    JOIN
        ::fn_trace_gettable((SELECT path FROM sys.traces WHERE is_default = 1), DEFAULT)
    ON
        te.trace_event_id = eventclass
    WHERE
        te.name = 'Object:Deleted'
    ORDER BY
        [StartTime] DESC;


### Show auto grow and auto shrink events

*Keywords*: cross apply

*Reference*: http://www.sqldbadiaries.com/2010/11/18/how-many-times-did-my-database-auto-grow/

    USE master
    GO

    SELECT
        DB_NAME(databaseid)         [Database],
        filename                    [File Name],
        te.name                     [Event Type],
        SUM(integerdata / 128)      [Growth (MiB)],
        duration / 1000             [Duration (sec)]
    FROM
        sys.trace_events te
    JOIN
        ::fn_trace_gettable((SELECT path FROM sys.traces WHERE is_default = 1), DEFAULT)
    ON
        te.trace_event_id = eventclass
    WHERE
        te.name LIKE '%Auto Shrink%' OR te.name LIKE '%Auto Grow%'
    GROUP BY
        starttime, databaseid, filename, name, integerdata, duration
    ORDER BY
        starttime DESC;


### Exercises

