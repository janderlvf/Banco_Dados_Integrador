/* ################################################################# CREATE TABLES ###############################################################33 */

DROP DATABASE IF EXISTS imobiliaria;
create database imobiliaria;
use imobiliaria;

CREATE TABLE Imovel (
    id_imovel int auto_increment PRIMARY KEY,
    endereco VARCHAR(50),
    descricao VARCHAR(100),
    status  ENUM ('Indisponivel', 'Alugado', 'Disponivel','Reforma'),
    id_tipo_imovel int
);


CREATE TABLE Cliente (
    id_cliente int auto_increment PRIMARY KEY,
    endereco_cliente VARCHAR(100),
    nome VARCHAR(50) NOT NULL,
    estado_civil VARCHAR(50),
    cpf VARCHAR(18) UNIQUE,
    rg VARCHAR(18) UNIQUE
);


CREATE TABLE Tipo_Imovel (
    id_tipo int auto_increment PRIMARY KEY,
    tipo_imovel VARCHAR(50) NOT NULL
);


CREATE TABLE Corretor (
    id_corretor int  auto_increment PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    creci int UNIQUE NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    telefone VARCHAR(50) NOT NULL
);


CREATE TABLE Tipo_Negocio (
    id_tipo_negocio int auto_increment PRIMARY KEY,
    tipo_negocio VARCHAR(50) NOT NULL
);

CREATE TABLE Negocio (
    id_negocio int auto_increment PRIMARY KEY,
    valor int NOT NULL,
    data_negocio VARCHAR(50),
    observacao VARCHAR(100),
    forma_pagto ENUM('DEPOSITO','BOLETO'),
    duracao  ENUM ('INDETERMINADO', '12 meses', '24 meses', '36 meses' ,'48 meses', '60 meses'),
    id_imovel int,
    id_tipo_negocio int,
    id_corretor int
);

CREATE TABLE Historico (
    id_imovel int,
    id_cliente int,
    status ENUM ('ATUAL', 'ANTIGO') NOT NULL,
    data_efetivacao DATE NOT NULL
);

CREATE TABLE Participacao (
    id_cliente int,
    id_negocio int,
    tipo_participacao ENUM('COMPRADOR','VENDEDOR','LOCADOR','LOCATARIO')
);
 
ALTER TABLE Imovel ADD CONSTRAINT FK_Imovel_2
    FOREIGN KEY (id_tipo_imovel)
    REFERENCES Tipo_Imovel (id_tipo)
    ON DELETE RESTRICT;
 
ALTER TABLE Negocio ADD CONSTRAINT FK_Negocio_2
    FOREIGN KEY (id_imovel)
    REFERENCES Imovel (id_imovel)
    ON DELETE CASCADE;
 
ALTER TABLE Negocio ADD CONSTRAINT FK_Negocio_3
    FOREIGN KEY (id_tipo_negocio)
    REFERENCES Tipo_Negocio (id_tipo_negocio)
    ON DELETE RESTRICT;
 
ALTER TABLE Negocio ADD CONSTRAINT FK_Negocio_4
    FOREIGN KEY (id_corretor)
    REFERENCES Corretor (id_corretor)
    ON DELETE CASCADE;
 
ALTER TABLE Historico ADD CONSTRAINT FK_Historico_1
    FOREIGN KEY (id_imovel)
    REFERENCES Imovel (id_imovel)
    ON DELETE SET NULL;
 
ALTER TABLE Historico ADD CONSTRAINT FK_Historico_2
    FOREIGN KEY (id_cliente)
    REFERENCES Cliente (id_cliente)
    ON DELETE SET NULL;
 
ALTER TABLE Participacao ADD CONSTRAINT FK_Participacao_1
    FOREIGN KEY (id_cliente)
    REFERENCES Cliente (id_cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Participacao ADD CONSTRAINT FK_Participacao_2
    FOREIGN KEY (id_negocio)
    REFERENCES Negocio (id_negocio)
    ON DELETE RESTRICT;


/* ################################################################# PROCEDURES ###############################################################33 */ 

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
		in_endereco
		,in_nome
		,in_estado_civil
		,in_cpf
		,in_rg

	);
END	$		
delimiter	;

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

drop PROCEDURE if exists pr_cad_negocio;
delimiter	$	
CREATE	PROCEDURE	pr_cad_negocio(
	IN in_valor int
	, IN in_observacao varchar(255)
	, IN in_forma_pagamento varchar(255)
	, IN in_duracao varchar(255)
	, IN in_id_imovel INT
	, IN in_id_tipo_negocio varchar(255)
	, IN in_id_corretor int
	, IN in_id_cliente1 INT 
	, IN in_id_cliente2 INT
	, IN in_tipo_participacao_cliente1 varchar(30)
	, IN in_tipo_participacao_cliente2 varchar(30))	
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
		,in_forma_pagamento
		,in_duracao
		,in_id_imovel
		,in_id_tipo_negocio
		,in_id_corretor
	);

	insert into Participacao(id_cliente, tipo_participacao) values(in_id_cliente1,in_tipo_participacao_cliente1)
	,(in_id_cliente2,in_tipo_participacao_cliente2);
END	$		
delimiter	;

