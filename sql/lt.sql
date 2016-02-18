CREATE TABLE Clienti_Log
(
    Sede                    VARCHAR(45) NOT NULL,
    Anno                    INT UNSIGNED NOT NULL,
    Mese                    INT UNSIGNED NOT NULL,
    SenzaPrenotazione       INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (Sede, Anno, Mese),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Scarichi_Log
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Sede                    VARCHAR(45) NOT NULL,
    Magazzino               INT UNSIGNED NOT NULL,
    Ingrediente             VARCHAR(45) NOT NULL,
    `Timestamp`             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Quantita                INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (ID),
    FOREIGN KEY (Sede, Magazzino)
        REFERENCES Magazzino(Sede, ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

DELIMITER $$

CREATE TRIGGER nuova_sede
AFTER INSERT
ON Sede
FOR EACH ROW
BEGIN
    INSERT INTO Clienti_Log(Sede, Anno, Mese) VALUES
        (NEW.Nome, YEAR(CURRENT_DATE), MONTH(CURRENT_DATE));
END;$$

CREATE PROCEDURE RegistraClienti(IN inSede VARCHAR(45), IN numero INT)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    INSERT INTO Clienti_Log(Sede, Anno, Mese, SenzaPrenotazione) VALUES
        (inSede, YEAR(CURRENT_DATE), MONTH(CURRENT_DATE), numero)
        ON DUPLICATE KEY
            UPDATE SenzaPrenotazione = SenzaPrenotazione + numero;
END;$$

CREATE TRIGGER aggiorna_Scarichi_Log_update
AFTER UPDATE
ON Confezione
FOR EACH ROW
BEGIN
    DECLARE IngScaricato VARCHAR(45);
    
    IF OLD.Stato = 'in uso' AND NEW.Stato = 'parziale'
        AND OLD.Peso > NEW.Peso THEN
        SET IngScaricato = (SELECT L.Ingrediente
                            FROM Lotto L
                            WHERE L.Codice = NEW.CodiceLotto);
                            
        INSERT INTO Scarichi_Log(Sede, Magazzino, Ingrediente, Quantita)
        VALUES (NEW.Sede, NEW.Magazzino, IngScaricato, OLD.Peso - NEW.Peso);
    END IF;
END;$$

CREATE TRIGGER aggiorna_Scarichi_Log_delete
AFTER DELETE
ON Confezione
FOR EACH ROW
BEGIN
    DECLARE IngScaricato VARCHAR(45);
    
    IF OLD.Stato = 'in uso' THEN
        SET IngScaricato = (SELECT L.Ingrediente
                            FROM Lotto L
                            WHERE L.Codice = OLD.CodiceLotto);
                            
        INSERT INTO Scarichi_Log(Sede, Magazzino, Ingrediente, Quantita)
        VALUES (OLD.Sede, OLD.Magazzino, IngScaricato, OLD.Peso);
    END IF;
END;$$

DELIMITER ;
