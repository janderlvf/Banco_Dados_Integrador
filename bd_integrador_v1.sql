/* Lógico_IMOBILIARIA2: */
DROP DATABASE imobiliaria;
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

INSERT INTO Tipo_Imovel (tipo_imovel)
	Values ('Chacara'),
		   ('Terreno'),
		   ('Apartamento');
           
    
INSERT INTO Imovel (endereco, descricao , status, id_tipo_imovel) values 
		   ('Rua Claudia Avila', 'Casa 4 quartos com suite', 'Indisponivel', '1'),
		   ('Rua Claudio Felix', 'Terreno 500 m²', 'Alugado', '2'),
		   ('Avenida Luciano Fernandes', 'Apartamento 2 quartos com sacada', 'Indisponivel', '3'),
		   ('Rua Manoel Jose', 'Chacara 5 quartos', 'Alugado', '4'),
		   ('Av. Marcos Paulo', 'Casa 3 quartos', 'Disponivel', '1'),
		   ('Av. Maria Jose', 'Comercio para lojas ', 'Disponivel','2'),
		   ('Av. Roberto Carlos', 'Apartamento 3 quartos', 'Disponivel', '3');
   

INSERT INTO Cliente (endereco_cliente, nome , estado_civil, cpf, rg) 
	Values ('Rua Ana Avila', 'Marcos Jose ', 'Casado', '05838501824', 'MG14045120'),
		   ('Rua Theo Felix', 'Jander luis Viana', 'Solteiro', '15838521824', 'MG12045000'),
		   ('Avenida Luciano Alves Fernandes', 'Arthur Carvalho', 'Casado', '25830501824', 'MG12045810'),
		   ('Rua Manoel Joaquim Jose', 'Leonardo Souza', 'Casado', '35808501824', 'MG12005120'),
		   ('Av. Marcos Paulo Alvim', 'Leandro Quadros', 'Casado', '45831501824', 'MG14045121'),
		   ('Av. Maria Jose Calixto', 'Maria Joaquina de Amaral  ', 'Casado','55838501824', 'MG12045160'),
		   ('Av. Roberto Carlos dos Anjos', 'Raul Carlos', 'Casado', '65838501824', 'MG92045120');
                
           
INSERT INTO Corretor (nome ,creci , endereco, telefone) 
	Values ('Alan Marcos Jose ',  '14045120','Rua Ana Avila', '998182822'),
		   ('luis Viana', '12045000', 'Rua Theo Felix', '998672345' ),
		   ('Arthur Victor Carvalho', '12045810','Avenida Luciano Alves Fernandes', '989672345' ),
		   ( 'Carlos Leonardo Souza', '12005120','Rua Manoel Joaquim Jose', '9986723454' );

INSERT INTO Tipo_Negocio (tipo_negocio)
	Values ('Venda'),
		   ('Aluguel'); 
           
           
INSERT INTO Negocio (valor, data_negocio, observacao, forma_pagto, duracao,id_imovel, id_tipo_negocio, id_corretor) 
	Values ('100000', '28-10-2018', 'falta documentacao','DEPOSITO', '36 meses','3','1', '3'),
		   ('220000', '28-10-2010', 'entrega feita', 'DEPOSITO','36 meses','2','1', '2'),
		   ('5000', '28-10-2015', 'todo dia 5','DEPOSITO', '12 meses', '3','2', '3'),
		   ('333000', '28-10-2015', 'falta documentacao','DEPOSITO', '36 meses', '1','1', '1');
 
 -- select * from negocio;
 
  -- RELATORIOS
   
   -- Select id_imovel, endereco, descricao From Imovel Where status= 'Vendido';  
   
   -- Select id_negocio, valor From  negocio n , imovel i Where n.id_imovel = i.id_imovel and n.valor >= 100000 and i.status = 'Vendido';

	/*Select N.id_negocio, I.descricao, AVG(N.valor) from negocio N INNER join imovel I ON (N.id_negocio = I.id_imovel) GROUP BY id_negocio;*/
   
   -- SELECT C.nome, SUM(N.Valor) FROM corretor C , negocio N WHERE C.id_corretor = N.id_corretor and C.id_corretor = 3 ;

	
    