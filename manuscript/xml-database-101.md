# XML Database 101

## Return the total number of installed patches

*Keywords*: XML database, patches

    SELECT
        EXTRACTVALUE(DBMS_QOPATCH.GET_OPATCH_COUNT, '/patchCountInfo')
    FROM
        dual;


## List user passwords (hashed, of course...)

*Keywords*: XML database, security

From 11g onwards, password hashes do not appear in dba_users anymore.  Of course they are still visible in sys.user$, but we can do better...

    SELECT
        username,
        EXTRACT(
            XMLTYPE(
                DBMS_METADATA.GET_XML('USER', username)),
                '//USER_T/PASSWORD/text()'
            ).getStringVal()  AS  password_hash
    FROM
        dba_users;


## Return patch details such as patch and inventory location

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/info.sql

    SELECT 
        XMLSERIALIZE(
            DOCUMENT DBMS_QOPATCH.GET_OPATCH_INSTALL_INFO AS CLOB INDENT SIZE = 2
        ) AS info 
    FROM
        dual;


## XXX

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/lsinventory.sql

    SELECT
        XMLTRANSFORM(
            DBMS_QOPATCH.GET_OPATCH_LSINVENTORY, DBMS_QOPATCH.GET_OPATCH_XSLT
        ).GetClobVal() AS lsinventory
    FROM
        dual;


## XXX

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/patches.sql

    WITH opatch AS (
        SELECT DBMS_QOPATCH.GET_OPATCH_LSINVENTORY patch_output FROM dual
    )
    SELECT
        patches.*
    FROM
        opatch,
        XMLTABLE(
            'InventoryInstance/patches/*'
            PASSING opatch.patch_output
            COLUMNS
                patch_id     NUMBER       PATH 'patchID',
                patch_uid    NUMBER       PATH 'uniquePatchID',
                description  VARCHAR2(80) PATH 'patchDescription',
                applied_date VARCHAR2(30) PATH 'appliedDate',
                sql_patch    VARCHAR2(8)  PATH 'sqlPatch',
                rollbackable VARCHAR2(8)  PATH 'rollbackable'
        ) patches;


## Show bugs fixed by each installed patch

*Keywords*: XML database, patches

*Reference*: xt_scripts/opatch/bugs_fixed.sql

    WITH bugs AS (
        SELECT
            id,
            description
        FROM XMLTABLE(
            '/bugInfo/bugs/bug'
            PASSING DBMS_QOPATCH.GET_OPATCH_BUGS
            COLUMNS
                id          NUMBER PATH '@id',
                description VARCHAR2(100) PATH 'description'
        )
    )
    SELECT * FROM bugs;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
