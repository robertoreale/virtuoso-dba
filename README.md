The Virtuoso DBA
===

# Calculate the size of the temporary tablespaces

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
