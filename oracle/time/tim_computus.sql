--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    time
--  Submodule: tim_computus
--  Purpose:   calculates the calendar date of Easter, from 1583 to 2999
--  Reference: http://www.adp-gmbh.ch/ora/plsql/calendar.html
--  Tested:    10g, 11g
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

CLEAR COLUMN
SET LINE 200


WITH t0 AS
    (
        SELECT
            LEVEL + 1582 AS year
        FROM
            dual
        CONNECT BY LEVEL <= 2299 - 1582
    ),
t1 AS
(
    SELECT
        year,
        CASE
            WHEN year < 1700 THEN 22
            WHEN year < 1900 THEN 23
            WHEN year < 2200 THEN 24
            ELSE 25
        END AS m,
        CASE
            WHEN year < 1700 THEN 2
            WHEN year < 1800 THEN 3
            WHEN year < 1900 THEN 4
            WHEN year < 2100 THEN 5
            WHEN year < 2200 THEN 6
            ELSE 0
        END AS n,
        MOD(year, 19) AS a,
        MOD(year, 4)  AS b,
        MOD(year, 7)  AS c
    FROM
        t0
),
t2 AS
(
    SELECT
        year, m, n, a, b, c,
        MOD(19 * a + m, 30) AS d
    FROM
        t1
),
t3 AS
(
    SELECT
        year, m, n, a, b, c, d,
        MOD(2 * b + 4 * c + 6 * d + n, 7) AS e
    FROM
        t2
),
t4 AS
(
    SELECT
        year, m, n, a, b, c, d, e,
        22 + d + e AS day,
        3          AS month
    FROM
        t3
),
t5 AS
(
    SELECT
        year, m, n, a, b, c, d, e,
        CASE
            WHEN day > 31 THEN day - 31
            ELSE day
        END AS day,
        CASE
            WHEN day > 31 THEN month + 1
            ELSE month
        END AS month
    FROM
        t4
),
t6 AS
(
    SELECT
        year,
        CASE
            WHEN day = 26 AND month = 4 THEN 19
            WHEN day = 25 AND month = 4 AND d = 28 AND e = 6 AND a > 10 THEN 18
            ELSE day
        END AS day,
        month
    FROM
        t5
),
t7 AS
(
    SELECT
        year,
        TO_DATE(
            TO_CHAR(day,    '00'  ) ||
            TO_CHAR(month,  '00'  ) ||
            TO_CHAR(year,   '0000'),
            'DDMMYYYY'
        ) AS easter_sunday
    FROM
        t6
)
SELECT
    year,
    easter_sunday - 52    AS jeudi_gras,
    easter_sunday - 48    AS carnival_monday,
    easter_sunday - 47    AS mardi_gras,
    easter_sunday - 46    AS ash_wednesday,
    easter_sunday - 7     AS palm_sunday,
    easter_sunday - 3     AS maundy_thursday,
    easter_sunday - 2     AS good_friday,
    easter_sunday - 1     AS holy_saturday,
    easter_sunday         AS easter_sunday,
    easter_sunday + 1     AS easter_monday,
    easter_sunday + 39    AS ascension_of_christ,
    easter_sunday + 49    AS whitsunday,
    easter_sunday + 50    AS whitmonday,
    easter_sunday + 60    AS corpus_christi
FROM
    t7;

--  ex: ts=4 sw=4 et filetype=sql
