with potential_duplicates as(
                  select
                          SUM(executions)                                 as "Executions",
                          SUM(elapsed_time/1000000)                       as "Elapsed Time",
                          SUM(cpu_time/1000000)                           as "CPU Time",
                          COUNT(*)                                        as "Statements",
                          SUBSTR(sql_text,1,60)                           as "SQL"
                  from    v$sqlarea
                  group by
                          SUBSTR(sql_text,1,60)
                  having  COUNT(*) > 5
                  order by count(*) DESC
  )
  select
          *
  from       potential_duplicates
  where      rownum < 11;



select
          sharable_mem,
          sql_text
  from       v$sqlarea
 where      sql_text like 'insert into tffusr.fix_mess_received ( connection_code, seqn%'