<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();
checkAccess('cash');

$userId = $_SESSION['user_id'];
$db = Database::getInstance();
$message = '';

// Obtener turno actual
$turno = $db->fetchOne("SELECT * FROM turnos_caja WHERE user_id = ? AND estado = 'abierto'", [$userId]);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        $message = "Error CSRF";
    } else {
        if (isset($_POST['abrir_caja'])) {
            if ($turno) {
                $message = "Ya tienes un turno abierto";
            } else {
                $monto = floatval($_POST['monto_inicial']);
                $sql = "INSERT INTO turnos_caja (user_id, usuario_id, usuario_nombre, monto_inicial, estado, fecha_apertura) VALUES (?, ?, ?, ?, 'abierto', NOW())";
                $db->query($sql, [$userId, $userId, $_SESSION['username'], $monto]);
                header("Location: cash.php");
                exit;
            }
        } elseif (isset($_POST['cerrar_caja'])) {
            if (!$turno) {
                $message = "No tienes turno para cerrar";
            } else {
                $monto_final = floatval($_POST['monto_final']);

                // Calcular sistema
                $ventas = $db->fetchOne("SELECT COALESCE(SUM(total), 0) as total FROM ventas WHERE fecha >= ? AND usuario_id = ?", [$turno['fecha_apertura'], $userId]);
                $total_sistema = $turno['monto_inicial'] + $ventas['total'];
                $diferencia = $monto_final - $total_sistema;

                $sql = "UPDATE turnos_caja SET fecha_cierre = NOW(), estado = 'cerrado', monto_final = ?, ventas_total = ?, diferencia = ? WHERE id = ?";
                $db->query($sql, [$monto_final, $ventas['total'], $diferencia, $turno['id']]);
                header("Location: cash.php?msg=closed");
                exit;
            }
        } elseif (isset($_POST['movimiento'])) {
            if ($turno) {
                $tipo = $_POST['tipo']; // 'ingreso', 'retiro'
                $monto = floatval($_POST['monto']);
                $desc = sanitize($_POST['descripcion']);

                $sql = "INSERT INTO movimientos_caja (turno_id, tipo, monto, descripcion, usuario_id, fecha) VALUES (?, ?, ?, ?, ?, NOW())";
                $db->query($sql, [$turno['id'], $tipo, $monto, $desc, $userId]);
                $message = "Movimiento registrado";
            }
        }
    }
}

// Historial reciente
$historial = $db->fetchAll("SELECT * FROM turnos_caja WHERE user_id = ? ORDER BY fecha_apertura DESC LIMIT 5", [$userId]);

// Generar Token
if (empty($_SESSION['csrf_token']))
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Caja - <?php echo APP_NAME; ?></title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
</head>

