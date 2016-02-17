CREATE TABLE Confezione_Snapshot
(
    CodiceLotto             VARCHAR(32) NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Peso                    INT UNSIGNED NOT NULL,
    PRIMARY KEY (CodiceLotto, Numero)
) ENGINE = InnoDB;
