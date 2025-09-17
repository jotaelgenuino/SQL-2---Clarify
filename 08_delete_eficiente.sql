CREATE DATABASE db1609_eficiente
GO

USE db1609_eficiente
GO

CREATE TABLE clientes(
cliente_id INT PRIMARY KEY,
nome_cliente VARCHAR(100),
data_cadastro DATETIME
);

CREATE TABLE pedidos(
pedido_id INT PRIMARY KEY,
cliente_id INT,
data_pedido DATETIME,
valor_total DECIMAL(10,2),
FOREIGN KEY (cliente_id)
REFERENCES clientes(cliente_id)
);

INSERT INTO clientes(cliente_id, nome_cliente, data_cadastro)
SELECT TOP 1000000
--Gerar o valor sequencial de 1 a infinito por cada linha. O over exige ordenar, isso é um truque do instrutor 
--para dizer que não quer em ordem pré definida.
	ROW_NUMBER() OVER(ORDER BY (SELECT NULL)),
	'Cliente ' + CAST(ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS VARCHAR(10)),
	DATEADD(DAY, -(ROW_NUMBER() OVER(ORDER BY (SELECT NULL))% 3650), GETDATE())
	FROM master.dbo.spt_values a, master.dbo.spt_values b;

	INSERT INTO pedidos(pedido_id, cliente_id, data_pedido, valor_total)
	SELECT TOP 1000000
	ROW_NUMBER() OVER(ORDER BY (SELECT NULL)),
	(ABS(CHECKSUM(NEWID())) % 1000000) +1, -- Atribuimos um cliente
	DATEADD(DAY, -(ROW_NUMBER() OVER(ORDER BY (SELECT NULL))% 3650), GETDATE()),
	CAST (RAND() * 1000 AS DECIMAL(10,2)) 
FROM master.dbo.spt_values a, master.dbo.spt_values b;

SELECT TOP 10 * FROM clientes;
SELECT TOP 10 * FROM pedidos;

BEGIN TRY
	BEGIN TRANSACTION
	--- AQUI FAREMOS UMA EXCLUSÃO EFICIENTE
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
	PRINT 'W=Erro durante a exclusão ' + ERROR_MESSAGE();	
END CATCH;

SELECT COUNT(*) FROM clientes;
SELECT COUNT(*) FROM pedidos;