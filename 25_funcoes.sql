-- Funções para usar sempre que necessário.

IF OBJECT_ID('dbo.fn_media', 'FN') IS NULL
BEGIN
	EXEC('
		CREATE FUNCTION dbo.fn_media (
		@n1 DECIMAL(5,2),
		@n2 DECIMAL(5,2))
		RETURNS DECIMAL(5,2)
		AS
		BEGIN
			RETURN (@n1 + @n2) / 2
		END;
	');
END;
GO

-- Dados de exemplo (Tabela temporaria para não afetar nosso esquema)

IF OBJECT_ID ('tempdb..#Alunos') IS NOT NULL
	DROP TABLE #Alunos;

CREATE TABLE #Alunos(
	id INT IDENTITY PRIMARY KEY,
	nome VARCHAR(100),
	nota1 DECIMAL(10,2),
	nota2 DECIMAL(10,2)
	);

	INSERT INTO #Alunos (nome, nota1, nota2)
	VALUES
	('Caio', 8.5, 7.0),
	('Gabriel', 6.0, 5.5),
	('Jotael', 9.0, 9.5),
	('Natalia', 4.0, 5.0);

-- Consulta usando a função já existente

SELECT
	nome,
	nota1,
	nota2,
	dbo.fn_media(nota1, nota2) AS media_atual
	FROM #Alunos
	ORDER BY nome;
	GO

-- Criar uma nova função sem alterar a antiga (Classificar Aprovado/ Reprovado com base fn_media)

IF OBJECT_ID('dbo.fn_situacao2', 'FN') IS NOT NULL
	DROP FUNCTION dbo.fn_situacao2;
GO
CREATE FUNCTION dbo.fn_situacao2 (
	@n1 DECIMAL(5,2),
	@n2 DECIMAL(5,2))
	RETURNS VARCHAR(20)
	AS
	BEGIN
		DECLARE @media DECIMAL (5,2);
		SET @media = dbo.fn_media(@n1, @n2)

		RETURN CASE
			WHEN @media >=7 THEN 'Aprovado'
			ELSE 'Reprovado'
		END;
	END;
	GO

-- Consulta final usando as duas funções

SELECT
	a.nome,
	a.nota1,
	a.nota2,
	dbo.fn_media(a.nota1, a.nota2) AS Media,

	dbo.fn_situacao2(a.nota1, a.nota2) AS Situacao
FROM #Alunos AS a
ORDER BY Media DESC, Nome;