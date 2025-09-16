/*
Este script demonstra como realizar inserções em lotes utilizando transações, ou seja, inserir grandes volumes
de dados de forma eficiente dividindo as inserções em pequenos lotes ('batches' ou 'chunks') ajuda a evitar 
quebras e melhora o desempenho do banco
*/

--Seleciona o banco de dados que vamos utilizar
USE db1609_empresa_muito_legal
GO

--Criar Tabela
CREATE TABLE vendas (
venda_id INT IDENTITY(1,1) PRIMARY KEY,
cliente_id INT,
produto_id INT,
quantidade INT,
valor_total DECIMAL(10,2),
data_venda DATETIME
);

--Variaveis para controle dos lotes
DECLARE @batch_size INT = 1000; -- Tamanho do lote (Quantidade maxima de resgistros)
DECLARE @total_registros INT = 10000; -- Total de registro que desejamos inserir
DECLARE @contador INT = 0; -- Contador de inserções realizadas

BEGIN TRY
-- Iniciar a transação para garantir que inserçoes de cada lote sejam atomicas

WHILE @contador < @total_registros
BEGIN
-- Iniciando a transação
BEGIN TRANSACTION
-- Inserindo um lote de registros na tabela venda
INSERT INTO vendas (cliente_id, produto_id, quantidade, valor_total, data_venda)
SELECT
-- Gerando um cliente_id aleatorio entre 1 e 1000
ABS(CHECKSUM(NEWID())) % 1000 + 1,
ABS(CHECKSUM(NEWID())) % 100 + 1,
ABS(CHECKSUM(NEWID())) % 10 + 1,
-- Gerando um valor_total aleatorio entre 1 e 1000
(ABS(CHECKSUM(NEWID())) % 1000 + 1) *10,
-- Data da venda será a data e hora atual
GETDATE()
FROM master.dbo.spt_values t1
CROSS JOIN master.dbo.spt_values t2
WHERE t1.type = 'P' AND t2.type = 'P'
ORDER BY NEWID()
-- Inserção de apenas um lote
OFFSET @contador ROWS FETCH NEXT @batch_size ROW ONLY;

-- Atualizar o contador de registros inseridos
SET @contador = @contador + @batch_size;
-- Confirmando a transação e comitando

COMMIT TRANSACTION
-- Exibindo uma pensagem de progresso
PRINT 'lote' + CAST(@contador / @batch_size AS VARCHAR) + 'inseridos com sucesso!'

END
END TRY
BEGIN CATCH 
-- Caso ocorra algum erro realizamos um rollback da transação

IF @@TRANCOUNT > 0
BEGIN
ROLLBACK TRANSACTION
END
PRINT 'Erro: ' + ERROR_MESSAGE();
END CATCH

--Verificar o que tem na tabela
SELECT COUNT(*) AS Total_Vendas FROM vendas;
