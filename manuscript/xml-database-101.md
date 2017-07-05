## XML Database 101

### Return the total number of installed patches

*Keywords*: XML database, patches

    SELECT
        EXTRACTVALUE(DBMS_QOPATCH.GET_OPATCH_COUNT, '/patchCountInfo')
    FROM
        dual;


### List user passwords (hashed, of course...)

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


### Show bugs fixed by each installed patch

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
