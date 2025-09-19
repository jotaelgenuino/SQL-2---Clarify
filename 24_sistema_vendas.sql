IF NOT EXISTS (SELECT 1 FROM sys.databases
WHERE name = 'db1609_sistema_vendas')
CREATE DATABASE db1609_sistema_vendas;
GO

USE db1609_sistema_vendas;
GO

IF OBJECT_ID ('clientes', 'U') IS NOT NULL
DROP TABLE clientes;
GO

IF OBJECT_ID ('produtos', 'U') IS NOT NULL
DROP TABLE produtos;
GO

IF OBJECT_ID ('vendas', 'U') IS NOT NULL
DROP TABLE vendas;
GO

IF OBJECT_ID ('auditoria_vendas', 'U') IS NOT NULL
DROP TABLE auditoria_vendas;
GO

IF OBJECT_ID ('trg_AuditoriaInsercao', 'TR') IS NOT NULL
DROP TRIGGER trg_AuditoriaInsercao;
GO

IF OBJECT_ID ('trg_AuditoriaExclusao', 'TR') IS NOT NULL
DROP TRIGGER trg_AuditoriaExclusao;
GO

CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(100) NOT NULL,
	email_cliente VARCHAR(100),
	data_cadastro DATETIME DEFAULT GETDATE(),
	status NVARCHAR(20) DEFAULT 'Ativa'
);
GO

CREATE TABLE produtos(
	Produto_id INT PRIMARY KEY,
	nome_produto VARCHAR(100) NOT NULL,
	preco DECIMAL(10,2) NOT NULL,

	status NVARCHAR(20) DEFAULT 'Ativa'
);
GO

CREATE TABLE vendas(
	venda_id INT IDENTITY(1,1) PRIMARY KEY,
	cliente_id INT NOT NULL,
	produto_id INT NOT NULL,
	quantidade INT NOT NULL,
	valor_total DECIMAL(10,2),
	data_venda DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id) ON DELETE CASCADE,
	FOREIGN KEY (cliente_id) REFERENCES clientes(produto_id) ON DELETE CASCADE
);
GO

CREATE TABLE auditoria_vendas(
	id_auditoria INT IDENTITY(1,1) PRIMARY KEY,
	venda_id INT,
	cliente_id INT,
	produto_id INT,
	quantidade INT,
	valor_total DECIMAL(10,2),
	data_venda DATETIME,
	operacao NVARCHAR(20),
	data_operacao DATETIME DEFAULT GETDATE(),
	usuario NVARCHAR(50) DEFAULT SYSTEM_USER
);
GO
-- TRIGGER --

CREATE TRIGGER trg_VendasInsercao
ON vendas
AFTER INSERT
AS
BEGIN
	INSERT INTO auditoria_vendas (venda_id, cliente_id, produto_id, quantidade, valor_total, data_venda, operacao)
	SELECT venda_id, cliente_id, produto_id, quantidade, valor_total, data_venda, 'INSERT'
	FROM inserted
END;
GO

CREATE TRIGGER trg_VendasExclusao
ON vendas
AFTER DELETE
AS
BEGIN
	INSERT INTO auditoria_vendas (venda_id, cliente_id, produto_id, quantidade, valor_total, data_venda, operacao)
	SELECT venda_id, cliente_id, produto_id, quantidade, valor_total, data_venda, 'DELETE'
	FROM deleted
END;
GO

CREATE TRIGGER trg_AuditoriaAtualizacao
ON vendas
AFTER UPDATE
AS
BEGIN
	INSERT INTO auditoria_vendas (venda_id, cliente_id, produto_id, quantidade, valor_total, data_venda, operacao)
	SELECT venda_id, cliente_id, produto_id, quantidade, valor_total, data_venda, 'UPDATE'
	FROM deleted
END;
GO

INSERT INTO clientes
(cliente_id, nome_cliente, email_cliente)
VALUES
(1, 'Caio', 'caio@gmail.com'),
(2, 'Gabriel', 'gabriel@gmail.com'),
(3, 'Jotael', 'jotael@gmail.com'),
(4, 'Natalia', 'natalia@gmail.com');

INSERT INTO produtos
(produto_id, nome_produto, preco)
VALUES
(1, 'Notebook', 3500.00),
(2, 'Smartphone', 2000.00),
(3, 'TV 900', 2500.00),
(4, 'Fone Cebrutius', 300.00);

INSERT INTO vendas
(cliente_id, produto_id, quantidade, valor_total)
VALUES
(1, 1, 1, 3500.00),
(2, 2, 2, 4000.00),
(3, 4, 3, 900.00),
(4, 3, 1, 2800.00),
(1, 2, 1, 3500.00);

-- CONSULTAS--

PRINT 'Total de Vendas por cliente';
SELECT c.nome_cliente, SUM(v.valor_total) AS total_vendas
FROM vendas v
JOIN clientes c ON v.cliente_id = c.cliente_id
GROUP BY c.nome_cliente
ORDER BY total_vendas DESC;

PRINT 'TOP 3 produtos mais vendidos';
SELECT p.nome_produto, SUM(v.quantidade) AS total_vendido
FROM vendas v
JOIN produtos p ON v.produto_id = p.produto_id
GROUP BY p.nome_produto
ORDER BY total_vendido DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-- VISUALIZAÇÂO DE CONSULTAS --

PRINT 'Auditoria de Operações'
SELECT * FROM auditoria_vendas

