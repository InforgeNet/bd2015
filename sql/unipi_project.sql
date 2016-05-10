SELECT "Creazione database e impostazione variabili."
    AS "************** START - FASE 1 **************";

DROP SCHEMA IF EXISTS unipi_project;
CREATE SCHEMA unipi_project DEFAULT CHARACTER SET utf8;
USE unipi_project;

SET GLOBAL event_scheduler = on;


-- TABLES
SELECT "Creazione tabelle." AS "***** FASE 2 *****";

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
    Stato                   ENUM('completa', 'parziale', 'in uso', 'in ordine')
                                NOT NULL DEFAULT 'in ordine',
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
    Quantita                INT UNSIGNED NOT NULL DEFAULT 1,
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
    Sesso                   CHAR(1) NOT NULL,
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
    InizioPreparazione      TIMESTAMP NULL DEFAULT NULL
                                ON UPDATE CURRENT_TIMESTAMP,
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
    `Data`                  DATETIME NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Account                 VARCHAR(45),
    Nome                    VARCHAR(45),
    Telefono                VARCHAR(16),
    Sala                    INT UNSIGNED NOT NULL,
    Tavolo                  INT UNSIGNED,
    Descrizione             TEXT,
    Approvato               BOOL,
    PRIMARY KEY (ID),
    UNIQUE KEY (Tavolo, `Data`),
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
    VeridicitaTotale        INT UNSIGNED NOT NULL DEFAULT 0,
    AccuratezzaTotale       INT UNSIGNED NOT NULL DEFAULT 0,
    NumeroValutazioni       INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (ID),
    UNIQUE KEY (Account, Sede, Ricetta),
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
    PRIMARY KEY (Recensione, Domanda),
    FOREIGN KEY (Recensione)
        REFERENCES Recensione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Domanda, Risposta)
        REFERENCES Risposta(Domanda, Numero)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;


-- LOG TABLES
SELECT "Creazione tabelle di log." AS "******** FASE 3 *********";

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


-- REPORT TABLES
SELECT "Creazione tabelle di report." AS "********** FASE 4 **********";

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

CREATE TABLE Report_PiattiPreferiti
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    GiudizioTotale          INT UNSIGNED NOT NULL,
    NumeroRecensioni        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
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

CREATE TABLE Report_VenditePiatti
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    Vendite                 INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
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

