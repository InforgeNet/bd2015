CREATE OR REPLACE VIEW IngredientiInScadenza AS
SELECT C.Sede, L.Ingrediente
FROM Lotto L INNER JOIN Confezione C ON L.Codice = C.CodiceLotto
WHERE (C.Stato = 'completa' AND L.Scadenza < CURRENT_DATE + INTERVAL 5 DAY)
    OR (C.Stato = 'parziale' AND FROM_DAYS(TO_DAYS(L.Scadenza) -
        ROUND(TIMESTAMPDIFF(DAY, C.DataAcquisto, L.Scadenza)*0.2)) <
                                                CURRENT_DATE + INTERVAL 5 DAY)
GROUP BY C.Sede, L.Ingrediente;

CREATE OR REPLACE VIEW ConsumiUltimaSettimana AS
SELECT SL.Sede, SL.Ingrediente, COALESCE(SUM(SL.Quantita), 0) as Quantita
FROM Scharichi_Log SL
WHERE SL.`Timestamp` BETWEEN CURRENT_DATE - INTERVAL 1 WEEK AND CURRENT_DATE
GROUP BY SL.Sede, SL.Ingrediente;
