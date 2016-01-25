DELIMITER $$

/******************************************************************************
 * nuova_confezione controlla che DataCarico, se presente, non sia precedente * 
 * a DataAcquisto. Inoltre controlla che sia specificati tutti gli attributi  *
 * necessari.                                                                 * 
 ******************************************************************************/ 
CREATE TRIGGER nuova_confezione
BEFORE INSERT
ON Confezione
FOR EACH ROW
BEGIN
    IF NEW.DataCarico IS NOT NULL THEN
        IF NEW.DataCarico < NEW.DataAcquisto THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DataCarico precedente a DataAcquisto.';
        END IF;
        IF NEW.Collocazione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Collocazione non può essere NULL.';
        END IF;
        IF NEW.Aspetto IS NULL THEN
            SET NEW.Aspetto = TRUE; -- Default: nessun danno
        END IF;
        IF NEW.Stato IS NULL THEN
            SET NEW.Stato = 'completa'; -- Default
        END IF;
    ELSEIF (NEW.Collocazione IS NOT NULL
            OR NEW.Aspetto IS NOT NULL
            OR NEW.Stato IS NOT NULL) THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'DataCarico, Collocazione, Aspetto e Stato '
                                   'devono essere tutti NULL o tutti non-NULL.';
    END IF;
END;$$

/******************************************************************************
 * aggiorna_confezione controlla che DataCarico, se presente, non sia         * 
 * precendente a DataAcquisto. Inoltre controlla che sia specificati tutti    *
 * gli attributi necessari.                                                   * 
 ******************************************************************************/ 
CREATE TRIGGER aggiorna_confezione
BEFORE UPDATE
ON Confezione
FOR EACH ROW
BEGIN
    IF NEW.DataCarico IS NOT NULL THEN
        IF NEW.DataCarico < NEW.DataAcquisto THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DataCarico precedente a DataAcquisto.';
        END IF;
        IF NEW.Collocazione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Collocazione non può essere NULL.';
        END IF;
        IF NEW.Aspetto IS NULL THEN
            SET NEW.Aspetto = TRUE; -- Default: nessun danno
        END IF;
        IF NEW.Stato IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Stato non può essere NULL.';
        END IF;
    ELSEIF (NEW.Collocazione IS NOT NULL
            OR NEW.Aspetto IS NOT NULL
            OR NEW.Stato IS NOT NULL) THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'DataCarico, Collocazione, Aspetto e Stato '
                                   'devono essere tutti NULL o tutti non-NULL.';
    END IF;
END;$$

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
    DECLARE MenuAttiviPeriodo INT;
    
    IF NEW.DataFine <= NEW.DataInizio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DataFine precedente a DataInizio.';
    END IF;

    SET MenuAttiviPeriodo = (SELECT COUNT(*)
                                FROM Menu M
                                WHERE M.Sede = NEW.Sede
                                    AND M.DataFine >= NEW.DataInizio
                                    AND M.DataInizio <= NEW.DataFine);
            
    IF MenuAttiviPeriodo > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un menu è già attivo in questo periodo.';
    END IF;
END;$$

CREATE TRIGGER nuova_fase
BEFORE INSERT
ON Fase
FOR EACH ROW
BEGIN
    IF NEW.Ingrediente IS NOT NULL THEN
        SET NEW.Durata = NULL;
        SET NEW.Testo = NULL;
        IF NEW.Strumento IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una fase deve impiegare o uno strumento o un '
                                'ingrediente. Non entrambi.';
        END IF;
        IF NEW.Dose IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Dose deve essere specificato.';
        END IF;
        IF NEW.Primario IS NULL THEN
            SET NEW.Primario = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Dose = NULL;
        SET NEW.Primario = NULL;
        IF NEW.Strumento IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una fase deve specificare o un ingrediente o '
                                'uno strumento.';
        ELSE
            IF NEW.Durata = NULL THEN
                SET NEW.Durata = '00:00:00'; -- Default
            END IF;
            IF NEW.Testo = NULL THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'L\'attributo Testo deve essere '
                                    'specificato.';
            END IF;
        END IF;
    END IF;
END;$$

