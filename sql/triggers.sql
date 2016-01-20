DELIMITER $$

/******************************************************************************
 * nuovo_menu contolla che il periodo di applicazione del nuovo menu inserito *
 * non sia in conflitto con il periodo di applicazione di un altro menu nella *
 * stessa sede (ogni sede applica un solo menu alla volta). Inoltre controlla *
 * che DataFine sia successiva a DataInizio.                                  *
 * Business Rule: (BR05)                                                      *
 ******************************************************************************/
CREATE TRIGGER nuovo_menu
BEFORE INSERT
ON Menu
FOR EACH ROW
BEGIN
    IF NEW.DataFine <= NEW.DataInizio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DataFine precedente a DataInizio.';
    END IF;

    DECLARE MenuAttiviPeriodo INT;
    SET MenuAttiviPeriodo = (SELECT COUNT(*)
        FROM Menu M
        WHERE M.Sede = NEW.Sede
            AND M.DataFine >= NEW.DataInizio
            AND M.DataInizio <= NEW.DataFine);
            
    IF MenuAttiviPeriodo > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un menu è già attivo in questo periodo.';
    END IF;
END$$

/******************************************************************************
 * nuova_prenotazione controlla: se l'account (in caso di prenotazione online)*
 * è abilitato a prenotare; se il tavolo da prenotare è libero; se la sala e  *
 * tutti i tavoli che contiene sono liberi per un allestimento.               *
 * Business Rule: (BR16) e (BR19)                                             *
 ******************************************************************************/
CREATE TRIGGER nuova_prenotazione
BEFORE INSERT
ON Prenotazione
FOR EACH ROW
BEGIN
    IF NEW.Account IS NOT NULL THEN
        DECLARE PrenotazioniAbilitate BOOL;
        SET PrenotazioniAbilitate = (SELECT A.PuoPrenotare
                                        FROM Account A
                                        WHERE A.Username = NEW.Account);
                                        
        IF PrenotazioniAbilitate = false THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prenotazioni disabilitate per l\'account.';
        END IF;
    END IF;    
        
    DECLARE AllestimentiSala INT;
-- NOTA: L'uso di espressioni booleane all'interno di SUM() è possibile solo in
--       MySQL (che converte l'espressione booleana in int). In altri DBMS si
--       può utilizzare COUNT() e spostare l'espressione booleana nel WHERE.
    SET AllestimentiSala = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                                FROM Prenotazione P
                                WHERE P.Sala = NEW.Sala
                                    AND P.Sede = NEW.Sede
                                    AND P.Tavolo = NULL);
                        
    IF AllestimentiSala > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala scelta è già prenotata per allestimento.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        DECLARE PostiTavolo INT;
        SET PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
        
        IF PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo non ha un numero adeguato di posti.';
        END IF;

        DECLARE TavoloLibero INT;
        SET TavoloLibero = (SELECT SUM(P.Date 
                                        BETWEEN (NEW.Date - INTERVAL 2 HOUR)
                                            AND (NEW.Date + INTERVAL 2 HOUR))
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo
                                AND P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);

        IF TavoloLibero > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    ELSE
        DECLARE SalaLibera INT;
        SET SalaLibera = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                            FROM Prenotazione P
                            WHERE P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);
                            
        IF SalaLibera > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala contiene tavoli prenotati.';
        END IF;
    END IF;
END$$

/******************************************************************************
 * rettifica_prenotazione controlla che la rettifica della prenotazione venga *
 * fatta al max. 48 ore prima della data della prenotazione. Inoltre controlla*
 * che la nuova prenotazione sia valida.                                      *
 * Business Rule: (BR16) e (BR17)                                             *
 ******************************************************************************/
CREATE TRIGGER rettifica_prenotazione
BEFORE UPDATE
ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE PuoRettificare BOOL;
    SET PuoRettificare = (SELECT (NOW() < OLD.Data - INTERVAL 2 DAY)
                          FROM Prenotazione P
                          WHERE P.ID = OLD.ID); -- ??
                          
   	IF PuoRettificare = false THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile modificare la prenotazione.';
    END IF;
    
    IF NEW.Sala IS NOT NULL THEN
        DECLARE AllestimentiSala INT;
        SET AllestimentiSala = (SELECT SUM(DATE(P.Date) = DATE(NEW.Date))
                                    FROM Prenotazione P
                                    WHERE P.Sala = NEW.Sala
                                        AND P.Sede = NEW.Sede
                                        AND P.Tavolo = NULL);
                            
        IF AllestimentiSala > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala scelta è prenotata per allestimento.';
        END IF;
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        DECLARE PostiTavolo INT;
        SET PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
        
        IF PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo non ha un numero adeguato di posti.';
        END IF;

        DECLARE TavoloLibero INT;
        SET TavoloLibero = (SELECT SUM(P.Date 
                                        BETWEEN (NEW.Date - INTERVAL 2 HOUR)
                                            AND (NEW.Date + INTERVAL 2 HOUR))
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo
                                AND P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);

        IF TavoloLibero > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    END IF;
END$$

/******************************************************************************
 * annulla_prenotazione controlla che l'annullamento della prenotazione       *
 * venga fatta al max. 72 ore prima della data della prenotazione.            *
 * Business Rule: (BR18)                                                      *
 ******************************************************************************/
CREATE TRIGGER annulla_prenotazione
BEFORE DELETE
ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE PuoAnnullare BOOL;
    SET PuoAnnullare = (SELECT (NOW() < OLD.Data - INTERVAL 3 DAY)
                          FROM Prenotazione P
                          WHERE P.ID = OLD.ID); -- ??
                          
   	IF PuoAnnullare = false THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile annullare la prenotazione.';
    END IF;
END$$

/******************************************************************************
 * limite_valori_x controlla che i valori immessi per gli attributi           * 
 * riguardanti un voto non siano inferiori di 1 o maggiori di 5.              *
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
 * massimo_variazioni_piatto controlla che, per il piatto sul quale si sta    *
 * applicando la variazione, non siano già state scelte 3 variazioni.         *
 * Business Rule: (BR12)                                                      *
 ******************************************************************************/
CREATE TRIGGER massimo_variazioni_piatto
BEFORE INSERT
ON Modifica
FOR EACH ROW
BEGIN
    DECLARE NumVariazioni INT;
    SET NumVariazioni = (SELECT COUNT(*)
                            FROM Modifica M
                            WHERE M.Piatto = NEW.Piatto);
    
    IF NumVariazioni >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ci sono già 3 variazioni su questo piatto.';
    END IF;
END$$

DELIMETER ;
