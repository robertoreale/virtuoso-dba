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

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
