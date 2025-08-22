-- RF[01] Funcionalidade de Cadastro de Usuários

-- 1. Criar um novo usuário
DELIMITER //
CREATE PROCEDURE CriarUsuario(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_senha VARCHAR(255),
    IN p_numero_celular VARCHAR(15),
    IN p_bairro_id INT
)
BEGIN
    INSERT INTO usuarios (username, email, senha, numero_celular, sign_date, bairro_id)
    VALUES (p_username, p_email, p_senha, p_numero_celular, UNIX_TIMESTAMP(), p_bairro_id);
END //
DELIMITER ;

-- 2. Entrar com um usuário
DELIMITER //
CREATE PROCEDURE EntrarUsuario(
    IN p_email VARCHAR(100),
    IN p_senha VARCHAR(255)
)
BEGIN
    SELECT * FROM usuarios
    WHERE email = p_email AND senha = p_senha;
END //
DELIMITER ;

-- RF[02] Recuperação de acesso

-- 1. Recuperar senha
DELIMITER //
CREATE PROCEDURE RecuperarSenha(
    IN p_email VARCHAR(100)
)
BEGIN
    SELECT * FROM usuarios
    WHERE email = p_email;
END //
DELIMITER ;

-- 2. Atualizar senha
DELIMITER //
CREATE PROCEDURE AtualizarSenha(
    IN p_email VARCHAR(100),
    IN p_nova_senha VARCHAR(100)
)
BEGIN
    UPDATE usuarios
    SET senha = p_nova_senha
    WHERE email = p_email;
END //
DELIMITER ;

-- 3. Atualizar e-mail
DELIMITER //
CREATE PROCEDURE AtualizarEmail(
    IN p_id INT,
    IN p_novo_email VARCHAR(100)
)
BEGIN
    UPDATE usuarios
    SET email = p_novo_email
    WHERE id = p_id;
END //
DELIMITER ;

-- 4. Atualizar número de celular
DELIMITER //
CREATE PROCEDURE AtualizarNumeroCelular(
    IN p_id INT,
    IN p_novo_numero_celular VARCHAR(15)
)
BEGIN
    UPDATE usuarios
    SET numero_celular = p_novo_numero_celular
    WHERE id = p_id;
END //
DELIMITER ;

-- RF[03] Funcionalidade de Denúncias

-- 1. Criar uma nova denúncia
DELIMITER //
CREATE PROCEDURE CriarDenuncia(
    IN p_usuario_id INT,
    IN p_local_id INT,
    IN p_descricao TEXT,
    IN p_data_denuncia DATETIME DEFAULT CURRENT_TIMESTAMP,
)
BEGIN
    INSERT INTO denuncias (usuario_id, local_id, descricao, data_denuncia)
    VALUES (p_usuario_id, p_local_id, p_descricao, NOW());
END //
DELIMITER ;

-- 2. Listar denúncias por usuário
DELIMITER //
CREATE PROCEDURE ListarDenunciasRecentesPorUsuario(
    IN p_usuario_id INT
)
BEGIN
    SELECT * FROM denuncias
    WHERE usuario_id = p_usuario_id
    ORDER BY data_denuncia DESC;
END //
DELIMITER ;

-- RF[06] Upload de Mídia (áudio, imagens, vídeos)

-- 1. Inserir mídia
DELIMITER //
CREATE PROCEDURE InserirMidia(
    IN p_denuncia_id INT,
    IN p_tipo VARCHAR(50),
    IN p_caminho_arquivo VARCHAR(255)
)
BEGIN
    INSERT INTO midia (denuncia_id, tipo, caminho_arquivo)
    VALUES (p_denuncia_id, p_tipo, p_caminho_arquivo);
END //
DELIMITER ;

-- 2. Listar mídias por denúncia
DELIMITER //
CREATE PROCEDURE ListarMidiasPorDenuncia(
    IN p_denuncia_id INT
)
BEGIN
    SELECT * FROM midia
    WHERE denuncia_id = p_denuncia_id;
END //
DELIMITER ;

