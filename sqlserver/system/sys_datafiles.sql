--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    SQL Server
--  Module:    system
--  Submodule: sys_datafiles
--  Purpose:   database files as stored in the master database
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
    DB_NAME(database_id)                          [Database],
    name                                          [Logical Name],
    physical_name                                 [Physical Name],
    CAST((size) / 8192.0 AS DECIMAL(18,2))        [Size (MiB)],
    CASE
        WHEN type_desc = 'ROWS' THEN 'Data File(s)'
        WHEN Type_Desc = 'LOG'  THEN 'Log File(s)'
        ELSE Type_Desc
    END                                           [Type],
    state_desc                                    [Online State]
FROM
    sys.master_files;

--  ex: ts=4 sw=4 et filetype=sql
