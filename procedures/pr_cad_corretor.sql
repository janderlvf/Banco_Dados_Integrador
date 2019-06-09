drop PROCEDURE if exists pr_cad_corretor;
delimiter	$	
CREATE	PROCEDURE	pr_cad_corretor(
	IN in_nome varchar(50)
	, IN in_creci int
	, IN in_endereco varchar(100)
	, IN in_telefone varchar(50))

BEGIN	
	INSERT INTO Corretor(
		nome
		,creci
		,endereco
		,telefone

	)
	VALUES(
		in_nome
		,in_creci
		,in_endereco
		,in_telefone

	);
END	$		
delimiter	;