CREATE TABLE Report_SuggerimentiMigliori
(
    Posizione               INT UNSIGNED NOT NULL,
    Suggerimento            INT UNSIGNED NOT NULL,
    GradimentoTotale        INT UNSIGNED NOT NULL,
    NumeroGradimenti        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
    UNIQUE KEY (Suggerimento),
    FOREIGN KEY (Suggerimento)
        REFERENCES Variazione(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Report_ProposteMigliori
(
    Posizione               INT UNSIGNED NOT NULL,
    Proposta                INT UNSIGNED NOT NULL,
    GradimentoTotale        INT UNSIGNED NOT NULL,
    NumeroGradimenti        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Posizione),
    UNIQUE KEY (Proposta),
    FOREIGN KEY (Proposta)
        REFERENCES Proposta(ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Report_Ordinativi
(
    Sede            VARCHAR(45) NOT NULL,
    Ingrediente     VARCHAR(45) NOT NULL,
    Quantita        INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Ingrediente),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Report_Sprechi
(
    Sede                    VARCHAR(45) NOT NULL,
    Ingrediente             VARCHAR(45) NOT NULL,
    Spreco                  INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Ingrediente),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ingrediente)
        REFERENCES Ingrediente(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE Report_TakeAway
(
    Posizione               INT UNSIGNED NOT NULL,
    Sede                    VARCHAR(45) NOT NULL,
    Pony                    INT UNSIGNED NOT NULL,
    DeltaTempoAndata        TIME NOT NULL,
    DeltaTempoRitorno       TIME NOT NULL,
    PRIMARY KEY (Posizione),
    UNIQUE KEY (Sede, Pony),
    FOREIGN KEY (Sede, Pony)
        REFERENCES Pony(Sede, ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;


-- MATERIALIZED VIEWS
SELECT "Creazione materialized views." AS "********** FASE 5 ***********";

CREATE TABLE MV_OrdiniRicetta
(
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    Comparse                INT UNSIGNED NOT NULL DEFAULT 1,
    TotOrdini               INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Ricetta),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE MV_MenuCorrente
(
    Sede                    VARCHAR(45) NOT NULL,
    Ricetta                 VARCHAR(45) NOT NULL,
    Novita                  BOOL NOT NULL DEFAULT FALSE,
    PRIMARY KEY (Sede, Ricetta),
    FOREIGN KEY (Sede)
        REFERENCES Sede(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Ricetta)
        REFERENCES Ricetta(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;

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


-- VIEWS
SELECT "Creazione views." AS "**** FASE 6 ****";

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
FROM Scarichi_Log SL
WHERE SL.`Timestamp` BETWEEN CURRENT_DATE - INTERVAL 1 WEEK AND CURRENT_DATE
GROUP BY SL.Sede, SL.Ingrediente;


DELIMITER $$


-- STORED ROUTINES
SELECT "Creazione stored routines." AS "********* FASE 7 *********";

CREATE PROCEDURE RegistraClienti(IN inSede VARCHAR(45), IN numero INT)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    INSERT INTO Clienti_Log(Sede, Anno, Mese, SenzaPrenotazione) VALUES
        (inSede, YEAR(CURRENT_DATE), MONTH(CURRENT_DATE), numero)
        ON DUPLICATE KEY
            UPDATE SenzaPrenotazione = SenzaPrenotazione + numero;
END;$$

CREATE FUNCTION StatoComanda(idComanda INT)
RETURNS ENUM('nuova', 'in preparazione', 'parziale', 'evasa', 'consegna')
NOT DETERMINISTIC READS SQL DATA
BEGIN
    -- bit 1 set: contiene piatti in attesa
    -- bit 2 set: contiene piatti in preparazione
    -- bit 3 set: contiene piatti in servizio
    DECLARE Flags INT;
    
    SET Flags = (SELECT IF(SUM(P.Stato = 'attesa') > 0, 1, 0)
                        + IF(SUM(P.Stato = 'in preparazione') > 0, 2, 0)
                        + IF(SUM(P.Stato = 'servizio') > 0, 4, 0)
                    FROM Piatto P
                    WHERE P.Comanda = idComanda);
                    
    CASE
        WHEN Flags = 4 THEN -- tutti i piatti in servizio
        BEGIN
            DECLARE TakeAway BOOL DEFAULT FALSE;
            SET TakeAway = (SELECT C.Account IS NOT NULL
                            FROM Comanda C
                            WHERE C.ID = idComanda);
            IF TakeAway THEN
                RETURN 'consegna';
            ELSE
                RETURN 'evasa';
            END IF;
        END;
        WHEN Flags > 4 THEN RETURN 'parziale'; -- alcuni piatti in servizio
        WHEN Flags > 1 THEN RETURN 'in preparazione'; -- alcuni piatti in prep.
        ELSE RETURN 'nuova'; -- tutti i piatti in attesa (Flags = 1)
    END CASE;    
END;$$

CREATE FUNCTION IngredientiDisponibili(cSede VARCHAR(45), cRicetta VARCHAR(45),
                                                    cNovita BOOL, cData DATE)
RETURNS BOOL
NOT DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE ClientiPrenotazioni INT;
    DECLARE MediaSenzaPrenotazione INT;
    DECLARE StimaClienti INT;
    DECLARE StimaOrdini INT;
    DECLARE cIngrediente VARCHAR(45);
    DECLARE cDose INT;
    DECLARE cPrimario BOOL;
    DECLARE qtaDisponibile INT;
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE curIngredienti CURSOR FOR
        SELECT F.Ingrediente, SUM(F.Dose), SUM(F.Primario) > 0
        FROM Fase F
        WHERE F.Ricetta = cRicetta AND F.Ingrediente IS NOT NULL
        GROUP BY F.Ingrediente;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
    
    IF cData IS NULL THEN
        SET cData = CURRENT_DATE;
    END IF;
      
    SET ClientiPrenotazioni = (SELECT COALESCE(CP.Numero, 0)
                                FROM MV_ClientiPrenotazione CP
                                WHERE CP.Sede = cSede
                                    AND CP.`Data` = cData);
    
    SET MediaSenzaPrenotazione = (SELECT
                                CEIL(COALESCE(AVG(CL.SenzaPrenotazione), 0)/
                                        DAY(LAST_DAY(cData)))
                                        AS Media
                                    FROM Clienti_Log CL
                                    WHERE CL.Sede = cSede
                                        AND CL.Mese = MONTH(cData)
                                        AND CL.Anno <> YEAR(cData)
                                );
                            
    SET StimaClienti = ClientiPrenotazioni + MediaSenzaPrenotazione;
    
    IF cNovita THEN
        SET StimaOrdini = (SELECT CEIL(StimaClienti * 0.33));
    ELSE
        SET StimaOrdini = (SELECT (COALESCE(CEIL(MV.TotOrdini / MV.Comparse), 0)
                                        + StimaClienti * 0.1) AS StimaOrdini
                            FROM MV_OrdiniRicetta MV
                            WHERE MV.Sede = cSede AND MV.Ricetta = cRicetta);
    END IF;
    
    IF StimaOrdini < 5 THEN
        SET StimaOrdini = 5;
    END IF;
    
    OPEN curIngredienti;
    
    loop_lbl: LOOP
        FETCH curIngredienti INTO cIngrediente, cDose, cPrimario;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        SET qtaDisponibile = (SELECT SUM(C.Peso)
                                FROM Confezione C INNER JOIN Lotto L
                                            ON C.CodiceLotto = L.Codice
                                WHERE C.Sede = cSede
                                    AND L.Ingrediente = cIngrediente
                                    AND (C.Stato <> 'in ordine'
                                        OR (C.Stato = 'in ordine'
                                            AND C.DataArrivo >=
                                                cData - INTERVAL 3 DAY))
                                    AND (C.Aspetto OR (NOT cPrimario)));
        
        IF qtaDisponibile < (cDose * StimaOrdini) THEN
            RETURN FALSE;
        END IF;
    END LOOP loop_lbl;
    
    CLOSE curIngredienti;
    
    RETURN TRUE;
END;$$

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

CREATE PROCEDURE AnalizzaRecensioni()
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    TRUNCATE TABLE Report_PiattiPreferiti;
    
    INSERT INTO Report_PiattiPreferiti(Posizione, Sede, Ricetta, GiudizioTotale,
                                                            NumeroRecensioni)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT R.Sede, R.Ricetta,
                SUM(R.Giudizio)*IF(SUM(R.NumeroValutazioni) = 0, 6, ROUND(
            AVG((R.VeridicitaTotale + R.AccuratezzaTotale)/R.NumeroValutazioni))
                ) AS GiudizioTotale, COUNT(*) AS NumeroRecensioni
            FROM Recensione R
            GROUP BY R.Sede, R.Ricetta
        ) AS D
    ORDER BY D.GiudizioTotale/D.NumeroRecensioni DESC;
END;$$

CREATE PROCEDURE AnalizzaVendite(IN inizio TIMESTAMP, IN fine TIMESTAMP)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    IF inizio IS NULL THEN
        SET inizio = '1970-01-01 00:00:01';
    END IF;
    IF fine IS NULL THEN
        SET fine = CURRENT_TIMESTAMP;
    END IF;
    
    TRUNCATE TABLE Report_VenditePiatti;
    
    INSERT INTO Report_VenditePiatti(Posizione, Sede, Ricetta, Vendite)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT C.Sede, P.Ricetta, COUNT(*) AS Vendite
            FROM Piatto P INNER JOIN Comanda C ON P.Comanda = C.ID
            WHERE C.`Timestamp` BETWEEN inizio AND fine
            GROUP BY C.Sede, P.Ricetta
        ) AS D
    ORDER BY D.Vendite DESC;
END;$$

CREATE PROCEDURE AnalizzaSuggerimenti()
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    TRUNCATE TABLE Report_SuggerimentiMigliori;
    
    INSERT INTO Report_SuggerimentiMigliori(Posizione, Suggerimento,
                                            GradimentoTotale, NumeroGradimenti)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT G.Suggerimento, SUM(G.Punteggio) AS GradimentoTotale,
                                                    COUNT(*) AS NumeroGradimenti
            FROM Gradimento G
            WHERE G.Suggerimento IS NOT NULL
            GROUP BY G.Suggerimento
        ) AS D
    ORDER BY D.GradimentoTotale/D.NumeroGradimenti DESC;
END;$$

CREATE PROCEDURE AnalizzaProposte()
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    TRUNCATE TABLE Report_ProposteMigliori;
    
    INSERT INTO Report_ProposteMigliori(Posizione, Proposta, GradimentoTotale,
                                                               NumeroGradimenti)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT G.Proposta, SUM(G.Punteggio) AS GradimentoTotale,
                                                    COUNT(*) AS NumeroGradimenti
            FROM Gradimento G
            WHERE G.Proposta IS NOT NULL
            GROUP BY G.Proposta
        ) AS D
    ORDER BY D.GradimentoTotale/D.NumeroGradimenti DESC;
END;$$

CREATE PROCEDURE AnalizzaSprechi(IN inizio TIMESTAMP, IN fine TIMESTAMP)
NOT DETERMINISTIC MODIFIES SQL DATA
BEGIN
    IF inizio IS NULL THEN
        SET inizio = '1970-01-01 00:00:01';
    END IF;
    IF fine IS NULL THEN
        SET fine = CURRENT_TIMESTAMP;
    END IF;
    
    TRUNCATE TABLE Report_Sprechi;
    
    BEGIN
        DECLARE NomeSede VARCHAR(45);
        DECLARE NomeIngrediente VARCHAR(45);
        DECLARE Scaricata INT;
        DECLARE Quantita INT;
        DECLARE Finito BOOL DEFAULT FALSE;
        DECLARE curScarichi CURSOR FOR
            SELECT SL.Sede, SL.Ingrediente, COALESCE(SUM(SL.Quantita), 0) AS Qta
            FROM Scarichi_Log SL
            WHERE SL.`Timestamp` BETWEEN inizio AND fine
            GROUP BY SL.Sede, SL.Ingrediente;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
        
        OPEN curScarichi;
        
        loop_lbl: LOOP
            FETCH curScarichi INTO NomeSede, NomeIngrediente, Scaricata;
            IF Finito THEN
                LEAVE loop_lbl;
            END IF;
            
            SET Quantita = (
            SELECT COALESCE(SUM(F.Dose), 0) AS Quantita
            FROM Fase F
                INNER JOIN Ricetta R ON F.Ricetta = R.Nome
                INNER JOIN Piatto P ON R.Nome = P.Ricetta
                INNER JOIN Comanda C ON P.Comanda = C.ID
            WHERE C.Sede = NomeSede
                AND F.Ingrediente = NomeIngrediente
                AND C.`Timestamp` BETWEEN inizio AND fine
                AND F.ID NOT IN (SELECT MF.FaseVecchia
                                FROM ModificaFase MF
                                    INNER JOIN Variazione V
                                        ON MF.Variazione = V.ID
                                    INNER JOIN
                                    (SELECT M.Variazione
                                    FROM Modifica M
                                    WHERE M.Piatto = P.ID) AS D
                                        ON V.ID = D.Variazione)
                AND F.ID NOT IN (SELECT MFN.FaseNuova
                                FROM ModificaFase MFN
                                    INNER JOIN Variazione VA
                                        ON MFN.Variazione = VA.ID
                                WHERE VA.ID NOT IN (SELECT MO.Variazione
                                                    FROM Modifica MO
                                                    WHERE MO.Piatto = P.ID))                                        
            );
            
            INSERT INTO Report_Sprechi(Sede, Ingrediente, Spreco)
            VALUES (NomeSede, NomeIngrediente, Scaricata - Quantita);
            
        END LOOP loop_lbl;
        
        CLOSE curScarichi;
    END;
END;$$  


-- TRIGGERS
SELECT "Creazione triggers." AS "***** FASE 8 ******";

CREATE TRIGGER nuova_sede
AFTER INSERT
ON Sede
FOR EACH ROW
BEGIN
    INSERT INTO Clienti_Log(Sede, Anno, Mese) VALUES
        (NEW.Nome, YEAR(CURRENT_DATE), MONTH(CURRENT_DATE));
END;$$

CREATE TRIGGER nuovo_magazzino
BEFORE INSERT
ON Magazzino
FOR EACH ROW
BEGIN
    -- Simula AUTO_INCREMENT
    IF NEW.ID IS NULL THEN
        SET NEW.ID = (SELECT IFNULL(MAX(ID), 0) + 1
                            FROM Magazzino
                            WHERE Sede = NEW.Sede);
    END IF;
END;$$

CREATE TRIGGER nuova_confezione
BEFORE INSERT
ON Confezione
FOR EACH ROW
BEGIN
    -- Simula AUTO_INCREMENT
    IF NEW.Numero IS NULL THEN
        SET NEW.Numero = (SELECT IFNULL(MAX(Numero), 0) + 1
                            FROM Confezione
                            WHERE CodiceLotto = NEW.CodiceLotto);
    END IF;
                        
    IF NEW.DataCarico IS NOT NULL THEN
        IF NEW.DataCarico < NEW.DataAcquisto THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DataCarico precedente a DataAcquisto.';
        END IF;
        IF NEW.Collocazione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Collocazione non può essere NULL.';
        END IF;
        IF NEW.Aspetto IS NULL THEN
            SET NEW.Aspetto = TRUE; -- Default: nessun danno
        END IF;
        IF NEW.Stato IS NULL THEN
            SET NEW.Stato = 'completa'; -- Default
        END IF;
    ELSE
        IF (NEW.Stato <> 'in ordine') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo DataCarico non può essere NULL.';
        ELSEIF (NEW.Collocazione IS NOT NULL
            OR NEW.Aspetto IS NOT NULL) THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'DataCarico, Collocazione e Aspetto devono '
                                    'essere tutti NULL o tutti non-NULL.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER aggiorna_confezione
BEFORE UPDATE
ON Confezione
FOR EACH ROW
BEGIN
    IF NEW.DataCarico IS NOT NULL THEN
        IF NEW.DataCarico < NEW.DataAcquisto THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'DataCarico precedente a DataAcquisto.';
        END IF;
        IF NEW.Collocazione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Collocazione non può essere NULL.';
        END IF;
        IF NEW.Aspetto IS NULL THEN
            SET NEW.Aspetto = TRUE; -- Default: nessun danno
        END IF;
    ELSE
        IF (NEW.Stato <> 'in ordine') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo DataCarico non può essere NULL.';
        ELSEIF (NEW.Collocazione IS NOT NULL
            OR NEW.Aspetto IS NOT NULL) THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'DataCarico, Collocazione e Aspetto devono '
                                    'essere tutti NULL o tutti non-NULL.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER elimina_lotto_confezione
AFTER DELETE
ON Confezione
FOR EACH ROW
BEGIN
    DECLARE LottoPresente BOOL;
    DECLARE IngScaricato VARCHAR(45);
    
    SET LottoPresente = (SELECT COUNT(*) > 0
                        FROM Confezione C
                        WHERE C.CodiceLotto = OLD.CodiceLotto);
    
    IF NOT LottoPresente THEN
        DELETE FROM Lotto WHERE Codice = OLD.CodiceLotto;
    END IF;
    
    IF OLD.Stato = 'in uso' THEN
        SET IngScaricato = (SELECT L.Ingrediente
                            FROM Lotto L
                            WHERE L.Codice = OLD.CodiceLotto);
                            
        INSERT INTO Scarichi_Log(Sede, Magazzino, Ingrediente, Quantita)
        VALUES (OLD.Sede, OLD.Magazzino, IngScaricato, OLD.Peso)
        ON DUPLICATE KEY
            UPDATE Quantita = Quantita + OLD.Peso;
    END IF;
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
        VALUES (NEW.Sede, NEW.Magazzino, IngScaricato, OLD.Peso - NEW.Peso)
        ON DUPLICATE KEY
            UPDATE Quantita = Quantita + (OLD.Peso - NEW.Peso);
    END IF;
END;$$

CREATE TRIGGER nuovo_menu
BEFORE INSERT
ON Menu
FOR EACH ROW
BEGIN
    DECLARE MenuAttiviPeriodo BOOL;
    
    IF NEW.DataFine <= NEW.DataInizio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DataFine precedente a DataInizio.';
    END IF;

    SET MenuAttiviPeriodo = (SELECT COUNT(*) > 0
                                FROM Menu M
                                WHERE M.Sede = NEW.Sede
                                    AND M.DataFine >= NEW.DataInizio
                                    AND M.DataInizio <= NEW.DataFine);
            
    IF MenuAttiviPeriodo THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un menu è già attivo in questo periodo.';
    END IF;
END;$$

CREATE TRIGGER nuovo_elenco
BEFORE INSERT
ON Elenco
FOR EACH ROW
BEGIN
    SET NEW.Novita = (SELECT (COUNT(*) = 0) AS PrimaVolta
                        FROM MV_OrdiniRicetta MVOR
                        WHERE MVOR.Ricetta = NEW.Ricetta
                            AND MVOR.Sede = (SELECT M.Sede
                                                FROM Menu M
                                                WHERE M.ID = NEW.Menu));
END;$$

CREATE TRIGGER controllo_ingredienti
AFTER INSERT
ON Elenco
FOR EACH ROW
BEGIN
    DECLARE cSede VARCHAR(45);
    DECLARE cData DATE;
    
    SELECT M.Sede, M.DataInizio INTO cSede, cData
    FROM Menu M
    WHERE M.ID = NEW.Menu;

    IF NOT IngredientiDisponibili(cSede, NEW.Ricetta, NEW.Novita, cData) THEN
        SIGNAL SQLSTATE '01000' -- Warning
        SET MESSAGE_TEXT = 'La ricetta potrebbe non comparire nel menu in '
                            'quanto potrebbe non esserci una quantità '
                            'sufficiente di ingredienti.';
    END IF;
END;$$

CREATE TRIGGER nuova_fase
BEFORE INSERT
ON Fase
FOR EACH ROW
BEGIN
    IF NEW.Ingrediente IS NOT NULL THEN
        SET NEW.Durata = NULL;
        SET NEW.Testo = NULL;
        IF NEW.Strumento IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una fase può impiegare o uno strumento o un '
                                'ingrediente. Non entrambi.';
        END IF;
        IF NEW.Dose IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Dose deve essere specificato.';
        END IF;
        IF NEW.Primario IS NULL THEN
            SET NEW.Primario = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Dose = NULL;
        SET NEW.Primario = NULL;
        
        IF NEW.Durata IS NULL THEN
            SET NEW.Durata = '00:00:00'; -- Default
        END IF;
        IF NEW.Testo IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Testo deve essere specificato.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER aggiorna_fase
BEFORE UPDATE
ON Fase
FOR EACH ROW
BEGIN
    IF NEW.Ingrediente IS NOT NULL THEN
        SET NEW.Durata = NULL;
        SET NEW.Testo = NULL;
        IF NEW.Strumento IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Una fase può impiegare o uno strumento o un '
                                'ingrediente. Non entrambi.';
        END IF;
        IF NEW.Dose IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Dose deve essere specificato.';
        END IF;
        IF NEW.Primario IS NULL THEN
            SET NEW.Primario = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Dose = NULL;
        SET NEW.Primario = NULL;
        
        IF NEW.Durata = NULL THEN
            SET NEW.Durata = '00:00:00'; -- Default
        END IF;
        IF NEW.Testo = NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'L\'attributo Testo deve essere '
                                'specificato.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER nuova_sequenza_fasi
BEFORE INSERT
ON SequenzaFasi
FOR EACH ROW
BEGIN
    DECLARE StessaRicetta BOOL;
    SET StessaRicetta = (SELECT COUNT(*) > 0
                            FROM (SELECT F1.ID, F1.Ricetta
                                    FROM Fase F1
                                    WHERE F1.ID = NEW.Fase) AS Fase1
                            INNER JOIN
                                (SELECT F2.ID, F2.Ricetta
                                    FROM Fase F2
                                    WHERE F2.ID = NEW.FasePrecedente) AS Fase2
                            ON Fase1.Ricetta = Fase2.Ricetta);
    
    IF NOT StessaRicetta THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le due fasi non appartengono alla stessa ricetta.';
    END IF;
END;$$

CREATE TRIGGER aggiorna_sequenza_fasi
BEFORE UPDATE
ON SequenzaFasi
FOR EACH ROW
BEGIN
    DECLARE StessaRicetta BOOL;
    SET StessaRicetta = (SELECT COUNT(*) > 0
                            FROM (SELECT F1.ID, F1.Ricetta
                                    FROM Fase F1
                                    WHERE F1.ID = NEW.Fase) AS Fase1
                            INNER JOIN
                                (SELECT F2.ID, F2.Ricetta
                                    FROM Fase F2
                                    WHERE F2.ID = NEW.FasePrecedente) AS Fase2
                            ON Fase1.Ricetta = Fase2.Ricetta);
    
    IF NOT StessaRicetta THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le due fasi non appartengono alla stessa ricetta.';
    END IF;
END;$$

CREATE TRIGGER nuova_sala
BEFORE INSERT
ON Sala
FOR EACH ROW
BEGIN
    -- Simula AUTO_INCREMENT
    IF NEW.Numero IS NULL THEN
        SET NEW.Numero = (SELECT IFNULL(MAX(Numero), 0) + 1
                            FROM Sala
                            WHERE Sede = NEW.Sede);
    END IF;
END;$$

CREATE TRIGGER nuovo_tavolo
BEFORE INSERT
ON Tavolo
FOR EACH ROW
BEGIN
    -- Simula AUTO_INCREMENT
    IF NEW.Numero IS NULL THEN
        SET NEW.Numero = (SELECT IFNULL(MAX(Numero), 0) + 1
                            FROM Tavolo
                            WHERE Sede = NEW.Sede
                                AND Sala = NEW.Sala);
    END IF;
END;$$

CREATE TRIGGER nuova_comanda
BEFORE INSERT
ON Comanda
FOR EACH ROW
BEGIN
    IF (NEW.Account IS NOT NULL
            AND (NEW.Tavolo IS NOT NULL OR NEW.Sala IS NOT NULL))
        OR (NEW.Account IS NULL AND NEW.Tavolo IS NULL
                                AND NEW.Sala IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una comanda deve essere o da tavolo o take-away. '
                            'Non entrambe.';
    END IF;
END;$$

CREATE TRIGGER aggiorna_comanda
BEFORE UPDATE
ON Comanda
FOR EACH ROW
BEGIN
    IF (NEW.Account IS NOT NULL
            AND (NEW.Tavolo IS NOT NULL OR NEW.Sala IS NOT NULL))
        OR (NEW.Account IS NULL AND NEW.Tavolo IS NULL
                                AND NEW.Sala IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una comanda deve essere o da tavolo o take-away. '
                            'Non entrambe.';
    END IF;
END;$$

CREATE TRIGGER assegna_pony
AFTER UPDATE
ON Piatto
FOR EACH ROW
BEGIN
    DECLARE NumeroPiatti INT;
    DECLARE SedeComanda VARCHAR(45);
    DECLARE PonyScelto INT;
    
    IF StatoComanda(NEW.Comanda) = 'consegna' THEN
        SET SedeComanda = (SELECT C.Account <> NULL, C.Sede
                            FROM Comanda C
                            WHERE C.ID = NEW.Comanda);
                                
        SET NumeroPiatti = (SELECT COUNT(*)
                            FROM Piatto P
                            WHERE P.Comanda = NEW.Comanda);
                            
        SET PonyScelto = (SELECT P.ID
                            FROM Pony P
                            WHERE P.Sede = SedeComanda
                                AND P.Stato = 'libero'
                                AND Ruote = (NumeroPiatti > 5)
                            LIMIT 1);
                         
        IF PonyScelto IS NULL THEN
            SET PonyScelto = (SELECT P.ID
                                FROM Pony P
                                WHERE P.Sede = SedeComanda
                                    AND P.Stato = 'libero'
                                LIMIT 1);
        END IF;
        
        IF PonyScelto IS NULL THEN
            SIGNAL SQLSTATE '01000' -- Warning
            SET MESSAGE_TEXT = 'Nessun Pony è stato assegnato in '
                                'quanto sono tutti occupati.';
        ELSE
            INSERT INTO Consegna(Comanda, Sede, Pony, Arrivo, Ritorno)
            VALUES (NEW.Comanda, SedeComanda, PonyScelto, NULL, NULL);
        END IF;
    END IF;
END;$$

CREATE TRIGGER nuova_variazione
BEFORE INSERT
ON Variazione
FOR EACH ROW
BEGIN
    IF (NEW.Nome IS NOT NULL AND NEW.Account IS NOT NULL)
        OR (NEW.Nome IS NULL AND NEW.Account IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una variazione deve essere una variazione '
                            'dagli chef (con nome) o un suggerimento inviato '
                            'da un account utente (senza nome).';
    END IF;
END;$$

CREATE TRIGGER aggiorna_variazione
BEFORE UPDATE
ON Variazione
FOR EACH ROW
BEGIN
    IF (NEW.Nome IS NOT NULL AND NEW.Account IS NOT NULL)
        OR (NEW.Nome IS NULL AND NEW.Account IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una variazione deve essere una variazione '
                            'dagli chef (con nome) o un suggerimento inviato '
                            'da un account utente (senza nome).';
    END IF;
END;$$

CREATE TRIGGER nuova_modificafase
BEFORE INSERT
ON ModificaFase
FOR EACH ROW
BEGIN
    DECLARE RicettaFaseNuova VARCHAR(45);
    DECLARE RicettaFaseVecchia VARCHAR(45);
    DECLARE RicettaVariazione VARCHAR(45);
    DECLARE FaseInAggiunta BOOL;
    DECLARE FaseInEliminazione BOOL;
    
    IF NEW.FaseNuova IS NULL AND NEW.FaseVecchia IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FaseNuova o FaseVecchia devono essere specificati.';
    END IF;
    
    SET RicettaVariazione = (SELECT V.Ricetta FROM Variazione V
                                WHERE V.ID = NEW.Variazione);
    
    IF NEW.FaseNuova IS NOT NULL THEN
        SET RicettaFaseNuova = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseNuova);
        
        IF RicettaFaseNuova <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseNuova deve corrispondere '
                                'alla ricetta della variazione.';
        END IF;
        
        SET FaseInEliminazione = (SELECT COUNT(*) > 0
                                    FROM ModificaFase MF
                                    WHERE MF.FaseVecchia = NEW.FaseNuova);
        
        IF FaseInEliminazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La fase inserita come FaseNuova viene '
                                'già eliminata da un\'altra ModificaFase. Una '
                                'fase può essere solo aggiunta o rimossa dalle '
                                'ModificaFase.';
        END IF;
    END IF;
    
    IF NEW.FaseVecchia IS NOT NULL THEN
        SET RicettaFaseVecchia = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseVecchia);
                                    
        IF RicettaFaseVecchia <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia deve corrispondere '
                                'alla ricetta della variazione.';
        ELSEIF RicettaFaseNuova IS NOT NULL
            AND RicettaFaseNuova <> RicettaFaseVecchia THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia e quella di '
                                'FaseNuova devono corrispondere.';
        END IF;
        
        SET FaseInAggiunta = (SELECT COUNT(*) > 0
                                    FROM ModificaFase MF
                                    WHERE MF.FaseNuova = NEW.FaseVecchia);
        
        IF FaseInAggiunta THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La fase inserita come FaseVecchia viene '
                                'già aggiunta da un\'altra ModificaFase. Una '
                                'fase può essere solo aggiunta o rimossa dalle '
                                'ModificaFase.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER aggiorna_modificafase
BEFORE UPDATE
ON ModificaFase
FOR EACH ROW
BEGIN
    DECLARE RicettaFaseNuova VARCHAR(45);
    DECLARE RicettaFaseVecchia VARCHAR(45);
    DECLARE RicettaVariazione VARCHAR(45);
    DECLARE FaseInAggiunta BOOL;
    DECLARE FaseInEliminazione BOOL;
    
    IF NEW.FaseNuova IS NULL AND NEW.FaseVecchia IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FaseNuova o FaseVecchia devono essere specificati.';
    END IF;
    
    SET RicettaVariazione = (SELECT V.Ricetta FROM Variazione V
                                WHERE V.ID = NEW.Variazione);
    
    IF NEW.FaseNuova IS NOT NULL THEN
        SET RicettaFaseNuova = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseNuova);
        
        IF RicettaFaseNuova <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseNuova deve corrispondere '
                                'alla ricetta della variazione.';
        END IF;
        
        SET FaseInEliminazione = (SELECT COUNT(*) > 0
                                    FROM ModificaFase MF
                                    WHERE MF.FaseVecchia = NEW.FaseNuova);
        
        IF FaseInEliminazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La fase inserita come FaseNuova viene '
                                'già eliminata da un\'altra ModificaFase. Una '
                                'fase può essere solo aggiunta o rimossa dalle '
                                'ModificaFase.';
        END IF;
    END IF;
    
    IF NEW.FaseVecchia IS NOT NULL THEN
        SET RicettaFaseVecchia = (SELECT F.Ricetta FROM Fase F
                                    WHERE F.ID = NEW.FaseVecchia);
                                    
        IF RicettaFaseVecchia <> RicettaVariazione THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia deve corrispondere '
                                'alla ricetta della variazione.';
        ELSEIF RicettaFaseNuova IS NOT NULL
            AND RicettaFaseNuova <> RicettaFaseVecchia THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La ricetta di FaseVecchia e quella di '
                                'FaseNuova devono corrispondere.';
        END IF;
        
        SET FaseInAggiunta = (SELECT COUNT(*) > 0
                                    FROM ModificaFase MF
                                    WHERE MF.FaseNuova = NEW.FaseVecchia);
        
        IF FaseInAggiunta THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La fase inserita come FaseVecchia viene '
                                'già aggiunta da un\'altra ModificaFase. Una '
                                'fase può essere solo aggiunta o rimossa dalle '
                                'ModificaFase.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER nuova_modifica
BEFORE INSERT
ON Modifica
FOR EACH ROW
BEGIN
    DECLARE Suggerimento BOOL;
    DECLARE NumVariazioni INT;
    DECLARE StessaRicetta BOOL;
    
    SET Suggerimento = (SELECT V.Account IS NOT NULL
                        FROM Variazione V
                        WHERE V.ID = NEW.Variazione);
    
    IF Suggerimento THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo le variazioni selezionate dagli chef possono '
                            'essere selezionate, non i suggerimenti.';
    END IF;
    
    SET NumVariazioni = (SELECT COUNT(*)
                            FROM Modifica M
                            WHERE M.Piatto = NEW.Piatto);
    
    IF NumVariazioni >= 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ci sono già 3 variazioni su questo piatto.';
    END IF;
    
    SET StessaRicetta = (SELECT COUNT(*) > 0
                            FROM (SELECT P.ID, P.Ricetta
                                    FROM Piatto P
                                    WHERE P.ID = NEW.Piatto) AS Pi
                            INNER JOIN
                                (SELECT V.ID, V.Ricetta
                                    FROM Variazione V
                                    WHERE V.ID = NEW.Variazione) AS Va
                            ON Pi.Ricetta = Va.Ricetta);
    
    IF NOT StessaRicetta THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La variazione selezionata non è applicabile al '
                            'piatto scelto.';
    END IF;
END;$$

CREATE TRIGGER nuovo_pony
BEFORE INSERT
ON Pony
FOR EACH ROW
BEGIN
    -- Simula AUTO_INCREMENT
    IF NEW.ID IS NULL THEN
        SET NEW.ID = (SELECT IFNULL(MAX(ID), 0) + 1
                            FROM Pony
                            WHERE Sede = NEW.Sede);
    END IF;
END;$$

CREATE TRIGGER nuova_consegna
BEFORE INSERT
ON Consegna
FOR EACH ROW
BEGIN
    UPDATE Pony SET Stato = 'occupato'
        WHERE Sede = NEW.Sede
            AND ID = NEW.Pony;
    
    -- Le nuove consegne non devono avere mai Arrivo e Ritorno.
    SET NEW.Arrivo = NULL;
    SET NEW.Ritorno = NULL;
END;$$

CREATE TRIGGER aggiorna_consegna
BEFORE UPDATE
ON Consegna
FOR EACH ROW
BEGIN
    IF NEW.Arrivo IS NOT NULL AND NEW.Arrivo < NEW.Partenza THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Arrivo precedente a partenza.';
    ELSEIF NEW.Arrivo IS NULL AND NEW.Ritorno IS NOT NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Se Ritorno viene specificato anche Arrivo deve '
                                'essere specificato.';
    END IF;
            
    
    IF NEW.Ritorno IS NOT NULL THEN
        IF OLD.Arrivo IS NOT NULL AND OLD.Arrivo = NEW.Arrivo THEN
            -- Evita ON UPDATE CURRENT_TIMESTAMP
            SET NEW.Arrivo = OLD.Arrivo;
        END IF;
        IF NEW.Ritorno < NEW.Arrivo THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ritorno precedente a arrivo.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER libera_pony
AFTER UPDATE
ON Consegna
FOR EACH ROW
BEGIN
    IF NEW.Ritorno IS NOT NULL AND OLD.Ritorno IS NULL THEN
        UPDATE Pony SET Stato = 'libero' WHERE Sede = NEW.Sede
                                            AND ID = NEW.Pony;
    END IF;
END;$$

CREATE TRIGGER nuova_prenotazione
BEFORE INSERT
ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE PrenotazioniAbilitate BOOL;
    DECLARE PostiTavolo INT;
    DECLARE TavoloLibero BOOL;
    DECLARE SalaLibera BOOL;
    DECLARE TavoloAssegnato INT;
    DECLARE SalaAssegnata INT;
    
    IF CURRENT_DATETIME > (NEW.`Data` - INTERVAL 1 DAY) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Una prenotazione deve essere effettuata almeno un '
                            'giorno prima della data scelta.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        SET PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
    END IF;
    
    IF NEW.Account IS NOT NULL THEN
        SET PrenotazioniAbilitate = (SELECT A.PuoPrenotare
                                        FROM Account A
                                        WHERE A.Username = NEW.Account);
                                        
        IF NOT PrenotazioniAbilitate THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prenotazioni disabilitate per l\'account.';
        END IF;
        
        SET NEW.Telefono = NULL;
        IF NEW.Tavolo IS NOT NULL THEN
            SET NEW.Nome = NULL;
            SET NEW.Descrizione = NULL;
            SET NEW.Approvato = NULL;
            
            IF PostiTavolo > NEW.Numero + 3 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                                    'di posti.';
            END IF;
        ELSEIF NEW.Nome IS NULL THEN
            SET NEW.Descrizione = NULL;
            SET NEW.Approvato = NULL;
            
            -- Assegna Tavolo
            SELECT T.Numero, T.Sala INTO TavoloAssegnato, SalaAssegnata
            FROM Tavolo T
            WHERE T.Numero NOT IN (
                SELECT P1.Tavolo
                FROM Prenotazione P1
                WHERE P1.`Data` >
                    (NEW.`Data` - INTERVAL 2 HOUR)
                    AND P1.`Data` <
                        (NEW.`Data` + INTERVAL 2 HOUR))
                AND T.Sala NOT IN (
                    SELECT P2.Sala
                    FROM Prenotazione P2
                    WHERE P2.`Data` <
                        (NEW.`Data` - INTERVAL 2 HOUR)
                        AND P2.`Data` >
                            (NEW.`Data` + INTERVAL 2 HOUR)
                    AND P2.Tavolo = NULL)
                AND T.Posti BETWEEN NEW.Numero
                                AND (NEW.Numero + 3)
            ORDER BY T.Posti ASC
            LIMIT 1;            
                                    
            IF TavoloAssegnato IS NULL THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Non ci sono tavoli liberi per questo '
                                    'numero di persone.';
            END IF;
            
            SET NEW.Tavolo = TavoloAssegnato;
            SET NEW.Sala = SalaAssegnata;
            
        ELSEIF NEW.Descrizione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Descrizione deve essere specificato per gli '
                                'allestimenti.';
        ELSEIF NEW.Approvato IS NULL THEN
            SET NEW.Approvato = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Descrizione = NULL;
        SET NEW.Approvato = NULL;
        IF NEW.Nome IS NULL OR NEW.Telefono IS NULL OR NEW.Tavolo IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome, Telefono e Tavolo devono essere '
                                'specificati per le prenotazioni telefoniche.';
        END IF;
    END IF;    

    SET SalaLibera = (SELECT SUM(DATE(P.`Data`) = DATE(NEW.`Data`)) > 0
                        FROM Prenotazione P
                        WHERE P.Sala = NEW.Sala
                            AND P.Sede = NEW.Sede
                            AND P.Tavolo = NULL);
                        
    IF SalaLibera THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala scelta è già prenotata per un '
                            'allestimento.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
    
        IF PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                            'di posti.';
        END IF;

        SET TavoloLibero = (SELECT SUM(P.`Data` >
                                            (NEW.`Data` - INTERVAL 2 HOUR)
                                            AND P.`Data` <
                                            (NEW.`Data` + INTERVAL 2 HOUR)) = 0
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo
                                AND P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);

        IF NOT TavoloLibero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    ELSE
        SET SalaLibera = (SELECT SUM(DATE(P.`Data`) = DATE(NEW.`Data`)) = 0
                            FROM Prenotazione P
                            WHERE P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);
                            
        IF NOT SalaLibera THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala contiene tavoli già prenotati.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER aggiorna_prenotazione
BEFORE UPDATE
ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE PostiTavolo INT;
    DECLARE TavoloLibero BOOL;
    DECLARE SalaLibera BOOL;
    
   	IF CURRENT_DATETIME > (OLD.`Data` - INTERVAL 2 DAY) THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile modificare la prenotazione.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        SET PostiTavolo = (SELECT T.Posti
                            FROM Tavolo T
                            WHERE T.ID = NEW.Tavolo
                                AND T.Sala = NEW.Sala
                                AND T.Sede = NEW.Sede);
    END IF;
    
    IF NEW.Account IS NOT NULL THEN
        SET NEW.Telefono = NULL;
        IF NEW.Tavolo IS NOT NULL THEN
            SET NEW.Nome = NULL;
            SET NEW.Descrizione = NULL;
            SET NEW.Approvato = NULL;
            
            IF PostiTavolo > NEW.Numero + 3 THEN
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                                    'di posti.';
            END IF;
        ELSEIF NEW.Nome IS NULL OR NEW.Descrizione IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome e Descrizione devono essere specificati '
                                'per gli allestimenti.';
        ELSEIF NEW.Approvato IS NULL THEN
            SET NEW.Approvato = FALSE; -- Default
        END IF;
    ELSE
        SET NEW.Descrizione = NULL;
        SET NEW.Approvato = NULL;
        IF NEW.Nome IS NULL OR NEW.Telefono IS NULL OR NEW.Tavolo IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome, Telefono e Tavolo devono essere '
                                'specificati per le prenotazioni telefoniche.';
        END IF;
    END IF;    

    SET SalaLibera = (SELECT SUM(DATE(P.`Data`) = DATE(NEW.`Data`)) > 0
                        FROM Prenotazione P
                        WHERE P.Sala = NEW.Sala
                            AND P.Sede = NEW.Sede
                            AND P.Tavolo = NULL);
                        
    IF SalaLibera THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La sala scelta è già prenotata per un '
                            'allestimento.';
    END IF;
    
    IF NEW.Tavolo IS NOT NULL THEN
        IF PostiTavolo < NEW.Numero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto non ha un numero adeguato '
                            'di posti.';
        END IF;

        SET TavoloLibero = (SELECT SUM(P.`Data` >
                                            (NEW.`Data` - INTERVAL 2 HOUR)
                                            AND P.`Data` <
                                            (NEW.`Data` + INTERVAL 2 HOUR)) = 0
                            FROM Prenotazione P
                            WHERE P.Tavolo = NEW.Tavolo
                                AND P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);

        IF NOT TavoloLibero THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il tavolo scelto è già prenotato.';
        END IF;
    ELSE
        SET SalaLibera = (SELECT SUM(DATE(P.`Data`) = DATE(NEW.`Data`)) = 0
                            FROM Prenotazione P
                            WHERE P.Sala = NEW.Sala
                                AND P.Sede = NEW.Sede);
                            
        IF NOT SalaLibera THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La sala contiene tavoli già prenotati.';
        END IF;
    END IF;
END;$$

CREATE TRIGGER elimina_prenotazione
BEFORE DELETE
ON Prenotazione
FOR EACH ROW
BEGIN
   	IF CURRENT_DATETIME > (OLD.`Data` - INTERVAL 3 DAY) THEN
   	    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile annullare la prenotazione.';
    END IF;
END;$$

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

CREATE TRIGGER nuovo_gradimento
BEFORE INSERT
ON Gradimento
FOR EACH ROW
BEGIN
    IF (NEW.Proposta IS NOT NULL AND NEW.Suggerimento IS NOT NULL)
        OR (NEW.Proposta IS NULL AND NEW.Suggerimento IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un gradimento deve riferirsi a una proposta o a '
                            'un suggerimento. Non ad entrambi.';
    END IF;
    
    IF NEW.Punteggio < 1 OR NEW.Punteggio > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Punteggio deve essere compreso tra 1 e 5';
    END IF;
END;$$

CREATE TRIGGER nuova_recensione
BEFORE INSERT
ON Recensione
FOR EACH ROW
BEGIN
    IF NEW.Giudizio < 1 OR NEW.Giudizio > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Giudizio deve essere compreso tra 1 e 5';
    END IF;
END;$$

CREATE TRIGGER nuova_valutazione
BEFORE INSERT
ON Valutazione
FOR EACH ROW
BEGIN
    IF NEW.Veridicita < 1 OR NEW.Veridicita > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Veridicita deve essere compreso tra 1 e 5';
    END IF;
    IF NEW.Accuratezza < 1 OR NEW.Accuratezza > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Accuratezza deve essere compreso tra 1 e 5';
    END IF;
END;$$

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

CREATE TRIGGER nuova_risposta
BEFORE INSERT
ON Risposta
FOR EACH ROW
BEGIN
    IF NEW.Efficienza < 1 OR NEW.Efficienza > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Efficienza deve essere compreso tra 1 e 5';
    END IF;
    
    -- Simula AUTO_INCREMENT
    IF NEW.Numero IS NULL THEN
        SET NEW.Numero = (SELECT IFNULL(MAX(Numero), 0) + 1
                            FROM Risposta
                            WHERE Domanda = NEW.Domanda);
    END IF;
END;$$


-- EVENTS
SELECT "Creazione events." AS "**** FASE 9 *****";

CREATE EVENT aggiorna_MV_OrdiniRicetta_MenuCorrente
ON SCHEDULE
EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 2 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE cSede VARCHAR(45);
    DECLARE cRicetta VARCHAR(45);
    DECLARE cOrdini INT;
    DECLARE cNovita BOOL;
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE curPiatto CURSOR FOR
        SELECT C.Sede, P.Ricetta, COUNT(*) AS Ordini
        FROM Piatto P INNER JOIN Comanda C ON P.Comanda = C.ID
        WHERE DATE(C.`Timestamp`) = (CURRENT_DATE - INTERVAL 1 DAY)
        GROUP BY C.Sede, P.Ricetta;
    DECLARE curElenco CURSOR FOR
        SELECT M.Sede, E.Ricetta, E.Novita
        FROM Elenco E INNER JOIN Menu M ON E.Menu = M.ID
        WHERE CURRENT_DATE
                    BETWEEN M.DataInizio AND M.DataFine;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
    
    OPEN curPiatto;
    
    loop_lbl: LOOP
        FETCH curPiatto INTO cSede, cRicetta, cOrdini;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        INSERT INTO MV_OrdiniRicetta(Sede, Ricetta, TotOrdini) VALUES
            (cSede, cRicetta, cOrdini)
            ON DUPLICATE KEY
                UPDATE Comparse = Comparse + 1, TotOrdini = TotOrdini + cOrdini;
    END LOOP loop_lbl;
    
    CLOSE curPiatto;
    
    
    
    SET Finito = FALSE;
    TRUNCATE TABLE MV_MenuCorrente; -- full refresh
    OPEN curElenco;
    
    loop2_lbl: LOOP
        FETCH curElenco INTO cSede, cRicetta, cNovita;
        IF Finito THEN
            LEAVE loop2_lbl;
        END IF;
        
        IF IngredientiDisponibili(cSede, cRicetta, cNovita, NULL) THEN
            INSERT INTO MV_MenuCorrente(Sede, Ricetta, Novita) VALUES
                (cSede, cRicetta, cNovita);
        END IF;
    END LOOP loop2_lbl;
    
    CLOSE curElenco;
END;$$

CREATE EVENT aggiorna_elenco_novita
ON SCHEDULE
EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL '1:30' HOUR_MINUTE
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE cSede VARCHAR(45);
    DECLARE cRicetta VARCHAR(45);
    DECLARE RimuoviNovita BOOL;
    DECLARE curMenu CURSOR FOR
        SELECT MC.Sede, MC.Ricetta
        FROM MV_MenuCorrente MC
        WHERE MC.Novita = TRUE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;
    
    OPEN curMenu;
    
    loop_lbl: LOOP
        FETCH curMenu INTO cSede, cRicetta;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        SET RimuoviNovita = (SELECT (COUNT(*) > 4) AS RimuoviNovita
                                FROM MV_OrdiniRicetta MVOR
                                WHERE MVOR.Ricetta = cRicetta
                                    AND MVOR.Sede = cSede);
        IF RimuoviNovita THEN
            UPDATE Elenco E INNER JOIN Menu M ON E.Menu = M.ID
            SET E.Novita = FALSE
            WHERE M.Sede = cSede AND E.Ricetta = cRicetta;
        END IF;
    END LOOP loop_lbl;
    
    CLOSE curMenu;
END;$$

CREATE EVENT Analytics_Scheduler
ON SCHEDULE
EVERY 1 MONTH
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 4 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    CALL AnalizzaRecensioni();
    CALL AnalizzaVendite(CURRENT_TIMESTAMP - INTERVAL 1 MONTH, NULL);
    CALL AnalizzaSuggerimenti();
    CALL AnalizzaProposte();
END;$$

CREATE EVENT Elenco_Ordini
ON SCHEDULE
EVERY 1 WEEK
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 5 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE ClientiPrenotazioni INT;
    DECLARE MediaSenzaPrenotazione INT;
    DECLARE StimaClienti INT;
    DECLARE StimaOrdini INT;
    DECLARE NomeSede VARCHAR(45);
    DECLARE NomeRicetta VARCHAR(45);
    DECLARE RicettaNovita BOOL;
    DECLARE Finito BOOL DEFAULT FALSE;
    DECLARE curRicetta CURSOR FOR
        SELECT M.Sede, E.Ricetta, E.Novita
        FROM Menu M INNER JOIN Elenco E ON M.ID = E.Menu
        WHERE M.DataInizio <= CURRENT_DATE
            AND M.DataFine >= CURRENT_DATE + INTERVAL 6 DAY;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET Finito = TRUE;

    TRUNCATE TABLE Report_Ordinativi;
    
    OPEN curRicetta;
    
    loop_lbl: LOOP
        FETCH curRicetta INTO NomeSede, NomeRicetta, RicettaNovita;
        IF Finito THEN
            LEAVE loop_lbl;
        END IF;
        
        SET ClientiPrenotazioni = (SELECT COALESCE(CP.Numero, 0)
                                    FROM MV_ClientiPrenotazione CP
                                    WHERE CP.Sede = NomeSede
                                        AND CP.`Data` BETWEEN CURRENT_DATE
                                            AND CURRENT_DATE + INTERVAL 6 DAY);
        
        SET MediaSenzaPrenotazione = (
            SELECT CEIL(COALESCE(AVG(CL.SenzaPrenotazione), 0)/4) AS Media
            FROM Clienti_Log CL
            WHERE CL.Sede = NomeSede
                AND CL.Mese = MONTH(CURRENT_DATE)
                AND CL.Anno <> YEAR(CURRENT_DATE)
            );
            
        SET StimaClienti = ClientiPrenotazioni + MediaSenzaPrenotazione;
    
        IF RicettaNovita THEN
            SET StimaOrdini = (SELECT CEIL(StimaClienti * 0.33));
        ELSE
            SET StimaOrdini = (
                SELECT (COALESCE(CEIL(MV.TotOrdini / MV.Comparse), 0)
                            + StimaClienti * 0.1) AS StimaOrdini
                FROM MV_OrdiniRicetta MV
                WHERE MV.Sede = NomeSede AND MV.Ricetta = NomeRicetta
                );
        END IF;
        
        IF StimaOrdini < 5 THEN
            SET StimaOrdini = 5;
        END IF;
                
        INSERT INTO Report_Ordinativi(Sede, Ingrediente, Quantita)
        SELECT NomeSede, F.Ingrediente, SUM(F.Dose)*StimaOrdini AS Qta
        FROM Fase F
        WHERE F.Ricetta = NomeRicetta
        ON DUPLICATE KEY UPDATE Quantita = Quantita + VALUES(Quantita);
    END LOOP loop_lbl;
    
    CLOSE curRicetta;
END;$$

CREATE EVENT aggiorna_Report_TakeAway
ON SCHEDULE
EVERY 1 WEEK
STARTS TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 3 HOUR
ON COMPLETION PRESERVE
DO
BEGIN
    DECLARE TempoMedioAndata INT;
    DECLARE TempoMedioRitorno INT;
    
    TRUNCATE TABLE Report_TakeAway;
    
    SELECT CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Partenza, C.Arrivo))) AS TMAndata,
            CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Arrivo, C.Ritorno))) AS TMRitorno
        INTO TempoMedioAndata, TempoMedioRitorno
    FROM Consegna C
    WHERE C.Ritorno IS NOT NULL;
    
    IF TempoMedioAndata IS NULL OR TempoMedioRitorno IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Dati insufficienti per la generazione di '
                            'Report_TakeAway.';
    END IF;
    
    INSERT INTO Report_TakeAway(Posizione, Sede, Pony, DeltaTempoAndata,
                                                           DeltaTempoRitorno)
    SELECT @row_number := @row_number + 1 AS Posizione, D.*
    FROM (SELECT @row_number := 0) AS N,
        (
            SELECT P.Sede, P.ID AS Pony,
                    SEC_TO_TIME(
                        CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Partenza, C.Arrivo))) -
                        TempoMedioAndata
                        ) AS DeltaTempoAndata,
                    SEC_TO_TIME(
                        CEIL(AVG(TIMESTAMPDIFF(SECOND, C.Arrivo, C.Ritorno))) -
                        TempoMedioRitorno
                        ) AS DeltaTempoRitorno
            FROM Pony P INNER JOIN Consegna C
            WHERE C.Ritorno IS NOT NULL
            GROUP BY P.Sede, P.ID
        ) AS D
    ORDER BY (D.DeltaTempoAndata + D.DeltaTempoRitorno) ASC;
