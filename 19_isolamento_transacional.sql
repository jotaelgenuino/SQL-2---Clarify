CREATE DATABASE db1609_isolamentotransacional;
GO

USE db1609_isolamentotransacional;
GO

CREATE TABLE produtos(
	produto_id INT PRIMARY KEY,
	nome_produto VARCHAR(100),
	quantidade INT,
	preco DECIMAL(10,2)
);


INSERT INTO produtos(produto_id, nome_produto, quantidade, preco)
VALUES
(1, 'Camiseta', 100, '50.00'),
(2, 'Cal�a', 50, '100.00'),
(3, 'Tenis', 75, '150.00');

SELECT * FROM produtos;

/*
Exemplo de controle de isolamento transacional
Para observar o comportamento vamos realizar algumas opera��es
A) Usar diferentes niveis de isolamento
B) Simular transa��es recorrentes
*/

-- Come�ando com uma transa��o com nivel de isolamento "READ UNCOMMITTED"
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN  TRANSACTION;
		-- Ler os dados da tabela produtos, permitindo dados n�o confirmados (dirty read)
		PRINT 'Transa��o 1 (READ UNCOMMITTED)';
		SELECT * FROM produtos

		-- Alterando dados de quantidade sem confirmar a transa��o
		UPDATE produtos
		SET quantidade = quantidade -10
		WHERE produto_id = 1;

		-- Simulando alguma processamento
		WAITFOR DELAY '00:00:10'-- Atraso de 10 segundos
COMMIT TRANSACTION;

-- Come�ando uma transa��o com o n�vel de isolamento "serializable"
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;

-- Tentar ler e bloquear a linha de produto_id 1
	PRINT 'Transa��o 2 (Serializable)';
	SELECT * FROM produtos WHERE produto_id = 1;
	WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;

SELECT * FROM produtos