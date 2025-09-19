--CREATE DATABASE db1609_particionamentotabelas;
--GO

USE db1609_particionamentotabelas;
GO

IF EXISTS (
	SELECT * FROM sys.partition_schemes WHERE name = 'ps_ano')
		DROP PARTITION SCHEME ps_ano;
GO
IF EXISTS (
	SELECT * FROM sys.partition_functions WHERE name = 'pf_ano')
		DROP PARTITION FUNCTION pf_ano;
GO

/*
Dividir as tabelas grandes em parti��es para melhorar o desempenho e facilitar o gerenciamento de dados

O particionamento vai dividir a tabela com base em um valor de coluna, nesse exemplo usaremos datas
*/

--Criar a funcao de particionamento, ela que define como tudo vai ser distribuido

CREATE PARTITION FUNCTION pf_ano (DATE)
AS RANGE RIGHT FOR VALUES ('2010-12-31', '2011-12-31', '2012-12-31', '2013-12-31', '2014-12-31', '2015-12-31');
GO
-- Criaremos um esquema de particionamento que define como as parti��es ser�o distribuidas. (N�o os dados)
CREATE PARTITION SCHEME ps_ano
AS PARTITION pf_ano
-- Cada participa��o ser� mapeada aqui no TO, nesse caso todas parti��es est�o sendo alocadas no PRIMARY.
TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);
GO

-- Agora vamos efetivamente criar a tabela, usando o esquema de particionamento definido anteriormente
CREATE TABLE vendas(
	id INT NOT NULL,
	data DATE NOT NULL,
	valor DECIMAL(10,2),
	cliente_id INT,
	CONSTRAINT PK_vendas PRIMARY KEY NONCLUSTERED(id, data)
	)
ON ps_ano(data);
GO
-- Inserir os dados na tabela particionada, o SQL vai colocar automaticamente os dados nas parti��es corretas conforme a coluna data

INSERT INTO vendas(id, data, valor, cliente_id)
VALUES
(1, '2010-05-01', 150.00, 101),
(2, '2011-06-15', 150.00, 102),
(3, '2012-08-20', 150.00, 103),
(4, '2013-02-20', 150.00, 104),
(5, '2014-11-12', 150.00, 105),
(6, '2015-07-30', 150.00, 106);

-- Pode consultar a tabela normalmente, e o sql vai usar a tabela particionada para acelerar a busca

SELECT * FROM vendas WHERE data = '2012-08-20'