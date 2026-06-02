USE tor_vercinema;

-- 1. VISTA_CLIENTE: Palinsesto pubblico per i clienti
CREATE VIEW VISTA_CLIENTE AS
SELECT 
    F.Titolo AS Titolo_Film,
    GROUP_CONCAT(G.Nome_Genere SEPARATOR ', ') AS Generi,    -- Unisce i generi multipli in un'unica stringa
    F.Classificazione,
    P.Data_Ora AS Orario,
    S.ID_Sala AS Sala,
    P.Prezzo
FROM FILM F
JOIN PROIEZIONE P ON F.ID_Film = P.FK_Film                   -- Collega il film alle sue proiezioni
JOIN SALA S ON P.FK_Sala = S.ID_Sala                         -- Collega la proiezione alla sua sala fisica
LEFT JOIN FILM_GENERI FG ON F.ID_Film = FG.FK_Film
LEFT JOIN GENERI G ON FG.FK_Genere = G.ID_Genere
WHERE P.Data_Ora > NOW()                                     -- Esclude i film già iniziati o passati
  AND P.Data_Ora <= F.Scadenza_Diritti                       -- Blocca proiezioni se i diritti sono scaduti
GROUP BY P.ID_Proiezione, F.Titolo, F.Classificazione, P.Data_Ora, S.ID_Sala, P.Prezzo;


CREATE VIEW VISTA_STAFF AS
SELECT 
    PR.ID_Prenotazione,                                      -- ID del biglietto da scansionare/spuntare
    U.Username AS Username_Cliente,                          -- Riferimento visivo per controllo identità
    F.Titolo AS Titolo_Film,                                 -- Nome del film (più comprensibile dell'ID)
    P.Data_Ora AS Orario_Spettacolo,                         -- Orario per verificare che il biglietto sia per oggi
    S.ID_Sala AS Sala,                                       -- Sala in cui indirizzare fisicamente il cliente
    PO.Fila AS Fila_Posto,                                   -- Coordinata spaziale: Fila
    PO.Numero AS Numero_Posto                                -- Coordinata spaziale: Numero
FROM PRENOTAZIONE PR
JOIN UTENTE U ON PR.FK_Utente = U.ID_Utente                  
JOIN POSTO PO ON PR.FK_Posto = PO.ID_Posto                   
JOIN PROIEZIONE P ON PR.FK_Proiezione = P.ID_Proiezione      -- Risale alla proiezione per estrarre l'orario
JOIN FILM F ON P.FK_Film = F.ID_Film                         -- Dalla proiezione risale al titolo del film
JOIN SALA S ON P.FK_Sala = S.ID_Sala                         -- Dalla proiezione risale alla stanza fisica
ORDER BY PR.ID_Prenotazione ASC;                             -- Ordina i biglietti in modo numerico sequenziale


-- 3. VISTA_ADMIN: Cruscotto direzionale incassi in tempo reale
CREATE VIEW VISTA_ADMIN AS
SELECT 
    F.Titolo AS Titolo_Film,
    DATE(P.Data_Ora) AS Giorno_Proiezione,                   -- Estrapola solo la data esatta dall'orario
    COUNT(PR.ID_Prenotazione) AS Biglietti_Venduti,          -- Conta il numero di prenotazioni effettuate
    COALESCE(SUM(P.Prezzo), 0) AS Incasso_Totale             -- Somma i prezzi (se 0 biglietti venduti, restituisce 0)
FROM FILM F
JOIN PROIEZIONE P ON F.ID_Film = P.FK_Film                   -- Recupera le proiezioni per ogni film
LEFT JOIN PRENOTAZIONE PR ON P.ID_Proiezione = PR.FK_Proiezione -- Includi la proiezione anche se non ha vendite
GROUP BY F.ID_Film, F.Titolo, DATE(P.Data_Ora);              -- Aggrega i risultati per film e per giornata

