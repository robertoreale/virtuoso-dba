## First Steps

### Show blocked sessions

    USE master
    GO

    SELECT *
        FROM sys.sysprocesses
        WHERE blocked > 0;


### Show active sessions per user

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

*Keywords*: JOIN

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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