END;$$


DELIMITER ;


-- INSERTS
SELECT "Riempimento tabelle." AS "***** FASE 10 ******";

INSERT INTO Sede(Nome, Citta, CAP, Via, NumeroCivico) VALUES
('Pizzeria da Cecco', 'Milano', 20121, 'Mercato', 3),
('L\'ostrica ubriaca', 'Golfo Aranci', 07020, 'Libertà', 10),
('Il girasole', 'Torino', 10138, 'Giambattista Gropello', 17),
('Il pozzo', 'Milano', 20121, 'S. Carpoforo', 7),
('Ristorante da Giovanni', 'Cagliari', 09127, 'Giardini', 147),
('Ristorante Venezia', 'Viareggio', 55049, 'Michele Coppino', 201),
('Il paiolo magico', 'Livorno', 57125, 'Calzabigi', 13),
('Pizzeria da Gennaro', 'Napoli', 80124, 'Lucio Silla', 67),
('L\'aragosta', 'Viareggio', 57121, 'Piero Gobetti', 10),
('Tatooine', 'Roma', 00165, 'San Francesco di Sales', 16);

INSERT INTO Magazzino(Sede, ID) VALUES
('Pizzeria da Cecco', NULL),            ('L\'ostrica ubriaca', NULL),
('L\'ostrica ubriaca', NULL),           ('Il girasole', NULL),
('Il pozzo', NULL),                     ('Ristorante da Giovanni', NULL),
('Ristorante Venezia', NULL),           ('Ristorante Venezia', NULL),
('Il paiolo magico', NULL),             ('Il paiolo magico', NULL),
('Il paiolo magico', NULL),             ('Pizzeria da Gennaro', NULL),
('L\'aragosta', NULL),                  ('Tatooine', NULL);

