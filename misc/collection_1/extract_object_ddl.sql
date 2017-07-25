DECLARE
ddl CLOB;
BEGIN
SELECT dbms_metadata.get_ddl('VIEW','BATCH_OU_RELATIONS_VIEW','TDLUSR113')
INTO ddl
FROM dual;
dbms_output.put_line(ddl);
END;
/