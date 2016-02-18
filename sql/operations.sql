DELIMITER $$

-- OPERAZIONE 1
CREATE FUNCTION StatoComanda(idComanda INT)
RETURNS ENUM('nuova', 'in preparazione', 'parziale', 'evasa', 'consegna')
NOT DETERMINISTIC READS SQL DATA
BEGIN
    -- bit 1 set: contiene piatti in attesa
    -- bit 2 set: contiene piatti in preparazione
    -- bit 3 set: contiene piatti in servizio
    DECLARE Flags INT;
    
    SET Flags = (SELECT IF(SUM(P.Stato = 'attesa') > 0, 1, 0)
                        + IF(SUM(P.Stato = 'in preparazione') > 0, 2, 0)
                        + IF(SUM(P.Stato = 'servizio') > 0, 4, 0)
                    FROM Piatto P
                    WHERE P.Comanda = idComanda);
                    
    CASE
        WHEN Flags = 4 THEN -- tutti i piatti in servizio
        BEGIN
            DECLARE TakeAway BOOL DEFAULT FALSE;
            SET TakeAway = (SELECT C.Account IS NOT NULL
                            FROM Comanda C
                            WHERE C.ID = idComanda);
            IF TakeAway THEN
                RETURN 'consegna';
            ELSE
                RETURN 'evasa';
            END IF;
        END;
        WHEN Flags > 4 THEN RETURN 'parziale'; -- alcuni piatti in servizio
        WHEN Flags > 1 THEN RETURN 'in preparazione'; -- alcuni piatti in prep.
        ELSE RETURN 'nuova'; -- tutti i piatti in attesa (Flags = 1)
    END CASE;    
END;$$


-- OPERAZIONE 2
CREATE TRIGGER assegna_pony
AFTER UPDATE
ON Piatto
FOR EACH ROW
BEGIN
    DECLARE NumeroPiatti INT;
    DECLARE SedeComanda VARCHAR(45);
    DECLARE PonyScelto INT;
    
    IF StatoComanda(NEW.Comanda) = 'consegna' THEN
        SET SedeComanda = (SELECT C.Account <> NULL, C.Sede
                            FROM Comanda C
                            WHERE C.ID = NEW.Comanda);
                                
        SET NumeroPiatti = (SELECT COUNT(*)
                            FROM Piatto P
                            WHERE P.Comanda = NEW.Comanda);
                            
        -- Se i piatti sono 5 o meno scelgo un pony su 2 ruote,
        -- altrimenti su 4 ruote
        SET PonyScelto = (SELECT P.ID
                            FROM Pony P
                            WHERE P.Sede = SedeComanda
                                AND P.Stato = 'libero'
                                AND Ruote = (NumeroPiatti > 5)
                            LIMIT 1);
                         
        -- Se non disponibile scelgo un pony qualsiasi
        IF PonyScelto IS NULL THEN
            SET PonyScelto = (SELECT P.ID
                                FROM Pony P
                                WHERE P.Sede = SedeComanda
                                    AND P.Stato = 'libero'
                                LIMIT 1);
        END IF;
        
        IF PonyScelto IS NULL THEN
            -- Nessun Pony disponibile
            SIGNAL SQLSTATE '01000' -- Warning
            SET MESSAGE_TEXT = 'Nessun Pony è stato assegnato in '
                                'quanto sono tutti occupati.';
        ELSE
            -- Assegna Pony
            INSERT INTO Consegna(Comanda, Sede, Pony, Arrivo, Ritorno)
            VALUES (NEW.Comanda, SedeComanda, PonyScelto, NULL, NULL);
        END IF;
    END IF;
END;$$

DELIMITER ;

-- OPERAZIONE 3
INSERT INTO Comanda(Sede, Sala, Tavolo) VALUES ('nome sede', 2, 10);


-- OPERAZIONE 4
INSERT INTO Piatto(Comanda, Ricetta) VALUES (1, 'nome ricetta');

DELIMITER $$

-- OPERAZIONE 5
CREATE FUNCTION IngredientiDisponibili(cSede VARCHAR(45), cRicetta VARCHAR(45),
                                                    cNovita BOOL, cData DATE)