INSERT INTO Sala(Sede, Numero) VALUES
('Pizzeria da Cecco', NULL),            ('L\'ostrica ubriaca', NULL),
('L\'ostrica ubriaca', NULL),           ('Il girasole', NULL),
('Il girasole', NULL),                  ('Il pozzo', NULL),
('Ristorante da Giovanni', NULL),       ('Ristorante Venezia', NULL),
('Il paiolo magico', NULL),             ('Il paiolo magico', NULL),
('Il paiolo magico', NULL),             ('Pizzeria da Gennaro', NULL),
('Pizzeria da Gennaro', NULL),          ('Pizzeria da Gennaro', NULL),
('L\'aragosta', NULL),                  ('Tatooine', NULL);

INSERT INTO Tavolo(Sede, Sala, Numero, Posti) VALUES
('Pizzeria da Cecco', 1, NULL, 2),      ('Pizzeria da Cecco', 1, NULL, 2),
('Pizzeria da Cecco', 1, NULL, 2),      ('Pizzeria da Cecco', 1, NULL, 3),
('Pizzeria da Cecco', 1, NULL, 3),      ('Pizzeria da Cecco', 1, NULL, 4),
('Pizzeria da Cecco', 1, NULL, 4),      ('Pizzeria da Cecco', 1, NULL, 4),
('Pizzeria da Cecco', 1, NULL, 6),      ('Pizzeria da Cecco', 1, NULL, 6),
('Pizzeria da Cecco', 1, NULL, 8),      ('Pizzeria da Cecco', 1, NULL, 8),
('Pizzeria da Cecco', 1, NULL, 10),     ('Pizzeria da Cecco', 1, NULL, 12),
('Pizzeria da Cecco', 1, NULL, 12),     ('Pizzeria da Cecco', 1, NULL, 14),
('Pizzeria da Cecco', 1, NULL, 16),     ('L\'ostrica ubriaca', 1, NULL, 2),
('L\'ostrica ubriaca', 1, NULL, 2),     ('L\'ostrica ubriaca', 1, NULL, 2),
('L\'ostrica ubriaca', 1, NULL, 2),     ('L\'ostrica ubriaca', 1, NULL, 2),
('L\'ostrica ubriaca', 1, NULL, 3),     ('L\'ostrica ubriaca', 1, NULL, 3),
('L\'ostrica ubriaca', 1, NULL, 4),     ('L\'ostrica ubriaca', 1, NULL, 4),
('L\'ostrica ubriaca', 1, NULL, 4),     ('L\'ostrica ubriaca', 1, NULL, 4),
('L\'ostrica ubriaca', 1, NULL, 5),     ('L\'ostrica ubriaca', 1, NULL, 6),
('L\'ostrica ubriaca', 1, NULL, 6),     ('L\'ostrica ubriaca', 1, NULL, 10),
('L\'ostrica ubriaca', 1, NULL, 10),    ('L\'ostrica ubriaca', 1, NULL, 14),
('L\'ostrica ubriaca', 1, NULL, 15),    ('L\'ostrica ubriaca', 1, NULL, 16),
('L\'ostrica ubriaca', 1, NULL, 16),    ('L\'ostrica ubriaca', 2, NULL, 2),
('L\'ostrica ubriaca', 2, NULL, 2),     ('L\'ostrica ubriaca', 2, NULL, 2),
('L\'ostrica ubriaca', 2, NULL, 2),     ('L\'ostrica ubriaca', 2, NULL, 2),
('L\'ostrica ubriaca', 2, NULL, 2),     ('L\'ostrica ubriaca', 2, NULL, 3),
('L\'ostrica ubriaca', 2, NULL, 4),     ('L\'ostrica ubriaca', 2, NULL, 4),
('L\'ostrica ubriaca', 2, NULL, 4),     ('L\'ostrica ubriaca', 2, NULL, 4),
('L\'ostrica ubriaca', 2, NULL, 5),     ('L\'ostrica ubriaca', 2, NULL, 5),
('L\'ostrica ubriaca', 2, NULL, 6),     ('L\'ostrica ubriaca', 2, NULL, 6),
('L\'ostrica ubriaca', 2, NULL, 6),     ('L\'ostrica ubriaca', 2, NULL, 8),
('L\'ostrica ubriaca', 2, NULL, 10),    ('L\'ostrica ubriaca', 2, NULL, 12),
('L\'ostrica ubriaca', 2, NULL, 14),    ('L\'ostrica ubriaca', 2, NULL, 14),
('Il girasole', 1, NULL, 2),            ('Il girasole', 1, NULL, 2),
('Il girasole', 1, NULL, 2),            ('Il girasole', 1, NULL, 4),
('Il girasole', 1, NULL, 4),            ('Il girasole', 1, NULL, 4),
('Il girasole', 1, NULL, 4),            ('Il girasole', 1, NULL, 4),
('Il girasole', 1, NULL, 5),            ('Il girasole', 1, NULL, 6),
('Il girasole', 1, NULL, 8),            ('Il girasole', 1, NULL, 8),
('Il girasole', 2, NULL, 4),            ('Il girasole', 2, NULL, 4),
('Il girasole', 2, NULL, 4),            ('Il girasole', 2, NULL, 4),
('Il girasole', 2, NULL, 10),           ('Il girasole', 2, NULL, 12),
('Il girasole', 2, NULL, 16),           ('Il girasole', 2, NULL, 16),
('Il pozzo', 1, NULL, 2),               ('Il pozzo', 1, NULL, 2),
('Il pozzo', 1, NULL, 2),               ('Il pozzo', 1, NULL, 2),
('Il pozzo', 1, NULL, 2),               ('Il pozzo', 1, NULL, 2),
('Il pozzo', 1, NULL, 2),               ('Il pozzo', 1, NULL, 2),
('Il pozzo', 1, NULL, 3),               ('Il pozzo', 1, NULL, 3),
('Il pozzo', 1, NULL, 4),               ('Il pozzo', 1, NULL, 4),
('Il pozzo', 1, NULL, 4),               ('Il pozzo', 1, NULL, 4),
('Il pozzo', 1, NULL, 4),               ('Il pozzo', 1, NULL, 4),
('Il pozzo', 1, NULL, 5),               ('Il pozzo', 1, NULL, 6),
('Il pozzo', 1, NULL, 6),               ('Il pozzo', 1, NULL, 8),
('Il pozzo', 1, NULL, 8),               ('Il pozzo', 1, NULL, 8),
('Il pozzo', 1, NULL, 8),               ('Il pozzo', 1, NULL, 8),
('Il pozzo', 1, NULL, 10),              ('Il pozzo', 1, NULL, 12),
('Il pozzo', 1, NULL, 12),              ('Il pozzo', 1, NULL, 12),
('Il pozzo', 1, NULL, 12),              ('Il pozzo', 1, NULL, 12),
('Il pozzo', 1, NULL, 14),              ('Il pozzo', 1, NULL, 14),
('Il pozzo', 1, NULL, 15),              ('Il pozzo', 1, NULL, 15),
('Ristorante da Giovanni', 1, NULL, 2), ('Ristorante da Giovanni', 1, NULL, 2),
('Ristorante da Giovanni', 1, NULL, 3), ('Ristorante da Giovanni', 1, NULL, 3),
('Ristorante da Giovanni', 1, NULL, 4), ('Ristorante da Giovanni', 1, NULL, 4),
('Ristorante da Giovanni', 1, NULL, 4), ('Ristorante da Giovanni', 1, NULL, 6),
('Ristorante da Giovanni', 1, NULL, 6), ('Ristorante da Giovanni', 1, NULL, 6),
('Ristorante da Giovanni', 1, NULL, 8), ('Ristorante da Giovanni', 1, NULL, 8),
('Ristorante da Giovanni', 1, NULL, 10),('Ristorante da Giovanni', 1, NULL, 10),
('Ristorante da Giovanni', 1, NULL, 10),('Ristorante da Giovanni', 1, NULL, 16),
('Ristorante da Giovanni', 1, NULL, 16),('Ristorante Venezia', 1, NULL, 2),
('Ristorante Venezia', 1, NULL, 2),     ('Ristorante Venezia', 1, NULL, 2),
('Ristorante Venezia', 1, NULL, 2),     ('Ristorante Venezia', 1, NULL, 2),
('Ristorante Venezia', 1, NULL, 4),     ('Ristorante Venezia', 1, NULL, 4),
('Ristorante Venezia', 1, NULL, 4),     ('Ristorante Venezia', 1, NULL, 4),
('Ristorante Venezia', 1, NULL, 4),     ('Ristorante Venezia', 1, NULL, 5),
('Ristorante Venezia', 1, NULL, 6),     ('Ristorante Venezia', 1, NULL, 6),
('Ristorante Venezia', 1, NULL, 6),     ('Ristorante Venezia', 1, NULL, 8),
('Ristorante Venezia', 1, NULL, 8),     ('Ristorante Venezia', 1, NULL, 10),
('Ristorante Venezia', 1, NULL, 10),    ('Ristorante Venezia', 1, NULL, 12),
('Ristorante Venezia', 1, NULL, 12),    ('Ristorante Venezia', 1, NULL, 14),
('Ristorante Venezia', 1, NULL, 15),    ('Ristorante Venezia', 1, NULL, 16),
('Ristorante Venezia', 1, NULL, 18),    ('Il paiolo magico', 1, NULL, 2),
('Il paiolo magico', 1, NULL, 2),       ('Il paiolo magico', 1, NULL, 2),
('Il paiolo magico', 1, NULL, 2),       ('Il paiolo magico', 1, NULL, 2),
('Il paiolo magico', 1, NULL, 3),       ('Il paiolo magico', 1, NULL, 3),
('Il paiolo magico', 1, NULL, 4),       ('Il paiolo magico', 1, NULL, 4),
('Il paiolo magico', 1, NULL, 4),       ('Il paiolo magico', 1, NULL, 4),
('Il paiolo magico', 1, NULL, 4),       ('Il paiolo magico', 1, NULL, 4),
('Il paiolo magico', 1, NULL, 5),       ('Il paiolo magico', 1, NULL, 6),
('Il paiolo magico', 1, NULL, 6),       ('Il paiolo magico', 1, NULL, 8),
('Il paiolo magico', 1, NULL, 10),      ('Il paiolo magico', 1, NULL, 10),
('Il paiolo magico', 1, NULL, 14),      ('Il paiolo magico', 1, NULL, 16),
('Il paiolo magico', 1, NULL, 18),      ('Il paiolo magico', 1, NULL, 18),
('Il paiolo magico', 2, NULL, 2),       ('Il paiolo magico', 2, NULL, 2),
('Il paiolo magico', 2, NULL, 2),       ('Il paiolo magico', 2, NULL, 2),
('Il paiolo magico', 2, NULL, 2),       ('Il paiolo magico', 2, NULL, 2),
('Il paiolo magico', 2, NULL, 2),       ('Il paiolo magico', 2, NULL, 4),
('Il paiolo magico', 2, NULL, 4),       ('Il paiolo magico', 2, NULL, 4),
('Il paiolo magico', 2, NULL, 4),       ('Il paiolo magico', 2, NULL, 4),
('Il paiolo magico', 3, NULL, 2),       ('Il paiolo magico', 3, NULL, 2),
('Il paiolo magico', 3, NULL, 2),       ('Il paiolo magico', 3, NULL, 2),
('Il paiolo magico', 3, NULL, 2),       ('Il paiolo magico', 3, NULL, 2),
('Il paiolo magico', 3, NULL, 3),       ('Il paiolo magico', 3, NULL, 3),
('Il paiolo magico', 3, NULL, 4),       ('Il paiolo magico', 3, NULL, 4),
('Il paiolo magico', 3, NULL, 4),       ('Il paiolo magico', 3, NULL, 4),
('Il paiolo magico', 3, NULL, 5),       ('Il paiolo magico', 3, NULL, 5),
('Il paiolo magico', 3, NULL, 6),       ('Il paiolo magico', 3, NULL, 6),
('Il paiolo magico', 3, NULL, 6),       ('Il paiolo magico', 3, NULL, 8),
('Il paiolo magico', 3, NULL, 8),       ('Il paiolo magico', 3, NULL, 10),
('Il paiolo magico', 3, NULL, 10),      ('Il paiolo magico', 3, NULL, 10),
('Il paiolo magico', 3, NULL, 12),      ('Il paiolo magico', 3, NULL, 12),
('Il paiolo magico', 3, NULL, 14),      ('Il paiolo magico', 3, NULL, 14),
('Il paiolo magico', 3, NULL, 15),      ('Il paiolo magico', 3, NULL, 18),
('Il paiolo magico', 3, NULL, 20),      ('Il paiolo magico', 3, NULL, 24),
('Pizzeria da Gennaro', 1, NULL, 2),    ('Pizzeria da Gennaro', 1, NULL, 2),
('Pizzeria da Gennaro', 1, NULL, 2),    ('Pizzeria da Gennaro', 1, NULL, 2),
('Pizzeria da Gennaro', 1, NULL, 4),    ('Pizzeria da Gennaro', 1, NULL, 4),
('Pizzeria da Gennaro', 1, NULL, 4),    ('Pizzeria da Gennaro', 1, NULL, 6),
('Pizzeria da Gennaro', 1, NULL, 8),    ('Pizzeria da Gennaro', 2, NULL, 2),
('Pizzeria da Gennaro', 2, NULL, 2),    ('Pizzeria da Gennaro', 2, NULL, 2),
('Pizzeria da Gennaro', 2, NULL, 2),    ('Pizzeria da Gennaro', 2, NULL, 2),
('Pizzeria da Gennaro', 2, NULL, 4),    ('Pizzeria da Gennaro', 2, NULL, 4),
('Pizzeria da Gennaro', 2, NULL, 4),    ('Pizzeria da Gennaro', 2, NULL, 4),
('Pizzeria da Gennaro', 2, NULL, 5),    ('Pizzeria da Gennaro', 2, NULL, 8),
('Pizzeria da Gennaro', 2, NULL, 15),   ('Pizzeria da Gennaro', 3, NULL, 2),
('Pizzeria da Gennaro', 3, NULL, 2),    ('Pizzeria da Gennaro', 3, NULL, 3),
('Pizzeria da Gennaro', 3, NULL, 4),    ('Pizzeria da Gennaro', 3, NULL, 4),
('Pizzeria da Gennaro', 3, NULL, 6),    ('Pizzeria da Gennaro', 3, NULL, 6),
('Pizzeria da Gennaro', 3, NULL, 10),   ('Pizzeria da Gennaro', 3, NULL, 12),
('L\'aragosta', 1, NULL, 2),            ('L\'aragosta', 1, NULL, 2),
('L\'aragosta', 1, NULL, 2),            ('L\'aragosta', 1, NULL, 2),
('L\'aragosta', 1, NULL, 3),            ('L\'aragosta', 1, NULL, 3),
('L\'aragosta', 1, NULL, 4),            ('L\'aragosta', 1, NULL, 4),
('L\'aragosta', 1, NULL, 4),            ('L\'aragosta', 1, NULL, 5),
('L\'aragosta', 1, NULL, 6),            ('L\'aragosta', 1, NULL, 6),
('L\'aragosta', 1, NULL, 8),            ('L\'aragosta', 1, NULL, 10),
('L\'aragosta', 1, NULL, 10),           ('Tatooine', 1, NULL, 2),
('Tatooine', 1, NULL, 2),               ('Tatooine', 1, NULL, 2),
('Tatooine', 1, NULL, 2),               ('Tatooine', 1, NULL, 2),
('Tatooine', 1, NULL, 2),               ('Tatooine', 1, NULL, 3),
('Tatooine', 1, NULL, 3),               ('Tatooine', 1, NULL, 4),
('Tatooine', 1, NULL, 4),               ('Tatooine', 1, NULL, 4),
('Tatooine', 1, NULL, 4),               ('Tatooine', 1, NULL, 5),
('Tatooine', 1, NULL, 6),               ('Tatooine', 1, NULL, 6),
('Tatooine', 1, NULL, 8),               ('Tatooine', 1, NULL, 8),
('Tatooine', 1, NULL, 10),              ('Tatooine', 1, NULL, 10),
('Tatooine', 1, NULL, 10),              ('Tatooine', 1, NULL, 12);

