## The MODEL Clause

### Generate the even integers between -100 and 100, inclusive

*Keywords*: MODEL

*Reference*: http://www.orafaq.com/wiki/Oracle_Row_Generator_Techniques

    SELECT
        n
    FROM
        dual
    WHERE
        1 = 2
    MODEL
        DIMENSION BY (0 AS key)
        MEASURES     (0 AS n)
        RULES UPSERT 
        (
            n [FOR key FROM -100 TO 100 INCREMENT 2] = CV(key)
        );


### Exercises

<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
