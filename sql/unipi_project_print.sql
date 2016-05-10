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


-- INSERTS NON RIPORTATI NEL DOCUMENTO

SELECT "Esecuzione script terminata. Bye bye ;)"
    AS "************ END OF SCRIPT ************";
