<?php
/**
 * Script para simular una venta completa y verificar lógica decimal
 */
require_once __DIR__ . '/app/bootstrap.php';

// Simular sesión
$_SESSION['user_id'] = 1; // Admin
$_SESSION['username'] = 'admin';
$_SESSION['csrf_token'] = 'test_token';

echo "═══════════════════════════════════════════════════════════════\n";
echo "PRUEBA DE FLUJO DE VENTA DECIMAL\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $db = Database::getInstance();
    $pdo = $db->getConnection();

    // 1. Crear producto de prueba con decimales
    $codigo = 'TEST-' . time();
    $pdo->prepare("INSERT INTO productos (codigo_barra, nombre, precio, stock, unidad_medida) VALUES (?, 'Cable 2.5mm', 150.50, 100.000, 'mts')")
        ->execute([$codigo]);
    $prodId = $pdo->lastInsertId();
    echo "[1] Producto creado (ID: $prodId, Stock: 100.000, Precio: 150.50)\n";

    // 2. Abrir caja si no existe
    $stmt = $pdo->prepare("SELECT id FROM turnos_caja WHERE user_id = ? AND estado = 'abierto'");
    $stmt->execute([1]);
    $turno = $stmt->fetch();

    if (!$turno) {
        $pdo->prepare("INSERT INTO turnos_caja (user_id, usuario_id, usuario_nombre, monto_inicial, estado, fecha_apertura) VALUES (1, 1, 'admin', 1000, 'abierto', NOW())")
            ->execute();
        $turnoId = $pdo->lastInsertId();
        echo "[2] Caja abierta (Turno ID: $turnoId)\n";
    } else {
        $turnoId = $turno['id'];
        echo "[2] Caja ya abierta (Turno ID: $turnoId)\n";
    }

    // 3. Simular POST 'add_to_cart'
    // Como no podemos hacer POST real aqui, simulamos la lógica interna de sales.php

    echo "[3] Agregando 1.5 mts al carrito...\n";
    $_POST['add_to_cart'] = 1;
    $_POST['producto_id'] = $prodId;
    $_POST['cantidad'] = 1.5;

    // Aquí invocamos la lógica... pero sales.php tiene HTML mezclado.
    // Mejor verificamos solo la lógica de base de datos simulando la venta final.

    $cantidadVenta = 1.5;
    $precioVenta = 150.50;
    $totalVenta = $cantidadVenta * $precioVenta;

    // Insertar venta manualmente para verificar constraints y triggers si los hubiera
    $pdo->beginTransaction();

    $stmt = $pdo->prepare("INSERT INTO ventas (usuario_id, total, monto_pagado, cambio, fecha) VALUES (?, ?, ?, ?, NOW())");
    $stmt->execute([1, $totalVenta, $totalVenta, 0]);
    $ventaId = $pdo->lastInsertId();

    $stmt = $pdo->prepare("INSERT INTO venta_detalles (venta_id, producto_id, cantidad, precio, subtotal) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$ventaId, $prodId, $cantidadVenta, $precioVenta, $totalVenta]);

    $stmt = $pdo->prepare("UPDATE productos SET stock = stock - ? WHERE id = ?");
    $stmt->execute([$cantidadVenta, $prodId]);

    $pdo->commit();

    echo "[4] Venta registrada (ID: $ventaId). Comprobando stock final...\n";

    // 4. Verificar stock final
    $stmt = $pdo->prepare("SELECT stock FROM productos WHERE id = ?");
    $stmt->execute([$prodId]);
    $stockFinal = $stmt->fetchColumn();

    echo "    Stock inicial: 100.000\n";
    echo "    Vendido:       " . number_format($cantidadVenta, 3) . "\n";
    echo "    Stock final:   " . $stockFinal . "\n";

    if (abs($stockFinal - 98.500) < 0.001) {
        echo "\n✓ PRUEBA EXITOSA: El stock decimal se descontó correctamente.\n";
    } else {
        echo "\n✗ ERROR: El stock final no es correcto.\n";
    }

    // Limpieza
    //$pdo->exec("DELETE FROM productos WHERE id = $prodId");

} catch (Exception $e) {
    if ($pdo->inTransaction())
        $pdo->rollBack();
    echo "\n✗ ERROR EXCEPCIÓN: " . $e->getMessage() . "\n";
}
?>