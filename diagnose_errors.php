<?php
/**
 * Script de diagnóstico de errores del sistema
 * Verifica cada página y reporta errores específicos
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "╔═══════════════════════════════════════════════════════════════╗\n";
echo "║              DIAGNÓSTICO DE ERRORES DEL SISTEMA               ║\n";
echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

// Páginas a verificar
$pages = [
    'dashboard' => 'public/dashboard.php',
    'ventas' => 'public/sales.php',
    'caja' => 'public/cash.php',
    'reportes' => 'public/reports.php',
    'usuarios' => 'public/users.php'
];

$baseDir = __DIR__;

echo "Directorio base: $baseDir\n\n";
echo "═══════════════════════════════════════════════════════════════\n";
echo "VERIFICACIÓN DE ARCHIVOS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

foreach ($pages as $name => $path) {
    $fullPath = $baseDir . '/' . $path;
    echo "[$name]\n";
    echo "  Ruta: $path\n";

    if (file_exists($fullPath)) {
        echo "  ✓ Archivo existe\n";
        echo "  Tamaño: " . filesize($fullPath) . " bytes\n";
    } else {
        echo "  ✗ ARCHIVO NO ENCONTRADO\n";
    }
    echo "\n";
}

echo "═══════════════════════════════════════════════════════════════\n";
echo "VERIFICACIÓN DE CONEXIÓN A BASE DE DATOS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    require_once $baseDir . '/app/bootstrap.php';
    echo "✓ Bootstrap cargado correctamente\n";

    // Verificar conexión PDO
    if (isset($pdo)) {
        echo "✓ Conexión PDO establecida\n";

        // Probar consulta simple
        $stmt = $pdo->query("SELECT DATABASE() as db");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        echo "✓ Base de datos activa: " . $result['db'] . "\n\n";

        // Verificar tablas críticas
        echo "Verificando tablas críticas:\n";
        $criticalTables = ['usuarios', 'ventas', 'productos', 'turnos_caja', 'clientes'];

        foreach ($criticalTables as $table) {
            try {
                $stmt = $pdo->query("SELECT COUNT(*) as count FROM `$table`");
                $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
                echo "  ✓ $table ($count registros)\n";
            } catch (PDOException $e) {
                echo "  ✗ $table - ERROR: " . $e->getMessage() . "\n";
            }
        }

    } else {
        echo "✗ Variable \$pdo no está definida\n";
    }

} catch (Exception $e) {
    echo "✗ ERROR al cargar bootstrap:\n";
    echo "  " . $e->getMessage() . "\n";
    echo "  Archivo: " . $e->getFile() . "\n";
    echo "  Línea: " . $e->getLine() . "\n";
}

echo "\n═══════════════════════════════════════════════════════════════\n";
echo "SIMULACIÓN DE CARGA DE PÁGINAS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

// Simular sesión
if (!isset($_SESSION)) {
    session_start();
}
$_SESSION['user_id'] = 1;
$_SESSION['username'] = 'admin';
$_SESSION['rol'] = 'admin';

foreach ($pages as $name => $path) {
    $fullPath = $baseDir . '/' . $path;

    if (!file_exists($fullPath)) {
        continue;
    }

    echo "Probando: $name\n";

    ob_start();
    try {
        include $fullPath;
        $output = ob_get_clean();
        echo "  ✓ Página cargada sin errores fatales\n";
    } catch (Exception $e) {
        ob_end_clean();
        echo "  ✗ ERROR:\n";
        echo "    Mensaje: " . $e->getMessage() . "\n";
        echo "    Archivo: " . $e->getFile() . "\n";
        echo "    Línea: " . $e->getLine() . "\n";
    } catch (Error $e) {
        ob_end_clean();
        echo "  ✗ ERROR FATAL:\n";
        echo "    Mensaje: " . $e->getMessage() . "\n";
        echo "    Archivo: " . $e->getFile() . "\n";
        echo "    Línea: " . $e->getLine() . "\n";
    }
    echo "\n";
}

echo "═══════════════════════════════════════════════════════════════\n";
echo "DIAGNÓSTICO COMPLETADO\n";
echo "═══════════════════════════════════════════════════════════════\n";
?>