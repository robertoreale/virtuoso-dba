# Internals

## Count the number of trace files generated each day

*Keywords*: x$ interface

    SELECT
        TRUNC(creation_time, 'DDD') day,
        COUNT(*) count
    FROM x$dbgdirext
        WHERE
            type = 2 AND logical_file LIKE '%.trc'
        GROUP BY TRUNC(creation_time, 'DDD')
        ORDER BY 2 DESC;


## Display hidden/undocumented initialization parameters

*Keywords*: DECODE function, x$ interface

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


## Display the number of ASM allocated and free allocation units

*Keywords*: PIVOT emulation, x$ interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        group_kfdat                                       AS group#,
        number_kfdat                                      AS disk#,
        --  emulate the PIVOT functions which is missing in 10g
        SUM(CASE WHEN v_kfdat = 'V' THEN 1 ELSE 0 END)    AS alloc_au,
        SUM(CASE WHEN v_kfdat = 'F' THEN 1 ELSE 0 END)    AS free_au
    FROM
        x$kfdat
    GROUP BY
        group_kfdat, number_kfdat;


## Display the count of allocation units per ASM file by file alias (for metadata only)

*Keywords*: x$interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        COUNT(xnum_kffxp)    AS au_count,
        number_kffxp         AS file#,
        group_kffxp          AS dg#
    FROM
        x$kffxp
    WHERE
        number_kffxp < 256
    GROUP BY
        number_kffxp, group_kffxp
    ORDER BY
        COUNT(xnum_kffxp);


## Display the count of allocation units per ASM file by file alias

*Keywords*: x$interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        group_kffxp,
        number_kffxp,
        name,
        COUNT(*) count
    FROM
        x$kffxp
    JOIN
        v$asm_alias
    ON
        group_kffxp = group_number AND number_kffxp = file_number
    GROUP BY
        group_kffxp, number_kffxp, name
    ORDER BY
        group_kffxp, number_kffxp;


## Show file utilization

*Keywords*: x$interface, asm

*Reference*: MOS Doc ID 351117.1

    SELECT
        f.group_number,
        f.file_number,
        bytes,
        space,
        a.name
    FROM
        v$asm_file f
    JOIN
        v$asm_alias a
    ON
        f.group_number = a.group_number AND f.file_number = a.file_number
    ORDER BY
        f.group_number, f.file_number;


## Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
