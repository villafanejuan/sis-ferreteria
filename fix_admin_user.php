<?php
/**
 * Script para verificar y corregir el usuario admin
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "═══════════════════════════════════════════════════════════════\n";
echo "VERIFICACIÓN Y CORRECCIÓN DE USUARIO ADMIN\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "[1/4] Verificando usuarios existentes...\n";
    $stmt = $pdo->query("SELECT id, username, nombre, rol, role_id, activo, is_active FROM usuarios");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($users)) {
        echo "      ✗ No hay usuarios en la base de datos\n\n";

        echo "[2/4] Creando usuario admin...\n";
        $password = password_hash('password', PASSWORD_BCRYPT);
        $pdo->exec("
            INSERT INTO usuarios (username, password, nombre, email, rol, role_id, activo, is_active, failed_attempts) 
            VALUES ('admin', '$password', 'Administrador', 'admin@ferreteria.com', 'admin', 1, 1, 1, 0)
        ");
        echo "      ✓ Usuario admin creado\n\n";
    } else {
        echo "      ✓ Usuarios encontrados: " . count($users) . "\n";
        foreach ($users as $user) {
            echo "        - ID: {$user['id']}, Username: {$user['username']}, Rol: {$user['rol']}, Role ID: " . ($user['role_id'] ?? 'NULL') . "\n";
        }
        echo "\n";

        // Verificar si admin existe
        $stmt = $pdo->query("SELECT * FROM usuarios WHERE username = 'admin'");
        $admin = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$admin) {
            echo "[2/4] Usuario admin no existe, creando...\n";
            $password = password_hash('password', PASSWORD_BCRYPT);
            $pdo->exec("
                INSERT INTO usuarios (username, password, nombre, email, rol, role_id, activo, is_active, failed_attempts) 
                VALUES ('admin', '$password', 'Administrador', 'admin@ferreteria.com', 'admin', 1, 1, 1, 0)
            ");
            echo "      ✓ Usuario admin creado\n\n";
        } else {
            echo "[2/4] Usuario admin existe\n";
            echo "      ID: {$admin['id']}\n";
            echo "      Username: {$admin['username']}\n";
            echo "      Rol: {$admin['rol']}\n";
            echo "      Role ID: " . ($admin['role_id'] ?? 'NULL') . "\n\n";

            // Actualizar contraseña por si acaso
            echo "[3/4] Actualizando contraseña de admin...\n";
            $password = password_hash('password', PASSWORD_BCRYPT);
            $pdo->exec("UPDATE usuarios SET password = '$password' WHERE username = 'admin'");
            echo "      ✓ Contraseña actualizada\n\n";
        }
    }

    echo "[4/4] Verificación final...\n";
    $stmt = $pdo->query("SELECT id, username, nombre, rol, role_id FROM usuarios WHERE username = 'admin'");
    $admin = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($admin) {
        echo "      ✓ Usuario admin verificado:\n";
        echo "        ID: {$admin['id']}\n";
        echo "        Username: {$admin['username']}\n";
        echo "        Nombre: {$admin['nombre']}\n";
        echo "        Rol: {$admin['rol']}\n";
        echo "        Role ID: " . ($admin['role_id'] ?? 'NULL') . "\n";
    }

    echo "\n╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║              ✓ VERIFICACIÓN COMPLETADA                       ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

    echo "Ahora cierra sesión e inicia sesión nuevamente con:\n";
    echo "  Usuario: admin\n";
    echo "  Contraseña: password\n\n";

} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>