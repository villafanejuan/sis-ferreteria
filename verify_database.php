<?php
// Script de verificación de base de datos
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== VERIFICACIÓN DE BASE DE DATOS FERRETERIA ===\n\n";

try {
    // Intentar conectar
    $pdo = new PDO("mysql:host=localhost;dbname=ferreteria_db;charset=utf8mb4", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "✓ Conexión exitosa a ferreteria_db\n\n";

    // Listar tablas
    echo "TABLAS EN LA BASE DE DATOS:\n";
    echo str_repeat("-", 50) . "\n";

    $stmt = $pdo->query("SHOW TABLES");
    $tables = $stmt->fetchAll(PDO::FETCH_COLUMN);

    if (empty($tables)) {
        echo "⚠ NO HAY TABLAS EN LA BASE DE DATOS\n";
        echo "La base de datos existe pero está vacía.\n";
    } else {
        foreach ($tables as $index => $table) {
            echo ($index + 1) . ". " . $table . "\n";
        }
        echo "\nTotal de tablas: " . count($tables) . "\n";
    }

} catch (PDOException $e) {
    echo "✗ ERROR DE CONEXIÓN:\n";
    echo $e->getMessage() . "\n\n";

    // Intentar ver qué bases de datos existen
    try {
        $pdo = new PDO("mysql:host=localhost;charset=utf8mb4", "root", "");
        echo "\nBASES DE DATOS DISPONIBLES:\n";
        echo str_repeat("-", 50) . "\n";
        $stmt = $pdo->query("SHOW DATABASES");
        $databases = $stmt->fetchAll(PDO::FETCH_COLUMN);
        foreach ($databases as $db) {
            echo "- " . $db . "\n";
        }
    } catch (PDOException $e2) {
        echo "No se pudieron listar las bases de datos.\n";
    }
}

echo "\n" . str_repeat("=", 50) . "\n";
?>