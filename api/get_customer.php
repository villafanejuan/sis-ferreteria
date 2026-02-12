<?php
/**
 * API: Búsqueda de clientes para POS
 * Endpoint AJAX para autocompletado de clientes
 */

header('Content-Type: application/json');
require_once __DIR__ . '/../app/bootstrap.php';

// Verificar sesión
if (!isset($_SESSION['user_id'])) {
    echo json_encode(['success' => false, 'error' => 'No autorizado']);
    exit;
}

$query = isset($_GET['q']) ? trim($_GET['q']) : '';
$limit = isset($_GET['limit']) ? intval($_GET['limit']) : 10;

try {
    if (empty($query)) {
        // Devolver cliente genérico
        echo json_encode([
            'success' => true,
            'customers' => [
                [
                    'id' => null,
                    'nombre' => 'Cliente Genérico',
                    'documento' => '',
                    'telefono' => '',
                    'saldo_cuenta_corriente' => 0
                ]
            ]
        ]);
        exit;
    }

    // Buscar por nombre o documento
    $searchTerm = "%{$query}%";

    $stmt = $pdo->prepare("
        SELECT 
            id,
            nombre,
            documento,
            telefono,
            email,
            saldo_cuenta_corriente
        FROM clientes
        WHERE nombre LIKE ? OR documento LIKE ?
        ORDER BY nombre
        LIMIT ?
    ");

    $stmt->execute([$searchTerm, $searchTerm, $limit]);
    $customers = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Formatear resultados
    foreach ($customers as &$customer) {
        $customer['saldo_cuenta_corriente'] = floatval($customer['saldo_cuenta_corriente']);
    }

    echo json_encode([
        'success' => true,
        'customers' => $customers,
        'count' => count($customers)
    ]);

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'error' => 'Error en búsqueda: ' . $e->getMessage()
    ]);
}
