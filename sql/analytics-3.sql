CREATE TABLE Report_Ordinativi
(
    Sede            VARCHAR(45) NOT NULL,
    Ingrediente     VARCHAR(45) NOT NULL,
    Quantita        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Ingrediente),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
)ENGINE = InnoDB;

DELIMITER $$

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

DELIMITER ;
