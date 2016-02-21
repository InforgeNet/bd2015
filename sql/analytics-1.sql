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

CREATE OR REPLACE VIEW IngredientiInScadenza AS
SELECT C.Sede, L.Ingrediente
FROM Lotto L INNER JOIN Confezione C ON L.Codice = C.CodiceLotto
WHERE (C.Stato = 'completa' AND L.Scadenza < CURRENT_DATE + INTERVAL 5 DAY)
    OR (C.Stato = 'parziale' AND FROM_DAYS(TO_DAYS(L.Scadenza) -
        ROUND(TIMESTAMPDIFF(DAY, C.DataAcquisto, L.Scadenza)*0.2)) <
                                                CURRENT_DATE + INTERVAL 5 DAY)
GROUP BY C.Sede, L.Ingrediente;

DELIMITER $$

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

DELIMITER ;
