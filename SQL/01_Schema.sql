CREATE DATABASE IF NOT EXISTS tor_vercinema;
USE tor_vercinema;

-- 2. Tabella FILM 
CREATE TABLE FILM (
    ID_Film INT PRIMARY KEY AUTO_INCREMENT, -- Identificativo univoco 
    Titolo VARCHAR(255) NOT NULL,            -- Titolo del film
    Genere VARCHAR(100),                    -- Categoria cinematografica 
    Durata INT,                             -- Durata in minuti 
    Regista VARCHAR(255)                    -- Nome e cognome del regista 
) ENGINE=InnoDB; 

-- 3. Tabella SALA
CREATE TABLE SALA (
    ID_Sala INT PRIMARY KEY,                -- Numero o ID della sala 
    Capienza_Totale INT NOT NULL            -- Numero massimo di posti
) ENGINE=InnoDB; 

-- 4. Tabella POSTO
CREATE TABLE POSTO (
    ID_Posto INT PRIMARY KEY,               -- Identificativo univoco del posto 
    Fila CHAR(1) NOT NULL,                  -- Lettera della fila (es. 'A') 
    Numero INT NOT NULL,                    -- Numero del posto nella fila 
    FK_Sala INT NOT NULL,                   -- Riferimento alla sala 
    FOREIGN KEY (FK_Sala) REFERENCES SALA(ID_Sala) 
        ON UPDATE CASCADE ON DELETE CASCADE -- Vincolo di integrità referenziale
) ENGINE=InnoDB;

-- 5. Tabella PROIEZIONE 
CREATE TABLE PROIEZIONE (
    ID_Proiezione INT PRIMARY KEY,          -- Identificativo dell'evento 
    Data_Ora DATETIME NOT NULL,             -- Data e orario di inizio
    Prezzo DECIMAL(5,2) NOT NULL,           -- Costo del biglietto (es. 10.50)
    FK_Film INT NOT NULL,                   -- Riferimento al film 
    FK_Sala INT NOT NULL,                   -- Riferimento alla sala 7]
    FOREIGN KEY (FK_Film) REFERENCES FILM(ID_Film) ON UPDATE CASCADE,
    FOREIGN KEY (FK_Sala) REFERENCES SALA(ID_Sala) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Tabella UTENTE 
CREATE TABLE UTENTE (
    ID_Utente INT PRIMARY KEY,              -- Identificativo utente 
    Username VARCHAR(50) UNIQUE NOT NULL,   -- Nome utente univoco
    Email VARCHAR(100) UNIQUE NOT NULL,     -- Indirizzo email
    Password VARCHAR(255) NOT NULL,         -- Hash della password 
    Ruolo ENUM('Cliente', 'Staff', 'Admin') NOT NULL -- Business Rule sui ruoli 
) ENGINE=InnoDB;

-- 7. Tabella PRENOTAZIONE
CREATE TABLE PRENOTAZIONE (
    ID_Prenotazione INT PRIMARY KEY AUTO_INCREMENT, -- Numero del ticket 
    Data_Acquisto TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Momento della transazione 
    FK_Utente INT NOT NULL,                  -- Chi prenota 
    FK_Proiezione INT NOT NULL,              -- Quale spettacolo
    FK_Posto INT NOT NULL,                   -- Quale posto
    
    FOREIGN KEY (FK_Utente) REFERENCES UTENTE(ID_Utente),
    FOREIGN KEY (FK_Proiezione) REFERENCES PROIEZIONE(ID_Proiezione),
    FOREIGN KEY (FK_Posto) REFERENCES POSTO(ID_Posto),
    
    -- Vincolo di Unicità: un posto non può essere venduto due volte per la stessa proiezione 
    UNIQUE (FK_Proiezione, FK_Posto)
) ENGINE=InnoDB;