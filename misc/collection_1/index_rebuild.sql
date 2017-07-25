prompt
ACCEPT spoolfile CHAR prompt 'Output-file : ';
ACCEPT schema CHAR prompt 'Schema name (% allowed) : '; 
prompt
prompt
prompt Rebuild the index when :
prompt   - deleted entries represent 20% or more of the current entries
prompt   - the index depth is more then 4 levels.
prompt Possible candidate for bitmap index :
prompt   - when distinctiveness is more than 99%
prompt
spool &spoolfile

set serveroutput on
set verify off
declare
 c_name        INTEGER;
 ignore        INTEGER;
 height        index_stats.height%TYPE := 0;
 lf_rows       index_stats.lf_rows%TYPE := 0;
 del_lf_rows   index_stats.del_lf_rows%TYPE := 0;
 distinct_keys index_stats.distinct_keys%TYPE := 0;
 cursor c_indx is
  select owner, table_name, index_name
  from dba_indexes
  where owner not in ('SYS','SYSTEM')
    and table_name = 'TEMP_VIEW_5_PEG';
begin
 dbms_output.enable (1000000);
 dbms_output.put_line ('Owner           Index Name                              % Deleted Entries Blevel Distinctiveness');
 dbms_output.put_line ('--------------- --------------------------------------- ----------------- ------ ---------------');

 c_name := DBMS_SQL.OPEN_CURSOR;
 for r_indx in c_indx loop
  DBMS_SQL.PARSE(c_name,'analyze index ' || r_indx.owner || '.' || 
                 r_indx.index_name || ' validate structure',DBMS_SQL.NATIVE);
  ignore := DBMS_SQL.EXECUTE(c_name);

  select HEIGHT, decode (LF_ROWS,0,1,LF_ROWS), DEL_LF_ROWS, 
         decode (DISTINCT_KEYS,0,1,DISTINCT_KEYS) 
         into height, lf_rows, del_lf_rows, distinct_keys
  from index_stats;

--  insert into index_appo values (r_indx.index_name);
--
-- Index is considered as candidate for rebuild when :
--   - when deleted entries represent 20% or more of the current entries
--   - when the index depth is more then 4 levels.(height starts counting from 1 so > 5)
-- Index is (possible) candidate for a bitmap index when :
--   - distinctiveness is more than 99%
--
  if ( height > 5 ) OR ( (del_lf_rows/lf_rows) > 0.2 ) then
    dbms_output.put_line (rpad(r_indx.owner,16,' ') || rpad(r_indx.index_name,40,' ') || 
                          lpad(round((del_lf_rows/lf_rows)*100,3),17,' ') || 
                          lpad(height-1,7,' ') || lpad(round((lf_rows-distinct_keys)*100/lf_rows,3),16,' '));
  end if;
  commit;
 end loop;
 DBMS_SQL.CLOSE_CURSOR(c_name);
end;
/

spool off
set verify on

