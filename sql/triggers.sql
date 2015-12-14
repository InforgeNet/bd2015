DELIMITER $$

-- TODO: Usare DECLARE invece di SET per tutte le variabili?

/******************************************************************************
 * nuova_consegna si assicura che ogni volta che viene inserita una nuova     *
 * consegna il pony a cui viene assegnata sia libero e che la comanda sia     *
 * effettivamente in attesa di consegna.                                      *
 ******************************************************************************/
CREATE TRIGGER nuova_consegna
BEFORE INSERT
ON Consegna
FOR EACH ROW
BEGIN
    SET @StatoPony = (SELECT P.Stato AS StatoPony
                        FROM Pony P
                        WHERE P.ID = NEW.Pony);

    SET @StatoComanda = (SELECT C.stato AS StatoComanda
                                FROM Comanda C
                                WHERE C.ID = NEW.ID);
                                
    IF @StatoPony <> 'libero' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Assegnamento di consegna a pony non libero.';
    ELSE IF @StatoComanda <> 'consegna' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Comanda relativa non pronta per la consegna.';
    END IF;
END$$

/******************************************************************************
 * nuova_prenotazione controlla: se l'account (in caso di prenotazione online)*
 * è abilitato a prenotare; se il tavolo da prenotare è libero; se la sala e  *
 * tutti i tavoli che contiene sono liberi per un allestimento.               *
 ******************************************************************************/
CREATE TRIGGER nuova_prenotazione
BEFORE INSERT
ON Prenotazione
FOR EACH ROW
BEGIN
    IF NEW.Account <> NULL THEN
        SET @PrenotazioniAbilitate = (SELECT A.PuoPrenotare
                                        FROM Account A
                                        WHERE A.Username = NEW.Account);
                                        
        IF @PrenotazioniAbilitate = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prenotazioni disabilitate per l\'account.';
        END IF;
    END IF;    
        
        SET @AllestimentiSala = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                                    FROM Prenotazione P
                                    WHERE P.Sala = NEW.Sala
                                        AND P.Sede = NEW.Sede
                                        AND P.Tavolo = NULL);
                        
    IF @AllestimentiSala > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala scelta è già prenotata per allestimento.';
    END IF;
    
    IF NEW.Tavolo <> NULL THEN
        SET @PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
        
        IF @PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo non ha un numero adeguato di posti.';
        END IF;

-- NOTA: L'uso di espressioni booleane all'interno di SUM() è possibile solo in
--       MySQL (che converte l'espressione booleana in int). In altri DBMS si
--       può utilizzare COUNT() e spostare l'espressione booleana nel WHERE.
        SET @TavoloLibero = (SELECT SUM(P.Date 
                                        BETWEEN (NEW.Date - INTERVAL 2 HOUR)
                                            AND (NEW.Date + INTERVAL 2 HOUR))
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo
                                AND P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);

        IF @TavoloLibero > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    ELSE
        SET @SalaLibera = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                            FROM Prenotazione P
                            WHERE P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);
                            
        IF @SalaLibera > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala contiene tavoli prenotati.';
        END IF;
    END IF;
END$$

/******************************************************************************
 * rettifica_prenotazione controlla che la rettifica della prenotazione venga *
 * fatta al max. 48 ore prima della data della prenotazione. Inoltre controlla*
 * che la nuova prenotazione sia valida.                                      *
 ******************************************************************************/
CREATE TRIGGER rettifica_prenotazione
BEFORE UPDATE
ON Prenotazione
FOR EACH ROW
BEGIN
    SET @PuoRettificare = (SELECT (NOW() < OLD.Data - INTERVAL 2 DAY)
                          FROM Prenotazione P
                          WHERE P.ID = OLD.ID); -- ??
                          
   	IF @PuoRettificare = 0 THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile modificare la prenotazione.';
    END IF;
    
    -- TODO: controllare stesse cose INSERT (con procedura?)
END$$

/******************************************************************************
 * rettifica_prenotazione controlla che l'annullamento della prenotazione     *
 * venga fatta al max. 72 ore prima della data della prenotazione.            *
 ******************************************************************************/
CREATE TRIGGER annulla_prenotazione
BEFORE DELETE
ON Prenotazione
FOR EACH ROW
BEGIN
    SET @PuoAnnullare = (SELECT (NOW() < OLD.Data - INTERVAL 3 DAY)
                          FROM Prenotazione P
                          WHERE P.ID = OLD.ID); -- ??
                          
   	IF @PuoAnnullare = 0 THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile annullare la prenotazione.';
    END IF;
END$$

-- TODO: Vanno fatti anche tutti gli altri trigger in quanto MySQL non supporta
--       i CHECK constraint!

DELIMITER ;
