CREATE DATABASE db1609_alteravancada02;
GO

USE db1609_alteravancada02;

CREATE TABLE clientes(
cliente_id INT,
nome_cliente VARCHAR(100),
data_cadastro DATETIME
CONSTRAINT PK_clientes_cliente_id PRIMARY KEY (cliente_id)
);

INSERT INTO clientes(cliente_id, nome_cliente, data_cadastro)
VALUES
(1, 'Caio Ross', '2025-01-01'),
(2, 'Gabriel Sousa', '2025-01-01'),
(3, 'Jotael Genuino', '2025-01-01'),
(4, 'Natalia Sales', '2025-01-01');

-- Remover a chave primaria existente
ALTER TABLE clientes
DROP CONSTRAINT PK__clientes__cliente_id;

-- Adicionar uma nova chave primaria a uma coluna existente
ALTER TABLE clientes
ADD CONSTRAINT PK__clientes__nome_cliente PRIMARY KEY (nome_cliente);

-- Adicionar um indice para otimizar a consulta por data nesse exemplo

CREATE NONCLUSTERED INDEX IX_clientes_data_cadastro
ON clientes (data_cadastro);

-- Alterar um tipo
ALTER TABLE clientes
ALTER COLUMN nome_cliente TEXT;

--Adicionando uma nova coluna
ALTER TABLE clientes
ADD email_cliente VARCHAR(150);

ALTER TABLE clientes
DROP COLUMN email_cliente;

-- Verificar se o indice existe na tabela
SELECT * FROM sys.indexes WHERE name = 'IX_clientes_data_cadastro';


ALTER TABLE clientes
DROP CONSTRAINT PK_clientes_cliente_id;