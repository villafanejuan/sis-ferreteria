<?php
/**
 * Diagnóstico de problemas de sesión y usuario
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

session_start();

echo "═══════════════════════════════════════════════════════════════\n";
echo "DIAGNÓSTICO DE SESIÓN Y USUARIOS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/3] Verificando sesión actual...\n";

    if (isset($_SESSION['user_id'])) {
        echo "      ✓ Sesión activa\n";
        echo "      User ID: {$_SESSION['user_id']}\n";
        echo "      Username: " . ($_SESSION['username'] ?? 'N/A') . "\n";
        echo "      Nombre: " . ($_SESSION['nombre'] ?? 'N/A') . "\n";
        echo "      Role: " . ($_SESSION['role'] ?? 'N/A') . "\n\n";

        // Verificar si el user_id existe en la tabla usuarios
        echo "[2/3] Verificando usuario en base de datos...\n";
        $stmt = $pdo->prepare("SELECT * FROM usuarios WHERE id = ?");
        $stmt->execute([$_SESSION['user_id']]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user) {
            echo "      ✓ Usuario encontrado en BD\n";
            echo "      ID: {$user['id']}\n";
            echo "      Username: {$user['username']}\n";
            echo "      Nombre: {$user['nombre']}\n";
            echo "      Rol (campo rol): {$user['rol']}\n";
            echo "      Role ID: " . ($user['role_id'] ?? 'NULL') . "\n";
            echo "      Activo: " . ($user['activo'] ? 'Sí' : 'No') . "\n";
            echo "      Is Active: " . ($user['is_active'] ? 'Sí' : 'No') . "\n\n";
        } else {
            echo "      ✗ PROBLEMA: Usuario con ID {$_SESSION['user_id']} NO existe en la BD\n";
            echo "      Esto causa el error de foreign key constraint\n\n";

            // Listar usuarios disponibles
            echo "      Usuarios disponibles en la BD:\n";
            $stmt = $pdo->query("SELECT id, username, nombre FROM usuarios");
            $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
            foreach ($users as $u) {
                echo "        - ID: {$u['id']}, Username: {$u['username']}, Nombre: {$u['nombre']}\n";
            }
            echo "\n";
        }
    } else {
        echo "      ✗ No hay sesión activa\n\n";
    }

    echo "[3/3] Verificando estructura de tablas...\n";

    // Verificar foreign keys de turnos_caja
    $stmt = $pdo->query("
        SELECT 
            CONSTRAINT_NAME,
            COLUMN_NAME,
            REFERENCED_TABLE_NAME,
            REFERENCED_COLUMN_NAME
        FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = 'ferreteria_db'
        AND TABLE_NAME = 'turnos_caja'
        AND REFERENCED_TABLE_NAME IS NOT NULL
    ");
    $fks = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo "      Foreign keys en turnos_caja:\n";
    foreach ($fks as $fk) {
        echo "        - {$fk['CONSTRAINT_NAME']}: {$fk['COLUMN_NAME']} -> {$fk['REFERENCED_TABLE_NAME']}.{$fk['REFERENCED_COLUMN_NAME']}\n";
    }

    echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║                  DIAGNÓSTICO COMPLETADO                       ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n";

} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>