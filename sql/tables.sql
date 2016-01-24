-- TODO: Controllare equivalenza con diagrammi
-- TODO: Aggiungere tutti i trigger necessari
-- TODO: Stendere il capitolo 9
-- TODO: Se graficamente brutto senza, aggiungere i backtick ai nomi
-- TODO: Nei diagrammi: spostare DataArrivo nell'associazione InOrdine (nullable)

-- CREATE SCHEMA IF NOT EXISTS unipi_project DEFAULT CHARACTER SET utf8;
-- USE unipi_project;

CREATE TABLE Sede
(
    Nome                    VARCHAR(45) NOT NULL,
    Citta                   VARCHAR(45) NOT NULL,
    CAP                     INT(5) UNSIGNED ZEROFILL NOT NULL,
    Via                     VARCHAR(45) NOT NULL,
    NumeroCivico            INT UNSIGNED NOT NULL,
    PRIMARY KEY (Nome),
    UNIQUE KEY (Citta, Via, NumeroCivico)
) ENGINE = InnoDB;

CREATE TABLE Magazzino
(
    Sede                    VARCHAR(45) NOT NULL,
    ID                      INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, ID),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Ingrediente
(
    Nome                    VARCHAR(45) NOT NULL,
    Provenienza             VARCHAR(45) NOT NULL,
    TipoProduzione          VARCHAR(45) NOT NULL,
    Genere                  VARCHAR(45) NOT NULL,
    Allergene               BOOL NOT NULL DEFAULT FALSE,
    PRIMARY KEY (Nome)
) ENGINE = InnoDB;

