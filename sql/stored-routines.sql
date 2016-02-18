CREATE PROCEDURE RegistraClienti(IN inSede VARCHAR(45), IN numero INT)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    INSERT INTO Clienti_Log(Sede, Anno, Mese, SenzaPrenotazione) VALUES
        (inSede, YEAR(CURRENT_DATE), MONTH(CURRENT_DATE), numero)
        ON DUPLICATE KEY
            UPDATE SenzaPrenotazione = SenzaPrenotazione + numero;
END;$$

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
        SET cData = CURRENT_DATE;
    END IF;
      
    SET ClientiPrenotazioni = (SELECT COALESCE(CP.Numero, 0)
                                FROM MV_ClientiPrenotazione CP
                                WHERE CP.Sede = cSede
                                    AND CP.`Data` = cData);
    
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
        SET StimaOrdini = (SELECT CEIL(StimaClienti * 0.33));
    ELSE
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
