<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();

// Generar token CSRF si no existe
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

$message = '';
$carrito = isset($_SESSION['carrito']) ? $_SESSION['carrito'] : [];
$is_ajax = isset($_POST['ajax']) && $_POST['ajax'] == '1';

// Verificar si hay turno abierto
$stmt = $pdo->prepare("SELECT id FROM turnos_caja WHERE user_id = ? AND estado = 'abierto'");
$stmt->execute([$_SESSION['user_id']]);
$turnoAbierto = $stmt->fetch();

// --- LÓGICA DE BACKEND (AJAX & POST) ---
if ($_SERVER['REQUEST_METHOD'] == 'POST' && $turnoAbierto) {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        if ($is_ajax) {
            echo json_encode(['success' => false, 'message' => 'Error de seguridad. Recarga la página.']);
            exit;
        }
    } else {
        // --- BUSQUEDA DE PRODUCTOS ---
        if (isset($_POST['search_term'])) {
            $term = sanitize($_POST['search_term']);
            // Búsqueda por código exacto primero, luego por nombre
            $sql = "SELECT id, codigo_barra, nombre, precio, stock, unidad_medida 
                    FROM productos 
                    WHERE (codigo_barra = ? OR id = ?)
                    OR nombre LIKE ? 
                    ORDER BY nombre LIMIT 20";
            $stmt = $pdo->prepare($sql);
            $likeTerm = "%$term%";
            $stmt->execute([$term, $term, $likeTerm]);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

            echo json_encode(['success' => true, 'results' => $results]);
            exit;
        }

        // --- AGREGAR AL CARRITO ---
        if (isset($_POST['add_to_cart'])) {
            $producto_id = intval($_POST['producto_id']);
            $cantidad = floatval($_POST['cantidad']); // Soporte DECIMAL

            if ($producto_id > 0 && $cantidad > 0) {
                // Verificar stock
                $stmt = $pdo->prepare("SELECT id, codigo_barra, nombre, precio, stock, unidad_medida FROM productos WHERE id = ?");
                $stmt->execute([$producto_id]);
                $prod = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($prod) {
                    $cantidadActualEnCarrito = isset($carrito[$producto_id]) ? $carrito[$producto_id]['cantidad'] : 0;

                    if (($cantidadActualEnCarrito + $cantidad) > $prod['stock']) {
                        echo json_encode(['success' => false, 'message' => 'Stock insuficiente. Disponible: ' . $prod['stock']]);
                        exit;
                    }

                    if (isset($carrito[$producto_id])) {
                        $carrito[$producto_id]['cantidad'] += $cantidad;
                    } else {
                        $carrito[$producto_id] = [
                            'id' => $prod['id'],
                            'codigo' => $prod['codigo_barra'],
                            'nombre' => $prod['nombre'],
                            'precio' => $prod['precio'],
                            'cantidad' => $cantidad,
                            'unidad' => $prod['unidad_medida'] ?? 'unid'
                        ];
                    }
                    $_SESSION['carrito'] = $carrito;
                    echo json_encode(['success' => true, 'cart' => $carrito, 'total' => calculateTotal($carrito)]);
                    exit;
                }
            }
            echo json_encode(['success' => false, 'message' => 'Producto no válido']);
            exit;
        }

        // --- ELIMINAR DEL CARRITO ---
        if (isset($_POST['remove_item'])) {
            $id = intval($_POST['product_id']);
            unset($carrito[$id]);
            $_SESSION['carrito'] = $carrito;
            echo json_encode(['success' => true, 'cart' => $carrito, 'total' => calculateTotal($carrito)]);
            exit;
        }

        // --- COMPLETAR VENTA ---
        if (isset($_POST['complete_sale'])) {
            if (empty($carrito)) {
                echo json_encode(['success' => false, 'message' => 'El carrito está vacío']);
                exit;
            }

            try {
                $pdo->beginTransaction();

                $total = calculateTotal($carrito);
                $pago = floatval($_POST['amount_paid']);
                $cambio = $pago - $total;

                if ($pago < $total) {
                    throw new Exception("Monto insuficiente");
                }

                // Insertar Venta
                $stmt = $pdo->prepare("INSERT INTO ventas (usuario_id, total, monto_pagado, cambio, fecha) VALUES (?, ?, ?, ?, NOW())");
                $stmt->execute([$_SESSION['user_id'], $total, $pago, $cambio]);
                $ventaId = $pdo->lastInsertId();

                // Detalles y Stock
                foreach ($carrito as $item) {
                    // Verificar stock nuevamente (concurrencia básica)
                    $stmtStock = $pdo->prepare("SELECT stock FROM productos WHERE id = ? FOR UPDATE");
                    $stmtStock->execute([$item['id']]);
                    $stockActual = $stmtStock->fetchColumn();

                    if ($stockActual < $item['cantidad']) {
                        throw new Exception("Stock insuficiente para " . $item['nombre']);
                    }

                    // Insertar detalle
                    $stmtDet = $pdo->prepare("INSERT INTO venta_detalles (venta_id, producto_id, cantidad, precio, subtotal) VALUES (?, ?, ?, ?, ?)");
                    $subtotal = $item['precio'] * $item['cantidad'];
                    $stmtDet->execute([$ventaId, $item['id'], $item['cantidad'], $item['precio'], $subtotal]);

                    // Descontar stock
                    $stmtUpd = $pdo->prepare("UPDATE productos SET stock = stock - ? WHERE id = ?");
                    $stmtUpd->execute([$item['cantidad'], $item['id']]);
                }

                // Movimiento de Caja
                $stmtCaja = $pdo->prepare("INSERT INTO movimientos_caja (turno_id, tipo, monto, descripcion, venta_id, created_at, usuario_id, fecha) VALUES (?, 'venta', ?, ?, ?, NOW(), ?, NOW())");
                $stmtCaja->execute([$turnoAbierto['id'], $total, "Venta #$ventaId", $ventaId, $_SESSION['user_id']]);

                $pdo->commit();

                // Limpiar carrito
                unset($_SESSION['carrito']);

                echo json_encode(['success' => true, 'message' => 'Venta completada', 'change' => $cambio, 'ticket_id' => $ventaId]);
            } catch (Exception $e) {
                $pdo->rollBack();
                echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
            }
            exit;
        }

        // --- CANCELAR VENTA (LIMPIAR) ---
        if (isset($_POST['cancel_sale'])) {
            unset($_SESSION['carrito']);
            echo json_encode(['success' => true]);
            exit;
        }
    }
}

