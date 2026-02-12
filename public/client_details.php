<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();
checkAccess('sales');

$id = isset($_GET['id']) ? intval($_GET['id']) : 0;
$db = Database::getInstance();

$cliente = $db->fetchOne("SELECT * FROM clientes WHERE id = ?", [$id]);

if (!$cliente) {
    header("Location: clients.php");
    exit;
}

// Procesar Pago
$message = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['register_payment'])) {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        $message = "Error CSRF";
    } else {
        $monto = floatval($_POST['monto']);
        $metodo = $_POST['metodo_pago']; // efectivo, transferencia
        $notas = sanitize($_POST['notas']);

        if ($monto > 0) {
            // 1. Reducir deuda cliente
            $db->query("UPDATE clientes SET saldo_cuenta_corriente = saldo_cuenta_corriente - ? WHERE id = ?", [$monto, $id]);
            
            // 2. Registrar movimiento en CC
            $nuevoSaldo = $cliente['saldo_cuenta_corriente'] - $monto;
            $sqlCC = "INSERT INTO cuenta_corriente_movimientos (cliente_id, tipo, monto, saldo_historico, descripcion, usuario_id, fecha) VALUES (?, 'pago', ?, ?, ?, ?, NOW())";
            $desc = "Pago ($metodo)" . ($notas ? " - $notas" : "");
            $db->query($sqlCC, [$id, $monto, $nuevoSaldo, $desc, $_SESSION['user_id']]);

            // 3. Registrar entrada en Caja (si es efectivo)
            if ($metodo === 'efectivo') {
                // Verificar turno caja
                $turno = $db->fetchOne("SELECT id FROM turnos_caja WHERE user_id = ? AND estado = 'abierto'", [$_SESSION['user_id']]);
                if ($turno) {
                    $sqlCaja = "INSERT INTO movimientos_caja (turno_id, tipo, monto, descripcion, usuario_id, fecha) VALUES (?, 'ingreso', ?, ?, ?, NOW())";
                    $db->query($sqlCaja, [$turno['id'], $monto, "Pago Cliente #" . $id . " - " . $cliente['nombre'], $_SESSION['user_id']]);
                }
            }

            header("Location: client_details.php?id=$id&msg=payment_registered");
            exit;
        }
    }
}

// Historial Movimientos
$movimientos = $db->fetchAll("SELECT * FROM cuenta_corriente_movimientos WHERE cliente_id = ? ORDER BY fecha DESC LIMIT 50", [$id]);

// Últimas ventas
$ventas = $db->fetchAll("SELECT * FROM ventas WHERE cliente_id = ? ORDER BY fecha DESC LIMIT 10", [$id]);

