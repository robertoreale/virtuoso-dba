--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    SQL Server
--  Module:    backups
--  Submodule: bck_last_restores
--  Purpose:   shows info about the last restore operation, for each database
--  Reference: dba.stackexchange.com/questions/33703
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

WITH LastRestores AS
    (
        SELECT
            db.name,
            db.create_date,
            rhist.restore_date,
            rhist.destination_database_name,
            rhist.backup_set_id,
            rhist.restore_history_id,
            rownum = ROW_NUMBER() OVER (
                PARTITION BY db.name ORDER BY rhist.restore_date DESC
            )
        FROM
            sys.databases db
        LEFT OUTER JOIN
            msdb.dbo.restorehistory rhist
        ON rhist.destination_database_name = db.name
    )
SELECT
    name                         [Database],
    create_date                  [Creation Date],
    restore_date                 [Restore Date],
    destination_database_name    [Destination],
    backup_set_id                [Backup Set ID],
    restore_history_id           [Restore History ID]
FROM LastRestores
    WHERE rownum = 1;

--  ex: ts=4 sw=4 et filetype=sql
