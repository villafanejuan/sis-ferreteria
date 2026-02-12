<?php
/**
 * Script para importar la base de datos ferreteria_db.sql
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);
set_time_limit(300); // 5 minutos

echo "╔═══════════════════════════════════════════════════════════════╗\n";
echo "║           IMPORTACIÓN DE BASE DE DATOS FERRETERIA             ║\n";
echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

try {
    // Conectar sin seleccionar base de datos
    $pdo = new PDO("mysql:host=localhost;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/4] Conexión establecida\n";

    // Eliminar base de datos si existe
    echo "[2/4] Eliminando base de datos anterior (si existe)...\n";
    $pdo->exec("DROP DATABASE IF EXISTS ferreteria_db");
    echo "      ✓ Base de datos eliminada\n\n";

    // Crear base de datos
    echo "[3/4] Creando base de datos ferreteria_db...\n";
    $pdo->exec("CREATE DATABASE ferreteria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    echo "      ✓ Base de datos creada\n\n";

    // Seleccionar base de datos
    $pdo->exec("USE ferreteria_db");

    // Leer archivo SQL
    echo "[4/4] Importando estructura y datos...\n";
    $sqlFile = __DIR__ . '/ferreteria_db.sql';

    if (!file_exists($sqlFile)) {
        throw new Exception("Archivo SQL no encontrado: $sqlFile");
    }

    $sql = file_get_contents($sqlFile);

    // Dividir en statements individuales
    $statements = array_filter(
        array_map('trim', explode(';', $sql)),
        function ($stmt) {
            return !empty($stmt) &&
                !preg_match('/^--/', $stmt) &&
                !preg_match('/^\/\*/', $stmt);
        }
    );

    $successCount = 0;
    $errorCount = 0;

    foreach ($statements as $statement) {
        if (empty(trim($statement)))
            continue;

        try {
            $pdo->exec($statement);
            $successCount++;
        } catch (PDOException $e) {
            // Ignorar algunos errores comunes que no son críticos
            if (
                strpos($e->getMessage(), 'already exists') === false &&
                strpos($e->getMessage(), 'Duplicate') === false
            ) {
                echo "      ⚠ Error en statement: " . substr($statement, 0, 50) . "...\n";
                echo "        " . $e->getMessage() . "\n";
                $errorCount++;
            }
        }
    }

    echo "\n      ✓ Statements ejecutados: $successCount\n";
    if ($errorCount > 0) {
        echo "      ⚠ Errores encontrados: $errorCount\n";
    }

    // Verificar tablas creadas
    echo "\n═══════════════════════════════════════════════════════════════\n";
    echo "VERIFICACIÓN DE TABLAS\n";
    echo "═══════════════════════════════════════════════════════════════\n\n";

    $stmt = $pdo->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

    echo "Tablas creadas (" . count($tables) . "):\n";
    foreach ($tables as $table) {
        // Contar registros
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM `$table`");
        $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
        echo "  ✓ $table ($count registros)\n";
    }

    echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║                  IMPORTACIÓN COMPLETADA                       ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n";

} catch (PDOException $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>