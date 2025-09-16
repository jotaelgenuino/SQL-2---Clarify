CREATE DATABASE db1609_empresa_muito_legal;
GO

USE db1609_empresa_muito_legal
GO

CREATE TABLE clientes(
cliente_id INT PRIMARY KEY,
nome_cliente VARCHAR(100),
email_cliente VARCHAR(100),
-- Data e horario do inicio da validade do registro
data_inicio DATETIME2 GENERATED ALWAYS AS ROW START HIDDEN,
-- Data e hora do fim da validade do regitro
data_fim DATETIME2 GENERATED ALWAYS AS ROW END HIDDEN,
-- Definir o periodo de tempo durante o qual o resgitro � valido
PERIOD FOR SYSTEM_TIME (data_inicio, data_fim)
)
-- Ativando o versionamento do sistema e criando uma tabela de historico
WITH (SYSTEM_VERSIONING = on (HISTORY_TABLE = dbo.clientes_historico));

-- Criar tabela de historico que armazenara as vers�es anteriores dos dados 
--(Por padr�o o SQL server cria essa tabela automaticmente quando o versionamento � habilitado, mas podemos criar explicitamente se desejado)
CREATE TABLE clientes_historico(
cliente_id INT PRIMARY KEY,
nome_cliente VARCHAR(100),
email_cliente VARCHAR(100),
data_inicio  DATETIME2,
data_fim DATETIME2
)

INSERT INTO clientes(cliente_id, nome_cliente, email_cliente)
VALUES
(1, 'Caio Ross', 'kio199@gmail.com'),
(2, 'Gabriel Sousa', 'gabriel@gmail.com'),
(3, 'Jotael Genuino', 'jotael@gmail.com'),
(4, 'Natalia Sales', 'natalia@gmail.com')

-- Verificar os dados que acabamos de inserir
SELECT * FROM clientes

UPDATE clientes
SET nome_cliente = 'Caio Rossi', email_cliente = 'sem.email@gmail.com'
WHERE cliente_id = 1

SELECT * FROM clientes_historico

-- Inserindo dados em uma tabela temporaria
-- Essas tabelas s�o uteis para armazenar dados temporarios que n�o precisam persistir no banco de dados.

CREATE TABLE #clientes_temporarios (
cliente_id INT PRIMARY KEY,
nome_cliente VARCHAR(100),
email_cliente VARCHAR(100)
);

INSERT INTO #clientes_temporarios(cliente_id,nome_cliente,email_cliente)
VALUES
(5,'Stephen Hawking', 'hipervoid@gmail.com'),
(6,'Albert Einstein', 'linguinha@gmail.com')

SELECT * FROM #clientes_temporarios