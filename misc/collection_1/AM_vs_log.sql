-----------------------------------------
----    VS_LOG                        ---
-----------------------------------------
--da usere con dhw_st in dwhep

SELECT   job_name, REPLACE (target_table, '"', '') ttable, record_selected sel, record_inserted ins, record_updated upd, record_merged mrg,
         record_errors err, RPAD (oracle_error, 10) oracle_error, data_run, elapsed_time secondi,
         CASE
            WHEN elapsed_time = 0 AND oracle_check = 'WARNINGS' THEN fnc_difdt (data_run)
            ELSE fnc_difdt (NULL, elapsed_time)
         END tempo, oracle_check, oracle_error oracle_error_esteso
    FROM vs_log
   WHERE 1 = 1
   AND TRUNC(data_run) = TRUNC(SYSDATE) 
ORDER BY data_run DESC;

SELECT   job_name, REPLACE (target_table, '"', '') ttable, record_selected sel, record_inserted ins, record_updated upd, record_merged mrg,
         record_errors err, RPAD (oracle_error, 10) oracle_error, data_run, elapsed_time secondi,
         CASE
            WHEN elapsed_time = 0 AND oracle_check = 'WARNINGS' THEN fnc_difdt (data_run)
            ELSE fnc_difdt (NULL, elapsed_time)
         END tempo, oracle_check, oracle_error oracle_error_esteso
    FROM vs_log
   WHERE 1 = 1 AND TRUNC (data_run) = TRUNC (SYSDATE) AND oracle_check <> 'OK'
ORDER BY data_run DESC;


SELECT   job_name, REPLACE (target_table, '"', '') ttable, record_selected sel, record_inserted ins, record_updated upd, record_merged mrg,
         record_errors err, RPAD (oracle_error, 10) oracle_error, data_run, elapsed_time secondi,
         CASE
            WHEN elapsed_time = 0 AND oracle_check = 'WARNINGS' THEN fnc_difdt (data_run)
            ELSE fnc_difdt (NULL, elapsed_time)
         END tempo, oracle_check, oracle_error oracle_error_esteso
    FROM vs_log
   WHERE 1 = 1
  and job_name = 'MP_ST_MRM_VOUCHER'
ORDER BY data_run DESC;



-----------------------------------------
----    VS_LOG_2                      ---
-----------------------------------------
SELECT   creation_date, task_object_name, execution_object_name, MESSAGE_TEXT, return_result
    FROM vs_log_2
WHERE trunc(creation_date) = trunc(sysdate)
ORDER BY creation_date DESC;

-- **************************************************************** --
-- IMPORTANTE PER RISALIRE AL TASK OWF DAL MAPPING ANDATO IN ERRORE --
-- **************************************************************** --
SELECT   creation_date, task_object_name, execution_object_name, MESSAGE_TEXT, return_result
    FROM vs_log_2
ORDER BY creation_date DESC;

select * from vs_owb_flows_objects;

-----------------------------------------
----    WT_LOG_FUNCTION_OWF           ---
-----------------------------------------

SELECT   *
    FROM wt_log_function_owf
   WHERE 1 = 1 AND TRUNC (date_proc) = TRUNC (SYSDATE)
ORDER BY date_proc DESC;

SELECT   *
    FROM wt_log_function_owf
   WHERE 1 = 1 AND TRUNC (date_proc) = TRUNC (SYSDATE) AND msg_proc <> 'OK'
ORDER BY date_proc DESC;

-----------------------------------------
----    WT_ERROR_MSG                  ---
-----------------------------------------
SELECT   date_err, code_err, MESSAGE, process_name
    FROM wt_error_msg
   WHERE 1 = 1 AND TRUNC (date_err) = TRUNC (SYSDATE)
ORDER BY date_err DESC;


-----------------------------------------
----    WT_LOG_PREPOST_MAPS           ---
-----------------------------------------
SELECT   act_name,object_name,step_act,data_run,row_inserted,elapsed_time,exit_msg
    FROM wt_log_prepost_maps
   WHERE 1 = 1 AND TRUNC (data_run) = TRUNC (SYSDATE) AND exit_msg <> 'OK'
ORDER BY data_run DESC, step_act DESC;


-----------------------------------------
----    USER ACTION's                 ---
-----------------------------------------
select 'KENAN' as area,ERROR, CODE_EXIT, MAP_NAME from WT_KEN_USER_ACTION union all
select 'CDW' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION union all
select 'ANOVO' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_ANOVO union all
select 'BBH' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_BBH union all
select 'CALL' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_CALLTRACK union all
select 'CHURN' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_CHURN union all
select 'CLBK' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_CLBK union all
select 'CMDM' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_CMDM union all
select 'CP' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_CP union all
select 'GEO' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_GEO union all
select 'INTRA' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_INTRADAY union all
select 'IPTV' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_IPTV union all
select 'IVR' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_IVR union all
select 'LAPS' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_LAPSED union all
select 'LGS' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_LGS union all
select 'LOY' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_LOYALTY union all
select 'MRKT' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_MRKT union all
select 'NBA' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_NBA union all
select 'PCAMP' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_PCAMP union all
select 'PPV' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_PPV union all
select 'HTL' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_PPV_HTL union all
select 'PASS' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_PPV_PASS union all
select 'PREM' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_PREMIUM union all
select 'PRSP' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_PRSP union all
select 'SALES' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_S union all
select 'SAP' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_SAP union all
select 'SMS' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_SMS union all
select 'WO' as area,ERROR, CODE_EXIT, MAP_NAME from WT_USER_ACTION_WO;
