TODO
===

* Continuous Integration

* Cosa sono e a cosa servono gli undo segments. In un RAC sono condivisi o privati? Quali blocchi contengono? (Committed, Uncommitted, Expired, Unexpired, …) come funziona la retention?
* RAC: dove stanno e a cosa servono i voting disk (membership), OCR, CRS?
* AWR: che cos’è, a cosa serve e come funziona. Cosa sono gli Wait Events e quali sono i più importanti? Per esempio Scattered read, db file sequential real, log file sync, latch free, …
* Metodi per ricoverare una tabella a fronte di un errore applicativo che ha alterato scorrettamente alcune righe: Flashback, BCV+export, Logminer, Undo+scn
* Errori ricorrent: 1555, 4030 e 4031, 600, 7445 Cosa significano e come si agice.
* Quali metodi si usano per forzare un piano di esecuzione? Hint, manipolazione delle statistiche, stored outlines (cosa sono?), profili
* Che cos’è il clustering factor di un indice?
* Il listener ascolta solo sulla porta 1521? Come si può cambiare?
* Differenza tra backup a caldo e a freddo, prerequisito per poter fare un bck a caldo (archivelog mode).
* Cosa fare quando si riempie la directory degli archive: spostarli e/o cambiare destinazione degli archive, fare il backup archive può richiedere troppo tempo…
* Come approcciare quando gli utenti dicono che “il db è lento”: prima si guardano i dati del server (OS) processi, memoria, dischi, cpu, poi si entra nel db, si guarda alert, poi si guarda il carico del db: cosa sta girando, poi si confronta con i dati storici AWR e si esaminano gli eventi d'attesa.
* Le strutture principali di Oracle: sga, buffer cache, library cache, shared pool, undo, redolog, …
* Relazione tra “snapshot too old”, undo, lettura consistente: come funziona tutto il meccanismo.
* Principali V$ e GV$, per esempio v$session, v$process, per esempio per associare sessione oracle a processo unix.
* Unix-Linux shell scripting e comandi per le performance e per gli spazi es: top, DF –k, grep, awk, …
* OEM utilizzo basilare.
* RMAN utilizzo basilare e concetti base di backup.
