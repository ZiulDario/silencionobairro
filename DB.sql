CREATE DATABASE IF NOT EXISTS 'silencionobairro_db';
USE 'silencionobairro_db';

CREATE TABLE IF NOT EXISTS 'usuarios' (
    id int primary key auto_increment,
    username varchar(50) not null,
    email varchar(100) not null unique,
    senha string not null,
    numero_celular varchar(15) not null,
    sign_date int not null, datetime default current_timestamp,
    bairro_id int not null,
    FOREIGN KEY (bairro_id) REFERENCES bairros(id),
);

CREATE TABLE IF NOT EXISTS 'bairros' (
    id int primary key auto_increment,
    nome varchar(100) not null unique,
    cidade varchar(100) not null,
    estado varchar(50) not null
);

CREATE TABLE IF NOT EXISTS 'local' (
    id int primary key auto_increment,
    nome varchar(100) not null,
    descricao text,
    endereco varchar(255) not null,
    bairro_id int not null,
    FOREIGN KEY (bairro_id) REFERENCES bairros(id)
);

CREATE TABLE IF NOT EXISTS 'denuncias' (
    id int primary key auto_increment,
    usuario_id int not null,
    local_id int not null,
    descricao text not null,
    data_denuncia datetime default current_timestamp,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (local_id) REFERENCES local(id)
);

CREATE TABLE IF NOT EXISTS 'midias' (
    id int primary key auto_increment,
    denuncia_id int not null,
    tipo varchar(50) not null, -- 'imagem', 'audio', 'video'
    caminho_arquivo varchar(255) not null,
    data_upload datetime default current_timestamp,
    FOREIGN KEY (denuncia_id) REFERENCES denuncias(id)
);

CREATE TABLE IF NOT EXISTS 'admin' (
    id int primary key auto_increment,
    username varchar(50) not null unique,
    email varchar(100) not null unique,
    senha string not null,
    numero_celular varchar(15) not null,
    sign_date int not null, datetime default current_timestamp
);
