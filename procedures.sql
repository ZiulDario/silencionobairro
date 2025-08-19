
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

