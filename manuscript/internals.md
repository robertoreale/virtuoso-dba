# Internals

## Count the number of trace files generated each day

*Keywords*: x$ interface

    SELECT
        TRUNC(creation_time, 'DAY') day,
        COUNT(*) count
    FROM x$dbgdirext
        WHERE
            type = 2 AND logical_file LIKE '%.trc'
        GROUP BY TRUNC(creation_time, 'DAY')
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


--  Purpose:   shows file utilization
--  Reference: MOS Doc ID 351117.1
--  Tested:    10g, 11g


CLEAR COLUMN
SET LINE 132

COL name FORMAT a60


SELECT
    f.group_number     AS group#,
    f.file_number      AS file#,
    bytes              AS bytes,
    space              AS space,
    space / 1048576    AS space_mib,
    a.name             AS name
FROM
    v$asm_file f JOIN v$asm_alias a
ON
    f.group_number = a.group_number AND f.file_number = a.file_number
WHERE
    system_created = 'Y'
ORDER BY
    f.group_number, f.file_number;


--  Purpose:   shows file utilization
--  Reference: MOS Doc ID 351117.1


CLEAR COLUMN
SET LINE 132

COL name FORMAT a60


SELECT
    f.group_number     AS group#,
    f.file_number      AS file#,
    bytes              AS bytes,
    space              AS space,
    space / 1048576    AS space_mib,
    a.name             AS name
FROM
    v$asm_file f JOIN v$asm_alias a
ON
    f.group_number = a.group_number AND f.file_number = a.file_number
WHERE
    system_created = 'N'
ORDER BY
    f.group_number, f.file_number;


--  Purpose:   shows the ASM parameters and underscore (i.e. hidden) parameters
--  Reference: https://sites.google.com/site/oracledbnote/automaticstoragemanagement/asm-metadata-and-internals

COL parameter FORMAT a50 HEADING "Parameter"
COL value     FORMAT a45 HEADING "Instance Value"


SELECT
    a.ksppinm     AS parameter,
    c.ksppstvl    AS value
FROM
    x$ksppi a
JOIN
    x$ksppcv b USING (indx)
JOIN
    x$ksppsv c USING (indx)
WHERE
    ksppinm LIKE '%asm%'
ORDER BY
    a.ksppinm;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
