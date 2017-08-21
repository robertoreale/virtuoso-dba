----------------------------------------------------------
-- VERIFICA sessioni attive (guarda paralleli e non)
---------------------------------------------------------- 
select * from (
select ses.OSUSER,ses.machine, count(ses.osuser) parallelo,0 altre
from v$session ses
where ses.TYPE='USER'
and ses.PROGRAM like '%(P%'
group by ses.osuser,ses.machine
union
select ses.OSUSER,ses.machine, 0 parallelo, count(ses.osuser) altre
from v$session ses
where ses.TYPE='USER'
and ses.PROGRAM not like '%(P%'
group by ses.osuser, ses.machine)
order by parallelo desc,altre desc;



----------------------------------------------------------
-- VERIFICA sessioni padre per richiesta kill (parallele)
---------------------------------------------------------- 
select 
    to_char(s.SID) sid,
    to_char(p.spid) spid,
    s.osuser,
    s.terminal,
    s.machine,
    s.program,
    s.status,
    s.module,
    s.logon_time,
    s.last_call_et,
    count(*)
    FROM v$session s, v$sess_io si, v$process p, v$session s2
   WHERE (    (s.username IS NOT NULL)
        --AND (NVL (s.osuser, :"SYS_B_3") <> :"SYS_B_4")
        --AND (s.TYPE <> :"SYS_B_5")
         )
     AND (si.SID(+) = s.SID)
     AND (p.addr(+) = s.paddr)
     AND s.audsid=s2.audsid
     and not s.program like '%(P%'
     and s2.program like '%(P%'
group by 
    s.SID,
    p.spid,
    s.osuser,
    s.terminal,
    s.machine,
    s.program,
    s.status,
    s.module,
    s.logon_time,
    s.last_call_et
having count(*)>1;



---------------------------------------------------------- 
-- Verifica accoppiata per kill
---------------------------------------------------------- 
SELECT se.SID, spid, se.program, se.terminal,se.osuser,se.status,se.command, se.LOGON_TIME,
        io.PHYSICAL_READS, io.CONSISTENT_GETS, io.BLOCK_GETS, io.BLOCK_CHANGES
  FROM v$session se,
       v$process pro,
       v$sess_io io
 WHERE se.paddr = pro.addr
 order by se.program;

SELECT se.osuser,count(*) conteggio
  FROM v$session se,
       v$process pro
 WHERE se.paddr = pro.addr
 and se.program like 'oracle@dwhese01 (P0%'
 group by se.osuser;