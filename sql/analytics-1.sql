CREATE TABLE Report_PiattiDaAggiungere
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    PRIMARY KEY(Posizione),
    UNIQUE KEY (Sede, Ricetta),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

DELIMITER $$

CREATE PROCEDURE ConsigliaPiatti(IN nomeSede VARCHAR(45))
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    DECLARE NomeRicetta VARCHAR(45);
    DECLARE Finito1 BOOL DEFAULT FALSE;
    DECLARE curRicetta CURSOR FOR
        SELECT R.Nome
        FROM Ricetta R
        WHERE R.Nome NOT IN (SELECT E.Ricetta
                            FROM Elenco E INNER JOIN Menu M ON E.Menu = M.ID
                            WHERE CURRENT_DATE BETWEEN
                                                M.DataInizio AND M.DataFine);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito1 = TRUE;
    
    loop1_lbl: LOOP
        FETCH curRicetta INTO NomeRicetta;
        IF Finito1 THEN
            LEAVE loop1_lbl;
        END IF;
    END LOOP loop1_lbl;
END;$$

DELIMITER ;
