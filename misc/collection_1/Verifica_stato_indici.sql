---------------------------
-- Verifica stato indici --
---------------------------

SELECT 'conteggio indici' Descrizione,
       TO_CHAR (COUNT (DISTINCT index_name)) nome_indice,
       ' ' as "Indici o partiz UNUSABLE" 
  FROM dba_indexes
 WHERE status = 'UNUSABLE'
UNION ALL
SELECT 'conteggio indici partizionati',
       TO_CHAR (COUNT (DISTINCT index_name)),
       ' '  as "Indici o partiz UNUSABLE"
  FROM dba_ind_partitions
 WHERE status = 'UNUSABLE'
UNION ALL
SELECT 'conteggio indici subpartizionati',
       TO_CHAR (COUNT (DISTINCT index_name)),
       ' '  as "Indici o partiz UNUSABLE"
  FROM dba_ind_subpartitions
 WHERE status = 'UNUSABLE'
UNION ALL
SELECT DISTINCT index_owner,
                index_name,
                TO_CHAR (COUNT (index_name))
           FROM dba_ind_partitions
          WHERE status = 'UNUSABLE'
          group by index_owner,index_name
UNION ALL
SELECT DISTINCT index_owner,
                index_name,
                TO_CHAR (COUNT (index_name))
           FROM dba_ind_subpartitions
          WHERE status = 'UNUSABLE'
          group by index_owner,index_name
UNION ALL
SELECT DISTINCT owner,
                index_name,
                TO_CHAR (COUNT (index_name))
           FROM dba_indexes
          WHERE status = 'UNUSABLE'
          group by owner,index_name;