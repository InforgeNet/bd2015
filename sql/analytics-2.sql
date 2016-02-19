CREATE TABLE Report_PiattiPreferiti
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    GiudizioTotale          INT UNSIGNED NOT NULL,
    NumeroRecensioni        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
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

CREATE TABLE Report_VenditePiatti
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    Vendite                 INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
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

CREATE TABLE Report_SuggerimentiMigliori
(
    Posizione               INT UNSIGNED NOT NULL,
    Suggerimento            INT UNSIGNED NOT NULL,
    GradimentoTotale        INT UNSIGNED NOT NULL,
    NumeroGradimenti        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
    UNIQUE KEY (Suggerimento),
    FOREIGN KEY (Suggerimento)
        REFERENCES Variazione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Report_ProposteMigliori
(
    Posizione               INT UNSIGNED NOT NULL,
    Proposta                INT UNSIGNED NOT NULL,
    GradimentoTotale        INT UNSIGNED NOT NULL,
    NumeroGradimenti        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
    UNIQUE KEY (Proposta),
    FOREIGN KEY (Proposta)
        REFERENCES Proposta(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

DELIMITER $$

CREATE PROCEDURE AnalizzaRecensioni()
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    TRUNCATE TABLE Report_PiattiPreferiti;
    
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    INTO Report_PiattiPreferiti
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT R.Sede, R.Ricetta,
                SUM(R.Giudizio)*IF(SUM(R.NumeroValutazioni) = 0, 5, ROUND(
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
    
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    INTO Report_VenditePiatti
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
    
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    INTO Report_SuggerimentiMigliori
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
    
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    INTO Report_ProposteMigliori
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

DELIMITER ;
