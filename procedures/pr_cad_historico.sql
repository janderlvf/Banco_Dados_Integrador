
drop procedure IF EXISTS pr_cad_historico;

DELIMITER $$
 
CREATE PROCEDURE pr_cad_historico(
IN  in_id_cliente INT
,IN in_id_imovel INT)
BEGIN
   DECLARE msg varchar(255);

   IF(in_id_cliente	IS NULL)	
   THEN	
		SET	msg	=	'ID CLIENTE DEVE SER INFORMADO';	
		SIGNAL	SQLSTATE	'45000'	SET	MESSAGE_TEXT	=	msg;
	END IF;

   IF(in_id_imovel IS NULL)	
   THEN	
		SET	msg	=	'ID IMOVEL DEVE SER INFORMADO';	
		SIGNAL	SQLSTATE	'45000'	SET	MESSAGE_TEXT	=	msg;
	END IF;
      
	INSERT INTO Historico(id_imovel,id_cliente,status,data_efetivacao)
	VALUES(in_id_imovel,in_id_cliente,'ATUAL',CURDATE());


END $$
DELIMITER ;