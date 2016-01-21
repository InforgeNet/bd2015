
/* Per completare le create table è necessario:

  a)Dare i giusti domini agli attributi, ho messo troppi varchar.
    Ricordati che il dominio di una chiave esterna deve essere uguale al dominio
    della chiave primaria che referenzia.
  b)Controllare le foreign key che puntino alla giusta primary key.
    Ti consiglio di controllare la referenzialità tra le tabelle FASE,
    MODIFICAFASE,SEQUENZAFASI e tra le tabelle GRADIMENTO,RECENSIONE,
    VALUTAZIONE,DOMANDA,RISPOSTA, perchè ho avuto problemi e confusione.
    
    */

-- TODO: Fix relazione Cucina in diagrammi (strumento non ha per forza una sede)

CREATE TABLE Sede
(
    Nome                    VARCHAR(45) NOT NULL,
    Citta                   VARCHAR(45) NOT NULL,
    CAP                     INT(5) UNSIGNED ZEROFILL NOT NULL,
    Via                     VARCHAR(45) NOT NULL,
    NumeroCivico            INT UNSIGNED NOT NULL,
    PRIMARY KEY (Nome),
    UNIQUE KEY (Citta, Via, NumeroCivico)
) ENGINE = InnoDB

CREATE TABLE Sala
(
    Sede                    VARCHAR(45) NOT NULL
        REFERENCES Sede(Nome)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    Numero                  INT UNSIGNED NOT NULL,
    PRIMARY KEY (Sede, Numero)
) ENGINE = InnoDB

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
) ENGINE = InnoDB

CREATE TABLE Account
(
    Username                VARCHAR(20) NOT NULL,
    Email                   VARCHAR(100) NOT NULL,
    Password                CHAR(32) NOT NULL,
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
) ENGINE = InnoDB

CREATE TABLE Prenotazione
(
    ID                      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Sede                    VARCHAR(45) NOT NULL,
    Data                    DATETIME NOT NULL,
    Numero                  INT UNSIGNED NOT NULL,
    Account                 VARCHAR(45)
        REFERENCES Account(Username)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
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
        ON UPDATE CASCADE
) ENGINE = InnoDB

CREATE TABLE Strumento
(
    Nome                    VARCHAR(45) NOT NULL,
    PRIMARY KEY (Nome)
) ENGINE = InnoDB

CREATE TABLE Funzione
(
    Strumento               VARCHAR(45) NOT NULL,
    Funzione                VARCHAR(45) NOT NULL,
    PRIMARY KEY (Strumento, Funzione),
    FOREIGN KEY (Strumento)
        REFERENCES Strumento(Nome)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB

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
) ENGINE = InnoDB

/* 8@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@21 */

create table Menu
(
    ID                  numeric(4) primary key,
    Sede                varchar(20),
    DataInizio          data,
    DataFine            data,
    foreign key(Sede) references Sede(Nome)
        on delete cascade
		on update set null
)

create table Elenco 
(
    Menu                numeric(4),
    Ricetta             varchar(20),
    Novita              varchar(20),
    primary key(Menu,Ricetta),
    foreign key(Menu) references Menu(ID)
        on delete cascade
		on update set null,
    foreign key(Ricetta) references Ricetta(Nome)
        on delete cascade
		on update set null         

)



create table Proposta 
(
    ID                  varchar(20),
    Procedimento        varchar(20),
    Account             varchar(20),
    Nome                varchar(20),
    primary key(ID),
    foreign key(Account) references Account(Username)
        on delete cascade
		on update set null,
    foreign key(Nome) references Ingrediente(Nome)
        on delete cascade
		on update set null
)

create table Gradimento
(
    ID                 varchar(20),
    Account            varchar(20),
    Proposta           varchar(20),
    Variazione         varchar(20),
    Punteggio          integer(2),
    primary key(ID),
    foreign key(Account) references Account(Username)
        on delete cascade
		on update set null,
    foreign key(Proposta) references Proposta(ID)
        on delete cascade
		on update set null,
    foreign key(Variazione) references Variazione(ID)
        on delete cascade
		on update set null,
    

)


create table Recensione
(
    ID                varchar(20),
    Account           varchar(20),
    Ricetta           varchar(20),
    Testo             varchar(255),
    Giudizio          varchar(20),
    primary key(ID),
    foreign key(Account) references Account(Username)
        on delete cascade
		on update set null,
    foreign key(Ricetta) references Ricetta(Nome)
        on delete cascade
		on update set null
 )

 create table Valutazione
(
    Account           varchar(20),
    Recensione        varchar(20),
    Veridicita        varchar(20),
    Accuratezza       varchar(20),
    Testo             varchar(255),
    primary key(Account,Recensione),
    foreign key(Account) references Account(Username)
        on delete cascade
		on update set null,
    foreign key(Recensione) references Recensione(ID)
        on delete cascade
		on update set null
 )

 create table Domanda /*manca l'attributo Domanda nella tabella DOMANDA di pag 22?? */
(
    Numero            integer(2),
    Sede              varchar(20),
    Domanda           varchar(63),
    Testo             varchar(255),
    primary key(Numero,Sede,Domanda),
    foreign key(Sede) references Sede(Nome)
        on delete cascade
		on update set null
 )
 
 
  create table Risposta
