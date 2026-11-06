CREATE DATABASE IF NOT EXISTS sigeru CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE sigeru;

-- =============================================
-- TABLA BASE: USUARIO
-- =============================================
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    estado VARCHAR(20) NOT NULL DEFAULT 'activo'
) ENGINE=InnoDB;

-- =============================================
-- TABLAS DE ROLES (herencia de USUARIO)
-- =============================================
CREATE TABLE IF NOT EXISTS administrador (
    id_usuario INT PRIMARY KEY,
    nivel_permiso INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS operario (
    id_usuario INT PRIMARY KEY,
    id_centro INT NULL,
    id_vertedero INT NULL,
    turno VARCHAR(20),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS conductor (
    id_usuario INT PRIMARY KEY,
    id_camion INT NULL,
    id_peon INT NULL,
    id_operario_asigna INT NULL,
    turno VARCHAR(20),
    zona_asignada VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS peon (
    id_usuario INT PRIMARY KEY,
    turno VARCHAR(20),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================
-- INSTALACIONES
-- =============================================
CREATE TABLE IF NOT EXISTS centro_acopio (
    id_centro INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(255),
    capacidad INT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS vertedero (
    id_vertedero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(255),
    capacidad INT
) ENGINE=InnoDB;

-- =============================================
-- TIPO DE RESIDUO Y TABLAS INTERMEDIAS
-- =============================================
CREATE TABLE IF NOT EXISTS tipo_residuo (
    id_tipo_residuo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS centro_acopio_tipo_residuo (
    id_centro INT NOT NULL,
    id_tipo_residuo INT NOT NULL,
    PRIMARY KEY (id_centro, id_tipo_residuo),
    FOREIGN KEY (id_centro) REFERENCES centro_acopio(id_centro) ON DELETE CASCADE,
    FOREIGN KEY (id_tipo_residuo) REFERENCES tipo_residuo(id_tipo_residuo) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS vertedero_tipo_residuo (
    id_vertedero INT NOT NULL,
    id_tipo_residuo INT NOT NULL,
    PRIMARY KEY (id_vertedero, id_tipo_residuo),
    FOREIGN KEY (id_vertedero) REFERENCES vertedero(id_vertedero) ON DELETE CASCADE,
    FOREIGN KEY (id_tipo_residuo) REFERENCES tipo_residuo(id_tipo_residuo) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =============================================
-- CAMION
-- =============================================
CREATE TABLE IF NOT EXISTS camion (
    id_camion INT AUTO_INCREMENT PRIMARY KEY,
    id_centro INT NULL,
    id_vertedero INT NULL,
    id_tipo_residuo INT NULL,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    modelo VARCHAR(100),
    estado VARCHAR(30) NOT NULL DEFAULT 'disponible',
    FOREIGN KEY (id_centro) REFERENCES centro_acopio(id_centro) ON DELETE SET NULL,
    FOREIGN KEY (id_vertedero) REFERENCES vertedero(id_vertedero) ON DELETE SET NULL,
    FOREIGN KEY (id_tipo_residuo) REFERENCES tipo_residuo(id_tipo_residuo) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- RUTA (antes de contenedor por FK)
-- =============================================
CREATE TABLE IF NOT EXISTS ruta (
    id_ruta INT AUTO_INCREMENT PRIMARY KEY,
    id_conductor INT NULL,
    nombre VARCHAR(100),
    zona VARCHAR(100),
    descripcion TEXT,
    color VARCHAR(20) NOT NULL DEFAULT '#1a5c52',
    estado VARCHAR(20) NOT NULL DEFAULT 'activa',
    FOREIGN KEY (id_conductor) REFERENCES conductor(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- CONTENEDOR
-- =============================================
CREATE TABLE IF NOT EXISTS contenedor (
    id_contenedor INT AUTO_INCREMENT PRIMARY KEY,
    id_ruta INT NULL,
    ubicacion VARCHAR(255),
    zona VARCHAR(100),
    estado VARCHAR(30) NOT NULL DEFAULT 'funcional',
    tipo_residuo VARCHAR(100),
    orden_en_ruta INT NULL,
    FOREIGN KEY (id_ruta) REFERENCES ruta(id_ruta) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- INCIDENCIA
-- =============================================
CREATE TABLE IF NOT EXISTS incidencia (
    id_incidencia INT AUTO_INCREMENT PRIMARY KEY,
    id_contenedor INT NULL,
    id_conductor_asignado INT NULL,
    tipo VARCHAR(50) NOT NULL,
    descripcion TEXT NULL,
    ubicacion VARCHAR(255) NULL,
    zona VARCHAR(100) NULL,
    imagen LONGTEXT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'abierta',
    fecha_reporte DATE NOT NULL,
    fecha_resolucion DATE NULL,
    FOREIGN KEY (id_contenedor) REFERENCES contenedor(id_contenedor) ON DELETE CASCADE,
    FOREIGN KEY (id_conductor_asignado) REFERENCES conductor(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- MANTENIMIENTO
-- =============================================
CREATE TABLE IF NOT EXISTS mantenimiento (
    id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_contenedor INT NOT NULL,
    id_operario INT NULL,
    fecha DATE NOT NULL,
    tipo VARCHAR(50),
    descripcion TEXT,
    estado VARCHAR(30) NOT NULL DEFAULT 'pendiente',
    FOREIGN KEY (id_contenedor) REFERENCES contenedor(id_contenedor) ON DELETE CASCADE,
    FOREIGN KEY (id_operario) REFERENCES operario(id_usuario) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- MAQUINARIA
-- =============================================
CREATE TABLE IF NOT EXISTS maquinaria (
    id_maquinaria INT AUTO_INCREMENT PRIMARY KEY,
    id_centro INT NULL,
    id_vertedero INT NULL,
    tipo VARCHAR(100),
    estado VARCHAR(30) NOT NULL DEFAULT 'operativa',
    FOREIGN KEY (id_centro) REFERENCES centro_acopio(id_centro) ON DELETE SET NULL,
    FOREIGN KEY (id_vertedero) REFERENCES vertedero(id_vertedero) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =============================================
-- REPUESTO CONTENEDOR
-- =============================================
CREATE TABLE IF NOT EXISTS repuesto_contenedor (
    id_repuesto INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(100),
    cantidad INT NOT NULL DEFAULT 0,
    ubicacion VARCHAR(255)
) ENGINE=InnoDB;

-- =============================================
-- FKs DIFERIDAS (referencias circulares entre roles)
-- =============================================
ALTER TABLE operario
    ADD FOREIGN KEY (id_centro) REFERENCES centro_acopio(id_centro) ON DELETE SET NULL,
    ADD FOREIGN KEY (id_vertedero) REFERENCES vertedero(id_vertedero) ON DELETE SET NULL;

ALTER TABLE conductor
    ADD FOREIGN KEY (id_camion) REFERENCES camion(id_camion) ON DELETE SET NULL,
    ADD FOREIGN KEY (id_peon) REFERENCES peon(id_usuario) ON DELETE SET NULL,
    ADD FOREIGN KEY (id_operario_asigna) REFERENCES operario(id_usuario) ON DELETE SET NULL;

-- =============================================
-- DATOS INICIALES
-- =============================================
INSERT INTO tipo_residuo (nombre) VALUES
    ('Organico'),
    ('Plastico'),
    ('Vidrio'),
    ('Papel/Carton'),
    ('Metal'),
    ('Electronico');

INSERT INTO usuario (nombre, apellido, email, contrasena, telefono, estado) VALUES
    ('Admin', 'SiGeRU', 'admin@sigeru.uy', '$2y$10$WvvksFs/6DfwDi/MbS83BuoHt6W6zyA85TUMuiyxpHig3e2xDWR5G', '099123456', 'activo');

INSERT INTO administrador (id_usuario, nivel_permiso) VALUES (1, 1);

INSERT INTO ruta (nombre, zona, color, estado) VALUES
    ('Ruta Centro', 'Centro', '#1a5c52', 'activa'),
    ('Ruta Costera', 'Pocitos', '#2196F3', 'activa'),
    ('Ruta Norte', 'Aguada', '#FF9800', 'activa');

INSERT INTO contenedor (id_ruta, ubicacion, zona, estado, tipo_residuo, orden_en_ruta) VALUES
    (1, '18 de Julio y Ejido', 'Centro', 'funcional', 'Organico', 1),
    (1, '18 de Julio y Paraguay', 'Centro', 'funcional', 'Plastico', 2),
    (1, '18 de Julio y Rio Negro', 'Centro', 'funcional', 'Vidrio', 3),
    (1, 'Av. Libertador y Convencion', 'Centro', 'danado', 'Organico', 4),
    (1, 'Plaza Independencia', 'Centro', 'funcional', 'Papel/Carton', 5),
    (2, 'Rambla y Buxareo', 'Pocitos', 'funcional', 'Organico', 1),
    (2, 'Rambla y Franzini', 'Pocitos', 'funcional', 'Plastico', 2),
    (2, '21 de Setiembre y Ellauri', 'Pocitos', 'funcional', 'Vidrio', 3),
    (2, 'Rambla y Pereira de la Luz', 'Pocitos', 'funcional', 'Metal', 4),
    (2, 'Av. Brasil y 26 de Marzo', 'Pocitos', 'danado', 'Organico', 5),
    (3, 'Av. Agraciada y Lima', 'Aguada', 'funcional', 'Organico', 1),
    (3, 'Av. Agraciada y Minas', 'Aguada', 'funcional', 'Plastico', 2),
    (3, 'Av. Agraciada y Yi', 'Aguada', 'funcional', 'Vidrio', 3),
    (3, 'Rondeau y San Martin', 'Aguada', 'funcional', 'Metal', 4),
    (3, 'Av. del Libertador y La Paz', 'Aguada', 'funcional', 'Papel/Carton', 5);

INSERT INTO incidencia (tipo, descripcion, ubicacion, zona, estado, fecha_reporte) VALUES
    ('desborde', 'Contenedor desbordado en esquina', '18 de Julio y Andes', 'Centro', 'abierta', CURDATE()),
    ('rotura', 'Tapa de contenedor rota', 'Rambla y Buxareo', 'Pocitos', 'abierta', CURDATE()),
    ('falta_recoleccion', 'No pasaron a recolectar hace 3 dias', 'Av. Agraciada y Minas', 'Aguada', 'en_proceso', CURDATE()),
    ('desborde', 'Residuos fuera del contenedor', '21 de Setiembre y Williman', 'Pocitos', 'abierta', CURDATE()),
    ('otro', 'Olor fuerte en la zona', 'Plaza Independencia', 'Centro', 'resuelta', CURDATE());

-- =============================================
-- DATOS DE PRUEBA: centro, vertedero, camion y usuarios por rol
-- Contrasenas: admin@sigeru.uy = admin123 | resto = test1234
-- =============================================
INSERT INTO centro_acopio (nombre, ubicacion, capacidad) VALUES
    ('Centro de Acopio Cordon', 'Av. Italia 2500, Montevideo', 500);
INSERT INTO vertedero (nombre, ubicacion, capacidad) VALUES
    ('Vertedero Felipe Cardoso', 'Camino Felipe Cardoso, Montevideo', 5000);

INSERT INTO camion (id_centro, id_vertedero, id_tipo_residuo, matricula, modelo, estado) VALUES
    (1, 1, 1, 'SAA1234', 'Volvo FM', 'disponible'),
    (1, 1, 2, 'SBB5678', 'Mercedes Atego', 'disponible');

INSERT INTO usuario (nombre, apellido, email, contrasena, telefono, estado) VALUES
    ('Carlos', 'Operario', 'operario@sigeru.uy', '$2y$10$n1DJ16QOalddTBQml8sinOrTi3/VP9/v9vWkLDaIDBvguc/4i12ia', '099111111', 'activo'),
    ('Martin', 'Conductor', 'conductor.test@sigeru.uy', '$2y$10$n1DJ16QOalddTBQml8sinOrTi3/VP9/v9vWkLDaIDBvguc/4i12ia', '099222222', 'activo'),
    ('Diego', 'Peon', 'peon@sigeru.uy', '$2y$10$n1DJ16QOalddTBQml8sinOrTi3/VP9/v9vWkLDaIDBvguc/4i12ia', '099333333', 'activo');

INSERT INTO operario (id_usuario, id_centro, id_vertedero, turno) VALUES (2, 1, 1, 'manana');
INSERT INTO peon (id_usuario, turno) VALUES (4, 'manana');
INSERT INTO conductor (id_usuario, id_camion, id_peon, id_operario_asigna, turno, zona_asignada) VALUES
    (3, 1, 4, 2, 'manana', 'Centro');

UPDATE ruta SET id_conductor = 3 WHERE id_ruta = 1;
