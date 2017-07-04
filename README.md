The Virtuoso DBA
===

## Calculate the size of the temporary tablespaces

*Keywords*: aggregate functions, dynamic views, logical storage

    SELECT
        inst_id,
        ts.name,
        tmpf.block_size,
        SUM(tmpf.bytes) AS bytes
    FROM
        gv$tablespace ts
    JOIN
        gv$tempfile tmpf
    USING
        (inst_id, ts#)
    GROUP BY
        inst_id, ts.name, tmpf.block_size;


## Display hidden/undocumented initialization parameters

*Keywords*: DECODE function

*Reference*: http://www.oracle-training.cc/oracle_tips_hidden_parameters.htm

    SELECT
        i.ksppinm                AS name,
        cv.ksppstvl              AS value,
        cv.ksppstdf              AS def,
        DECODE
            (
                i.ksppity,
                1, 'boolean',
                2, 'string',
                3, 'number',
                4, 'file',
                i.ksppity
            )                    AS type,
        i.ksppdesc               AS description
    FROM
        sys.x$ksppi i JOIN sys.x$ksppcv cv USING (indx)
    WHERE
        i.ksppinm LIKE '\_%' ESCAPE '\'
    ORDER BY
        name;


## Count the client sessions with a FQDN

*Keywords*: regular expressions, dynamic views

Assume a FQDN has the form N_1.N_2.….N_t, where t > 1 and each N_i can contain lowercase letters, numbers and the dash.
 
    SELECT
        machine
    FROM
        gv$session
    WHERE
        REGEXP_LIKE(machine, '^([[:alnum:]]+\.)+[[:alnum:]-]+$');


## Show the maximum possible date

*Keywords*: time functions

*Reference*: http://stackoverflow.com/questions/687510/

December 31, 9999 CE, one second to midnight.

    SELECT
        TO_CHAR(
            TO_DATE('9999-12-31', 'YYYY-MM-DD')
            + (1 - 1/24/60/60),
        'DD-MON-YYYY hh12:mi:ss AD') AS latest_date
    FROM
        dual;


## Show the minimum possible date

*Keywords*: time functions

*Reference*: http://stackoverflow.com/questions/687510/, Oracle bug 106242

    SELECT 
        TO_CHAR(TO_DATE(1, 'J'), 'DD-MON-YYYY hh12:mi:ss AD') AS earliest_date
    FROM
        dual;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
