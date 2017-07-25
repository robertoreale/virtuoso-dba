--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    system
--  Submodule: sys_db_files_growth
--  Purpose:   shows auto-growth settings for data and log files
--  Reference: http://www.handsonsqlserver.com/how-to-view-the-database-auto-growth-settings-and-correct-them/
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

--  ex: ts=4 sw=4 et filetype=sql
