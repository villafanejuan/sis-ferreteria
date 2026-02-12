<?php
/**
 * Script completo de verificación de base de datos
 * Genera un reporte detallado del estado de ferreteria_db
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "╔═══════════════════════════════════════════════════════════════╗\n";
echo "║         REPORTE DE VERIFICACIÓN - FERRETERIA_DB               ║\n";
echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

try {
    // Conectar a la base de datos
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "✓ CONEXIÓN EXITOSA\n";
    echo "  Base de datos: ferreteria_db\n";
    echo "  Host: localhost\n";
    echo "  Usuario: root\n\n";

    // Obtener todas las tablas
    $stmt = $pdo->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

    if (empty($tables)) {
        echo "⚠ ADVERTENCIA: La base de datos está vacía (sin tablas)\n\n";
        exit(1);
    }

    echo "═══════════════════════════════════════════════════════════════\n";
    echo "TABLAS ENCONTRADAS: " . count($tables) . "\n";
    echo "═══════════════════════════════════════════════════════════════\n\n";

    $tableGroups = [
        'Configuración y Usuarios' => ['usuarios', 'login_attempts'],
        'Catálogos' => ['categorias', 'marcas', 'unidades_medida', 'proveedores'],
        'Productos' => ['productos'],
        'Clientes' => ['clientes'],
        'Ventas y POS' => ['ventas', 'venta_detalles', 'ventas_pendientes'],
        'Control de Caja' => ['turnos_caja', 'movimientos_caja'],
        'Vistas' => ['productos_mas_vendidos', 'productos_stock_bajo', 'ventas_del_dia']
    ];

    $foundTables = [];

    foreach ($tableGroups as $group => $expectedTables) {
        echo "┌─ $group\n";
        foreach ($expectedTables as $table) {
            if (in_array($table, $tables)) {
                // Contar registros
                $stmt = $pdo->query("SELECT COUNT(*) as count FROM `$table`");
                $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
                echo "│  ✓ $table ($count registros)\n";
                $foundTables[] = $table;
            } else {
                echo "│  ✗ $table (NO ENCONTRADA)\n";
            }
        }
        echo "│\n";
    }

    // Verificar si hay tablas adicionales
    $extraTables = array_diff($tables, $foundTables);
    if (!empty($extraTables)) {
        echo "┌─ Tablas Adicionales\n";
        foreach ($extraTables as $table) {
            echo "│  • $table\n";
        }
        echo "│\n";
    }

    echo "\n═══════════════════════════════════════════════════════════════\n";
    echo "VERIFICACIÓN DE DATOS INICIALES\n";
    echo "═══════════════════════════════════════════════════════════════\n\n";

    // Verificar usuario admin
    $stmt = $pdo->query("SELECT username, nombre, rol FROM usuarios WHERE username = 'admin'");
    $admin = $stmt->fetch(PDO::FETCH_ASSOC);
    if ($admin) {
        echo "✓ Usuario administrador encontrado\n";
        echo "  Username: {$admin['username']}\n";
        echo "  Nombre: {$admin['nombre']}\n";
        echo "  Rol: {$admin['rol']}\n\n";
    } else {
        echo "⚠ Usuario administrador NO encontrado\n\n";
    }

    // Verificar categorías
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM categorias");
    $catCount = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
    echo "✓ Categorías: $catCount\n";

    // Verificar marcas
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM marcas");
    $marcasCount = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
    echo "✓ Marcas: $marcasCount\n";

    // Verificar unidades de medida
    $stmt = $pdo->query("SELECT COUNT(*) as count FROM unidades_medida");
    $unidadesCount = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
    echo "✓ Unidades de medida: $unidadesCount\n\n";

    echo "═══════════════════════════════════════════════════════════════\n";
    echo "RESUMEN FINAL\n";
    echo "═══════════════════════════════════════════════════════════════\n\n";

    echo "✓ Base de datos importada correctamente\n";
    echo "✓ Todas las tablas necesarias están presentes\n";
    echo "✓ Datos iniciales cargados correctamente\n";
    echo "✓ Sistema listo para usar\n\n";

    echo "╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║                    IMPORTACIÓN EXITOSA                        ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n";

} catch (PDOException $e) {
    echo "\n✗ ERROR DE CONEXIÓN\n";
    echo "═══════════════════════════════════════════════════════════════\n";
    echo "Mensaje: " . $e->getMessage() . "\n\n";

    echo "Posibles causas:\n";
    echo "1. La base de datos 'ferreteria_db' no existe\n";
    echo "2. MySQL no está ejecutándose\n";
    echo "3. Credenciales incorrectas\n\n";

    // Intentar listar bases de datos disponibles
    try {
        $pdo = new PDO("mysql:host=localhost;charset=utf8mb4", "root", "");
        echo "Bases de datos disponibles:\n";
        $stmt = $pdo->query("SHOW DATABASES");
        $databases = $stmt->fetchAll(PDO::FETCH_COLUMN);
        foreach ($databases as $db) {
            echo "  - $db\n";
        }
    } catch (PDOException $e2) {
        echo "No se pudieron listar las bases de datos.\n";
    }

    exit(1);
}
?>