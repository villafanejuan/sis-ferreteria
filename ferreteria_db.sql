-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-02-2026 a las 20:44:30
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ferreteria_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `icono` varchar(50) DEFAULT 'fa-box',
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `descripcion`, `icono`, `activo`, `created_at`) VALUES
(1, 'Herramientas Manuales', 'Martillos, destornilladores, llaves, alicates', 'fa-wrench', 1, '2026-02-12 02:49:58'),
(2, 'Herramientas Eléctricas', 'Taladros, amoladoras, sierras eléctricas', 'fa-power-off', 1, '2026-02-12 02:49:58'),
(3, 'Electricidad', 'Cables, enchufes, llaves térmicas, cajas', 'fa-bolt', 1, '2026-02-12 02:49:58'),
(4, 'Plomería', 'Caños, conexiones, grifería, accesorios', 'fa-tint', 1, '2026-02-12 02:49:58'),
(5, 'Pinturería', 'Pinturas, pinceles, rodillos, diluyentes', 'fa-paint-brush', 1, '2026-02-12 02:49:58'),
(6, 'Construcción', 'Cemento, arena, ladrillos, bloques', 'fa-building', 1, '2026-02-12 02:49:58'),
(7, 'Tornillería y Bulonería', 'Tornillos, tuercas, arandelas, bulones', 'fa-cog', 1, '2026-02-12 02:49:58'),
(8, 'Ferretería General', 'Candados, bisagras, cerraduras, herrajes', 'fa-key', 1, '2026-02-12 02:49:58'),
(9, 'Jardín y Exterior', 'Mangueras, aspersores, herramientas de jardín', 'fa-leaf', 1, '2026-02-12 02:49:58'),
(10, 'Seguridad', 'Candados, alarmas, cámaras, elementos de protección', 'fa-shield-alt', 1, '2026-02-12 02:49:58'),
(11, 'Adhesivos y Selladores', 'Pegamentos, siliconas, cintas, selladores', 'fa-tape', 1, '2026-02-12 02:49:58'),
(12, 'Maderas y Tableros', 'Madera, MDF, melamina, terciados', 'fa-tree', 1, '2026-02-12 02:49:58'),
(13, 'Abrasivos', 'Lijas, discos de corte, piedras de amolar', 'fa-circle', 1, '2026-02-12 02:49:58'),
(14, 'Iluminación', 'Lámparas, tubos, focos, LED', 'fa-lightbulb', 1, '2026-02-12 02:49:58'),
(15, 'Climatización', 'Ventiladores, estufas, aires acondicionados', 'fa-fan', 1, '2026-02-12 02:49:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `documento` varchar(20) DEFAULT NULL,
  `tipo_documento` enum('DNI','CUIT','CUIL','Pasaporte') DEFAULT 'DNI',
  `telefono` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(20) DEFAULT NULL,
  `saldo_cuenta_corriente` decimal(10,2) DEFAULT 0.00,
  `limite_credito` decimal(10,2) DEFAULT 0.00,
  `notas` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `nombre`, `documento`, `tipo_documento`, `telefono`, `email`, `direccion`, `ciudad`, `provincia`, `codigo_postal`, `saldo_cuenta_corriente`, `limite_credito`, `notas`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'juanjo', '3234563434343', 'DNI', '34533434562', 'admin@gmail.com', 'calle falsa 123', NULL, NULL, NULL, 2080.00, 0.00, NULL, 1, '2026-02-12 23:29:20', '2026-02-13 18:53:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuenta_corriente_movimientos`
--

CREATE TABLE `cuenta_corriente_movimientos` (
  `id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `tipo` enum('venta','pago','ajuste_debito','ajuste_credito') NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `saldo_historico` decimal(10,2) NOT NULL DEFAULT 0.00,
  `referencia_id` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cuenta_corriente_movimientos`
--

INSERT INTO `cuenta_corriente_movimientos` (`id`, `cliente_id`, `tipo`, `monto`, `saldo_historico`, `referencia_id`, `descripcion`, `usuario_id`, `fecha`) VALUES
(1, 1, 'venta', 1040.00, 1040.00, 3, 'Venta #3', 1, '2026-02-12 23:35:50'),
(2, 1, 'venta', 1040.00, 2080.00, 4, 'Venta #4', 1, '2026-02-13 18:53:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text DEFAULT NULL,
  `success` tinyint(1) DEFAULT 0,
  `attempted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `login_attempts`
--

INSERT INTO `login_attempts` (`id`, `username`, `ip_address`, `user_agent`, `success`, `attempted_at`) VALUES
(1, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-11 23:55:45'),
(2, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-11 23:56:45'),
(3, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-11 23:58:37'),
(4, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:01:56'),
(5, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 1, '2026-02-12 00:02:32'),
(6, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 1, '2026-02-12 00:02:45'),
(7, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:04:04'),
(8, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:04:22'),
(9, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 1, '2026-02-12 00:05:35'),
(10, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:13:38'),
(11, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:13:51'),
(12, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:14:23'),
(13, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:16:41'),
(14, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 21:06:54'),
(15, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 21:12:20'),
(16, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 21:36:15'),
(17, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36 Edg/144.0.0.0', 1, '2026-02-12 23:31:25'),
(18, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 1, '2026-02-13 18:50:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `pais_origen` varchar(100) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`id`, `nombre`, `pais_origen`, `descripcion`, `activo`, `created_at`) VALUES
(1, 'Bahco', 'Suecia', 'Herramientas manuales profesionales', 1, '2026-02-12 02:49:58'),
(2, 'Stanley', 'Estados Unidos', 'Herramientas y accesorios', 1, '2026-02-12 02:49:58'),
(3, 'Bosch', 'Alemania', 'Herramientas eléctricas y accesorios', 1, '2026-02-12 02:49:58'),
(4, 'DeWalt', 'Estados Unidos', 'Herramientas eléctricas profesionales', 1, '2026-02-12 02:49:58'),
(5, 'Makita', 'Japón', 'Herramientas eléctricas de alta calidad', 1, '2026-02-12 02:49:58'),
(6, 'Black+Decker', 'Estados Unidos', 'Herramientas para hogar y jardín', 1, '2026-02-12 02:49:58'),
(7, 'Einhell', 'Alemania', 'Herramientas y equipos de bricolaje', 1, '2026-02-12 02:49:58'),
(8, 'Tramontina', 'Brasil', 'Herramientas y productos para el hogar', 1, '2026-02-12 02:49:58'),
(9, 'Philips', 'Países Bajos', 'Iluminación y productos electrónicos', 1, '2026-02-12 02:49:58'),
(10, 'Osram', 'Alemania', 'Iluminación profesional', 1, '2026-02-12 02:49:58'),
(11, '3M', 'Estados Unidos', 'Adhesivos, abrasivos y protección', 1, '2026-02-12 02:49:58'),
(12, 'Sika', 'Suiza', 'Selladores y productos químicos para construcción', 1, '2026-02-12 02:49:58'),
(13, 'Fischer', 'Alemania', 'Anclajes y fijaciones', 1, '2026-02-12 02:49:58'),
(14, 'Karcher', 'Alemania', 'Limpieza y equipos de alta presión', 1, '2026-02-12 02:49:58'),
(15, 'Total Tools', 'China', 'Herramientas accesibles para múltiples usos', 1, '2026-02-12 02:49:58'),
(16, 'Pretul', 'México', 'Herramientas económicas', 1, '2026-02-12 02:49:58'),
(17, 'Ema', 'Argentina', 'Accesorios y ferretería general', 1, '2026-02-12 02:49:58');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos_caja`
--

CREATE TABLE `movimientos_caja` (
  `id` int(11) NOT NULL,
  `turno_id` int(11) NOT NULL,
  `tipo` enum('venta','ingreso','egreso','apertura','cierre','inicial') NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `venta_id` int(11) DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `movimientos_caja`
--

INSERT INTO `movimientos_caja` (`id`, `turno_id`, `tipo`, `monto`, `descripcion`, `venta_id`, `usuario_id`, `fecha`, `created_at`) VALUES
(1, 3, 'inicial', 10.00, 'Apertura de turno', NULL, 1, '2026-02-12 00:16:56', '2026-02-12 00:16:56'),
(2, 3, 'venta', 1040.00, 'Venta #2', 2, 1, '2026-02-12 00:31:08', '2026-02-12 00:31:08'),
(3, 4, 'venta', 520.00, 'Venta #5', 5, 1, '2026-02-13 18:58:46', '2026-02-13 18:58:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `codigo_barra` varchar(50) DEFAULT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `categoria_id` int(11) DEFAULT NULL,
  `marca_id` int(11) DEFAULT NULL,
  `unidad_medida_id` int(11) DEFAULT 1,
  `proveedor_id` int(11) DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT 0.00,
  `precio_costo` decimal(10,2) DEFAULT 0.00,
  `margen_ganancia` decimal(5,2) DEFAULT 30.00,
  `stock` decimal(10,3) NOT NULL DEFAULT 0.000,
  `unidad_medida` varchar(20) DEFAULT 'unid',
  `stock_minimo` decimal(10,3) NOT NULL DEFAULT 0.000,
  `ubicacion_deposito` varchar(50) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `codigo_barra`, `modelo`, `categoria_id`, `marca_id`, `unidad_medida_id`, `proveedor_id`, `precio`, `precio_costo`, `margen_ganancia`, `stock`, `unidad_medida`, `stock_minimo`, `ubicacion_deposito`, `imagen`, `activo`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'pedazo de chapa', '', '123123123', '2sd3das', NULL, NULL, 2, NULL, 520.00, 400.00, 30.00, 3.000, 'unid', 5.000, NULL, NULL, 1, '2026-02-13 19:36:03', '2026-02-12 00:18:09', '2026-02-13 19:36:03'),
(2, 'Cable 2.5mm', NULL, 'TEST-1770855977', NULL, NULL, NULL, 1, NULL, 150.50, 0.00, 30.00, 98.500, 'mts', 0.000, NULL, NULL, 1, NULL, '2026-02-12 00:26:17', '2026-02-12 00:26:17'),
(3, 'prueba', 'articulo de prueba', '8473432', NULL, NULL, NULL, 2, NULL, 130.00, 100.00, 30.00, 20.300, 'unid', 20.100, NULL, NULL, 1, '2026-02-13 19:36:18', '2026-02-12 21:31:32', '2026-02-13 19:36:18'),
(4, 'ACOPLE RÁPIDO', '1/2', 'P0001', NULL, NULL, NULL, 1, NULL, 6100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(5, 'ACOPLE RÁPIDO', '3/3', 'P0002', NULL, NULL, NULL, 1, NULL, 7000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(6, 'ACOPLE RÁPIDO', '1\"', 'P0003', NULL, NULL, NULL, 1, NULL, 7700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(7, 'AEROSOL BLANCO', 'BRILLANTE - DOBLE AA X 250G', 'P0004', NULL, NULL, NULL, 1, NULL, 5030.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(8, 'AEROSOL BLANCO', 'SATINADO - DOBLE AA X 250G', 'P0005', NULL, NULL, NULL, 1, NULL, 5030.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(9, 'AEROSOL BLANCO', 'MATE - DOBLE AA X 250G ', 'P0006', NULL, NULL, NULL, 1, NULL, 5030.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(10, 'AEROSOL NEGRO', 'BRILLANTE X250G', 'P0007', NULL, NULL, NULL, 1, NULL, 5030.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(11, 'AEROSOL NEGRO', 'SATINADO X 250G', 'P0008', NULL, NULL, NULL, 1, NULL, 5030.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(12, 'AEROSOL NEGRO', 'MATE X 250G', 'P0009', NULL, NULL, NULL, 1, NULL, 5030.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(13, 'ALICATE CORTE DIAG', 'CROSS 6½\"', 'P0010', NULL, NULL, NULL, 1, NULL, 13500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(14, 'ARGOLLA NIQUELADAS P/TOLDO', ' Nº 30', 'P0011', NULL, NULL, NULL, 1, NULL, 26466.48, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(15, 'BARRAL', '22 MM X 2,00 MTS. CEDRO S/ARG.', 'P0012', NULL, NULL, NULL, 1, NULL, 11096.14, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(16, 'BARRAL ', '22 MM X 1,40 MTS. CEDRO S/ARG.', 'P0013', NULL, NULL, NULL, 1, NULL, 9481.08, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(17, 'BARRAL ', '22 MM X 1,80 MTS. CEDRO S/ARG.', 'P0014', NULL, NULL, NULL, 1, NULL, 10570.08, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(18, 'BARRAL ', '22 MM X 2,20 MTS . CEDRO S/ARG.', 'P0015', NULL, NULL, NULL, 1, NULL, 11644.13, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(19, 'BASE PARA 1 MODULO', 'JELUZ EXTERIOR', 'P0016', NULL, NULL, NULL, 1, NULL, 428.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(20, 'BASE PARA 2 MODULOS', 'JELUZ EXTERIOR', 'P0017', NULL, NULL, NULL, 1, NULL, 718.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(21, 'BASE PARA 3 MODULOS', 'JELUZ EXTERIOR', 'P0018', NULL, NULL, NULL, 1, NULL, 1430.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(22, 'BASE PARA 4 MODULOS', 'JELUZ EXTERIOR', 'P0019', NULL, NULL, NULL, 1, NULL, 1911.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(23, 'BASE PARA 5 MODULOS', 'JELUZ EXTERIOR', 'P0020', NULL, NULL, NULL, 1, NULL, 2300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(24, 'BOMBA CENTRIFUGA BTA', '-', 'P0021', NULL, NULL, NULL, 1, NULL, 52000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(25, 'BOYA PILETA SATELITE CHICA', '- ', 'P0022', NULL, NULL, NULL, 1, NULL, 3000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(26, 'BUJE M-H RED. ', '¾\" X ½\"', 'P0023', NULL, NULL, NULL, 1, NULL, 221.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(27, 'BUJE M-H RED. ', '1\" X ¾\"', 'P0024', NULL, NULL, NULL, 1, NULL, 410.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(28, 'BULON ZINCADO 1/4', '1/4 X 1/2', 'P0025', NULL, NULL, NULL, 1, NULL, 62.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(29, 'BULON ZINCADO 1/4', '1/4 X 5/8', 'P0026', NULL, NULL, NULL, 1, NULL, 68.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(30, 'BULON ZINCADO 1/4', '1/4 X 3/4', 'P0027', NULL, NULL, NULL, 1, NULL, 72.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(31, 'BULON ZINCADO 1/4', '1/4 X 7/8', 'P0028', NULL, NULL, NULL, 1, NULL, 75.46, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(32, 'BULON ZINCADO 1/4', '1/4 X 1', 'P0029', NULL, NULL, NULL, 1, NULL, 76.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(33, 'BULON ZINCADO 1/4', '1/4 X 1 1/4', 'P0030', NULL, NULL, NULL, 1, NULL, 99.30, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(34, 'BULON ZINCADO 1/4', '1/4 X 1 1/2', 'P0031', NULL, NULL, NULL, 1, NULL, 112.11, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(35, 'BULON ZINCADO 1/4', '1/4 X 1 3/4', 'P0032', NULL, NULL, NULL, 1, NULL, 133.64, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(36, 'BULON ZINCADO 1/4', '1/4 X 2', 'P0033', NULL, NULL, NULL, 1, NULL, 150.30, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(37, 'BULON ZINCADO 1/4', '1/4 X 2 1/4', 'P0034', NULL, NULL, NULL, 1, NULL, 160.26, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(38, 'BULON ZINCADO 1/4', '1/4 X 2 1/2', 'P0035', NULL, NULL, NULL, 1, NULL, 178.60, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(39, 'BULON ZINCADO 1/4', '1/4 X 2 3/4', 'P0036', NULL, NULL, NULL, 1, NULL, 194.09, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(40, 'BULON ZINCADO 1/4', '1/4 X 3', 'P0037', NULL, NULL, NULL, 1, NULL, 211.43, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(41, 'BULON ZINCADO 1/4', '1/4 X 3 1/4', 'P0038', NULL, NULL, NULL, 1, NULL, 234.26, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(42, 'BULON ZINCADO 1/4', '1/4 X 3 1/2', 'P0039', NULL, NULL, NULL, 1, NULL, 251.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(43, 'BULON ZINCADO 1/4', '1/4 X 4', 'P0040', NULL, NULL, NULL, 1, NULL, 283.75, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(44, 'BULON ZINCADO 1/4', '1/4 X 4 1/2', 'P0041', NULL, NULL, NULL, 1, NULL, 317.71, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(45, 'BULON ZINCADO 1/4', '1/4 X 5', 'P0042', NULL, NULL, NULL, 1, NULL, 343.34, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(46, 'BULON ZINCADO 1/4', '1/4 X 5 1/2', 'P0043', NULL, NULL, NULL, 1, NULL, 460.74, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(47, 'BULON ZINCADO 1/4', '1/4 X 6', 'P0044', NULL, NULL, NULL, 1, NULL, 500.77, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(48, 'BULON ZINCADO 3/8', '3/8 X 1/2', 'P0045', NULL, NULL, NULL, 1, NULL, 155.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(49, 'BULON ZINCADO 3/8', '3/8 X 5/8', 'P0046', NULL, NULL, NULL, 1, NULL, 146.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(50, 'BULON ZINCADO 3/8', '3/8 X 3/4', 'P0047', NULL, NULL, NULL, 1, NULL, 162.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(51, 'BULON ZINCADO 3/8', '3/8 X 7/8', 'P0048', NULL, NULL, NULL, 1, NULL, 172.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(52, 'BULON ZINCADO 3/8', '3/8 X 1', 'P0049', NULL, NULL, NULL, 1, NULL, 183.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(53, 'BULON ZINCADO 3/8', '3/8 X 1 1/4', 'P0050', NULL, NULL, NULL, 1, NULL, 220.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(54, 'BULON ZINCADO 3/8', '3/8 X 1 1/2', 'P0051', NULL, NULL, NULL, 1, NULL, 240.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(55, 'BULON ZINCADO 3/8', '3/8 X 1 3/4', 'P0052', NULL, NULL, NULL, 1, NULL, 294.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(56, 'BULON ZINCADO 3/8', '3/8 X 2', 'P0053', NULL, NULL, NULL, 1, NULL, 309.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(57, 'BULON ZINCADO 3/8', '3/8 X 2 1/4', 'P0054', NULL, NULL, NULL, 1, NULL, 363.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(58, 'BULON ZINCADO 3/8', '3/8 X 2 1/2', 'P0055', NULL, NULL, NULL, 1, NULL, 400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(59, 'BULON ZINCADO 3/8', '3/8 X 2 3/4', 'P0056', NULL, NULL, NULL, 1, NULL, 452.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(60, 'BULON ZINCADO 3/8', '3/8 X 3', 'P0057', NULL, NULL, NULL, 1, NULL, 485.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(61, 'BULON ZINCADO 3/8', '3/8 X 3 1/4', 'P0058', NULL, NULL, NULL, 1, NULL, 532.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(62, 'BULON ZINCADO 3/8', '3/8 X 3 1/2', 'P0059', NULL, NULL, NULL, 1, NULL, 572.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(63, 'BULON ZINCADO 3/8', '3/8 X 4', 'P0060', NULL, NULL, NULL, 1, NULL, 622.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(64, 'BULON ZINCADO 5/16', '5/16 X 1/2', 'P0061', NULL, NULL, NULL, 1, NULL, 97.24, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(65, 'BULON ZINCADO 5/16', '5/16 X 5/8', 'P0062', NULL, NULL, NULL, 1, NULL, 102.33, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(66, 'BULON ZINCADO 5/16', '5/16 X 3/4', 'P0063', NULL, NULL, NULL, 1, NULL, 108.44, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(67, 'BULON ZINCADO 5/16', '5/16 X 7/8', 'P0064', NULL, NULL, NULL, 1, NULL, 116.26, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(68, 'BULON ZINCADO 5/16', '5/16  X 1', 'P0065', NULL, NULL, NULL, 1, NULL, 126.52, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(69, 'BULON ZINCADO 5/16', '5/16 X 1 1/4', 'P0066', NULL, NULL, NULL, 1, NULL, 145.77, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(70, 'BULON ZINCADO 5/16', '5/16 X 1 1/2', 'P0067', NULL, NULL, NULL, 1, NULL, 172.62, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(71, 'BULON ZINCADO 5/16', '5/16 X 1 3/4 ', 'P0068', NULL, NULL, NULL, 1, NULL, 195.51, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(72, 'BULON ZINCADO 5/16', '5/16 X 2', 'P0069', NULL, NULL, NULL, 1, NULL, 223.31, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(73, 'BULON ZINCADO 5/16', '5/16 X 2 1/4', 'P0070', NULL, NULL, NULL, 1, NULL, 246.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(74, 'BULON ZINCADO 5/16', '5/16 X 2 1/2', 'P0071', NULL, NULL, NULL, 1, NULL, 269.49, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(75, 'BULON ZINCADO 5/16', '5/16 X 2 3/4', 'P0072', NULL, NULL, NULL, 1, NULL, 311.52, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(76, 'BULON ZINCADO 5/16', '5/16 X 3', 'P0073', NULL, NULL, NULL, 1, NULL, 331.61, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(77, 'BULON ZINCADO 5/16', '5/16 X 3 1/4', 'P0074', NULL, NULL, NULL, 1, NULL, 364.71, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(78, 'BULON ZINCADO 5/16', '5/16 X 3 1/2', 'P0075', NULL, NULL, NULL, 1, NULL, 389.09, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(79, 'BULON ZINCADO 5/16', '5/16 X 4', 'P0076', NULL, NULL, NULL, 1, NULL, 419.28, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(80, 'BULON ZINCADO 5/16', '5/16 X 4 1/2', 'P0077', NULL, NULL, NULL, 1, NULL, 484.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(81, 'BULON ZINCADO 5/16', '5/16 X 5', 'P0078', NULL, NULL, NULL, 1, NULL, 524.51, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(82, 'BULON ZINCADO 5/16', '5/16 X 5 1/2', 'P0079', NULL, NULL, NULL, 1, NULL, 643.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(83, 'BULON ZINCADO 5/16', '5/16 X 6 ', 'P0080', NULL, NULL, NULL, 1, NULL, 747.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(84, 'BULON ZINCADO 5/16', '5/16 X 7', 'P0081', NULL, NULL, NULL, 1, NULL, 860.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(85, 'BULON ZINCADO 5/16', '5/16 X 8', 'P0082', NULL, NULL, NULL, 1, NULL, 980.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(86, 'BUSCAPOLO CHICO ', '3 X 140 SICA', 'P0083', NULL, NULL, NULL, 1, NULL, 2500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(87, 'CABLE CANAL', '20 X 10 C/ADH X 2MTS.', 'P0084', NULL, NULL, NULL, 1, NULL, 7400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(88, 'CABLE CANAL', '20 X 10 S/ADH X 2 MTS.', 'P0085', NULL, NULL, NULL, 1, NULL, 5400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(89, 'CABLE CANAL ACCESORIOS', '20 X 10', 'P0086', NULL, NULL, NULL, 1, NULL, 940.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(90, 'CABLE COAXIL ', 'REG X MT', 'P0087', NULL, NULL, NULL, 1, NULL, 650.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(91, 'CABLE COAXIL ', 'RG59 X MT', 'P0088', NULL, NULL, NULL, 1, NULL, 1100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(92, 'CABLE ENV. REDONDO', '2 X1.5 KALOP', 'P0090', NULL, NULL, NULL, 1, NULL, 1900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(93, 'CABLE ENV. REDONDO', '2 X 2.5', 'P0091', NULL, NULL, NULL, 1, NULL, 2600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(94, 'CABLE ENV. REDONDO', '2 X 4', 'P0092', NULL, NULL, NULL, 1, NULL, 3887.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(95, 'CABLE ENV. REDONDO', '3 X 1', 'P0093', NULL, NULL, NULL, 1, NULL, 2500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(96, 'CABLE ENV. REDONDO', '3 X 1,5', 'P0094', NULL, NULL, NULL, 1, NULL, 3430.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(97, 'CABLE ENV. REDONDO', '3 X 2,5', 'P0095', NULL, NULL, NULL, 1, NULL, 3670.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(98, 'CABLE ENV. REDONDO', '4 X 1', 'P0096', NULL, NULL, NULL, 1, NULL, 2310.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(99, 'CABLE ENV. REDONDO', '4 X 1,5', 'P0097', NULL, NULL, NULL, 1, NULL, 3020.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(100, 'CABLE ENV. REDONDO', '4 X 2,5', 'P0098', NULL, NULL, NULL, 1, NULL, 4590.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(101, 'CABLE IMSA', '1 X 1', 'P0099', NULL, NULL, NULL, 1, NULL, 407.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(102, 'CABLE IMSA', '1 X 1.5', 'P0100', NULL, NULL, NULL, 1, NULL, 588.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(103, 'CABLE IMSA', '1 X 2.5', 'P0101', NULL, NULL, NULL, 1, NULL, 935.20, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(104, 'CABLE IMSA', '1 X 4', 'P0102', NULL, NULL, NULL, 1, NULL, 1385.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(105, 'CABLE IMSA', '1 X 6', 'P0103', NULL, NULL, NULL, 1, NULL, 2220.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(106, 'CABLE SUPERASTIC', '1 X 1', 'P0104', NULL, NULL, NULL, 1, NULL, 595.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(107, 'CABLE SUPERASTIC', '1 X 1.5', 'P0105', NULL, NULL, NULL, 1, NULL, 820.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(108, 'CABLE SUPERASTIC', '1 X 2.5', 'P0106', NULL, NULL, NULL, 1, NULL, 1308.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(109, 'CABLE SUPERASTIC', '1 X 4', 'P0107', NULL, NULL, NULL, 1, NULL, 2100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(110, 'CABLE SUPERASTIC', '1 X 6', 'P0108', NULL, NULL, NULL, 1, NULL, 3100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(111, 'CABOS MARTILLO CARPINTERO', '12\"', 'P0109', NULL, NULL, NULL, 1, NULL, 1050.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(112, 'CABOS MARTILLO MACETA', '14\"', 'P0110', NULL, NULL, NULL, 1, NULL, 1300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(113, 'CABOS MARTILLO MACETA', '16\"', 'P0111', NULL, NULL, NULL, 1, NULL, 1400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(114, 'CAJA CAPSULADA MIG.', '-', 'P0112', NULL, NULL, NULL, 1, NULL, 4000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(115, 'CAJA HIERRO CUADRADA', '10X10', 'P0113', NULL, NULL, NULL, 1, NULL, 1600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(116, 'CAJA HIERRO OCTAGONAL ', 'CHICA', 'P0114', NULL, NULL, NULL, 1, NULL, 530.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(117, 'CAJA HIERRO OCTAGONAL ', 'GRANDE', 'P0115', NULL, NULL, NULL, 1, NULL, 1112.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(118, 'CAJA HIERRO RECTANGULAR', '5X10', 'P0116', NULL, NULL, NULL, 1, NULL, 530.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(119, 'CAJA PVC OCTAGONAL', 'CHICA', 'P0117', NULL, NULL, NULL, 1, NULL, 500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(120, 'CAJA PVC RECTANGULAR', '5X10', 'P0118', NULL, NULL, NULL, 1, NULL, 500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(121, 'CALEFON ELECTRICO', 'ACERO INOX 20LTS', 'P0119', NULL, NULL, NULL, 1, NULL, 72000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(122, 'CALEFON ELECTRICO', 'ACERO INOX 10LTS', 'P0120', NULL, NULL, NULL, 1, NULL, 65000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(123, 'CALEFON RESISTENCIA \"FOCO\"', '-', 'P0122', NULL, NULL, NULL, 1, NULL, 9100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(124, 'CALEFON RESISTENCIA \"PULMÓN\"', '-', 'P0123', NULL, NULL, NULL, 1, NULL, 12500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(125, 'CANILLA METÁLICA ESF', '1\"', 'P0126', NULL, NULL, NULL, 1, NULL, 17500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(126, 'CAÑERIA ROSCA CODO 1/2\"', '1/2\" X 45° H-H', 'P0127', NULL, NULL, NULL, 1, NULL, 813.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(127, 'CAÑERIA ROSCA CODO 1/2\"', 'H-H C/INS.', 'P0128', NULL, NULL, NULL, 1, NULL, 3500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(128, 'CAÑERIA ROSCA CODO 3', '3/4\" X 45° H-H', 'P0129', NULL, NULL, NULL, 1, NULL, 1070.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(129, 'CAÑERIA ROSCA CODO 3/4\"', '1\" X 45° H-H', 'P0130', NULL, NULL, NULL, 1, NULL, 1940.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(130, 'CAÑERIA ROSCA CODO 3/4\"', 'H-H C/INS.', 'P0131', NULL, NULL, NULL, 1, NULL, 5200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(131, 'CAÑERIA ROSCA CODO H-H', '1/2\"', 'P0132', NULL, NULL, NULL, 1, NULL, 375.30, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(132, 'CAÑERIA ROSCA CODO H-H', '3/4\"', 'P0133', NULL, NULL, NULL, 1, NULL, 598.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(133, 'CAÑERIA ROSCA CODO H-H', '1\"', 'P0134', NULL, NULL, NULL, 1, NULL, 1066.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(134, 'CAÑERIA ROSCA CODO M-H', '1/2\"', 'P0135', NULL, NULL, NULL, 1, NULL, 394.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(135, 'CAÑERIA ROSCA CODO M-H', '3/4\"', 'P0136', NULL, NULL, NULL, 1, NULL, 625.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(136, 'CAÑERIA ROSCA CODO M-H', '1\"', 'P0137', NULL, NULL, NULL, 1, NULL, 900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(137, 'CAÑERIA ROSCA CODO RED.', '3/4\" X 1/2\"', 'P0138', NULL, NULL, NULL, 1, NULL, 1062.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(138, 'CAÑERIA ROSCA CODO RED.', '1\" X 3/4\"', 'P0139', NULL, NULL, NULL, 1, NULL, 1410.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(139, 'CAÑERIA ROSCA CODO RED.', '1 X 1/2\"', 'P0140', NULL, NULL, NULL, 1, NULL, 1711.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(140, 'CAÑERIA ROSCA CURVA H-H', '1/2\"', 'P0141', NULL, NULL, NULL, 1, NULL, 877.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(141, 'CAÑERIA ROSCA CURVA H-H', '3/4\"', 'P0142', NULL, NULL, NULL, 1, NULL, 1125.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(142, 'CAÑERIA ROSCA CURVA H-H', '1\"', 'P0143', NULL, NULL, NULL, 1, NULL, 2500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(143, 'CAÑERIA ROSCA CURVA M-H', '1/2\"', 'P0144', NULL, NULL, NULL, 1, NULL, 1026.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(144, 'CAÑERIA ROSCA CURVA M-H', '3/4\"', 'P0145', NULL, NULL, NULL, 1, NULL, 1300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(145, 'CAÑERIA ROSCA CURVA M-H', '1\"', 'P0146', NULL, NULL, NULL, 1, NULL, 2600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(146, 'CAÑERIA ROSCA TE H-H', '1/2\"', 'P0147', NULL, NULL, NULL, 1, NULL, 515.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(147, 'CAÑERIA ROSCA TE H-H', '3/4\"', 'P0148', NULL, NULL, NULL, 1, NULL, 835.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(148, 'CAÑERIA ROSCA TE H-H', '1\"', 'P0149', NULL, NULL, NULL, 1, NULL, 1640.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(149, 'CAÑERIA ROSCA TE RED.', '3/4 X 1/2\" H-H', 'P0150', NULL, NULL, NULL, 1, NULL, 1132.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(150, 'CAÑERIA ROSCA TE RED.', '1\" X 1/2 H-H', 'P0151', NULL, NULL, NULL, 1, NULL, 1890.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(151, 'CAÑERIA ROSCA TE RED.', '1\" X 3/4 H-H', 'P0152', NULL, NULL, NULL, 1, NULL, 1260.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(152, 'CAÑO CORRUGADO', 'NARANJA 1\"X25MTS.', 'P0153', NULL, NULL, NULL, 1, NULL, 11700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(153, 'CAÑO CORRUGADO', 'IGNIFUGO BLANCO 3/4X25MTS', 'P0154', NULL, NULL, NULL, 1, NULL, 12700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(154, 'CAÑO CORRUGADO', 'IGNIFUGO BLANCO 7/8X25MTS', 'P0155', NULL, NULL, NULL, 1, NULL, 15307.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(155, 'CAÑO CORRUGADO', 'IGNIFUGO BLANCO 1\"X 25MTS.', 'P0156', NULL, NULL, NULL, 1, NULL, 18900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(156, 'CAÑO CORRUGADO', 'IGNIFUGO BLANCO 1\"1/4X25MTS.', 'P0157', NULL, NULL, NULL, 1, NULL, 24830.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(157, 'CAÑO CORRUGADO', 'IGNIFUGO BLANCO 1\"1/2X25MTS', 'P0158', NULL, NULL, NULL, 1, NULL, 21200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(158, 'CAÑO CORRUGADO', 'PESADO GRIS 1\"', 'P0159', NULL, NULL, NULL, 1, NULL, 37250.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(159, 'CAÑO CORRUGADO', 'PESADO GRIS 7/8\"', 'P0160', NULL, NULL, NULL, 1, NULL, 38000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(160, 'CAÑO IGNIFUGO BLANCO', '3MTS X 20MM', 'P0161', NULL, NULL, NULL, 1, NULL, 4050.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(161, 'CAÑO IGNIFUGO BLANCO', '3MTS X 22MM', 'P0162', NULL, NULL, NULL, 1, NULL, 5444.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(162, 'CAÑO RIGIDO', '3 MTS X 5/8', 'P0163', NULL, NULL, NULL, 1, NULL, 2400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(163, 'CAÑO RIGIDO', '3/4 X 3MTS', 'P0164', NULL, NULL, NULL, 1, NULL, 2980.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(164, 'CAÑO RIGIDO', '7/8 X 3MTS', 'P0165', NULL, NULL, NULL, 1, NULL, 4360.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(165, 'CAÑO RIGIDO', '1\" X 3MTS', 'P0166', NULL, NULL, NULL, 1, NULL, 5200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(166, 'CAPACITOR', '4 UF / 400V C/TERMINAL', 'P0167', NULL, NULL, NULL, 1, NULL, 4404.44, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(167, 'CAPACITOR', '12,5 UF / 400V C/TERMINAL', 'P0168', NULL, NULL, NULL, 1, NULL, 7479.24, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(168, 'CAPACITOR', '14 UF / 400V C/TERMINAL', 'P0169', NULL, NULL, NULL, 1, NULL, 8227.17, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(169, 'CAPACITOR', '16 UF / 400V C/TERMINAL', 'P0170', NULL, NULL, NULL, 1, NULL, 10110.83, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(170, 'CAPACITOR', '1,5 UF / 400V C/CABLE TIPO CARAMELO', 'P0171', NULL, NULL, NULL, 1, NULL, 3490.31, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(171, 'CAPACITOR', '2,5 UF / 400V C/CABLE TIPO CARAMELO', 'P0172', NULL, NULL, NULL, 1, NULL, 3850.42, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(172, 'CAPACITOR', '4 UF / 400V C/CABLE TIPO CARAMELO', 'P0173', NULL, NULL, NULL, 1, NULL, 6343.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(173, 'CAPACITOR', '30 UF', 'P0174', NULL, NULL, NULL, 1, NULL, 7600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(174, 'CAPACITOR', '35 UF', 'P0175', NULL, NULL, NULL, 1, NULL, 8000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(175, 'CAPACITOR', '40 UF', 'P0176', NULL, NULL, NULL, 1, NULL, 9200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(176, 'CAPACITOR', '45 UF', 'P0177', NULL, NULL, NULL, 1, NULL, 9800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(177, 'CAPACITOR', '50 UF', 'P0178', NULL, NULL, NULL, 1, NULL, 10416.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(178, 'CAPACITOR', '60 UF', 'P0179', NULL, NULL, NULL, 1, NULL, 11700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(179, 'CAPACITOR ELECTROLITICO', '140-170 220VCA', 'P0180', NULL, NULL, NULL, 1, NULL, 11740.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(180, 'CAPACITOR ELECTROLITICO', '190-210 220VCA', 'P0181', NULL, NULL, NULL, 1, NULL, 13561.48, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(181, 'CAPACITOR ELECTROLITICO', '240-270 220VCA', 'P0182', NULL, NULL, NULL, 1, NULL, 15365.03, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(182, 'CAPACITOR ELECTROLITICO', '270- 310  220VCA', 'P0183', NULL, NULL, NULL, 1, NULL, 16100.40, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(183, 'CAPACITOR ELECTROLITICO', '320-360 220VCA', 'P0184', NULL, NULL, NULL, 1, NULL, 18746.93, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(184, 'CAPACITOR ELECTROLITICO', '350-400 220VCA', 'P0185', NULL, NULL, NULL, 1, NULL, 19522.15, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(185, 'CARRETEL BORDEADORA', 'ABRA-SOL', 'P0186', NULL, NULL, NULL, 1, NULL, 4500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(186, 'CERRADURA', 'PRIVE 101', 'P0187', NULL, NULL, NULL, 1, NULL, 7000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(187, 'CERRADURA', 'PARA PUERTA PLACA', 'P0188', NULL, NULL, NULL, 1, NULL, 5000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(188, 'CINTA AISLADORA', '15 PLUS TACSA', 'P0189', NULL, NULL, NULL, 1, NULL, 870.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(189, 'CINTA ENMASCARAR', '24 X 40', 'P0190', NULL, NULL, NULL, 1, NULL, 5300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(190, 'CINTA MÉTRICA IMP.', '5MS', 'P0191', NULL, NULL, NULL, 1, NULL, 3250.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(191, 'CINTA MINISTERIO (VERDE)XMT', '-', 'P0192', NULL, NULL, NULL, 1, NULL, 1000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(192, 'CINTA PANAMÁ (AMERICANA) XMT', '-', 'P0193', NULL, NULL, NULL, 1, NULL, 750.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(193, 'CINTA SILLÓN X MT', '-', 'P0194', NULL, NULL, NULL, 1, NULL, 535.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(194, 'CLAVOS PUNTA PARIS  1.\"', 'KG', 'P0195', NULL, NULL, NULL, 1, NULL, 10385.34, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(195, 'CLAVOS PUNTA PARIS  1.1/2\"', 'KG', 'P0196', NULL, NULL, NULL, 1, NULL, 10085.10, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(196, 'CLAVOS PUNTA PARIS  2.\"', 'KG', 'P0197', NULL, NULL, NULL, 1, NULL, 9162.24, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(197, 'CLAVOS PUNTA PARIS  2.1/2\"', 'KG', 'P0198', NULL, NULL, NULL, 1, NULL, 8726.08, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(198, 'CLAVOS PUNTA PARIS  3.\"', 'KG', 'P0199', NULL, NULL, NULL, 1, NULL, 8726.08, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(199, 'CLAVOS PUNTA PARIS  3.1/2\"', 'KG', 'P0200', NULL, NULL, NULL, 1, NULL, 8726.08, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(200, 'CLAVOS PUNTA PARIS  4.\"', 'KG', 'P0201', NULL, NULL, NULL, 1, NULL, 8726.08, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(201, 'CODO ESPIGA', '1/2\"', 'P0202', NULL, NULL, NULL, 1, NULL, 243.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(202, 'CODO ESPIGA', '3/4\"', 'P0203', NULL, NULL, NULL, 1, NULL, 330.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(203, 'CODO ESPIGA', '1\"', 'P0204', NULL, NULL, NULL, 1, NULL, 516.28, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:12', '2026-02-13 19:35:12'),
(204, 'CODO ESPIGA ROSCA HEMBRA', '1/2\"', 'P0205', NULL, NULL, NULL, 1, NULL, 359.60, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(205, 'CODO ESPIGA ROSCA HEMBRA', '3/4\"', 'P0206', NULL, NULL, NULL, 1, NULL, 487.71, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(206, 'CODO ESPIGA ROSCA HEMBRA', '1\"', 'P0207', NULL, NULL, NULL, 1, NULL, 688.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(207, 'COMANDO VENTILADOR ', ' ABON GARDEN', 'P0208', NULL, NULL, NULL, 1, NULL, 12000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(208, 'COMANDO VENTILADOR EVEREST', 'CHICO', 'P0209', NULL, NULL, NULL, 1, NULL, 12100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(209, 'COMANDO VENTILADOR EVEREST', 'GRANDE', 'P0210', NULL, NULL, NULL, 1, NULL, 16050.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(210, 'CONECTOR CAÑO', '20MM', 'P0211', NULL, NULL, NULL, 1, NULL, 390.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(211, 'CONECTOR CAÑO', '22MM', 'P0212', NULL, NULL, NULL, 1, NULL, 535.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(212, 'CONEXIÓN TANQUE', '½\"', 'P0213', NULL, NULL, NULL, 1, NULL, 3700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(213, 'CONEXIÓN TANQUE', '¾\"', 'P0214', NULL, NULL, NULL, 1, NULL, 4200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(214, 'CONEXIÓN TANQUE', '1\"', 'P0215', NULL, NULL, NULL, 1, NULL, 4750.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(215, 'CORTA HIERRO BIASSONI HEX.', '350 MM', 'P0216', NULL, NULL, NULL, 1, NULL, 12625.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(216, 'CORTA HIERRO BIASSONI PLANO', '350 X 35MM', 'P0217', NULL, NULL, NULL, 1, NULL, 11300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(217, 'CORTINA BAÑO ', 'ALUMINIO BRONCEADO X MTS Ø½ ', 'P0218', NULL, NULL, NULL, 1, NULL, 2474.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(218, 'CORTINA BAÑO ', 'HIERRO X MT. Ø ½', 'P0219', NULL, NULL, NULL, 1, NULL, 2000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(219, 'CUPLA', 'Ø40', 'P0220', NULL, NULL, NULL, 1, NULL, 475.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(220, 'CUPLA', 'Ø50', 'P0221', NULL, NULL, NULL, 1, NULL, 506.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(221, 'CUPLA', 'Ø60', 'P0222', NULL, NULL, NULL, 1, NULL, 640.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(222, 'CUPLA', 'Ø100', 'P0223', NULL, NULL, NULL, 1, NULL, 1500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(223, 'CUPLA', 'Ø110', 'P0224', NULL, NULL, NULL, 1, NULL, 1525.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(224, 'CUPLA H - H', '½\"', 'P0225', NULL, NULL, NULL, 1, NULL, 303.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(225, 'CUPLA H - H', '¾\"', 'P0226', NULL, NULL, NULL, 1, NULL, 440.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(226, 'CUPLA H - H', '1\"', 'P0227', NULL, NULL, NULL, 1, NULL, 645.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(227, 'CUPLA H-H C/INSERTO', '½\"', 'P0228', NULL, NULL, NULL, 1, NULL, 3500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(228, 'CUPLA H-H C/INSERTO', '¾\"', 'P0229', NULL, NULL, NULL, 1, NULL, 4675.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(229, 'CUPLA RED.', '¾\" X ½\"', 'P0230', NULL, NULL, NULL, 1, NULL, 456.30, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(230, 'CUPLA RED.', '1\" X ¾\"', 'P0231', NULL, NULL, NULL, 1, NULL, 815.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(231, 'CUPLA RED. ', '1\" X ½\"', 'P0232', NULL, NULL, NULL, 1, NULL, 950.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(232, 'CUPLA REDUCCIÓN', 'Ø100 A Ø60', 'P0233', NULL, NULL, NULL, 1, NULL, 1250.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(233, 'CURVA PVC BLANCO', 'Ø60°-45°', 'P0234', NULL, NULL, NULL, 1, NULL, 1361.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(234, 'CURVA PVC BLANCO', 'Ø100°-45°', 'P0235', NULL, NULL, NULL, 1, NULL, 2200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(235, 'CURVA RIGIDA', '5/8', 'P0236', NULL, NULL, NULL, 1, NULL, 260.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(236, 'CURVA RIGIDA', '3/4', 'P0237', NULL, NULL, NULL, 1, NULL, 280.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(237, 'CURVA RIGIDA', '7/8', 'P0238', NULL, NULL, NULL, 1, NULL, 413.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(238, 'CURVA RIGIDA', '1\"', 'P0239', NULL, NULL, NULL, 1, NULL, 465.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(239, 'CURVAS PARA CAÑO', '20MM', 'P0240', NULL, NULL, NULL, 1, NULL, 670.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(240, 'CURVAS PARA CAÑO', '22MM', 'P0241', NULL, NULL, NULL, 1, NULL, 787.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(241, 'DESTORNILLADOR PHILLIPS', 'CR.VA 5 X 125 CROSS.', 'P0242', NULL, NULL, NULL, 1, NULL, 3100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(242, 'DESTORNILLADOR PLANO', 'CR.VA 5 X 125 CROSS.', 'P0243', NULL, NULL, NULL, 1, NULL, 300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(243, 'DISCO CORTE ', '115 X 1,0 PLANO', 'P0244', NULL, NULL, NULL, 1, NULL, 595.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(244, 'DISCO CORTE ', '180 X 1,2 PLANO', 'P0245', NULL, NULL, NULL, 1, NULL, 1617.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(245, 'DISCO FLAP', 'G° 40', 'P0246', NULL, NULL, NULL, 1, NULL, 2400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(246, 'DISCO FLAP', 'G°60', 'P0247', NULL, NULL, NULL, 1, NULL, 2400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(247, 'ELECTRODO', '2.0MM', 'P0249', NULL, NULL, NULL, 1, NULL, 16400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(248, 'ELECTRODO', '2.5MM', 'P0250', NULL, NULL, NULL, 1, NULL, 12310.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(249, 'ENTREROSCA', '½\"', 'P0251', NULL, NULL, NULL, 1, NULL, 226.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(250, 'ENTREROSCA', '¾\"', 'P0252', NULL, NULL, NULL, 1, NULL, 325.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(251, 'ENTREROSCA', '1\"', 'P0253', NULL, NULL, NULL, 1, NULL, 520.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(252, 'ESCALERA FAMILIAR ', '8 ESCALONES', 'P0254', NULL, NULL, NULL, 1, NULL, 75900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(253, 'ESPIGA 1/2\" ROSCA H RED. ', '3/4\"', 'P0255', NULL, NULL, NULL, 1, NULL, 514.32, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(254, 'ESPIGA 1/2\" ROSCA M RED.', '3/4\"', 'P0257', NULL, NULL, NULL, 1, NULL, 273.90, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(255, 'ESPIGA 3/4\" ROSCA H RED.', '1\"', 'P0258', NULL, NULL, NULL, 1, NULL, 667.03, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(256, 'ESPIGA 3/4\" ROSCA M RED.', '1\"', 'P0259', NULL, NULL, NULL, 1, NULL, 355.69, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(257, 'ESPIGA 3/4\" ROSCA M RED.', '1/2\"', 'P0260', NULL, NULL, NULL, 1, NULL, 273.90, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(258, 'ESPIGA DOBLE', '1/2\"', 'P0261', NULL, NULL, NULL, 1, NULL, 171.44, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(259, 'ESPIGA DOBLE', '3/4\"', 'P0262', NULL, NULL, NULL, 1, NULL, 225.63, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(260, 'ESPIGA DOBLE', '1\"', 'P0263', NULL, NULL, NULL, 1, NULL, 335.98, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(261, 'ESPIGA DOBLE RED.', '3/4\" X 1/2\"', 'P0264', NULL, NULL, NULL, 1, NULL, 291.65, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(262, 'ESPIGA DOBLE RED.', '1\" X 3/4\"', 'P0265', NULL, NULL, NULL, 1, NULL, 356.67, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(263, 'ESPIGA DOBLE RED.', '1\" X 1/2\"', 'P0266', NULL, NULL, NULL, 1, NULL, 258.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(264, 'ESPIGA ROSCA HEMBRA', '1/2\"', 'P0267', NULL, NULL, NULL, 1, NULL, 213.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(265, 'ESPIGA ROSCA HEMBRA', '3/4\"', 'P0268', NULL, NULL, NULL, 1, NULL, 243.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(266, 'ESPIGA ROSCA HEMBRA', '1\"', 'P0269', NULL, NULL, NULL, 1, NULL, 360.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(267, 'ESPIGA ROSCA MACHO', '1/2\"', 'P0270', NULL, NULL, NULL, 1, NULL, 171.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13');
INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `codigo_barra`, `modelo`, `categoria_id`, `marca_id`, `unidad_medida_id`, `proveedor_id`, `precio`, `precio_costo`, `margen_ganancia`, `stock`, `unidad_medida`, `stock_minimo`, `ubicacion_deposito`, `imagen`, `activo`, `deleted_at`, `created_at`, `updated_at`) VALUES
(268, 'ESPIGA ROSCA MACHO', '3/4\"', 'P0271', NULL, NULL, NULL, 1, NULL, 225.60, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(269, 'ESPIGA ROSCA MACHO', '1\"', 'P0272', NULL, NULL, NULL, 1, NULL, 335.90, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(270, 'ESPUMA POLIURETANO', '300ML CROSS', 'P0273', NULL, NULL, NULL, 1, NULL, 6730.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(271, 'FICHA MACHO ', 'ALTO CONSUMO PERNO CHICO', 'P0274', NULL, NULL, NULL, 1, NULL, 2800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(272, 'FICHA MACHO/HEMBRA', 'POLARIZADA C/U', 'P0275', NULL, NULL, NULL, 1, NULL, 1600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(273, 'GABINETE P/BOMBA FIBRA', NULL, 'P0276', NULL, NULL, NULL, 1, NULL, 34000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(274, 'GRAMPA OMEGA PPN', '½\"', 'P0277', NULL, NULL, NULL, 1, NULL, 115.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(275, 'GRAMPA OMEGA PPN', '¾\"', 'P0278', NULL, NULL, NULL, 1, NULL, 140.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(276, 'GRAMPA OMEGA PPN', '1\"', 'P0279', NULL, NULL, NULL, 1, NULL, 171.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(277, 'GRAMPA OMEGA PPN', '1 1/4\"', 'P0280', NULL, NULL, NULL, 1, NULL, 568.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(278, 'GRAMPA OMEGA PPN', '1 1/2\"', 'P0281', NULL, NULL, NULL, 1, NULL, 700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(279, 'GRAMPA OMEGA PPN', '2\"', 'P0282', NULL, NULL, NULL, 1, NULL, 770.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(280, 'GRAMPA PVC', 'Ø40', 'P0283', NULL, NULL, NULL, 1, NULL, 780.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(281, 'GRAMPA PVC', 'Ø50', 'P0284', NULL, NULL, NULL, 1, NULL, 1164.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(282, 'GRAMPA PVC', 'Ø60', 'P0285', NULL, NULL, NULL, 1, NULL, 1300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(283, 'GRAMPA PVC', 'Ø100 / 110', 'P0286', NULL, NULL, NULL, 1, NULL, 2062.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(284, 'GRAMPAS CAÑO', 'Ø20MM', 'P0287', NULL, NULL, NULL, 1, NULL, 275.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(285, 'GRAMPAS CAÑO', 'Ø22MM', 'P0288', NULL, NULL, NULL, 1, NULL, 350.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(286, 'GRAMPAS OMEGA CHAPA', '5/8', 'P0289', NULL, NULL, NULL, 1, NULL, 82.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(287, 'GRAMPAS OMEGA CHAPA', '3/4', 'P0290', NULL, NULL, NULL, 1, NULL, 97.80, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(288, 'GRAMPAS OMEGA CHAPA', '7/8', 'P0291', NULL, NULL, NULL, 1, NULL, 152.80, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(289, 'GRAMPAS OMEGA CHAPA', '1 \"', 'P0292', NULL, NULL, NULL, 1, NULL, 185.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(290, 'GRAMPAS OMEGA CHAPA', '1 1/4 \"', 'P0293', NULL, NULL, NULL, 1, NULL, 305.60, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(291, 'GUANTES ALGODÓN PALMA', 'MDT.BCO.REF', 'P0294', NULL, NULL, NULL, 1, NULL, 940.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(292, 'GUANTE DESCARNE PUÑO CORTO', 'PAR ', 'P0295', NULL, NULL, NULL, 1, NULL, 8000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(293, 'HOJA SIERRA', '18 DIENTES', 'P0297', NULL, NULL, NULL, 1, NULL, 3700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(294, 'HOJA SIERRA', '24 DIENTES', 'P0298', NULL, NULL, NULL, 1, NULL, 3700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(295, 'HOJA SIERRA', '36 DIENTES', 'P0299', NULL, NULL, NULL, 1, NULL, 3400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(296, 'JUEGO 9 LLAVES HEXAGONALES', '1.5 A 10MM LARGAS', 'P0300', NULL, NULL, NULL, 1, NULL, 13900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(297, 'JUEGO 9 LLAVES HEXAGONALES', '1/16\"  A 3/8\" LARGAS', 'P0301', NULL, NULL, NULL, 1, NULL, 13900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(298, 'LAMPARA INFRARROJA', '150W', 'P0302', NULL, NULL, NULL, 1, NULL, 24000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(299, 'LAMPARA LED', '9W-E27', 'P0303', NULL, NULL, NULL, 1, NULL, 900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(300, 'LAMPARA LED', '12W-E27', 'P0304', NULL, NULL, NULL, 1, NULL, 1100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(301, 'LAMPARA LED', '18W-E27', 'P0305', NULL, NULL, NULL, 1, NULL, 2500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(302, 'LAMPARA LED', '20W -E27', 'P0306', NULL, NULL, NULL, 1, NULL, 2850.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(303, 'LAMPARA LED', 'DICROICA GU1O-5W', 'P0307', NULL, NULL, NULL, 1, NULL, 1300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(304, 'LAMPARA LED ', '100W-E40', 'P0308', NULL, NULL, NULL, 1, NULL, 36900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(305, 'LAMPARA LED CON FOTOCELULA', '10W LUZ ', 'P0309', NULL, NULL, NULL, 1, NULL, 15600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(306, 'LAMPARA LED AUTÓNOMA', '12W', 'P0310', NULL, NULL, NULL, 1, NULL, 13700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(307, 'LAMPARA LED TUBULAR', '9W', 'P0311', NULL, NULL, NULL, 1, NULL, 5400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(308, 'LAMPARA LED GOTA FILAMENTO', NULL, 'P0312', NULL, NULL, NULL, 1, NULL, 3500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(309, 'LAMPARA LED GOTA', '4W', 'P0313', NULL, NULL, NULL, 1, NULL, 900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(310, 'LAMPARA FILAMENTO ALIC', '20W', 'P0314', NULL, NULL, NULL, 1, NULL, 7950.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(311, 'LAMPARA LED TUBULAR', '15W', 'P0315', NULL, NULL, NULL, 1, NULL, 6800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(312, 'LIJA AL AGUA', '-', 'P0316', NULL, NULL, NULL, 1, NULL, 540.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(313, 'LIJA ANTIEMPASTE', '-', 'P0317', NULL, NULL, NULL, 1, NULL, 800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(314, 'LIJA ESMERIL', '-', 'P0318', NULL, NULL, NULL, 1, NULL, 400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(315, 'LIMPIA PILETA S/C', '-', 'P0319', NULL, NULL, NULL, 1, NULL, 8400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(316, 'LLAVE AJUSTABLE', 'CROSS 8\"- 203MM', 'P0320', NULL, NULL, NULL, 1, NULL, 18700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(317, 'LLAVE COMBINADA GEDORE', '8MM', 'P0321', NULL, NULL, NULL, 1, NULL, 3000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(318, 'LLAVE COMBINADA GEDORE', '10MM', 'P0322', NULL, NULL, NULL, 1, NULL, 3450.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(319, 'LLAVE COMBINADA GEDORE', '11MM', 'P0323', NULL, NULL, NULL, 1, NULL, 3900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(320, 'LLAVE COMBINADA GEDORE', '12MM', 'P0324', NULL, NULL, NULL, 1, NULL, 4100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(321, 'LLAVE COMBINADA GEDORE', '14MM', 'P0325', NULL, NULL, NULL, 1, NULL, 4900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(322, 'LLAVE COMBINADA GEDORE', '15MM', 'P0326', NULL, NULL, NULL, 1, NULL, 5500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(323, 'LLAVE COMBINADA RHEIN', '8 MM', 'P0327', NULL, NULL, NULL, 1, NULL, 3678.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(324, 'LLAVE COMBINADA RHEIN', '9MM', 'P0328', NULL, NULL, NULL, 1, NULL, 3800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(325, 'LLAVE COMBINADA RHEIN', '10MM ', 'P0329', NULL, NULL, NULL, 1, NULL, 3850.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(326, 'LLAVE COMBINADA RHEIN', '11MM', 'P0330', NULL, NULL, NULL, 1, NULL, 4200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(327, 'LLAVE COMBINADA RHEIN', '12MM', 'P0331', NULL, NULL, NULL, 1, NULL, 4320.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(328, 'LLAVE COMBINADA RHEIN', '13MM', 'P0332', NULL, NULL, NULL, 1, NULL, 4480.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(329, 'LLAVE COMBINADA RHEIN', '14MM', 'P0333', NULL, NULL, NULL, 1, NULL, 5200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(330, 'LLAVE DE PASO METÁLICA', '1\"', 'P0336', NULL, NULL, NULL, 1, NULL, 11200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(331, 'LLAVE DOBLE BOCA GEDORE', '6-7', 'P0337', NULL, NULL, NULL, 1, NULL, 5445.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(332, 'LLAVE DOBLE BOCA GEDORE', '8-9', 'P0338', NULL, NULL, NULL, 1, NULL, 6400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(333, 'LLAVE DOBLE BOCA GEDORE', '8-10', 'P0339', NULL, NULL, NULL, 1, NULL, 6600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(334, 'LLAVE DOBLE BOCA GEDORE', '12-13', 'P0340', NULL, NULL, NULL, 1, NULL, 9200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(335, 'LLAVE DOBLE BOCA GEDORE', '13-15', 'P0341', NULL, NULL, NULL, 1, NULL, 10100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(336, 'LLAVE DOBLE BOCA GEDORE', '14-15', 'P0342', NULL, NULL, NULL, 1, NULL, 11220.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(337, 'LLAVE DOBLE BOCA GEDORE', '16-17', 'P0343', NULL, NULL, NULL, 1, NULL, 11800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(338, 'LLAVE TÉRMICA SICA', '3 X 20', 'P0344', NULL, NULL, NULL, 1, NULL, 18500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(339, 'LLAVE TÉRMICA SICA', '3 X 25', 'P0345', NULL, NULL, NULL, 1, NULL, 18500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(340, 'LLAVE TÉRMICA SICA', '3 X 63', 'P0346', NULL, NULL, NULL, 1, NULL, 30200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(341, 'LLAVE TÉRMICA SICA', '4 X 40', 'P0347', NULL, NULL, NULL, 1, NULL, 31600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(342, 'LLAVE TÉRMICA SICA', '4 X 50', 'P0348', NULL, NULL, NULL, 1, NULL, 42400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(343, 'LLAVE TÉRMICA SICA', '4 X 63', 'P0349', NULL, NULL, NULL, 1, NULL, 42400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(344, 'LLAVE TÉRMICA SICA', '4 X 80', 'P0350', NULL, NULL, NULL, 1, NULL, 140000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(345, 'LLAVE TÉRRICA SICA 1', '1X5', 'P0351', NULL, NULL, NULL, 1, NULL, 4370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(346, 'LLAVE TÉRRICA SICA 1', '1X10', 'P0352', NULL, NULL, NULL, 1, NULL, 4370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(347, 'LLAVE TÉRRICA SICA 1', '1X15', 'P0353', NULL, NULL, NULL, 1, NULL, 4370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(348, 'LLAVE TÉRRICA SICA 1', '1X20', 'P0354', NULL, NULL, NULL, 1, NULL, 4370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(349, 'LLAVE TÉRRICA SICA 1', '1X25', 'P0355', NULL, NULL, NULL, 1, NULL, 4370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(350, 'LLAVE TÉRRICA SICA 1', '1X32', 'P0356', NULL, NULL, NULL, 1, NULL, 4370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(351, 'LLAVE TÉRRICA SICA 1', '1X40', 'P0357', NULL, NULL, NULL, 1, NULL, 6350.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(352, 'LLAVE TÉRRICA SICA 1', '1X50', 'P0358', NULL, NULL, NULL, 1, NULL, 10100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(353, 'LLAVE TÉRRICA SICA 1', '1X63', 'P0359', NULL, NULL, NULL, 1, NULL, 10100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(354, 'LLAVE TÉRRICA SICA 1', '1X80', 'P0360', NULL, NULL, NULL, 1, NULL, 28500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(355, 'LLAVE TÉRRICA SICA 1', '1X100', 'P0361', NULL, NULL, NULL, 1, NULL, 28500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(356, 'LLAVE TÉRRICA SICA 2', '2X10', 'P0362', NULL, NULL, NULL, 1, NULL, 9600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(357, 'LLAVE TÉRRICA SICA 2', '2X20', 'P0363', NULL, NULL, NULL, 1, NULL, 9600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(358, 'LLAVE TÉRRICA SICA 2', '2X25', 'P0364', NULL, NULL, NULL, 1, NULL, 9600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(359, 'LLAVE TÉRRICA SICA 2', '2X32', 'P0365', NULL, NULL, NULL, 1, NULL, 9600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(360, 'LLAVE TÉRRICA SICA 2', '2X40', 'P0366', NULL, NULL, NULL, 1, NULL, 13700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(361, 'LLAVE TÉRRICA SICA 2', '2X50', 'P0367', NULL, NULL, NULL, 1, NULL, 19900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(362, 'LLAVE TÉRRICA SICA 2', '2X63', 'P0368', NULL, NULL, NULL, 1, NULL, 19900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(363, 'LLAVE TÉRRICA SICA 2', '2X80', 'P0369', NULL, NULL, NULL, 1, NULL, 70100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(364, 'LLAVE TÉRRICA SICA 2', '2X100', 'P0370', NULL, NULL, NULL, 1, NULL, 70100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(365, 'LLAVE TÉRRICA SICA 3', '3X10', 'P0371', NULL, NULL, NULL, 1, NULL, 18500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(366, 'LLAVE TÉRRICA SICA 3', '3X15', 'P0372', NULL, NULL, NULL, 1, NULL, 18500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(367, 'MANGUERA REF. P/PILETA', '1 1/4 X MT.', 'P0373', NULL, NULL, NULL, 1, NULL, 1950.80, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(368, 'MANGUERA REF. P/PILETA', '1 1/2 X MT.', 'P0374', NULL, NULL, NULL, 1, NULL, 2545.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(369, 'MANGUERA RIEGO', '3/4 TRANSPARENTE X MT', 'P0375', NULL, NULL, NULL, 1, NULL, 1890.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(370, 'MANGUERA TRICOLOR', '1\" X MT', 'P0376', NULL, NULL, NULL, 1, NULL, 2000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(371, 'MANIJA BAUL ZINCADA', '80MM', 'P0377', NULL, NULL, NULL, 1, NULL, 2900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(372, 'MANIJA BAUL ZINCADA', '91MM', 'P0378', NULL, NULL, NULL, 1, NULL, 3600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(373, 'MANIJA BAUL ZINCADA', '103MM', 'P0379', NULL, NULL, NULL, 1, NULL, 3900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(374, 'MANIJA BISELADA', 'BRONCE PLATIL', 'P0380', NULL, NULL, NULL, 1, NULL, 14700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(375, 'MANIJA FALLEBA', 'EMB/EXT', 'P0381', NULL, NULL, NULL, 1, NULL, 4800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(376, 'MANIJA PULIDA', 'BRONCE MINISTERIO', 'P0382', NULL, NULL, NULL, 1, NULL, 13400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(377, 'MANIJA SANATORIO', 'BRONCE PULIDO', 'P0383', NULL, NULL, NULL, 1, NULL, 22000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(378, 'MANIJA SANATORIO', 'PESADA', 'P0384', NULL, NULL, NULL, 1, NULL, 15000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(379, 'MECHA ACERO RÁPIDO', 'Ø1,50', 'P0385', NULL, NULL, NULL, 1, NULL, 1480.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(380, 'MECHA ACERO RÁPIDO', 'Ø1,75', 'P0386', NULL, NULL, NULL, 1, NULL, 1300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(381, 'MECHA ACERO RÁPIDO', 'Ø2', 'P0387', NULL, NULL, NULL, 1, NULL, 1300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(382, 'MECHA ACERO RÁPIDO', 'Ø4,75', 'P0398', NULL, NULL, NULL, 1, NULL, 2600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(383, 'MECHA ACERO RÁPIDO', 'Ø5', 'P0399', NULL, NULL, NULL, 1, NULL, 2750.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(384, 'MECHA ACERO RÁPIDO', 'Ø5,25', 'P0400', NULL, NULL, NULL, 1, NULL, 2910.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(385, 'MECHA ACERO RÁPIDO', 'Ø5,50', 'P0401', NULL, NULL, NULL, 1, NULL, 3200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(386, 'MECHA ACERO RÁPIDO', 'Ø5,75', 'P0402', NULL, NULL, NULL, 1, NULL, 3260.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(387, 'MECHA ACERO RÁPIDO', 'Ø6', 'P0403', NULL, NULL, NULL, 1, NULL, 3350.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(388, 'MECHA ACERO RÁPIDO', 'Ø6,25', 'P0404', NULL, NULL, NULL, 1, NULL, 3800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(389, 'MECHA ACERO RÁPIDO', 'Ø6,50', 'P0405', NULL, NULL, NULL, 1, NULL, 3900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(390, 'MECHA ACERO RÁPIDO', 'Ø7,25', 'P0408', NULL, NULL, NULL, 1, NULL, 4980.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(391, 'MECHA ACERO RÁPIDO', 'Ø7,50', 'P0409', NULL, NULL, NULL, 1, NULL, 5200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(392, 'MECHA ACERO RÁPIDO', 'Ø7,75', 'P0410', NULL, NULL, NULL, 1, NULL, 5770.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(393, 'MECHA ACERO RÁPIDO', 'Ø8,25', 'P0412', NULL, NULL, NULL, 1, NULL, 6600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(394, 'MECHA ACERO RÁPIDO', 'Ø8,50', 'P0413', NULL, NULL, NULL, 1, NULL, 6700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(395, 'MECHA ACERO RÁPIDO', 'Ø8,75', 'P0414', NULL, NULL, NULL, 1, NULL, 7200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(396, 'MECHA ACERO RÁPIDO', 'Ø9', 'P0415', NULL, NULL, NULL, 1, NULL, 7600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(397, 'MECHA ACERO RÁPIDO', 'Ø9,25', 'P0416', NULL, NULL, NULL, 1, NULL, 8100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(398, 'MECHA ACERO RÁPIDO', 'Ø9,50', 'P0417', NULL, NULL, NULL, 1, NULL, 8450.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(399, 'MECHA ACERO RÁPIDO', 'Ø9,75', 'P0418', NULL, NULL, NULL, 1, NULL, 9200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(400, 'MECHA ACERO RÁPIDO', 'Ø10', 'P0419', NULL, NULL, NULL, 1, NULL, 9600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(401, 'MECHA ACERO RÁPIDO', 'Ø10,25', 'P0420', NULL, NULL, NULL, 1, NULL, 11400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(402, 'MECHA ACERO RÁPIDO', 'Ø10,50', 'P0421', NULL, NULL, NULL, 1, NULL, 11810.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(403, 'MECHA ACERO RÁPIDO', 'Ø10,75', 'P0422', NULL, NULL, NULL, 1, NULL, 12870.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:13', '2026-02-13 19:35:13'),
(404, 'MECHA ACERO RÁPIDO', 'Ø11', 'P0423', NULL, NULL, NULL, 1, NULL, 13260.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(405, 'MECHA ACERO RÁPIDO', 'Ø11,25', 'P0424', NULL, NULL, NULL, 1, NULL, 14260.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(406, 'MECHA ACERO RÁPIDO', 'Ø11,50', 'P0425', NULL, NULL, NULL, 1, NULL, 14560.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(407, 'MECHA ACERO RÁPIDO', 'Ø11,75', 'P0426', NULL, NULL, NULL, 1, NULL, 15530.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(408, 'MECHA ACERO RÁPIDO', 'Ø12', 'P0427', NULL, NULL, NULL, 1, NULL, 16470.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(409, 'MECHA ACERO RÁPIDO', 'Ø12,25', 'P0428', NULL, NULL, NULL, 1, NULL, 17800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(410, 'MECHA ACERO RÁPIDO', 'Ø12,50', 'P0429', NULL, NULL, NULL, 1, NULL, 18500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(411, 'MECHA ACERO RÁPIDO', 'Ø12,75', 'P0430', NULL, NULL, NULL, 1, NULL, 20300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(412, 'MECHA ACERO RÁPIDO', 'Ø13', 'P0431', NULL, NULL, NULL, 1, NULL, 20900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(413, 'MECHA ACERO RÁPIDO ', 'Ø1', 'P0432', NULL, NULL, NULL, 1, NULL, 1480.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(414, 'MECHA ACERO RÁPIDO ', 'Ø1,25', 'P0433', NULL, NULL, NULL, 1, NULL, 1480.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(415, 'MECHA WIDIA', 'Ø10', 'P0436', NULL, NULL, NULL, 1, NULL, 3750.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(416, 'MECHA WIDIA LARGA', 'Ø6 X 200', 'P0437', NULL, NULL, NULL, 1, NULL, 8100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(417, 'MECHA WIDIA LARGA', 'Ø6 X 400', 'P0438', NULL, NULL, NULL, 1, NULL, 12000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(418, 'MECHA WIDIA LARGA', 'Ø14 X 400', 'P0439', NULL, NULL, NULL, 1, NULL, 32850.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(419, 'MEDIA SOMBRA VERDE', '2MTS ANCHO X 1MT', 'P0440', NULL, NULL, NULL, 1, NULL, 8750.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(420, 'MODULO BIPOLAR', 'JELUZ VERONA', 'P0441', NULL, NULL, NULL, 1, NULL, 3300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(421, 'MODULO C/U', NULL, 'P0442', NULL, NULL, NULL, 1, NULL, 670.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(422, 'MODULO CIEGO', 'JELUZ VERONA', 'P0443', NULL, NULL, NULL, 1, NULL, 140.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(423, 'MODULO CIEGO', 'PLASNAVI', 'P0444', NULL, NULL, NULL, 1, NULL, 300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(424, 'MODULO COMBINACIÓN', 'JELUZ VERONA', 'P0445', NULL, NULL, NULL, 1, NULL, 1370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(425, 'MODULO COMBINACIÓN', 'PLASNAVI', 'P0446', NULL, NULL, NULL, 1, NULL, 2200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(426, 'MODULO PULSADOR', 'JELUZ VERONA', 'P0447', NULL, NULL, NULL, 1, NULL, 1200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(427, 'MODULO PUNTO', 'JELUZ VERONA', 'P0448', NULL, NULL, NULL, 1, NULL, 1120.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(428, 'MODULO PUNTO', '2 1/2 - JELUZ VERONA', 'P0449', NULL, NULL, NULL, 1, NULL, 2370.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(429, 'MODULO PUNTO', 'PLASNAVI', 'P0450', NULL, NULL, NULL, 1, NULL, 1800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(430, 'MODULO TELEFONO', 'PLASNAVI', 'P0451', NULL, NULL, NULL, 1, NULL, 5600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(431, 'MODULO TODA TELEFONO', 'JELUZ VERONA', 'P0452', NULL, NULL, NULL, 1, NULL, 4450.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(432, 'MODULO TOMACORRIENTE', '10 AMP - JELUZ VERONA', 'P0453', NULL, NULL, NULL, 1, NULL, 1200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(433, 'MODULO TOMACORRIENTE', '20 AMP - JELUZ VERONA', 'P0454', NULL, NULL, NULL, 1, NULL, 2300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(434, 'MODULO TOMACORRIENTE', 'PLASNAVI', 'P0455', NULL, NULL, NULL, 1, NULL, 2000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(435, 'MODULO TOMACORRIENTE', '20 AMP - PLASNAVI', 'P0456', NULL, NULL, NULL, 1, NULL, 3200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(436, 'MODULO VARIADOR VENTILADOR', 'JELUZ VERONA', 'P0457', NULL, NULL, NULL, 1, NULL, 10100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(437, 'MODULO VENTILADOR VELOC.', 'PLASNAVI', 'P0458', NULL, NULL, NULL, 1, NULL, 10100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(438, 'NIPLE ', ' ½\" X 6CM', 'P0459', NULL, NULL, NULL, 1, NULL, 300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(439, 'NIPLE ', '¾\" X 6CM', 'P0460', NULL, NULL, NULL, 1, NULL, 402.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(440, 'NIPLE ', '¾\" X 10CM', 'P0461', NULL, NULL, NULL, 1, NULL, 600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(441, 'NIPLE ', '1\" X 6M', 'P0462', NULL, NULL, NULL, 1, NULL, 615.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(442, 'PALA ANCHA BIASSONI', 'MOD. 992100', 'P0463', NULL, NULL, NULL, 1, NULL, 65000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(443, 'PALA CORAZÓN BIASSONI', 'MOD.992110', 'P0464', NULL, NULL, NULL, 1, NULL, 55000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(444, 'PALA PUNTA BIASSONI', 'MOD.992130', 'P0465', NULL, NULL, NULL, 1, NULL, 65000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(445, 'PINCEL', '1\"', 'P0466', NULL, NULL, NULL, 1, NULL, 1400.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(446, 'PINCEL', '1 ½\"', 'P0467', NULL, NULL, NULL, 1, NULL, 2000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(447, 'PINCEL', '2 ½\"', 'P0468', NULL, NULL, NULL, 1, NULL, 3000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(448, 'PINZA PICO LORO', 'CROSSMASTER 6\"', 'P0469', NULL, NULL, NULL, 1, NULL, 14500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(449, 'PINZA PUNTA MEDIA CAÑA', 'CROSSMASTER 6½\"', 'P0470', NULL, NULL, NULL, 1, NULL, 11900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(450, 'PINZA UNIV.', 'CROSSMASTER 7\"', 'P0471', NULL, NULL, NULL, 1, NULL, 15500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(451, 'PINZA UNIV.', 'CROSSMASTER 8\"', 'P0472', NULL, NULL, NULL, 1, NULL, 18600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(452, 'PLAFON S17- LED 18W', 'REDONDO', 'P0473', NULL, NULL, NULL, 1, NULL, 7600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(453, 'PLAFON S17- LED 18W', 'CUADRADO', 'P0474', NULL, NULL, NULL, 1, NULL, 8050.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(454, 'PORTA CUCHILLAS ', '18 MM ECONO. CROSS', 'P0475', NULL, NULL, NULL, 1, NULL, 3255.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(455, 'PORTALAMPARA', 'PORCELANA C/GRAMPA \"L\"', 'P0476', NULL, NULL, NULL, 1, NULL, 2000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(456, 'PORTALAMPARA', 'PORCELANA C/GRAMPA 3/8', 'P0477', NULL, NULL, NULL, 1, NULL, 1966.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(457, 'PORTALAMPARA', 'PVC', 'P0478', NULL, NULL, NULL, 1, NULL, 1500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(458, 'PROYECTOR HALOGENO', '150 W', 'P0479', NULL, NULL, NULL, 1, NULL, 12465.40, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(459, 'PROYECTOR HALOGENO', '500W CON LAMPARA', 'P0480', NULL, NULL, NULL, 1, NULL, 16537.43, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(460, 'PROYECTOR LED ', '10W LUZ FRÍA', 'P0481', NULL, NULL, NULL, 1, NULL, 6100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(461, 'PROYECTOR LED ', '20W - SICA', 'P0483', NULL, NULL, NULL, 1, NULL, 10800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(462, 'PROYECTOR LED ', '100W LUZ FRÍA', 'P0484', NULL, NULL, NULL, 1, NULL, 27100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(463, 'PROYECTOR LED ', '30W LUZ FRÍA', 'P0485', NULL, NULL, NULL, 1, NULL, 7600.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(464, 'PROYECTOR LED ', '20W - CAPOBIANCO', 'P0486', NULL, NULL, NULL, 1, NULL, 12000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(465, 'RAMAL T', 'Ø40', 'P0487', NULL, NULL, NULL, 1, NULL, 960.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(466, 'RAMAL Y', 'Ø60°-45°', 'P0491', NULL, NULL, NULL, 1, NULL, 2048.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(467, 'RAMAL Y', 'Ø110°-45°', 'P0492', NULL, NULL, NULL, 1, NULL, 3700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(468, 'RECEPTACULO', 'CURVO PVC', 'P0493', NULL, NULL, NULL, 1, NULL, 3000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(469, 'RECEPTACULO', 'RECTO PVC', 'P0494', NULL, NULL, NULL, 1, NULL, 4200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(470, 'RECEPTACULO', 'CURVO PORCELANA', 'P0495', NULL, NULL, NULL, 1, NULL, 3540.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(471, 'REGATONES GOMA', 'Ø16MM', 'P0496', NULL, NULL, NULL, 1, NULL, 333.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(472, 'REGATONES GOMA', 'Ø19MM', 'P0497', NULL, NULL, NULL, 1, NULL, 335.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(473, 'REGATONES GOMA', 'Ø22MM', 'P0498', NULL, NULL, NULL, 1, NULL, 348.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(474, 'REGATONES GOMA', 'Ø25MM', 'P0499', NULL, NULL, NULL, 1, NULL, 355.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(475, 'REMACHES RÁPIDOS POP', '3,5 X 10 C/U', 'P0500', NULL, NULL, NULL, 1, NULL, 18.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(476, 'REMACHES RÁPIDOS POP', '3,5 X 12 C/U', 'P0501', NULL, NULL, NULL, 1, NULL, 19.80, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(477, 'REMACHES RÁPIDOS POP', '3,5 X 14 C/U', 'P0502', NULL, NULL, NULL, 1, NULL, 20.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(478, 'REMACHES RÁPIDOS POP', '3,5 X 16 C/U', 'P0503', NULL, NULL, NULL, 1, NULL, 22.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(479, 'REMACHES RÁPIDOS POP', '4 X 12 C/U', 'P0504', NULL, NULL, NULL, 1, NULL, 24.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(480, 'REMACHES RÁPIDOS POP', '4 X 16 C/U', 'P0505', NULL, NULL, NULL, 1, NULL, 26.80, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(481, 'REMACHES RÁPIDOS POP', '4 X 19 C/U', 'P0506', NULL, NULL, NULL, 1, NULL, 29.30, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(482, 'REMACHES RÁPIDOS POP', '4X 25 C/U', 'P0507', NULL, NULL, NULL, 1, NULL, 40.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(483, 'REMACHES RÁPIDOS POP', '4,8 X 10  C/U', 'P0508', NULL, NULL, NULL, 1, NULL, 41.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(484, 'REMACHES RÁPIDOS POP', '4,8 X 12 C/U ', 'P0509', NULL, NULL, NULL, 1, NULL, 42.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(485, 'REMACHES RÁPIDOS POP', '4,8 X 14 C/U', 'P0510', NULL, NULL, NULL, 1, NULL, 44.03, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(486, 'REMACHES RÁPIDOS POP', '4,8 X 16 C/U', 'P0511', NULL, NULL, NULL, 1, NULL, 44.75, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(487, 'REMACHES RÁPIDOS POP', '4,8 X 20 C/U', 'P0512', NULL, NULL, NULL, 1, NULL, 45.60, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(488, 'REMACHES RÁPIDOS POP', '4,8 X 25 C/U ', 'P0513', NULL, NULL, NULL, 1, NULL, 46.30, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(489, 'REMACHES RÁPIDOS POP', '5 X 12 C/U ', 'P0514', NULL, NULL, NULL, 1, NULL, 42.20, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(490, 'REMACHES RÁPIDOS POP', '5 X 14 C/U', 'P0515', NULL, NULL, NULL, 1, NULL, 60.15, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(491, 'REMACHES RÁPIDOS POP', '5 X 16 C/U', 'P0516', NULL, NULL, NULL, 1, NULL, 46.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(492, 'RIEL  SOPORTE RAPI-STAND', 'X PAR', 'P0517', NULL, NULL, NULL, 1, NULL, 22900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(493, 'RODAMIENTO', 'SKF 6201', 'P0518', NULL, NULL, NULL, 1, NULL, 5000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(494, 'RODAMIENTO', 'SKF 6203', 'P0519', NULL, NULL, NULL, 1, NULL, 6500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(495, 'RODAMIENTO', 'SKF 2Z 6204', 'P0520', NULL, NULL, NULL, 1, NULL, 5500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(496, 'RODAMIENTO', 'SKF 6204 2RSH/C3 (BLINDADO)', 'P0521', NULL, NULL, NULL, 1, NULL, 8000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(497, 'RODAMIENTO', 'SKF 6205 2RSH', 'P0522', NULL, NULL, NULL, 1, NULL, 8500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(498, 'RODAMIENTO', 'SKF 6205 2RS1/C3', 'P0523', NULL, NULL, NULL, 1, NULL, 9300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(499, 'RODAMIENTO', 'SKF 6200 2RSH/C3', 'P0524', NULL, NULL, NULL, 1, NULL, 12000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(500, 'RODAMIENTO', '609', 'P0525', NULL, NULL, NULL, 1, NULL, 7000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(501, 'RODAMIENTO', 'NTN 6200 Z NR', 'P0526', NULL, NULL, NULL, 1, NULL, 15000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(502, 'RODAMIENTO', 'NTN 6202 LLUC3/2AS', 'P0527', NULL, NULL, NULL, 1, NULL, 9000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(503, 'RODAMIENTO', 'NSK 6200', 'P0528', NULL, NULL, NULL, 1, NULL, 4300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(504, 'RODAMIENTO', 'NSK 6201', 'P0529', NULL, NULL, NULL, 1, NULL, 4500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(505, 'RODAMIENTO', 'GBC 6204', 'P0530', NULL, NULL, NULL, 1, NULL, 6000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(506, 'RODAMIENTO', 'KBS 6002', 'P0531', NULL, NULL, NULL, 1, NULL, 3500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(507, 'RODAMIENTO', 'KOYO 629', 'P0532', NULL, NULL, NULL, 1, NULL, 5200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(508, 'SELLADOR GRIETA POMO', NULL, 'P0533', NULL, NULL, NULL, 1, NULL, 9100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(509, 'SELLADOR SILICONA', '280ML', 'P0534', NULL, NULL, NULL, 1, NULL, 6500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(510, 'SOGA TRENZADA PP', '6MM X MT', 'P0536', NULL, NULL, NULL, 1, NULL, 318.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(511, 'SOGA TRENZADA PP', '8MM X MT', 'P0537', NULL, NULL, NULL, 1, NULL, 590.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(512, 'SOGA TRENZADA PP', '10MM X MT', 'P0538', NULL, NULL, NULL, 1, NULL, 920.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(513, 'SOGA TRENZADA PP', '12MM X MT', 'P0539', NULL, NULL, NULL, 1, NULL, 1360.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(514, 'SOPORTE CORTINA', 'ALUMINIO½ ABIERTO', 'P0540', NULL, NULL, NULL, 1, NULL, 1160.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(515, 'SOPORTE CORTINA', 'ALUMINIO½ CERRADO', 'P0541', NULL, NULL, NULL, 1, NULL, 1160.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(516, 'SOPORTE CORTINA', 'HIERRO½ ABIERTO', 'P0542', NULL, NULL, NULL, 1, NULL, 850.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(517, 'SOPORTE CORTINA', 'HIERRO½ CERRADO', 'P0543', NULL, NULL, NULL, 1, NULL, 850.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(518, 'SOPORTE CORTINA', '5/8 ABIERTO Y CERRADO', 'P0544', NULL, NULL, NULL, 1, NULL, 900.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(519, 'SOPORTE ESTANTERÍA', '100 X 125', 'P0545', NULL, NULL, NULL, 1, NULL, 750.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(520, 'SOPORTE ESTANTERÍA', '250 X 300', 'P0546', NULL, NULL, NULL, 1, NULL, 2315.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(521, 'SOPORTE RAPI-STAND', '17CM X PAR', 'P0547', NULL, NULL, NULL, 1, NULL, 6800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(522, 'SOPORTE RAPI-STAND', '27 CM X PAR', 'P0548', NULL, NULL, NULL, 1, NULL, 14000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(523, 'SOPORTE RAPI-STAND', '37 X PAR', 'P0549', NULL, NULL, NULL, 1, NULL, 17000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(524, 'TAPA BASTIDOR', 'JELUZ VERONA', 'P0550', NULL, NULL, NULL, 1, NULL, 930.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(525, 'TAPA BASTIDOR', 'PLASNAVI', 'P0551', NULL, NULL, NULL, 1, NULL, 1000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(526, 'TAPA INODORO', NULL, 'P0552', NULL, NULL, NULL, 1, NULL, 16100.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(527, 'TAPA PORTA MODULO EXT.', 'JELUZ EXTERIOR', 'P0553', NULL, NULL, NULL, 1, NULL, 545.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(528, 'TAPON ROSCA HEMBRA', '½\"', 'P0554', NULL, NULL, NULL, 1, NULL, 211.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(529, 'TAPON ROSCA HEMBRA', '¾\"', 'P0555', NULL, NULL, NULL, 1, NULL, 295.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(530, 'TAPON ROSCA HEMBRA', '1\"', 'P0556', NULL, NULL, NULL, 1, NULL, 550.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(531, 'TAPON ROSCA MACHO', '½\"', 'P0557', NULL, NULL, NULL, 1, NULL, 242.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(532, 'TAPON ROSCA MACHO', '¾\"', 'P0558', NULL, NULL, NULL, 1, NULL, 263.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(533, 'TAPON ROSCA MACHO', '1\"', 'P0559', NULL, NULL, NULL, 1, NULL, 296.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(534, 'TARUGO', 'Ø6', 'P0560', NULL, NULL, NULL, 1, NULL, 14.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(535, 'TARUGO', 'Ø8', 'P0561', NULL, NULL, NULL, 1, NULL, 30.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(536, 'TARUGO', 'Ø10', 'P0562', NULL, NULL, NULL, 1, NULL, 55.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14');
INSERT INTO `productos` (`id`, `nombre`, `descripcion`, `codigo_barra`, `modelo`, `categoria_id`, `marca_id`, `unidad_medida_id`, `proveedor_id`, `precio`, `precio_costo`, `margen_ganancia`, `stock`, `unidad_medida`, `stock_minimo`, `ubicacion_deposito`, `imagen`, `activo`, `deleted_at`, `created_at`, `updated_at`) VALUES
(537, 'TARUGO', 'Ø12', 'P0563', NULL, NULL, NULL, 1, NULL, 127.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(538, 'TARUGO LADO HUECO ', 'Ø6', 'P0564', NULL, NULL, NULL, 1, NULL, 42.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(539, 'TARUGO LADO HUECO ', 'Ø8', 'P0565', NULL, NULL, NULL, 1, NULL, 64.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(540, 'TARUGO LADO HUECO ', 'Ø10', 'P0566', NULL, NULL, NULL, 1, NULL, 115.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(541, 'TEE ESPIGA', '1/2\"', 'P0567', NULL, NULL, NULL, 1, NULL, 635.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(542, 'TEE ESPIGA', '3/4\"', 'P0568', NULL, NULL, NULL, 1, NULL, 685.76, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(543, 'TEE ESPIGA', '1\"', 'P0569', NULL, NULL, NULL, 1, NULL, 956.70, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(544, 'TENAZA CARPINTERO', 'PROF.CROSS. 7\"', 'P0570', NULL, NULL, NULL, 1, NULL, 16630.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(545, 'TENDEDERO CALESITA', 'BASE DE CEMENTO', 'P0571', NULL, NULL, NULL, 1, NULL, 115000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(546, 'TENDEDERO EXTENSIBLE', '7 VARILLAS', 'P0572', NULL, NULL, NULL, 1, NULL, 37000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(547, 'TORNILLOS CABEZA FRESADA 1/8', '1/8 X 1\"', 'P0574', NULL, NULL, NULL, 1, NULL, 22.73, 6.10, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(548, 'TORNILLOS CABEZA FRESADA 1/8', '1/8 X 2\"', 'P0575', NULL, NULL, NULL, 1, NULL, 40.07, 6.10, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(549, 'TORNILLOS CABEZA FRESADA 1/8', '1/8 X 1/2\"', 'P0576', NULL, NULL, NULL, 1, NULL, 13.82, 6.10, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(550, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 1/4', 'P0577', NULL, NULL, NULL, 1, NULL, 16.86, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(551, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 1/2', 'P0578', NULL, NULL, NULL, 1, NULL, 24.31, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(552, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 3/4', 'P0579', NULL, NULL, NULL, 1, NULL, 32.20, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(553, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 1', 'P0580', NULL, NULL, NULL, 1, NULL, 39.93, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(554, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 1 1/2', 'P0581', NULL, NULL, NULL, 1, NULL, 54.16, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(555, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 2', 'P0582', NULL, NULL, NULL, 1, NULL, 67.68, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(556, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 2 1/2', 'P0583', NULL, NULL, NULL, 1, NULL, 81.93, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(557, 'TORNILLOS CABEZA FRESADA 5/32', '5/32 X 3', 'P0584', NULL, NULL, NULL, 1, NULL, 95.00, 7.30, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(558, 'TORNILLOS CABEZA FRESADA 3/16', '3/16 X 1\"', 'P0585', NULL, NULL, NULL, 1, NULL, 48.23, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(559, 'TORNILLOS CABEZA FRESADA 3/16', '3/16 X 1 1/2', 'P0586', NULL, NULL, NULL, 1, NULL, 65.61, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(560, 'TORNILLOS CABEZA FRESADA 3/16', '3/16 X 2\"', 'P0587', NULL, NULL, NULL, 1, NULL, 83.95, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(561, 'TORNILLOS CABEZA FRESADA 3/16', '3/16 X 3\"', 'P0588', NULL, NULL, NULL, 1, NULL, 117.44, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(562, 'TORNILLOS CABEZA FRESADA 1/4', '1/4 X 1/2\"', 'P0589', NULL, NULL, NULL, 1, NULL, 54.07, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(563, 'TORNILLOS CABEZA FRESADA 1/4', '1/4 X 3/4', 'P0590', NULL, NULL, NULL, 1, NULL, 69.90, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(564, 'TORNILLOS CABEZA FRESADA 1/4', '1/4 X 1\"', 'P0591', NULL, NULL, NULL, 1, NULL, 76.98, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(565, 'TORNILLOS CABEZA FRESADA 1/4', '1/4 X 1 1/2\"', 'P0592', NULL, NULL, NULL, 1, NULL, 102.35, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(566, 'TORNILLOS CABEZA FRESADA 5/6', '5/6 X 1/2', 'P0593', NULL, NULL, NULL, 1, NULL, 97.20, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(567, 'TORNILLOS CABEZA FRESADA 5/6', '5/6 X 3/4', 'P0594', NULL, NULL, NULL, 1, NULL, 108.74, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(568, 'TORNILLOS CABEZA FRESADA 5/6', '5/6 X 1', 'P0595', NULL, NULL, NULL, 1, NULL, 94.60, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(569, 'TORNILLOS CABEZA REDONDA 1/4', '1/4 X 1/2', 'P0596', NULL, NULL, NULL, 1, NULL, 54.07, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(570, 'TORNILLOS CABEZA REDONDA 1/4', '1/4 X 3/4', 'P0597', NULL, NULL, NULL, 1, NULL, 69.60, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(571, 'TORNILLOS CABEZA REDONDA 1/4', '1/4 X 1', 'P0598', NULL, NULL, NULL, 1, NULL, 76.98, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(572, 'TORNILLOS CABEZA REDONDA 1/4', '1/4 X 1 1/2', 'P0599', NULL, NULL, NULL, 1, NULL, 102.35, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(573, 'TORNILLOS CABEZA REDONDA 5/16', '5/16 X 1/2', 'P0600', NULL, NULL, NULL, 1, NULL, 97.20, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(574, 'TORNILLOS CABEZA REDONDA 5/16', '5/16 X 3/4', 'P0601', NULL, NULL, NULL, 1, NULL, 108.74, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(575, 'TORNILLOS CABEZA REDONDA 5/16', '5/16 X 1', 'P0602', NULL, NULL, NULL, 1, NULL, 94.60, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(576, 'TORNILLOS CABEZA REDONDA 5/16', '5/16 X 1 1/4', 'P0603', NULL, NULL, NULL, 1, NULL, 146.00, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(577, 'TORNILLOS CABEZA REDONDA 5/16', '5/16 X 1 1/2', 'P0604', NULL, NULL, NULL, 1, NULL, 170.19, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(578, 'TORNILLOS CABEZA REDONDA 5/16', '5/16 X 1 3/4 ', 'P0605', NULL, NULL, NULL, 1, NULL, 187.95, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(579, 'TORNILLOS CABEZA REDONDA 5/16', '5/16 X 2', 'P0606', NULL, NULL, NULL, 1, NULL, 206.50, 12.80, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(580, 'TORNILLOS CABEZA TANQUE 3/16', ' 3/16 X 1/2\"', 'P0607', NULL, NULL, NULL, 1, NULL, 29.71, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(581, 'TORNILLOS CABEZA TANQUE 3/16', '3/16 X 1\"', 'P0608', NULL, NULL, NULL, 1, NULL, 48.23, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(582, 'TORNILLOS CABEZA TANQUE 3/16', '3/16 X 1 1/2\"', 'P0609', NULL, NULL, NULL, 1, NULL, 65.61, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(583, 'TORNILLOS CABEZA TANQUE 3/16', '3/16 X 2 1/2\"', 'P0610', NULL, NULL, NULL, 1, NULL, 95.88, 8.60, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(584, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 1/4', 'P0611', NULL, NULL, NULL, 1, NULL, 36.77, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(585, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 1/2', 'P0612', NULL, NULL, NULL, 1, NULL, 54.07, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(586, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 3/4', 'P0613', NULL, NULL, NULL, 1, NULL, 69.60, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(587, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 1', 'P0614', NULL, NULL, NULL, 1, NULL, 76.98, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(588, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 1 1/4 ', 'P0615', NULL, NULL, NULL, 1, NULL, 91.20, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(589, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 1 1/2', 'P0616', NULL, NULL, NULL, 1, NULL, 102.35, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(590, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 2 ', 'P0617', NULL, NULL, NULL, 1, NULL, 130.91, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(591, 'TORNILLOS CABEZA TANQUE 1/4', '1/4 X 2 1/2\"', 'P0618', NULL, NULL, NULL, 1, NULL, 161.19, 10.20, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(592, 'TORNILLOS FIX DORADO', '5 X 40 ', 'P0619', NULL, NULL, NULL, 1, NULL, 31.75, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(593, 'TORNILLOS FIX DORADO', '5 X 50', 'P0620', NULL, NULL, NULL, 1, NULL, 36.90, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(594, 'TORNILLOS FIX DORADO', '6 X 40', 'P0621', NULL, NULL, NULL, 1, NULL, 51.76, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(595, 'TORNILLOS FIX DORADO', '6 X 50', 'P0622', NULL, NULL, NULL, 1, NULL, 58.48, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(596, 'TORNILLOS FIX NEGRO (3,5)', '6X3/4\" MADERA X500-PRF', 'P0623', NULL, NULL, NULL, 1, NULL, 25.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(597, 'TORNILLOS FIX NEGRO (3,5)', '6X1\" MADERA X500-PRF', 'P0624', NULL, NULL, NULL, 1, NULL, 29.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(598, 'TORNILLOS FIX NEGRO (3,5)', '6X5/8\" MADERA X500-PRF', 'P0625', NULL, NULL, NULL, 1, NULL, 30.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(599, 'TORNILLOS FIX NEGRO (3,5)', '6X1\"1/4 MADERA X500-PRF', 'P0626', NULL, NULL, NULL, 1, NULL, 33.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(600, 'TORNILLOS FIX NEGRO (3,5)', '6X1\"1/2 MADERA X500-PRF', 'P0627', NULL, NULL, NULL, 1, NULL, 38.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(601, 'TORNILLOS FIX NEGRO (3,5)', '6X2\" MADERA X300-PRF', 'P0629', NULL, NULL, NULL, 1, NULL, 43.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(602, 'TORNILLOS FIX NEGRO (4,5)', '8X3\" MADERA X300-PRF', 'P0636', NULL, NULL, NULL, 1, NULL, 50.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(603, 'TORNILLOS INODORO', '22 X 70 MM C/U', 'P0637', NULL, NULL, NULL, 1, NULL, 1050.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:14', '2026-02-13 19:35:14'),
(604, 'TORNILLOS PARKER 10', '10 X 1/2', 'P0638', NULL, NULL, NULL, 1, NULL, 30.19, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(605, 'TORNILLOS PARKER 10', '10 X 3/4', 'P0639', NULL, NULL, NULL, 1, NULL, 37.04, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(606, 'TORNILLOS PARKER 10', '10 X 1', 'P0640', NULL, NULL, NULL, 1, NULL, 42.34, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(607, 'TORNILLOS PARKER 10', '10 X 1 1/4', 'P0641', NULL, NULL, NULL, 1, NULL, 55.71, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(608, 'TORNILLOS PARKER 10', '10 X 2 ', 'P0642', NULL, NULL, NULL, 1, NULL, 77.73, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(609, 'TORNILLOS PARKER 12', '12 X 1/2', 'P0643', NULL, NULL, NULL, 1, NULL, 38.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(610, 'TORNILLOS PARKER 12', '12 X 3/4', 'P0644', NULL, NULL, NULL, 1, NULL, 49.97, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(611, 'TORNILLOS PARKER 12', '12 X 1', 'P0645', NULL, NULL, NULL, 1, NULL, 61.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(612, 'TORNILLOS PARKER 14', '14 X 1/2 ', 'P0646', NULL, NULL, NULL, 1, NULL, 51.40, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(613, 'TORNILLOS PARKER 14', '14 X 3/4', 'P0647', NULL, NULL, NULL, 1, NULL, 66.34, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(614, 'TORNILLOS PARKER 14', '14 X 1', 'P0648', NULL, NULL, NULL, 1, NULL, 78.65, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(615, 'TORNILLOS PARKER 14', '14 X 1 1/2', 'P0649', NULL, NULL, NULL, 1, NULL, 109.75, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(616, 'TORNILLOS PARKER 4', '4 X 1/4', 'P0650', NULL, NULL, NULL, 1, NULL, 9.55, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(617, 'TORNILLOS PARKER 4', '4 X 1/2', 'P0651', NULL, NULL, NULL, 1, NULL, 12.23, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(618, 'TORNILLOS PARKER 4', '4 X 3/4', 'P0652', NULL, NULL, NULL, 1, NULL, 17.95, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(619, 'TORNILLOS PARKER 4', '4 X  1', 'P0653', NULL, NULL, NULL, 1, NULL, 22.33, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(620, 'TORNILLOS PARKER 6', '6 X 1/4', 'P0654', NULL, NULL, NULL, 1, NULL, 13.01, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(621, 'TORNILLOS PARKER 6', '6 X 3/8', 'P0655', NULL, NULL, NULL, 1, NULL, 16.52, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(622, 'TORNILLOS PARKER 6', '6 X 1/2', 'P0656', NULL, NULL, NULL, 1, NULL, 16.16, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(623, 'TORNILLOS PARKER 6', '6 X 3/4', 'P0657', NULL, NULL, NULL, 1, NULL, 21.18, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(624, 'TORNILLOS PARKER 6', '6 X 1 ', 'P0658', NULL, NULL, NULL, 1, NULL, 26.69, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(625, 'TORNILLOS PARKER 6', '6 X 1 1/2', 'P0659', NULL, NULL, NULL, 1, NULL, 39.49, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(626, 'TORNILLOS PARKER 7', '7 X 1/2', 'P0660', NULL, NULL, NULL, 1, NULL, 20.73, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(627, 'TORNILLOS PARKER 7', '7 X 1', 'P0661', NULL, NULL, NULL, 1, NULL, 31.51, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(628, 'TORNILLOS PARKER 7', '7 X 1 1/4', 'P0662', NULL, NULL, NULL, 1, NULL, 37.83, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(629, 'TORNILLOS PARKER 7', '7 X 1 1/2', 'P0663', NULL, NULL, NULL, 1, NULL, 46.50, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(630, 'TORNILLOS PARKER 7', '7 X 3/4', 'P0664', NULL, NULL, NULL, 1, NULL, 25.81, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(631, 'TORNILLOS PARKER 8', '8 X 1/2', 'P0665', NULL, NULL, NULL, 1, NULL, 23.21, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(632, 'TORNILLOS PARKER 8', '8 X 3/4', 'P0666', NULL, NULL, NULL, 1, NULL, 29.10, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(633, 'TORNILLOS PARKER 8', '8 X 1', 'P0667', NULL, NULL, NULL, 1, NULL, 35.40, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(634, 'TORNILLOS PARKER 8', '8 X 1 1/2', 'P0668', NULL, NULL, NULL, 1, NULL, 53.62, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(635, 'TORNILLOS PARKER 8', '8 X 2 ', 'P0669', NULL, NULL, NULL, 1, NULL, 69.47, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(636, 'TUBO 18W LED ', '288 LED 120CR', 'P0670', NULL, NULL, NULL, 1, NULL, 3870.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(637, 'UNION DOBLE', '½\"', 'P0671', NULL, NULL, NULL, 1, NULL, 1223.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(638, 'UNION DOBLE', '¾\"', 'P0672', NULL, NULL, NULL, 1, NULL, 1575.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(639, 'UNION DOBLE', '1\"', 'P0673', NULL, NULL, NULL, 1, NULL, 3200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(640, 'UNION PARA CAÑO', '20MM', 'P0674', NULL, NULL, NULL, 1, NULL, 287.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(641, 'UNION PARA CAÑO', '22MM', 'P0675', NULL, NULL, NULL, 1, NULL, 390.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(642, 'VALVULA DE RETENCIÓN PVC', 'C/CANASTA 3/4', 'P0676', NULL, NULL, NULL, 1, NULL, 6000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(643, 'VALVULA ESFÉRICA PVC', '1\"', 'P0679', NULL, NULL, NULL, 1, NULL, 6000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(644, 'VALVULA EXCLUSA BRONCE', '1\"', 'P0680', NULL, NULL, NULL, 1, NULL, 19800.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(645, 'VALVULA RETENCIÓN BRONCE', '3/4', 'P0681', NULL, NULL, NULL, 1, NULL, 16500.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(646, 'VALVULA RETENCIÓN BRONCE', '1\"', 'P0682', NULL, NULL, NULL, 1, NULL, 25200.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(647, 'VENTILADOR DE TECHO', 'BENJAMIN- 4P', 'P0683', NULL, NULL, NULL, 1, NULL, 90550.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(648, 'VENTILADOR DE TECHO', 'CODINI- 4P', 'P0684', NULL, NULL, NULL, 1, NULL, 95870.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(649, 'VENTILADOR DE TECHO', 'EVEREST- 3P', 'P0685', NULL, NULL, NULL, 1, NULL, 85300.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(650, 'VENTILADOR DE TECHO', 'SELENE- 4P MADERA C/APLIQUE', 'P0686', NULL, NULL, NULL, 1, NULL, 106570.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(651, 'ZAPATILLA CON CABLE', '1.5 MT', 'P0687', NULL, NULL, NULL, 1, NULL, 20150.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(652, 'ZOCALOS PUERTA ALUMINIO', '60CM', 'P0688', NULL, NULL, NULL, 1, NULL, 2700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(653, 'ZOCALOS PUERTA ALUMINIO', '70CM', 'P0689', NULL, NULL, NULL, 1, NULL, 2700.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(654, 'ZOCALOS PUERTA ALUMINIO', '80CM', 'P0690', NULL, NULL, NULL, 1, NULL, 2860.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(655, 'ZOCALOS PUERTA ALUMINIO', '90CM', 'P0691', NULL, NULL, NULL, 1, NULL, 3240.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(656, 'ZOCALOS PUERTA ALUMINIO', '100CM', 'P0692', NULL, NULL, NULL, 1, NULL, 3560.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(657, 'w 40', '155 g', 'P0693', NULL, NULL, NULL, 1, NULL, 6750.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15'),
(658, 'Aceitodo', '90 g', 'P0694', NULL, NULL, NULL, 1, NULL, 5000.00, 0.00, 30.00, 0.000, 'unid', 0.000, NULL, NULL, 1, NULL, '2026-02-13 19:35:15', '2026-02-13 19:35:15');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `razon_social` varchar(200) DEFAULT NULL,
  `cuit` varchar(20) DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `codigo_postal` varchar(20) DEFAULT NULL,
  `contacto` varchar(100) DEFAULT NULL,
  `notas` text DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `permisos` text DEFAULT NULL COMMENT 'JSON con permisos del rol',
  `activo` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre`, `descripcion`, `permisos`, `activo`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'Administrador del sistema', '{\"all\": true}', 1, '2026-02-11 23:53:19', '2026-02-11 23:53:19'),
(2, 'vendedor', 'Vendedor - Acceso a ventas y productos', '{\"sales\": true, \"products\": true, \"customers\": true}', 1, '2026-02-11 23:53:19', '2026-02-11 23:53:19'),
(3, 'cajero', 'Cajero - Acceso a caja y reportes', '{\"cash\": true, \"reports\": true, \"sales\": true}', 1, '2026-02-11 23:53:19', '2026-02-11 23:53:19');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turnos_caja`
--

CREATE TABLE `turnos_caja` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `usuario_nombre` varchar(100) DEFAULT NULL,
  `monto_inicial` decimal(10,2) NOT NULL DEFAULT 0.00,
  `monto_final` decimal(10,2) DEFAULT NULL,
  `monto_esperado` decimal(10,2) DEFAULT NULL,
  `diferencia` decimal(10,2) DEFAULT NULL,
  `estado` enum('abierto','cerrado') DEFAULT 'abierto',
  `fecha_apertura` timestamp NOT NULL DEFAULT current_timestamp(),
  `fecha_cierre` timestamp NULL DEFAULT NULL,
  `notas_apertura` text DEFAULT NULL,
  `notas_cierre` text DEFAULT NULL,
  `cerrado_por` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `turnos_caja`
--

INSERT INTO `turnos_caja` (`id`, `user_id`, `usuario_id`, `usuario_nombre`, `monto_inicial`, `monto_final`, `monto_esperado`, `diferencia`, `estado`, `fecha_apertura`, `fecha_cierre`, `notas_apertura`, `notas_cierre`, `cerrado_por`) VALUES
(3, 1, 1, 'Administrador', 10.00, 11.00, 1275.75, -1264.75, 'cerrado', '2026-02-12 00:16:56', '2026-02-12 21:14:02', '', NULL, NULL),
(4, 1, 1, 'admin', 0.00, NULL, NULL, NULL, 'abierto', '2026-02-12 23:18:31', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidades_medida`
--

CREATE TABLE `unidades_medida` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `abreviatura` varchar(10) NOT NULL,
  `tipo` enum('unidad','longitud','peso','volumen','area','otro') DEFAULT 'unidad',
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `unidades_medida`
--

INSERT INTO `unidades_medida` (`id`, `nombre`, `abreviatura`, `tipo`, `activo`) VALUES
(1, 'Unidad', 'ud', 'unidad', 1),
(2, 'Metro', 'm', 'longitud', 1),
(3, 'Centímetro', 'cm', 'longitud', 1),
(4, 'Kilogramo', 'kg', 'peso', 1),
(5, 'Gramo', 'g', 'peso', 1),
(6, 'Litro', 'L', 'volumen', 1),
(7, 'Mililitro', 'ml', 'volumen', 1),
(8, 'Metro cuadrado', 'm²', 'area', 1),
(9, 'Caja', 'caja', 'unidad', 1),
(10, 'Paquete', 'paq', 'unidad', 1),
(11, 'Bolsa', 'bolsa', 'unidad', 1),
(12, 'Rollo', 'rollo', 'unidad', 1),
(13, 'Par', 'par', 'unidad', 1),
(14, 'Juego', 'juego', 'unidad', 1),
(15, 'Set', 'set', 'unidad', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `rol` enum('admin','vendedor','cajero') NOT NULL DEFAULT 'vendedor',
  `role_id` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `is_active` tinyint(1) DEFAULT 1,
  `last_login` timestamp NULL DEFAULT NULL,
  `failed_attempts` int(11) DEFAULT 0,
  `last_failed_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `username`, `password`, `nombre`, `email`, `rol`, `role_id`, `activo`, `is_active`, `last_login`, `failed_attempts`, `last_failed_login`, `created_at`, `updated_at`) VALUES
(1, 'admin', '$argon2id$v=19$m=65536,t=4,p=3$OVFDWTJZN1poQWVFSWUzdA$hop7fr/UVRC9kKkzw1zIWlaafOChzNrJQghG9vPiGik', 'Administrador', 'admin@ferreteria.com', 'admin', 1, 1, 1, '2026-02-13 18:50:52', 0, NULL, '2026-02-11 23:49:57', '2026-02-13 18:50:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `subtotal` decimal(10,2) DEFAULT 0.00,
  `descuento_porcentaje` decimal(5,2) DEFAULT 0.00,
  `descuento_monto` decimal(10,2) DEFAULT 0.00,
  `monto_pagado` decimal(10,2) DEFAULT 0.00,
  `cambio` decimal(10,2) DEFAULT 0.00,
  `metodo_pago` enum('efectivo','tarjeta_debito','tarjeta_credito','transferencia','cuenta_corriente','otro') DEFAULT 'efectivo',
  `metodo_pago_secundario` varchar(50) DEFAULT NULL,
  `monto_pago_secundario` decimal(10,2) DEFAULT 0.00,
  `estado` enum('completada','pendiente','cancelada') DEFAULT 'completada',
  `notas` text DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `usuario_id`, `cliente_id`, `total`, `subtotal`, `descuento_porcentaje`, `descuento_monto`, `monto_pagado`, `cambio`, `metodo_pago`, `metodo_pago_secundario`, `monto_pago_secundario`, `estado`, `notas`, `fecha`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, 225.75, 0.00, 0.00, 0.00, 225.75, 0.00, 'efectivo', NULL, 0.00, 'completada', NULL, '2026-02-12 00:26:17', '2026-02-12 00:26:17', '2026-02-12 00:26:17'),
(2, 1, NULL, 1040.00, 0.00, 0.00, 0.00, 1040.00, 0.00, 'efectivo', NULL, 0.00, 'completada', NULL, '2026-02-12 00:31:08', '2026-02-12 00:31:08', '2026-02-12 00:31:08'),
(3, 1, 1, 1040.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'cuenta_corriente', '', 0.00, 'completada', NULL, '2026-02-12 23:35:50', '2026-02-12 23:35:50', '2026-02-12 23:35:50'),
(4, 1, 1, 1040.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'cuenta_corriente', '', 0.00, 'completada', NULL, '2026-02-13 18:53:26', '2026-02-13 18:53:26', '2026-02-13 18:53:26'),
(5, 1, NULL, 520.00, 0.00, 0.00, 0.00, 520.00, 0.00, 'transferencia', 'Nombre: pepe - Tel: 3248324324', 0.00, 'completada', NULL, '2026-02-13 18:58:46', '2026-02-13 18:58:46', '2026-02-13 18:58:46');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas_pendientes`
--

CREATE TABLE `ventas_pendientes` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `cliente_id` int(11) DEFAULT NULL,
  `items` longtext NOT NULL,
  `subtotal` decimal(10,2) DEFAULT 0.00,
  `descuento` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) DEFAULT 0.00,
  `notas` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_detalles`
--

CREATE TABLE `venta_detalles` (
  `id` int(11) NOT NULL,
  `venta_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` decimal(10,3) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `precio_costo` decimal(10,2) DEFAULT 0.00,
  `descuento_porcentaje` decimal(5,2) DEFAULT 0.00,
  `descuento_monto` decimal(10,2) DEFAULT 0.00,
  `subtotal` decimal(10,2) NOT NULL,
  `subtotal_sin_descuento` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `venta_detalles`
--

INSERT INTO `venta_detalles` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio`, `precio_costo`, `descuento_porcentaje`, `descuento_monto`, `subtotal`, `subtotal_sin_descuento`) VALUES
(1, 1, 2, 1.500, 150.50, 0.00, 0.00, 0.00, 225.75, 0.00),
(2, 2, 1, 2.000, 520.00, 0.00, 0.00, 0.00, 1040.00, 0.00),
(3, 3, 1, 2.000, 520.00, 0.00, 0.00, 0.00, 1040.00, 0.00),
(4, 4, 1, 2.000, 520.00, 0.00, 0.00, 0.00, 1040.00, 0.00),
(5, 5, 1, 1.000, 520.00, 0.00, 0.00, 0.00, 520.00, 0.00);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nombre` (`nombre`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nombre` (`nombre`),
  ADD KEY `idx_documento` (`documento`);

--
-- Indices de la tabla `cuenta_corriente_movimientos`
--
ALTER TABLE `cuenta_corriente_movimientos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cliente` (`cliente_id`),
  ADD KEY `idx_fecha` (`fecha`),
  ADD KEY `fk_cc_usuario` (`usuario_id`);

--
-- Indices de la tabla `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_attempted_at` (`attempted_at`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nombre` (`nombre`);

--
-- Indices de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_turno` (`turno_id`),
  ADD KEY `idx_tipo` (`tipo`),
  ADD KEY `idx_venta` (`venta_id`),
  ADD KEY `idx_fecha` (`fecha`),
  ADD KEY `fk_movimiento_usuario` (`usuario_id`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nombre` (`nombre`),
  ADD KEY `idx_codigo_barra` (`codigo_barra`),
  ADD KEY `idx_categoria` (`categoria_id`),
  ADD KEY `idx_marca` (`marca_id`),
  ADD KEY `idx_proveedor` (`proveedor_id`),
  ADD KEY `idx_stock` (`stock`),
  ADD KEY `idx_deleted` (`deleted_at`),
  ADD KEY `fk_producto_unidad` (`unidad_medida_id`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nombre` (`nombre`),
  ADD KEY `idx_cuit` (`cuit`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `idx_nombre` (`nombre`);

--
-- Indices de la tabla `turnos_caja`
--
ALTER TABLE `turnos_caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_fecha_apertura` (`fecha_apertura`),
  ADD KEY `fk_turno_cerrado_por` (`cerrado_por`);

--
-- Indices de la tabla `unidades_medida`
--
ALTER TABLE `unidades_medida`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_nombre` (`nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_rol` (`rol`),
  ADD KEY `fk_usuario_role` (`role_id`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_usuario` (`usuario_id`),
  ADD KEY `idx_cliente` (`cliente_id`),
  ADD KEY `idx_fecha` (`fecha`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_metodo_pago` (`metodo_pago`);

--
-- Indices de la tabla `ventas_pendientes`
--
ALTER TABLE `ventas_pendientes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_usuario` (`usuario_id`),
  ADD KEY `idx_cliente` (`cliente_id`);

--
-- Indices de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_venta` (`venta_id`),
  ADD KEY `idx_producto` (`producto_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `cuenta_corriente_movimientos`
--
ALTER TABLE `cuenta_corriente_movimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=659;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `turnos_caja`
--
ALTER TABLE `turnos_caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `unidades_medida`
--
ALTER TABLE `unidades_medida`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ventas_pendientes`
--
ALTER TABLE `ventas_pendientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cuenta_corriente_movimientos`
--
ALTER TABLE `cuenta_corriente_movimientos`
  ADD CONSTRAINT `fk_cc_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cc_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  ADD CONSTRAINT `fk_movimiento_turno` FOREIGN KEY (`turno_id`) REFERENCES `turnos_caja` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_movimiento_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `fk_movimiento_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_producto_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_producto_marca` FOREIGN KEY (`marca_id`) REFERENCES `marcas` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_producto_proveedor` FOREIGN KEY (`proveedor_id`) REFERENCES `proveedores` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_producto_unidad` FOREIGN KEY (`unidad_medida_id`) REFERENCES `unidades_medida` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `turnos_caja`
--
ALTER TABLE `turnos_caja`
  ADD CONSTRAINT `fk_turno_cerrado_por` FOREIGN KEY (`cerrado_por`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_turno_usuario` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `fk_venta_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_venta_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `ventas_pendientes`
--
ALTER TABLE `ventas_pendientes`
  ADD CONSTRAINT `fk_pendiente_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_pendiente_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  ADD CONSTRAINT `fk_detalle_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`),
  ADD CONSTRAINT `fk_detalle_venta` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
