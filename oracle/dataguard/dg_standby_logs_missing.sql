--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    dg
--  Submodule: dg_standby_logs_not_applied_gap
--  Purpose:   basic info about sequence archive log not sent
--  Reference: mmonteverde@faberbits.com / matias.monteverde@gmail.com
--  Tested:    10g, 11g
--
--  Copyright (c) 2014-5 Matias Monteverde Giannini
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


--
--  Check for LOGSEQ Arch lost and not applied and generate state WAIT_FOR_GAP
--
-- Run in standby database
--


SELECT high.thread#, "LowGap#", "HighGap#"
FROM
       (
       SELECT thread#, MIN(sequence#)-1 "HighGap#"
      FROM
       (
           SELECT a.thread#, a.sequence#
           FROM
           (
               SELECT *
               FROM v$archived_log
          ) a,
           (
              SELECT thread#, MAX(next_change#)gap1
                FROM v$log_history
                GROUP BY thread#
            ) b
            WHERE a.thread# = b.thread#
            AND a.next_change# > gap1
        )
        GROUP BY thread#
    ) high,
    (
        SELECT thread#, MIN(sequence#) "LowGap#"
        FROM
        (
            SELECT thread#, sequence#
            FROM v$log_history, v$datafile
            WHERE checkpoint_change# <= next_change#
            AND checkpoint_change# >= first_change#
        )
        GROUP BY thread#
    ) low
   WHERE low.thread# = high.thread#
/