RETURNS BOOL
NOT DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE ClientiPrenotazioni INT;
    DECLARE MediaSenzaPrenotazione INT;
    DECLARE StimaClienti INT;
    DECLARE StimaOrdini INT;
    DECLARE cIngrediente VARCHAR(45);
    DECLARE cDose INT;
    DECLARE cPrimario BOOL;
    DECLARE qtaDisponibile INT;
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE curIngredienti CURSOR FOR
        SELECT F.Ingrediente, SUM(F.Dose), SUM(F.Primario) > 0
        FROM Fase F
        WHERE F.Ricetta = cRicetta AND F.Ingrediente IS NOT NULL
        GROUP BY F.Ingrediente;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
    
    IF cData IS NULL THEN
        SET cData = CURRENT_DATE; -- Default
    END IF;
      
    SET ClientiPrenotazioni = (SELECT COALESCE(SUM(P.Numero), 0)
                                FROM Prenotazione P
                                WHERE P.Sede = cSede
                                    AND DATE(P.`Data`) = cData);
    
    -- AVG(SenzaPrenotazione) = media di clienti fuori prenotazione per tale
    -- mese. Questo viene diviso per il numero di giorni che il mese
    -- contiene (= media dei clienti fuori prenotazione in un giorno del mese).
    -- [La stima non è precisissima nel caso del mese di febbraio per via degli
    -- anni bisestili, ma non è importante: in fondo è pur sempre una stima]
    SET MediaSenzaPrenotazione = (SELECT
                                CEIL(COALESCE(AVG(CL.SenzaPrenotazione), 0)/
                                        DAY(LAST_DAY(cData)))
                                        AS Media
                                    FROM Clienti_Log CL
                                    WHERE CL.Sede = cSede
                                        AND CL.Mese = MONTH(cData)
                                        AND CL.Anno <> YEAR(cData)
                                );
                            
    SET StimaClienti = ClientiPrenotazioni + MediaSenzaPrenotazione;
    
    IF cNovita THEN
        -- 1/3 dei clienti ordina la ricetta
        SET StimaOrdini = (SELECT CEIL(StimaClienti * 0.33));
    ELSE
        -- Stima ordini viene calcolata come la media degli ordini della ricetta
        -- incrementata del 10% dei clienti stimati. L'incremento del 10% sul
        -- numero di clienti stimati serve come margine di sicurezza.
        SET StimaOrdini = (SELECT (COALESCE(CEIL(MV.TotOrdini / MV.Comparse), 0)
                                        + StimaClienti * 0.1) AS StimaOrdini
                            FROM MV_OrdiniRicetta MV
                            WHERE MV.Sede = cSede AND MV.Ricetta = cRicetta);
    END IF;
    
    IF StimaOrdini < 5 THEN
        SET StimaOrdini = 5;
    END IF;
    
    OPEN curIngredienti;
    
    loop_lbl: LOOP
        FETCH curIngredienti INTO cIngrediente, cDose, cPrimario;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        -- somma il peso delle confezioni di quell'ingrediente che non sono in
        -- ordine o che arrivano con almeno tre giorni di anticipo rispetto a
        -- cData e che non sono danneggiate (se l'ingrediente è primario in
        -- questa ricetta).
        SET qtaDisponibile = (SELECT SUM(C.Peso)
                                FROM Confezione C INNER JOIN Lotto L
                                            ON C.CodiceLotto = L.Codice
                                WHERE C.Sede = cSede
                                    AND L.Ingrediente = cIngrediente
                                    AND (C.Stato <> 'in ordine'
                                        OR (C.Stato = 'in ordine'
                                            AND C.DataArrivo >=
                                                cData - INTERVAL 3 DAY))
                                    AND (C.Aspetto OR (NOT cPrimario)));
        
        IF qtaDisponibile < (cDose * StimaOrdini) THEN
            RETURN FALSE;
        END IF;
    END LOOP loop_lbl;
    
    CLOSE curIngredienti;
    
    RETURN TRUE;
END;$$

DELIMITER ;

-- OPERAZIONE 6
INSERT INTO Prenotazione(Sede, `Data`, Numero, Account, Sala, Tavolo)
VALUES ('nome sede', 'yyyy-mm-dd hh:mm:ss', 5, 'username', 2, 7);


-- OPERAZIONE 7
SELECT @row_number := @row_number + 1 AS Posizione, D.*
FROM (SELECT @row_number := 0) AS N,
    (
        SELECT R.ID AS Recensione,
                SUM(COALESCE(V.Veridicita, 0)) AS VeridicitaTotale,
                SUM(COALESCE(V.Veridicita, 0)) AS AccuratezzaTotale,
                IF(V.Recensione IS NULL, 0, COUNT(*)) AS NumeroValutazioni
        FROM Recensione R LEFT OUTER JOIN Valutazione V ON R.ID = V.Recensione
        GROUP BY R.ID
    ) AS D
ORDER BY (D.VeridicitaTotale + D.AccuratezzaTotale)/D.NumeroValutazioni DESC;


-- OPERAZIONE 8
INSERT INTO Valutazione(Account, Recensione, Veridicita, Accuratezza, Testo)
VALUES ('username', 10, 4, 3, 'testo testo testo');
