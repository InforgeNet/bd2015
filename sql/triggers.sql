DELIMITER $$

/******************************************************************************
 * nuova_consegna si assicura che ogni volta che viene inserita una nuova     *
 * consegna il pony a cui viene assegnata sia libero.                         *
 ******************************************************************************/
CREATE TRIGGER nuova_consegna
BEFORE INSERT
ON Consegna
FOR EACH ROW
BEGIN
    SET @StatoPony = (SELECT P.Stato AS StatoPony
                        FROM Pony P WHERE P.id = new.Pony);

    IF @StatoPony != "libero" THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Assegnamento di una consegna a un pony non libero.';
    END IF;
END$$
DELIMITER ;
