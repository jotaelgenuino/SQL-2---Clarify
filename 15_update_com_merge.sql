CREATE DATABASE db1609_updatemerge;
GO

USE db1609_updatemerge;
GO

CREATE TABLE clientes(
cliente_id INT PRIMARY KEY,
nome_cliente VARCHAR(200),
total_pedido DECIMAL(10,2) DEFAULT 0.00,
status_cliente VARCHAR(50) DEFAULT 'Ativo'
);

CREATE TABLE pedidos(
pedido_id INT PRIMARY KEY,
cliente_id INT,
valor_pedido DECIMAL(10,2),
data_pedido DATETIME,
FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

INSERT INTO clientes (cliente_id, nome_cliente)
VALUES
(1, 'Caio Ross'),
(2, 'Gabriel Sousa'),
(3, 'Jotael Genuino'),
(4, 'Natalia Sales');

INSERT INTO pedidos(pedido_id, cliente_id, valor_pedido, data_pedido)
VALUES
(1, 1, 100.00, '2025-01-10'),
(2, 1, 150.00, '2025-01-10'),
(3, 2, 200.00, '2025-01-12'),
(4, 3, 50.00, '2025-02-05'),
(5, 3, 74.00, '2025-02-10');

-- Comparar os dados dessa tabela com a de pedidos atualizando os pedidos existentes e inserindo 
-- novos pedidos e excluindo pedidos que n�o s�o mais becessarios
CREATE TABLE novos_pedidos(
pedido_id INT PRIMARY KEY,
cliente_id INT,
valor_pedido DECIMAL(10,2),
data_pedido DATETIME,
);
INSERT INTO novos_pedidos
(pedido_id, cliente_id, valor_pedido, data_pedido)
VALUES
(2, 1, 160.00, '2025-01-01'), -- Pedido existente (Atualiza��o)
(6, 2, 300.00, '2025-01-02'), -- Novo pedido
(7, 3, 80.00, '2025-01-03'); -- Novo pedido

MERGE INTO pedidos AS target
USING novos_pedidos AS source
ON target.pedido_id = source.pedido_id

-- Quando houver a correspondencia de pedidos fazer o update
WHEN MATCHED THEN
	UPDATE SET 
	target.valor_pedido = source.valor_pedido,
	target.data_pedido = source.data_pedido

-- Quando n�o houver a correspondencia de pedido, fazer o insert
WHEN NOT MATCHED BY TARGET THEN
INSERT (pedido_id, cliente_id, valor_pedido, data_pedido)
VALUES (source.pedido_id, source.cliente_id, source.valor_pedido, source.data_pedido)

-- Quando houver correspondencia em pedidos, mas n�o em novos pedidos, fazer delete
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;

	SELECT * FROM pedidos