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

## Count the client sessions with a FQDN

*Keywords*: regular expressions, dynamic views

Assume a FQDN has the form N_1.N_2.….N_t, where t > 1 and each N_i can contain lowercase letters, numbers and the dash.
 
    SELECT
        machine
    FROM
        v$session
    WHERE
        REGEXP_LIKE(machine, '^([[:alnum:]]+\.)+[[:alnum:]-]+$');


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
