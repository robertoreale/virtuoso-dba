--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    statspack
--  Submodule: sp_top_cpu_intensive_queries
--  Purpose:   top-10 CPU-intensive queries
--  Reference: https://community.oracle.com/thread/1101381
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

COL start_time  FORMAT a10
COL stop_time   FORMAT a10
COL module      FORMAT a15 TRUNC
COL text_subset FORMAT a30 TRUNC

COL bg  FORMAT '99'
COL ex  FORMAT '99'
COL ct  FORMAT '99'
COL et  FORMAT '99'
COL rp  FORMAT '99'
COL dr  FORMAT '99'
COL pc  FORMAT '99'
COL iv  FORMAT '99'
COL ld  FORMAT '99'
COL gpe FORMAT '99.9'


WITH snaps AS
    (
        SELECT
            dbid                                                             AS dbid,
            instance_number                                                  AS instance_number,
            TO_CHAR(snap_time, 'DD/MM/YYYY')                                 AS snap_day,
            snap_id                                                          AS start_snap,
            LEAD(snap_id) OVER (ORDER BY snap_time)                          AS stop_snap,
            TO_CHAR(snap_time, 'HH24:MI')                                    AS start_time,
            LEAD(TO_CHAR(snap_time, 'HH24:MI')) OVER (ORDER BY snap_time)    AS stop_time
        FROM
            stats$snapshot
    ),
work AS
    (
        SELECT 
            s.snap_day                                              AS snap_day,
            s.start_snap                                            AS start_snap,
            s.stop_snap                                             AS stop_snap,
            s.start_time                                            AS start_time,
            s.stop_time                                             AS stop_time,
            ss1.hash_value                                          AS hash_value,
            ss1.module                                              AS module,
            ss1.text_subset                                         AS text_subset,
            SUM(ss1.buffer_gets    - NVL(ss2.buffer_gets, 0))       AS bg,
            SUM(ss1.executions     - NVL(ss2.executions, 0))        AS ex,
            SUM(ss1.cpu_time       - NVL(ss2.cpu_time, 0))          AS ct,
            SUM(ss1.elapsed_time   - NVL(ss2.elapsed_time, 0))      AS et,
            SUM(ss1.rows_processed - NVL(ss2.rows_processed, 0))    AS rp,
            SUM(ss1.disk_reads     - NVL(ss2.disk_reads, 0))        AS dr,
            SUM(ss1.parse_calls    - NVL(ss2.parse_calls, 0))       AS pc,
            SUM(ss1.invalidations  - NVL(ss2.invalidations, 0))     AS iv,
            SUM(ss1.loads          - NVL(ss2.loads, 0))             AS ld
        FROM
            snaps s
        JOIN
            stats$sql_summary ss1
        ON
                   ss1.snap_id         = s.stop_snap
            AND    ss1.dbid            = s.dbid
            AND    ss1.instance_number = s.instance_number
        JOIN
            stats$sql_summary ss2
        ON
                   ss2.snap_id         = s.start_snap
            AND    ss2.dbid            = ss1.dbid
            AND    ss2.instance_number = ss1.instance_number
            AND    ss2.hash_value      = ss1.hash_value
            AND    ss2.address         = ss1.address
            AND    ss2.text_subset     = ss1.text_subset
            AND    ss1.executions      > NVL(ss2.executions, 0)
        WHERE
            s.stop_snap IS NOT NULL
        GROUP BY 
            s.snap_day,
            s.start_snap,
            s.stop_snap,
            s.start_time,
            s.stop_time,
            ss1.hash_value,
            ss1.module,
            ss1.text_subset
    ),
top_n AS
    (
        SELECT
            w.*,
            bg / ex    AS gpe,
            ROW_NUMBER() OVER
                (
                    PARTITION BY start_snap ORDER BY ct DESC
                )      AS nr
        FROM
            work w
    )
SELECT
    snap_day,
    start_snap,
    stop_snap,
    start_time,
    stop_time,
    hash_value,
    module,
    text_subset,
    bg,    -- buffer gets
    ex,    -- executions
    ct,    -- cpu time
    et,    -- elapsed time
    rp,    -- rows processed
    dr,    -- disk reads
    pc,    -- parse calls
    iv,    -- invalidations
    ld,    -- loads
    gpe    -- gets per execs
FROM
    top_n
WHERE
    nr <= 10;

--  ex: ts=4 sw=4 et filetype=sql
