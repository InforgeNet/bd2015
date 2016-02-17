CREATE OR REPLACE VIEW RankRecensioni AS
SELECT R.ID AS Recensione,
        R.VeridicitaTotale, R.AccuratezzaTotale, R.NumeroValutazioni
FROM Recensione R
GROUP BY R.ID
ORDER BY (R.VeridicitaTotale + R.AccuratezzaTotale)/R.NumeroValutazioni DESC;
