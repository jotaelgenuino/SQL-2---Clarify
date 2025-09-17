CREATE DATABASE db1609_altercondicional;
GO

USE db1609_altercondicional;

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

SELECT * FROM clientes;
DECLARE @num_dados INT;
SELECT @num_dados = COUNT(*)
FROM clientes
WHERE nome_cliente IS NOT NULL;

PRINT 'Quantidade de dados na tabela ' + CAST(@num_dados AS VARCHAR);

IF @num_dados = 0
BEGIN
	ALTER TABLE clientes
	ALTER COLUMN nomecliente TEXT;
	PRINT 'Tipo de dado alterado para TEXT'
END
ELSE
BEGIN
	PRINT 'A coluna contem dados e não pode ser alterada para um novo tipo';
END

-- Verificar se a estrutura foi alterada com sucesso
EXEC sp_columns 'clientes';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA,COLUMNS
WHERE TABLE_NAME = 'clientes'