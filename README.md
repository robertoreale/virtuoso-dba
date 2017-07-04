The Virtuoso DBA
===

## Calculate the size of the temporary tablespaces

*Keywords*: aggregate functions, dynamics views, logical storage

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

*Keywords*: 

Hint: Assume a FQDN has the form N_1.N_2….N_t, where t > 1 and each N_i can contain lowercase letters, numbers and the dash (-)).
 
SELECT machine   from v$session where  REGEXP_LIKE(machine, '^([a-z0-9-]+\.)+[a-z0-9-]+$') ;

