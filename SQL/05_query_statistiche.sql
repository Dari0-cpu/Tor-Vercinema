SELECT COUNT(*) AS NumeroClientiUnder30
FROM Utente                                                                       -- numero clienti under 30
WHERE TIMESTAMPDIFF(YEAR, Data_Nascita, CURDATE()) < 30 and Ruolo like 'Cliente';




SELECT COUNT(*) AS NumeroClientiSenior
FROM Utente                                                                       -- numero clienti over 65
WHERE TIMESTAMPDIFF(YEAR, Data_Nascita, CURDATE()) >65 and Ruolo like 'Cliente';



  
SELECT AVG(TIMESTAMPDIFF(YEAR, Data_Nascita, CURDATE())) AS Eta_media_Cliente
FROM utente                                                                      -- Età media dei clienti
WHERE ruolo like 'Cliente';


  
SELECT AVG(TIMESTAMPDIFF(YEAR, Data_Nascita, CURDATE())) AS eta_media_staff
FROM utente                                                                    -- Età media dello staff
WHERE ruolo like 'Staff';

  
  
SELECT Titolo AS film_over_18
FROM film                                   -- numero film over 18
WHERE Classificazione LIKE 'VM18';


SELECT SUM(Capienza_Totale) AS Posti_Totali_Cinema             -- posti totali del cinema
FROM sala  ;

  
SELECT COUNT(*) AS totale_prenotazioni                    -- totale prenotazioni
FROM prenotazione;





SELECT titolo, COUNT(*) AS NumeroPrenotazioni
FROM film f 
JOIN Proiezione p ON p.FK_Film=f.ID_Film                    -- Classifica film più visti (con più prenotazioni)
JOIN Prenotazione c ON p.ID_Proiezione= c.FK_Proiezione
GROUP BY f.ID_Film, f.Titolo
ORDER BY NumeroPrenotazioni desc;


  
SELECT titolo, SUM(p.prezzo) AS incasso
FROM film f 
JOIN Proiezione p ON p.FK_Film=f.ID_Film                    -- Classifica film più incasso
JOIN Prenotazione c ON p.ID_Proiezione= c.FK_Proiezione
GROUP BY f.ID_Film, f.Titolo
ORDER BY incasso desc;


  
SELECT SUM(p.prezzo) AS incasso_totale
FROM proiezione p                                           -- incasso totale
JOIN prenotazione c ON p.ID_Proiezione = c.FK_Proiezione;






SELECT AVG(incasso_giornaliero) AS incasso_medio_giornaliero
FROM ( SELECT SUM(p.prezzo) AS incasso_giornaliero
	  FROM proiezione p                                          -- incasso medio giornaliero
      JOIN prenotazione c ON p.ID_Proiezione = c.FK_Proiezione
      GROUP BY DATE (p.Data_Ora)) i ;




  
SELECT f.Titolo, COUNT(*) AS num_recensioni
FROM recensione r 
JOIN film f ON f.ID_Film = r.FK_Film               --  Classifica film con più recensioni
GROUP BY f.ID_film, f.Titolo;



  
SELECT f.Titolo, AVG(r.Voto) AS media_recensioni
FROM recensione r 
JOIN film f ON f.ID_Film = r.FK_Film               --  Classifica film con valutazione media pià alta
GROUP BY f.ID_film, f.Titolo
ORDER BY media_recensioni desc;




SELECT u.Username, SUM(c.Prezzo) AS Spesa_Totale
FROM utente u
JOIN prenotazione p ON p.FK_Utente = u.ID_Utente          -- spesa totale per ogni cliente registrato
JOIN proiezione c ON c.ID_Proiezione = p.FK_Proiezione
GROUP BY u.ID_Utente, u.Username 
ORDER BY Spesa_Totale desc;



  
SELECT g.Nome_Genere, COUNT(*) as num_prenotazioni
FROM generi g
JOIN film_generi fg ON g.ID_Genere=fg.FK_Genere
JOIN film f ON fg.FK_Film=f.ID_Film                           -- Classifica generi più apprezzati 
JOIN proiezione p ON f.ID_Film=p.FK_Film
JOIN prenotazione pr ON p.ID_Proiezione=pr.FK_Proiezione
GROUP BY g.ID_Genere, g.Nome_Genere
ORDER BY num_prenotazioni desc;






