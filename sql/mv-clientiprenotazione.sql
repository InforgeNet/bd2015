CREATE TABLE MV_ClientiPrenotazione
(
    Sede                    VARCHAR(45) NOT NULL,
    `Data`                  DATE NOT NULL,
    Numero                  INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (Sede, `Data`),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

DELIMITER $$

CREATE TRIGGER aggiorna_MV_ClientiPrenotazione_insert
AFTER INSERT
ON Prenotazione
FOR EACH ROW
BEGIN
    INSERT INTO MV_ClientiPrenotazione(Sede, `Data`, Numero)
    VALUES (NEW.Sede, DATE(NEW.`Data`), NEW.Numero)
    ON DUPLICATE KEY
        UPDATE Numero = Numero + NEW.Numero;
END;$$

CREATE TRIGGER aggiorna_MV_ClientiPrenotazione_update
AFTER UPDATE
ON Prenotazione
FOR EACH ROW
BEGIN
    IF NEW.Numero <> OLD.Numero THEN
        INSERT INTO MV_ClientiPrenotazione(Sede, `Data`, Numero)
        VALUES (NEW.Sede, DATE(NEW.`Data`), NEW.Numero)
        ON DUPLICATE KEY
            UPDATE Numero = Numero - OLD.Numero + NEW.Numero;
    END IF;
END;$$

CREATE TRIGGER aggiorna_MV_ClientiPrenotazione_delete
AFTER DELETE
ON Prenotazione
FOR EACH ROW
BEGIN
    UPDATE MV_ClientiPrenotazione
    SET Numero = Numero - OLD.Numero
    WHERE Sede = OLD.Sede
        AND `Data` = DATE(OLD.`Data`);
END;$$

DELIMITER ;
