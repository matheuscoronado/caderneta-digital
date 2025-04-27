create database cardeneta;
use cardeneta;

 create table Usuario (
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

-- Criação da tabela Registro
CREATE TABLE Registro (
    id_registro INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    id_docente INT NOT NULL,
    descricao_atividade TEXT,
    data_registro DATE NOT NULL,
    status ENUM('em andamento', 'concluido', 'reprovado') NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno),
    FOREIGN KEY (id_docente) REFERENCES Docente(id_docente)
);

-- Criação da tabela Anotacao
CREATE TABLE Anotacao (
    id_anotacao INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    id_registro INT NOT NULL,
    conteudo TEXT NOT NULL,
    data_anotacao DATE NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno),
    FOREIGN KEY (id_registro) REFERENCES Registro(id_registro)
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

SHOW TABLES;
