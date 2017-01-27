--------------------------------------------------------------------------------
--
--  The SQL Diaries
-- 
--  Phylum:    Oracle
--  Module:    syn
--  Submodule: syn_unpivot
--  Purpose:   using the UNPIVOT clause
--  Reference: http://www.oracle.com/technetwork/articles/sql/11g-pivot-097235.html
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

SET PAGESIZE 20
COL sonnet_18 HEADING "Sonnet 18"


SELECT
    sonnet_18
FROM
    (
        (
            SELECT
                'Shall I compare thee to a summer''s day?'              AS q1_v1,
                'Thou art more lovely and more temperate:'              AS q1_v2,
                'Rough winds do shake the darling buds of May,'         AS q1_v3,
                'And summer''s lease hath all too short a date'         AS q1_v4,
                -- 
                'Sometime too hot the eye of heaven shines,'            AS q2_v1,
                'And often is his gold complexion dimm''d;'             AS q2_v2,
                'And every fair from fair sometime declines,'           AS q2_v3,
                'By chance, or nature''s changing course, untrimm''d:'  AS q2_v4,
                --
                'But thy eternal summer shall not fade,'                AS q3_v1,
                'Nor lose possession of that fair thou ow''st;'         AS q3_v2,
                'Nor shall Death brag thou wander''st in his shade,'    AS q3_v3,
                'When in eternal lines to time thou grow''st:'          AS q3_v4,
                --
                'So long as men can breathe, or eyes can see,'          AS c_v1,
                'So long lives this, and this gives life to thee.'      AS c_v2
            FROM
                dual
        )
        UNPIVOT
        (
            sonnet_18 FOR verse IN
                (
                    q1_v1, q1_v2, q1_v3, q1_v4,
                    q2_v1, q2_v2, q2_v3, q2_v4,
                    q3_v1, q3_v2, q3_v3, q3_v4,
                    c_v1, c_v2
                )
        )
    );

--  ex: ts=4 sw=4 et filetype=sql
