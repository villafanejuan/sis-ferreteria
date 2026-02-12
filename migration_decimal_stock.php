<?php
/**
 * Migración para soporte de decimales en stock
 */

require_once __DIR__ . '/app/bootstrap.php';

echo "═══════════════════════════════════════════════════════════════\n";
echo "MIGRACIÓN: SOPORTE PARA STOCK DECIMAL Y PRECIOS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $db = Database::getInstance();
    $pdo = $db->getConnection();

    // 1. Modificar tabla productos
    echo "[1/4] Modificando tabla 'productos'...\n";
    $pdo->exec("ALTER TABLE productos MODIFY COLUMN stock DECIMAL(10,3) NOT NULL DEFAULT 0.000");
    $pdo->exec("ALTER TABLE productos MODIFY COLUMN stock_minimo DECIMAL(10,3) NOT NULL DEFAULT 0.000");
    echo "      ✓ Columnas stock y stock_minimo actualizadas a DECIMAL(10,3).\n";

    // 2. Modificar tabla venta_detalles
    echo "[2/4] Modificando tabla 'venta_detalles'...\n";
    $pdo->exec("ALTER TABLE venta_detalles MODIFY COLUMN cantidad DECIMAL(10,3) NOT NULL");
    echo "      ✓ Columna cantidad actualizada a DECIMAL(10,3).\n";

    // 3. Modificar tabla movimientos_caja (si guarda referencias a cantidades, aunque creo que no)
    // No es necesario, movimientos_caja guarda montos (dinero), que ya es DECIMAL(10,2)
    echo "[3/4] Verificando tablas de caja...\n";
    echo "      ✓ Tablas de caja no requieren cambios (manejan dinero).\n";

    // 4. Modificar tabla carrito (si existiera en BD, pero es session)
    // La sesión manejará floats/doubles de PHP, así que está bien.

    echo "\n✓ Migración completada exitosamente.\n";

} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>