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

    SET @StatoComanda = (SELECT C.Stato AS StatoComanda
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
    IF NEW.Account IS NOT NULL THEN
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
    
    IF NEW.Tavolo IS NOT NULL THEN
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
    
    IF NEW.Sala IS NOT NULL THEN
        SET @AllestimentiSala = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                                    FROM Prenotazione P
                                    WHERE P.Sala = NEW.Sala
                                        AND P.Sede = NEW.Sede
                                        AND P.Tavolo = NULL);
                            
        IF @AllestimentiSala > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala scelta è prenotata per allestimento.';
        END IF;
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        SET @PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
        
        IF @PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo non ha un numero adeguato di posti.';
        END IF;

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
    END IF;
END$$

/******************************************************************************
 * annulla_prenotazione controlla che l'annullamento della prenotazione       *
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

/******************************************************************************
* limite_valori_x controlla che i valori immessi per gli attributi riguardanti* 
* un voto non siano inferiori di 1 o maggiori di 5                            *
 ******************************************************************************/
CREATE TRIGGER limite_valori_punteggio
BEFORE INSERT
ON Gradimento
FOR EACH ROW
BEGIN
    IF NEW.Punteggio < 1 OR NEW.Punteggio > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punteggio deve essere compreso tra 1 e 5';
    END IF;
END$$

CREATE TRIGGER limite_valori_giudizio
BEFORE INSERT
ON Recensione
FOR EACH ROW
BEGIN
    IF NEW.Giudizio < 1 OR NEW.Giudizio > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Giudizio deve essere compreso tra 1 e 5';
    END IF;
END$$

CREATE TRIGGER limite_valori_veridicità_accuratezza
BEFORE INSERT
ON Valutazione
FOR EACH ROW
BEGIN
    IF NEW.Veridicità < 1 OR NEW.Veridicità > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Veridicita deve essere compreso tra 1 e 5';
    END IF;
    IF NEW.Accuratezza < 1 OR NEW.Accuratezza > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Accuratezza deve essere compreso tra 1 e 5';
    END IF;
END$$

CREATE TRIGGER limite_valori_efficienza
BEFORE INSERT
ON Risposta
FOR EACH ROW
BEGIN
    IF NEW.Efficienza < 1 OR NEW.Efficienza > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Efficienza deve essere compreso tra 1 e 5';
    END IF;
END$$

/******************************************************************************
 * aggiorna_consegna si assicura che l'arrivo registrato sia sempre successivo*
 * alla partenza e che il ritorno sia sempre successivo all'arrivo.           *
 ******************************************************************************/
CREATE TRIGGER aggiorna_consegna
BEFORE UPDATE
ON Consegna
FOR EACH ROW
BEGIN
    IF NEW.Arrivo IS NOT NULL AND NEW.Arrivo < OLD.Partenza THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Arrivo precedente a partenza.';
    END IF;
    
    IF NEW.Ritorno IS NOT NULL AND NEW.Ritorno < OLD.Arrivo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ritorno precedente a arrivo.';
    END IF;
END$$

/******************************************************************************
 * gestione_menu controlla che con l'inserimento di un nuovo menu, datafine   * 
 * sia successiva a data inizio.                                              *
 ******************************************************************************/
CREATE TRIGGER gestione_menu
BEFORE INSERT
ON Menu
FOR EACH ROW
BEGIN
    IF NEW.DataFine <= NEW.DataInizio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DataFine precedente a DataInizio.';
    END IF;
    
END$$
 
/******************************************************************************
 *gestione_confezioni controlla che DataCarico, se presente, non sia          * 
 *precedente a DataAcquisto.                                                  * 
******************************************************************************/ 
CREATE TRIGGER gestione_confezioni
BEFORE INSERT
ON Confezioni
FOR EACH ROW
BEGIN
    IF NEW.DataCarico IS NOT NULL AND NEW.DataCarico < NEW.DataAcquisto THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DataCarico precedente a DataAcquisto.';
    END IF;
END$$

/******************************************************************************
 * registrazione_account controlla che i valori relativi ad account abbiamo le*
 * giuste lunghezze.                                                          *
 ******************************************************************************/
CREATE TRIGGER  registrazione_account 
BEFORE INSERT
ON Account
FOR EACH ROW
BEGIN
    IF NEW.CAP < 10000 OR NEW.CAP > 99999 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CAP deve essere di 5 cifre.';
    END IF;
END$$   

 DELIMITER ;
