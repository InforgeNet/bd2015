CREATE TABLE Report_Sprechi
(
    Sede                    VARCHAR(45) NOT NULL,
    Ingrediente             VARCHAR(45) NOT NULL,
    Spreco                  INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Ingrediente),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

DELIMITER $$

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
            WHERE SL.`Timestamp` BETWEEN inizio AND fine;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
        
        OPEN curScarichi;
        
        loop_lbl: LOOP
            FETCH curScarichi INTO NomeSede, NomeIngrediente, Scaricata;
            IF Finito THEN
                LEAVE loop_lbl;
            END IF;
            
            SET Quantita = (
            SELECT SUM(F.Dose) AS Quantita
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

DELIMITER ;
