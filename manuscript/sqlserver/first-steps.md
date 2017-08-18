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


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