(
    Numero            integer(2),
    Domanda           varchar(63),
    Sede              varchar(20),
    Testo             varchar(255),
    Efficienza        varchar(20),
    primary key(Numero,Domanda,Sede),
    foreign key(Domanda,Sede) references Domanda(Domanda,Sede)
        on delete cascade
		on update set null
 )
 
 create table QuestionarioSvolto
 (
    Recensione             varchar(20),
    Sede                   varchar(20),
    Domanda                varchar(20),
    Risposta               varchar(20),
    primary key(Recensione,Sede,Domanda,Risposta),
    foreign key(Recensione) references Recensione(ID)
        on delete cascade
		on update set null,
    foreign key(Recensione) references Recensione(ID)
        on delete cascade
		on update set null,
    foreign key(Sede,Domanda,Risposta) references Risposta(Sede,Domanda,Numero) 
    /*non sono sicuro, non mi tornano le chiavi primarie di DOMANDA , RISPOSTA, QUESTIONARIOSVOLTO */
        on delete cascade
		on update set null
 
 )
 
 
create table Composizione
(
    Proposta             varchar(20),
    Ingrediente          varchar(20),
    primary key(Proposta,Ingrediente),
    foreign key(Proposta) references Proposta(ID)
        on delete cascade
		on update set null,
    foreign key(Ingrediente) references Ingrediente(Nome)
        on delete cascade
		on update set null
    
)

create table Ingrediente
(
    Nome                varchar(20) primary key,
    Provenienza         varchar(20),
    TipoProduzione      varchar(20),
    Genere              varchar(20),
    Allergene           bool

)

create table Magazzino
(
    ID                  numeric(4),
    Sede                varchar(20),
    primary key(ID,Sede),
    foreign key(Sede) references Sede(Nome)
        on delete cascade
		on update set null
     
)
create table Confezione
( 
    Numero                 varchar(20),
    CodiceLotto            varchar(20),
    Ingrediente            varchar(20),
    Peso                   varchar(20),
    Prezzo                 varchar(20),
    DataAcquisto           data,
    DataCarico             data,
    Sede                   varchar(20),
    Magazzino              varchar(20),
    Collocazione           varchar(20),
    Scadenza               varchar(20),
    Aspetto                varchar(20),
    Stato                  varchar(20),
    
    primary key(Numero,CodiceLotto),
    foreign key(Magazzino,Sede) references Magazzino(ID,Sede)
        on delete cascade
		on update set null

)




create table Pony
(
    ID                  varchar(20),
    Sede                varchar(20),
    Ruote               smallint,
    Stato               varchar(20),
    primary key(ID,Sede),
    foreign key(Sede) references Sede(Nome)
        on delete cascade
		on update set null
)

create table Consegna
(
    Comanda             varchar(20),
    Sede                varchar(20),
    Pony                varchar(20),
    Partenza            varchar(20),
    Arrivo              date,
    Ritorno             date,
    primary key(Comanda,Pony),
    foreign key(Comanda) references Comanda(ID)
        on delete cascade
		on update set null,
    foreign key(Pony) references Pony(ID)
        on delete cascade
		on update set null
)

create table Comanda  
( 
    ID                  varchar(20),
    Timestamp           time,
    Sede                varchar(20),
    Sala                varchar(20),
    Tavolo              varchar(20),
    Account             varchar(20),
 
    primary key(ID),
    foreign key(Tavolo,Sala) references Tavolo(ID,Sala)
        on delete cascade
		on update set null,
    /*per la relazione Gestione*/
    foreign key(Sede) references Sede(Nome)
        on delete cascade
		on update set null
)

create table  Piatto
(
    ID                  varchar(20) primary key,
    Comanda             varchar(20),
    Ricetta             varchar(20),
    Stato               varchar(20),
    
    foreign key(Comanda) references Comanda(ID)
        on delete cascade
		on update set null,
    foreign key(Ricetta) references Ricetta(Nome)
        on delete cascade
		on update set null
        
)

create table Variazione
(
    ID                  varchar(20) primary key,
    Nome                varchar(20),
    Account             varchar(20),
    
    foreign key(Account) references Account(Username)
         on delete cascade
		 on update set null
   
)

create table ModificaFase
( 
    ID                  varchar(20),
    Variazione          varchar(20),
    Ricetta             varchar(20),
    FaseVecchia         varchar(20),
    FaseNuova           varchar(20),
    /*ero in dubbio riguardo le references */
    primary key(ID,Variazione)
    foreign key(Variazione) references Variazione(ID)
        on delete cascade
		on update set null,
    foreign key(Ricetta,FaseVecchia) references Fase(Ricetta,Numero)
        on delete cascade
		on update set null,
    foreign key(Ricetta,FaseNuova) references Fase(Ricetta,Numero)
        on delete cascade
		on update set null
    

)

create table Fase
(   

   Ricetta              varchar(20),
   Numero               integer,
   Ingrediente          varchar(20),
   Dose                 integer,
   Primario             varchar(20),
   Strumento            varchar(20),
   Testo                varchar(255),
   Durata               time,
   
   primary key(Numero,Ricetta),
   foreign key(Ricetta) references Ricetta(Nome)
        on delete cascade
		on update set null,
   foreign key(Strumento) references Strumento(Nome)
        on delete cascade
		on update set null,
   foreign key(Ingrediente) references Ingrediente(Nome)
        on delete cascade
		on update set null

)


create table SequenzaFasi
(
    Ricetta           varchar(20),
    Fase              numeric(4), /*secondo me è più chiaro chiamare NumFase e NumFasePrecedente,se non ho capito male.*/
    FasePrecedente    numeric(4),
    primary key(Ricetta,Fase),
    foreign key(Fase) references Fase(Numero)
        on delete cascade
		on update set null,
    foreign key(FasePrecedente) references Fase(Numero)
        on delete cascade
		on update set null,
    foreign key(Ricetta) references Ricetta(Nome)
        on delete cascade
		on update set null
)


