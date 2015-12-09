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
                        WHERE P.ID = NEW.Pony);

    SET @StatoComanda = (SELECT C.stato AS StatoComanda
                                FROM Comanda C
                                WHERE C.ID = NEW.ID);
                                
    IF @StatoPony <> 'libero' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Assegnamento di consegna a pony non libero.';
    ELSE IF @StatoComanda <> 'consegna' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Comanda relativa non pronta per la consegna.';
    END IF;
END$$
DELIMITER ;