CREATE TRIGGER aggiorna_fase
BEFORE UPDATE
ON Fase
FOR EACH ROW
BEGIN
    IF NEW.Ingrediente IS NOT NULL THEN
        SET NEW.Durata = NULL;
        SET NEW.Testo = NULL;
        IF NEW.Strumento IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una fase deve impiegare o uno strumento o un '
                                'ingrediente. Non entrambi.';
        END IF;
        IF NEW.Dose IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Dose deve essere specificato.';
        END IF;
        IF NEW.Primario IS NULL THEN
            SET NEW.Primario = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Dose = NULL;
        SET NEW.Primario = NULL;
        IF NEW.Strumento IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una fase deve specificare o un ingrediente o '
                                'uno strumento.';
        ELSE
            IF NEW.Durata = NULL THEN
                SET NEW.Durata = '00:00:00'; -- Default
            END IF;
            IF NEW.Testo = NULL THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'L\'attributo Testo deve essere '
                                    'specificato.';
            END IF;
        END IF;
    END IF;
END;$$

CREATE TRIGGER nuova_sequenza_fasi
BEFORE INSERT
ON SequenzaFasi
FOR EACH ROW
BEGIN
    DECLARE StessaRicetta INT;
    SET StessaRicetta = (SELECT COUNT(*)
                            FROM (SELECT F1.ID, F1.Ricetta
                                    FROM Fase F1
                                    WHERE F1.ID = NEW.Fase) AS Fase1
                            INNER JOIN
                                (SELECT F2.ID, F2.Ricetta
                                    FROM Fase F2
                                    WHERE F2.ID = NEW.FasePrecedente) AS Fase2
                            ON Fase1.Ricetta = Fase2.Ricetta);
    
    IF StessaRicetta = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le due fasi non appartengono alla stessa ricetta.';
    END IF;
END;$$

CREATE TRIGGER aggiorna_sequenza_fasi
BEFORE UPDATE
ON SequenzaFasi
FOR EACH ROW
BEGIN
    DECLARE StessaRicetta INT;
    SET StessaRicetta = (SELECT COUNT(*)
                            FROM (SELECT F1.ID, F1.Ricetta
                                    FROM Fase F1
                                    WHERE F1.ID = NEW.Fase) AS Fase1
                            INNER JOIN
                                (SELECT F2.ID, F2.Ricetta
                                    FROM Fase F2
                                    WHERE F2.ID = NEW.FasePrecedente) AS Fase2
                            ON Fase1.Ricetta = Fase2.Ricetta);
    
    IF StessaRicetta = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le due fasi non appartengono alla stessa ricetta.';
    END IF;
END;$$

