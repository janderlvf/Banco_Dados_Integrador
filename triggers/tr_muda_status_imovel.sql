drop TRIGGER IF EXISTS tr_muda_status_imovel;

delimiter	$	
CREATE	TRIGGER	tr_muda_status_imovel	BEFORE	INSERT	ON	Negocio	
FOR	EACH	ROW	
BEGIN
	DECLARE var_id_tipo_negocio int;


	SELECT id_tipo_negocio into var_id_tipo_negocio FROM Tipo_Negocio where Tipo_Negocio = 'Aluguel';

	if(new.id_tipo_negocio = var_id_tipo_negocio)
	THEN
		UPDATE Imovel SET STATUS='Alugado' WHERE ID_IMOVEL = new.id_imovel;
	ELSE
		UPDATE Imovel SET STATUS='Indisponivel' WHERE ID_IMOVEL = new.id_imovel;
	END IF;
END	$		
delimiter	;	