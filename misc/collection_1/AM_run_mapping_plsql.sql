-- Per il lancio da prompt SQL dei MAPPING OWB eseguire:

DECLARE
   retval   NUMBER;
   p_env    wb_rt_mapaudit.wb_rt_name_values;
BEGIN
   retval := MP_WT_DECODER_SKY_SERVICE.main (p_env);
   COMMIT;
END;
/

-------------------------------------------------------------------------

-- Per il lancio da prompt SQL delle procedure PL/SQL eseguire:

exec [nome_procedura]

-------------------------------------------------------------------------

-- Per il lancio da prompt SQL delle funzioni PL/SQL eseguire:

var func_name number;
exec :func_name := [nome_funzione]

-- Per la visualizzazione dell'esito eseguire: 
print func_name

-------------------------------------------------------------------------

-- Entrare nel codice della procedure/function per vedere quale tabella
-- di log utilizza, di solito è la DWH_DM@WT_LOG_COPY_TABLE_BOOK (tabella
-- di logging delle procedure e funzioni del book)
 
DECLARE
  NROWS NUMBER;
BEGIN

  LOAD_TEMP_VIEW_3(
    NROWS => NROWS
  );

DBMS_OUTPUT.PUT_LINE('NROWS = ' || NROWS);

END;