INSERT INTO Account(Username, Email, Password, Nome, Cognome, Sesso, Citta, CAP,
    Via, NumeroCivico, Telefono) VALUES
('Expinguith59', 'ritabeneventi@gmail.com', '0d13d544b4e1b8edc45f9afa166768d1',
    'Rita', 'Beneventi', 'F', 'Messina', 98125, 'San Domenico Soriano', 42,
    03356005799),
('Lopurter', 'giulianagallo@hotmail.it', '1a075e925efc9f88680a078384bd8220',
    'Giuliana', 'Gallo', 'F', 'Renate', 20055, 'San Cosmo', 142, 3342718302),
('DCattaneo', 'dcattaneo@gmail.com', '219348e0258035828fa08ea5eb624aac',
    'Delinda', 'Cattaneo', 'F', 'Milano', 20121, 'Hoepli', 6, 3318428014),
('Monan1980', 'p.costa@live.it', '31bed8ee8ee314d3cd701986d4dd9d68',
    'Pantaleone', 'Costa', 'M', 'Mezzana Bigli', 27030, 'Alessandro Manzoni', 33,
    03647734886),
('Nhoya', 'nhoyaif@insicuri.net', '4616ea18bd0dc06b412ed37d6a4f1ab8',
    'Francesco', 'Giordano', 'M', 'Cagliari', 09127, 'Ottone Bacaredda', 97,
    3313342124),
('domenicoboni', 'domenicoboni@gmail.com', '5b7039dce362525ab13e4ec48adc5f04',
    'Domenico', 'Boni', 'M', 'Livorno', 57128, 'dell\'Ardenza', 80, 0586282497),
('lorythebest', 'lorythebest@outlook.com', '650393f04f7d81491f2c8e393bc2ff6e',
    'Ilda', 'Lori', 'F', 'Viareggio', 57121, 'Piero Gobetti', 11, 3348468115),
('murdercode', 'murder.code@inforge.net', '7bfd12dabc628020c97d396e039a731f',
    'Stefano', 'Novelli', 'M', 'Golfo Aranci', 07020, 'Libertà', 179, 3339282019),
('lolasd', 'dfijdefierku@guerrillamail.com', '840d7a569d5a84e404ccc6c2b44a4165',
    'Matteo', 'De Luca', 'M', 'Milano', 44444, 'Giuseppe Garibaldi', 15, 3333333333),
('SpeedJack', 'speedjack@inforge.net', '9173039d5e505f44dfa151663ce5ee52',
    'Niccolò', 'Scatena', 'M', 'Pisa', 56124, 'Pungilupo', 7, 3314432120),
('Serendipity', 'grazia.casci@yahoo.com', 'a68c4445228eb1b1a49e3df10f2d51df',
    'Grazia', 'Casci', 'F', 'Pisa', 56124, 'Caduti El-Alamein', 12, 3347282923),
('GMarra', 'gabri95@gmail.com', 'b7938f4f7741d580a1056771b62a62b9',
    'Gabriele', 'Marraccini', 'M', 'Roma', 00163, 'Ernesto Guevara', 8, 3348293712),
('lorytony', 'lorenzo.tone@hotmail.it', 'c4d2188aa605e98ab72134125afa108e',
    'Lorenzo', 'Tonelli', 'M', 'Torino', 10134, 'Corso Re Umberto', 7, 3313738263);

INSERT INTO Pony(Sede, ID) VALUES       ('Pizzeria da Cecco', NULL),
('L\'ostrica ubriaca', NULL),           ('L\'ostrica ubriaca', NULL),
('Il girasole', NULL),                  ('Il pozzo', NULL),
('Ristorante Venezia', NULL),           ('Il paiolo magico', NULL),
('Pizzeria da Gennaro', NULL),          ('Pizzeria da Gennaro', NULL),
('Pizzeria da Gennaro', NULL),          ('L\'aragosta', NULL);
INSERT INTO Pony(Sede, ID, Ruote) VALUES
('Ristorante da Giovanni', NULL, TRUE), ('Ristorante da Giovanni', NULL, TRUE),
('Il paiolo magico', NULL, TRUE),       ('Tatooine', NULL, TRUE);

INSERT INTO Domanda(ID, Sede, Testo) VALUES
(1, 'Pizzeria da Cecco', 'Come valuta la qualità del cibo in rapporto al '
    'prezzo?'),
(2, 'Pizzeria da Cecco','Come valuta l\'efficienza del personale del '
    'ristorante?'),
(3, 'L\'ostrica ubriaca', 'Consiglierebbe questo ristorante ad un amico?'),
(4, 'L\'ostrica ubriaca', 'Le porzioni erano adeguate?'),
(5, 'Il girasole', 'L\'ambiente del ristorante è stato di suo gradimento?'),
(6, 'Il girasole', 'Come valuta la qualità del cibo in rapporto al prezzo?'),
(7, 'Il girasole', 'Le porzioni erano adeguate?'),
(8, 'Il pozzo', 'Come valuta la qualità del cibo in rapporto al prezzo?'),
(9, 'Il pozzo', 'Come valuta l\'efficienza del personale del ristorante?'),
(10, 'Ristorante da Giovanni',
    'Come valuta l\'efficienza del personale del ristorante?'),
(11, 'Ristorante da Giovanni', 'Consiglierebbe questo ristorante ad un amico?'),
(12, 'Ristorante Venezia','Qual\'è la sua valutazione complessiva sul '
    'ristorante?'),
(13, 'Il paiolo magico', 'Le porzioni erano adeguate?'),
(14, 'Il paiolo magico', 'Consiglierebbe questo ristorante ad un amico?'),
(15, 'Pizzeria da Gennaro',
    'Come valuta la qualità del cibo in rapporto al prezzo?'),
(16, 'Pizzeria da Gennaro', 'Consiglierebbe questo ristorante ad un amico?'),
(17, 'L\'aragosta', 'Come valuta l\'efficienza del personale del ristorante?'),
(18, 'L\'aragosta', 'Come valuta la qualità del cibo in rapporto al prezzo?'),
(19, 'L\'aragosta', 'Le porzioni erano adeguate?'),
(20, 'Tatooine', 'Come valuta la qualità del cibo in rapporto al prezzo?');

