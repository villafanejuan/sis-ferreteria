<?php
/**
 * Script para ejecutar migración 004: Mejoras POS
 */

require_once __DIR__ . '/../../config/database.php';

try {
    echo "=== Iniciando Migración 004: Mejoras POS ===\n\n";

    $pdo = getDBConnection();
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Leer archivo SQL
    $sql = file_get_contents(__DIR__ . '/004_pos_enhancements.sql');

    // Ejecutar migración
    echo "Ejecutando migración...\n";
    $pdo->exec($sql);

    echo "\n✅ Migración 004 completada exitosamente!\n\n";
    echo "Cambios aplicados:\n";
    echo "- Tabla ventas: agregados campos para descuentos y pagos mixtos\n";
    echo "- Tabla venta_items: agregados campos para descuentos por producto\n";
    echo "- Tabla ventas_pendientes: creada para suspender ventas\n";
    echo "- Índices: creados para mejorar rendimiento de búsqueda\n";
    echo "- Vistas: productos_mas_vendidos y productos_stock_bajo\n";

} catch (PDOException $e) {
    echo "\n❌ Error en migración: " . $e->getMessage() . "\n";
    exit(1);
}
