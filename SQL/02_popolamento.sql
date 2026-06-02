USE tor_vercinema;

-- ==============================================================================
-- POPOLAMENTO TABELLE ANAGRAFICHE (Senza dipendenze)
-- ==============================================================================

-- 1. Inserimento GENERI (Aggiunti nuovi generi per coprire i nuovi film)
INSERT INTO GENERI (ID_Genere, Nome_Genere) VALUES 
(1, 'Azione'),
(2, 'Fantascienza'),
(3, 'Commedia'),
(4, 'Animazione'),
(5, 'Horror'),
(6, 'Drammatico'),
(7, 'Avventura'),
(8, 'Thriller'),
(9, 'Romantico'),
(10, 'Documentario');

-- 2. Inserimento SALE (Portate a 5 come da stima del progetto)
INSERT INTO SALA (ID_Sala, Capienza_Totale) VALUES 
(1, 150),
(2, 100),
(3, 80),
(4, 50),  -- Sala VIP
(5, 30);  -- Sala Privè

-- 3. Inserimento UTENTI (Aggiunti nuovi profili con età differenti per testare VM14/VM18)
INSERT INTO UTENTE (ID_Utente, Username, Email, Password, Data_Nascita, Ruolo) VALUES 
(1, 'mario.rossi', 'mario.rossi@email.it', '5e884898da28047151d0e56f8dc62927', '1995-05-15', 'Cliente'),
(2, 'giulia.bianchi', 'giulia.b@email.it', 'e10adc3949ba59abbe56e057f20f883e', '2008-10-20', 'Cliente'),  -- < 18 anni nel 2026
(3, 'operatore_sala1', 'staff1@torvercinema.it', '900150983cd24fb0d6963f7d28e17f72', '1990-11-03', 'Staff'),
(4, 'admin_master', 'direzione@torvercinema.it', 'adminhash99998888777766665555444', '1985-02-28', 'Admin'),
(5, 'luca_giovane', 'luca99@email.it', 'a94a8fe5ccb19ba61c4c0873d391e987', '2010-03-12', 'Cliente'),   -- 16 anni nel 2026
(6, 'sara_cinefila', 'sara.cine@email.it', 'c81e728d9d4c2f636f067f89cc14862c', '1988-07-24', 'Cliente'),
(7, 'nonno_pino', 'giuseppe.anziano@email.it', 'eccbc87e4b5ce2fe28308fd9f2a7baf3', '1955-01-10', 'Cliente'); -- Utente per sconto Senior

