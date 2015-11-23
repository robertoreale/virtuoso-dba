-- first query

SELECT nvl(ses.username,'ORACLE PROC')||' ('||ses.sid||')' USERNAME,
       SID,   
       MACHINE, 
       REPLACE(SQL.SQL_TEXT,CHR(10),'') STMT, 
      ltrim(to_char(floor(SES.LAST_CALL_ET/3600), '09')) || ':'
       || ltrim(to_char(floor(mod(SES.LAST_CALL_ET, 3600)/60), '09')) || ':'
       || ltrim(to_char(mod(SES.LAST_CALL_ET, 60), '09'))    RUNT 
  FROM V$SESSION SES,   
       V$SQLtext_with_newlines SQL 
 where SES.STATUS = 'ACTIVE'
   and SES.USERNAME is not null
   and SES.SQL_ADDRESS    = SQL.ADDRESS 
   and SES.SQL_HASH_VALUE = SQL.HASH_VALUE 
   and Ses.AUDSID <> userenv('SESSIONID') 


-- second query
SET LINESIZE 20000

select s.sid
      ,s.serial#
      ,s.username
      ,s.sql_id
      ,s.sql_child_number
      ,optimizer_mode
      ,hash_value
      ,address
      ,sql_text
from   v$sqlarea sqlarea
      ,v$session s
where  s.sql_hash_value = sqlarea.hash_value
and    s.sql_address    = sqlarea.address
and    s.username       is not null;



