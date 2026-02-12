<?php
/**
 * Script completo para crear la base de datos ferreteria_db
 * Crea todas las tablas, vistas, triggers y datos iniciales
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);
set_time_limit(300);

echo "╔═══════════════════════════════════════════════════════════════╗\n";
echo "║     CREACIÓN COMPLETA DE BASE DE DATOS FERRETERÍA             ║\n";
echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

try {
    // Conectar a MySQL
    $pdo = new PDO("mysql:host=localhost;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/10] Conexión establecida\n";

    // Eliminar y crear base de datos
    echo "[2/10] Recreando base de datos...\n";
    $pdo->exec("DROP DATABASE IF EXISTS ferreteria_db");
    $pdo->exec("CREATE DATABASE ferreteria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    $pdo->exec("USE ferreteria_db");
    echo "        ✓ Base de datos creada\n\n";

    // Crear tabla usuarios
    echo "[3/10] Creando tabla usuarios...\n";
    $pdo->exec("
        CREATE TABLE usuarios (
            id INT(11) NOT NULL AUTO_INCREMENT,
            username VARCHAR(50) NOT NULL UNIQUE,
            password VARCHAR(255) NOT NULL,
            nombre VARCHAR(100) NOT NULL,
            email VARCHAR(100) DEFAULT NULL,
            rol ENUM('admin','vendedor','cajero') NOT NULL DEFAULT 'vendedor',
            activo TINYINT(1) DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_username (username),
            KEY idx_rol (rol)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Insertar usuario admin
    $pdo->exec("
        INSERT INTO usuarios (username, password, nombre, email, rol, activo) VALUES
        ('admin', '\$2y\$10\$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrador', 'admin@ferreteria.com', 'admin', 1)
    ");
    echo "        ✓ Tabla usuarios creada (1 registro)\n\n";

    // Crear tabla login_attempts
    echo "[4/10] Creando tabla login_attempts...\n";
    $pdo->exec("
        CREATE TABLE login_attempts (
            id INT(11) NOT NULL AUTO_INCREMENT,
            username VARCHAR(50) NOT NULL,
            ip_address VARCHAR(45) NOT NULL,
            user_agent TEXT DEFAULT NULL,
            success TINYINT(1) DEFAULT 0,
            attempted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_username (username),
            KEY idx_attempted_at (attempted_at)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");
    echo "        ✓ Tabla login_attempts creada\n\n";

    // Crear tabla categorias
    echo "[5/10] Creando tabla categorias...\n";
    $pdo->exec("
        CREATE TABLE categorias (
            id INT(11) NOT NULL AUTO_INCREMENT,
            nombre VARCHAR(100) NOT NULL,
            descripcion TEXT DEFAULT NULL,
            icono VARCHAR(50) DEFAULT 'fa-box',
            activo TINYINT(1) DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_nombre (nombre)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Insertar categorías
    $pdo->exec("
        INSERT INTO categorias (nombre, descripcion, icono) VALUES
        ('Herramientas Manuales', 'Martillos, destornilladores, llaves, alicates', 'fa-wrench'),
        ('Herramientas Eléctricas', 'Taladros, amoladoras, sierras eléctricas', 'fa-power-off'),
        ('Electricidad', 'Cables, enchufes, llaves térmicas, cajas', 'fa-bolt'),
        ('Plomería', 'Caños, conexiones, grifería, accesorios', 'fa-tint'),
        ('Pinturería', 'Pinturas, pinceles, rodillos, diluyentes', 'fa-paint-brush'),
        ('Construcción', 'Cemento, arena, ladrillos, bloques', 'fa-building'),
        ('Tornillería y Bulonería', 'Tornillos, tuercas, arandelas, bulones', 'fa-cog'),
        ('Ferretería General', 'Candados, bisagras, cerraduras, herrajes', 'fa-key'),
        ('Jardín y Exterior', 'Mangueras, aspersores, herramientas de jardín', 'fa-leaf'),
        ('Seguridad', 'Candados, alarmas, cámaras, elementos de protección', 'fa-shield-alt'),
        ('Adhesivos y Selladores', 'Pegamentos, siliconas, cintas, selladores', 'fa-tape'),
        ('Maderas y Tableros', 'Madera, MDF, melamina, terciados', 'fa-tree'),
        ('Abrasivos', 'Lijas, discos de corte, piedras de amolar', 'fa-circle'),
        ('Iluminación', 'Lámparas, tubos, focos, LED', 'fa-lightbulb'),
        ('Climatización', 'Ventiladores, estufas, aires acondicionados', 'fa-fan')
    ");
    echo "        ✓ Tabla categorias creada (15 registros)\n\n";

    // Crear tabla marcas
    echo "[6/10] Creando tabla marcas...\n";
    $pdo->exec("
        CREATE TABLE marcas (
            id INT(11) NOT NULL AUTO_INCREMENT,
            nombre VARCHAR(100) NOT NULL,
            pais_origen VARCHAR(100) DEFAULT NULL,
            descripcion TEXT DEFAULT NULL,
            activo TINYINT(1) DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_nombre (nombre)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Insertar marcas
    $pdo->exec("
        INSERT INTO marcas (nombre, pais_origen, descripcion) VALUES
        ('Bahco', 'Suecia', 'Herramientas manuales profesionales'),
        ('Stanley', 'Estados Unidos', 'Herramientas y accesorios'),
        ('Bosch', 'Alemania', 'Herramientas eléctricas y accesorios'),
        ('DeWalt', 'Estados Unidos', 'Herramientas eléctricas profesionales'),
        ('Makita', 'Japón', 'Herramientas eléctricas de alta calidad'),
        ('Black & Decker', 'Estados Unidos', 'Herramientas eléctricas y manuales'),
        ('Tramontina', 'Brasil', 'Herramientas y utensilios'),
        ('Ferrum', 'Argentina', 'Grifería y sanitarios'),
        ('FV', 'Argentina', 'Grifería y accesorios'),
        ('Schneider Electric', 'Francia', 'Material eléctrico'),
        ('Philips', 'Países Bajos', 'Iluminación y electrónica'),
        ('Tigre', 'Brasil', 'Caños y conexiones de PVC'),
        ('Awaduct', 'Argentina', 'Caños y accesorios eléctricos'),
        ('Alba', 'Argentina', 'Pinturas y revestimientos'),
        ('Sinteplast', 'Argentina', 'Pinturas y esmaltes'),
        ('Poxipol', 'Argentina', 'Adhesivos y pegamentos'),
        ('Genérica', 'Varios', 'Productos sin marca específica')
    ");
    echo "        ✓ Tabla marcas creada (17 registros)\n\n";

    // Continúa en el siguiente bloque...
    echo "[7/10] Creando tablas de productos y clientes...\n";

    // Tabla unidades_medida
    $pdo->exec("
        CREATE TABLE unidades_medida (
            id INT(11) NOT NULL AUTO_INCREMENT,
            nombre VARCHAR(50) NOT NULL,
            abreviatura VARCHAR(10) NOT NULL,
            tipo ENUM('unidad','longitud','peso','volumen','area','otro') DEFAULT 'unidad',
            activo TINYINT(1) DEFAULT 1,
            PRIMARY KEY (id),
            KEY idx_nombre (nombre)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    $pdo->exec("
        INSERT INTO unidades_medida (nombre, abreviatura, tipo) VALUES
        ('Unidad', 'ud', 'unidad'),
        ('Metro', 'm', 'longitud'),
        ('Centímetro', 'cm', 'longitud'),
        ('Kilogramo', 'kg', 'peso'),
        ('Gramo', 'g', 'peso'),
        ('Litro', 'L', 'volumen'),
        ('Mililitro', 'ml', 'volumen'),
        ('Metro cuadrado', 'm²', 'area'),
        ('Caja', 'caja', 'unidad'),
        ('Paquete', 'paq', 'unidad'),
        ('Bolsa', 'bolsa', 'unidad'),
        ('Rollo', 'rollo', 'unidad'),
        ('Par', 'par', 'unidad'),
        ('Juego', 'juego', 'unidad'),
        ('Set', 'set', 'unidad')
    ");

    // Tabla proveedores
    $pdo->exec("
        CREATE TABLE proveedores (
            id INT(11) NOT NULL AUTO_INCREMENT,
            nombre VARCHAR(150) NOT NULL,
            razon_social VARCHAR(200) DEFAULT NULL,
            cuit VARCHAR(20) DEFAULT NULL,
            telefono VARCHAR(50) DEFAULT NULL,
            email VARCHAR(100) DEFAULT NULL,
            direccion TEXT DEFAULT NULL,
            ciudad VARCHAR(100) DEFAULT NULL,
            provincia VARCHAR(100) DEFAULT NULL,
            codigo_postal VARCHAR(20) DEFAULT NULL,
            contacto VARCHAR(100) DEFAULT NULL,
            notas TEXT DEFAULT NULL,
            activo TINYINT(1) DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_nombre (nombre),
            KEY idx_cuit (cuit)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Tabla productos
    $pdo->exec("
        CREATE TABLE productos (
            id INT(11) NOT NULL AUTO_INCREMENT,
            nombre VARCHAR(200) NOT NULL,
            descripcion TEXT DEFAULT NULL,
            codigo_barra VARCHAR(50) DEFAULT NULL,
            modelo VARCHAR(100) DEFAULT NULL,
            categoria_id INT(11) DEFAULT NULL,
            marca_id INT(11) DEFAULT NULL,
            unidad_medida_id INT(11) DEFAULT 1,
            proveedor_id INT(11) DEFAULT NULL,
            precio DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            precio_costo DECIMAL(10,2) DEFAULT 0.00,
            margen_ganancia DECIMAL(5,2) DEFAULT 30.00,
            stock INT(11) NOT NULL DEFAULT 0,
            stock_minimo INT(11) DEFAULT 5,
            ubicacion_deposito VARCHAR(50) DEFAULT NULL,
            imagen VARCHAR(255) DEFAULT NULL,
            activo TINYINT(1) DEFAULT 1,
            deleted_at TIMESTAMP NULL DEFAULT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_nombre (nombre),
            KEY idx_codigo_barra (codigo_barra),
            KEY idx_categoria (categoria_id),
            KEY idx_marca (marca_id),
            KEY idx_proveedor (proveedor_id),
            KEY idx_stock (stock),
            KEY idx_deleted (deleted_at),
            CONSTRAINT fk_producto_categoria FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE SET NULL,
            CONSTRAINT fk_producto_marca FOREIGN KEY (marca_id) REFERENCES marcas (id) ON DELETE SET NULL,
            CONSTRAINT fk_producto_unidad FOREIGN KEY (unidad_medida_id) REFERENCES unidades_medida (id) ON DELETE SET NULL,
            CONSTRAINT fk_producto_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedores (id) ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Tabla clientes
    $pdo->exec("
        CREATE TABLE clientes (
            id INT(11) NOT NULL AUTO_INCREMENT,
            nombre VARCHAR(150) NOT NULL,
            documento VARCHAR(20) DEFAULT NULL,
            tipo_documento ENUM('DNI','CUIT','CUIL','Pasaporte') DEFAULT 'DNI',
            telefono VARCHAR(50) DEFAULT NULL,
            email VARCHAR(100) DEFAULT NULL,
            direccion TEXT DEFAULT NULL,
            ciudad VARCHAR(100) DEFAULT NULL,
            provincia VARCHAR(100) DEFAULT NULL,
            codigo_postal VARCHAR(20) DEFAULT NULL,
            saldo_cuenta_corriente DECIMAL(10,2) DEFAULT 0.00,
            limite_credito DECIMAL(10,2) DEFAULT 0.00,
            notas TEXT DEFAULT NULL,
            activo TINYINT(1) DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_nombre (nombre),
            KEY idx_documento (documento)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    echo "        ✓ Tablas de productos y clientes creadas\n\n";

    // Continúa en el siguiente mensaje...
    echo "[8/10] Creando tablas de ventas y POS...\n";

    // Tabla ventas
    $pdo->exec("
        CREATE TABLE ventas (
            id INT(11) NOT NULL AUTO_INCREMENT,
            usuario_id INT(11) NOT NULL,
            cliente_id INT(11) DEFAULT NULL,
            total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            subtotal DECIMAL(10,2) DEFAULT 0.00,
            descuento_porcentaje DECIMAL(5,2) DEFAULT 0.00,
            descuento_monto DECIMAL(10,2) DEFAULT 0.00,
            monto_pagado DECIMAL(10,2) DEFAULT 0.00,
            cambio DECIMAL(10,2) DEFAULT 0.00,
            metodo_pago ENUM('efectivo','tarjeta_debito','tarjeta_credito','transferencia','cuenta_corriente','otro') DEFAULT 'efectivo',
            metodo_pago_secundario VARCHAR(50) DEFAULT NULL,
            monto_pago_secundario DECIMAL(10,2) DEFAULT 0.00,
            estado ENUM('completada','pendiente','cancelada') DEFAULT 'completada',
            notas TEXT DEFAULT NULL,
            fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_usuario (usuario_id),
            KEY idx_cliente (cliente_id),
            KEY idx_fecha (fecha),
            KEY idx_estado (estado),
            KEY idx_metodo_pago (metodo_pago),
            CONSTRAINT fk_venta_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
            CONSTRAINT fk_venta_cliente FOREIGN KEY (cliente_id) REFERENCES clientes (id) ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Tabla venta_detalles
    $pdo->exec("
        CREATE TABLE venta_detalles (
            id INT(11) NOT NULL AUTO_INCREMENT,
            venta_id INT(11) NOT NULL,
            producto_id INT(11) NOT NULL,
            cantidad DECIMAL(10,2) NOT NULL DEFAULT 1.00,
            precio DECIMAL(10,2) NOT NULL,
            precio_costo DECIMAL(10,2) DEFAULT 0.00,
            descuento_porcentaje DECIMAL(5,2) DEFAULT 0.00,
            descuento_monto DECIMAL(10,2) DEFAULT 0.00,
            subtotal DECIMAL(10,2) NOT NULL,
            subtotal_sin_descuento DECIMAL(10,2) DEFAULT 0.00,
            PRIMARY KEY (id),
            KEY idx_venta (venta_id),
            KEY idx_producto (producto_id),
            CONSTRAINT fk_detalle_venta FOREIGN KEY (venta_id) REFERENCES ventas (id) ON DELETE CASCADE,
            CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_id) REFERENCES productos (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Tabla ventas_pendientes
    $pdo->exec("
        CREATE TABLE ventas_pendientes (
            id INT(11) NOT NULL AUTO_INCREMENT,
            usuario_id INT(11) NOT NULL,
            cliente_id INT(11) DEFAULT NULL,
            items LONGTEXT NOT NULL,
            subtotal DECIMAL(10,2) DEFAULT 0.00,
            descuento DECIMAL(10,2) DEFAULT 0.00,
            total DECIMAL(10,2) DEFAULT 0.00,
            notas TEXT DEFAULT NULL,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_usuario (usuario_id),
            KEY idx_cliente (cliente_id),
            CONSTRAINT fk_pendiente_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
            CONSTRAINT fk_pendiente_cliente FOREIGN KEY (cliente_id) REFERENCES clientes (id) ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    echo "        ✓ Tablas de ventas creadas\n\n";

    echo "[9/10] Creando tablas de control de caja...\n";

    // Tabla turnos_caja
    $pdo->exec("
        CREATE TABLE turnos_caja (
            id INT(11) NOT NULL AUTO_INCREMENT,
            user_id INT(11) NOT NULL,
            usuario_id INT(11) DEFAULT NULL,
            usuario_nombre VARCHAR(100) DEFAULT NULL,
            monto_inicial DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            monto_final DECIMAL(10,2) DEFAULT NULL,
            monto_esperado DECIMAL(10,2) DEFAULT NULL,
            diferencia DECIMAL(10,2) DEFAULT NULL,
            estado ENUM('abierto','cerrado') DEFAULT 'abierto',
            fecha_apertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            fecha_cierre TIMESTAMP NULL DEFAULT NULL,
            notas_apertura TEXT DEFAULT NULL,
            notas_cierre TEXT DEFAULT NULL,
            cerrado_por INT(11) DEFAULT NULL,
            PRIMARY KEY (id),
            KEY idx_user (user_id),
            KEY idx_estado (estado),
            KEY idx_fecha_apertura (fecha_apertura),
            CONSTRAINT fk_turno_usuario FOREIGN KEY (user_id) REFERENCES usuarios (id),
            CONSTRAINT fk_turno_cerrado_por FOREIGN KEY (cerrado_por) REFERENCES usuarios (id) ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    // Tabla movimientos_caja
    $pdo->exec("
        CREATE TABLE movimientos_caja (
            id INT(11) NOT NULL AUTO_INCREMENT,
            turno_id INT(11) NOT NULL,
            tipo ENUM('venta','ingreso','egreso','apertura','cierre','inicial') NOT NULL,
            monto DECIMAL(10,2) NOT NULL,
            descripcion TEXT DEFAULT NULL,
            venta_id INT(11) DEFAULT NULL,
            usuario_id INT(11) NOT NULL,
            fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_turno (turno_id),
            KEY idx_tipo (tipo),
            KEY idx_venta (venta_id),
            KEY idx_fecha (fecha),
            CONSTRAINT fk_movimiento_turno FOREIGN KEY (turno_id) REFERENCES turnos_caja (id) ON DELETE CASCADE,
            CONSTRAINT fk_movimiento_venta FOREIGN KEY (venta_id) REFERENCES ventas (id) ON DELETE SET NULL,
            CONSTRAINT fk_movimiento_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    echo "        ✓ Tablas de control de caja creadas\n\n";

    echo "[10/10] Verificando estructura final...\n";

    // Verificar tablas creadas
    $stmt = $pdo->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

    echo "\n═══════════════════════════════════════════════════════════════\n";
    echo "RESUMEN FINAL\n";
    echo "═══════════════════════════════════════════════════════════════\n\n";
    echo "Total de tablas creadas: " . count($tables) . "\n\n";

    foreach ($tables as $table) {
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM `$table`");
        $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
        echo sprintf("  %-30s %d registros\n", "✓ $table", $count);
    }

    echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║          ✓ BASE DE DATOS CREADA EXITOSAMENTE                 ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

    echo "Credenciales de acceso:\n";
    echo "  Usuario: admin\n";
    echo "  Contraseña: password\n\n";

} catch (PDOException $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    echo "Archivo: " . $e->getFile() . "\n";
    echo "Línea: " . $e->getLine() . "\n";
    exit(1);
}
?>