## Enter Imperative Thinking

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
