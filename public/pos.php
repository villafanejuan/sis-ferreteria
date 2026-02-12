<?php
/**
 * POS - Punto de Venta Profesional
 * Interfaz moderna para ventas rápidas en ferretería
 */

require_once __DIR__ . '/../app/bootstrap.php';
checkSession();

// Generar token CSRF
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

// Verificar turno abierto
$stmt = $pdo->prepare("SELECT id, monto_inicial FROM turnos_caja WHERE user_id = ? AND estado = 'abierto'");
$stmt->execute([$_SESSION['user_id']]);
$turnoAbierto = $stmt->fetch();

// Procesar venta
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['process_sale'])) {
    if (!$turnoAbierto) {
        echo json_encode(['success' => false, 'message' => 'Debes abrir un turno de caja primero']);
        exit;
    }

    // Verificar CSRF
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        echo json_encode(['success' => false, 'message' => 'Error de seguridad']);
        exit;
    }

    try {
        $cart = json_decode($_POST['cart'], true);
        $total = floatval($_POST['total']);
        $amount_paid = floatval($_POST['amount_paid']);
        $payment_method = sanitize($_POST['payment_method']);
        $customer_id = !empty($_POST['customer_id']) ? intval($_POST['customer_id']) : null;

        if (empty($cart) || $total <= 0) {
            echo json_encode(['success' => false, 'message' => 'Carrito vacío']);
            exit;
        }

        if ($amount_paid < $total) {
            echo json_encode(['success' => false, 'message' => 'Monto insuficiente']);
            exit;
        }

        $change = $amount_paid - $total;

        // Iniciar transacción
        $pdo->beginTransaction();

        // Insertar venta
        $stmt = $pdo->prepare("
            INSERT INTO ventas (
                usuario_id, cliente_id, total, monto_pagado, cambio, 
                metodo_pago, estado, fecha
            ) VALUES (?, ?, ?, ?, ?, ?, 'completada', NOW())
        ");
        $stmt->execute([
            $_SESSION['user_id'],
            $customer_id,
            $total,
            $amount_paid,
            $change,
            $payment_method
        ]);
        $venta_id = $pdo->lastInsertId();

        // Insertar items y actualizar stock
        foreach ($cart as $item) {
            // Verificar stock actual
            $stmt = $pdo->prepare("SELECT stock, precio, precio_costo FROM productos WHERE id = ?");
            $stmt->execute([$item['id']]);
            $producto = $stmt->fetch();

            if (!$producto || $producto['stock'] < $item['quantity']) {
                $pdo->rollBack();
                echo json_encode(['success' => false, 'message' => 'Stock insuficiente para ' . $item['nombre']]);
                exit;
            }

            // Insertar detalle de venta
            $subtotal = $item['precio'] * $item['quantity'];
            $stmt = $pdo->prepare("
                INSERT INTO venta_detalles (
                    venta_id, producto_id, cantidad, precio, subtotal, precio_costo
                ) VALUES (?, ?, ?, ?, ?, ?)
            ");
            $stmt->execute([
                $venta_id,
                $item['id'],
                $item['quantity'],
                $item['precio'],
                $subtotal,
                $producto['precio_costo']
            ]);

            // Actualizar stock
            $stmt = $pdo->prepare("UPDATE productos SET stock = stock - ? WHERE id = ?");
            $stmt->execute([$item['quantity'], $item['id']]);
        }

        // Registrar movimiento de caja
        $stmt = $pdo->prepare("
            INSERT INTO movimientos_caja (
                turno_id, tipo, monto, descripcion, venta_id, 
                usuario_id, fecha, created_at
            ) VALUES (?, 'venta', ?, ?, ?, ?, NOW(), NOW())
        ");
        $stmt->execute([
            $turnoAbierto['id'],
            $total,
            'Venta #' . $venta_id . ' - ' . $payment_method,
            $venta_id,
            $_SESSION['user_id']
        ]);

        $pdo->commit();

        echo json_encode([
            'success' => true,
            'message' => 'Venta completada exitosamente',
            'venta_id' => $venta_id,
            'total' => $total,
            'change' => $change
        ]);
        exit;

    } catch (Exception $e) {
        $pdo->rollBack();
        echo json_encode(['success' => false, 'message' => 'Error al procesar venta: ' . $e->getMessage()]);
        exit;
    }
}

// Obtener estadísticas rápidas
$stats = [];
if ($turnoAbierto) {
    // Ventas del turno
    $stmt = $pdo->prepare("
        SELECT COUNT(*) as total_ventas, COALESCE(SUM(total), 0) as total_monto
        FROM ventas 
        WHERE usuario_id = ? AND DATE(fecha) = CURDATE()
    ");
    $stmt->execute([$_SESSION['user_id']]);
    $stats = $stmt->fetch();
}

$pageTitle = 'POS - Punto de Venta';
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <?php echo $pageTitle; ?> -
        <?php echo APP_NAME; ?>
    </title>
    <script src="../assets/js/tailwindcss.js"></script>
    <link href="../assets/css/fontawesome.min.css" rel="stylesheet">
    <link href="../assets/css/pos.css" rel="stylesheet">
</head>

<body class="bg-gray-100">
    <!-- Navegación -->
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <!-- Notificaciones -->
    <div id="notifications" class="fixed top-20 right-4 z-50"></div>

    <div class="container mx-auto px-4 py-6">
        <?php if (!$turnoAbierto): ?>
            <!-- Mensaje: Caja Cerrada -->
            <div class="max-w-2xl mx-auto mt-12">
                <div class="bg-white rounded-xl shadow-lg p-8 text-center">
                    <div class="inline-flex items-center justify-center w-20 h-20 bg-yellow-100 rounded-full mb-4">
                        <i class="fas fa-lock text-yellow-600 text-4xl"></i>
                    </div>
                    <h2 class="text-3xl font-bold text-gray-800 mb-3">Caja Cerrada</h2>
                    <p class="text-gray-600 text-lg mb-6">
                        Debes abrir un turno de caja para comenzar a vender
                    </p>
                    <a href="cash.php"
                        class="inline-flex items-center px-6 py-3 bg-green-600 hover:bg-green-700 text-white font-bold rounded-lg shadow-lg transition transform hover:scale-105">
                        <i class="fas fa-cash-register mr-2"></i>
                        Abrir Caja
                    </a>
                </div>
            </div>
        <?php else: ?>
            <!-- Header POS -->
            <div class="bg-white rounded-lg shadow-md p-4 mb-4">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-2xl font-bold text-gray-800 flex items-center">
                            <i class="fas fa-cash-register text-blue-600 mr-3"></i>
                            Punto de Venta
                        </h1>
                        <p class="text-sm text-gray-500 mt-1">
                            <i class="fas fa-user mr-1"></i>
                            <?php echo htmlspecialchars($_SESSION['username']); ?>
                            <span class="mx-2">•</span>
                            <i class="fas fa-calendar mr-1"></i>
                            <?php echo date('d/m/Y H:i'); ?>
                        </p>
                    </div>
                    <div class="text-right">
                        <p class="text-sm text-gray-500">Ventas de hoy</p>
                        <p class="text-2xl font-bold text-green-600">
                            $
                            <?php echo number_format($stats['total_monto'] ?? 0, 2); ?>
                        </p>
                        <p class="text-xs text-gray-400">
                            <?php echo $stats['total_ventas'] ?? 0; ?> ventas
                        </p>
                    </div>
                </div>
            </div>

            <!-- Layout Principal POS -->
            <div class="pos-container">
                <!-- Panel Izquierdo: Búsqueda y Productos -->
                <div class="search-panel">
                    <div class="search-header">
                        <!-- Búsqueda por Nombre -->
                        <div class="mb-4">
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                <i class="fas fa-search mr-1"></i> Buscar Producto
                                <span class="keyboard-shortcut">F2</span>
                            </label>
                            <div class="relative">
                                <input type="text" id="pos_search" placeholder="Escribe para buscar productos..."
                                    class="search-input w-full" autofocus>
                                <div id="search_results" class="relative"></div>
                            </div>
                        </div>

                        <!-- Escáner de Código de Barras -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-2">
                                <i class="fas fa-barcode mr-1"></i> Código de Barras
                                <span class="keyboard-shortcut">F3</span>
                            </label>
                            <input type="text" id="barcode_scanner" placeholder="Escanea o escribe el código..."
                                class="search-input w-full font-mono">
                        </div>
                    </div>

                    <!-- Instrucciones -->
                    <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 mt-4">
                        <h3 class="font-semibold text-blue-900 mb-2">
                            <i class="fas fa-keyboard mr-1"></i> Atajos de Teclado
                        </h3>
                        <div class="grid grid-cols-2 gap-2 text-sm text-blue-800">
                            <div><kbd class="px-2 py-1 bg-white rounded">F1</kbd> Nueva venta</div>
                            <div><kbd class="px-2 py-1 bg-white rounded">F2</kbd> Buscar</div>
                            <div><kbd class="px-2 py-1 bg-white rounded">F3</kbd> Escáner</div>
                            <div><kbd class="px-2 py-1 bg-white rounded">ESC</kbd> Limpiar</div>
                        </div>
                    </div>
                </div>

                <!-- Panel Derecho: Carrito y Pago -->
                <div class="cart-panel">
                    <!-- Header del Carrito -->
                    <div class="cart-header">
                        <div class="flex items-center justify-between">
                            <h2 class="text-xl font-bold text-gray-800 flex items-center">
                                <i class="fas fa-shopping-cart text-purple-600 mr-2"></i>
                                Carrito
                                <span id="cart_count"
                                    class="hidden ml-2 px-2 py-1 bg-purple-100 text-purple-800 text-sm font-bold rounded-full"></span>
                            </h2>
                            <button onclick="clearCart()"
                                class="text-red-500 hover:text-red-700 text-sm font-medium transition"
                                title="Vaciar carrito (F1)">
                                <i class="fas fa-trash-alt mr-1"></i> Vaciar
                            </button>
                        </div>
                    </div>

                    <!-- Items del Carrito -->
                    <div id="cart_items" class="cart-items-container custom-scrollbar">
                        <div class="text-center py-12 text-gray-400">
                            <i class="fas fa-shopping-cart text-6xl mb-4 opacity-20"></i>
                            <p class="text-lg">Carrito vacío</p>
                            <p class="text-sm">Busca productos para agregar</p>
                        </div>
                    </div>

                    <!-- Footer del Carrito: Total y Pago -->
                    <div class="cart-footer">
                        <!-- Total -->
                        <div class="bg-gray-50 rounded-lg p-4 mb-4">
                            <div class="flex justify-between items-center">
                                <span class="text-gray-600 font-medium">Total a Pagar</span>
                                <span id="cart_total" class="text-3xl font-bold text-gray-900">$0.00</span>
                            </div>
                        </div>

                        <!-- Sección de Pago -->
                        <div id="payment_section" class="hidden space-y-4">
                            <!-- Método de Pago -->
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-2">
                                    Método de Pago
                                </label>
                                <select id="payment_method"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                    <option value="efectivo">💵 Efectivo</option>
                                    <option value="tarjeta_debito">💳 Tarjeta Débito</option>
                                    <option value="tarjeta_credito">💳 Tarjeta Crédito</option>
                                    <option value="transferencia">🏦 Transferencia</option>
                                    <option value="cuenta_corriente">📋 Cuenta Corriente</option>
                                </select>
                            </div>

                            <!-- Monto Pagado -->
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 mb-2">
                                    Monto Recibido
                                </label>
                                <div class="relative">
                                    <span
                                        class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-500 font-bold">$</span>
                                    <input type="number" id="amount_paid" step="0.01" min="0" placeholder="0.00"
                                        class="w-full pl-8 pr-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 text-lg font-semibold"
                                        oninput="calculateChange()">
                                </div>

                                <!-- Botones de Cantidad Rápida -->
                                <div class="grid grid-cols-4 gap-2 mt-2">
                                    <button onclick="quickAmount(1000)" class="quick-amount-btn text-xs">+$1000</button>
                                    <button onclick="quickAmount(2000)" class="quick-amount-btn text-xs">+$2000</button>
                                    <button onclick="quickAmount(5000)" class="quick-amount-btn text-xs">+$5000</button>
                                    <button onclick="setExactAmount()"
                                        class="quick-amount-btn text-xs bg-blue-100">Exacto</button>
                                </div>
                            </div>

                            <!-- Vuelto -->
                            <div class="bg-green-50 border border-green-200 rounded-lg p-3">
                                <div class="flex justify-between items-center">
                                    <span class="text-green-700 font-medium">Vuelto</span>
                                    <span id="change_display" class="text-2xl font-bold text-gray-400">$0.00</span>
                                </div>
                            </div>

                            <!-- Botón Cobrar -->
                            <button id="checkout_btn" onclick="processCheckout()" disabled
                                class="checkout-btn w-full opacity-50 cursor-not-allowed">
                                <i class="fas fa-check-circle mr-2"></i>
                                COBRAR
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        <?php endif; ?>
    </div>

    <!-- Hidden Form para enviar venta -->
    <form id="sale_form" method="POST" style="display: none;">
        <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
        <input type="hidden" name="process_sale" value="1">
        <input type="hidden" name="cart" id="cart_data">
        <input type="hidden" name="total" id="total_data">
        <input type="hidden" name="amount_paid" id="amount_paid_data">
        <input type="hidden" name="payment_method" id="payment_method_data">
        <input type="hidden" name="customer_id" id="customer_id_data">
    </form>

    <!-- Scripts -->
    <script src="../assets/js/pos.js"></script>
    <script>
        // Procesar checkout
        async function processCheckout() {
            if (Object.keys(POS.cart).length === 0) {
                showNotification('El carrito está vacío', 'error');
                return;
            }

            const amountPaid = parseFloat(document.getElementById('amount_paid').value || 0);
            if (amountPaid < POS.total) {
                showNotification('El monto recibido es insuficiente', 'error');
                return;
            }

            if (!confirm('¿Confirmar venta por $' + POS.total.toFixed(2) + '?')) {
                return;
            }

            // Preparar datos
            document.getElementById('cart_data').value = JSON.stringify(POS.cart);
            document.getElementById('total_data').value = POS.total;
            document.getElementById('amount_paid_data').value = amountPaid;
            document.getElementById('payment_method_data').value = document.getElementById('payment_method').value;

            // Enviar formulario
            const formData = new FormData(document.getElementById('sale_form'));

            try {
                const response = await fetch('pos.php', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();

                if (data.success) {
                    showNotification('✓ Venta #' + data.venta_id + ' completada - Vuelto: $' + data.change.toFixed(2), 'success');

                    // Limpiar carrito y recargar
                    POS.cart = {};
                    updateCartUI();
                    document.getElementById('amount_paid').value = '';
                    document.getElementById('pos_search').focus();

                    // Recargar página después de 2 segundos
                    setTimeout(() => location.reload(), 2000);
                } else {
                    showNotification(data.message, 'error');
                }
            } catch (error) {
                console.error('Error:', error);
                showNotification('Error al procesar la venta', 'error');
            }
        }
    </script>
</body>

</html>