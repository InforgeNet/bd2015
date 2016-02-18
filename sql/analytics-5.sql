CREATE TABLE Report_TakeAway
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Pony                    INT UNSIGNED NOT NULL,
    DeltaTempoAndata        TIME NOT NULL,
    DeltaTempoRitorno       TIME NOT NULL,
    PRIMARY KEY (Posizione),
    UNIQUE KEY (Sede, Pony),
    FOREIGN KEY (Sede, Pony)
        REFERENCES Pony(Sede, ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

DELIMITER $$

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
    INTO Report_TakeAway
    ORDER BY (D.DeltaTempoAndata + D.DeltaTempoRitorno) ASC;
END;$$

DELIMITER ;
