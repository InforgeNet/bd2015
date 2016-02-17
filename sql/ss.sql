CREATE TABLE Confezione_Snapshot
(
    CodiceLotto             VARCHAR(32) NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Peso                    INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodiceLotto, Numero)
) ENGINE = InnoDB;

DELIMITER $$

CREATE EVENT snapshot_Confezione
ON SCHEDULE
EVERY 1 WEEK
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 4 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    TRUNCATE TABLE Confezione_Snapshot;
    
    SELECT C.CodiceLotto, C.Numero, C.Peso
        INTO Confezione_Snapshot(CodiceLotto, Numero, Peso)
    FROM Confezione C
    WHERE C.Stato <> 'in ordine';
END;$$

DELIMITER ;
