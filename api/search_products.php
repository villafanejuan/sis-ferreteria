<?php
/**
 * API: Búsqueda de productos para POS
 * Endpoint AJAX para búsqueda en tiempo real
 */

header('Content-Type: application/json');
require_once __DIR__ . '/../app/bootstrap.php';

// Verificar sesión
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'error' => 'No autorizado']);
    exit;
}

$query = isset($_GET['q']) ? trim($_GET['q']) : '';
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : 20;

if (empty($query)) {
    echo json_encode(['success' => true, 'products' => []]);
    exit;
}

try {
    // Buscar por nombre, código de barra, marca o categoría
    $searchTerm = "%{$query}%";

    $stmt = $pdo->prepare("
        SELECT 
            p.id,
            p.nombre,
            p.codigo_barra,
            p.modelo,
            p.precio,
            p.stock,
            p.stock_minimo,
            p.precio_costo,
            m.nombre as marca,
            c.nombre as categoria,
            u.nombre as unidad,
            u.abreviatura as unidad_abrev,
            pr.nombre as proveedor
        FROM productos p
        LEFT JOIN marcas m ON p.marca_id = m.id
        LEFT JOIN categorias c ON p.categoria_id = c.id
        LEFT JOIN unidades_medida u ON p.unidad_medida_id = u.id
        LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
        WHERE p.deleted_at IS NULL
          AND (
              p.nombre LIKE ? 
              OR p.codigo_barra LIKE ?
              OR p.modelo LIKE ?
              OR m.nombre LIKE ?
              OR c.nombre LIKE ?
          )
        ORDER BY 
            CASE 
                WHEN p.codigo_barra = ? THEN 1
                WHEN p.nombre LIKE ? THEN 2
                ELSE 3
            END,
            p.nombre
        LIMIT ?
    ");

    $stmt->execute([
        $searchTerm,
        $searchTerm,
        $searchTerm,
        $searchTerm,
        $searchTerm,
        $query,
        $query . '%',
        $limit
    ]);

    $products = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Formatear resultados
    foreach ($products as &$product) {
        $product['precio'] = floatval($product['precio']);
        $product['stock'] = intval($product['stock']);
        $product['stock_minimo'] = intval($product['stock_minimo']);
        $product['precio_costo'] = floatval($product['precio_costo']);
        $product['stock_status'] = $product['stock'] <= 0 ? 'sin_stock' :
            ($product['stock'] <= $product['stock_minimo'] ? 'bajo' : 'ok');

        // Nombre completo con marca y modelo
        $product['nombre_completo'] = $product['nombre'];
        if (!empty($product['marca'])) {
            $product['nombre_completo'] .= ' - ' . $product['marca'];
        }
        if (!empty($product['modelo'])) {
            $product['nombre_completo'] .= ' (' . $product['modelo'] . ')';
        }
    }

    echo json_encode([
        'success' => true,
        'products' => $products,
        'count' => count($products)
    ]);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Error en búsqueda: ' . $e->getMessage()
    ]);
}
