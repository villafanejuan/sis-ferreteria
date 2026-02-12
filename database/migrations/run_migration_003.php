<?php
/**
 * Script para ejecutar la migración a sistema de ferretería
 * Este script maneja las modificaciones de columnas de forma segura
 */

require_once __DIR__ . '/../../config/app.php';

try {
    // Conectar a la base de datos
    $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
    $pdo = new PDO($dsn, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "===========================================\n";
    echo "MIGRACIÓN A SISTEMA DE FERRETERÍA\n";
    echo "===========================================\n\n";

    // PARTE 1: Ejecutar SQL de creación de tablas
    echo "PARTE 1: Creando nuevas tablas...\n";
    $sqlFile = __DIR__ . '/003_adapt_to_ferreteria.sql';

    if (file_exists($sqlFile)) {
        $sql = file_get_contents($sqlFile);
        $statements = array_filter(
            array_map('trim', explode(';', $sql)),
            function ($stmt) {
                $stmt = preg_replace('/--.*$/m', '', $stmt);
                $stmt = trim($stmt);
                return !empty($stmt);
            }
        );

        foreach ($statements as $statement) {
            try {
                $pdo->exec($statement);
                if (stripos($statement, 'CREATE TABLE') !== false) {
                    preg_match('/CREATE TABLE.*?`(\w+)`/i', $statement, $matches);
                    if (isset($matches[1])) {
                        echo "✓ Tabla creada: {$matches[1]}\n";
                    }
                } elseif (stripos($statement, 'INSERT INTO') !== false) {
                    preg_match('/INSERT INTO.*?`(\w+)`/i', $statement, $matches);
                    if (isset($matches[1])) {
                        echo "✓ Datos insertados en: {$matches[1]}\n";
                    }
                }
            } catch (PDOException $e) {
                if (
                    strpos($e->getMessage(), 'already exists') === false &&
                    strpos($e->getMessage(), 'Duplicate') === false
                ) {
                    echo "⚠ Advertencia: " . $e->getMessage() . "\n";
                }
            }
        }
    }

    echo "\nPARTE 2: Modificando tablas existentes...\n";

    // Función helper para agregar columna si no existe
    function addColumnIfNotExists($pdo, $table, $column, $definition)
    {
        try {
            $stmt = $pdo->query("SHOW COLUMNS FROM `$table` LIKE '$column'");
            if ($stmt->rowCount() == 0) {
                $pdo->exec("ALTER TABLE `$table` ADD COLUMN `$column` $definition");
                echo "✓ Columna agregada: $table.$column\n";
                return true;
            }
            return false;
        } catch (PDOException $e) {
            echo "⚠ Error agregando $table.$column: " . $e->getMessage() . "\n";
            return false;
        }
    }

    // Modificar tabla productos
    echo "\nModificando tabla productos...\n";
    addColumnIfNotExists($pdo, 'productos', 'marca_id', 'int(11) DEFAULT NULL AFTER categoria_id');
    addColumnIfNotExists($pdo, 'productos', 'modelo', 'varchar(100) DEFAULT NULL AFTER marca_id');
    addColumnIfNotExists($pdo, 'productos', 'unidad_medida_id', 'int(11) DEFAULT 1 AFTER modelo');
    addColumnIfNotExists($pdo, 'productos', 'ubicacion_deposito_id', 'int(11) DEFAULT NULL AFTER unidad_medida_id');
    addColumnIfNotExists($pdo, 'productos', 'stock_minimo', 'int(11) DEFAULT 0 AFTER stock');
    addColumnIfNotExists($pdo, 'productos', 'stock_maximo', 'int(11) DEFAULT NULL AFTER stock_minimo');
    addColumnIfNotExists($pdo, 'productos', 'precio_costo', 'decimal(10,2) DEFAULT 0.00 AFTER precio');
    addColumnIfNotExists($pdo, 'productos', 'margen_ganancia', 'decimal(5,2) DEFAULT 0.00 COMMENT \'Porcentaje de ganancia\' AFTER precio_costo');
    addColumnIfNotExists($pdo, 'productos', 'proveedor_id', 'int(11) DEFAULT NULL AFTER margen_ganancia');
    addColumnIfNotExists($pdo, 'productos', 'codigo_proveedor', 'varchar(50) DEFAULT NULL AFTER proveedor_id');
    addColumnIfNotExists($pdo, 'productos', 'es_fraccionable', 'tinyint(1) DEFAULT 0 COMMENT \'Si se puede vender en fracciones\' AFTER codigo_proveedor');
    addColumnIfNotExists($pdo, 'productos', 'peso', 'decimal(10,3) DEFAULT NULL COMMENT \'Peso en kg\' AFTER es_fraccionable');
    addColumnIfNotExists($pdo, 'productos', 'dimensiones', 'varchar(50) DEFAULT NULL COMMENT \'LxAxH en cm\' AFTER peso');
    addColumnIfNotExists($pdo, 'productos', 'garantia_meses', 'int(11) DEFAULT NULL AFTER dimensiones');
    addColumnIfNotExists($pdo, 'productos', 'updated_at', 'timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() AFTER created_at');

    // Modificar tabla clientes
    echo "\nModificando tabla clientes...\n";
    addColumnIfNotExists($pdo, 'clientes', 'tipo_cliente', 'enum(\'minorista\',\'mayorista\',\'constructor\',\'empresa\') DEFAULT \'minorista\' AFTER nombre');
    addColumnIfNotExists($pdo, 'clientes', 'cuit_cuil', 'varchar(13) DEFAULT NULL AFTER tipo_cliente');
    addColumnIfNotExists($pdo, 'clientes', 'razon_social', 'varchar(200) DEFAULT NULL AFTER cuit_cuil');
    addColumnIfNotExists($pdo, 'clientes', 'direccion', 'varchar(255) DEFAULT NULL AFTER email');
    addColumnIfNotExists($pdo, 'clientes', 'localidad', 'varchar(100) DEFAULT NULL AFTER direccion');
    addColumnIfNotExists($pdo, 'clientes', 'provincia', 'varchar(100) DEFAULT NULL AFTER localidad');
    addColumnIfNotExists($pdo, 'clientes', 'codigo_postal', 'varchar(10) DEFAULT NULL AFTER provincia');
    addColumnIfNotExists($pdo, 'clientes', 'limite_credito', 'decimal(10,2) DEFAULT 0.00 AFTER puntos');
    addColumnIfNotExists($pdo, 'clientes', 'saldo_cuenta', 'decimal(10,2) DEFAULT 0.00 AFTER limite_credito');
    addColumnIfNotExists($pdo, 'clientes', 'descuento_porcentaje', 'decimal(5,2) DEFAULT 0.00 AFTER saldo_cuenta');
    addColumnIfNotExists($pdo, 'clientes', 'activo', 'tinyint(1) DEFAULT 1 AFTER descuento_porcentaje');
    addColumnIfNotExists($pdo, 'clientes', 'notas', 'text DEFAULT NULL AFTER activo');
    addColumnIfNotExists($pdo, 'clientes', 'created_at', 'timestamp NOT NULL DEFAULT current_timestamp() AFTER notas');
    addColumnIfNotExists($pdo, 'clientes', 'updated_at', 'timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() AFTER created_at');

    // Modificar tabla venta_detalles
    echo "\nModificando tabla venta_detalles...\n";
    addColumnIfNotExists($pdo, 'venta_detalles', 'cantidad_fraccion', 'decimal(10,3) DEFAULT NULL COMMENT \'Para productos fraccionables\' AFTER cantidad');
    addColumnIfNotExists($pdo, 'venta_detalles', 'descuento_porcentaje', 'decimal(5,2) DEFAULT 0.00 AFTER precio');
    addColumnIfNotExists($pdo, 'venta_detalles', 'descuento_monto', 'decimal(10,2) DEFAULT 0.00 AFTER descuento_porcentaje');

    // Modificar tabla ventas
    echo "\nModificando tabla ventas...\n";
    addColumnIfNotExists($pdo, 'ventas', 'descuento_total', 'decimal(10,2) DEFAULT 0.00 AFTER total');
    addColumnIfNotExists($pdo, 'ventas', 'subtotal', 'decimal(10,2) DEFAULT 0.00 AFTER descuento_total');
    addColumnIfNotExists($pdo, 'ventas', 'metodo_pago', 'enum(\'efectivo\',\'transferencia\',\'tarjeta_debito\',\'tarjeta_credito\',\'cuenta_corriente\',\'mixto\') DEFAULT \'efectivo\' AFTER cambio');
    addColumnIfNotExists($pdo, 'ventas', 'notas', 'text DEFAULT NULL AFTER metodo_pago');

    // Actualizar productos existentes
    echo "\nActualizando productos existentes...\n";
    $pdo->exec("UPDATE `productos` SET `unidad_medida_id` = 1 WHERE `unidad_medida_id` IS NULL OR `unidad_medida_id` = 0");
    echo "✓ Unidad de medida asignada a productos\n";

    $genericaBrandId = $pdo->query("SELECT id FROM marcas WHERE nombre = 'Genérica' LIMIT 1")->fetchColumn();
    if ($genericaBrandId) {
        $pdo->exec("UPDATE `productos` SET `marca_id` = $genericaBrandId WHERE `marca_id` IS NULL");
        echo "✓ Marca genérica asignada a productos\n";
    }

    echo "\n===========================================\n";
    echo "RESUMEN DE MIGRACIÓN\n";
    echo "===========================================\n";

    // Verificar tablas creadas
    $tables = ['marcas', 'unidades_medida', 'proveedores', 'ubicaciones_deposito', 'categorias'];
    foreach ($tables as $table) {
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM $table");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        echo "  - $table: {$result['count']} registros\n";
    }

    echo "\n✓ Migración completada exitosamente!\n\n";

} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n\n";
    exit(1);
}
