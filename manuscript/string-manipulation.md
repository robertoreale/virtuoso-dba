## String Manipulation

### Count the client sessions with a FQDN

*Keywords*: regular expressions, dynamic views

Assume a FQDN has the form N_1.N_2.....N_t, where t > 1 and each N_i can contain lowercase letters, numbers and the dash.
 
    SELECT
        machine
    FROM
        gv$session
    WHERE
        REGEXP_LIKE(machine, '^([[:alnum:]]+\.)+[[:alnum:]-]+$');


<!-- vim: set fenc=utf-8 spell spl=en ts=4 sw=4 et filetype=markdown : -->
