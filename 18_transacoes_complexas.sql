CREATE DATABASE db1609_transacoescomplexas;
GO

USE db1609_transacoescomplexas;
GO

CREATE TABLE clientes(
	cliente_id INT PRIMARY KEY,
	nome_cliente VARCHAR(200),
	saldo DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE pedidos(
	pedido_id INT PRIMARY KEY,
	cliente_id INT,
	valor DECIMAL(10,2),
	data_pedido DATETIME,
	FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
	);

INSERT INTO clientes (cliente_id, nome_cliente, saldo)
VALUES
(1, 'Mozart Frans Herald', '1000.00'),
(2, 'Bethoven da Silva', '2000.00');

INSERT INTO pedidos(pedido_id, cliente_id, valor, data_pedido)
VALUES
(1, 1, 300.00, '2025-03-10'),
(2, 2, 150.00, '2025-01-11');

-- Iniciando a transa��o

BEGIN TRANSACTION;
	--Atualizando o saldo do cliente ap�s o pedido
	UPDATE clientes
	SET saldo = saldo - 300
	WHERE cliente_id = 1;


	SAVE TRANSACTION SaldoAtualizado

	-- Inserir o novo pedido
	-- Simular um erro, for�ando a falha para testar o rollback
	BEGIN TRY
	INSERT INTO pedidos
	(pedido_id, cliente_id, valor, data_pedido)
	VALUES (3, 1, 500.00, '2025-03-12');

	-- Simulando um erro, demonstrando o rollback parcial
	-- Isso da erro pois o valor do pedido � maior que o saldo
	UPDATE clientes
	SET saldo = saldo - 500
	WHERE cliente_id = 1;
	-- Se tudo ocorrer bem, confirmamos a transa��o
	COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	PRINT 'Erro detectado: ' + ERROR_MESSAGE();
	-- Reverte as altera��es ap�s o savepoint em caso de erro
	ROLLBACK TRANSACTION SaldoAtualizado
	PRINT 'Transa��o revertida parcilamente. O saldo do cliente n�o foi alterado, mas o pedido foi adicionado';
END CATCH;

SELECT * FROM clientes;
SELECT * FROM pedidos;