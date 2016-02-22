CREATE EVENT aggiorna_MV_OrdiniRicetta_MenuCorrente
ON SCHEDULE
EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 2 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE cSede VARCHAR(45);
    DECLARE cRicetta VARCHAR(45);
    DECLARE cOrdini INT;
    DECLARE cNovita BOOL;
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE curPiatto CURSOR FOR
        SELECT C.Sede, P.Ricetta, COUNT(*) AS Ordini
        FROM Piatto P INNER JOIN Comanda C ON P.Comanda = C.ID
        WHERE DATE(C.`Timestamp`) = (CURRENT_DATE - INTERVAL 1 DAY)
        GROUP BY C.Sede, P.Ricetta;
    DECLARE curElenco CURSOR FOR
        SELECT M.Sede, E.Ricetta, E.Novita
        FROM Elenco E INNER JOIN Menu M ON E.Menu = M.ID
        WHERE CURRENT_DATE
                    BETWEEN M.DataInizio AND M.DataFine;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
    
    OPEN curPiatto;
    
    loop_lbl: LOOP
        FETCH curPiatto INTO cSede, cRicetta, cOrdini;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        INSERT INTO MV_OrdiniRicetta(Sede, Ricetta, TotOrdini) VALUES
            (cSede, cRicetta, cOrdini)
            ON DUPLICATE KEY
                UPDATE Comparse = Comparse + 1, TotOrdini = TotOrdini + cOrdini;
    END LOOP loop_lbl;
    
    CLOSE curPiatto;
    
    
    
    SET Finito = FALSE;
    TRUNCATE TABLE MV_MenuCorrente; -- full refresh
    OPEN curElenco;
    
    loop2_lbl: LOOP
        FETCH curElenco INTO cSede, cRicetta, cNovita;
        IF Finito THEN
            LEAVE loop2_lbl;
        END IF;
        
        IF IngredientiDisponibili(cSede, cRicetta, cNovita, NULL) THEN
            INSERT INTO MV_MenuCorrente(Sede, Ricetta, Novita) VALUES
                (cSede, cRicetta, cNovita);
        END IF;
    END LOOP loop2_lbl;
    
    CLOSE curElenco;
END;$$

CREATE EVENT aggiorna_elenco_novita
ON SCHEDULE
EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL '1:30' HOUR_MINUTE
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE cSede VARCHAR(45);
    DECLARE cRicetta VARCHAR(45);
    DECLARE RimuoviNovita BOOL;
    DECLARE curMenu CURSOR FOR
        SELECT MC.Sede, MC.Ricetta
        FROM MV_MenuCorrente MC
        WHERE MC.Novita = TRUE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
    
    OPEN curMenu;
    
    loop_lbl: LOOP
        FETCH curMenu INTO cSede, cRicetta;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        SET RimuoviNovita = (SELECT (COUNT(*) > 4) AS RimuoviNovita
                                FROM MV_OrdiniRicetta MVOR
                                WHERE MVOR.Ricetta = cRicetta
                                    AND MVOR.Sede = cSede);
        IF RimuoviNovita THEN
            UPDATE Elenco E INNER JOIN Menu M ON E.Menu = M.ID
            SET E.Novita = FALSE
            WHERE M.Sede = cSede AND E.Ricetta = cRicetta;
        END IF;
    END LOOP loop_lbl;
    
    CLOSE curMenu;
END;$$

CREATE EVENT Analytics_Scheduler
ON SCHEDULE
EVERY 1 MONTH
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 4 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    CALL AnalizzaRecensioni();
    CALL AnalizzaVendite(CURRENT_TIMESTAMP - INTERVAL 1 MONTH, NULL);
    CALL AnalizzaSuggerimenti();
    CALL AnalizzaProposte();
END;$$