if (empty($_SESSION['csrf_token'])) $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle Cliente - <?php echo APP_NAME; ?></title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex flex-col min-h-screen pb-10">
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <div class="max-w-7xl mx-auto px-4 py-8 w-full flex-1">
        <!-- Header -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <a href="clients.php" class="text-gray-500 hover:text-gray-700 mb-2 block"><i class="fas fa-arrow-left mr-1"></i>Volver a Clientes</a>
                <h1 class="text-3xl font-bold text-gray-800"><?php echo htmlspecialchars($cliente['nombre']); ?></h1>
                <div class="flex gap-4 text-sm text-gray-600 mt-1">
                    <span><i class="fas fa-id-card mr-1"></i><?php echo $cliente['documento']; ?></span>
                    <?php if($cliente['telefono']): ?><span><i class="fas fa-phone mr-1"></i><?php echo $cliente['telefono']; ?></span><?php endif; ?>
                </div>
            </div>
            
            <div class="bg-white p-4 rounded-lg shadow border-l-4 <?php echo $cliente['saldo_cuenta_corriente'] > 0 ? 'border-red-500' : 'border-green-500'; ?> flex flex-col items-end">
                <span class="text-xs uppercase font-bold text-gray-400">Saldo Actual</span>
                <span class="text-3xl font-mono font-bold <?php echo $cliente['saldo_cuenta_corriente'] > 0 ? 'text-red-600' : 'text-green-600'; ?>">
                    $<?php echo number_format($cliente['saldo_cuenta_corriente'], 2); ?>
                </span>
                <span class="text-xs text-gray-400">Límite: $<?php echo number_format($cliente['limite_credito'], 2); ?></span>
            </div>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Columna Principal: Estado de Cuenta -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-lg shadow mb-6">
                    <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
                        <h2 class="font-bold text-gray-800"><i class="fas fa-file-invoice-dollar mr-2 text-blue-500"></i>Estado de Cuenta</h2>
                        <button onclick="openPaymentModal()" class="bg-green-600 text-white px-4 py-2 rounded text-sm font-bold hover:bg-green-700 shadow-sm">
                            <i class="fas fa-money-bill-wave mr-2"></i>Registrar Pago
                        </button>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead class="bg-gray-50 text-xs text-gray-500 uppercase">
                                <tr>
                                    <th class="p-3">Fecha</th>
                                    <th class="p-3">Descripción</th>
                                    <th class="p-3 text-right text-red-600">Cargo</th>
                                    <th class="p-3 text-right text-green-600">Abono</th>
                                    <th class="p-3 text-right">Saldo</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100 text-sm">
                                <?php foreach ($movimientos as $m): ?>
                                    <tr class="hover:bg-gray-50">
                                        <td class="p-3"><?php echo date('d/m/y H:i', strtotime($m['fecha'])); ?></td>
                                        <td class="p-3">
                                            <span class="font-medium <?php echo $m['tipo'] == 'venta' ? 'text-gray-800' : 'text-blue-600'; ?>">
                                                <?php echo ucfirst($m['tipo']); ?>
                                            </span>
                                            <div class="text-xs text-gray-500 truncate w-48" title="<?php echo htmlspecialchars($m['descripcion']); ?>">
                                                <?php echo htmlspecialchars($m['descripcion']); ?>
                                            </div>
                                        </td>
                                        <td class="p-3 text-right font-mono text-red-600">
                                            <?php echo ($m['tipo'] == 'venta' || $m['tipo'] == 'ajuste_debito') ? '$'.number_format($m['monto'], 2) : '-'; ?>
                                        </td>
                                        <td class="p-3 text-right font-mono text-green-600">
                                            <?php echo ($m['tipo'] == 'pago' || $m['tipo'] == 'ajuste_credito') ? '$'.number_format($m['monto'], 2) : '-'; ?>
                                        </td>
                                        <td class="p-3 text-right font-mono font-bold">
                                            $<?php echo number_format($m['saldo_historico'], 2); ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                                <?php if (empty($movimientos)): ?>
                                    <tr><td colspan="5" class="p-6 text-center text-gray-400">No hay movimientos registrados</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Columna Lateral: Info y Ventas -->
            <div class="space-y-6">
                <!-- Info -->
                <div class="bg-white rounded-lg shadow p-6">
                    <h3 class="font-bold text-gray-700 border-b pb-2 mb-4">Información</h3>
                    <div class="space-y-3 text-sm">
                        <div>
                            <span class="block text-xs text-gray-500">Dirección</span>
                            <span class="text-gray-800"><?php echo htmlspecialchars($cliente['direccion'] ?? '-'); ?></span>
                        </div>
                        <div>
                            <span class="block text-xs text-gray-500">Email</span>
                            <span class="text-gray-800"><?php echo htmlspecialchars($cliente['email'] ?? '-'); ?></span>
                        </div>
                        <div>
                            <span class="block text-xs text-gray-500">Notas</span>
                            <div class="bg-yellow-50 p-2 rounded text-gray-600 italic">
                                <?php echo htmlspecialchars($cliente['notas'] ?? 'Sin notas adicionales.'); ?>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Historial Ventas -->
               <div class="bg-white rounded-lg shadow overflow-hidden">
                    <div class="bg-gray-50 px-4 py-2 border-b border-gray-100">
                         <h3 class="font-bold text-gray-700 text-sm">Últimas Ventas</h3>
                    </div>
                    <table class="w-full text-left text-sm">
                        <tbody class="divide-y divide-gray-100">
                            <?php foreach ($ventas as $v): ?>
                                <tr class="hover:bg-gray-50">
                                    <td class="p-3">
                                        <div class="font-mono text-xs text-gray-500">#<?php echo $v['id']; ?></div>
                                        <div class="text-xs"><?php echo date('d/m/y', strtotime($v['fecha'])); ?></div>
                                    </td>
                                    <td class="p-3 text-right font-bold">
                                        $<?php echo number_format($v['total'], 2); ?>
                                    </td>
                                    <!-- Placeholder "Ver" -->
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
               </div>
            </div>
        </div>
    </div>

    <!-- Payment Modal -->
    <div id="paymentModal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
        <div class="fixed inset-0 bg-gray-900 bg-opacity-50" onclick="document.getElementById('paymentModal').classList.add('hidden')"></div>
        <div class="bg-white rounded-lg shadow-xl w-full max-w-sm z-10 p-6">
            <h3 class="text-xl font-bold mb-4 border-b pb-2">Registrar Pago</h3>
            <form method="POST">
                <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                <input type="hidden" name="register_payment" value="1">
                
                <div class="mb-4">
                    <label class="block text-sm font-bold text-gray-700 mb-1">Monto a Pagar</label>
                    <div class="relative">
                        <span class="absolute left-3 top-3 text-gray-400">$</span>
                        <input type="number" step="0.01" name="monto" required autofocus
                            class="w-full pl-8 border-2 border-green-500 p-2 rounded text-2xl font-bold text-gray-800"
                            placeholder="0.00">
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="block text-sm font-bold text-gray-700 mb-1">Método</label>
                    <select name="metodo_pago" class="w-full border p-2 rounded">
                        <option value="efectivo">Efectivo</option>
                        <option value="transferencia">Transferencia</option>
                        <option value="tarjeta_debito">Débito</option>
                    </select>
                </div>
                
                 <div class="mb-6">
                    <label class="block text-sm font-bold text-gray-700 mb-1">Notas (Opcional)</label>
                    <input type="text" name="notas" class="w-full border p-2 rounded" placeholder="Ref. recibo, etc.">
                </div>
                
                <div class="flex gap-2">
                    <button type="button" onclick="document.getElementById('paymentModal').classList.add('hidden')" class="flex-1 bg-gray-100 text-gray-600 py-2 rounded hover:bg-gray-200">Cancelar</button>
                    <button type="submit" class="flex-1 bg-green-600 text-white py-2 rounded font-bold hover:bg-green-700">Confirmar</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function openPaymentModal() {
            document.getElementById('paymentModal').classList.remove('hidden');
            document.querySelector('input[name="monto"]').focus();
        }
    </script>
</body>
</html>