INSERT INTO Risposta(Domanda, Numero, Testo, Efficienza) VALUES
(1, NULL, 'Ottima', 5),                 (1, NULL, 'Sufficiente', 3),
(1, NULL, 'Scarsa', 1),                 (2, NULL, 'Molto efficiente', 5),
(2, NULL, 'Normale', 3),                (2, NULL, 'Poco efficiente', 1),
(3, NULL, 'Assolutamente sì', 5),       (3, NULL, 'Probabilmente sì', 4),
(3, NULL, 'Forse', 3),                  (3, NULL, 'Probabilmente no', 2),
(3, NULL, 'Assolutamente no', 1),       (4, NULL, 'Assolutamente sì', 5),
(4, NULL, 'Più sì che no', 4),          (4, NULL, 'Così e così', 3),
(4, NULL, 'Più no che sì', 2),          (4, NULL, 'Assolutamente no', 1),
(5, NULL, 'Sì', 5),                     (5, NULL, 'No', 1),
(6, NULL, 'Ottima', 5),                 (6, NULL, 'Buona', 4),
(6, NULL, 'Sufficiente', 3),            (6, NULL, 'Scarsa', 2),
(6, NULL, 'Pessima', 1),                (7, NULL, 'Sì', 5),
(7, NULL, 'Così e così', 3),            (7, NULL, 'No', 1),
(8, NULL, 'Ottima', 5),                 (8, NULL, 'Sufficiente', 3),
(8, NULL, 'Scarsa', 1),                 (9, NULL, 'Ottima', 5),
(9, NULL, 'Sufficiente', 3),            (9, NULL, 'Scarsa', 1),
(10, NULL, 'Molto efficiente', 5),      (10, NULL, 'Normale', 3),
(10, NULL, 'Poco efficiente', 1),       (11, NULL, 'Assolutamente sì', 5),
(11, NULL, 'Probabilmente sì', 4),      (11, NULL, 'Forse', 3),
(11, NULL, 'Probabilmente no', 2),      (11, NULL, 'Assolutamente no', 1),
(12, NULL, 'Eccellente!', 5),           (12, NULL, 'Buono', 4),
(12, NULL, 'Non so', 3),                (12, NULL, 'Cattivo', 2),
(12, NULL, 'Bleah!', 1),                (13, NULL, 'Assolutamente sì', 5),
(13, NULL, 'Più sì che no', 4),         (13, NULL, 'Così e così', 3),
(13, NULL, 'Più no che sì', 2),         (13, NULL, 'Assolutamente no', 1),
(14, NULL, 'Assolutamente sì', 5),      (14, NULL, 'Probabilmente sì', 4),
(14, NULL, 'Forse', 3),                 (14, NULL, 'Probabilmente no', 2),
(14, NULL, 'Assolutamente no', 1),      (15, NULL, 'Ottima', 5),
(15, NULL, 'Sufficiente', 3),           (15, NULL, 'Scarsa', 1),
(16, NULL, 'Sì', 5),                    (16, NULL, 'No', 1),
(17, NULL, 'Molto efficiente', 5),      (17, NULL, 'Normale', 3),
(17, NULL, 'Poco efficiente', 1),       (18, NULL, 'Ottima', 5),
(18, NULL, 'Sufficiente', 3),           (18, NULL, 'Scarsa', 1),
(19, NULL, 'Sì', 5),                    (19, NULL, 'Così e così', 3),
(19, NULL, 'No', 1),                    (20, NULL, 'Ottima', 5),
(20, NULL, 'Buona', 4),                 (20, NULL, 'Sufficiente', 3),
(20, NULL, 'Scarsa', 2),                (20, NULL, 'Pessima', 1);

INSERT INTO Ricetta(Nome, Testo) VALUES
('Tagliere salumi e formaggi', 'Tagliare il prosciutto, la mortadella, '
    'il salame, il lardo e il pecorino a fette. Aggiungere alcune scaglie di '
    'parmigiano.'),
('Crostini con salmone e philadelphia', 'Mescolare la philadelphia in una '
    'terrina assieme all\'erba cipollina fino ad ottenere una crema morbida. '
    'Tagliare il pane in fette. Scaldare una padella antiaderente e '
    'abbrustolire le fette di pane su entrambi i lati fino a che non risultano '
    'croccanti. Spalmare su ciascun crostino la crema di philadelphia e '
    'adagiate su ciascuna di esse una fettina di salmone affumicato.'),
('Pizza margherita', 'Oleare la teglia e stenderci sopra l\'impasto. '
    'Aggiungere la salsa di pomodoro. Aggiungere le fette di mozzarella. '
    'Condire con olio. Cuocere in forno.'),
('Pizza wrustel', 'Oleare la teglia e stenderci sopra l\'impasto. Aggiungere '
    'la salsa di pomodoro. Aggiungere le fette di mozzarella e di wrustel. '
    'Condire con olio. Cuocere in forno.'),
('Pizza quattro formaggi', 'Oleare la teglia e stenderci sopra l\'impasto. '
    'Aggiungere la salsa di pomodoro. Aggiungere il provolone, il parmigiano, '
    'la groviera e il pecorino. Condire con olio. Cuocere in forno.'),
('Tortelli di zucca al ragù', 'Scaldare il ragù. Cuocere i tortelli in acqua '
    'salata. Scolare i tortelli e condirli con il ragù e un filo di olio.'),
('Ravioli burro e salvia ripieni di spinaci', 'Scaldare il burro e la salvia '
    'in una pentola. Cuocere i ravioli in acqua salata. Saltarli nella padella '
    'con il burro e la salvia.'),
('Spaghetti con aglio, olio e peperoncino', 'Tagliare l\'aglio e i peperoncini '
    'in piccoli pezzi. Soffriggere l\'aglio e il peperoncino in olio. Cuocere '
    'gli spaghetti in acqua salata. Saltare gli spaghetti nella pentola con '
    'aglio, olio e peperoncino.'),
('Ravioli panna e scampi', 'Soffriggere aglio, prezzemolo e peperoncino. '
    'Sfumare con vino bianco. Aggiungere pomodoro a pezzi. Aggiungere gli '
    'scampi. Cuocere i ravioli in acqua salata. Saltare i ravioli nella '
    'padella e aggiungere la panna.'),
('Risotto carnaroli con aragosta e champagne', 'Lessare le aragoste. Scolarle '
    'e estrarne una polpa, tagliandola in pezzi. Far restringere il brodo con '
    'cipolla, carote, sedano, prezzemolo e le carcasse delle aragoste. '
    'Filtrare il brodo. Far appassire gli scalogni con un po\' di burro e '
    'olio. Aggiungerci poi il riso e bagnare con un bicchiere di champagne. '
    'Unire poi il brodo. Continuare la cottura alternando champagne e brodo. '
    'Infine aggiungere la polpa di aragosta e terminare la cottura.'),
('Tagliata di manzo alla griglia', 'Cuocere la carne sulla griglia. Tagliare '
    'la carne. Condire con sale.'),
('Petto di pollo in salsa', 'Tagliare il pollo in fettine e impanarle. Far '
    'sciogliere il burro in una padella. Aggiungere le fettine di pollo. Far '
    'sciogliere altro burro in un\'altra padella con un po\' di farina. '
    'Aggiungere del pepe nero. Preparare un brodo vegetale in acqua con '
    'sedano, carota e cipolla. Aggiungere il brodo all\'amalgama di burro e '
    'farina. Aggiungere la salsa prodotta alle fettine di pollo.'),
('Fritto misto', 'Pulire gamberi e totani. Infarinarli. Friggerli. '
    'Friggere le patatine. Condire con sale.'),
('Orata alla griglia', 'Pulire il pesce. Cuocere l\'orata sulla griglia già '
    'calda. Togliere pelle, pinne e lische. Condire con olio e limone.'),
('Branzino alla griglia', 'Pulire il pesce. Cuocere il branzino sulla griglia '
    'già calda. Togliere pelle, pinne e lische. Condire con olio e limone.'),
('Patate arrosto', 'Sbucciare e tagliare a tocchetti le patate. Cuocere in '
    'forno. Condire con olio.'),
('Patatine fritte', 'Friggere le patatine. Condire con sale.'),
('Insalata mista', 'Lavare l\'insalata. Condire l\'insalata con carote, mais '
    'piselli, olio e sale.'),
('Torta al cioccolato', 'Tagliare una fetta di torta al cioccolato. Scaldare '
    'la torta in forno. Stendere lo zucchero a velo sopra il dolce.'),
('Torta della nonna', 'Tagliare una fetta di torta della nonna. Scaldare '
    'la torta in forno. Stendere lo zucchero a velo sopra il dolce.'),
('Limoncello', 'Versare il limoncello in un bicchiere.'),
('Vino rosso', 'Servire.'),
('Vino bianco', 'Servire.'),
('Birra', 'Servire.'),
('Coca Cola', 'Servire.'),
('Acqua naturale', 'Servire.'),
('Acqua frizzante', 'Servire.');

INSERT INTO Ingrediente(Nome, Provenienza, TipoProduzione, Genere, Allergene)
VALUES
('Pasta lievitata', 'Piemonte', 'Intensiva', 'Impasto', TRUE),
('Sugo di pomodoro', 'Toscana', 'Biologica', 'Sugo', TRUE),
('Mozzarella', 'Marche', 'Intensiva', 'Latticino', TRUE),
('Olio extravergine di oliva', 'Calabria', 'Biologica', 'Condimento', FALSE),
('Torta al cioccolato', 'Piemonte', 'Artigianale', 'Dessert', FALSE),
('Zucchero a velo', 'Sicilia', 'Industriale', 'Condimento', FALSE),
('Sale', 'Sardegna', 'Intensiva', 'Condimento', FALSE),
('Limoncello', 'Sardegna', 'Industriale', 'Bevanda', FALSE),
('Vino bianco', 'Toscana', 'Biologica', 'Bevanda', FALSE),
('Birra', 'Germania', 'Industriale', 'Bevanda', FALSE),
('Acqua naturale', 'Marche', 'Industriale', 'Bevanda', FALSE),
('Ali di pollo', 'Lombardia', 'Intensiva', 'Carne', TRUE),
('Farina', 'Lombardia', 'Biologica', 'Cereale', FALSE),
('Uova', 'Sicilia', 'Biologica', 'Derivato animale', FALSE),
('Anatra', 'Sardegna', 'Intensiva', 'Carne', TRUE),
('Arancia', 'Toscana', 'Biologica', 'Frutta', TRUE),
('Burro', 'Toscana', 'Industriale', 'Latticino', TRUE),
('Pasta', 'Sardegna', 'Intensiva', 'Cereale', TRUE),
('Grand Marnier', 'Molise', 'Industriale', 'Liquore', FALSE),
('Sfoglie per lasagne', 'Toscana', 'Intensiva', 'Cereale', TRUE),
('Ricotta', 'Campania', 'Artigianale', 'Latticino', TRUE),
('Besciamella', 'Campania', 'Artigianale', 'Latticino', TRUE),
('Salmone', 'Liguria', 'Intensiva', 'Pesce', TRUE),
('Ceci', 'Puglia', 'Biologica', 'Legume', TRUE),
('Philadelphia', 'Piemonte', 'Industriale', 'Latticino', TRUE),
('Tonno', 'Sardegna', 'Intensiva', 'Pesce', TRUE),
('Pane', 'Toscana', 'Artigianale', 'Cereale', FALSE),
('Prosciutto crudo', 'Toscana', 'Biologica', 'Salume', TRUE),
('Patatine', 'Piemonte', 'Industriale', 'Prodotto lavorato', FALSE);

INSERT INTO Lotto(Codice, Ingrediente, Scadenza) VALUES
('L3938M29A', 'Sugo di pomodoro', '2016-03-02'),
('L9357VA929C', 'Olio extravergine di oliva', '2016-04-07'),
('L3948VVYH3', 'Zucchero a velo', '2017-05-15'),
('LE0U8UIV5Y48', 'Sugo di pomodoro', '2016-03-07'),
('LM934YN4E', 'Mozzarella', '2016-02-28'),
('L00AA18H2', 'Torta al cioccolato', '2016-04-20'),
('LHUE666AA', 'Sale', '2018-11-01'),
('L8H7776A', 'Acqua naturale', '2020-09-10'),
('L1212DD8RH3QQ', 'Birra', '2017-08-14'),
('LIM12999AER6', 'Limoncello', '2019-01-01'),
('LM99AV118W', 'Mozzarella', '2016-03-07'),
('LZZ99AA00', 'Zucchero a velo', '2018-07-22'),
('LP4830HA22', 'Pasta lievitata', '2016-03-01'),
('LP4830HA23', 'Pasta lievitata', '2016-03-03');

INSERT INTO Strumento(Nome) VALUES
('Mattarello'), ('Coltello'), ('Cucchiaio'), ('Forchetta'), ('Bicchiere'),
('Forno'), ('Forno a microonde'), ('Fornello'), ('Tagliere'), ('Scolapasta'),
('Teglia'), ('Ciotola');

INSERT INTO Funzione(Strumento, Nome) VALUES
('Mattarello', 'Stendere'), ('Coltello', 'Tagliare'), ('Coltello', 'Affettare'),
('Cucchiaio', 'Prendere'), ('Forchetta', 'Inforchettare'),
('Bicchiere', 'Contenere'), ('Forno', 'Cuocere'), ('Forno', 'Scaldare'),
('Forno', 'Scongelare'), ('Forno a microonde', 'Scaldare'),
('Forno a microonde', 'Scongelare'), ('Forno a microonde', 'Riscaldare'),
('Fornello', 'Cuocere'), ('Fornello', 'Scaldare'), ('Tagliere', 'Appoggiare'),
('Scolapasta', 'Scolare'), ('Teglia', 'Contenere'), ('Ciotola', 'Contenere');

INSERT INTO Cucina(Sede, Strumento, Quantita) VALUES
('Pizzeria da Cecco', 'Mattarello', 6), ('Pizzeria da Cecco', 'Coltello', 10),
('Pizzeria da Cecco', 'Forno', 2), ('Pizzeria da Cecco', 'Cucchiaio', 8),
('Pizzeria da Cecco', 'Ciotola', 2), ('L\'ostrica ubriaca', 'Forchetta', 9),
('L\'ostrica ubriaca', 'Forno a microonde', 1),
('L\'ostrica ubriaca', 'Fornello', 6), ('L\'ostrica ubriaca', 'Bicchiere', 8),
('Ristorante Venezia', 'Coltello', 4), ('Ristorante Venezia', 'Teglia', 3),
('Il paiolo magico', 'Forchetta', 12), ('Il paiolo magico', 'Bicchiere', 5),
('L\'aragosta', 'Scolapasta', 2);

INSERT INTO Fase(ID, Ricetta, Ingrediente, Dose, Primario, Strumento, Testo,
    Durata) VALUES
(1, 'Pizza margherita', 'Pasta lievitata', 200, TRUE, NULL, NULL, NULL),
(2, 'Pizza margherita', NULL, NULL, NULL, 'Mattarello',
    'Stendere la pasta con il mattarello.', '00:03:00'),
(3, 'Pizza margherita', 'Sugo di pomodoro', 400, FALSE, NULL, NULL, NULL),
(4, 'Pizza margherita', NULL, NULL, NULL, 'Cucchiaio',
    'Distribuire il sugo di pomodoro sulla pasta.', '00:00:30'),
(5, 'Pizza margherita', 'Mozzarella', 350, TRUE, NULL, NULL, NULL),
(6, 'Pizza margherita', NULL, NULL, NULL, 'Coltello',
    'Tagliare la mozzarella a cubetti.', '00:02:00'),
(7, 'Pizza margherita', NULL, NULL, NULL, NULL,
    'Distribuire i cubetti di mozzarella sulla pasta.', '00:00:30'),
(8, 'Pizza margherita', 'Olio extravergine di oliva', 10, FALSE, NULL, NULL,
    NULL),
(9, 'Pizza margherita', NULL, NULL, NULL, 'Forno', 'Cuocere in forno.',
    '00:10:00'),
(10, 'Torta al cioccolato', 'Torta al cioccolato', 100, TRUE, NULL, NULL, NULL),
(11, 'Torta al cioccolato', NULL, NULL, NULL, 'Coltello',
    'Tagliare una fetta di torta al cioccolato.', NULL),
(12, 'Torta al cioccolato', NULL, NULL, NULL, 'Forno a microonde',
    'Scaldare la fetta di torta nel forno a microonde.', '00:01:30'),
