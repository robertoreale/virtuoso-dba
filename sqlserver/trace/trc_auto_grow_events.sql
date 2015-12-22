--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    trace
--  Submodule: trc_auto_grow_events
--  Purpose:   shows auto grow and auto shrink events
--  Reference: http://www.sqldbadiaries.com/2010/11/18/how-many-times-did-my-database-auto-grow/
--  Tested:    2012
--
--  Copyright (c) 2015 Roberto Reale
--  
--  Permission is hereby granted, free of charge, to any person obtaining a
--  copy of this software and associated documentation files (the "Software"),
--  to deal in the Software without restriction, including without limitation
--  the rights to use, copy, modify, merge, publish, distribute, sublicense,
--  and/or sell copies of the Software, and to permit persons to whom the
--  Software is furnished to do so, subject to the following conditions:
--  
--  The above copyright notice and this permission notice shall be included in
--  all copies or substantial portions of the Software.
--  
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
--  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
--  DEALINGS IN THE SOFTWARE.
-- 
--------------------------------------------------------------------------------


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

--  ex: ts=4 sw=4 et filetype=sql
