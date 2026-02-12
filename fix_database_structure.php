<?php
/**
 * Script para verificar y corregir problemas de estructura de base de datos
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "═══════════════════════════════════════════════════════════════\n";
echo "DIAGNÓSTICO Y CORRECCIÓN DE ESTRUCTURA DE BASE DE DATOS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "✓ Conexión establecida\n\n";

    // Verificar estructura de turnos_caja
    echo "VERIFICANDO TABLA: turnos_caja\n";
    echo str_repeat("-", 60) . "\n";

    $stmt = $pdo->query("DESCRIBE turnos_caja");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $hasUserId = false;
    $hasUsuarioId = false;
    $hasUsuarioNombre = false;

    foreach ($columns as $col) {
        echo "  - " . $col['Field'] . " (" . $col['Type'] . ")\n";
        if ($col['Field'] === 'user_id')
            $hasUserId = true;
        if ($col['Field'] === 'usuario_id')
            $hasUsuarioId = true;
        if ($col['Field'] === 'usuario_nombre')
            $hasUsuarioNombre = true;
    }

    echo "\n";
    echo "Columnas necesarias:\n";
    echo "  user_id: " . ($hasUserId ? "✓ EXISTE" : "✗ FALTA") . "\n";
    echo "  usuario_id: " . ($hasUsuarioId ? "✓ EXISTE" : "⚠ OPCIONAL") . "\n";
    echo "  usuario_nombre: " . ($hasUsuarioNombre ? "✓ EXISTE" : "⚠ OPCIONAL") . "\n\n";

    // Agregar columnas faltantes si es necesario
    if (!$hasUsuarioId) {
        echo "Agregando columna usuario_id...\n";
        $pdo->exec("ALTER TABLE turnos_caja ADD COLUMN usuario_id INT(11) DEFAULT NULL AFTER user_id");
        echo "✓ Columna usuario_id agregada\n\n";
    }

    if (!$hasUsuarioNombre) {
        echo "Agregando columna usuario_nombre...\n";
        $pdo->exec("ALTER TABLE turnos_caja ADD COLUMN usuario_nombre VARCHAR(100) DEFAULT NULL AFTER usuario_id");
        echo "✓ Columna usuario_nombre agregada\n\n";
    }

    // Verificar estructura de movimientos_caja
    echo "VERIFICANDO TABLA: movimientos_caja\n";
    echo str_repeat("-", 60) . "\n";

    $stmt = $pdo->query("DESCRIBE movimientos_caja");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($columns as $col) {
        echo "  - " . $col['Field'] . " (" . $col['Type'] . ")\n";
    }

    echo "\n";

    // Verificar tabla usuarios
    echo "VERIFICANDO TABLA: usuarios\n";
    echo str_repeat("-", 60) . "\n";

    $stmt = $pdo->query("SELECT id, username, nombre, rol FROM usuarios LIMIT 5");
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

    foreach ($users as $user) {
        echo "  ID: {$user['id']} | User: {$user['username']} | Nombre: {$user['nombre']} | Rol: {$user['rol']}\n";
    }

    echo "\n═══════════════════════════════════════════════════════════════\n";
    echo "DIAGNÓSTICO COMPLETADO\n";
    echo "═══════════════════════════════════════════════════════════════\n";

} catch (PDOException $e) {
    echo "✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>