(13, 'Torta al cioccolato', 'Zucchero a velo', 5, FALSE, NULL, NULL, NULL),
(14, 'Limoncello', 'Limoncello', 20, TRUE, NULL, NULL, NULL),
(15, 'Limoncello', NULL, NULL, NULL, 'Bicchiere', 'Versare in un bicchiere.',
    NULL),
(16, 'Vino bianco', 'Vino bianco', 1000, TRUE, NULL, NULL, NULL),
(17, 'Birra', 'Birra', 1000, TRUE, NULL, NULL, NULL),
(18, 'Acqua naturale', 'Acqua naturale', 1000, TRUE, NULL, NULL, NULL),
(19, 'Pizza margherita', 'Olio extravergine di oliva', 5, FALSE, NULL, NULL,
    NULL),
(20, 'Pizza margherita', 'Prosciutto crudo', 80, FALSE, NULL, NULL, NULL),
(21, 'Pizza margherita', NULL, NULL, NULL, 'Coltello', 'Tagliare il prosciutto '
    'a fette.', '00:01:30'),
(22, 'Pizza margherita', NULL, NULL, NULL, NULL, 'Distribuire il prosciutto '
    'sulla pizza.', '00:00:15'),
(23, 'Pizza margherita', 'Patatine', 80, FALSE, NULL, NULL, NULL),
(24, 'Pizza margherita', NULL, NULL, NULL, 'Fornello', 'Friggere le patatine.',
    '00:10:00'),
(25, 'Pizza margherita', NULL, NULL, NULL, NULL, 'Distribuire le patatine '
    'sulla pizza.', '00:00:15'),
(26, 'Acqua naturale', 'Acqua naturale', 500, TRUE, NULL, NULL, NULL),
(27, 'Pizza margherita', 'Salmone', 100, FALSE, NULL, NULL, NULL),
(28, 'Pizza margherita', NULL, NULL, NULL, 'Coltello', 'Tagliare il salmone a '
    'fette.', '00:01:30'),
(29, 'Pizza margherita', NULL, NULL, NULL, NULL, 'Distribuire il salmone sulla '
    'pizza.', '00:00:15'),
(30, 'Birra', 'Birra', 500, TRUE, NULL, NULL, NULL),
(31, 'Limoncello', 'Limoncello', 10, TRUE, NULL, NULL, NULL),
(32, 'Vino bianco', 'Vino bianco', 500, TRUE, NULL, NULL, NULL);

INSERT INTO SequenzaFasi(Fase, FasePrecedente) VALUES
(2, 1), (4, 2), (4, 3), (7, 4), (6, 5), (7, 6), (22, 7), (21, 20), (22, 21),
(28, 27), (29, 22), (29, 28), (25, 29), (24, 23), (25, 24), (8, 25), (19, 25),
(9, 8), (9, 19), (11, 10), (12, 11), (13, 12), (15, 14), (15, 31);

INSERT INTO Variazione(ID, Ricetta, Nome) VALUES
(1, 'Pizza margherita', 'Meno olio'), (2, 'Pizza margherita', 'Pizza bianca'),
(3, 'Pizza margherita', 'Con prosciutto crudo'),
(4, 'Pizza margherita', 'Con patatine'), (5, 'Acqua naturale', 'Mezzo litro'),
(6, 'Torta al cioccolato', 'Senza zucchero');
INSERT INTO Variazione(ID, Ricetta, Account) VALUES
(7, 'Pizza margherita', 'Serendipity'), (8, 'Birra', 'Nhoya'),
(9, 'Limoncello', 'Serendipity'), (10, 'Vino bianco', 'murdercode');

INSERT INTO ModificaFase(Variazione, ID, FaseVecchia, FaseNuova) VALUES
(1, 1, 8, 19), (2, 1, 3, NULL), (2, 2, 4, NULL), (3, 1, NULL, 20),
(3, 2, NULL, 21), (3, 3, NULL, 22), (4, 1, NULL, 23),
(4, 2, NULL, 24), (4, 3, NULL, 25), (5, 1, 18, 26),
(6, 1, 13, NULL), (7, 1, NULL, 27), (7, 2, NULL, 28),
(7, 3, NULL, 29), (8, 1, 17, 30), (9, 1, 14, 31), (10, 1, 16, 32);

INSERT INTO Proposta(ID, Account, Nome, Procedimento) VALUES
(1, 'Monan1980', 'Alette di pollo fritte', NULL),
(2, 'Nhoya', 'Anatra all\'arancia', NULL),
(3, 'Serendipity', 'Lasagne al salmone', 'Mettete un filo d’olio in una padella'
    ' e fate cuocere appena il salmone affumicato tagliato a pezzetti, Portate '
    'bollore dell’acqua calda salata in una pentola larga, fate sbollentare '
    'per meno di un minuto 2-3 sfoglie di lasagna alla volta, mettete in un '
    'colapasta con un filo d’olio tra i vari strati per non far attaccare la '
    'pasta. Lasciate la pentola sul fuoco, quando vi serviranno le altre '
    'sfoglie di pasta le cuocerete in contemporanea alla preparazione delle '
    'lasagne, togliete dal fuoco e tenete da parte, in una ciotola mettete la '
    'ricotta e stemperate con 4-5 cucchiai di latte tiepido, create il primo '
    'strato di lasagne mettendo sul fondo qualche cucchiaio di besciamella, '
    'poi la pasta, in seguito aggiungete la ricotta, la spalmate livellandola. '
    'Aggiungete i pezzetti di salmone affumicato precedentemente cotto in '
    'padella, aggiungete un po’ di besciamella poi altra pasta e ripete '
    'l’operazione fino ad esaurimento degli ingredienti. l’ultimo strato sarà '
    'composto da pasta e besciamella; infornate a 200° per 10 minuti.'),
(4, 'Expinguith59', 'Salmone al sale', NULL),
(5, 'Nhoya', 'Torta al cioccolato', 'Tagliare una fetta di torta al '
    'cioccolato. Scaldare la torta in forno. Stendere lo zucchero a velo sopra '
    'il dolce.'),
(6, 'Monan1980', 'Pizza margherita', NULL),
(7, 'lorytony', 'Pasta e ceci', 'In una pentola mettete 3 cucchiai di olio, lo '
    'spicchio d’aglio e far soffriggere per un minuto, quando l’aglio sarà '
    'dorato versare i ceci precedentemente sciacquati e sgocciolati aggiungere '
    'anche i rametti di rosmarino e far insaporire a fuoco medio per un paio '
    'di minuti. Aggiungere 3 bicchieri d’acqua, salare e far cuocere per una '
    'mezz’ora a fuoco basso mettendo il coperchio e senza girare. Aggiungere '
    'altra acqua se necessaio. A questo punto se si vuole creare una crema '
    'schiacciare con lo schiacciapatate 2-3 cucchiai dei ceci in cottura, in '
    'questo modo si accelera la cottura e la pasta avrà un sapore più intenso. '
    'Versare la pasta nella pentola ed aggiungere acqua fino a calda coprire '
    'la pasta, mettere il coperchio e lasciare cuocere secondo i tempi di '
    'cottura della pasta.'),
(8, 'murdercode', 'Crostini con salmone e philadelphia', NULL),
(9, 'murdercode', 'Salmone alla griglia', NULL),
(10, 'Expinguith59', 'Pasta col tonno', NULL);

INSERT INTO Composizione(Proposta, Ingrediente) VALUES
(1, 'Ali di pollo'), (1, 'Farina'), (1, 'Sale'), (1, 'Uova'),
(2, 'Anatra'), (2, 'Arancia'), (2, 'Sale'), (2, 'Burro'), (2, 'Grand Marnier'),
(3, 'Sfoglie per lasagne'), (3, 'Ricotta'), (3, 'Besciamella'), (3, 'Salmone'),
(3, 'Olio extravergine di oliva'),
(4, 'Salmone'), (4, 'Sale'),
(5, 'Torta al cioccolato'), (5, 'Zucchero a velo'),
(6, 'Pasta lievitata'), (6, 'Sugo di pomodoro'), (6, 'Mozzarella'),
(6, 'Olio extravergine di oliva'),
(7, 'Pasta'), (7, 'Ceci'), (7, 'Olio extravergine di oliva'),
(8, 'Pane'), (8, 'Salmone'), (8, 'Philadelphia'),
(9, 'Salmone'), (9, 'Sale'),
(10, 'Pasta'), (10, 'Tonno'), (10, 'Olio extravergine di oliva');

INSERT INTO Gradimento(Account, Proposta, Punteggio) VALUES
('Nhoya', 3, 4), ('murdercode', 7, 3), ('Monan1980', 5, 5),
('Monan1980', 2, 5), ('Serendipity', 7, 5), ('lorytony', 4, 1);
INSERT INTO Gradimento(Account, Suggerimento, Punteggio) VALUES
('murdercode', 7, 5), ('Lopurter', 9, 2), ('Nhoya', 10, 4), ('GMarra', 7, 3);

INSERT INTO Recensione(ID, Account, Sede, Ricetta, Testo, Giudizio) VALUES
(1, 'Serendipity', 'Il paiolo magico', 'Petto di pollo in salsa',
    'Il miglior pollo!', 5),
(2, 'murdercode', 'Pizzeria da Cecco', 'Pizza margherita',
    'Ottima pizza! Ambiente troppo rumoroso.', 4),
(3, 'Lopurter', 'L\'aragosta', 'Branzino alla griglia',
    'Pesce pessimo. Personale antipatico.', 1),
(4, 'Lopurter', 'Pizzeria da Cecco', 'Pizza quattro formaggi',
    'Buona, ma c\'è di meglio!', 4),
(5, 'lolasd', 'Tatooine', 'Orata alla griglia', 'spamspamSPAMspamspam', 3),
(6, 'SpeedJack', 'Ristorante Venezia', 'Ravioli panna e scampi',
    'I migliori ravioli della Versilia!', 5),
(7, 'murdercode', 'L\'ostrica ubriaca', 'Orata alla griglia',
    'Bel locale. Pesce passabile!', 4),
(8, 'murdercode', 'Il pozzo', 'Tagliata di manzo alla griglia',
    'Carne buona ma personale veramente odioso.', 2),
(9, 'GMarra', 'Il paiolo magico', 'Risotto carnaroli con aragosta e champagne',
    'Un risotto speciale!', 5),
(10, 'Serendipity', 'Pizzeria da Gennaro', 'Pizza margherita',
    'Di napoletano ha solo il nome!', 2);
    
INSERT INTO Valutazione(Account, Recensione, Veridicita, Accuratezza, Testo)
VALUES
('Expinguith59', 3, 1, 1, 'Bugiardissimo!'),
('lorytony', 6, 5, 4, 'Hai proprio ragione!'),
('murdercode', 4, 4, 3, 'La pizza è ottima! Ma il locale è troppo affollato.'),
('Serendipity', 9, 5, 5, 'Amo il paiolo magico!'),
('murdercode', 5, 1, 1, 'Vai a spammare da un\'altra parte!'),
('Lopurter', 2, 4, 4, 'La pizza non è poi così fantastica eh.'),
('domenicoboni', 5, 1, 1, 'Ma sta zitto!'),
('GMarra', 1, 5, 4, 'Meglio il risotto.'),
('Nhoya', 6, 5, 5, 'Eh già!'),
('Serendipity', 2, 2, 3, 'A me non è piaciuta neanche la pizza: troppo olio!');

INSERT INTO QuestionarioSvolto(Recensione, Domanda, Risposta) VALUES
(1, 13, 1), (1, 14, 1), (2, 1, 2), (2, 2, 2), (3, 17, 3), (3, 18, 3),
(3, 19, 3), (4, 1, 1), (4, 2, 2), (5, 20, 1), (6, 12, 1), (7, 3, 2), (7, 4, 2),
(8, 8, 3), (8, 9, 2), (9, 13, 1), (9, 14, 1), (10, 15, 3), (10, 16, 2);

INSERT INTO Clienti_Log(Sede, Anno, Mese, SenzaPrenotazione) VALUES
('Il paiolo magico', 2016, 1, 84),      ('Il paiolo magico', 2015, 12, 111),
('Il paiolo magico', 2015, 11, 98),     ('Il paiolo magico', 2015, 10, 108),
('Il paiolo magico', 2015, 9, 72),      ('Il paiolo magico', 2015, 8, 103),
('Il paiolo magico', 2015, 7, 85),      ('Il paiolo magico', 2015, 6, 123),
('Il paiolo magico', 2015, 5, 95),      ('Il paiolo magico', 2015, 4, 101),
('Il paiolo magico', 2015, 3, 76),      ('Il paiolo magico', 2015, 2, 100),
('Il paiolo magico', 2015, 1, 80),      ('Pizzeria da Cecco', 2015, 2, 89),
('L\'ostrica ubriaca', 2015, 2, 65),    ('Il girasole', 2015, 2, 57),
('Il pozzo', 2015, 2, 84),              ('Ristorante da Giovanni', 2015, 2, 88),
('Ristorante Venezia', 2015, 2, 91),    ('Pizzeria da Gennaro', 2015, 2, 77),
('L\'aragosta', 2015, 2, 102),          ('Tatooine', 2015, 2, 100);

INSERT INTO Scarichi_Log(Sede, Magazzino, Ingrediente, `Timestamp`, Quantita)
VALUES
('Pizzeria da Cecco', 1, 'Mozzarella', '2016-02-22 21:00:00', 12500),
('L\'ostrica ubriaca', 2, 'Tonno', '2016-02-22 22:30:00', 21800),
('Il girasole', 1, 'Sale', '2016-02-22 20:15:00', 1400),
('Il pozzo', 1, 'Sale', '2016-02-22 19:45:00', 320);

INSERT INTO Scarichi_Log(Sede, Magazzino, Ingrediente, Quantita) VALUES
('Ristorante da Giovanni', 1, 'Sugo di pomodoro', 21200),
('Ristorante Venezia', 2, 'Pasta lievitata', 1850),
('Pizzeria da Gennaro', 1, 'Acqua naturale', 90000),
('L\'aragosta', 1, 'Vino bianco', 20000),
('Tatooine', 1, 'Sugo di pomodoro', 15100),
('Il paiolo magico', 3, 'Torta al cioccolato', 800);

INSERT INTO Confezione(CodiceLotto, Numero, Peso, Prezzo, Sede, Magazzino,
    DataAcquisto, DataArrivo, DataCarico, Collocazione, Aspetto, Stato) VALUES
('L3938M29A', NULL, 500, 3.30, 'Pizzeria da Cecco', 1, '2016-01-10', '2016-01-15',
    '2016-01-15', 'a1', NULL, NULL ),
('L9357VA929C', NULL, 6000, 15.70, 'L\'ostrica ubriaca', 1, '2016-02-01',
    '2016-02-06', '2016-04-07', 'a1', NULL, NULL),
('L3948VVYH3', NULL, 700, 5.70, 'Ristorante da Giovanni', 1, '2015-10-01',
    '2015-10-11', '2017-05-15', 'a1', NULL, NULL),
('LE0U8UIV5Y48', NULL, 500, 3.30, 'L\'ostrica ubriaca', 1, '2016-02-01', '2016-02-06', 
    '2016-03-07', 'a2', NULL, NULL),
('LE0U8UIV5Y48', NULL, 500, 3.30, 'Il pozzo', 1, '2016-02-01', '2016-02-06',
    '2016-03-07', 'a1', NULL, NULL),
('LM934YN4E', NULL, 2000, 10.50, 'Il pozzo', 1,'2016-01-10', '2016-01-15', 
    '2016-02-28', 'a2', NULL, NULL),
('L00AA18H2', NULL, 3000, 12.30, 'Ristorante Venezia', 2, '2016-02-01', '2016-02-06', 
    '2016-04-20', 'a1', NULL, NULL),
('L00AA18H2', NULL, 3000, 12.30, 'Il paiolo magico', 3, '2016-02-01', '2016-02-06', 
    '2016-04-20', 'a1', NULL, NULL),
('LHUE666AA', NULL, 500, 2.25, 'Il girasole', 1, '2015-10-01', '2015-10-11',
    '2018-11-01', 'a1', NULL, NULL),