CREATE TRIGGER nuova_comanda
BEFORE INSERT
ON Comanda
FOR EACH ROW
BEGIN
    IF (NEW.Account IS NOT NULL
            AND (NEW.Tavolo IS NOT NULL OR NEW.Sala IS NOT NULL))
        OR (NEW.Account IS NULL AND NEW.Tavolo IS NULL
                                AND NEW.Sala IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una comanda deve essere o da tavolo o take-away. '
                            'Non entrambe.';
    END IF;
END;$$

CREATE TRIGGER aggiorna_comanda
BEFORE UPDATE
ON Comanda
FOR EACH ROW
BEGIN
    IF (NEW.Account IS NOT NULL
            AND (NEW.Tavolo IS NOT NULL OR NEW.Sala IS NOT NULL))
        OR (NEW.Account IS NULL
            AND (NEW.Account IS NULL AND NEW.Tavolo IS NULL
                                        AND NEW.Sala IS NULL)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una comanda deve essere o da tavolo o take-away. '
                            'Non entrambe.';
    END IF;
END;$$

CREATE TRIGGER nuova_variazione
BEFORE INSERT
ON Variazione
FOR EACH ROW
BEGIN
    IF (NEW.Nome IS NOT NULL AND NEW.Account IS NOT NULL)
        OR (NEW.Nome IS NULL AND NEW.Account IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una variazione deve essere una variazione '
                            'dagli chef (con nome) o un suggerimento inviato '
                            'da un account utente (senza nome).';
    END IF;
END;$$

CREATE TRIGGER aggiorna_variazione
BEFORE UPDATE
ON Variazione
FOR EACH ROW
BEGIN
    IF (NEW.Nome IS NOT NULL AND NEW.Account IS NOT NULL)
        OR (NEW.Nome IS NULL AND NEW.Account IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una variazione deve essere una variazione '
                            'dagli chef (con nome) o un suggerimento inviato '
                            'da un account utente (senza nome).';
    END IF;
END;$$

CREATE TRIGGER nuova_modificafase
BEFORE INSERT
ON ModificaFase
FOR EACH ROW
BEGIN
    DECLARE RicettaFaseNuova VARCHAR(45);
    DECLARE RicettaFaseVecchia VARCHAR(45);
    DECLARE RicettaVariazione VARCHAR(45);
    
    IF NEW.FaseNuova IS NULL AND NEW.FaseVecchia IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FaseNuova o FaseVecchia devono essere specificati.';
    END IF;
    
    SET RicettaVariazione = (SELECT V.Ricetta FROM Variazione V
                                WHERE V.ID = NEW.Variazione);
    
    IF NEW.FaseNuova IS NOT NULL THEN
        SET RicettaFaseNuova = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseNuova);
        
        IF RicettaFaseNuova <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseNuova deve corrispondere '
                                'alla ricetta della variazione.';
        END IF;
    END IF;
    
    IF NEW.FaseVecchia IS NOT NULL THEN
        SET RicettaFaseVecchia = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseVecchia);
                                    
        IF RicettaFaseVecchia <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia deve corrispondere '
                                'alla ricetta della variazione.';
        ELSEIF RicettaFaseNuova IS NOT NULL
            AND RicettaFaseNuova <> RicettaFaseVecchia THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia e quella di '
                                'FaseNuova devono corrispondere.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER aggiorna_modificafase
BEFORE UPDATE
ON ModificaFase
FOR EACH ROW
BEGIN
    DECLARE RicettaFaseNuova VARCHAR(45);
    DECLARE RicettaFaseVecchia VARCHAR(45);
    DECLARE RicettaVariazione VARCHAR(45);
    
    IF NEW.FaseNuova IS NULL AND NEW.FaseVecchia IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FaseNuova o FaseVecchia devono essere specificati.';
    END IF;
    
    SET RicettaVariazione = (SELECT V.Ricetta FROM Variazione V
                                WHERE V.ID = NEW.Variazione);
    
    IF NEW.FaseNuova IS NOT NULL THEN
        SET RicettaFaseNuova = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseNuova);
        
        IF RicettaFaseNuova <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseNuova deve corrispondere '
                                'alla ricetta della variazione.';
        END IF;
    END IF;
    
    IF NEW.FaseVecchia IS NOT NULL THEN
        SET RicettaFaseVecchia = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseVecchia);
                                    
        IF RicettaFaseVecchia <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia deve corrispondere '
                                'alla ricetta della variazione.';
        ELSEIF RicettaFaseNuova IS NOT NULL
            AND RicettaFaseNuova <> RicettaFaseVecchia THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia e quella di '
                                'FaseNuova devono corrispondere.';
        END IF;
    END IF;
END;$$

/******************************************************************************
 * nuova_modifica controlla che, per il piatto sul quale si sta applicando la *
 * variazione, non siano già state scelte 3 variazioni. Inoltre controlla che *
 * la ricetta del piatto e quella della variazione corrispondano.             *
 * Business Rule: (BR12)                                                      *
 ******************************************************************************/
CREATE TRIGGER nuova_modifica
BEFORE INSERT
ON Modifica
FOR EACH ROW
BEGIN
    DECLARE NumVariazioni INT;
    DECLARE StessaRicetta INT;
    
    SET NumVariazioni = (SELECT COUNT(*)
                            FROM Modifica M
                            WHERE M.Piatto = NEW.Piatto);
    
    IF NumVariazioni >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ci sono già 3 variazioni su questo piatto.';
    END IF;
    
    SET StessaRicetta = (SELECT COUNT(*)
                            FROM (SELECT P.ID, P.Ricetta
                                    FROM Piatto P
                                    WHERE P.ID = NEW.Piatto) AS Pi
                            INNER JOIN
                                (SELECT V.ID, V.Ricetta
                                    FROM Variazione V
                                    WHERE V.ID = NEW.Variazione) AS Va
                            ON Pi.Ricetta = Va.Ricetta);
    
    IF StessaRicetta = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La variazione selezionata non è applicabile al '
                            'piatto scelto.';
    END IF;
END;$$

CREATE TRIGGER aggiorna_modifica
BEFORE UPDATE
ON Modifica
FOR EACH ROW
BEGIN
    DECLARE StessaRicetta INT;
    
    SET StessaRicetta = (SELECT COUNT(*)
                            FROM (SELECT P.ID, P.Ricetta
                                    FROM Piatto P
                                    WHERE P.ID = NEW.Piatto) AS Pi
                            INNER JOIN
                                (SELECT V.ID, V.Ricetta
                                    FROM Variazione V
                                    WHERE V.ID = NEW.Variazione) AS Va
                            ON Pi.Ricetta = Va.Ricetta);
    
    IF StessaRicetta = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La variazione selezionata non è applicabile al '
                            'piatto scelto.';
    END IF;
