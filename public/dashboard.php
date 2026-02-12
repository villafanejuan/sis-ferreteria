<?php
/**
 * Dashboard Principal - Rediseñado
 */

require_once __DIR__ . '/../app/bootstrap.php';

// Verificar autenticación
if (!isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}

// Logic for welcome modal
$show_welcome = false;
if (!isset($_SESSION['welcome_shown'])) {
    $_SESSION['welcome_shown'] = true;
    $show_welcome = true;
}

// Obtener datos del usuario
$userId = $_SESSION['user_id'];
$userName = $_SESSION['nombre'] ?? $_SESSION['username'];
$isAdmin = ($_SESSION['role'] ?? '') === 'admin';

// Obtener conexión directa para queries simples
$db = Database::getInstance();

// Obtener estadísticas básicas
try {
    $totalProductos = $db->fetchOne("SELECT COUNT(*) as total FROM productos")['total'] ?? 0;
    $productosStockBajo = $db->fetchOne("SELECT COUNT(*) as total FROM productos WHERE stock < stock_minimo")['total'] ?? 0;

    $statsHoy = $db->fetchOne("
        SELECT COUNT(*) as total_ventas, COALESCE(SUM(total), 0) as total_ingresos 
        FROM ventas 
        WHERE DATE(fecha) = CURDATE()
    ");
    $ventasHoy = $statsHoy['total_ventas'] ?? 0;
    $ingresosHoy = $statsHoy['total_ingresos'] ?? 0;

    $productosBajos = $db->fetchAll("
        SELECT p.*, c.nombre as categoria_nombre
        FROM productos p
        LEFT JOIN categorias c ON p.categoria_id = c.id
        WHERE p.stock < p.stock_minimo
        ORDER BY p.stock ASC
        LIMIT 10
    ");

    $topProductos = $db->fetchAll("
        SELECT p.nombre, 
               SUM(vd.cantidad) as total_vendido,
               COUNT(DISTINCT v.id) as num_ventas
        FROM productos p
        INNER JOIN venta_detalles vd ON p.id = vd.producto_id
        INNER JOIN ventas v ON vd.venta_id = v.id
        WHERE v.fecha >= DATE_SUB(NOW(), INTERVAL 7 DAY)
        GROUP BY p.id, p.nombre
        ORDER BY total_vendido DESC
        LIMIT 5
    ");

} catch (Exception $e) {
    $totalProductos = 0; $productosStockBajo = 0; $ventasHoy = 0; $ingresosHoy = 0; $productosBajos = []; $topProductos = [];
}

$turnoAbierto = null;
if (canAccess('cash')) {
    $turnoAbierto = $db->fetchOne("SELECT * FROM turnos_caja WHERE user_id = ? AND estado = 'abierto'", [$userId]);
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - <?php echo APP_NAME; ?></title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex flex-col min-h-screen pb-12">
    <!-- Navegación -->
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <!-- Contenido Principal -->
    <div class="max-w-7xl mx-auto px-4 py-8 w-full flex-1">
        
        <!-- Estado del Sistema -->
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800">
                <i class="fas fa-tachometer-alt mr-2 text-gray-500"></i>Panel de Control
            </h1>
            <div class="text-sm text-gray-500">
                <?php echo date('d/m/Y H:i'); ?>
            </div>
        </div>

        <!-- Tarjetas de Estadísticas (Compactas) -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <?php if ($_SESSION['role'] !== 'cajero'): ?>
                <div class="card-compact p-4 border-l-4 border-blue-500 flex justify-between items-center">
                    <div>
                        <p class="text-xs text-gray-500 uppercase font-bold">Total Productos</p>
                        <p class="text-2xl font-bold text-gray-800 font-mono-num"><?php echo $totalProductos; ?></p>
                    </div>
                    <i class="fas fa-box text-blue-200 text-3xl"></i>
                </div>
            <?php endif; ?>

            <div class="card-compact p-4 border-l-4 border-green-500 flex justify-between items-center">
                <div>
                    <p class="text-xs text-gray-500 uppercase font-bold">Ventas Hoy</p>
                    <p class="text-2xl font-bold text-gray-800 font-mono-num"><?php echo $ventasHoy; ?></p>
                </div>
                <i class="fas fa-shopping-cart text-green-200 text-3xl"></i>
            </div>

            <div class="card-compact p-4 border-l-4 border-yellow-500 flex justify-between items-center">
                <div>
                    <p class="text-xs text-gray-500 uppercase font-bold">Ingresos Hoy</p>
                    <p class="text-2xl font-bold text-gray-800 font-mono-num">$<?php echo number_format($ingresosHoy, 2); ?></p>
                </div>
                <i class="fas fa-dollar-sign text-yellow-200 text-3xl"></i>
            </div>

            <?php if ($_SESSION['role'] !== 'cajero'): ?>
                <div class="card-compact p-4 border-l-4 border-red-500 flex justify-between items-center">
                    <div>
                        <p class="text-xs text-gray-500 uppercase font-bold">Stock Bajo</p>
                        <p class="text-2xl font-bold text-red-600 font-mono-num"><?php echo $productosStockBajo; ?></p>
                    </div>
                    <i class="fas fa-exclamation-triangle text-red-200 text-3xl"></i>
                </div>
            <?php endif; ?>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Columna Izquierda: Accesos Rápidos (Teclado) -->
            <div class="lg:col-span-1">
                <div class="card-compact p-4 mb-4">
                    <h3 class="font-bold text-gray-700 border-b pb-2 mb-3">Accesos Rápidos</h3>
                    <div class="space-y-2">
                        <?php if (canAccess('sales')): ?>
                            <a href="sales.php" class="block p-3 bg-gray-50 hover:bg-blue-50 border border-gray-200 rounded flex justify-between items-center group">
                                <span class="font-medium text-gray-700 group-hover:text-blue-700"><i class="fas fa-cash-register mr-2 opacity-50"></i>Nueva Venta</span>
                                <span class="kbd-shortcut">F2</span>
                            </a>
                        <?php endif; ?>
                        
                        <?php if (canAccess('products')): ?>
                            <a href="products.php" class="block p-3 bg-gray-50 hover:bg-blue-50 border border-gray-200 rounded flex justify-between items-center group">
                                <span class="font-medium text-gray-700 group-hover:text-blue-700"><i class="fas fa-box mr-2 opacity-50"></i>Productos</span>
                                <span class="kbd-shortcut">F3</span>
                            </a>
                        <?php endif; ?>

                        <?php if (canAccess('cash')): ?>
                            <a href="cash.php" class="block p-3 bg-gray-50 hover:bg-blue-50 border border-gray-200 rounded flex justify-between items-center group">
                                <span class="font-medium text-gray-700 group-hover:text-blue-700"><i class="fas fa-wallet mr-2 opacity-50"></i>Caja</span>
                                <span class="kbd-shortcut">F4</span>
                            </a>
                        <?php endif; ?>

                        <?php if (checkAdmin()): ?>
                         <a href="users.php" class="block p-3 bg-gray-50 hover:bg-blue-50 border border-gray-200 rounded flex justify-between items-center group">
                                <span class="font-medium text-gray-700 group-hover:text-blue-700"><i class="fas fa-users mr-2 opacity-50"></i>Usuarios</span>
                                <span class="text-xs text-gray-400">Admin</span>
                            </a>
                        <?php endif; ?>
                    </div>
                </div>

                <!-- Resumen de Caja -->
                <?php if (canAccess('cash')): ?>
                <div class="card-compact p-4 <?php echo $turnoAbierto ? 'border-green-200 bg-green-50' : 'border-red-200 bg-red-50'; ?>">
                    <h3 class="font-bold text-gray-700 mb-2">Estado de Caja</h3>
                    <?php if ($turnoAbierto): ?>
                        <div class="text-green-700">
                            <i class="fas fa-check-circle mr-1"></i> <strong>ABIERTA</strong>
                            <p class="text-xs mt-1">Inicio: $<?php echo number_format($turnoAbierto['monto_inicial'], 2); ?></p>
                            <p class="text-xs">U: <?php echo $turnoAbierto['usuario_nombre']; ?></p>
                        </div>
                    <?php else: ?>
                        <div class="text-red-700">
                            <i class="fas fa-times-circle mr-1"></i> <strong>CERRADA</strong>
                            <a href="cash.php" class="block mt-2 text-center text-xs bg-red-600 text-white py-1 rounded hover:bg-red-700">Abrir Turno</a>
                        </div>
                    <?php endif; ?>
                </div>
                <?php endif; ?>
            </div>

            <!-- Columna Derecha: Tablas de Datos -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Stock Bajo -->
                <?php if ($_SESSION['role'] !== 'cajero'): ?>
                <div class="card-compact overflow-hidden">
                    <div class="bg-red-50 px-4 py-2 border-b border-red-100 flex justify-between items-center">
                        <h3 class="font-bold text-red-800 text-sm"><i class="fas fa-exclamation-triangle mr-2"></i>Requieren Reposición</h3>
                        <a href="products.php?filter=low_stock" class="text-xs text-red-600 hover:underline">Ver todos</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="dense-table">
                            <thead>
                                <tr>
                                    <th>Producto</th>
                                    <th class="text-center">Stock Limit</th>
                                    <th class="text-center">Actual</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($productosBajos as $p): ?>
                                    <tr>
                                        <td class="font-medium"><?php echo htmlspecialchars($p['nombre']); ?></td>
                                        <td class="text-center text-gray-500 text-xs"><?php echo round($p['stock_minimo'], 0); ?></td>
                                        <td class="text-center font-bold text-red-600 font-mono-num"><?php echo round($p['stock'], 1); ?></td>
                                    </tr>
                                <?php endforeach; ?>
                                <?php if (empty($productosBajos)): ?>
                                    <tr><td colspan="3" class="text-center py-4 text-gray-400">Todo en orden</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                <?php endif; ?>

                <!-- Top Ventas -->
                <div class="card-compact overflow-hidden">
                    <div class="bg-blue-50 px-4 py-2 border-b border-blue-100">
                        <h3 class="font-bold text-blue-800 text-sm"><i class="fas fa-trophy mr-2"></i>Top Ventas (7 días)</h3>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="dense-table">
                            <thead>
                                <tr>
                                    <th>Producto</th>
                                    <th class="text-center">Ventas</th>
                                    <th class="text-right">Total Unid.</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($topProductos as $p): ?>
                                    <tr>
                                        <td class="font-medium"><?php echo htmlspecialchars($p['nombre']); ?></td>
                                        <td class="text-center"><?php echo $p['num_ventas']; ?></td>
                                        <td class="text-right font-bold text-blue-600 font-mono-num"><?php echo round($p['total_vendido'], 1); ?></td>
                                    </tr>
                                <?php endforeach; ?>
                                <?php if (empty($topProductos)): ?>
                                    <tr><td colspan="3" class="text-center py-4 text-gray-400">Sin datos recientes</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Welcome Modal -->
    <?php if ($show_welcome): ?>
        <div id="welcomeModal" class="fixed inset-0 z-50 flex items-center justify-center hidden">
            <div class="fixed inset-0 bg-gray-900 bg-opacity-50" onclick="closeWelcomeModal()"></div>
            <div class="bg-white rounded-lg shadow-xl p-6 relative max-w-sm w-full mx-4 text-center z-10">
                <i class="fas fa-smile-beam text-4xl text-blue-500 mb-4 animate-bounce"></i>
                <h3 class="text-xl font-bold text-gray-800">¡Hola, <?php echo htmlspecialchars($userName); ?>!</h3>
                <p id="welcomeMessage" class="text-gray-600 mt-2 mb-6 italic"></p>
                <button onclick="closeWelcomeModal()" class="w-full bg-blue-600 text-white rounded py-2 font-bold hover:bg-blue-700">Entendido [Esc]</button>
            </div>
        </div>
        <script>
            document.addEventListener('DOMContentLoaded', () => {
                const msgs = ["¡Éxito en tus ventas!", "¡Hoy será un gran día!", "Tu esfuerzo cuenta.", "¡A trabajar con energía!"];
                document.getElementById('welcomeMessage').innerText = msgs[Math.floor(Math.random() * msgs.length)];
                setTimeout(() => document.getElementById('welcomeModal').classList.remove('hidden'), 300);
            });
            function closeWelcomeModal() { document.getElementById('welcomeModal').classList.add('hidden'); }
        </script>
    <?php endif; ?>
</body>
</html>