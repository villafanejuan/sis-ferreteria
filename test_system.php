<?php
/**
 * Test completo del sistema - Simula una sesión real
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "╔═══════════════════════════════════════════════════════════════╗\n";
echo "║              TEST COMPLETO DEL SISTEMA                        ║\n";
echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

// Iniciar sesión
session_start();

// Simular login del usuario admin
require_once __DIR__ . '/app/bootstrap.php';

try {
    // Obtener usuario admin
    $stmt = $pdo->prepare("SELECT * FROM usuarios WHERE username = ?");
    $stmt->execute(['admin']);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user) {
        throw new Exception("Usuario admin no encontrado");
    }

    // Establecer sesión
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['username'] = $user['username'];
    $_SESSION['nombre'] = $user['nombre'];
    $_SESSION['role'] = $user['rol'];
    $_SESSION['rol'] = $user['rol'];
    $_SESSION['logged_in'] = true;

    echo "[1/6] Sesión establecida correctamente\n";
    echo "        User ID: {$user['id']}\n";
    echo "        Username: {$user['username']}\n";
    echo "        Rol: {$user['rol']}\n\n";

    // Test 1: Dashboard
    echo "[2/6] Probando dashboard.php...\n";
    ob_start();
    try {
        include __DIR__ . '/public/dashboard.php';
        ob_end_clean();
        echo "        ✓ Dashboard carga sin errores\n\n";
    } catch (Exception $e) {
        ob_end_clean();
        echo "        ✗ Error: " . $e->getMessage() . "\n\n";
    }

    // Test 2: Sales
    echo "[3/6] Probando sales.php...\n";
    ob_start();
    try {
        include __DIR__ . '/public/sales.php';
        ob_end_clean();
        echo "        ✓ Sales carga sin errores\n\n";
    } catch (Exception $e) {
        ob_end_clean();
        echo "        ✗ Error: " . $e->getMessage() . "\n\n";
    }

    // Test 3: Cash
    echo "[4/6] Probando cash.php...\n";
    ob_start();
    try {
        include __DIR__ . '/public/cash.php';
        ob_end_clean();
        echo "        ✓ Cash carga sin errores\n\n";
    } catch (Exception $e) {
        ob_end_clean();
        echo "        ✗ Error: " . $e->getMessage() . "\n\n";
    }

    // Test 4: Reports
    echo "[5/6] Probando reports.php...\n";
    ob_start();
    try {
        include __DIR__ . '/public/reports.php';
        ob_end_clean();
        echo "        ✓ Reports carga sin errores\n\n";
    } catch (Exception $e) {
        ob_end_clean();
        echo "        ✗ Error: " . $e->getMessage() . "\n\n";
    }

    // Test 5: Users
    echo "[6/6] Probando users.php...\n";
    ob_start();
    try {
        include __DIR__ . '/public/users.php';
        ob_end_clean();
        echo "        ✓ Users carga sin errores\n\n";
    } catch (Exception $e) {
        ob_end_clean();
        echo "        ✗ Error: " . $e->getMessage() . "\n\n";
    }

    echo "╔═══════════════════════════════════════════════════════════════╗\n";
    echo "║                  TEST COMPLETADO                              ║\n";
    echo "╚═══════════════════════════════════════════════════════════════╝\n\n";

    echo "El sistema está listo para usar en:\n";
    echo "  http://localhost/sis-ferreteria/\n\n";
    echo "Credenciales:\n";
    echo "  Usuario: admin\n";
    echo "  Contraseña: password\n\n";

} catch (Exception $e) {
    echo "✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>