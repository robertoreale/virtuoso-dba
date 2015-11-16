--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Philum:    Oracle
--  Module:    logs
--  Submodule: log_switches_by_hour
--  Purpose:   counts log file switches, day by day, hour by hour
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

COL "00" FORMAT a4
COL "01" FORMAT a4
COL "02" FORMAT a4
COL "03" FORMAT a4
COL "04" FORMAT a4
COL "05" FORMAT a4
COL "06" FORMAT a4
COL "07" FORMAT a4
COL "08" FORMAT a4
COL "09" FORMAT a4
COL "10" FORMAT a4
COL "11" FORMAT a4
COL "12" FORMAT a4
COL "13" FORMAT a4
COL "14" FORMAT a4
COL "15" FORMAT a4
COL "16" FORMAT a4
COL "17" FORMAT a4
COL "18" FORMAT a4
COL "19" FORMAT a4
COL "20" FORMAT a4
COL "21" FORMAT a4
COL "22" FORMAT a4
COL "23" FORMAT a4


ALTER SESSION SET nls_date_format = 'YYYY-MM-DD';

SELECT
    TO_CHAR(first_time, 'YYYY-MM-DD')                                       AS DAY,
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '00', 1, 0)), '999')    AS "00",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '01', 1, 0)), '999')    AS "01",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '02', 1, 0)), '999')    AS "02",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '03', 1, 0)), '999')    AS "03",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '04', 1, 0)), '999')    AS "04",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '05', 1, 0)), '999')    AS "05",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '06', 1, 0)), '999')    AS "06",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '07', 1, 0)), '999')    AS "07",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '08', 1, 0)), '999')    AS "08",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '09', 1, 0)), '999')    AS "09",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '10', 1, 0)), '999')    AS "10",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '11', 1, 0)), '999')    AS "11",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '12', 1, 0)), '999')    AS "12",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '13', 1, 0)), '999')    AS "13",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '14', 1, 0)), '999')    AS "14",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '15', 1, 0)), '999')    AS "15",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '16', 1, 0)), '999')    AS "16",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '17', 1, 0)), '999')    AS "17",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '18', 1, 0)), '999')    AS "18",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '19', 1, 0)), '999')    AS "19",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '20', 1, 0)), '999')    AS "20",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '21', 1, 0)), '999')    AS "21",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '22', 1, 0)), '999')    AS "22",
    TO_CHAR(SUM(DECODE(TO_CHAR(first_time, 'HH24'), '23', 1, 0)), '999')    AS "23"
FROM
    v$log_history
GROUP BY
    TO_CHAR(first_time, 'YYYY-MM-DD')
ORDER BY
    TO_CHAR(first_time, 'YYYY-MM-DD');

--  ex: ts=4 sw=4 et filetype=sql
