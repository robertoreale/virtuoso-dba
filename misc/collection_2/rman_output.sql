/* Formatted on 2013/03/15 14:48 (Formatter Plus v4.8.8) */
SELECT file_type, space_used * percent_space_used / 100 / 1024 / 1024 used,
         space_reclaimable
       * percent_space_reclaimable
       / 100
       / 1024
       / 1024 reclaimable,
       frau.number_of_files
  FROM v$recovery_file_dest rfd, v$flash_recovery_area_usage frau;


SELECT   row_type, output_bytes, start_time, end_time, operation, object_type,
         output_device_type, status, mbytes_processed
    FROM v$rman_status
   WHERE start_time > SYSDATE - 7 AND operation IN ('BACKUP')
ORDER BY end_time;


select * from v$rman_output;




/* Formatted on 2013/03/15 14:38 (Formatter Plus v4.8.8) */
SELECT   j.session_recid, j.session_stamp,
         TO_CHAR (j.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
         TO_CHAR (j.end_time, 'yyyy-mm-dd hh24:mi:ss') end_time,
         (j.output_bytes / 1024 / 1024) output_mbytes, j.status, j.input_type,
         DECODE (TO_CHAR (TRUNC (j.start_time) + 1, 'd'),
                 1, 'Sunday',
                 2, 'Monday',
                 3, 'Tuesday',
                 4, 'Wednesday',
                 5, 'Thursday',
                 6, 'Friday',
                 7, 'Saturday'
                ) dow,
         j.elapsed_seconds, j.time_taken_display, x.cf, x.df, x.i0, x.i1, x.l,
         ro.inst_id output_instance
    FROM v$rman_backup_job_details j
         LEFT OUTER JOIN
         (SELECT   d.session_recid, d.session_stamp,
                   SUM (CASE
                           WHEN d.controlfile_included = 'YES'
                              THEN d.pieces
                           ELSE 0
                        END
                       ) cf,
                   SUM (CASE
                           WHEN d.controlfile_included = 'NO'
                           AND d.backup_type || d.incremental_level = 'D'
                              THEN d.pieces
                           ELSE 0
                        END
                       ) df,
                   SUM (CASE
                           WHEN d.backup_type || d.incremental_level = 'D0'
                              THEN d.pieces
                           ELSE 0
                        END
                       ) i0,
                   SUM (CASE
                           WHEN d.backup_type || d.incremental_level = 'I1'
                              THEN d.pieces
                           ELSE 0
                        END
                       ) i1,
                   SUM (CASE
                           WHEN d.backup_type = 'L'
                              THEN d.pieces
                           ELSE 0
                        END) l
              FROM v$backup_set_details d JOIN v$backup_set s
                   ON s.set_stamp = d.set_stamp AND s.set_count = d.set_count
             WHERE s.input_file_scan_only = 'NO'
          GROUP BY d.session_recid, d.session_stamp) x
         ON x.session_recid = j.session_recid
       AND x.session_stamp = j.session_stamp
         LEFT OUTER JOIN
         (SELECT   o.session_recid, o.session_stamp, MIN (inst_id) inst_id
              FROM gv$rman_output o
          GROUP BY o.session_recid, o.session_stamp) ro
         ON ro.session_recid = j.session_recid
       AND ro.session_stamp = j.session_stamp
   WHERE j.start_time > TRUNC (SYSDATE) - &number_of_days
ORDER BY j.start_time;


/* Formatted on 2013/03/15 14:38 (Formatter Plus v4.8.8) */
SELECT   d.bs_key, d.backup_type, d.controlfile_included, d.incremental_level,
         d.pieces, TO_CHAR (d.start_time, 'yyyy-mm-dd hh24:mi:ss') start_time,
         TO_CHAR (d.completion_time, 'yyyy-mm-dd hh24:mi:ss') completion_time,
         d.elapsed_seconds, d.device_type, d.compressed,
         (d.output_bytes / 1024 / 1024) output_mbytes, s.input_file_scan_only
    FROM v$backup_set_details d JOIN v$backup_set s
         ON s.set_stamp = d.set_stamp AND s.set_count = d.set_count
   WHERE session_recid = &session_recid AND session_stamp = &session_stamp
ORDER BY d.start_time;


--If the backup contains archived redo logs, the value is L. 
--If this is a datafile full backup, the value is D. 
--If this is an incremental backup, the value is I.
--BS_key Backup set identifier.

237  810129475


/* Formatted on 2013/03/15 14:50 (Formatter Plus v4.8.8) */
SELECT   output
    FROM gv$rman_output
   WHERE session_recid = &session_recid AND session_stamp = &session_stamp
ORDER BY recid;