('LHUE666AA', NULL, 500, 2.25, 'Ristorante Venezia', 1,'2015-10-01', '2015-10-11',
    '2018-11-01', 'a1', NULL, NULL),
('LHUE666AA', NULL, 500, 2.25, 'Il paiolo magico', 2,'2015-10-01', '2015-10-11',
    '2018-11-01', 'a1', NULL, NULL),
('L8H7776A', NULL, 9000, 6, 'Il girasole', 1, '2015-10-01', '2015-10-11',
    '2020-09-10', 'a2', NULL, NULL),
('L8H7776A', NULL, 9000, 6, 'Pizzeria da Gennaro', 1, '2015-10-01', '2015-10-11',
    '2020-09-10', 'a1', NULL, NULL),
('L1212DD8RH3QQ', NULL, 20000, 140, 'Pizzeria da Gennaro', 1, '2015-10-01',
    '2015-10-11', '2017-08-14', 'a2', NULL, NULL), 
('LIM12999AER6', NULL, 5000, 50, 'Pizzeria da Gennaro', 1, '2016-01-10', '2016-01-15',
    '2019-01-01', 'a3', NULL, NULL), 
('LIM12999AER6', NULL, 5000, 50, 'L\'aragosta', 1, '2016-01-10', '2016-01-15',
    '2019-01-01', 'a1', NULL, NULL), 
('LM99AV118W', NULL, 2000, 10, 'L\'aragosta', 1, '2016-02-10', '2016-02-15',
    '2016-03-07', 'a2', NULL, NULL), 
('LP4830HA22', NULL, 5000, 10, 'Tatooine', 1, '2016-02-01', '2016-02-06', 
    '2016-03-01', 'a1', NULL, NULL),
('LZZ99AA00', NULL, 1000, 6.5,'Il pozzo', 1, '2015-10-01', '2015-10-11',
    '2018-07-22', 'a3', NULL, NULL), 
('LM99AV118W', NULL, 2000, 10, 'Tatooine', 1, '2016-02-10', '2016-02-15',
    '2016-03-07', 'a2', NULL, NULL), 
('LP4830HA23', NULL, 5000, 10, 'L\'aragosta', 1,'2016-02-01', '2016-02-06', 
    '2016-03-03', 'a3', NULL, NULL),
('LZZ99AA00', NULL, 1000, 6.5, 'L\'aragosta', 1, '2015-10-01', '2015-10-11',
    '2018-07-22', 'a4', NULL, NULL);

INSERT INTO Menu(Sede, ID, DataInizio, DataFine) VALUES
('Pizzeria da Cecco', NULL, '16-02-18', '16-03-02'),           
('L\'ostrica ubriaca', NULL, '16-01-24', '16-02-24'),
('L\'ostrica ubriaca', NULL, '15-12-23', '16-01-23'),           
('Il girasole', NULL, '16-01-20', '16-03-10'),
('Il pozzo', NULL, '16-02-01', '16-02-28'),                     
('Ristorante da Giovanni', NULL, '16-02-01', '16-03-01'),
('Ristorante Venezia', NULL, '16-01-25', '16-02-25'),     
('Ristorante Venezia', NULL, '15-11-24', '15-12-31'),
('Il paiolo magico', NULL, '15-10-01', '15-12-31'),
('Il paiolo magico', NULL, '15-02-20', '15-04-20'),
('Il paiolo magico', NULL, '16-01-01', '16-03-10'),
('Pizzeria da Gennaro', NULL, '16-02-10', '16-04-20'),
('L\'aragosta', NULL, '16-01-24', '16-03-10'),        
('Tatooine', NULL, '16-01-10', '16-04-25');

INSERT INTO Elenco(Menu,Ricetta) VALUES
(1,'Pizza margherita'),  (1, 'Pizza wrustel'),(1, 'Birra' ),           
(2,'Vino bianco' ),(2,'Torta al cioccolato' ),(2,'Branzino alla griglia' ),
(3,'Patatine fritte' ), (3,'Ravioli panna e scampi' ),  (3,'Acqua frizzante'),                     
(4,'Coca Cola' ),(4,'Patate arrosto' ),(4, 'Ravioli burro e salvia ripieni di spinaci'),
(5,'Birra' ),     (5,'Torta della nonna' ),     (5, 'Spaghetti con aglio, olio e peperoncino'),     
(6,'Vino bianco' ),(6,'Torta al cioccolato' ),(6,'Branzino alla griglia' ),
(7,'Patatine fritte' ),       (7,'Ravioli panna e scampi' ),     (7,'Acqua frizzante'),  
(8,'Coca Cola' ),(8, 'Patate arrosto'),(8, 'Petto di pollo in salsa'),
(9,'Acqua naturale' ),(9, 'Fritto misto'),(9, 'Patatine fritte'),
(12,'Pizza margherita'), (12, 'Pizza wrustel'),(12, 'Birra' ),     
(10,'Coca Cola'),   (10,'Insalata mista'),  (10,'Tagliata di manzo alla griglia'),        
(11,'Birra'),(11,'Petto di pollo in salsa'),(11,'Torta della nonna'),
(13,'Birra'),(13,'Fritto misto'),(13,'Insalata mista'),
(14,'Patatine fritte' ),   (14,'Ravioli panna e scampi' ),(14,'Acqua frizzante');

INSERT INTO Comanda(ID, Timestamp, Sede, Sala , Tavolo , Account) VALUES
( NULL,'2016-02-22 20:00:01', 'Pizzeria da Cecco', 1,1,NULL),           
(NULL, '2016-02-21 21:00:01', 'Pizzeria da Cecco', 1,2,NULL),
(NULL, '2016-02-20 19:00:01', 'L\'ostrica ubriaca', 1,1,NULL),           
( NULL, '2016-02-22 20:00:01', 'Il girasole', 1,1,NULL),
(NULL, '2016-02-22 20:00:01', 'Pizzeria da Cecco', 1,3,NULL),                     
( NULL, '2016-02-21 21:00:01', 'L\'ostrica ubriaca', 1,2,NULL),
( NULL,'2016-02-20 19:00:01', 'Il girasole', 1,2,NULL),     
(NULL, '2016-02-22 20:00:01', 'Pizzeria da Cecco', 1,4,NULL),
( NULL, '2016-02-21 21:00:01', 'Il girasole', 1,3,NULL),
(NULL,'2016-02-22 20:00:01','L\'ostrica ubriaca', 1,3,NULL),
(NULL, '2016-02-22 20:00:01', 'Il pozzo', NULL,NULL,'lorythebest'),
( NULL, '2016-02-22 20:00:01', 'L\'ostrica ubriaca', NULL,NULL, 'Monan1980'),
(NULL, '2016-02-20 19:00:01', 'Il pozzo', 1,1,NULL),
(NULL, '2016-02-21 21:00:01', 'Il pozzo',1,2,NULL),
( NULL, '2016-02-22 20:00:01', 'Il pozzo',1,3,NULL),
(NULL, '2016-02-20 19:00:01', 'L\'ostrica ubriaca', 1,5,NULL),
(NULL, '2016-02-22 20:00:01', 'Ristorante Venezia', 1,1,NULL),
( NULL, '2016-02-20 19:00:01', 'Ristorante Venezia', NULL,NULL,'Lopurter'),
(NULL, '2016-02-22 20:00:01', 'Ristorante da Giovanni', 1,1,NULL),        
(NULL,'2016-02-22 20:00:01', 'Ristorante da Giovanni', 1,2,NULL),
( NULL, '2016-02-20 19:00:01', 'Ristorante Venezia', NULL,NULL,'lorythebest'),
( NULL, '2016-02-19 21:00:01', 'Il girasole', NULL,NULL,'Monan1980'),
( NULL, '2016-02-21 20:25:01', 'Ristorante Venezia', NULL,NULL,'Lopurter'),
( NULL, '2016-02-20 20:00:01', 'Ristorante Venezia', NULL,NULL,'domenicoboni'),
( NULL, '2016-02-22 19:20:01', 'Ristorante Venezia', NULL,NULL,'Lopurter'),
( NULL, '2016-02-20 19:00:01', 'Il pozzo', NULL,NULL,'murdercode'),
( NULL, '2016-02-21 19:30:01', 'Ristorante Venezia', NULL,NULL,'lolasd');

INSERT INTO Piatto(ID, Comanda, Ricetta, InizioPreparazione, Stato) VALUES
(NULL,1,'Pizza margherita',NULL,'attesa'),  (NULL,1, 'Pizza wrustel',NULL,'attesa'),(NULL,1, 'Birra' ,NULL,'attesa'),           
(NULL,2,'Vino bianco',NULL,'attesa' ),(NULL,2,'Torta al cioccolato',NULL,'attesa' ),(NULL,2,'Branzino alla griglia' ,NULL,'attesa'),
(NULL,3,'Patatine fritte',NULL,'attesa'), (NULL,3,'Ravioli panna e scampi',NULL,'attesa' ),  (NULL,3,'Acqua frizzante',NULL,'attesa'),                     
(NULL,4,'Coca Cola' ,NULL,'attesa'),(NULL,4,'Patate arrosto' ,NULL,'attesa'),(NULL,4, 'Ravioli burro e salvia ripieni di spinaci',NULL,'attesa'),
(NULL,5,'Birra',NULL,'attesa' ),     (NULL,5,'Torta della nonna',NULL,'attesa' ),     (NULL,5, 'Spaghetti con aglio, olio e peperoncino',NULL,'attesa'),     
(NULL,6,'Vino bianco',NULL,'attesa' ),(NULL,6,'Torta al cioccolato',NULL,'attesa' ),(NULL,6,'Branzino alla griglia',NULL,'attesa' ),
(NULL,7,'Patatine fritte',NULL,'attesa' ),       (NULL,7,'Ravioli panna e scampi' ,NULL,'attesa'),     (NULL,7,'Acqua frizzante',NULL,'attesa'),  
(NULL,8,'Coca Cola' ,NULL,'attesa'),(NULL,8, 'Patate arrosto',NULL,'attesa'),(NULL,8, 'Petto di pollo in salsa',NULL,'attesa'),
(NULL,9,'Acqua naturale' ,NULL,'attesa'),(NULL,9, 'Fritto misto',NULL,'attesa'),(NULL,9, 'Patatine fritte',NULL,'attesa'),
(NULL,12,'Pizza margherita',NULL,'attesa'), (NULL,12, 'Pizza wrustel',NULL,'attesa'),(NULL,12, 'Birra' ,NULL,'attesa'),     
(NULL,10,'Coca Cola',NULL,'attesa'),   (NULL,10,'Insalata mista',NULL,'attesa'),  (NULL,10,'Tagliata di manzo alla griglia',NULL,'attesa'),        
(NULL,11,'Birra',NULL,'attesa'),(NULL,11,'Petto di pollo in salsa',NULL,'attesa'),(NULL,11,'Torta della nonna',NULL,'attesa'),
(NULL,13,'Birra',NULL,'attesa'),(NULL,13,'Fritto misto',NULL,'attesa'),(NULL,13,'Insalata mista',NULL,'attesa'),
(NULL,15,'Coca Cola',NULL,'attesa' ),(NULL,15,'Patate arrosto',NULL,'attesa' ),(NULL,15, 'Ravioli burro e salvia ripieni di spinaci',NULL,'attesa'),
(NULL,16,'Birra',NULL,'attesa' ),     (NULL,16,'Torta della nonna',NULL,'attesa' ),     (NULL,16, 'Spaghetti con aglio, olio e peperoncino',NULL,'attesa'),     
(NULL,17,'Vino bianco',NULL,'attesa' ),(NULL,17,'Torta al cioccolato',NULL,'attesa' ),(NULL,17,'Branzino alla griglia',NULL,'attesa' ),
(NULL,18,'Patatine fritte' ,NULL,'attesa'),       (NULL,18,'Ravioli panna e scampi' ,NULL,'attesa'),     (NULL,18,'Acqua frizzante',NULL,'attesa'),  
(NULL,19,'Coca Cola',NULL,'attesa' ),(NULL,19, 'Patate arrosto',NULL,'attesa'),(NULL,19, 'Petto di pollo in salsa',NULL,'attesa'),
(NULL,20,'Acqua naturale',NULL,'attesa' ),(NULL,20, 'Fritto misto',NULL,'attesa'),(NULL,20, 'Patatine fritte',NULL,'attesa'),
(NULL,14,'Patatine fritte' ,NULL,'attesa'),   (NULL,14,'Ravioli panna e scampi' ,NULL,'attesa'),(NULL,14,'Acqua frizzante',NULL,'attesa'),
(NULL,21, 'Petto di pollo in salsa',NULL,'attesa'),
(NULL,22,'Acqua naturale',NULL,'attesa' ),
(NULL,23, 'Fritto misto',NULL,'attesa'),
(NULL,24, 'Patatine fritte',NULL,'attesa'),
(NULL,25,'Patatine fritte' ,NULL,'attesa'),
(NULL,26,'Ravioli panna e scampi' ,NULL,'attesa'),
(NULL,27,'Acqua frizzante',NULL,'attesa');


INSERT INTO Modifica(Piatto, Variazione) VALUES
(1, 1), (1, 3), (1, 4), (28, 1), (28, 2), (28, 3), (25, 5), (55, 5), (5, 6),
(47, 6);

INSERT INTO Consegna(Comanda, Sede, Pony, Partenza, Arrivo , Ritorno ) VALUES
(11,'Il pozzo',1,CURRENT_TIMESTAMP + INTERVAL 1 DAY,NULL,NULL),
(12,'L\'ostrica ubriaca',2,CURRENT_TIMESTAMP,NULL,NULL);
/*(18,'Ristorante Venezia',1,CURRENT_TIMESTAMP + INTERVAL 1 DAY,NULL,NULL),
(21,'Ristorante Venezia',1,CURRENT_TIMESTAMP + INTERVAL 2 DAY,NULL,NULL),
(22,'Il girasole',1,CURRENT_TIMESTAMP,NULL,NULL),
(23,'Ristorante Venezia',1,CURRENT_TIMESTAMP,NULL,NULL),
(24,'Ristorante Venezia',1,CURRENT_TIMESTAMP + INTERVAL 3 DAY,NULL,NULL),
(25,'Ristorante Venezia',1,CURRENT_TIMESTAMP + INTERVAL 4 DAY,NULL,NULL),
(26,'Il pozzo',1,CURRENT_TIMESTAMP,NULL,NULL),
(27,'Ristorante Venezia',1,CURRENT_TIMESTAMP + INTERVAL 5 DAY,NULL,NULL);

INSERT INTO Prenotazione(Sede, Data, Numero, Account, Sala) VALUES
('Il paiolo magico', '2016-02-26 20:00:00', 3, 'Serendipity', NULL),
('Il girasole', '2016-02-28 20:30:00', 4, 'murdercode', NULL),
('Pizzeria da Cecco', '2016-02-26 21:00:00', 2, 'SpeedJack', NULL),
('Ristorante Venezia', '2016-02-27 20:00:00', 1, 'Nhoya', NULL),
('Il paiolo magico', '2016-02-25 22:00:00', 5, 'Serendipity', NULL);
INSERT INTO Prenotazione(Sede, `Data`, Numero, Nome, Telefono, Sala) VALUES
('Il girasole', '2016-02-26 21:00:00', 3, 'Giovanni', '3342628162', NULL),
('Il pozzo', '2016-02-25 20:00:00', 2, 'Marcello', '3343974261', NULL),
('Il paiolo magico', '2016-02-25 21:00:00', 3, 'Tonelli', '3393843829', NULL),
('L\'aragosta', '2016-02-26 21:00:00', 1, 'Novelli', '3339739082', NULL);
INSERT INTO Prenotazione(Sede, `Data`, Numero, Account, Nome, Sala, Descrizione,
    Approvato) VALUES
('Il paiolo magico', '2016-02-27 20:00:00', 65, 'Serendipity', 'Harry Potter!', 2,
    'Serata a tema di harry potter!', TRUE);*/


SELECT "Esecuzione script terminata. Bye bye ;)" AS "************ END OF SCRIPT ************";
