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
    Sede                    VARCHAR(45) NOT NULL,
    Magazzino               INT UNSIGNED NOT NULL,
    Ingrediente             VARCHAR(45) NOT NULL,
    Quantita                INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (Sede, Magazzino, Ingrediente),
    FOREIGN KEY (Sede, Magazzino)
        REFERENCES Magazzino(Sede, ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;
