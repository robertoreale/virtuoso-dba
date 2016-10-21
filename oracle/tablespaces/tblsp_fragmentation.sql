--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    tablespaces
--  Submodule: tblsp_fragmentation
--  Purpose:   XXX
--  Tested:    11g
--
--  Copyright (c) 2016 Roberto Reale
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

COL tablespace     FORMAT a30
COL free_chunks    FORMAT 9999999999
COL largest_chunk  FORMAT 9999999999.99
COL fragmentation  FORMAT 999.99

--------------------------------------------------------------------------------
--
--  The fragmentation column gives an overall score with respect to how badly a
--  tablespace is fragmented; a 100% score indicates no fragmentation at all.
--  It is calculated according to the following formula:
--
--                         ___________      
--                       \/max(blocks)      
--                                  
--             1 - ------------------------ 
--                                  
--                             =====        
--                  4_______   \            
--                 \/blocks#    >    blocks 
--                             /            
--                             =====        
-- 
-- 
--  Cf. the book ``Oracle Performance Troubleshooting'', by Robin Schumacher.
-- 
--------------------------------------------------------------------------------


SELECT
    tablespace_name               AS tablespace,
    COUNT(*)                      AS free_chunks,
    NVL(MAX(bytes) / 1048576, 0)  AS largest_chunk,
    100 * (
        1 - NVL(SQRT(MAX(blocks) / (SQRT(SQRT(COUNT(blocks))) * SUM(blocks))), 0)
    )                             AS fragmentation
FROM
    sys.dba_free_space
GROUP BY
    tablespace_name;

--  ex: ts=4 sw=4 et filetype=sql
