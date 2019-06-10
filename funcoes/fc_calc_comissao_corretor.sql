drop FUNCTION if EXISTS fc_calc_comissao_corretor

DELIMITER	|		
CREATE	FUNCTION	fc_calc_comissao_corretor(
	periodo varchar(30)
	,valor int
)		
RETURNS	numeric(7,2)	BEGIN		
DECLARE	var_comissao numeric(7,2);	
	IF(LOCATE('Inderteminado',periodo) > 0)
	THEN
		SET var_comissao = 0.05 * valor;
	ELSEIF(LOCATE('12',periodo))
	THEN
		SET var_comissao = 0.01 * valor;
	ELSEIF(LOCATE('24',periodo))
	THEN
		SET var_comissao = 0.02 * valor;
	ELSEIF(LOCATE('36',periodo))
	THEN
		SET var_comissao = 0.03 * valor;
	ELSEIF(LOCATE('48',periodo))
	THEN
		SET var_comissao = 0.04 * valor;
	ELSEIF(LOCATE('60',periodo))
	THEN
		SET var_comissao = 0.05 * valor;
	ELSE
		SET var_comissao = 0;
	END IF;
	

RETURN	var_comissao;		
END	|