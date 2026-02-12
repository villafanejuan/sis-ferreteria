-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-02-2026 a las 01:39:18
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
(1, 'Herramientas Manuales', 'Martillos, destornilladores, llaves, alicates', 'fa-wrench', 1, '2026-02-11 23:49:58'),
(2, 'Herramientas Eléctricas', 'Taladros, amoladoras, sierras eléctricas', 'fa-power-off', 1, '2026-02-11 23:49:58'),
(3, 'Electricidad', 'Cables, enchufes, llaves térmicas, cajas', 'fa-bolt', 1, '2026-02-11 23:49:58'),
(4, 'Plomería', 'Caños, conexiones, grifería, accesorios', 'fa-tint', 1, '2026-02-11 23:49:58'),
(5, 'Pinturería', 'Pinturas, pinceles, rodillos, diluyentes', 'fa-paint-brush', 1, '2026-02-11 23:49:58'),
(6, 'Construcción', 'Cemento, arena, ladrillos, bloques', 'fa-building', 1, '2026-02-11 23:49:58'),
(7, 'Tornillería y Bulonería', 'Tornillos, tuercas, arandelas, bulones', 'fa-cog', 1, '2026-02-11 23:49:58'),
(8, 'Ferretería General', 'Candados, bisagras, cerraduras, herrajes', 'fa-key', 1, '2026-02-11 23:49:58'),
(9, 'Jardín y Exterior', 'Mangueras, aspersores, herramientas de jardín', 'fa-leaf', 1, '2026-02-11 23:49:58'),
(10, 'Seguridad', 'Candados, alarmas, cámaras, elementos de protección', 'fa-shield-alt', 1, '2026-02-11 23:49:58'),
(11, 'Adhesivos y Selladores', 'Pegamentos, siliconas, cintas, selladores', 'fa-tape', 1, '2026-02-11 23:49:58'),
(12, 'Maderas y Tableros', 'Madera, MDF, melamina, terciados', 'fa-tree', 1, '2026-02-11 23:49:58'),
(13, 'Abrasivos', 'Lijas, discos de corte, piedras de amolar', 'fa-circle', 1, '2026-02-11 23:49:58'),
(14, 'Iluminación', 'Lámparas, tubos, focos, LED', 'fa-lightbulb', 1, '2026-02-11 23:49:58'),
(15, 'Climatización', 'Ventiladores, estufas, aires acondicionados', 'fa-fan', 1, '2026-02-11 23:49:58');

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
(13, 'admin', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', 1, '2026-02-12 00:16:41');

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
(1, 'Bahco', 'Suecia', 'Herramientas manuales profesionales', 1, '2026-02-11 23:49:58'),
(2, 'Stanley', 'Estados Unidos', 'Herramientas y accesorios', 1, '2026-02-11 23:49:58'),
(3, 'Bosch', 'Alemania', 'Herramientas eléctricas y accesorios', 1, '2026-02-11 23:49:58'),
(4, 'DeWalt', 'Estados Unidos', 'Herramientas eléctricas profesionales', 1, '2026-02-11 23:49:58'),
(5, 'Makita', 'Japón', 'Herramientas eléctricas de alta calidad', 1, '2026-02-11 23:49:58'),
(6, 'Black & Decker', 'Estados Unidos', 'Herramientas eléctricas y manuales', 1, '2026-02-11 23:49:58'),
(7, 'Tramontina', 'Brasil', 'Herramientas y utensilios', 1, '2026-02-11 23:49:58'),
(8, 'Ferrum', 'Argentina', 'Grifería y sanitarios', 1, '2026-02-11 23:49:58'),
(9, 'FV', 'Argentina', 'Grifería y accesorios', 1, '2026-02-11 23:49:58'),
(10, 'Schneider Electric', 'Francia', 'Material eléctrico', 1, '2026-02-11 23:49:58'),
(11, 'Philips', 'Países Bajos', 'Iluminación y electrónica', 1, '2026-02-11 23:49:58'),
(12, 'Tigre', 'Brasil', 'Caños y conexiones de PVC', 1, '2026-02-11 23:49:58'),
(13, 'Awaduct', 'Argentina', 'Caños y accesorios eléctricos', 1, '2026-02-11 23:49:58'),
(14, 'Alba', 'Argentina', 'Pinturas y revestimientos', 1, '2026-02-11 23:49:58'),
(15, 'Sinteplast', 'Argentina', 'Pinturas y esmaltes', 1, '2026-02-11 23:49:58'),
(16, 'Poxipol', 'Argentina', 'Adhesivos y pegamentos', 1, '2026-02-11 23:49:58'),
(17, 'Genérica', 'Varios', 'Productos sin marca específica', 1, '2026-02-11 23:49:58');

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
(2, 3, 'venta', 1040.00, 'Venta #2', 2, 1, '2026-02-12 00:31:08', '2026-02-12 00:31:08');

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
(1, 'pedazo de chapa', '', '123123123', '2sd3das', 4, 12, 2, NULL, 520.00, 400.00, 30.00, 8.000, 'unid', 5.000, NULL, NULL, 1, NULL, '2026-02-12 00:18:09', '2026-02-12 00:31:08'),
(2, 'Cable 2.5mm', NULL, 'TEST-1770855977', NULL, NULL, NULL, 1, NULL, 150.50, 0.00, 30.00, 98.500, 'mts', 0.000, NULL, NULL, 1, NULL, '2026-02-12 00:26:17', '2026-02-12 00:26:17');

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
(3, 1, 1, 'Administrador', 10.00, NULL, NULL, NULL, 'abierto', '2026-02-12 00:16:56', NULL, '', NULL, NULL);

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
(1, 'admin', '$argon2id$v=19$m=65536,t=4,p=3$OTRiMTdvcUN2SlJSdWJVQg$cT5XezjkaR348JI11Vd8jxqgWBU91fpczk82zvlaQT4', 'Administrador', 'admin@ferreteria.com', 'admin', 1, 1, 1, '2026-02-12 00:16:41', 0, NULL, '2026-02-11 23:49:57', '2026-02-12 00:16:41');

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
(2, 1, NULL, 1040.00, 0.00, 0.00, 0.00, 1040.00, 0.00, 'efectivo', NULL, 0.00, 'completada', NULL, '2026-02-12 00:31:08', '2026-02-12 00:31:08', '2026-02-12 00:31:08');

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
(2, 2, 1, 2.000, 520.00, 0.00, 0.00, 0.00, 1040.00, 0.00);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `movimientos_caja`
--
ALTER TABLE `movimientos_caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ventas_pendientes`
--
ALTER TABLE `ventas_pendientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `venta_detalles`
--
ALTER TABLE `venta_detalles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

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