/* ################################################################# TRIGGERS ###############################################################33 */ 
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
		UPDATE Historico SET STATUS='ANTIGO' WHERE ID_IMOVEL = var_id_imovel;
		INSERT INTO Historico(id_imovel,id_cliente,status,data_efetivacao) values (var_id_imovel,new.id_cliente,'ATUAL',CURDATE());
	END IF;
END	$		
delimiter	;	

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


/* ################################################################# FUNCTIONS ###############################################################33 */ 


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
DELIMITER ;

/* ################################################################# INSERTS ###############################################################33 */ 

INSERT INTO Tipo_Imovel (tipo_imovel)
	Values ('Chacara'),
		   ('Terreno'),
		   ('Apartamento');

INSERT INTO Tipo_Negocio (tipo_negocio)
	Values ('Venda'),
		   ('Aluguel'); 
		   
CALL imobiliaria.pr_cad_corretor('Alan Marcos Jose ',  14045120,'Rua Ana Avila', '998182822');
CALL imobiliaria.pr_cad_corretor('luis Viana', 12045000, 'Rua Theo Felix', '998672345' );
CALL imobiliaria.pr_cad_corretor('Arthur Victor Carvalho', 12045810,'Avenida Luciano Alves Fernandes', '989672345' );
CALL imobiliaria.pr_cad_corretor( 'Carlos Leonardo Souza', 12005120,'Rua Manoel Joaquim Jose', '9986723454' );


CALL imobiliaria.pr_cad_cliente('Rua Ana Avila', 'Marcos Jose ', 'Casado', '05838501824', 'MG14045120');
CALL imobiliaria.pr_cad_cliente('Rua Theo Felix', 'Jander luis Viana', 'Solteiro', '15838521824', 'MG12045000');
CALL imobiliaria.pr_cad_cliente('Avenida Luciano Alves Fernandes', 'Arthur Carvalho', 'Casado', '25830501824', 'MG12045810');
CALL imobiliaria.pr_cad_cliente('Rua Manoel Joaquim Jose', 'Leonardo Souza', 'Casado', '35808501824', 'MG12005120');
CALL imobiliaria.pr_cad_cliente('Av. Marcos Paulo Alvim', 'Leandro Quadros', 'Casado', '45831501824', 'MG14045121');
CALL imobiliaria.pr_cad_cliente('Av. Maria Jose Calixto', 'Maria Joaquina de Amaral  ', 'Casado','55838501824', 'MG12045160');
CALL imobiliaria.pr_cad_cliente('Av. Roberto Carlos dos Anjos', 'Raul Carlos', 'Casado', '65838501824', 'MG92045120');


CALL imobiliaria.pr_cad_imovel('Casa 4 quartos com suite', 'Indisponivel','Chacara','Rua Claudia Avila','05838501824');
CALL imobiliaria.pr_cad_imovel('Terreno 500 m²', 'Alugado','Terreno','Rua Claudio Felix','15838521824');
CALL imobiliaria.pr_cad_imovel('Apartamento 2 quartos com sacada','Alugado','Apartamento','Avenida Luciano Fernandes','25830501824');
CALL imobiliaria.pr_cad_imovel('Chacara 5 quartos', 'Indisponivel','Chacara','Rua Manoel Jose','35808501824');
CALL imobiliaria.pr_cad_imovel( 'Casa 3 quartos','Alugado', 'Chacara','Av. Maria Jose','35808501824');
CALL imobiliaria.pr_cad_imovel('Comercio para lojas' ,'Disponivel','Terreno','Av. Roberto Carlos','05838501824');
CALL imobiliaria.pr_cad_imovel( 'Apartamento 3 quartos', 'Disponivel','Apartamento','Av. Marcos Paulo','05838501824');

CALL imobiliaria.pr_cad_negocio(100000, 'falta documentacao','DEPOSITO','36 meses',3,1,3,1,2,'Comprador','Vendedor');
CALL imobiliaria.pr_cad_negocio(220000, 'entrega feita','BOLETO','36 meses',2,1,2,1,2,'Comprador','Vendedor');
CALL imobiliaria.pr_cad_negocio(5000, 'todo dia 5','BOLETO','12 meses',3,2,3,1,2,'Comprador','Vendedor');
CALL imobiliaria.pr_cad_negocio(333000, 'falta documentacao','DEPOSITO','24 meses',3,1,3,1,2,'Comprador','Vendedor');


/* ################################################################# RELATORIOS ###############################################################33 */ 

 -- select * from negocio;
 
  -- RELATORIOS
   
   -- Select id_imovel, endereco, descricao From Imovel Where status= 'Vendido';  
   
   -- Select id_negocio, valor From  negocio n , imovel i Where n.id_imovel = i.id_imovel and n.valor >= 100000 and i.status = 'Vendido';

	/*Select N.id_negocio, I.descricao, AVG(N.valor) from negocio N INNER join imovel I ON (N.id_negocio = I.id_imovel) GROUP BY id_negocio;*/
   
   -- SELECT C.nome, SUM(N.Valor) FROM corretor C , negocio N WHERE C.id_corretor = N.id_corretor and C.id_corretor = 3 ;

	
    