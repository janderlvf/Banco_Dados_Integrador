drop PROCEDURE if exists pr_cad_cliente;
delimiter	$	
CREATE	PROCEDURE	pr_cad_cliente(
	IN in_endereco varchar(100)
	,IN in_nome varchar(50)
	,IN in_estado_civil varchar(50)
	,IN in_cpf varchar(18)
	,IN in_rg varchar(18))

BEGIN	
	INSERT INTO Cliente(
		endereco_cliente
		,nome
		,estado_civil
		,cpf
		,rg

	)
	VALUES(
		in_endereco_cliente
		,in_nome
		,in_estado_civil
		,in_cpf
		,in_rg

	);
END	$		
delimiter	;


