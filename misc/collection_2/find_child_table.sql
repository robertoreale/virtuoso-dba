select owner,constraint_name,constraint_type,table_name,r_owner,r_constraint_name
from all_constraints 
where constraint_type='R'
and r_constraint_name in (select constraint_name from all_constraints 
where constraint_type in ('P','U') and table_name='TB001CFC_CUSTOMER');