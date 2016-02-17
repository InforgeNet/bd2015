ALTER TABLE Recensione
ADD COLUMN VeridicitaTotale INT UNSIGNED NOT NULL DEFAULT 0 AFTER Giudizio
ADD COLUMN
    AccuratezzaTotale INT UNSIGNED NOT NULL DEFAULT 0 AFTER VeridicitaTotale
ADD COLUMN
    NumeroValutazioni INT UNSIGNED NOT NULL DEFAULT 0 AFTER AccuratezzaTotale;

DELIMITER $$

CREATE TRIGGER aggiorna_ridondanza_Recensione
AFTER INSERT
ON Valutazione
FOR EACH ROW
BEGIN
    UPDATE Recensione R
    SET R.VeridicitaTotale = R.VeridicitaTotale + NEW.Veridicita,
        R.AccuratezzaTotale = R.AccuratezzaTotale + NEW.Accuratezza,
        NumeroValutazioni = NumeroValutazioni + 1
    WHERE R.ID = NEW.Recensione;
END;$$

DELIMITER ;
