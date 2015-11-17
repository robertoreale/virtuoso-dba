--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    addm
--  Submodule: addm_task_params
--  Purpose:   shows the parameters that are configured for each ADDM task
--  Reference: http://www.remote-dba.net/oracle_10g_tuning/t_addm_diagnostic_advisor.htm
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

COL owner           FORMAT a15
COL task_name       FORMAT a30
COL parameter_name  FORMAT a30
COL parameter_value FORMAT a30


SELECT
    t.owner,
    t.task_name,
    p.parameter_name,
    p.parameter_value
FROM
    dba_advisor_tasks      t
JOIN
    dba_advisor_parameters p
ON
    t.task_id = p.task_id
ORDER BY
    t.owner, t.task_name, p.parameter_name;

--  ex: ts=4 sw=4 et filetype=sql
