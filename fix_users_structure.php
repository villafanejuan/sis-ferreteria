<?php
/**
 * Script para agregar columna last_login
 */

require_once __DIR__ . '/app/bootstrap.php';

echo "═══════════════════════════════════════════════════════════════\n";
echo "AGREGANDO COLUMNA LAST_LOGIN\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $db = Database::getInstance();
    $pdo = $db->getConnection();

    // Verificar si la columna ya existe
    $stmt = $pdo->query("SHOW COLUMNS FROM usuarios LIKE 'last_login'");
    $col = $stmt->fetch();

    if ($col) {
        echo "✓ La columna 'last_login' ya existe.\n";
    } else {
        echo "[1/2] Agregando columna 'last_login'...\n";
        $pdo->exec("ALTER TABLE usuarios ADD COLUMN last_login TIMESTAMP NULL DEFAULT NULL AFTER is_active");
        echo "      ✓ Columna agregada.\n";
    }

    // Verificar failed_attempts también
    $stmt = $pdo->query("SHOW COLUMNS FROM usuarios LIKE 'failed_attempts'");
    $col = $stmt->fetch();

    if ($col) {
        echo "✓ La columna 'failed_attempts' ya existe.\n";
    } else {
        echo "[2/2] Agregando columna 'failed_attempts'...\n";
        $pdo->exec("ALTER TABLE usuarios ADD COLUMN failed_attempts INT DEFAULT 0 AFTER last_login");
        echo "      ✓ Columna agregada.\n";
    }

    echo "\n✓ Estructura de usuarios actualizada correctamente.\n";

} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>