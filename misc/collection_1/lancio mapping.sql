-- ATTENZIONE!!! La connessione è: sqlplus owbrtrepo@dwhep/gr05owbrtrepo

- SE il mapp e' di STAGING ===>>> 

EXEC OWBRTREPO.PR_MAIN_CALL_MAP('OWBRTREPO','CDW_SKY_ST','PLSQL','MP_.........');

- SE il mapp e' di ODS     ===>>> 

EXEC OWBRTREPO.PR_MAIN_CALL_MAP('OWBRTREPO','CDW_SKY_ODS','PLSQL','MP_.........');

- SE il mapp e' di DDS     ===>>> 

EXEC OWBRTREPO.PR_MAIN_CALL_MAP('OWBRTREPO','CDW_SKY_DDS','PLSQL','MP_.........');

- SE il mapp e' di DM      ===>>> 

-- ATTENZIONE!!! La connessione è: sqlplus dwhrtrepo@dwhes/gr05dwhrtrepo

EXEC DWHRTREPO.PR_MAIN_CALL_MAP('DWHRTREPO','CDW_SKY_DM','PLSQL','MP_.........');






EXEC DWHRTREPO.PR_MAIN_CALL_MAP('DWHRTREPO','CDW_SKY_DM','PLSQL','MP_PRC_BUILD_TATTICA');