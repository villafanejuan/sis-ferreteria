<?php
/**
 * Script para actualizar tabla usuarios con columnas faltantes
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "═══════════════════════════════════════════════════════════════\n";
echo "ACTUALIZANDO TABLA USUARIOS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/3] Verificando estructura actual...\n";

    $stmt = $pdo->query("DESCRIBE usuarios");
    $columns = $stmt->fetchAll(PDO::FETCH_COLUMN);

    $hasRoleId = in_array('role_id', $columns);
    $hasIsActive = in_array('is_active', $columns);

    echo "      role_id: " . ($hasRoleId ? "✓ existe" : "✗ falta") . "\n";
    echo "      is_active: " . ($hasIsActive ? "✓ existe" : "✗ falta") . "\n\n";

    echo "[2/3] Agregando columnas faltantes...\n";

    // Agregar role_id si no existe
    if (!$hasRoleId) {
        echo "      Agregando role_id...\n";
        $pdo->exec("ALTER TABLE usuarios ADD COLUMN role_id INT(11) DEFAULT NULL AFTER rol");
        $pdo->exec("ALTER TABLE usuarios ADD CONSTRAINT fk_usuario_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE SET NULL");
        echo "      ✓ role_id agregado\n";
    }

    // Agregar is_active si no existe
    if (!$hasIsActive) {
        echo "      Agregando is_active...\n";
        $pdo->exec("ALTER TABLE usuarios ADD COLUMN is_active TINYINT(1) DEFAULT 1 AFTER activo");
        echo "      ✓ is_active agregado\n";
    }

    echo "\n[3/3] Sincronizando datos...\n";

    // Sincronizar role_id basado en rol
    echo "      Sincronizando role_id con rol...\n";
    $pdo->exec("UPDATE usuarios SET role_id = 1 WHERE rol = 'admin' AND role_id IS NULL");
    $pdo->exec("UPDATE usuarios SET role_id = 2 WHERE rol = 'vendedor' AND role_id IS NULL");
    $pdo->exec("UPDATE usuarios SET role_id = 3 WHERE rol = 'cajero' AND role_id IS NULL");

    // Sincronizar is_active con activo
    echo "      Sincronizando is_active con activo...\n";
    $pdo->exec("UPDATE usuarios SET is_active = activo WHERE is_active IS NULL");

    echo "      ✓ Datos sincronizados\n\n";

    // Verificar usuario admin
    $stmt = $pdo->query("SELECT id, username, nombre, rol, role_id, activo, is_active FROM usuarios WHERE username = 'admin'");
    $admin = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($admin) {
        echo "Usuario admin:\n";
        echo "  ID: {$admin['id']}\n";
        echo "  Username: {$admin['username']}\n";
        echo "  Nombre: {$admin['nombre']}\n";
        echo "  Rol (antiguo): {$admin['rol']}\n";
        echo "  Role ID (nuevo): {$admin['role_id']}\n";
        echo "  Activo (antiguo): {$admin['activo']}\n";
        echo "  Is Active (nuevo): {$admin['is_active']}\n";
    }

    echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║          ✓ TABLA USUARIOS ACTUALIZADA                        ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n";

} catch (PDOException $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>