# Row Generation

## List all integers between 00 and FF, hexadecimal

*Keywords*: CONNECT BY, TO_CHAR

    SELECT TO_CHAR(level - 1, '0X') AS n FROM dual CONNECT BY level <= 256;


## List all integers between 00000000 and 11111111, hexadecimal

*Keywords*: CONNECT BY, DECODE, bitwise operations

    SELECT 
        DECODE(BITAND(level - 1, 128), 128, '1', '0') ||
        DECODE(BITAND(level - 1,  64),  64, '1', '0') ||
        DECODE(BITAND(level - 1,  32),  32, '1', '0') ||
        DECODE(BITAND(level - 1,  16),  16, '1', '0') ||
        DECODE(BITAND(level - 1,   8),   8, '1', '0') ||
        DECODE(BITAND(level - 1,   4),   4, '1', '0') ||
        DECODE(BITAND(level - 1,   2),   2, '1', '0') ||
        DECODE(BITAND(level - 1,   1),   1, '1', '0') AS n
    FROM
        dual
    CONNECT BY level <= 256;


## Generate the integers between 1 and 256

*Keywords*: GROUP BY CUBE

*Reference*: https://technology.amis.nl/2005/02/11/courtesy-of-tom-kyte-generating-rows-in-sql-with-the-cube-statement-no-dummy-table-or-table-function-required/

    SELECT
        rownum
    FROM
        (
            SELECT 1 FROM dual GROUP BY CUBE (1,2,3,4,5,6,7,8)
        );


## Generate the integers between 1 and 100, in random order

*Keywords*: CONNECT BY, DBMS_RANDOM

    SELECT
        level
    FROM
        dual
    CONNECT BY LEVEL < 100
    ORDER BY DBMS_RANDOM.VALUE;


## Generate the English alphabet

*Keywords*: CONNECT BY, ASCII

    SELECT
        CHR(rownum + 64) letter
    FROM
        (
            SELECT level FROM dual CONNECT BY level < 27
        );


## Print the Sonnet XVIII by Shakespeare

*Keywords*: UNPIVOT

*Reference*: http://www.oracle.com/technetwork/articles/sql/11g-pivot-097235.html

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


## List the next seven week days

*Keywords*: JSON

*Reference*: https://technology.amis.nl/2016/09/20/next-step-in-row-generation-in-oracle-database-12c-sql-using-json_table/

    SELECT
        TO_CHAR(rownum + SYSDATE, 'DAY') day
    FROM
        (
            SELECT
                rws.rn
            FROM
                JSON_TABLE('[' || RPAD('1', -1 + 2 * (7), ',1') || ']', '$[*]'
                COLUMNS ("rn" PATH '$')
            ) rws
        )  days;


## Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
