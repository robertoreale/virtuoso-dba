--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    backups
--  Submodule: bck_database_growth
--  Purpose:   shows database growth from backups
--  Reference: http://www.sqlskills.com/blogs/erin/trending-database-growth-from-backups/
--  Tested:    2012
--
--  Copyright (c) 2014-5 Roberto Reale
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

--  ex: ts=4 sw=4 et filetype=sql
