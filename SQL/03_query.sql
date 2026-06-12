use tor_vercinema;

-- 1. raggruppamento per fasce d'età con costrutto case when 
select 
    sum(case when timestampdiff(year, data_nascita, curdate()) < 30 then 1 else 0 end) as clienti_under30,
    sum(case when timestampdiff(year, data_nascita, curdate()) > 65 then 1 else 0 end) as clienti_senior
from utente
where ruolo = 'cliente';

-- 2. età media raggruppata direttamente per ruolo 
select ruolo, avg(timestampdiff(year, data_nascita, curdate())) as eta_media
from utente
group by ruolo;

-- 3. operazione 01 (da documento): ricerca palinsesto giornaliero per una data specifica
select f.titolo, p.data_ora, s.id_sala, p.prezzo
from proiezione p
join film f on p.fk_film = f.id_film
join sala s on p.fk_sala = s.id_sala
where date(p.data_ora) = '2026-06-10';


-- 4. operazione 02: inserimento di una nuova prenotazione (query di tipo scrittura)
insert into prenotazione (data_acquisto, fk_proiezione, fk_posto, fk_utente) 
values (now(), 1, 15, 2);

-- 5. operazione 04: inserimento di una nuova proiezione a palinsesto
insert into proiezione (data_ora, prezzo, fk_film, fk_sala) 
values ('2026-06-20 21:00:00', 8.50, 3, 2);

-- 6. operazione 06: cancellazione automatica delle proiezioni passate (pulizia db)
delete from proiezione 
where TIMESTAMPDIFF(year, data_ora, NOW()) >=2;

-- 7. operazione 07: cancellazione prenotazioni legate a proiezioni terminate (scarto di 2 anni) usando una join
delete pr
from prenotazione pr
join proiezione p on pr.fk_proiezione = p.id_proiezione
where TIMESTAMPDIFF(year, p.data_ora, NOW()) >= 2;

-- 8. subquery con is null: mostra i film in catalogo che non hanno ricevuto nessuna prenotazione
select f.titolo
from film f
left join proiezione p on f.id_film = p.fk_film
left join prenotazione pr on p.id_proiezione = pr.fk_proiezione
where pr.id_prenotazione is null;

-- 9. statistica base: film vietati ai minori (consigliata per la traduzione in algebra relazionale)
select titolo as film_vm18
from film
where classificazione = 'vm18';

-- 10. aggregazione avanzata: film con voto medio > 4 ma solo se hanno almeno 2 recensioni (clausola having)
select f.titolo, avg(r.voto) as media_valutazione
from recensione r
join film f on f.id_film = r.fk_film
group by f.id_film, f.titolo
having count(r.id_recensione) >= 2 and avg(r.voto) > 4
order by media_valutazione desc;

-- 11. classifica film più visti in base al numero di prenotazioni
select f.titolo, count(pr.id_prenotazione) as numero_prenotazioni
from film f
join proiezione p on p.fk_film = f.id_film
join prenotazione pr on p.id_proiezione = pr.fk_proiezione
group by f.id_film, f.titolo
order by numero_prenotazioni desc;

-- 12. incasso totale per film
select f.titolo, sum(p.prezzo) as incasso_film
from film f
join proiezione p on p.fk_film = f.id_film
join prenotazione pr on p.id_proiezione = pr.fk_proiezione
group by f.id_film, f.titolo
order by incasso_film desc;

-- 13. media dell'incasso giornaliero (uso di query annidata nel blocco from)
select avg(incasso_giornaliero) as incasso_medio_giornaliero
from (
    select sum(p.prezzo) as incasso_giornaliero
    from proiezione p
    join prenotazione pr on p.id_proiezione = pr.fk_proiezione
    group by date(p.data_ora)
) as incassi;

-- 14. subquery nel where: trova il cliente che ha speso di più in assoluto nel cinema
select u.username, sum(p.prezzo) as spesa_totale
from utente u
join prenotazione pr on pr.fk_utente = u.id_utente
join proiezione p on p.id_proiezione = pr.fk_proiezione
group by u.id_utente, u.username
having sum(p.prezzo) = (
    select max(spesa_utente)
    from (
        select sum(p2.prezzo) as spesa_utente
        from prenotazione pr2
        join proiezione p2 on pr2.fk_proiezione = p2.id_proiezione
        group by pr2.fk_utente
    ) as spese_raggruppate
);

-- 15. classifica dei generi cinematografici più apprezzati
select g.nome_genere, count(pr.id_prenotazione) as totale_prenotazioni
from generi g
join film_generi fg on g.id_genere = fg.fk_genere
join film f on fg.fk_film = f.id_film
join proiezione p on f.id_film = p.fk_film
join prenotazione pr on p.id_proiezione = pr.fk_proiezione
group by g.id_genere, g.nome_genere
order by totale_prenotazioni desc;


-- ------------------------------------------------------------------------------

delimiter //

-- trigger per blocco vendita biglietti vm18 ai minorenni
create trigger check_eta_prenotazione
before insert on prenotazione
for each row
begin
    declare eta_utente int;
    declare classificazione_film varchar(5);

    -- estrapola l'età dello specifico utente che sta comprando (new indica la nuova riga in inserimento)
    select timestampdiff(year, data_nascita, curdate()) into eta_utente
    from utente
    where id_utente = new.fk_utente;

    -- estrapola la classificazione del film legato alla proiezione scelta
    select f.classificazione into classificazione_film
    from proiezione p
    join film f on p.fk_film = f.id_film
    where p.id_proiezione = new.fk_proiezione;

    -- se il film è vm18 e l'utente ha meno di 18 anni abortisce l'operazione
    if classificazione_film = 'vm18' and eta_utente < 18 then
        signal sqlstate '45000'
        set message_text = 'errore: divieto di vendita, utente minorenne per film vm18';
    end if;
end //

delimiter ;
