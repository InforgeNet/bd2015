DELIMITER $$

/******************************************************************************
 * nuova_consegna si assicura che ogni volta che viene inserita una nuova     *
 * consegna il pony a cui viene assegnata sia libero e che la comanda sia     *
 * effettivamente in attesa di consegna.                                      *
 ******************************************************************************/
CREATE TRIGGER nuova_consegna
BEFORE INSERT
ON Consegna
FOR EACH ROW
BEGIN
    SET @StatoPony = (SELECT P.Stato AS StatoPony
                        FROM Pony P
                        WHERE P.ID = new.Pony);

    SET @StatoConsegna = (SELECT C.stato AS StatoConsegna
                                FROM Comanda C
                                WHERE C.ID = new.ID);
                                
    IF @StatoPony <> 'libero' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Assegnamento di consegna a pony non libero.';
    ELSE IF @StatoConsegna <> 'consegna' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Comanda relativa non pronta per la consegna.';
    END IF;
END$$
DELIMITER ;