-- 4. Inserimento FILM (10 Film con trame estese ed escape dei singoli apici)
INSERT INTO FILM (ID_Film, Titolo, Durata, Regista, Classificazione, Casa_Produzione, Scadenza_Diritti, Trama) VALUES 
(1, 'Dune - Parte Due', 166, 'Denis Villeneuve', 'T', 'Warner Bros', '2026-12-31', 'Il viaggio mitico di Paul Atreides che si unisce a Chani e ai Fremen per vendicarsi dei cospiratori che hanno distrutto la sua famiglia.'),
(2, 'Deadpool & Wolverine', 127, 'Shawn Levy', 'VM14', 'Marvel Studios', '2027-06-30', 'Il mercenario chiacchierone si unisce a un riluttante Wolverine per salvare il suo universo da una minaccia esistenziale.'),
(3, 'Inside Out 2', 96, 'Kelsey Mann', 'T', 'Pixar Animation', '2026-10-15', 'Il quartier generale nella mente di Riley subisce un''improvvisa demolizione per far posto a nuove emozioni, tra cui Ansia.'),
(4, 'Nosferatu', 132, 'Robert Eggers', 'VM18', 'Focus Features', '2026-11-30', 'Una storia gotica di ossessione tra una giovane donna tormentata e il terrificante vampiro infatuato di lei.'),
(5, 'Furiosa: A Mad Max Saga', 148, 'George Miller', 'VM14', 'Warner Bros', '2027-01-15', 'Mentre il mondo crolla, la giovane Furiosa viene strappata al Luogo Verde delle Molte Madri e cade nelle mani di una grande Orda di Motociclisti guidata dal Signore della Guerra Dementus.'),
(6, 'Oppenheimer', 180, 'Christopher Nolan', 'T', 'Universal Pictures', '2026-12-31', 'La storia del fisico scienziato americano J. Robert Oppenheimer e del suo ruolo nello sviluppo della bomba atomica durante la Seconda Guerra Mondiale.'),
(7, 'Spider-Man: Across the Spider-Verse', 140, 'Joaquim Dos Santos', 'T', 'Sony Pictures', '2026-08-30', 'Miles Morales viene catapultato nel Multiverso, dove incontra una squadra di Spider-Eroi incaricata di proteggerne l''esistenza.'),
(8, 'Povere Creature!', 141, 'Yorgos Lanthimos', 'VM14', 'Searchlight Pictures', '2026-10-01', 'L''incredibile storia e la fantastica evoluzione di Bella Baxter, una giovane donna riportata alla vita dal brillante e poco ortodosso scienziato Dr. Godwin Baxter.'),
(9, 'Longlegs', 101, 'Osgood Perkins', 'VM18', 'Neon', '2026-09-15', 'L''agente dell''FBI Lee Harker viene assegnata a un caso irrisolto di omicidi seriali che prende pieghe inaspettate, rivelando prove di occultismo.'),
(10, 'Challengers', 131, 'Luca Guadagnino', 'T', 'MGM', '2026-11-20', 'Tashi Duncan, ex prodigio del tennis diventata allenatrice, iscrive il marito, un campione in crisi, a un torneo Challenger dove dovrà affrontare il suo ex migliore amico.');


-- ==============================================================================
-- POPOLAMENTO TABELLE PONTE E DIPENDENTI
-- ==============================================================================

-- 5. Inserimento FILM_GENERI
INSERT INTO FILM_GENERI (FK_Film, FK_Genere) VALUES 
(1, 1), (1, 2), (1, 7),        -- Dune: Azione, Fantascienza, Avventura
(2, 1), (2, 3),                -- Deadpool: Azione, Commedia
(3, 3), (3, 4),                -- Inside Out 2: Commedia, Animazione
(4, 5), (4, 8),                -- Nosferatu: Horror, Thriller
(5, 1), (5, 2),                -- Furiosa: Azione, Fantascienza
(6, 6), (6, 10),               -- Oppenheimer: Drammatico, Documentario
(7, 1), (7, 4), (7, 7),        -- Spiderman: Azione, Animazione, Avventura
(8, 3), (8, 2), (8, 6),        -- Povere Creature: Commedia, Fantascienza, Drammatico
(9, 5), (9, 8),                -- Longlegs: Horror, Thriller
(10, 6), (10, 9);              -- Challengers: Drammatico, Romantico

-- 6. Inserimento POSTI (Aumentati per simulare blocchi di poltrone per le prime 3 Sale)
-- SALA 1
INSERT INTO POSTO (ID_Posto, Fila, Numero, FK_Sala) VALUES 
(1, 'A', 1, 1), (2, 'A', 2, 1), (3, 'A', 3, 1), (4, 'A', 4, 1), (5, 'A', 5, 1),
(6, 'B', 1, 1), (7, 'B', 2, 1), (8, 'B', 3, 1), (9, 'B', 4, 1), (10, 'B', 5, 1);
-- SALA 2
INSERT INTO POSTO (ID_Posto, Fila, Numero, FK_Sala) VALUES 
(11, 'A', 1, 2), (12, 'A', 2, 2), (13, 'A', 3, 2), (14, 'A', 4, 2), (15, 'A', 5, 2),
(16, 'B', 1, 2), (17, 'B', 2, 2), (18, 'B', 3, 2), (19, 'B', 4, 2), (20, 'B', 5, 2);
-- SALA 3
INSERT INTO POSTO (ID_Posto, Fila, Numero, FK_Sala) VALUES 
(21, 'A', 1, 3), (22, 'A', 2, 3), (23, 'A', 3, 3),
(24, 'B', 1, 3), (25, 'B', 2, 3), (26, 'B', 3, 3);
-- SALA 4 E 5 (Sale piccole)
INSERT INTO POSTO (ID_Posto, Fila, Numero, FK_Sala) VALUES 
(27, 'A', 1, 4), (28, 'A', 2, 4), (29, 'A', 3, 4),
(30, 'A', 1, 5), (31, 'A', 2, 5), (32, 'A', 3, 5);

