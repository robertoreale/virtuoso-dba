select * from v$session where sid = '2182'

select * from v$system_event order by average_wait desc

select * from v$session_wait;

select a.sid, a.machine, a.schemaname, sum(b.conta), b.state, b.sw_event, b.wait_class from
(select schemaname, sid, machine from v$session) a,
(select sid,
   count(*) conta,
   CASE WHEN state != 'WAITING' THEN 'WORKING'
        ELSE 'WAITING'
   END AS state,
   CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
        ELSE event
   END AS sw_event,
   wait_class
FROM
   v$session_wait
GROUP BY sid,
   CASE WHEN state != 'WAITING' THEN 'WORKING'
        ELSE 'WAITING'
   END,
   CASE WHEN state != 'WAITING' THEN 'On CPU / runqueue'
        ELSE event
   END, wait_class
ORDER BY
   4 DESC, 2 DESC) b
where a.sid = b.sid
group by a.sid, a.machine, a.schemaname, b.state, b.sw_event, b.wait_class
order by 7;
   


