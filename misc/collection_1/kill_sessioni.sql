Le istanze da controllare sono 3:

DWH_ST su DWHEP
DWH_DM su DWHES
SIEBEL su SBE80_15K

Ciao,
Giacomo

select                          
    to_char(s.SID),
    to_char(p.spid),
    s.osuser,
    s.terminal,
    s.program,
    s.status,
    s.logon_time,
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
    s.program,
    s.status,
    s.logon_time
having count(*)>1    