END;$$

/******************************************************************************
 * aggiorna_consegna si assicura che l'arrivo registrato sia sempre successivo*
 * alla partenza e che il ritorno sia sempre successivo all'arrivo.           *
 ******************************************************************************/
CREATE TRIGGER aggiorna_consegna
BEFORE UPDATE
ON Consegna
FOR EACH ROW
BEGIN
    IF NEW.Arrivo IS NOT NULL AND NEW.Arrivo < NEW.Partenza THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Arrivo precedente a partenza.';
    END IF;
    
    IF NEW.Ritorno IS NOT NULL AND NEW.Ritorno < NEW.Arrivo THEN
        IF NEW.Arrivo IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Se Ritorno viene specificato anche Arrivo deve '
                                'essere specificato.';
        ELSEIF NEW.Ritorno < NEW.Arrivo THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ritorno precedente a arrivo.';
        END IF;
    END IF;
END;$$

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
    DECLARE PrenotazioniAbilitate BOOL;
    DECLARE TavoloAssegnato INT;
    DECLARE AllestimentiSala INT;
    DECLARE PostiTavolo INT;
    DECLARE TavoloLibero INT;
    DECLARE SalaLibera INT;
    
    IF NEW.Tavolo IS NOT NULL THEN
        SET PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
    END IF;
    
    IF NEW.Account IS NOT NULL THEN
        SET PrenotazioniAbilitate = (SELECT A.PuoPrenotare
                                        FROM Account A
                                        WHERE A.Username = NEW.Account);
                                        
        IF PrenotazioniAbilitate = FALSE THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prenotazioni disabilitate per l\'account.';
        END IF;
        
        SET NEW.Telefono = NULL;
        IF NEW.Tavolo IS NOT NULL THEN
            SET NEW.Nome = NULL;
            SET NEW.Descrizione = NULL;
            SET NEW.Approvato = NULL;
            
            IF PostiTavolo > NEW.Numero + 3 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                                    'di posti.';
            END IF;
        ELSEIF NEW.Nome IS NULL THEN
            SET NEW.Descrizione = NULL;
            SET NEW.Approvato = NULL;
            
            -- Assegna Tavolo (riportato solo nello script finale nel Cap. 9)
            
        ELSEIF NEW.Descrizione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Descrizione deve essere specificato per gli '
                                'allestimenti.';
        ELSEIF NEW.Approvato IS NULL THEN
            SET NEW.Approvato = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Descrizione = NULL;
        SET NEW.Approvato = NULL;
        IF NEW.Nome IS NULL OR NEW.Telefono IS NULL OR NEW.Tavolo IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome, Telefono e Tavolo devono essere '
                                'specificati per le prenotazioni telefoniche.';
        END IF;
    END IF;    

