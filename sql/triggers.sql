DELIMITER $$

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
 * è abilitato a prenotare; se la data inserita è successiva alla data        *
 * attuale; se il tavolo da prenotare è libero; se la sala e tutti i tavoli   *
 * che contiene sono liberi per un allestimento.                              *
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
    
    IF NEW.Data <= NOW() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La data deve essere successiva a quella attuale.';
    END IF;
    
        SET @AllestimentiSala = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                                    FROM Prenotazione P
                                    WHERE P.Sala = NEW.Sala
                                        AND P.Tavolo = NULL);
                        
    IF @AllestimentiSala > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala scelta è già prenotata per allestimento.';
    END IF;
    
    IF NEW.Tavolo <> NULL THEN
        SET @TavoloLibero = (SELECT SUM(P.Date 
                                        BETWEEN (NEW.Date - INTERVAL 2 HOUR)
                                            AND (NEW.Date + INTERVAL 2 HOUR))
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo);

        IF @TavoloLibero > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    ELSE
        SET @SalaLibera = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                            FROM Prenotazione P
                            WHERE P.Sala = NEW.Sala);
                            
        IF @SalaLibera > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala contiene tavoli prenotati.';
        END IF;
    END IF;
END$$

DELIMITER ;
