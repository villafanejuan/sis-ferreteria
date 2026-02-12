<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();
checkAccess('reports');

$db = Database::getInstance();

// Filtros
$fecha_inicio = $_GET['fecha_inicio'] ?? date('Y-m-01');
$fecha_fin = $_GET['fecha_fin'] ?? date('Y-m-d');
$usuario_id = isset($_GET['usuario_id']) && $_GET['usuario_id'] !== '' ? intval($_GET['usuario_id']) : null;

// Construir Query Ventas
$sql = "SELECT v.*, u.username as vendedor 
        FROM ventas v 
        LEFT JOIN usuarios u ON v.usuario_id = u.id 
        WHERE DATE(v.fecha) BETWEEN ? AND ?";
$params = [$fecha_inicio, $fecha_fin];

if ($usuario_id) {
    $sql .= " AND v.usuario_id = ?";
    $params[] = $usuario_id;
}

$sql .= " ORDER BY v.fecha DESC";
$ventas = $db->fetchAll($sql, $params);

// Totales
$total_ventas = 0;
foreach ($ventas as $v) $total_ventas += $v['total'];

// Usuarios para filtro
$usuarios = $db->fetchAll("SELECT id, username FROM usuarios ORDER BY username");
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reportes - <?php echo APP_NAME; ?></title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex flex-col min-h-screen pb-10">
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <div class="max-w-7xl mx-auto px-4 py-6 w-full flex-1">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800"><i class="fas fa-chart-pie mr-2 text-blue-600"></i>Reporte de Ventas</h1>
        </div>

        <!-- Filtros -->
        <div class="bg-white rounded-lg shadow p-4 mb-6 border border-gray-200">
            <form class="grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Desde</label>
                    <input type="date" name="fecha_inicio" value="<?php echo $fecha_inicio; ?>" class="w-full border p-2 rounded text-sm">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Hasta</label>
                    <input type="date" name="fecha_fin" value="<?php echo $fecha_fin; ?>" class="w-full border p-2 rounded text-sm">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">Vendedor</label>
                    <select name="usuario_id" class="w-full border p-2 rounded text-sm">
                        <option value="">Todos</option>
                        <?php foreach ($usuarios as $u): ?>
                            <option value="<?php echo $u['id']; ?>" <?php echo $usuario_id == $u['id'] ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($u['username']); ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <div class="md:col-span-2 flex gap-2">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded text-sm font-bold hover:bg-blue-700 w-full">
                        <i class="fas fa-filter mr-1"></i> Filtrar
                    </button>
                     <a href="reports.php" class="bg-gray-200 text-gray-600 px-4 py-2 rounded text-sm font-bold hover:bg-gray-300 text-center">
                        Limpiar
                    </a>
                </div>
            </form>
        </div>

        <!-- Resumen -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
            <div class="bg-white p-4 rounded-lg shadow border-l-4 border-green-500">
                <p class="text-xs font-bold text-gray-400 uppercase">Total Vendido</p>
                <p class="text-3xl font-bold text-gray-800 font-mono-num">$<?php echo number_format($total_ventas, 2); ?></p>
            </div>
            <div class="bg-white p-4 rounded-lg shadow border-l-4 border-blue-500">
                <p class="text-xs font-bold text-gray-400 uppercase">Cantidad Ventas</p>
                <p class="text-3xl font-bold text-gray-800 font-mono-num"><?php echo count($ventas); ?></p>
            </div>
             <div class="bg-white p-4 rounded-lg shadow border-l-4 border-yellow-500">
                <p class="text-xs font-bold text-gray-400 uppercase">Ticket Promedio</p>
                <p class="text-3xl font-bold text-gray-800 font-mono-num">
                    $<?php echo count($ventas) > 0 ? number_format($total_ventas / count($ventas), 2) : '0.00'; ?>
                </p>
            </div>
        </div>

        <!-- Tabla -->
        <div class="bg-white rounded-lg shadow border border-gray-200 overflow-hidden">
            <div class="bg-gray-50 px-4 py-2 border-b border-gray-100 flex justify-between items-center">
                <h3 class="font-bold text-gray-700">Detalle de Transacciones</h3>
                <span class="text-xs text-gray-500"><?php echo count($ventas); ?> registros</span>
            </div>
            <div class="overflow-x-auto">
                <table class="dense-table">
                    <thead>
                        <tr>
                            <th class="w-20">#Ticket</th>
                            <th>Fecha</th>
                            <th>Vendedor</th>
                            <th class="text-right">Total</th>
                            <th class="text-center w-24">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($ventas as $v): ?>
                            <tr class="hover:bg-gray-50 transition">
                                <td class="font-mono-num text-xs font-bold text-gray-600">#<?php echo $v['id']; ?></td>
                                <td class="text-sm"><?php echo date('d/m/Y H:i', strtotime($v['fecha'])); ?></td>
                                <td class="text-sm"><i class="fas fa-user-circle mr-1 text-gray-400"></i><?php echo htmlspecialchars($v['vendedor']); ?></td>
                                <td class="text-right font-mono-num font-bold text-gray-800">$<?php echo number_format($v['total'], 2); ?></td>
                                <td class="text-center">
                                    <button onclick="viewTicket(<?php echo $v['id']; ?>)" class="text-blue-600 hover:text-blue-800 text-xs font-bold">
                                        <i class="fas fa-eye mr-1"></i>Ver
                                    </button>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                         <?php if (empty($ventas)): ?>
                            <tr><td colspan="5" class="text-center py-10 text-gray-400">No hay ventas en este período</td></tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        function viewTicket(id) {
            // Placeholder: Podría abrir modal o ir a página de detalle
            alert('Ver detalle del ticket #' + id + ' (En desarrollo: Implementar visualización de detalles)');
        }
    </script>
</body>
</html>