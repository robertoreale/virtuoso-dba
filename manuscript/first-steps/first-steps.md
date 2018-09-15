## First Steps

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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
