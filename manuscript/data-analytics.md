## Data Analytics

### List the objects in the recycle bin, sorting by the version

*Keywords*: analytical functions

    SELECT
        original_name,
        type,
        object_name,
        droptime,
        RANK() OVER (
            PARTITION BY original_name, type ORDER BY droptime DESC
        ) obj_version,
        can_purge
    FROM
        dba_recyclebin;


### Show how much is tablespace usage growing

*Keywords*: regression models, dynamic views, logical storage

    SELECT
        d.name db,
        t.name tablespace_name,
        REGR_SLOPE(tablespace_usedsize, snap_id) usage_growth
    FROM
        dba_hist_tbspc_space_usage h=
        JOIN gv$database d USING(dbid)
        JOIN gv$tablespace t ON (h.tablespace_id = t.ts##)
    GROUP BY
        d.name, t.name
    ORDER BY
        db, tablespace_name;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
