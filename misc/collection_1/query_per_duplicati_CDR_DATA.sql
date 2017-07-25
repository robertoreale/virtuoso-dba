SQL> select count(*), MSG_ID, MSG_ID2, MSG_ID_SERV, SPLIT_ROW_NUM
  2  from EIW_CREAM.CDR_DATA_LOAD7
  3  group by MSG_ID, MSG_ID2, MSG_ID_SERV, SPLIT_ROW_NUM
  4  HAVING COUNT(*)>1;

  COUNT(*)     MSG_ID    MSG_ID2 MSG_ID_SERV SPLIT_ROW_NUM
---------- ---------- ---------- ----------- -------------
        12   27888690          1          49             0

SQL> select BILL_REF_NO, MSG_ID, MSG_ID2, MSG_ID_SERV, SPLIT_ROW_NUM from EIW_CREAM.CDR_DATA_LOAD7
  2  where MSG_ID=27888690 and MSG_ID2=1 and MSG_ID_SERV=49 and SPLIT_ROW_NUM=0;

BILL_REF_NO     MSG_ID    MSG_ID2 MSG_ID_SERV SPLIT_ROW_NUM
----------- ---------- ---------- ----------- -------------
   33473957   27888690          1          49             0
   41230171   27888690          1          49             0
   61256319   27888690          1          49             0
   81102046   27888690          1          49             0
   92593771   27888690          1          49             0
  118711545   27888690          1          49             0
  156577043   27888690          1          49             0
  365381039   27888690          1          49             0
  532325046   27888690          1          49             0
  220650045   27888690          1          49             0
  451087135   27888690          1          49             0
  283686053   27888690          1          49             0

12 rows selected.