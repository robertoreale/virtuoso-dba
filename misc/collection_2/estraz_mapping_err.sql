create table appo_estr_temp as
select distinct job_name, target_table from vs_log
where oracle_error like '%tablespace TEMP%'
and data_run > sysdate - 550
union
select distinct job_name, target_table from wt_vs_log_hist
where oracle_error like '%tablespace TEMP%'
and data_run > sysdate - 550
--order by data_run desc


select job_name, max(last_run) last_run from (
select a.job_name, max(data_run) last_run from appo_estr_temp a, wt_vs_log_hist b
where a.job_name = b.job_name
group by a.job_name
union
select a.job_name, max(data_run) last_run from appo_estr_temp a, vs_log b
where a.job_name = b.job_name
group by a.job_name)
group by job_name;


select a.job_name, a.target_table, a.record_inserted, a.data_run last_run from vs_log a, 
(select job_name, max(last_run) last_run from (
select a.job_name, max(data_run) last_run from appo_estr_temp a, wt_vs_log_hist b
where a.job_name = b.job_name
group by a.job_name
union
select a.job_name, max(data_run) last_run from appo_estr_temp a, vs_log b
where a.job_name = b.job_name
group by a.job_name)
group by job_name) b
where a.job_name = b.job_name
and a.data_run = b.last_run
union
select a.job_name, a.target_table, a.record_inserted, a.data_run last_run from wt_vs_log_hist a, 
(select job_name, max(last_run) last_run from (
select a.job_name, max(data_run) last_run from appo_estr_temp a, wt_vs_log_hist b
where a.job_name = b.job_name
group by a.job_name
union
select a.job_name, max(data_run) last_run from appo_estr_temp a, vs_log b
where a.job_name = b.job_name
group by a.job_name)
group by job_name) b
where a.job_name = b.job_name
and a.data_run = b.last_run



drop table appo_estr_temp purge