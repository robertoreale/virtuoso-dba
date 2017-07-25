CREATE OR REPLACE FUNCTION DWH_ST.fn_main_usr_action_intraday (
   "LEVEL_MP"   IN   NUMBER,
   "AREA"       IN   VARCHAR2
)
   RETURN NUMBER IS
   check_map        NUMBER;
   flg_exit         NUMBER          DEFAULT 0;
   check_esito      NUMBER          DEFAULT 0;
   uscita_forzata   EXCEPTION;
   code_err         VARCHAR2 (20);
   msg_err          VARCHAR2 (500);
   exec_fn          VARCHAR2 (1000);
-- variabili gestione concorrenza
   check_lock       NUMBER;
BEGIN
   -- verifico che non ci siano altre esecuzione della funzione in corso
   SELECT w.flg_lock
     INTO check_lock
     FROM wt_cunc_manage_intraday w;

   -- mi metto in attesa fino a che la wt_cunc_manage_bbh non viene sbloccata
   WHILE check_lock = 1 LOOP
      SELECT w.flg_lock
        INTO check_lock
        FROM wt_cunc_manage_intraday w;
   END LOOP;

   -- metto in stato di lock la wt_cunc_manage_bbh
   UPDATE wt_cunc_manage_intraday w
      SET w.flg_lock = 1;

   COMMIT;
   flg_exit := 0;

   IF (SUBSTR (area, 0, 3) != 'FN_') THEN
      WHILE flg_exit = 0 LOOP
         DELETE FROM wt_user_action_intraday;

         COMMIT;

         -- controllo se ci sono mapping andati in errore
         SELECT COUNT (*)
           INTO check_map
           FROM (SELECT job_name,
                        oracle_check,
                        SUBSTR (oracle_error, 5, 5) AS errorcode,
                        oracle_error
                   FROM (SELECT a.*,
                                ROW_NUMBER () OVER (PARTITION BY job_name ORDER BY data_run DESC)
                                                                                     AS contatore
                           FROM (SELECT l.job_name,
                                        l.oracle_check,
                                        l.oracle_error,
                                        l.data_run
                                   FROM vs_log l, wt_map_schedule w
                                  WHERE TRUNC (l.data_run) = TRUNC (SYSDATE)
                                    --riga da modificare
                                    AND w.des_map = l.job_name
                                    AND w.des_area = area
                                    AND (w.num_level = level_mp OR level_mp IS NULL)
                                 UNION ALL
                                 SELECT l2.execution_object_name,
                                        l2.return_result,
                                        l2.MESSAGE_TEXT,
                                        l2.creation_date
                                   FROM vs_log_2 l2, wt_map_schedule w
                                  WHERE TRUNC (l2.creation_date) = TRUNC (SYSDATE)
                                    --riga da modificare
                                    AND w.des_map = l2.execution_object_name
                                    AND w.des_area = area
                                    AND (w.num_level = level_mp OR level_mp IS NULL)) a) b
                  WHERE contatore = 1 AND oracle_check = 'RECORD_DISCARDED');

         IF check_map != 0 THEN
            check_esito := fn_wait_usr_action_intraday (level_mp, area);

            IF check_esito = 4 THEN
               DELETE FROM wt_user_action_intraday;

               COMMIT;

               -- sblocco la wt_cunc_manage_bbh
               UPDATE wt_cunc_manage_intraday w
                  SET w.flg_lock = 0;

               COMMIT;
               RETURN 1;
            END IF;
         ELSE
            flg_exit := 1;
         END IF;

         IF check_esito = 3 THEN
            RAISE uscita_forzata;
         END IF;
      END LOOP;
   -- verifico se una funzione è andata in errore
   ELSE
      WHILE flg_exit = 0 LOOP
         SELECT DISTINCT FIRST_VALUE (owf.msg_proc) OVER (PARTITION BY owf.proc_name, owf.lev_proc ORDER BY owf.date_proc DESC)
                    INTO exec_fn
                    FROM wt_log_function_owf owf
                   WHERE owf.proc_name = area AND owf.lev_proc = level_mp;

         IF exec_fn = 'OK' THEN
            flg_exit := 1;
         ELSE
            check_esito := fn_wait_usr_action_intraday (level_mp, area);

            IF check_esito = 4 THEN
               DELETE FROM wt_user_action_intraday;

               COMMIT;

               -- sblocco la wt_cunc_manage_bbh
               UPDATE wt_cunc_manage_intraday w
                  SET w.flg_lock = 0;

               COMMIT;
               RETURN 1;
            END IF;
         END IF;
      END LOOP;
   -- fine
   END IF;

   DELETE FROM wt_user_action_intraday;

   COMMIT;

   -- sblocco la wt_cunc_manage_bbh
   UPDATE wt_cunc_manage_intraday w
      SET w.flg_lock = 0;

   COMMIT;
   RETURN 1;
EXCEPTION
   WHEN uscita_forzata THEN
      code_err := SQLCODE;
      msg_err := SQLERRM;

      DELETE FROM wt_user_action_intraday;

      INSERT INTO wt_error_msg
                  (code_err, MESSAGE, date_err, process_name
                  )
           VALUES (code_err, msg_err, SYSDATE, 'FN_MAIN_USR_ACTION_INTRADAY'
                  );

      COMMIT;

      -- sblocco la wt_cunc_manage_bbh
      UPDATE wt_cunc_manage_intraday w
         SET w.flg_lock = 0;

      COMMIT;
      RETURN 3;
   WHEN OTHERS THEN
      code_err := SQLCODE;
      msg_err := SQLERRM;

      DELETE FROM wt_user_action_intraday;

      INSERT INTO wt_error_msg
                  (code_err, MESSAGE, date_err, process_name
                  )
           VALUES (code_err, msg_err, SYSDATE, 'FN_MAIN_USR_ACTION_INTRADAY'
                  );

      COMMIT;

      -- sblocco la wt_cunc_manage_bbh
      UPDATE wt_cunc_manage_intraday w
         SET w.flg_lock = 0;

      COMMIT;
      RETURN 3;
END fn_main_usr_action_intraday;
/
