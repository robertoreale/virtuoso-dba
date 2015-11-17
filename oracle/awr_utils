-
- View taken snapshot (useful when you want to delete a range)
-
SELECT snap_id, begin_interval_time, end_interval_time 
FROM SYS.WRM$_SNAPSHOT WHERE snap_id = ( SELECT MIN (snap_id)
FROM SYS.WRM$_SNAPSHOT) UNION SELECT snap_id, begin_interval_time, end_interval_time
FROM SYS.WRM$_SNAPSHOT WHERE snap_id = ( SELECT MAX (snap_id) FROM SYS.WRM$_SNAPSHOT)
/

