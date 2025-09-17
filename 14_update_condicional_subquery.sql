CREATE DATABASE db1609_updatesubquery;
GO

USE db1609_updatesubquery;
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

INSERT INTO pedidos(pedido_id, cliente_id, valor_pedido, data_pedido)
VALUES
(1, 1, 100.00, '2025-01-10'),
(2, 1, 150.00, '2025-01-10'),
(3, 2, 200.00, '2025-01-12'),
(4, 3, 50.00, '2025-02-05'),
(5, 3, 74.00, '2025-02-10');

INSERT INTO clientes (cliente_id, nome_cliente)
VALUES
(1, 'Caio Ross'),
(2, 'Gabriel Sousa'),
(3, 'Jotael Genuino'),
(4, 'Natalia Sales');

-- Condição para garantir atualizar apenas clientes com pedidos
UPDATE clientes SET total_pedido = (SELECT SUM(valor_pedido)
FROM pedidos
WHERE pedidos.cliente_id = clientes.cliente_id
)
-- Condição que permite atualizar só clientes com pedidos
WHERE cliente_id IN (SELECT cliente_id FROM pedidos)

SELECT * FROM clientes;

--ASCII ART
--      _       _             _    ____                  _             
--     | | ___ | |_ __ _  ___| |  / ___| ___ _ __  _   _(_)_ __   ___  
--  _  | |/ _ \| __/ _` |/ _ \ | | |  _ / _ \ '_ \| | | | | '_ \ / _ \ 
-- | |_| | (_) | || (_| |  __/ | | |_| |  __/ | | | |_| | | | | | (_) |
--  \___/ \___/ \__\__,_|\___|_|  \____|\___|_| |_|\__,_|_|_| |_|\___/ 

-- Exemplo de Update com condições avançada
UPDATE clientes
SET status_cliente = 'Inativo'
WHERE total_pedido < 100.00;

SELECT * FROM clientes

UPDATE pedidos
SET valor_pedido = valor_pedido * 2
WHERE cliente_id = 3
AND data_pedido < '2025-03-03'

SELECT * FROM pedidos