CREATE TABLE Lotto
(
    Codice                  VARCHAR(32) NOT NULL,
    Ingrediente             VARCHAR(45) NOT NULL,
    Scadenza                DATE NOT NULL,
    PRIMARY KEY (Codice),
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Confezione
(
    CodiceLotto             VARCHAR(32) NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Peso                    INT UNSIGNED NOT NULL,
    Prezzo                  DECIMAL(8,2) UNSIGNED NOT NULL,
    DataAcquisto            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DataArrivo              DATETIME,
    DataCarico              DATETIME,
    Sede                    VARCHAR(45) NOT NULL,
    Magazzino               INT UNSIGNED NOT NULL,
    Collocazione            VARCHAR(45),
    Aspetto                 BOOL COMMENT 'TRUE = ok; FALSE = danneggiata',
    Stato                   ENUM('completa', 'parziale', 'in uso'),
    PRIMARY KEY (CodiceLotto, Numero),
    FOREIGN KEY (CodiceLotto)
        REFERENCES Lotto(Codice)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Sede, Magazzino)
        REFERENCES Magazzino(Sede, ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Strumento
(
    Nome                    VARCHAR(45) NOT NULL,
    PRIMARY KEY (Nome)
) ENGINE = InnoDB;

CREATE TABLE Funzione
(
    Strumento               VARCHAR(45) NOT NULL,
    Nome                    VARCHAR(45) NOT NULL,
    PRIMARY KEY (Strumento, Nome),
    FOREIGN KEY (Strumento)
        REFERENCES Strumento(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Cucina
(
    Sede                    VARCHAR(45) NOT NULL,
    Strumento               VARCHAR(45) NOT NULL,
    Quantita                INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Strumento),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Strumento)
        REFERENCES Strumento(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Menu
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Sede                    VARCHAR(45) NOT NULL,
    DataInizio              DATE NOT NULL,
    DataFine                DATE NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE KEY (Sede, DataInizio),
    UNIQUE KEY (Sede, DataFine),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Ricetta
(
    Nome                    VARCHAR(45) NOT NULL,
    Testo                   TEXT NOT NULL,
    PRIMARY KEY (Nome)
) ENGINE = InnoDB;

CREATE TABLE Elenco
(
    Menu                    INT UNSIGNED NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    Novita                  BOOL NOT NULL DEFAULT TRUE,
    PRIMARY KEY (Menu, Ricetta),
    FOREIGN KEY (Menu)
        REFERENCES Menu(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Fase
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Ricetta                 VARCHAR(45) NOT NULL,
    Ingrediente             VARCHAR(45),
    Dose                    INT UNSIGNED,
    Primario                BOOL,
    Strumento               VARCHAR(45),
    Testo                   TEXT,
    Durata                  TIME,
    PRIMARY KEY (ID),
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (Strumento)
        REFERENCES Strumento(Nome)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE SequenzaFasi
(
    Fase                    INT UNSIGNED NOT NULL,
    FasePrecedente          INT UNSIGNED NOT NULL,
    PRIMARY KEY (Fase, FasePrecedente),
    FOREIGN KEY (Fase)
        REFERENCES Fase(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FasePrecedente)
        REFERENCES Fase(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Sala
(
    Sede                    VARCHAR(45) NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Numero),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Tavolo
(
    Sede                    VARCHAR(45) NOT NULL,
    Sala                    INT UNSIGNED NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Posti                   INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Sala, Numero),
    FOREIGN KEY (Sede, Sala)
        REFERENCES Sala(Sede, Numero)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Account
(
    Username                VARCHAR(20) NOT NULL,
    Email                   VARCHAR(100) NOT NULL,
    `Password`              CHAR(32) NOT NULL,
    Nome                    VARCHAR(45) NOT NULL,
    Cognome                 VARCHAR(45) NOT NULL,
    Citta                   VARCHAR(45) NOT NULL,
    CAP                     INT(5) UNSIGNED ZEROFILL NOT NULL,
    Via                     VARCHAR(45) NOT NULL,
    NumeroCivico            INT UNSIGNED NOT NULL,
    Telefono                VARCHAR(16) NOT NULL,
    PuoPrenotare            BOOL NOT NULL DEFAULT TRUE,
    PRIMARY KEY (Username),
    UNIQUE KEY (Email),
    UNIQUE KEY (Telefono),
    UNIQUE KEY (Nome, Cognome, Citta, Via, NumeroCivico)
) ENGINE = InnoDB;

CREATE TABLE Comanda
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Timestamp`             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Sede                    VARCHAR(45) NOT NULL,
    Sala                    INT UNSIGNED,
    Tavolo                  INT UNSIGNED,
    Account                 VARCHAR(20),
    PRIMARY KEY (ID),
    UNIQUE KEY (`Timestamp`, Sede, Sala, Tavolo),
    UNIQUE KEY (`Timestamp`, Account),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Sede, Sala, Tavolo)
        REFERENCES Tavolo(Sede, Sala, Numero)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Account)
        REFERENCES Account(Username)
        ON DELETE SET NULL
        ON UPDATE CASCADE        
) ENGINE = InnoDB;

CREATE TABLE Piatto
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Comanda                 INT UNSIGNED NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    Stato                   ENUM('attesa', 'in preparazione', 'servizio')
                                NOT NULL DEFAULT 'attesa',
    PRIMARY KEY (ID),
    FOREIGN KEY (Comanda)
        REFERENCES Comanda(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Variazione
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Ricetta                 VARCHAR(45) NOT NULL,
    Nome                    VARCHAR(45),
    Account                 VARCHAR(20),
    PRIMARY KEY (ID),
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Account)
        REFERENCES Account(Username)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE ModificaFase
(
    Variazione              INT UNSIGNED NOT NULL,
    ID                      INT UNSIGNED NOT NULL,
    FaseVecchia             INT UNSIGNED,
    FaseNuova               INT UNSIGNED,
    PRIMARY KEY (Variazione, ID),
    FOREIGN KEY (Variazione)
        REFERENCES Variazione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (FaseVecchia)
        REFERENCES Fase(ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (FaseNuova)
        REFERENCES Fase(ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Modifica
(
    Piatto                  INT UNSIGNED NOT NULL,
    Variazione              INT UNSIGNED NOT NULL,
    PRIMARY KEY (Piatto, Variazione),
    FOREIGN KEY (Piatto)
        REFERENCES Piatto(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Variazione)
        REFERENCES Variazione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Pony
(
    Sede                    VARCHAR(45) NOT NULL,
    ID                      INT UNSIGNED NOT NULL,
    Ruote                   BOOL NOT NULL DEFAULT FALSE
                                COMMENT 'TRUE = 4 ruote; FALSE = 2 ruote',
    Stato                   BOOL NOT NULL DEFAULT TRUE
                                COMMENT 'TRUE = libero; FALSE = occupato',
    PRIMARY KEY (Sede, ID),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Consegna
(
    Comanda                 INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Pony                    INT UNSIGNED NOT NULL,
    Partenza                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Arrivo                  DATETIME ON UPDATE CURRENT_TIMESTAMP,
    Ritorno                 DATETIME,
    PRIMARY KEY (Comanda),
    UNIQUE KEY (Pony, Partenza),
    FOREIGN KEY (Comanda)
        REFERENCES Comanda(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Sede, Pony)
        REFERENCES Pony(Sede, ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Prenotazione
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Sede                    VARCHAR(45) NOT NULL,
    Data                    DATETIME NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Account                 VARCHAR(45),
    Nome                    VARCHAR(45),
    Telefono                VARCHAR(16),
    Sala                    INT UNSIGNED NOT NULL,
    Tavolo                  INT UNSIGNED,
    Descrizione             TEXT,
    Approvato               BOOL,
    PRIMARY KEY (ID),
    UNIQUE KEY (Tavolo, Data),
    FOREIGN KEY (Sede, Sala, Tavolo)
        REFERENCES Tavolo(Sede, Sala, Numero)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Sede, Sala)
        REFERENCES Sala(Sede, Numero)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Account)
        REFERENCES Account(Username)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Proposta
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Account                 VARCHAR(20) NOT NULL,
    Nome                    VARCHAR(45) NOT NULL,
    Procedimento            TEXT,
    PRIMARY KEY (ID),
    UNIQUE KEY (Account, Nome),
    FOREIGN KEY (Account)
        REFERENCES Account(Username)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Composizione
(
    Proposta                INT UNSIGNED NOT NULL,
    Ingrediente             VARCHAR(45) NOT NULL,
    PRIMARY KEY (Proposta, Ingrediente),
    FOREIGN KEY (Proposta)
        REFERENCES Proposta(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Gradimento
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Account                 VARCHAR(20) NOT NULL,
    Proposta                INT UNSIGNED,
    Suggerimento            INT UNSIGNED,
    Punteggio               TINYINT(1) UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    UNIQUE KEY (Account, Proposta, Suggerimento),
    FOREIGN KEY (Account)
        REFERENCES Account(Username)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Proposta)
        REFERENCES Proposta(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Suggerimento)
        REFERENCES Variazione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Recensione
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Account                 VARCHAR(20) NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    Testo                   TEXT NOT NULL,
    Giudizio                TINYINT(1) UNSIGNED NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Account)
        REFERENCES Account(Username)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Valutazione
(
    Account                 VARCHAR(20) NOT NULL,
    Recensione              INT UNSIGNED NOT NULL,
    Veridicita              TINYINT(1) UNSIGNED NOT NULL,
    Accuratezza             TINYINT(1) UNSIGNED NOT NULL,
    Testo                   TEXT NOT NULL,
    PRIMARY KEY (Account, Recensione),
    FOREIGN KEY (Account)
        REFERENCES Account(Username)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Recensione)
        REFERENCES Recensione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Domanda
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Sede                    VARCHAR(45) NOT NULL,
    Testo                   VARCHAR(1024) NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Risposta
(
    Domanda                 INT UNSIGNED NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Testo                   VARCHAR(1024) NOT NULL,
    Efficienza              TINYINT(1) UNSIGNED NOT NULL,
    PRIMARY KEY (Domanda, Numero),
    FOREIGN KEY (Domanda)
        REFERENCES Domanda(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE QuestionarioSvolto
(
    Recensione              INT UNSIGNED NOT NULL,
    Domanda                 INT UNSIGNED NOT NULL,
    Risposta                INT UNSIGNED NOT NULL,
    PRIMARY KEY (Recensione, Domanda, Risposta),
    FOREIGN KEY (Recensione)
        REFERENCES Recensione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Domanda, Risposta)
        REFERENCES Risposta(Domanda, Numero)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;
