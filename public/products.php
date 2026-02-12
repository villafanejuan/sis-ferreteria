<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();

// Generar token CSRF para seguridad
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

$message = '';
$is_admin = checkAdmin();
$can_manage_products = $is_admin || hasRole('kiosquero'); // Kiosquero puede gestionar (Ferretero)

// --- PROCESAMIENTO DE FORMULARIOS ---
if ($_SERVER['REQUEST_METHOD'] == 'POST' && $can_manage_products) {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        $message = '<div class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Error de seguridad CSRF.</div>';
    } else {
        // AGREGAR
        if (isset($_POST['add_product'])) {
            $nombre = sanitize($_POST['nombre']);
            $descripcion = sanitize($_POST['descripcion']);
            $precio = floatval($_POST['precio']);
            $stock = floatval($_POST['stock']);
            $codigo_barra = sanitize($_POST['codigo_barra'] ?? '');
            $categoria_id = intval($_POST['categoria_id']);
            $unidad_medida_id = !empty($_POST['unidad_medida_id']) ? intval($_POST['unidad_medida_id']) : null;
            $stock_minimo = !empty($_POST['stock_minimo']) ? floatval($_POST['stock_minimo']) : 0;
            $precio_costo = floatval($_POST['precio_costo'] ?? 0);
            $margen_ganancia = floatval($_POST['margen_ganancia'] ?? 0);

            if (empty($nombre) || $precio <= 0) {
                $message = '<div class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Nombre y precio son obligatorios.</div>';
            } else {
                // Check duplicate barcode
                $dup = false;
                if (!empty($codigo_barra)) {
                    $stmt = $pdo->prepare("SELECT id FROM productos WHERE codigo_barra = ?");
                    $stmt->execute([$codigo_barra]);
                    if ($stmt->fetch()) {
                        $message = '<div class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">El código de barras ya existe.</div>';
                        $dup = true;
                    }
                }
                
                if (!$dup) {
                    $sql = "INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id, codigo_barra, unidad_medida_id, stock_minimo, precio_costo, margen_ganancia) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    $stmt = $pdo->prepare($sql);
                    if ($stmt->execute([$nombre, $descripcion, $precio, $stock, $categoria_id, $codigo_barra ?: null, $unidad_medida_id, $stock_minimo, $precio_costo, $margen_ganancia])) {
                        header("Location: products.php?msg=added");
                        exit;
                    } else {
                        $message = '<div class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Error al guardar en BD.</div>';
                    }
                }
            }
        } 
        // ACTUALIZAR
        elseif (isset($_POST['update_product'])) {
             $id = intval($_POST['id']);
             // (Logic similar to add, condensed for brevity/rewrite)
            $nombre = sanitize($_POST['nombre']);
            $descripcion = sanitize($_POST['descripcion']);
            $precio = floatval($_POST['precio']);
            $stock = floatval($_POST['stock']);
            $codigo_barra = sanitize($_POST['codigo_barra'] ?? '');
            $categoria_id = intval($_POST['categoria_id']);
            $unidad_medida_id = !empty($_POST['unidad_medida_id']) ? intval($_POST['unidad_medida_id']) : null;
            $stock_minimo = floatval($_POST['stock_minimo'] ?? 0);
            $precio_costo = floatval($_POST['precio_costo'] ?? 0);
            $margen_ganancia = floatval($_POST['margen_ganancia'] ?? 0);

            $stmt = $pdo->prepare("UPDATE productos SET nombre=?, descripcion=?, precio=?, stock=?, categoria_id=?, codigo_barra=?, unidad_medida_id=?, stock_minimo=?, precio_costo=?, margen_ganancia=?, updated_at=NOW() WHERE id=?");
            if ($stmt->execute([$nombre, $descripcion, $precio, $stock, $categoria_id, $codigo_barra ?: null, $unidad_medida_id, $stock_minimo, $precio_costo, $margen_ganancia, $id])) {
                header("Location: products.php?msg=updated");
                exit;
            }
        }
        // ELIMINAR (Soft)
        elseif (isset($_POST['delete_product'])) {
            $id = intval($_POST['id']);
            $pdo->prepare("UPDATE productos SET deleted_at = NOW() WHERE id = ?")->execute([$id]);
            header("Location: products.php?msg=deleted");
            exit;
        }
    }
}

// Mensajes GET
if (isset($_GET['msg'])) {
    if ($_GET['msg'] == 'added') $message = '<div class="bg-green-100 text-green-700 px-4 py-2 rounded mb-4">Producto agregado correctamente.</div>';
    if ($_GET['msg'] == 'updated') $message = '<div class="bg-blue-100 text-blue-700 px-4 py-2 rounded mb-4">Producto actualizado.</div>';
    if ($_GET['msg'] == 'deleted') $message = '<div class="bg-yellow-100 text-yellow-700 px-4 py-2 rounded mb-4">Producto eliminado.</div>';
}