-- 3. Remover mídia
DELIMITER //
CREATE PROCEDURE RemoverMidia(
    IN p_id INT
)
BEGIN
    DELETE FROM midia WHERE id = p_id;
END //
DELIMITER ;

-- RF[07] Painel do administrador 

-- 1. Listar todos os usuários
DELIMITER //
CREATE PROCEDURE ListarUsuarios()
BEGIN
    SELECT * FROM usuarios;
END //
DELIMITER ;

-- 2. Remover um usuário pelo ID
DELIMITER //
CREATE PROCEDURE RemoverUsuario(IN p_id INT)
BEGIN
    DELETE FROM usuarios WHERE id = p_id;
END //
DELIMITER ;

-- 3. Atualizar dados de um usuário
DELIMITER //
CREATE PROCEDURE AtualizarUsuario(
    IN p_id INT,
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_senha VARCHAR(255),
    IN p_numero_celular VARCHAR(15),
    IN p_bairro_id INT
)
BEGIN
    UPDATE usuarios
    SET username = p_username, email = p_email, senha = p_senha, numero_celular = p_numero_celular, bairro_id = p_bairro_id
    WHERE id = p_id;
END //
DELIMITER ;

-- 4. Inserir um novo bairro
DELIMITER //
CREATE PROCEDURE InserirBairro(
    IN p_nome VARCHAR(100),
    IN p_cidade VARCHAR(100),
    IN p_estado VARCHAR(50)
)
BEGIN
    INSERT INTO bairros (nome, cidade, estado)
    VALUES (p_nome, p_cidade, p_estado);
END //
DELIMITER ;

-- 5. Listar todos os bairros
DELIMITER //
CREATE PROCEDURE ListarBairros()
BEGIN
    SELECT * FROM bairros;
END //
DELIMITER ;

-- 6. Atualizar dados de bairro
DELIMITER //
CREATE PROCEDURE AtualizarBairro(
    IN p_id INT,
    IN p_nome VARCHAR(100),
    IN p_cidade VARCHAR(100),
    IN p_estado VARCHAR(50)
)
BEGIN
    UPDATE bairros
    SET nome = p_nome, cidade = p_cidade, estado = p_estado
    WHERE id = p_id;
END //
DELIMITER ;

-- 7. Contar denúncias por bairro
DELIMITER //
CREATE PROCEDURE ContarDenunciasPorBairro()
BEGIN
    SELECT bairros.nome, COUNT(denuncias.id) AS total_denuncias
    FROM bairros
    LEFT JOIN denuncias ON bairros.id = denuncias.bairro_id
    GROUP BY bairros.id;
END //
DELIMITER ;

-- 8. Listar denúncias recentes
DELIMITER //
CREATE PROCEDURE ListarDenunciasRecentes()
BEGIN
    SELECT denuncias.*, usuarios.username,local.nome AS local_nome
    FROM denuncias
    JOIN usuarios ON denuncias.usuario_id = usuarios.id
    JOIN local ON denuncias.local_id = local.id
    ORDER BY denuncias.data_denuncia DESC
    LIMIT 10;
END //
DELIMITER ;

-- 9 Remover denúncia
DELIMITER //
CREATE PROCEDURE RemoverDenuncia(IN p_id INT)
BEGIN
    DELETE FROM denuncias WHERE id = p_id;
END //
DELIMITER ;

-- 10 Atualizar denúncia
DELIMITER //
CREATE PROCEDURE AtualizarDenuncia(
    IN p_id INT,
    IN p_usuario_id INT,
    IN p_local_id INT,
    IN p_descricao TEXT
)
BEGIN
    UPDATE denuncias
    SET usuario_id = p_usuario_id, local_id = p_local_id, descricao = p_descricao
    WHERE id = p_id;
END //
DELIMITER ;

-- 11 Remover mídia por ID
DELIMITER //
CREATE PROCEDURE RemoverMidiaPorId(IN p_id INT)
BEGIN
    DELETE FROM midias WHERE id = p_id;
END //
DELIMITER ;