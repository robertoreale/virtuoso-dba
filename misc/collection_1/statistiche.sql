exec dbms_stats.gather_index_stats(ownname=>'dwh_dm',indname=>'PK_FT_ESIGENZE_DETT',degree=>16);

exec dbms_stats.gather_table_stats(ownname=>'DWH_DM',tabname=>'WT_FT_CONSUMI_PPV_AGG',degree=>16,estimate_percent=>5);


exec dbms_stats.gather_table_stats(ownname=>'RUUSR',tabname=>'RU_ESITI_ERRORI',cascade => TRUE);