-- 7. Inserimento PROIEZIONI (Programmazione densa per coprire i nuovi film)
INSERT INTO PROIEZIONE (ID_Proiezione, Data_Ora, Prezzo, FK_Film, FK_Sala) VALUES 
(1, '2026-06-10 18:30:00', 8.50, 3, 1),  -- Inside Out 2
(2, '2026-06-10 21:00:00', 10.00, 1, 1), -- Dune
(3, '2026-06-11 22:30:00', 10.00, 4, 2), -- Nosferatu
(4, '2026-06-12 20:15:00', 9.50, 2, 3),  -- Deadpool
(5, '2026-06-13 17:00:00', 8.00, 7, 1),  -- Spiderman
(6, '2026-06-13 21:15:00', 10.50, 6, 2), -- Oppenheimer
(7, '2026-06-14 20:30:00', 9.50, 5, 3),  -- Furiosa
(8, '2026-06-15 19:00:00', 12.00, 8, 4), -- Povere Creature! (Prezzo maggiorato in Sala VIP)
(9, '2026-06-15 22:00:00', 12.00, 9, 5), -- Longlegs (Sala Privè)
(10, '2026-06-16 21:00:00', 9.50, 10, 2); -- Challengers

-- 8. Inserimento RECENSIONI (Valutazioni assortite)
INSERT INTO RECENSIONE (ID_Recensione, Voto, Commento, Data_Scrittura, FK_Utente, FK_Film) VALUES 
(1, 5, 'Visivamente impressionante, il miglior film di fantascienza del decennio!', '2026-06-01 10:15:00', 1, 1),
(2, 4, 'Molto divertente e commovente, degno del primo capitolo.', '2026-06-02 14:20:00', 2, 3),
(3, 5, 'Nolan si conferma un maestro assoluto. Cast stellare e sonoro da Oscar.', '2026-06-03 11:00:00', 6, 6),
(4, 5, 'Un capolavoro di animazione. I colori, le musiche, tutto perfetto.', '2026-06-04 18:30:00', 5, 7),
(5, 3, 'Inquietante ma in alcune parti un po'' troppo lento per i miei gusti.', '2026-06-05 09:10:00', 1, 9),
(6, 4, 'Anya Taylor-Joy è magnifica. Azione pura dall''inizio alla fine!', '2026-06-05 16:45:00', 6, 5);

-- 9. Inserimento PRENOTAZIONI
INSERT INTO PRENOTAZIONE (ID_Prenotazione, Data_Acquisto, FK_Proiezione, FK_Posto, FK_Utente) VALUES 
(1, '2026-06-05 09:00:00', 1, 1, 1),   -- Mario prenota Inside Out 2
(2, '2026-06-06 11:30:00', 2, 2, 2),   -- Giulia prenota Dune
(3, '2026-06-06 11:35:00', 2, 3, 1),   -- Mario prenota Dune (vicino a Giulia)
(4, '2026-06-07 10:00:00', 5, 4, 5),   -- Luca (16 anni) prenota Spiderman (T)
(5, '2026-06-08 14:20:00', 6, 11, 7),  -- Nonno Pino prenota Oppenheimer (T)
(6, '2026-06-08 15:00:00', 3, 12, 1),  -- Mario prenota Nosferatu (VM18 - Mario è maggiorenne)
(7, '2026-06-09 18:10:00', 7, 21, 6),  -- Sara prenota Furiosa (VM14)
(8, '2026-06-09 18:15:00', 7, 22, 1),  -- Mario prenota Furiosa
(9, '2026-06-10 11:00:00', 8, 27, 6),  -- Sara prenota Povere Creature (Sala VIP)
(10, '2026-06-10 16:00:00', 10, 16, 2);-- Giulia prenota Challengers