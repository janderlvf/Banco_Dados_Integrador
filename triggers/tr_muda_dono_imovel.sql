drop TRIGGER IF EXISTS tr_muda_dono_imovel;

delimiter	$	
CREATE	TRIGGER	tr_muda_dono_imovel	BEFORE	INSERT	ON	Participacao	
FOR	EACH	ROW	
BEGIN
	DECLARE var_id_cliente int;
	DECLARE var_id_imovel int;

	if(new.tipo_participacao = 'Comprador')
	THEN
		SELECT n.id_imovel INTO var_id_imovel   FROM Negocio n where new.id_negocio = n.id_negocio;
		UPDATE HISTORICO SET STATUS='ANTIGO' WHERE ID_IMOVEL = var_id_imovel;
		INSERT INTO Historico(id_imovel,id_cliente,status,data_efetivacao) values (var_id_imovel,new.id_cliente,'ATUAL',CURDATE());
	END IF;
END	$		
delimiter	;	