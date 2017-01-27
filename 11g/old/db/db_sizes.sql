--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    db
--  Submodule: db_sizes
--  Purpose:   total and used space on the database
--  Tested:    10g, 11g
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


CLEAR COLUMN

COL alloc_space    HEADING "Total Space (MiB)"
COL used_space     HEADING "Used Space (MiB)"
COL free_space     HEADING "Free Space(MiB)"


SELECT
    alloc_space                 AS alloc_space,
    alloc_space - free_space    AS used_space,
    free_space                  AS free_space
FROM
    (
        SELECT
            (SELECT SUM(bytes / 1048576) from dba_data_files)   AS alloc_space,
            (SELECT SUM(bytes / 1048576) from dba_free_space)   AS free_space
        FROM dual
    );

--  ex: ts=4 sw=4 et filetype=sql
