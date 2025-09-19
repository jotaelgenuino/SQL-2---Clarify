-- Criação de triggers avançadas
-- Obejetivo: Usar as triggers para automação de tarefas
-- A trigger será configurada para realizar auditoria automatica após as inserções, atualizações e exclusões

IF NOT EXISTS (SELECT 1 FROM sys.databases
WHERE name = 'db1609_automacaotriggers')
CREATE DATABASE db1609_automacaotriggers;
GO

USE db1609_automacaotriggers;
GO

IF OBJECT_ID('trg_AuditoriaInsercao', 'TR') IS NOT NULL
DROP TRIGGER trg_AuditoriaInsercao
GO
IF OBJECT_ID('trg_AuditoriaExclusao', 'TR') IS NOT NULL
DROP TRIGGER trg_AuditoriaExclusao
GO
IF OBJECT_ID('trg_AuditoriaAtualizacao', 'TR') IS NOT NULL
DROP TRIGGER trg_AuditoriaAtualizacao
GO
IF OBJECT_ID('auditoria_vendas', 'U') IS NOT NULL
DROP TABLE auditoria_vendas
GO
IF OBJECT_ID('vendas', 'U') IS NOT NULL
DROP TABLE vendas
GO

-- Criação da tabela de auditoria para registrar alteações nos dados
CREATE TABLE auditoria_vendas(
	id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
	id_venda INT,
	valor_venda DECIMAL(10,2),
	data_venda DATE, -- Somente a DATA
	operacao NVARCHAR(50), -- Tipo: INSERT, UPDATE...
	data_operacao DATETIME, -- DATA e HORA
	usuario NVARCHAR(50) -- Usuário que afetou a operação
	);

-- Criação da tabela vendas complementar ao exercicio
CREATE TABLE vendas (
	id_venda INT PRIMARY KEY,
	valor_venda DECIMAL(10,2),
	data_venda DATE
);

GO

--Criação da trigger para a auditoria após a inserção da tabela vendas
CREATE TRIGGER trg_AuditoriaInsercao
	ON vendas
	AFTER INSERT
	AS
	BEGIN
		INSERT INTO auditoria_vendas(id_venda, valor_venda, data_venda, operacao, data_operacao, usuario)
		SELECT id_venda, valor_venda, data_venda, 'INSERT', GETDATE(), SYSTEM_USER
		FROM inserted; -- INSERTED contem os dados da linha
		PRINT 'Dados inseridos na tabela de auditoria após inserir a venda na tabela vendas';
	END;
	GO

--Criação da trigger para a auditoria após a exclusão da tabela de vendas
CREATE TRIGGER trg_AuditoriaExclusao
	ON vendas
	AFTER DELETE
	AS
	BEGIN 
		INSERT INTO auditoria_vendas(id_venda, valor_venda, data_venda, operacao, data_operacao, usuario)
		SELECT id_venda, valor_venda, data_venda, 'DELETE', GETDATE(), SYSTEM_USER
		FROM deleted;
		PRINT 'Dados inseridos na tabela de auditoria após excluir a venda na tabela vendas';
	END;
	GO

--Criação da trigger para a auditoria após a atualização da tabela de vendas
CREATE TRIGGER trg_AuditoriaAtualizacao
	ON vendas
	AFTER UPDATE
	AS
	BEGIN
		INSERT INTO auditoria_vendas (id_venda, valor_venda, data_venda, operacao, data_operacao, usuario)
		SELECT id_venda, valor_venda, data_venda, 'UPDATE', GETDATE(), SYSTEM_USER
		FROM inserted;
		PRINT 'Dados inseridos na tabela de auditoria após atualizar a venda na tabela vendas';
	END;
	GO

	INSERT INTO vendas (id_venda, valor_venda, data_venda)
	VALUES (1, 150, '2025-01-01');

	UPDATE vendas SET valor_venda = 200 WHERE id_venda = 1;

	DELETE FROM vendas WHERE id_venda = 1;

	SELECT * FROM auditoria_vendas
