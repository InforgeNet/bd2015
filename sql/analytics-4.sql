CREATE TABLE Report_Sprechi
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Ingrediente             VARCHAR(45) NOT NULL,
    Spreco                  INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
    UNIQUE KEY (Sede, Ingrediente),
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
    DECLARE NomeSede VARCHAR(45);
    DECLARE NomeRicetta VARCHAR(45);
    DECLARE Numero INT;
    DECLARE Finito1 BOOL DEFAULT FALSE;
    DECLARE curSedeRicetta CURSOR FOR
        SELECT C.Sede, P.Ricetta, COUNT(*) AS Numero
        FROM Piatto P INNER JOIN Comanda C ON P.Comanda = C.ID
        WHERE C.`Timestamp` BETWEEN inizio AND fine
        GROUP BY C.Sede, P.Ricetta;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito1 = TRUE; 
    
    IF inizio IS NULL THEN
        SET inizio = '1970-01-01 00:00:01';
    END IF;
    IF fine IS NULL THEN
        SET fine = CURRENT_TIMESTAMP;
    END IF;
    
    OPEN curSedeRicetta;
    
    loop1_lbl: LOOP
        FETCH curSedeRicetta INTO NomeSede, NomeRicetta, Numero;
        IF Finito1 THEN
            LEAVE loop1_lbl;
        END IF;
        
        BEGIN -- vanno considerate anche le variazioni
            DECLARE NomeIngrediente VARCHAR(45);
            DECLARE Quantita INT;
            DECLARE Scaricata INT;
            DECLARE Finito2 BOOL DEFAULT FALSE;
            DECLARE curIngredienti CURSOR FOR
                SELECT F.Ingrediente,
                        COALESCE(SUM(F.Dose), 0)*Numero AS Quantita
                FROM Fase F
                WHERE F.Ricetta = NomeRicetta AND F.Ingrediente IS NOT NULL
                GROUP BY F.Ingrediente; 
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito2 = TRUE; 
            
            loop2_lbl: LOOP
                FETCH curIngredienti INTO NomeIngrediente, Quantita;
                IF Finito2 THEN
                    LEAVE loop2_lbl;
                END IF;
                
                SET Scaricata = (SELECT COALESCE(SUM(SL.Quantita), 0)
                                FROM Scarichi_Log SL
                                WHERE SL.Sede = NomeSede
                                    AND SL.Ingrediente = NomeIngrediente
                                    AND SL.`Timestamp` BETWEEN inizio AND fine);
                                    
                -- NON VA BENE L'INTERO CODICE: deve essere presa la quantità
                -- di ingrediente usata per fare tutte le ricette, non una
                -- alla volta.
            END LOOP loop2_lbl;
        END;
    END LOOP loop1_lbl;
    
    CLOSE curSedeRicetta
    
END;$$  

DELIMITER ;