<body class="bg-gray-100 flex flex-col min-h-screen pb-10">
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <div class="max-w-4xl mx-auto px-4 py-8 w-full flex-1">
        <?php if ($message): ?>
            <div class="bg-blue-100 border-l-4 border-blue-500 text-blue-700 p-4 mb-4"><?php echo $message; ?></div>
        <?php endif; ?>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Panel de Control de Caja -->
            <div
                class="bg-white rounded-lg shadow-lg p-6 border-t-4 <?php echo $turno ? 'border-green-500' : 'border-red-500'; ?>">
                <h2 class="text-2xl font-bold mb-4 text-gray-800 flex items-center justify-between">
                    <span>
                        <i class="fas fa-cash-register mr-2"></i>Control de Caja
                    </span>
                    <?php if ($turno): ?>
                        <span class="text-xs bg-green-100 text-green-800 px-2 py-1 rounded">TURNO
                            #<?php echo $turno['id']; ?></span>
                    <?php endif; ?>
                </h2>

                <?php if (!$turno): ?>
                    <!-- Formulario Abrir Caja -->
                    <div class="text-center py-4">
                        <i class="fas fa-lock text-red-400 text-5xl mb-3"></i>
                        <p class="text-gray-500 mb-6 font-bold">La caja está cerrada</p>

                        <form method="POST" class="max-w-xs mx-auto text-left">
                            <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                            <label class="block text-xs font-bold text-gray-500 uppercase">Monto Inicial</label>
                            <div class="flex gap-2 mb-4">
                                <input type="number" step="0.01" name="monto_inicial" value="0.00"
                                    class="flex-1 border p-2 rounded text-lg font-bold" autofocus>
                                <button type="submit" name="abrir_caja"
                                    class="bg-green-600 text-white px-4 py-2 rounded font-bold hover:bg-green-700">ABRIR
                                    [F2]</button>
                            </div>
                        </form>
                    </div>
                <?php else: ?>
                    <!-- Info Turno Actual -->
                    <div class="space-y-4">
                        <div class="grid grid-cols-2 gap-4 text-sm">
                            <div class="bg-gray-50 p-3 rounded">
                                <span class="block text-gray-500 text-xs">Inicio</span>
                                <span
                                    class="font-bold text-lg text-gray-800 font-mono-num">$<?php echo number_format($turno['monto_inicial'], 2); ?></span>
                            </div>
                            <div class="bg-gray-50 p-3 rounded">
                                <span class="block text-gray-500 text-xs">Apertura</span>
                                <span
                                    class="font-bold text-gray-800"><?php echo date('H:i', strtotime($turno['fecha_apertura'])); ?></span>
                            </div>
                        </div>

                        <div class="border-t pt-4">
                            <h3 class="font-bold text-gray-700 mb-2">Registrar Movimiento</h3>
                            <form method="POST" class="grid grid-cols-2 gap-2">
                                <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                                <input type="hidden" name="movimiento" value="1">

                                <select name="tipo" class="border p-2 rounded text-sm">
                                    <option value="ingreso">Ingreso (+)</option>
                                    <option value="retiro">Retiro (-)</option>
                                </select>
                                <input type="number" step="0.01" name="monto" placeholder="Monto" required
                                    class="border p-2 rounded text-sm">
                                <input type="text" name="descripcion" placeholder="Motivo" required
                                    class="col-span-2 border p-2 rounded text-sm">
                                <button type="submit"
                                    class="col-span-2 bg-blue-600 text-white py-2 rounded text-sm font-bold hover:bg-blue-700">Registrar</button>
                            </form>
                        </div>

                        <div class="border-t pt-4">
                            <button onclick="document.getElementById('cierreModal').classList.remove('hidden')"
                                class="w-full bg-red-600 text-white py-3 rounded font-bold hover:bg-red-700">
                                <i class="fas fa-lock mr-2"></i>CERRAR TURNO [F2]
                            </button>
                        </div>
                    </div>
                <?php endif; ?>
            </div>

            <!-- Historial -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden border border-gray-200">
                <div class="bg-gray-50 px-4 py-3 border-b border-gray-100">
                    <h3 class="font-bold text-gray-700">Últimos Turnos</h3>
                </div>
                <div class="overflow-x-auto">
                    <table class="dense-table">
                        <thead>
                            <tr>
                                <th>Fecha</th>
                                <th class="text-right">Inicial</th>
                                <th class="text-right">Final</th>
                                <th class="text-center">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($historial as $h): ?>
                                <tr>
                                    <td class="text-xs"><?php echo date('d/m/y H:i', strtotime($h['fecha_apertura'])); ?>
                                    </td>
                                    <td class="text-right font-mono-num text-xs">
                                        $<?php echo number_format($h['monto_inicial'], 2); ?></td>
                                    <td class="text-right font-mono-num text-xs">
                                        <?php echo $h['monto_final'] !== null ? '$' . number_format($h['monto_final'], 2) : '<span class="text-gray-400">-</span>'; ?>
                                    </td>
                                    <td class="text-center">
                                        <?php if ($h['estado'] == 'abierto'): ?>
                                            <span class="text-xs bg-green-100 text-green-800 px-1 rounded">Abierto</span>
                                        <?php else: ?>
                                            <span class="text-xs bg-gray-100 text-gray-600 px-1 rounded">Cerrado</span>
                                        <?php endif; ?>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Cierre -->
    <div id="cierreModal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
        <div class="fixed inset-0 bg-gray-900 bg-opacity-50" onclick="this.parentElement.classList.add('hidden')"></div>
        <div class="bg-white rounded-lg shadow-xl p-6 relative max-w-sm w-full mx-4 z-10">
            <h3 class="text-xl font-bold mb-4 border-b pb-2">Cerrar Caja</h3>
            <form method="POST">
                <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                <div class="mb-4">
                    <label class="block text-sm font-bold text-gray-700 mb-1">Monto en Efectivo (Real)</label>
                    <input type="number" step="0.01" name="monto_final" required
                        class="w-full border-2 border-blue-500 p-2 rounded text-xl font-bold text-right"
                        placeholder="0.00" autofocus>
                    <p class="text-xs text-gray-500 mt-1">Cuente el dinero físico en caja.</p>
                </div>
                <div class="flex gap-2">
                    <button type="button" onclick="document.getElementById('cierreModal').classList.add('hidden')"
                        class="flex-1 bg-gray-200 text-gray-800 py-2 rounded font-bold hover:bg-gray-300">Cancelar</button>
                    <button type="submit" name="cerrar_caja"
                        class="flex-1 bg-red-600 text-white py-2 rounded font-bold hover:bg-red-700">Confirmar</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Shortcuts
        <?php if (!$turno): ?>
            // Shortcut para abrir (foco en monto)
            // Ya es automático por autofocus, pero F2 ayuda
            Shortcuts.register('f2', () => document.querySelector('input[name="monto_inicial"]').focus(), 'Abrir Turno');
        <?php else: ?>
            Shortcuts.register('f2', () => document.getElementById('cierreModal').classList.remove('hidden'), 'Cerrar Turno');
        <?php endif; ?>
    </script>
</body>

</html>