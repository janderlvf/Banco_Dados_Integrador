drop PROCEDURE if exists  ;
delimiter	$	
CREATE	PROCEDURE	pr_cad_negocio(
	IN in_valor int
	, IN in_observacao varchar(255)
	, IN in_forma_pagamento varchar(255)
	, IN in_duracao varchar(255)
	, IN in_id_imovel INT
	, IN in_tipo_negocio varchar(255)
	, IN in_id_corretor int)	
BEGIN	
	
	INSERT INTO Negocio(
		valor
		,data_negocio
		,observacao
		,forma_pagto
		,duracao
		,id_imovel
		,id_tipo_negocio
		,id_corretor
	)
	VALUES(
		in_valor
		,CURDATE()
		,in_observacao
		,in_forma_pagton
		,in_duracao
		,in_id_imovel
		,in_id_tipo_negocio
		,in_id_corretor
	);
END	$		
delimiter	;


