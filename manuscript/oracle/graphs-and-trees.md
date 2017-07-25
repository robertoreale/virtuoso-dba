## Graphs and Trees

### List all users to which a given role is granted, even indirectly

*Keywords*: hierarchical queries, security

    SELECT 
        grantee
    FROM
        dba_role_privs
    CONNECT BY prior grantee = granted_role
    START WITH granted_role = '&role'
    INTERSECT
    SELECT
        username
    FROM
        dba_users;


### List privileges granted to each user, even indirectly

*Keywords*: hierarchical queries, security

    SELECT
        level,
        u1.name grantee,
        u2.name privilege,
        SYS_CONNECT_BY_PATH(u1.name, '/') path
    FROM
        sysauth$ sa
    JOIN
        user$ u1 ON (u1.user## = grantee#)
    JOIN
        user$ u2 ON (u2.user## = sa.privilege#)
    CONNECT BY PRIOR privilege## = grantee#
    ORDER BY level, grantee, privilege;


### Display reference graph between tables

*Keywords*: hierarchical queries, constraints

    WITH
        constraints AS 
            (
                SELECT
                    *
                FROM
                    dba_constraints
                WHERE
                    status = 'ENABLED' AND constraint_type IN ('P','R')
            ),
        constraint_tree AS
            (
                SELECT DISTINCT
                    c1.owner || '.' || c1.table_name 
                        AS table_name,
                    NVL2(c2.table_name, c2.owner || '.' || c2.table_name, NULL)
                        AS parent_table_name
                FROM
                    constraints c1
                LEFT OUTER JOIN
                    constraints c2
                ON c1.r_constraint_name = c2.constraint_name
            )
    SELECT
        level AS depth,
        SYS_CONNECT_BY_PATH(table_name, '->') AS path
    FROM
        constraint_tree
    WHERE
        LEVEL > 1 AND CONNECT_BY_ISLEAF = 1
    START WITH
        parent_table_name IS NULL
    CONNECT BY
        NOCYCLE parent_table_name = PRIOR table_name
    ORDER BY
        depth, path;


### Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
