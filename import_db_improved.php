<?php
/**
 * Script mejorado para importar base de datos
 * Maneja transacciones correctamente
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);
set_time_limit(300);

echo "╔═══════════════════════════════════════════════════════════════╗\n";
echo "║         IMPORTACIÓN MEJORADA DE BASE DE DATOS                 ║\n";
echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

try {
    $pdo = new PDO("mysql:host=localhost;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/5] Conexión establecida\n";

    // Eliminar y recrear base de datos
    echo "[2/5] Recreando base de datos...\n";
    $pdo->exec("DROP DATABASE IF EXISTS ferreteria_db");
    $pdo->exec("CREATE DATABASE ferreteria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    $pdo->exec("USE ferreteria_db");
    echo "      ✓ Base de datos lista\n\n";

    // Leer archivo SQL
    echo "[3/5] Leyendo archivo SQL...\n";
    $sqlFile = __DIR__ . '/ferreteria_db.sql';
    $sql = file_get_contents($sqlFile);

    // Remover comentarios y limpiar
    $sql = preg_replace('/^--.*$/m', '', $sql);
    $sql = preg_replace('/\/\*.*?\*\//s', '', $sql);

    echo "      ✓ Archivo leído\n\n";

    // Ejecutar el SQL completo
    echo "[4/5] Ejecutando SQL...\n";

    // Desactivar autocommit para manejar transacciones manualmente
    $pdo->setAttribute(PDO::ATTR_AUTOCOMMIT, 0);
    $pdo->beginTransaction();

    try {
        // Ejecutar todo el SQL de una vez
        $pdo->exec($sql);
        $pdo->commit();
        echo "      ✓ SQL ejecutado exitosamente\n\n";
    } catch (PDOException $e) {
        $pdo->rollBack();
        throw $e;
    }

    // Reactivar autocommit
    $pdo->setAttribute(PDO::ATTR_AUTOCOMMIT, 1);

    // Verificar tablas
    echo "[5/5] Verificando tablas creadas...\n";
    $stmt = $pdo->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

    if (empty($tables)) {
        throw new Exception("No se crearon tablas. Revisa el archivo SQL.");
    }

    echo "\n═══════════════════════════════════════════════════════════════\n";
    echo "TABLAS CREADAS: " . count($tables) . "\n";
    echo "═══════════════════════════════════════════════════════════════\n\n";

    foreach ($tables as $table) {
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM `$table`");
        $count = $stmt->fetch(PDO::FETCH_ASSOC)['count'];
        echo sprintf("  %-30s %s registros\n", "✓ $table", $count);
    }

    echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║              ✓ IMPORTACIÓN EXITOSA                            ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n";

} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    echo "Archivo: " . $e->getFile() . "\n";
    echo "Línea: " . $e->getLine() . "\n";
    exit(1);
}
?>