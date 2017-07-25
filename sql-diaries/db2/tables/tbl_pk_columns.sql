--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    DB2
--  Module:    tables
--  Submodule: tbl_pk_columns
--  Purpose:   finds the primary-key columns for all tables
--  Reference: http://mainframestutor.in/useful-db2-queries/
--  Tested:    10.5.6
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


SET LINESIZE 120

SELECT 
    SUBSTR(tbcreator, 1, 30)    AS table_creator,
    SUBSTR(tbname,    1, 30)    AS table_name,
    SUBSTR(name,      1, 30)    AS column_name
FROM
    sysibm.syscolumns
WHERE
    keyseq > 0
ORDER BY
    keyseq ASC WITH UR;

--  ex: ts=4 sw=4 et filetype=sql
