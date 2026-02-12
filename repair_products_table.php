<?php
/**
 * Script para verificar y reparar tabla productos
 */

require_once __DIR__ . '/app/bootstrap.php';

echo "═══════════════════════════════════════════════════════════════\n";
echo "REPARACIÓN DE TABLA: PRODUCTOS\n";
echo "═══════════════════════════════════════════════════════════════\n\n";

try {
    $db = Database::getInstance();
    $pdo = $db->getConnection();

    // Verificar si existe unidad_medida
    $stmt = $pdo->query("SHOW COLUMNS FROM productos LIKE 'unidad_medida'");
    $col = $stmt->fetch();

    if (!$col) {
        echo "[!] Columna 'unidad_medida' faltante. Agregándola...\n";
        $pdo->exec("ALTER TABLE productos ADD COLUMN unidad_medida VARCHAR(20) DEFAULT 'unid' AFTER stock");
        echo "    ✓ Columna agregada exitosamente.\n";
    } else {
        echo "✓ La columna 'unidad_medida' ya existe.\n";
    }

    // Verificar decimales en stock nuevamente por seguridad
    $stmt = $pdo->query("SHOW COLUMNS FROM productos LIKE 'stock'");
    $col = $stmt->fetch(PDO::FETCH_ASSOC);
    echo "    Tipo de columna 'stock': " . $col['Type'] . "\n";

    echo "\n✓ Reparación completada.\n";

} catch (Exception $e) {
    echo "\n✗ ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>