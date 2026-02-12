<?php
/**
 * Script para agregar tabla roles faltante
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "═══════════════════════════════════════════════════════════════\n";
echo "AGREGANDO TABLA ROLES\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/2] Creando tabla roles...\n";

    // Verificar si ya existe
    $stmt = $pdo->query("SHOW TABLES LIKE 'roles'");
    if ($stmt->rowCount() > 0) {
        echo "      ⚠ Tabla roles ya existe, eliminando...\n";
        $pdo->exec("DROP TABLE IF EXISTS roles");
    }

    // Crear tabla roles
    $pdo->exec("
        CREATE TABLE roles (
            id INT(11) NOT NULL AUTO_INCREMENT,
            nombre VARCHAR(50) NOT NULL UNIQUE,
            descripcion TEXT DEFAULT NULL,
            permisos TEXT DEFAULT NULL COMMENT 'JSON con permisos del rol',
            activo TINYINT(1) DEFAULT 1,
            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY idx_nombre (nombre)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    ");

    echo "      ✓ Tabla roles creada\n\n";

    echo "[2/2] Insertando roles predefinidos...\n";

    // Insertar roles básicos
    $pdo->exec("
        INSERT INTO roles (nombre, descripcion, permisos) VALUES
        ('admin', 'Administrador del sistema', '{\"all\": true}'),
        ('vendedor', 'Vendedor - Acceso a ventas y productos', '{\"sales\": true, \"products\": true, \"customers\": true}'),
        ('cajero', 'Cajero - Acceso a caja y reportes', '{\"cash\": true, \"reports\": true, \"sales\": true}')
    ");

    echo "      ✓ 3 roles insertados\n\n";

    // Verificar
    $stmt = $pdo->query("SELECT * FROM roles");
    $roles = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "Roles creados:\n";
    foreach ($roles as $role) {
        echo "  - {$role['nombre']}: {$role['descripcion']}\n";
    }

    echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║              ✓ TABLA ROLES AGREGADA                          ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n";

} catch (PDOException $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>