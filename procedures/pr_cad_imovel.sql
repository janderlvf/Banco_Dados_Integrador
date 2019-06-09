
drop procedure  if EXISTS pr_cad_imovel;

DELIMITER $$
 
CREATE PROCEDURE pr_cad_imovel(
IN in_descricao varchar(255)
,IN in_status varchar(40)
,IN in_tipo_imovel varchar(40)
,IN in_endereco varchar(255)
,IN in_cpf varchar(15))
BEGIN
   DECLARE var_id_tipo_imovel INT ;
   DECLARE var_id_cliente INT;
   DECLARE msg varchar(255);
   
    select id_tipo into var_id_tipo_imovel from Tipo_Imovel where tipo_imovel = in_tipo_imovel;
  	select id_cliente into var_id_cliente from Cliente where cpf = in_cpf;
   
   IF(var_id_tipo_imovel	IS NULL)	
   THEN	
		SET	msg	=	'TIPO DE IMOVEL NAO LOCALIZADO';	
		SIGNAL	SQLSTATE	'45000'	SET	MESSAGE_TEXT	=	msg;
	END IF;

   IF(var_id_cliente IS NULL)	
   THEN	
		SET	msg	=	'CLIENTE INFORMADO NAO CADASTRADO';	
		SIGNAL	SQLSTATE	'45000'	SET	MESSAGE_TEXT	=	msg;
	END IF;
      
	INSERT INTO Imovel(endereco,descricao,status,id_tipo_imovel)
	VALUES(in_endereco,in_descricao,in_status,var_id_tipo_imovel);

	CALL pr_cad_historico(var_id_cliente,(SELECT MAX(id_imovel) from Imovel));


END $$
DELIMITER ;
