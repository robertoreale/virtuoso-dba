--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    SQL Server
--  Module:    objects
--  Submodule: obj_sizes
--  Purpose:   shows the sizes of every object in a database
--  Reference: http://stackoverflow.com/questions/2094436/
--  Tested:    2012
--
--  Copyright (c) 2015 Roberto Reale
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


SELECT
    t.name                            [Table Name],
    i.name                            [Index Name],
    SUM(p.rows)                       [Row Count],
    SUM(au.total_pages)               [Total Pages], 
    SUM(au.used_pages)                [Used Pages], 
    SUM(au.data_pages)                [Data Pages],
    SUM(au.total_pages) * 8 / 1024    [TotalSpace (MiB)], 
    SUM(au.used_pages)  * 8 / 1024    [UsedSpace (MiB)], 
    SUM(au.data_pages)  * 8 / 1024    [DataSpace (MiB)]
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units au ON p.partition_id = au.container_id
GROUP BY 
    t.name, i.object_id, i.index_id, i.name 
ORDER BY 
    OBJECT_NAME(i.object_id);

--  ex: ts=4 sw=4 et filetype=sql
