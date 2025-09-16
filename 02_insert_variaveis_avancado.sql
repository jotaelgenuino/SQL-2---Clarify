-- Usar a tabela vendas j� criada no exercicio anterior 

USE db1609_vendas
GO

--Inserir a coluna de valor total que falta na tabela de vendas
ALTER TABLE vendas
ADD valor_total DECIMAL(10,2)

--Realizar multiplas inser��es de forma controlada, usando variaveis para armazenar dados

--Inicializar transa��o
BEGIN TRANSACTION;

--Declarar as variaveis
DECLARE @cliente_id INT = 1; -- Cliente para o pedido (Jotael)
DECLARE @produto_id INT = 2; --Produto comprado (Smartphone)
DECLARE @quantidade INT = 3; -- Quantidade comprada (3 Unidades)
DECLARE @valor_total DECIMAL (10,2); -- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE() -- Data Atual da venda
DECLARE @status_transacao VARCHAR (50);

--Calcular o valor total da venda
SELECT @valor_total = p.preco * @quantidade
FROM produtos p
WHERE p.produto_id = @produto_id;

--Valida��o para garantir que a quantidade seja valida
IF @quantidade <= 0
BEGIN
SET @status_transacao = 'Falha: Quantidade Inv�lida';
ROLLBACK TRANSACTION; -- Reverte a transa��o caso a quantidade seja inv�lida
PRINT @status_transacao;
RETURN;
END

--Inserindo outra venda usando nosso novo 'metodo'
INSERT INTO vendas (cliente_id, produto_id, quantidade, valor_total, data_venda)
VALUES (@cliente_id,@produto_id, @quantidade, @valor_total, @data_venda);

-- Validando o sucesso da inser��o
IF @@ERROR <> 0
BEGIN
SET @status_transacao = 'Falha: Erro na inser��o da venda'
ROLLBACK TRANSACTION;
PRINT @status_transacao;
RETURN;
END

-- Se todas as inser��es forem OK, confirma a transa��o
SET @status_transacao = 'Sucesso: Vendas inseridas com sucesso'
COMMIT TRANSACTION; -- Confirmando a transa��o

--Verificando o status da transa��o
PRINT @status_transacao

--Verificando os dados inseridos
SELECT * FROM vendas;

--------------------CASO DE FALHA---------------------

BEGIN TRANSACTION;

DECLARE @cliente_id INT = 1; -- Cliente para o pedido (Jotael)
DECLARE @produto_id INT = 2; --Produto comprado (Smartphone)
DECLARE @quantidade INT = 3; -- Quantidade comprada (3 Unidades)
DECLARE @valor_total DECIMAL (10,2); -- Valor total do pedido
DECLARE @data_venda DATETIME = GETDATE() -- Data Atual da venda
DECLARE @status_transacao VARCHAR (50);

SET @quantidade = -1;
SET @cliente_id = 1;
SET @produto_id = 1;
SET @data_venda = GETDATE()

SELECT @valor_total = p.preco * @quantidade
FROM produtos p
WHERE p.produto_id = @produto_id;

IF @quantidade <= 0
BEGIN
SET @status_transacao = 'Falha: Quantidade Inv�lida';
ROLLBACK TRANSACTION; -- Reverte a transa��o caso a quantidade seja inv�lida
PRINT @status_transacao;
RETURN;
END

--Inserindo outra venda usando nosso novo 'metodo'
INSERT INTO vendas (cliente_id, produto_id, quantidade, valor_total, data_venda)
VALUES (@cliente_id,@produto_id, @quantidade, @valor_total, @data_venda);
