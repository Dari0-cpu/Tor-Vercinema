TOR VERCINEMA

💡 Idea del Progetto
L'obiettivo del progetto è la progettazione e l'implementazione di un database relazionale capace di gestire interamente l'ecosistema di un cinema multisala, dalla programmazione dei film alla vendita dei biglietti.

🚀 Perché un Database Relazionale?
L'uso di un DBMS relazionale è indispensabile per superare le inefficienze delle gestioni manuali o basate su fogli di calcolo (es. Excel). Un database strutturato garantisce:

Gestione della Concorrenza: Permette a centinaia di utenti di consultare il palinsesto e acquistare biglietti simultaneamente, garantendo meccanismi di lock che azzerano il rischio di overbooking (evitando la vendita dello stesso posto a più persone).

Integrità dei Dati: Tramite i vincoli di integrità, il sistema impedisce l'errore umano, come la sovrapposizione di due film nella stessa sala alla stessa ora o l'assegnazione di posti inesistenti.

Sicurezza e Astrazione: Centralizza i dati in un luogo sicuro, implementando il Role Based Access Control (RBAC) per mostrare solo le informazioni pertinenti all'utente, proteggendo dati sensibili e finanziari.

📝 Descrizione del Modello
L'implementazione nasce per risolvere le criticità riscontrate nei modelli tradizionali, focalizzandosi sulle necessità dei diversi attori coinvolti:

👤 Il Cliente (Utente Finale)
Esigenza: Evitare code fisiche e assicurarsi il posto desiderato in anticipo.

Soluzione: Interfaccia veloce per consultazione orari, disponibilità posti in tempo reale e acquisto immediato.

💼 L'Amministratore (Gestore)
Esigenza: Centralizzazione e controllo totale.

Soluzione: Strumenti automatizzati per prevenire errori di programmazione e reportistica finanziaria in tempo reale (incassi) per l'ottimizzazione del palinsesto.

🎫 Lo Staff (Operatore)
Esigenza: Rapidità operativa e sicurezza.

Soluzione: Strumento di validazione rapida dei titoli di accesso all'ingresso delle sale, con accesso limitato alle sole funzioni operative, escludendo i dati sensibili o finanziari.
