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

CREATE PROCEDURE ConsigliaPiatti(IN nomeSede VARCHAR(45))
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    DELETE FROM Report_PiattiDaAggiungere WHERE Sede = nomeSede;    
    
    INSERT INTO Report_PiattiDaAggiungere(Posizione, Sede, Ricetta)
    SELECT @row_number := @row_number + 1 AS Posizione, nomeSede, D.Ricetta
    FROM (SELECT @row_number := 0) AS N,
        (SELECT R.Nome AS Ricetta, COUNT(*) AS InScadenza,
            (SELECT IF(RPP.NumeroRecensioni = 0, 0,
                                   (RPP.GiudizioTotale/RPP.NumeroRecensioni)/10)
            FROM Report_PiattiPreferiti RPP
            WHERE RPP.Sede = nomeSede
                AND RPP.Ricetta = R.Nome) AS Punteggio
        FROM Fase F INNER JOIN Ricetta R ON F.Ricetta = R.Nome
        WHERE F.Ingrediente IS NOT NULL
            AND F.Ingrediente IN (SELECT IIS.Ingrediente
                                    FROM IngredientiInScadenza IIS
                                    WHERE IIS.Sede = nomeSede)
        GROUP BY R.Nome) AS D
    ORDER BY (D.InScadenza + D.Punteggio) DESC
    LIMIT 5;
END;$$

CREATE PROCEDURE AnalizzaRecensioni()
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    TRUNCATE TABLE Report_PiattiPreferiti;
    
    INSERT INTO Report_PiattiPreferiti(Posizione, Sede, Ricetta, GiudizioTotale,
                                                            NumeroRecensioni)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT R.Sede, R.Ricetta,
                SUM(R.Giudizio)*IF(SUM(R.NumeroValutazioni) = 0, 6, ROUND(
            AVG((R.VeridicitaTotale + R.AccuratezzaTotale)/R.NumeroValutazioni))
                ) AS GiudizioTotale, COUNT(*) AS NumeroRecensioni
            FROM Recensione R
            GROUP BY R.Sede, R.Ricetta
        ) AS D
    ORDER BY D.GiudizioTotale/D.NumeroRecensioni DESC;
END;$$

CREATE PROCEDURE AnalizzaVendite(IN inizio TIMESTAMP, IN fine TIMESTAMP)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    IF inizio IS NULL THEN
        SET inizio = '1970-01-01 00:00:01';
    END IF;
    IF fine IS NULL THEN
        SET fine = CURRENT_TIMESTAMP;
    END IF;
    
    TRUNCATE TABLE Report_VenditePiatti;
    
    INSERT INTO Report_VenditePiatti(Posizione, Sede, Ricetta, Vendite)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT C.Sede, P.Ricetta, COUNT(*) AS Vendite
            FROM Piatto P INNER JOIN Comanda C ON P.Comanda = C.ID
            WHERE C.`Timestamp` BETWEEN inizio AND fine
            GROUP BY C.Sede, P.Ricetta
        ) AS D
    ORDER BY D.Vendite DESC;
END;$$

CREATE PROCEDURE AnalizzaSuggerimenti()
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    TRUNCATE TABLE Report_SuggerimentiMigliori;
    
    INSERT INTO Report_SuggerimentiMigliori(Posizione, Suggerimento,
                                            GradimentoTotale, NumeroGradimenti)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT G.Suggerimento, SUM(G.Punteggio) AS GradimentoTotale,
                                                    COUNT(*) AS NumeroGradimenti
            FROM Gradimento G
            WHERE G.Suggerimento IS NOT NULL
            GROUP BY G.Suggerimento
        ) AS D
    ORDER BY D.GradimentoTotale/D.NumeroGradimenti DESC;
END;$$

CREATE PROCEDURE AnalizzaProposte()
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    TRUNCATE TABLE Report_ProposteMigliori;
    
    INSERT INTO Report_ProposteMigliori(Posizione, Proposta, GradimentoTotale,
                                                               NumeroGradimenti)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT G.Proposta, SUM(G.Punteggio) AS GradimentoTotale,
                                                    COUNT(*) AS NumeroGradimenti
            FROM Gradimento G
            WHERE G.Proposta IS NOT NULL
            GROUP BY G.Proposta
        ) AS D
    ORDER BY D.GradimentoTotale/D.NumeroGradimenti DESC;
END;$$

CREATE PROCEDURE AnalizzaSprechi(IN inizio TIMESTAMP, IN fine TIMESTAMP)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    IF inizio IS NULL THEN
        SET inizio = '1970-01-01 00:00:01';
    END IF;
    IF fine IS NULL THEN
        SET fine = CURRENT_TIMESTAMP;
    END IF;
    
    TRUNCATE TABLE Report_Sprechi;
    
    BEGIN
        DECLARE NomeSede VARCHAR(45);
        DECLARE NomeIngrediente VARCHAR(45);
        DECLARE Scaricata INT;
        DECLARE Quantita INT;
        DECLARE Finito BOOL DEFAULT FALSE;
        DECLARE curScarichi CURSOR FOR
            SELECT SL.Sede, SL.Ingrediente, COALESCE(SUM(SL.Quantita), 0) AS Qta
            FROM Scarichi_Log SL
            WHERE SL.`Timestamp` BETWEEN inizio AND fine
            GROUP BY SL.Sede, SL.Ingrediente;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
        
        OPEN curScarichi;
        
        loop_lbl: LOOP
            FETCH curScarichi INTO NomeSede, NomeIngrediente, Scaricata;
            IF Finito THEN
                LEAVE loop_lbl;
            END IF;
            
            SET Quantita = (
            SELECT COALESCE(SUM(F.Dose), 0) AS Quantita
            FROM Fase F
                INNER JOIN Ricetta R ON F.Ricetta = R.Nome
                INNER JOIN Piatto P ON R.Nome = P.Ricetta
                INNER JOIN Comanda C ON P.Comanda = C.ID
            WHERE C.Sede = NomeSede
                AND F.Ingrediente = NomeIngrediente
                AND C.`Timestamp` BETWEEN inizio AND fine
                AND F.ID NOT IN (SELECT MF.FaseVecchia
                                FROM ModificaFase MF
                                    INNER JOIN Variazione V
                                        ON MF.Variazione = V.ID
                                    INNER JOIN
                                    (SELECT M.Variazione
                                    FROM Modifica M
                                    WHERE M.Piatto = P.ID) AS D
                                        ON V.ID = D.Variazione)
                AND F.ID NOT IN (SELECT MFN.FaseNuova
                                FROM ModificaFase MFN
                                    INNER JOIN Variazione VA
                                        ON MFN.Variazione = VA.ID
                                WHERE VA.ID NOT IN (SELECT MO.Variazione
                                                    FROM Modifica MO
                                                    WHERE MO.Piatto = P.ID))                                        
            );
            
            INSERT INTO Report_Sprechi(Sede, Ingrediente, Spreco)
            VALUES (NomeSede, NomeIngrediente, Scaricata - Quantita);
            
        END LOOP loop_lbl;
        
        CLOSE curScarichi;
    END;
END;$$  
