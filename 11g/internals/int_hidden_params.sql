--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    int
--  Submodule: int_hidden_params
--  Purpose:   display hidden/undocumented initialization parameters
--  Reference: http://www.oracle-training.cc/oracle_tips_hidden_parameters.htm
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
SET LINE 200

COL name        FORMAT a50
COL value       FORMAT a10 TRUNCATE
COL def         FORMAT a10
col type        FORMAT a10
col description FORMAT a70 TRUNCATE


SELECT
    i.ksppinm                AS name,
    cv.ksppstvl              AS value,
    cv.ksppstdf              AS def,
    DECODE
        (
            i.ksppity,
            1, 'boolean',
            2, 'string',
            3, 'number',
            4, 'file',
            i.ksppity
        )                    AS type,
    i.ksppdesc               AS description
FROM
    sys.x$ksppi i JOIN sys.x$ksppcv cv USING (indx)
WHERE
    i.ksppinm LIKE '\_%' ESCAPE '\'
ORDER BY
    name;
   
--  ex: ts=4 sw=4 et filetype=sql
