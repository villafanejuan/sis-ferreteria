<?php
/**
 * Script simple para importar usando MySQL command line
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "═══════════════════════════════════════════════════════════════\n";
echo "IMPORTACIÓN DE BASE DE DATOS VÍA MYSQL CLI\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

$mysqlPath = 'D:\\Archivos de programas\\XAMPPg\\mysql\\bin\\mysql.exe';
$sqlFile = __DIR__ . '\\ferreteria_db.sql';

// Verificar que el archivo existe
if (!file_exists($sqlFile)) {
    die("✗ ERROR: Archivo SQL no encontrado: $sqlFile\n");
}

echo "[1/3] Archivo SQL encontrado\n";
echo "      Ruta: $sqlFile\n\n";

// Paso 1: Eliminar base de datos anterior
echo "[2/3] Eliminando base de datos anterior...\n";
$cmd = "\"$mysqlPath\" -u root -e \"DROP DATABASE IF EXISTS ferreteria_db\"";
exec($cmd, $output, $returnCode);

if ($returnCode === 0) {
    echo "      ✓ Base de datos eliminada\n\n";
} else {
    echo "      ⚠ No se pudo eliminar (puede no existir)\n\n";
}

// Paso 2: Importar archivo SQL
echo "[3/3] Importando archivo SQL...\n";
$cmd = "\"$mysqlPath\" -u root < \"$sqlFile\" 2>&1";
exec($cmd, $output, $returnCode);

if ($returnCode === 0) {
    echo "      ✓ Archivo importado exitosamente\n\n";

    // Verificar tablas
    echo "═══════════════════════════════════════════════════════════════\n";
    echo "VERIFICANDO TABLAS CREADAS\n";
    echo "═══════════════════════════════════════════════════════════════\n\n";

    try {
        $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        $stmt = $pdo->query("SHOW TABLES");
        $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

        if (empty($tables)) {
            echo "⚠ ADVERTENCIA: No se encontraron tablas\n";
        } else {
            echo "Tablas encontradas: " . count($tables) . "\n\n";
            foreach ($tables as $table) {
                $stmt = $pdo->query("SELECT COUNT(*) as count FROM `$table`");
                $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
                echo sprintf("  %-30s %d registros\n", "✓ $table", $count);
            }
        }

        echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
        echo "║                  ✓ IMPORTACIÓN EXITOSA                        ║\n";
        echo "╚═══════════════════════════════════════════════════════════════╝\n";

    } catch (PDOException $e) {
        echo "✗ Error al verificar: " . $e->getMessage() . "\n";
    }

} else {
    echo "      ✗ Error al importar\n";
    echo "      Salida:\n";
    foreach ($output as $line) {
        echo "        $line\n";
    }
    exit(1);
}
?>