--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    backups
--  Submodule: bck_database_growth_rate
--  Purpose:   identifes database growth rates from backups
--  Reference: https://www.mssqltips.com/sqlservertip/3690/
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

--  ex: ts=4 sw=4 et filetype=sql
