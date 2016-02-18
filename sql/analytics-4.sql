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

CREATE PROCEDURE AnalizzaSprechi(IN inizio TIMESTAMP, IN fine TIMESTAMP)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
END;$$
