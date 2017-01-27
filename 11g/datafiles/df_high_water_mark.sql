--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    datafiles
--  Submodule: df_high_water_mark
--  Purpose:   shows high-water and excess allocated size for datafiles
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
SET LINESIZE 160

COL file_name HEADING "File Name" FORMAT a50 TRUNCATED
COL file_size HEADING "File Size (MiB)" FORMAT "999999.99"
COL hwm       HEADING "HWM (MiB)" FORMAT "999999.99"
COL excess    HEADING "Excess (MiB)" FORMAT "999999.99"


WITH pars AS
    (
        -- block size in MiB
        SELECT
            TO_NUMBER(value) / 1048576  AS block_size_mb
        FROM
            v$parameter
        WHERE
            name = 'db_block_size'
    )
SELECT
    file_name,
    blocks                 * pars.block_size_mb  AS file_size,
    NVL(hwm, 1)            * pars.block_size_mb  AS hwm,
    (blocks - NVL(hwm, 1)) * pars.block_size_mb  AS excess
FROM
    pars,
    dba_data_files df
JOIN
    (
        SELECT
            file_id,
            MAX(block_id + blocks - 1)  AS hwm
        FROM
            dba_extents
        GROUP BY
            file_id
    ) ext
USING (file_id);

--  ex: ts=4 sw=4 et filetype=sql
