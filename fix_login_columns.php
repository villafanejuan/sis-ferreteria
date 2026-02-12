<?php
/**
 * Agregar columna failed_attempts a usuarios
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "═══════════════════════════════════════════════════════════════\n";
echo "AGREGANDO COLUMNA FAILED_ATTEMPTS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/2] Verificando si la columna existe...\n";

    $stmt = $pdo->query("DESCRIBE usuarios");
    $columns = $stmt->fetchAll(PDO::FETCH_COLUMN);

    if (in_array('failed_attempts', $columns)) {
        echo "      ⚠ La columna failed_attempts ya existe\n\n";
    } else {
        echo "      ✗ Columna failed_attempts no existe\n\n";

        echo "[2/2] Agregando columna failed_attempts...\n";
        $pdo->exec("ALTER TABLE usuarios ADD COLUMN failed_attempts INT(11) DEFAULT 0 AFTER is_active");
        $pdo->exec("ALTER TABLE usuarios ADD COLUMN last_failed_login TIMESTAMP NULL DEFAULT NULL AFTER failed_attempts");
        echo "      ✓ Columnas agregadas\n\n";
    }

    echo "╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║              ✓ ACTUALIZACIÓN COMPLETADA                      ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

    echo "Ahora puedes iniciar sesión con:\n";
    echo "  Usuario: admin\n";
    echo "  Contraseña: password\n\n";

} catch (PDOException $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>