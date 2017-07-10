# First Steps

## Show database role (primary, standby, etc.)

*Keywords*: dynamic views, data guard

    SELECT database_role FROM gv$database;


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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