CREATE EVENT Elenco_Ordini
ON SCHEDULE
EVERY 1 WEEK
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 5 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE ClientiPrenotazioni INT;
    DECLARE MediaSenzaPrenotazione INT;
    DECLARE StimaClienti INT;
    DECLARE StimaOrdini INT;
    DECLARE NomeSede VARCHAR(45);
    DECLARE NomeRicetta VARCHAR(45);
    DECLARE RicettaNovita BOOL;
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE curRicetta CURSOR FOR
        SELECT M.Sede, E.Ricetta, E.Novita
        FROM Menu M INNER JOIN Elenco E ON M.ID = E.Menu
        WHERE M.DataInizio <= CURRENT_DATE
            AND M.DataFine >= CURRENT_DATE + INTERVAL 6 DAY;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;

    TRUNCATE TABLE Report_Ordinativi;
    
    OPEN curRicetta;
    
    loop_lbl: LOOP
        FETCH curRicetta INTO NomeSede, NomeRicetta, RicettaNovita;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        SET ClientiPrenotazioni = (SELECT COALESCE(CP.Numero, 0)
                                    FROM MV_ClientiPrenotazione CP
                                    WHERE CP.Sede = NomeSede
                                        AND CP.`Data` BETWEEN CURRENT_DATE
                                            AND CURRENT_DATE + INTERVAL 6 DAY);
        
        SET MediaSenzaPrenotazione = (
            SELECT CEIL(COALESCE(AVG(CL.SenzaPrenotazione), 0)/4) AS Media
            FROM Clienti_Log CL
            WHERE CL.Sede = NomeSede
                AND CL.Mese = MONTH(CURRENT_DATE)
                AND CL.Anno <> YEAR(CURRENT_DATE)
            );
            
        SET StimaClienti = ClientiPrenotazioni + MediaSenzaPrenotazione;
    
        IF RicettaNovita THEN
            SET StimaOrdini = (SELECT CEIL(StimaClienti * 0.33));
        ELSE
            SET StimaOrdini = (
                SELECT (COALESCE(CEIL(MV.TotOrdini / MV.Comparse), 0)
                            + StimaClienti * 0.1) AS StimaOrdini
                FROM MV_OrdiniRicetta MV
                WHERE MV.Sede = NomeSede AND MV.Ricetta = NomeRicetta
                );
        END IF;
        
        IF StimaOrdini < 5 THEN
            SET StimaOrdini = 5;
        END IF;
                
        INSERT INTO Report_Ordinativi(Sede, Ingrediente, Quantita)
        SELECT NomeSede, F.Ingrediente, SUM(F.Dose)*StimaOrdini AS Qta
        FROM Fase F
        WHERE F.Ricetta = NomeRicetta
        ON DUPLICATE KEY UPDATE Quantita = Quantita + VALUES(Quantita);
    END LOOP loop_lbl;
    
    CLOSE curRicetta;
END;$$

CREATE EVENT aggiorna_Report_TakeAway
ON SCHEDULE
EVERY 1 WEEK
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 3 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE TempoMedioAndata INT;
    DECLARE TempoMedioRitorno INT;
    
    TRUNCATE TABLE Report_TakeAway;
    
    SELECT CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Partenza, C.Arrivo))) AS TMAndata,
            CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Arrivo, C.Ritorno))) AS TMRitorno
        INTO TempoMedioAndata, TempoMedioRitorno
    FROM Consegna C
    WHERE C.Ritorno IS NOT NULL;
    
    IF TempoMedioAndata IS NULL OR TempoMedioRitorno IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dati insufficienti per la generazione di '
                            'Report_TakeAway.';
    END IF;
    
    INSERT INTO Report_TakeAway(Posizione, Sede, Pony, DeltaTempoAndata,
                                                           DeltaTempoRitorno)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT P.Sede, P.ID AS Pony,
                    SEC_TO_TIME(
                        CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Partenza, C.Arrivo))) -
                        TempoMedioAndata
                        ) AS DeltaTempoAndata,
                    SEC_TO_TIME(
                        CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Arrivo, C.Ritorno))) -
                        TempoMedioRitorno
                        ) AS DeltaTempoRitorno
            FROM Pony P INNER JOIN Consegna C
            WHERE C.Ritorno IS NOT NULL
            GROUP BY P.Sede, P.ID
        ) AS D
    ORDER BY (D.DeltaTempoAndata + D.DeltaTempoRitorno) ASC;
END;$$