-- NOTA: L'uso di espressioni booleane all'interno di SUM() è possibile solo in
--       MySQL (che converte l'espressione booleana in int). In altri DBMS si
--       può utilizzare COUNT() e spostare l'espressione booleana nel WHERE.
    SET AllestimentiSala = (SELECT SUM(DATE(P.Data) = DATE(NEW.Data))
                                FROM Prenotazione P
                                WHERE P.Sala = NEW.Sala
                                    AND P.Sede = NEW.Sede
                                    AND P.Tavolo = NULL);
                        
    IF AllestimentiSala > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala scelta è già prenotata per un '
                            'allestimento.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
    
        IF PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                            'di posti.';
        END IF;

        SET TavoloLibero = (SELECT SUM(P.Data >
                                            (NEW.Data - INTERVAL 2 HOUR)
                                            AND P.Data <
                                                (NEW.Data + INTERVAL 2 HOUR))
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo
                                AND P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);

        IF TavoloLibero > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    ELSE
        SET SalaLibera = (SELECT SUM(DATE(P.Data) = DATE(NEW.Data))
                            FROM Prenotazione P
                            WHERE P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);
                            
        IF SalaLibera > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala contiene tavoli già prenotati.';
        END IF;
    END IF;
END;$$

/******************************************************************************
 * aggiorna_prenotazione controlla che la rettifica della prenotazione venga  *
 * fatta al max. 48 ore prima della data della prenotazione. Inoltre controlla*
 * che la nuova prenotazione sia valida.                                      *
 * Business Rule: (BR16) e (BR17)                                             *
 ******************************************************************************/
CREATE TRIGGER aggiorna_prenotazione
BEFORE UPDATE
ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE TavoloAssegnato INT;
    DECLARE AllestimentiSala INT;
    DECLARE PostiTavolo INT;
    DECLARE TavoloLibero INT;
    DECLARE SalaLibera INT;
    
   	IF CURRENT_DATETIME < (OLD.Data - INTERVAL 2 DAY) THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile modificare la prenotazione.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        SET PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
    END IF;
    
    IF NEW.Account IS NOT NULL THEN
        SET NEW.Telefono = NULL;
        IF NEW.Tavolo IS NOT NULL THEN
            SET NEW.Nome = NULL;
            SET NEW.Descrizione = NULL;
            SET NEW.Approvato = NULL;
            
            IF PostiTavolo > NEW.Numero + 3 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                                    'di posti.';
            END IF;
        ELSEIF NEW.Nome IS NULL OR NEW.Descrizione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome e Descrizione devono essere specificati '
                                'per gli allestimenti.';
        ELSEIF NEW.Approvato IS NULL THEN
            SET NEW.Approvato = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Descrizione = NULL;
        SET NEW.Approvato = NULL;
        IF NEW.Nome IS NULL OR NEW.Telefono IS NULL OR NEW.Tavolo IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome, Telefono e Tavolo devono essere '
                                'specificati per le prenotazioni telefoniche.';
        END IF;
    END IF;    

    SET AllestimentiSala = (SELECT SUM(DATE(P.Data) = DATE(NEW.Data))
                                FROM Prenotazione P
                                WHERE P.Sala = NEW.Sala
                                    AND P.Sede = NEW.Sede
                                    AND P.Tavolo = NULL);
                        
    IF AllestimentiSala > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala scelta è già prenotata per un '
                            'allestimento.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        IF PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                            'di posti.';
        END IF;

        SET TavoloLibero = (SELECT SUM(P.Data >
                                            (NEW.Data - INTERVAL 2 HOUR)
                                            AND P.Data <
                                                (NEW.Data + INTERVAL 2 HOUR))
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo
                                AND P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);

        IF TavoloLibero > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    ELSE
        SET SalaLibera = (SELECT SUM(DATE(P.Data) = DATE(NEW.Data))
                            FROM Prenotazione P
                            WHERE P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);
                            
        IF SalaLibera > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala contiene tavoli già prenotati.';
        END IF;
    END IF;
END;$$

/******************************************************************************
 * elimina_prenotazione controlla che l'annullamento della prenotazione       *
 * venga fatta al max. 72 ore prima della data della prenotazione.            *
 * Business Rule: (BR18)                                                      *
 ******************************************************************************/
CREATE TRIGGER elimina_prenotazione
BEFORE DELETE
ON Prenotazione
FOR EACH ROW
BEGIN
   	IF CURRENT_DATETIME < (OLD.Data - INTERVAL 3 DAY) THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile annullare la prenotazione.';
    END IF;
END;$$

CREATE TRIGGER nuovo_gradimento
BEFORE INSERT
ON Gradimento
FOR EACH ROW
BEGIN
    IF (NEW.Proposta IS NOT NULL AND NEW.Suggerimento IS NOT NULL)
        OR (NEW.Proposta IS NULL AND NEW.Suggerimento IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un gradimento deve riferirsi a una proposta o a '
                            'un suggerimento. Non ad entrambi.';
    END IF;
    
    IF NEW.Punteggio < 1 OR NEW.Punteggio > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punteggio deve essere compreso tra 1 e 5';
    END IF;
END;$$

CREATE TRIGGER nuova_recensione
BEFORE INSERT
ON Recensione
FOR EACH ROW
BEGIN
    IF NEW.Giudizio < 1 OR NEW.Giudizio > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Giudizio deve essere compreso tra 1 e 5';
    END IF;
END;$$

CREATE TRIGGER nuova_valutazione
BEFORE INSERT
ON Valutazione
FOR EACH ROW
BEGIN
    IF NEW.Veridicita < 1 OR NEW.Veridicita > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Veridicita deve essere compreso tra 1 e 5';
    END IF;
    IF NEW.Accuratezza < 1 OR NEW.Accuratezza > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Accuratezza deve essere compreso tra 1 e 5';
    END IF;
END;$$

CREATE TRIGGER nuova_risposta
BEFORE INSERT
ON Risposta
FOR EACH ROW
BEGIN
    IF NEW.Efficienza < 1 OR NEW.Efficienza > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Efficienza deve essere compreso tra 1 e 5';
    END IF;
END;$$

DELIMITER ;
