--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    asm
--  Submodule: asm_parameters
--  Purpose:   shows the ASM parameters and underscore (i.e. hidden) parameters
--  Reference: https://sites.google.com/site/oracledbnote/automaticstoragemanagement/asm-metadata-and-internals
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
SET LINE 100

COL parameter FORMAT a50 HEADING "Parameter"
COL value     FORMAT a45 HEADING "Instance Value"


SELECT
    a.ksppinm     AS parameter,
    c.ksppstvl    AS value
FROM
    x$ksppi a
JOIN
    x$ksppcv b USING (indx)
JOIN
    x$ksppsv c USING (indx)
WHERE
    ksppinm LIKE '%asm%'
ORDER BY
    a.ksppinm;

--  ex: ts=4 sw=4 et filetype=sql
