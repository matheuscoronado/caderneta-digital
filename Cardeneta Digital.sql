-- Criação do banco de dados
CREATE DATABASE cardeneta;
USE cardeneta;

-- Criação da tabela Usuario
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    tipo_usuario ENUM('aluno', 'docente', 'admin') NOT NULL
);

-- Criação da tabela Curso
CREATE TABLE Curso (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Criação da tabela Turma
CREATE TABLE Turma (
    id_turma INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    id_curso INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- Criação da tabela Aluno
CREATE TABLE Aluno (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_turma INT NOT NULL,
    matricula VARCHAR(50) UNIQUE NOT NULL,
    data_nascimento DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_turma) REFERENCES Turma(id_turma)
);

-- Criação da tabela Docente
CREATE TABLE Docente (
    id_docente INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    especialidade VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Criação da tabela Anotacao
CREATE TABLE Anotacao (
    id_anotacao INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    conteudo TEXT NOT NULL,
    data_anotacao DATE NOT NULL,
    status ENUM('em andamento', 'concluido', 'reprovado') NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno)
);

-- Criação da tabela Feedback
CREATE TABLE Feedback (
    id_feedback INT PRIMARY KEY AUTO_INCREMENT,
    id_anotacao INT NOT NULL,
    comentario TEXT,
    nota DECIMAL(3,1),
    tipo_feedback ENUM('docente', 'inteligencia_artificial') NOT NULL,
    data_feedback DATE,
    FOREIGN KEY (id_anotacao) REFERENCES Anotacao(id_anotacao)
);

-- Criação da tabela de Log para registrar alterações
CREATE TABLE Log_Alteracoes (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    tabela VARCHAR(50) NOT NULL,
    id_registro INT NOT NULL,
    acao ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    data_alteracao DATETIME NOT NULL,
    detalhes TEXT
);

-- Criação da tabela de Histórico de Nomes
CREATE TABLE Historico_Nomes (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    nome_antigo VARCHAR(100) NOT NULL,
    nome_novo VARCHAR(100) NOT NULL,
    data_alteracao DATETIME NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- TRIGGERS

-- Trigger para validar nota no Feedback
DELIMITER $$
CREATE TRIGGER validate_feedback_nota
BEFORE INSERT ON Feedback
FOR EACH ROW
BEGIN
    IF NEW.nota > 10 THEN
        SET NEW.nota = 10;
    ELSEIF NEW.nota < 0 THEN
        SET NEW.nota = 0;
    END IF;
END$$
DELIMITER ;

-- Trigger para preencher data padrão em Feedback
DELIMITER $$
CREATE TRIGGER set_default_feedback_date
BEFORE INSERT ON Feedback
FOR EACH ROW
BEGIN
    IF NEW.data_feedback IS NULL THEN
        SET NEW.data_feedback = CURDATE();
    END IF;
END$$
DELIMITER ;

-- Trigger para atualizar data de modificação em Anotacao
DELIMITER $$
CREATE TRIGGER update_data_anotacao
BEFORE UPDATE ON Anotacao
FOR EACH ROW
BEGIN
    SET NEW.data_anotacao = CURDATE();
END$$
DELIMITER ;

-- Trigger para registrar alterações na tabela Usuario
DELIMITER $$
CREATE TRIGGER log_update_usuario
AFTER UPDATE ON Usuario
FOR EACH ROW
BEGIN
    -- Registrar alterações genéricas no Log_Alteracoes
    INSERT INTO Log_Alteracoes (tabela, id_registro, acao, data_alteracao, detalhes)
    VALUES (
        'Usuario',
        OLD.id_usuario,
        'UPDATE',
        NOW(),
        CONCAT('Nome alterado de "', OLD.nome, '" para "', NEW.nome, '", ',
               'Email alterado de "', OLD.email, '" para "', NEW.email, '", ',
               'Tipo alterado de "', OLD.tipo_usuario, '" para "', NEW.tipo_usuario, '"')
    );

    -- Registrar alterações específicas de nome no Historico_Nomes
    IF OLD.nome <> NEW.nome THEN
        INSERT INTO Historico_Nomes (id_usuario, nome_antigo, nome_novo, data_alteracao)
        VALUES (OLD.id_usuario, OLD.nome, NEW.nome, NOW());
    END IF;
END$$
DELIMITER ;
