## A Stochastic World

### For each tablespace T, find the probability of segments in T to be smaller than or equal to a given size

*Keywords*: probability distributions, logical storage

    SELECT
        tablespace_name, 
        CUME_DIST(&size) WITHIN GROUP (ORDER BY bytes) probability
    FROM
        dba_segments
    GROUP BY
        tablespace_name;


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