function calculateTotal($cart)
{
    $total = 0;
    foreach ($cart as $item) {
        $total += $item['precio'] * $item['cantidad'];
    }
    return $total;
}

$cartTotal = calculateTotal($carrito);
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POS Ferretería</title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
    <link href="assets/css/styles.css" rel="stylesheet">
    <script src="assets/js/shortcuts.js"></script>
    <style>
        /* Layout específico para Ventas (Split View sin scroll global) */
        body {
            overflow: hidden;
            height: 100vh;
        }

        /* Ajuste para que el contenido ocupe el resto de la altura */
        .flex-1.overflow-hidden {
            height: calc(100vh - 50px);
            /* Ajuste aproximado por el navbar */
        }
    </style>
</head>

<body class="bg-gray-100 flex flex-col">

    <!-- Navbar Global -->
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <?php if (!$turnoAbierto): ?>
        <div class="flex-1 flex items-center justify-center">
            <div class="bg-white p-8 rounded-lg shadow-xl text-center">
                <i class="fas fa-lock text-6xl text-red-500 mb-4"></i>
                <h2 class="text-2xl font-bold text-gray-800">Caja Cerrada</h2>
                <p class="text-gray-600 my-4">Debes abrir un turno para realizar ventas.</p>
                <a href="cash.php" class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700">Ir a Caja</a>
            </div>
        </div>
    <?php else: ?>

        <!-- Contenido Principal (Split View) -->
        <div class="flex flex-1 overflow-hidden">

            <!-- PANEL IZQUIERDO: BUSCADOR Y CATÁLOGO (60%) -->
            <div class="w-3/5 bg-white border-r border-gray-200 flex flex-col">
                <!-- Buscador -->
                <div class="p-3 border-b border-gray-200 bg-gray-50">
                    <label class="block text-xs font-bold text-gray-500 uppercase mb-1">[F2] Buscar Producto (Nombre o
                        Código)</label>
                    <div class="relative">
                        <input type="text" id="search_input"
                            class="w-full border border-gray-300 rounded p-3 pl-10 text-lg font-mono"
                            placeholder="Ej: Tornillo 3mm..." autofocus autocomplete="off">
                        <i class="fas fa-search absolute left-3 top-4 text-gray-400"></i>
                        <div id="search_loading" class="absolute right-3 top-4 hidden">
                            <i class="fas fa-spinner fa-spin text-blue-500"></i>
                        </div>
                    </div>
                </div>

                <!-- Tabla de Resultados -->
                <div class="flex-1 overflow-y-auto p-0">
                    <table class="w-full text-left border-collapse dense-table">
                        <thead class="bg-gray-100 sticky top-0 shadow-sm text-gray-600">
                            <tr>
                                <th class="w-24">Código</th>
                                <th>Descripción</th>
                                <th class="w-20 text-right">Precio</th>
                                <th class="w-20 text-right">Stock</th>
                                <th class="w-32 text-center">Acción</th>
                            </tr>
                        </thead>
                        <tbody id="results_body" class="divide-y divide-gray-100">
                            <!-- Resultados AJAX aquí -->
                            <tr class="text-gray-400 text-center">
                                <td colspan="5" class="py-10">Escribe para buscar...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Info Panel inferior -->
                <div class="p-2 bg-gray-50 border-t border-gray-200 text-xs text-gray-500 flex justify-between">
                    <span><kbd class="bg-white border rounded px-1">↓/↑</kbd> Navegar</span>
                    <span><kbd class="bg-white border rounded px-1">Enter</kbd> Agregar</span>
                    <span><kbd class="bg-white border rounded px-1">F2</kbd> Foco Buscar</span>
                </div>
            </div>

            <!-- PANEL DERECHO: CARRITO Y COBRO (40%) -->
            <div class="w-2/5 bg-gray-50 flex flex-col h-full shadow-inner">
                <!-- Título -->
                <div class="p-3 bg-white border-b border-gray-200 flex justify-between items-center">
                    <h2 class="font-bold text-gray-800"><i class="fas fa-shopping-cart text-blue-600 mr-2"></i>Ticket de
                        Venta</h2>
                    <button onclick="clearCart()" class="text-red-500 text-xs hover:underline">[F4] Cancelar Todo</button>
                </div>

                <!-- Lista de Items -->
                <div class="flex-1 overflow-y-auto p-2">
                    <table class="w-full bg-white shadow-sm rounded overflow-hidden dense-table">
                        <thead class="bg-blue-50 text-blue-800 text-xs uppercase">
                            <tr>
                                <th>Cant.</th>
                                <th>Producto</th>
                                <th class="text-right">Total</th>
                                <th class="w-8"></th>
                            </tr>
                        </thead>
                        <tbody id="cart_body" class="divide-y divide-gray-100 text-sm">
                            <?php if (empty($carrito)): ?>
                                <tr id="empty_cart_msg">
                                    <td colspan="4" class="text-center py-8 text-gray-400">Carrito vacío</td>
                                </tr>
                            <?php else: ?>
                                <?php foreach ($carrito as $item): ?>
                                    <tr>
                                        <td class="font-mono font-bold w-16 text-center"><?php echo $item['cantidad']; ?></td>
                                        <td><?php echo htmlspecialchars($item['nombre']); ?>
                                            <div class="text-xs text-gray-500">$<?php echo number_format($item['precio'], 2); ?>
                                                unit.</div>
                                        </td>
                                        <td class="text-right font-bold">
                                            $<?php echo number_format($item['precio'] * $item['cantidad'], 2); ?></td>
                                        <td class="text-center"><button onclick="removeItem(<?php echo $item['id']; ?>)"
                                                class="text-red-400 hover:text-red-600"><i class="fas fa-times"></i></button></td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>

                <!-- Panel de Totales y Pago -->
                <div class="bg-white p-4 border-t border-gray-200 shadow-lg z-10">
                    <div class="flex justify-between items-end mb-4">
                        <span class="text-gray-500 text-lg">Total a Pagar:</span>
                        <span class="text-4xl font-bold text-gray-800"
                            id="display_total">$<?php echo number_format($cartTotal, 2); ?></span>
                    </div>

                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <div class="relative">
                            <label class="block text-xs text-gray-500 uppercase font-bold mb-1">Monto Abonado</label>
                            <div class="relative">
                                <span class="absolute left-3 top-2 text-gray-400">$</span>
                                <input type="number" id="amount_paid"
                                    class="w-full border border-gray-300 rounded p-2 pl-6 text-xl font-bold text-gray-700 bg-gray-50"
                                    placeholder="0.00" step="0.01">
                            </div>
                        </div>
                        <div>
                            <label class="block text-xs text-gray-500 uppercase font-bold mb-1">Su Cambio</label>
                            <div class="text-xl font-bold text-green-600 p-2 text-right bg-green-50 rounded border border-green-100"
                                id="change_display">$0.00</div>
                        </div>
                    </div>

                    <input type="hidden" id="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">

                    <button id="btn_checkout" onclick="completeSale()"
                        class="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-4 rounded shadow-lg text-lg uppercase tracking-wide transition transform active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed">
                        [F9] CONFIRMAR VENTA
                    </button>
                </div>
            </div>
        </div>

        <!-- Modal de Cantidad -->
        <div id="qty_modal" class="fixed inset-0 bg-black bg-opacity-50 hidden z-50 flex items-center justify-center">
            <div class="bg-white rounded-lg shadow-xl p-6 w-80">
                <h3 class="text-lg font-bold mb-4" id="modal_product_name">Producto</h3>
                <p class="text-sm text-gray-500 mb-2">Precio: $<span id="modal_price">0.00</span> | Stock: <span
                        id="modal_stock">0.00</span></p>
                <label class="block text-xs font-bold uppercase mb-1">Cantidad:</label>
                <input type="number" id="modal_qty"
                    class="w-full border-2 border-blue-500 rounded p-3 text-2xl text-center font-bold mb-4" step="0.001"
                    min="0.001">
                <div class="flex gap-2">
                    <button onclick="confirmAddToCart()"
                        class="flex-1 bg-blue-600 text-white py-2 rounded font-bold hover:bg-blue-700">Agregar</button>
                    <button onclick="closeModal()"
                        class="flex-1 bg-gray-300 text-gray-700 py-2 rounded hover:bg-gray-400">Cancelar</button>
                </div>
            </div>
        </div>

        <script>
            // --- ESTADO GLOBAL ---
            let currentSelectionIndex = -1;
            let productsCache = [];
            let selectedProductForModal = null;
            let cartTotal = <?php echo floatval($cartTotal); ?>;

            // --- INICIALIZACIÓN ---
            document.addEventListener('DOMContentLoaded', () => {
                document.getElementById('search_input').focus();
                updateChange();
            });

            // --- EVENTOS DE TECLADO GLOBALES ---
            document.addEventListener('keydown', (e) => {
                if (e.key === 'F2') {
                    e.preventDefault();
                    document.getElementById('search_input').focus();
                    document.getElementById('search_input').select();
                }
                if (e.key === 'F9') {
                    e.preventDefault();
                    if (!document.getElementById('btn_checkout').disabled) {
                        completeSale();
                    }
                }
                if (e.key === 'F4') {
                    e.preventDefault();
                    if (confirm('¿Vaciar carrito?')) clearCart();
                }
                if (e.key === 'Escape') {
                    closeModal();
                }
            });

            // --- BUSCADOR ---
            const searchInput = document.getElementById('search_input');
            let debounceTimer;

            searchInput.addEventListener('input', (e) => {
                clearTimeout(debounceTimer);
                const term = e.target.value.trim();
                if (term.length < 2) {
                    document.getElementById('results_body').innerHTML = '<tr class="text-gray-400 text-center"><td colspan="5" class="py-10">Escribe para buscar...</td></tr>';
                    return;
                }

                document.getElementById('search_loading').classList.remove('hidden');
                debounceTimer = setTimeout(() => searchProducts(term), 300);
            });

            // Navegación en resultados
            searchInput.addEventListener('keydown', (e) => {
                const rows = document.querySelectorAll('#results_body tr');
                if (rows.length === 0 || rows[0].innerText.includes('Escribe para buscar')) return;

                if (e.key === 'ArrowDown') {
                    e.preventDefault();
                    currentSelectionIndex = Math.min(currentSelectionIndex + 1, rows.length - 1);
                    highlightRow(rows);
                } else if (e.key === 'ArrowUp') {
                    e.preventDefault();
                    currentSelectionIndex = Math.max(currentSelectionIndex - 1, 0);
                    highlightRow(rows);
                } else if (e.key === 'Enter') {
                    e.preventDefault();
                    if (currentSelectionIndex >= 0 && productsCache[currentSelectionIndex]) {
                        openQtyModal(productsCache[currentSelectionIndex]);
                    }
                }
            });

            function highlightRow(rows) {
                rows.forEach((r, i) => {
                    if (i === currentSelectionIndex) r.classList.add('row-selected');
                    else r.classList.remove('row-selected');
                });
                // Scroll to view
                if (rows[currentSelectionIndex]) {
                    rows[currentSelectionIndex].scrollIntoView({ block: 'nearest' });
                }
            }

            async function searchProducts(term) {
                const formData = new FormData();
                formData.append('csrf_token', document.getElementById('csrf_token').value);
                formData.append('search_term', term);

                try {
                    const res = await fetch('sales.php', { method: 'POST', body: formData, headers: { 'X-Requested-With': 'XMLHttpRequest' } }); // Send header manually? No, usually auto if jQuery, but fetch needs manual check in PHP or extra header. PHP check is simpler. Actually my PHP code doesn't check header for search strictly, loops through POST.

                    // My PHP code checks 'ajax' param for some things but search_term is independent logic block.
                    // Let's ensure we send ajax=1
                    formData.append('ajax', '1');

                    const data = await res.json();
                    document.getElementById('search_loading').classList.add('hidden');

                    if (data.success) {
                        productsCache = data.results;
                        renderResults(data.results);
                    }
                } catch (err) {
                    console.error(err);
                }
            }

            function renderResults(products) {
                const tbody = document.getElementById('results_body');
                tbody.innerHTML = '';
                currentSelectionIndex = -1;

                if (products.length === 0) {
                    tbody.innerHTML = '<tr class="text-gray-400 text-center"><td colspan="5" class="py-10">No se encontraron productos</td></tr>';
                    return;
                }

                products.forEach((prod, index) => {
                    const tr = document.createElement('tr');
                    tr.className = 'border-b border-gray-50 hover:bg-gray-50 cursor-pointer';
                    tr.onclick = () => openQtyModal(prod);
                    /* 
                       Formato decimal stock: parseFloat(stock) removes trailing zeros if unwanted, 
                       or toFixed(3) to keep them. Ferreteria usually likes seeing 3 decimals for kg/m.
                    */
                    tr.innerHTML = `
                    <td class="font-mono text-xs text-gray-500">${prod.codigo_barra || prod.id}</td>
                    <td class="font-medium text-gray-800">${prod.nombre}</td>
                    <td class="text-right font-bold text-blue-600">$${parseFloat(prod.precio).toFixed(2)}</td>
                    <td class="text-right ${parseFloat(prod.stock) <= 0 ? 'text-red-500 font-bold' : 'text-green-600'}">${parseFloat(prod.stock).toFixed(3)} ${prod.unidad_medida || 'u'}</td>
                    <td class="text-center"><button class="text-xs bg-blue-100 text-blue-600 px-2 py-1 rounded hover:bg-blue-200">Seleccionar</button></td>
                `;
                    tbody.appendChild(tr);
                });

                // Validar selección inicial
                if (products.length > 0) {
                    currentSelectionIndex = 0;
                    highlightRow(tbody.querySelectorAll('tr'));
                }
            }

            // --- MODAL CANTIDAD ---
            const qtyModal = document.getElementById('qty_modal');
            const qtyInput = document.getElementById('modal_qty');

            function openQtyModal(product) {
                selectedProductForModal = product;
                document.getElementById('modal_product_name').innerText = product.nombre;
                document.getElementById('modal_price').innerText = parseFloat(product.precio).toFixed(2);
                document.getElementById('modal_stock').innerText = parseFloat(product.stock).toFixed(3);

                qtyInput.value = '1';
                qtyModal.classList.remove('hidden');
                qtyInput.focus();
                qtyInput.select();
            }

            function closeModal() {
                qtyModal.classList.add('hidden');
                document.getElementById('search_input').focus();
                selectedProductForModal = null;
            }

            // Evento Enter en Modal
            qtyInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') confirmAddToCart();
            });

            async function confirmAddToCart() {
                if (!selectedProductForModal) return;
                const qty = parseFloat(qtyInput.value);
                if (qty <= 0) return alert('Cantidad inválida');

                const formData = new FormData();
                formData.append('csrf_token', document.getElementById('csrf_token').value);
                formData.append('ajax', '1');
                formData.append('add_to_cart', '1');
                formData.append('producto_id', selectedProductForModal.id);
                formData.append('cantidad', qty);

                try {
                    const res = await fetch('sales.php', { method: 'POST', body: formData });
                    const data = await res.json();

                    if (data.success) {
                        renderCart(data.cart);
                        updateTotal(data.total);
                        closeModal();
                        // Limpiar búsqueda para siguiente item
                        document.getElementById('search_input').value = '';
                        document.getElementById('results_body').innerHTML = '<tr class="text-gray-400 text-center"><td colspan="5" class="py-10">Escribe para buscar...</td></tr>';
                        document.getElementById('search_input').focus();
                    } else {
                        alert(data.message);
                        qtyInput.select(); // Mantener foco en error
                    }
                } catch (err) {
                    console.error(err);
                    alert('Error al agregar producto');
                }
            }

            // --- CARRITO ---
            function renderCart(cartItems) {
                const tbody = document.getElementById('cart_body');
                tbody.innerHTML = '';

                if (Object.keys(cartItems).length === 0) {
                    tbody.innerHTML = '<tr id="empty_cart_msg"><td colspan="4" class="text-center py-8 text-gray-400">Carrito vacío</td></tr>';
                    return;
                }

                // Convert object to array if needed, session array comes as object from JSON sometimes if indices are IDs
                Object.values(cartItems).forEach(item => {
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                    <td class="font-mono font-bold w-16 text-center">${parseFloat(item.cantidad).toFixed(3).replace(/\.000$/, '')}</td>
                    <td>${item.nombre}<div class="text-xs text-gray-500">$${parseFloat(item.precio).toFixed(2)} unit.</div></td>
                    <td class="text-right font-bold">$${(item.precio * item.cantidad).toFixed(2)}</td>
                    <td class="text-center"><button onclick="removeItem(${item.id})" class="text-red-400 hover:text-red-600"><i class="fas fa-times"></i></button></td>
                `;
                    tbody.appendChild(tr);
                });
            }

            async function removeItem(id) {
                const formData = new FormData();
                formData.append('csrf_token', document.getElementById('csrf_token').value);
                formData.append('ajax', '1');
                formData.append('remove_item', '1');
                formData.append('product_id', id);

                const res = await fetch('sales.php', { method: 'POST', body: formData });
                const data = await res.json();
                if (data.success) {
                    renderCart(data.cart);
                    updateTotal(data.total);
                }
            }

            async function clearCart() {
                const formData = new FormData();
                formData.append('csrf_token', document.getElementById('csrf_token').value);
                formData.append('ajax', '1');
                formData.append('cancel_sale', '1');

                const res = await fetch('sales.php', { method: 'POST', body: formData });
                const data = await res.json();
                if (data.success) {
                    renderCart({});
                    updateTotal(0);
                }
            }

            // --- PAGO ---
            function updateTotal(total) {
                cartTotal = parseFloat(total);
                document.getElementById('display_total').innerText = '$' + cartTotal.toFixed(2);
                updateChange();
            }

            const amountInput = document.getElementById('amount_paid');
            amountInput.addEventListener('input', updateChange);

            function updateChange() {
                const paid = parseFloat(amountInput.value) || 0;
                const change = paid - cartTotal;
                const changeDisplay = document.getElementById('change_display');
                const btn = document.getElementById('btn_checkout');

                if (change >= 0 && cartTotal > 0) {
                    changeDisplay.innerText = '$' + change.toFixed(2);
                    changeDisplay.classList.remove('text-red-600');
                    changeDisplay.classList.add('text-green-600');
                    btn.disabled = false;
                } else {
                    changeDisplay.innerText = 'Faltan: $' + Math.abs(change).toFixed(2);
                    changeDisplay.classList.add('text-red-600');
                    changeDisplay.classList.remove('text-green-600');
                    btn.disabled = true;
                }

                if (cartTotal === 0) {
                    changeDisplay.innerText = '$0.00';
                    btn.disabled = true;
                }
            }

            async function completeSale() {
                const paid = parseFloat(amountInput.value) || 0;
                if (paid < cartTotal) return alert('Monto insuficiente');

                if (!confirm('¿Confirmar venta?')) return;

                const formData = new FormData();
                formData.append('csrf_token', document.getElementById('csrf_token').value);
                formData.append('ajax', '1');
                formData.append('complete_sale', '1');
                formData.append('amount_paid', paid);

                try {
                    const res = await fetch('sales.php', { method: 'POST', body: formData });
                    const data = await res.json();

                    if (data.success) {
                        alert(`¡Venta Exitosa!\nTicket #${data.ticket_id}\nCambio: $${parseFloat(data.change).toFixed(2)}`);
                        window.location.reload(); // Recargar para limpiar todo y volver estado inicial
                    } else {
                        alert(data.message);
                    }
                } catch (err) {
                    console.error(err);
                    alert('Error al procesar venta');
                }
            }
        </script>
    <?php endif; ?>
</body>

</html>