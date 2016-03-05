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
