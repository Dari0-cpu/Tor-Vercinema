CREATE DATABASE IF NOT EXISTS tor_vercinema;
USE tor_vercinema;

-- 1. CREAZIONE TABELLE FORTI (Senza Foreign Key)

-- Tabella FILM 
CREATE TABLE FILM (
    ID_Film int primary key auto_increment,               -- Identificativo univoco 
    Titolo varchar(255) not null,                         -- Titolo del film
    Durata int                                            -- Durata in minuti 
        check(Durata > 0),                                -- La durata non può essere negativa
    Regista varchar(255),                                 -- Nome e cognome del regista
    Classificazione enum('T', '6+', 'VM14', 'VM18'),      -- Classificazione del film
    Casa_Produzione varchar(255),                         -- Casa cinematografica
    Scadenza_Diritti date not null,                       -- Data di scadenza diritti di trasmissione
    Trama text                                            -- Usato TEXT per consentire testi lunghi
) engine=InnoDB; 

-- Tabella GENERI
CREATE TABLE GENERI (
    ID_Genere int primary key auto_increment,             -- Chiave primaria genere
    Nome_Genere varchar(50) not null unique               -- Genere non nullo e unico
) engine=InnoDB;

-- Tabella SALA
CREATE TABLE SALA (
    ID_Sala int primary key auto_increment,               -- Chiave primaria sala
    Capienza_Totale int not null                          -- Capienza massima della sala
        check(Capienza_Totale >= 1)
) engine=InnoDB;

-- Tabella UTENTE
CREATE TABLE UTENTE (
    ID_Utente int primary key auto_increment,             -- Chiave primaria utente
    Username varchar(50) unique not null,                 -- Username unico
    Email varchar(100) unique not null,                   -- Email utente
    Password varchar(255) not null,                       -- Hash della password
    Data_Nascita date not null,                           -- Data di nascita per età e sconti
    Ruolo enum('Cliente', 'Staff', 'Admin')               -- Gestione permessi RBAC
) engine=InnoDB;


-- 2. CREAZIONE TABELLE DIPENDENTI (Con Foreign Key)

-- Tabella FILM_GENERI
CREATE TABLE FILM_GENERI (
    FK_Film int not null,                                 
    FK_Genere int not null,                               
    
    primary key (FK_Film, FK_Genere),                     -- Chiave primaria composta
    
    foreign key (FK_Film) references FILM(ID_Film)
        on delete cascade on update cascade,              
    
    foreign key (FK_Genere) references GENERI(ID_Genere) 
        on delete cascade on update cascade               
) engine=InnoDB;

-- Tabella POSTO
CREATE TABLE POSTO (
    ID_Posto int primary key auto_increment,              
    Fila char(1) not null,                                
    Numero int not null,                                  
    FK_Sala int not null,                                 
    
    foreign key (FK_Sala) references SALA(ID_Sala)
        on delete cascade on update cascade               
) engine=InnoDB;

-- Tabella PROIEZIONE
CREATE TABLE PROIEZIONE (
    ID_Proiezione int primary key auto_increment,         
    Data_Ora datetime not null,                           
    Prezzo decimal(5,2) not null,                       
        check (Prezzo >= 0),                             
    FK_Film int not null,                                 
    FK_Sala int not null,                                 
    
    foreign key (FK_Film) references FILM(ID_Film)
        on delete cascade on update cascade,              
    foreign key (FK_Sala) references SALA(ID_Sala)
        on delete cascade on update cascade               
) engine=InnoDB;

-- Tabella RECENSIONE (messo al singolare per coerenza)
CREATE TABLE RECENSIONE (
    ID_Recensione int primary key auto_increment,         
    Voto int not null                                     
        check (Voto >= 0 AND Voto <= 5),                  
    Commento text,                                        
    Data_Scrittura datetime,                              
    FK_Utente int not null,                               
    FK_Film int not null,                                 
    
    foreign key (FK_Utente) references UTENTE(ID_Utente)
        on delete cascade on update cascade,              
    foreign key (FK_Film) references FILM(ID_Film)
        on delete cascade on update cascade               
) engine=InnoDB;

-- Tabella PRENOTAZIONE
CREATE TABLE PRENOTAZIONE (
    ID_Prenotazione int primary key auto_increment,
    Data_Acquisto datetime not null,                      
    FK_Proiezione int not null,
    FK_Posto int not null,
    FK_Utente int not null,
    
    foreign key (FK_Proiezione) references PROIEZIONE(ID_Proiezione)
		on delete restrict on update cascade,            
    foreign key (FK_Posto) references POSTO(ID_Posto)
        on delete cascade on update cascade,              
    foreign key (FK_Utente) references UTENTE(ID_Utente)
        on delete cascade on update cascade               
) engine=InnoDB;