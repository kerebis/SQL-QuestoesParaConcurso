CREATE DATABASE SistemaConcursos;
GO
USE SistemaConcursos;
GO

-- Tabela Área de Conhecimento
CREATE TABLE Area_de_Conhecimento (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Descricao TEXT
);
GO

-- Tabela Nível de Dificuldade
CREATE TABLE Nivel_de_Dificuldade (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL
);
GO

-- Tabela Tipo de Questão
CREATE TABLE Tipo_de_Questao (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Descricao VARCHAR(50) NOT NULL
);
GO

-- Tabela Questão
CREATE TABLE Questao (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Enunciado TEXT NOT NULL,
    Alternativas TEXT,
    Resposta_Correta VARCHAR(255),
    Area_de_Conhecimento_ID INT,
    Nivel_de_Dificuldade_ID INT,
    Tipo_de_Questao_ID INT,
    Data_de_Criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Ultima_Atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Area_de_Conhecimento_ID) REFERENCES Area_de_Conhecimento(ID),
    FOREIGN KEY (Nivel_de_Dificuldade_ID) REFERENCES Nivel_de_Dificuldade(ID),
    FOREIGN KEY (Tipo_de_Questao_ID) REFERENCES Tipo_de_Questao(ID)
);
GO

-- Tabela Banco de Questões
CREATE TABLE Banco_de_Questoes (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Descricao TEXT,
    Data_de_Criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Ultima_Atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- Tabela associativa para Questões e Bancos de Questões
CREATE TABLE Banco_Questao (
    Banco_ID INT,
    Questao_ID INT,
    Data_de_Adicao DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (Banco_ID, Questao_ID),
    FOREIGN KEY (Banco_ID) REFERENCES Banco_de_Questoes(ID),
    FOREIGN KEY (Questao_ID) REFERENCES Questao(ID)
);
GO

-- Tabela Prova
CREATE TABLE Prova (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Data_de_Criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Ultima_Atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Numero_de_Questoes INT,
    Tempo_Limite TIME
);
GO

-- Tabela associativa para Questões e Provas
CREATE TABLE Prova_Questao (
    Prova_ID INT,
    Questao_ID INT,
    Pontuacao DECIMAL(5,2),
    PRIMARY KEY (Prova_ID, Questao_ID),
    FOREIGN KEY (Prova_ID) REFERENCES Prova(ID),
    FOREIGN KEY (Questao_ID) REFERENCES Questao(ID)
);
GO

-- Tabela Candidato
CREATE TABLE Candidato (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Data_de_Nascimento DATE
);
GO

-- Tabela Resultado da Prova
CREATE TABLE Resultado_da_Prova (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Candidato_ID INT,
    Prova_ID INT,
    Pontuacao_Obtida DECIMAL(5,2),
    Comentarios TEXT,
    FOREIGN KEY (Candidato_ID) REFERENCES Candidato(ID),
    FOREIGN KEY (Prova_ID) REFERENCES Prova(ID)
);
GO

-- Tabela Relatórios e Estatísticas
CREATE TABLE Relatorios_e_Estatisticas (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Tipo_de_Relatorio VARCHAR(255),
    Data_de_Geracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    Dados TEXT
);
GO

CREATE PROCEDURE InserirQuestao
    @p_Enunciado TEXT,
    @p_Alternativas TEXT,
    @p_Resposta_Correta VARCHAR(255),
    @p_Area_de_Conhecimento_ID INT,
    @p_Nivel_de_Dificuldade_ID INT,
    @p_Tipo_de_Questao_ID INT
AS
BEGIN
    INSERT INTO Questao (Enunciado, Alternativas, Resposta_Correta, Area_de_Conhecimento_ID, Nivel_de_Dificuldade_ID, Tipo_de_Questao_ID)
    VALUES (@p_Enunciado, @p_Alternativas, @p_Resposta_Correta, @p_Area_de_Conhecimento_ID, @p_Nivel_de_Dificuldade_ID, @p_Tipo_de_Questao_ID);
END;
GO

CREATE PROCEDURE InserirBancoDeQuestoes
    @p_Nome VARCHAR(255),
    @p_Descricao TEXT
AS
BEGIN
    INSERT INTO Banco_de_Questoes (Nome, Descricao)
    VALUES (@p_Nome, @p_Descricao);
END;
GO

CREATE PROCEDURE InserirBancoDeQuestoes
    @p_Nome VARCHAR(255),
    @p_Descricao TEXT
AS
BEGIN
    INSERT INTO Banco_de_Questoes (Nome, Descricao)
    VALUES (@p_Nome, @p_Descricao);
END;
GO

CREATE PROCEDURE AssociarQuestaoAoBanco
    @p_Banco_ID INT,
    @p_Questao_ID INT
AS
BEGIN
    INSERT INTO Banco_Questao (Banco_ID, Questao_ID)
    VALUES (@p_Banco_ID, @p_Questao_ID);
END;
GO

CREATE PROCEDURE InserirProva
    @p_Nome VARCHAR(255),
    @p_Numero_de_Questoes INT,
    @p_Tempo_Limite TIME
AS
BEGIN
    INSERT INTO Prova (Nome, Numero_de_Questoes, Tempo_Limite)
    VALUES (@p_Nome, @p_Numero_de_Questoes, @p_Tempo_Limite);
END;
GO

CREATE PROCEDURE InserirCandidato
    @p_Nome VARCHAR(255),
    @p_Email VARCHAR(255),
    @p_Data_de_Nascimento DATE
AS
BEGIN
    INSERT INTO Candidato (Nome, Email, Data_de_Nascimento)
    VALUES (@p_Nome, @p_Email, @p_Data_de_Nascimento);
END;
GO

CREATE PROCEDURE AssociarQuestaoAProva
    @p_Prova_ID INT,
    @p_Questao_ID INT,
    @p_Pontuacao DECIMAL(5,2)
AS
BEGIN
    INSERT INTO Prova_Questao (Prova_ID, Questao_ID, Pontuacao)
    VALUES (@p_Prova_ID, @p_Questao_ID, @p_Pontuacao);
END;
GO
