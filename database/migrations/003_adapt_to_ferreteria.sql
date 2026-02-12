-- =====================================================
-- MIGRACIÓN 003: ADAPTACIÓN A SISTEMA DE FERRETERÍA
-- =====================================================
-- Fecha: 2026-02-11
-- Descripción: Transforma el sistema de kiosco en un sistema profesional de ferretería
-- =====================================================

-- =====================================================
-- 1. CREAR NUEVAS TABLAS
-- =====================================================

-- Tabla de Marcas
CREATE TABLE IF NOT EXISTS `marcas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `pais_origen` varchar(50) DEFAULT NULL,
  `sitio_web` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de Unidades de Medida
CREATE TABLE IF NOT EXISTS `unidades_medida` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `abreviatura` varchar(10) NOT NULL,
  `tipo` enum('unidad','longitud','peso','volumen','area','caja') NOT NULL DEFAULT 'unidad',
  `es_fraccionable` tinyint(1) DEFAULT 0 COMMENT 'Si permite decimales (ej: 2.5 metros)',
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  UNIQUE KEY `abreviatura` (`abreviatura`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de Proveedores
CREATE TABLE IF NOT EXISTS `proveedores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `razon_social` varchar(200) DEFAULT NULL,
  `cuit` varchar(13) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `localidad` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(10) DEFAULT NULL,
  `contacto_nombre` varchar(100) DEFAULT NULL,
  `contacto_telefono` varchar(20) DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_nombre` (`nombre`),
  KEY `idx_cuit` (`cuit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Tabla de Ubicaciones en Depósito (OPCIONAL - para ferreterías grandes)
CREATE TABLE IF NOT EXISTS `ubicaciones_deposito` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `pasillo` varchar(10) DEFAULT NULL,
  `estante` varchar(10) DEFAULT NULL,
  `nivel` varchar(10) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- 6. ACTUALIZAR CATEGORÍAS PARA FERRETERÍA
-- =====================================================

-- Limpiar categorías de kiosco y agregar categorías de ferretería
TRUNCATE TABLE `categorias`;

INSERT INTO `categorias` (`nombre`, `descripcion`) VALUES
('Herramientas Manuales', 'Martillos, destornilladores, llaves, alicates, etc.'),
('Herramientas Eléctricas', 'Taladros, amoladoras, sierras eléctricas, etc.'),
('Electricidad', 'Cables, enchufes, llaves térmicas, cajas de luz, etc.'),
('Plomería', 'Caños, conexiones, grifería, sanitarios, etc.'),
('Pinturería', 'Pinturas, pinceles, rodillos, diluyentes, etc.'),
('Construcción', 'Cemento, cal, arena, ladrillos, etc.'),
('Tornillería y Bulonería', 'Tornillos, tuercas, arandelas, bulones, etc.'),
('Ferretería General', 'Candados, cadenas, bisagras, cerraduras, etc.'),
('Jardín y Exterior', 'Mangueras, aspersores, herramientas de jardín, etc.'),
('Seguridad', 'Candados, alarmas, cámaras, elementos de protección, etc.'),
('Adhesivos y Selladores', 'Pegamentos, siliconas, cintas, etc.'),
('Maderas y Tableros', 'Madera, MDF, melamina, terciado, etc.'),
('Abrasivos', 'Lijas, discos de corte, discos de pulir, etc.'),
('Iluminación', 'Lámparas, tubos, focos, LED, etc.'),
('Climatización', 'Ventiladores, estufas, aires acondicionados, etc.');

-- =====================================================
-- 7. INSERTAR UNIDADES DE MEDIDA PREDETERMINADAS
-- =====================================================

INSERT INTO `unidades_medida` (`nombre`, `abreviatura`, `tipo`, `es_fraccionable`) VALUES
('Unidad', 'un', 'unidad', 0),
('Metro', 'm', 'longitud', 1),
('Centímetro', 'cm', 'longitud', 1),
('Kilogramo', 'kg', 'peso', 1),
('Gramo', 'g', 'peso', 1),
('Litro', 'l', 'volumen', 1),
('Mililitro', 'ml', 'volumen', 1),
('Metro cuadrado', 'm²', 'area', 1),
('Caja', 'caja', 'caja', 0),
('Paquete', 'paq', 'caja', 0),
('Bolsa', 'bolsa', 'caja', 0),
('Rollo', 'rollo', 'unidad', 0),
('Par', 'par', 'unidad', 0),
('Juego', 'juego', 'unidad', 0),
('Set', 'set', 'unidad', 0);

-- =====================================================
-- 8. INSERTAR MARCAS COMUNES DE FERRETERÍA (EJEMPLOS)
-- =====================================================

INSERT INTO `marcas` (`nombre`, `descripcion`, `pais_origen`) VALUES
('Bahco', 'Herramientas profesionales', 'Suecia'),
('Stanley', 'Herramientas manuales y eléctricas', 'Estados Unidos'),
('Bosch', 'Herramientas eléctricas y accesorios', 'Alemania'),
('DeWalt', 'Herramientas eléctricas profesionales', 'Estados Unidos'),
('Makita', 'Herramientas eléctricas', 'Japón'),
('Black & Decker', 'Herramientas eléctricas y manuales', 'Estados Unidos'),
('Tramontina', 'Herramientas y utensilios', 'Brasil'),
('Ferrum', 'Grifería y sanitarios', 'Argentina'),
('FV', 'Grifería y sanitarios', 'Argentina'),
('Schneider Electric', 'Material eléctrico', 'Francia'),
('Philips', 'Iluminación', 'Países Bajos'),
('Tigre', 'Caños y conexiones', 'Brasil'),
('Awaduct', 'Caños y conexiones', 'Argentina'),
('Alba', 'Pinturas', 'Argentina'),
('Sinteplast', 'Pinturas', 'Argentina'),
('Poxipol', 'Adhesivos', 'Argentina'),
('Genérica', 'Productos sin marca específica', NULL);

-- =====================================================
-- 9. INSERTAR UBICACIONES DE DEPÓSITO EJEMPLO (OPCIONAL)
-- =====================================================

INSERT INTO `ubicaciones_deposito` (`codigo`, `descripcion`, `pasillo`, `estante`, `nivel`) VALUES
('A1-1', 'Pasillo A - Estante 1 - Nivel 1', 'A', '1', '1'),
('A1-2', 'Pasillo A - Estante 1 - Nivel 2', 'A', '1', '2'),
('A1-3', 'Pasillo A - Estante 1 - Nivel 3', 'A', '1', '3'),
('B1-1', 'Pasillo B - Estante 1 - Nivel 1', 'B', '1', '1'),
('B1-2', 'Pasillo B - Estante 1 - Nivel 2', 'B', '1', '2'),
('MOSTRADOR', 'Productos en mostrador', NULL, NULL, NULL),
('DEPOSITO', 'Depósito general', NULL, NULL, NULL),
('EXTERIOR', 'Patio exterior', NULL, NULL, NULL);

-- =====================================================
-- FIN DE MIGRACIÓN PARTE 1
-- =====================================================