// Filtros y listado
$show_deleted = isset($_GET['show_deleted']) && $_GET['show_deleted'] == '1' && $is_admin;
$search = $_GET['q'] ?? '';

$sql = "SELECT p.*, c.nombre as categoria, u.abreviatura as unidad 
        FROM productos p 
        LEFT JOIN categorias c ON p.categoria_id = c.id 
        LEFT JOIN unidades_medida u ON p.unidad_medida_id = u.id 
        WHERE ";

if ($show_deleted) {
    $sql .= "p.deleted_at IS NOT NULL";
} else {
    $sql .= "p.deleted_at IS NULL";
}

if (!empty($search)) {
    $sql .= " AND (p.nombre LIKE :search1 OR p.codigo_barra LIKE :search2)";
}

$sql .= " ORDER BY p.nombre LIMIT 100"; // Limit to keep it snappy

$stmt = $pdo->prepare($sql);
if (!empty($search)) {
    $stmt->bindValue(':search1', "%$search%");
    $stmt->bindValue(':search2', "%$search%");
}
$stmt->execute();
$productos = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Datos auxiliares
$categorias = $pdo->query("SELECT * FROM categorias ORDER BY nombre")->fetchAll();
$unidades = $pdo->query("SELECT * FROM unidades_medida ORDER BY nombre")->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos - <?php echo APP_NAME; ?></title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 flex flex-col min-h-screen pb-10">
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <div class="max-w-7xl mx-auto px-4 py-4 w-full flex-1">
        <?php echo $message; ?>

        <!-- Toolbar Superior -->
        <div class="flex justify-between items-center mb-4 bg-white p-3 rounded-lg shadow-sm border border-gray-200">
            <h1 class="text-xl font-bold text-gray-800"><i class="fas fa-boxes mr-2"></i>Catálogo</h1>
            
            <form action="" method="GET" class="flex-1 max-w-lg mx-6 flex gap-2">
                <input type="text" name="q" value="<?php echo htmlspecialchars($search); ?>" 
                       class="flex-1 border border-gray-300 rounded px-3 py-1 text-sm focus:ring-2 focus:ring-blue-500" 
                       placeholder="Buscar por nombre o código... [F3]" id="search_input">
                <button type="submit" class="bg-gray-200 px-3 py-1 rounded hover:bg-gray-300 text-gray-600"><i class="fas fa-search"></i></button>
            </form>

            <div class="flex gap-2">
                <?php if ($can_manage_products): ?>
                    <button onclick="openModal()" class="bg-blue-600 text-white px-3 py-1 rounded text-sm font-bold hover:bg-blue-700 shadow-sm">
                        <i class="fas fa-plus mr-1"></i> [F2] Nuevo
                    </button>
                <?php endif; ?>
                <?php if ($is_admin): ?>
                    <a href="?show_deleted=<?php echo $show_deleted ? '0' : '1'; ?>" class="text-xs text-gray-500 hover:text-red-500 underline flex items-center">
                        <?php echo $show_deleted ? 'Ocultar Eliminados' : 'Ver Papelera'; ?>
                    </a>
                <?php endif; ?>
            </div>
        </div>

        <!-- Tabla Densa -->
        <div class="bg-white rounded-lg shadow border border-gray-200 overflow-hidden">
            <div class="overflow-x-auto max-h-[70vh]">
                <table class="dense-table" id="products_table">
                    <thead class="sticky top-0 shadow-sm">
                        <tr>
                            <th class="w-32">Código</th>
                            <th>Descripción</th>
                            <th>Categoría</th>
                            <th class="text-right">Costo</th>
                            <th class="text-right">Precio</th>
                            <th class="text-right">Stock</th>
                            <th class="w-20 text-center">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($productos as $p): ?>
                            <tr class="group cursor-default hover:bg-gray-50 transition-colors" data-id="<?php echo $p['id']; ?>">
                                <td class="font-mono-num text-xs text-gray-500">
                                    <?php echo $p['codigo_barra'] ? '<i class="fas fa-barcode mr-1 opacity-50"></i>'.$p['codigo_barra'] : '-'; ?>
                                </td>
                                <td>
                                    <div class="font-semibold text-gray-800"><?php echo htmlspecialchars($p['nombre']); ?></div>
                                    <div class="text-xs text-gray-400 truncate w-64"><?php echo htmlspecialchars($p['descripcion']); ?></div>
                                </td>
                                <td><span class="text-xs bg-gray-100 px-2 py-0.5 rounded text-gray-600"><?php echo $p['categoria']; ?></span></td>
                                <td class="text-right font-mono-num text-xs text-gray-400">$<?php echo number_format($p['precio_costo'], 2); ?></td>
                                <td class="text-right font-mono-num font-bold text-gray-800">$<?php echo number_format($p['precio'], 2); ?></td>
                                <td class="text-right">
                                    <span class="font-mono-num font-bold <?php echo $p['stock'] <= $p['stock_minimo'] ? 'text-red-600' : 'text-green-600'; ?>">
                                        <?php echo round($p['stock'], 3); ?> <span class="text-xs font-normal text-gray-400"><?php echo $p['unidad'] ?? 'u'; ?></span>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <?php if ($can_manage_products && !$p['deleted_at']): ?>
                                        <button onclick='editProduct(<?php echo json_encode($p); ?>)' class="text-blue-500 hover:text-blue-700 mx-1" title="Editar [Enter]"><i class="fas fa-edit"></i></button>
                                        <button onclick="confirmDelete(<?php echo $p['id']; ?>, '<?php echo addslashes($p['nombre']); ?>')" class="text-red-400 hover:text-red-600 mx-1" title="Eliminar"><i class="fas fa-trash"></i></button>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                        <?php if (empty($productos)): ?>
                            <tr><td colspan="7" class="text-center py-8 text-gray-400">No se encontraron productos</td></tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Producto (Agregar/Editar) -->
    <div id="productModal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
        <div class="fixed inset-0 bg-gray-900 bg-opacity-50" onclick="closeModal()"></div>
        <div class="bg-white rounded-lg shadow-xl w-full max-w-3xl z-10 overflow-hidden transform transition-all">
            <div class="bg-gray-800 text-white px-4 py-3 flex justify-between items-center">
                <h3 class="font-bold border-l-4 border-yellow-500 pl-2" id="modalTitle">Nuevo Producto</h3>
                <button onclick="closeModal()" class="text-gray-400 hover:text-white"><i class="fas fa-times"></i></button>
            </div>
            <form method="POST" class="p-6">
                <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                <input type="hidden" name="id" id="prodId">
                
                <div class="grid grid-cols-2 gap-4">
                    <!-- Columna 1 -->
                    <div class="space-y-3">
                        <div>
                            <label class="block text-xs font-bold text-gray-500">Nombre *</label>
                            <input type="text" name="nombre" id="prodNombre" required class="w-full border p-2 rounded focus:ring-2 focus:ring-blue-500">
                        </div>
                         <div>
                            <label class="block text-xs font-bold text-gray-500">Código Barras</label>
                            <div class="relative">
                                <i class="fas fa-barcode absolute left-2 top-3 text-gray-400"></i>
                                <input type="text" name="codigo_barra" id="prodCodigo" class="w-full border p-2 pl-8 rounded focus:ring-2 focus:ring-blue-500 font-mono">
                            </div>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500">Categoría *</label>
                            <select name="categoria_id" id="prodCategoria" required class="w-full border p-2 rounded">
                                <?php foreach ($categorias as $c): ?>
                                    <option value="<?php echo $c['id']; ?>"><?php echo $c['nombre']; ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div>
                             <label class="block text-xs font-bold text-gray-500">Descripción</label>
                             <textarea name="descripcion" id="prodDesc" rows="2" class="w-full border p-2 rounded"></textarea>
                        </div>
                    </div>
                    
                    <!-- Columna 2 -->
                    <div class="space-y-3 bg-gray-50 p-3 rounded">
                        <div class="grid grid-cols-2 gap-2">
                            <div>
                                <label class="block text-xs font-bold text-gray-500">Costo</label>
                                <input type="number" step="0.01" name="precio_costo" id="prodCosto" class="w-full border p-2 rounded" oninput="calcPrice()">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500">Margen %</label>
                                <input type="number" step="0.01" name="margen_ganancia" id="prodMargen" value="30" class="w-full border p-2 rounded" oninput="calcPrice()">
                            </div>
                        </div>
                        
                        <div>
                            <label class="block text-xs font-bold text-blue-600">PRECIO VENTA *</label>
                            <input type="number" step="0.01" name="precio" id="prodPrecio" required class="w-full border-2 border-blue-500 p-2 rounded text-lg font-bold">
                        </div>
                        
                        <div class="grid grid-cols-2 gap-2">
                             <div>
                                <label class="block text-xs font-bold text-gray-500">Stock Inicial</label>
                                <input type="number" step="0.001" name="stock" id="prodStock" required value="0" class="w-full border p-2 rounded">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500">Mínimo (Alerta)</label>
                                <input type="number" step="0.001" name="stock_minimo" id="prodMin" value="5" class="w-full border p-2 rounded">
                            </div>
                        </div>
                        
                        <div>
                            <label class="block text-xs font-bold text-gray-500">Unidad Medida</label>
                            <select name="unidad_medida_id" id="prodUnidad" class="w-full border p-2 rounded text-sm">
                                <option value="">Estándar (Unidad)</option>
                                <?php foreach ($unidades as $u): ?>
                                    <option value="<?php echo $u['id']; ?>"><?php echo $u['nombre']; ?> (<?php echo $u['abreviatura']; ?>)</option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="mt-6 flex justify-end gap-3 border-t pt-4">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-gray-600 hover:bg-gray-100 rounded">Cancelar</button>
                    <button type="submit" name="add_product" id="submitBtn" class="bg-blue-600 text-white px-6 py-2 rounded font-bold hover:bg-blue-700">Guardar</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Script de Lógica UI -->
    <script>
        // Teclado Navigation
        let selectedIndex = -1;
        const rows = document.querySelectorAll('#products_table tbody tr');

        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectRow(Math.min(selectedIndex + 1, rows.length - 1));
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectRow(Math.max(selectedIndex - 1, 0));
            } else if (e.key === 'Enter') {
                // Si no hay modal abierto, editar
                if (document.getElementById('productModal').classList.contains('hidden')) {
                    if (selectedIndex >= 0) {
                        const btn = rows[selectedIndex].querySelector('button[title*="Editar"]');
                        if (btn) btn.click();
                    }
                }
            } else if (e.key === 'Delete') {
                // Borrar
                 if (document.getElementById('productModal').classList.contains('hidden')) {
                    if (selectedIndex >= 0) {
                        const btn = rows[selectedIndex].querySelector('button[title*="Eliminar"]');
                        if (btn) btn.click();
                    }
                }
            }
        });

        function selectRow(index) {
            if (index < 0 || index >= rows.length) return;
            if (selectedIndex >= 0) rows[selectedIndex].classList.remove('row-selected');
            selectedIndex = index;
            rows[selectedIndex].classList.add('row-selected');
            rows[selectedIndex].scrollIntoView({block: 'nearest'});
        }

        // Shortcuts Integration
        Shortcuts.register('f2', openModal, 'Nuevo Producto');
        Shortcuts.register('f3', () => document.getElementById('search_input').focus(), 'Buscar');

        // Modal Logic
        function openModal() {
            document.getElementById('modalTitle').innerText = 'Nuevo Producto';
            document.getElementById('submitBtn').name = 'add_product';
            document.getElementById('submitBtn').innerText = 'Guardar';
            
            // Reset fields
            document.getElementById('prodId').value = '';
            document.getElementById('prodNombre').value = '';
            document.getElementById('prodCodigo').value = '';
            document.getElementById('prodDesc').value = '';
            document.getElementById('prodCosto').value = '';
            document.getElementById('prodMargen').value = '30';
            document.getElementById('prodPrecio').value = '';
            document.getElementById('prodStock').value = '0';
            document.getElementById('prodMin').value = '5';
            document.getElementById('prodUnidad').value = '';
            
            document.getElementById('productModal').classList.remove('hidden');
            document.getElementById('prodNombre').focus();
        }

        function editProduct(p) {
            document.getElementById('modalTitle').innerText = 'Editar Producto';
            document.getElementById('submitBtn').name = 'update_product';
            document.getElementById('submitBtn').innerText = 'Actualizar';

            document.getElementById('prodId').value = p.id;
            document.getElementById('prodNombre').value = p.nombre;
            document.getElementById('prodCodigo').value = p.codigo_barra || '';
            document.getElementById('prodDesc').value = p.descripcion || '';
            document.getElementById('prodCosto').value = p.precio_costo;
            document.getElementById('prodMargen').value = p.margen_ganancia;
            document.getElementById('prodPrecio').value = p.precio;
            document.getElementById('prodStock').value = p.stock;
            document.getElementById('prodMin').value = p.stock_minimo;
            document.getElementById('prodUnidad').value = p.unidad_medida_id || '';
            document.getElementById('prodCategoria').value = p.categoria_id;

            document.getElementById('productModal').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('productModal').classList.add('hidden');
        }

        function calcPrice() {
            const costo = parseFloat(document.getElementById('prodCosto').value) || 0;
            const margen = parseFloat(document.getElementById('prodMargen').value) || 0;
            if (costo > 0) {
                const precio = costo * (1 + (margen/100));
                document.getElementById('prodPrecio').value = precio.toFixed(2);
            }
        }

        function confirmDelete(id, name) {
            if(confirm('¿Eliminar "' + name + '"?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.innerHTML = `<input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                                  <input type="hidden" name="delete_product" value="1">
                                  <input type="hidden" name="id" value="${id}">`;
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>