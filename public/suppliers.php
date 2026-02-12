<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();

// Verificar acceso (Solo Admin puede gestionar proveedores)
if (!canAccess('products')) {
    header('Location: dashboard.php');
    exit;
}

// Generar token CSRF
if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

$message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Error de seguridad.</div>';
    } else {
        if (isset($_POST['add_supplier'])) {
            $nombre = sanitize($_POST['nombre']);
            $razon_social = sanitize($_POST['razon_social']);
            $cuit = sanitize($_POST['cuit']);
            $telefono = sanitize($_POST['telefono']);
            $email = sanitize($_POST['email']);
            $direccion = sanitize($_POST['direccion']);
            $localidad = sanitize($_POST['localidad']);
            $provincia = sanitize($_POST['provincia']);
            $contacto_nombre = sanitize($_POST['contacto_nombre']);
            $contacto_telefono = sanitize($_POST['contacto_telefono']);
            $notas = sanitize($_POST['notas']);

            if (empty($nombre)) {
                $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Nombre de proveedor requerido.</div>';
            } else {
                $stmt = $pdo->prepare("INSERT INTO proveedores (nombre, razon_social, cuit, telefono, email, direccion, localidad, provincia, contacto_nombre, contacto_telefono, notas) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                if ($stmt->execute([$nombre, $razon_social, $cuit, $telefono, $email, $direccion, $localidad, $provincia, $contacto_nombre, $contacto_telefono, $notas])) {
                    $message = '<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">Proveedor agregado exitosamente.</div>';
                } else {
                    $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Error al agregar proveedor.</div>';
                }
            }
        } elseif (isset($_POST['update_supplier'])) {
            $id = intval($_POST['id']);
            $nombre = sanitize($_POST['nombre']);
            $razon_social = sanitize($_POST['razon_social']);
            $cuit = sanitize($_POST['cuit']);
            $telefono = sanitize($_POST['telefono']);
            $email = sanitize($_POST['email']);
            $direccion = sanitize($_POST['direccion']);
            $localidad = sanitize($_POST['localidad']);
            $provincia = sanitize($_POST['provincia']);
            $contacto_nombre = sanitize($_POST['contacto_nombre']);
            $contacto_telefono = sanitize($_POST['contacto_telefono']);
            $notas = sanitize($_POST['notas']);
            $activo = isset($_POST['activo']) ? 1 : 0;

            if (empty($nombre) || $id <= 0) {
                $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Datos inválidos.</div>';
            } else {
                $stmt = $pdo->prepare("UPDATE proveedores SET nombre=?, razon_social=?, cuit=?, telefono=?, email=?, direccion=?, localidad=?, provincia=?, contacto_nombre=?, contacto_telefono=?, notas=?, activo=? WHERE id=?");
                if ($stmt->execute([$nombre, $razon_social, $cuit, $telefono, $email, $direccion, $localidad, $provincia, $contacto_nombre, $contacto_telefono, $notas, $activo, $id])) {
                    $message = '<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">Proveedor actualizado exitosamente.</div>';
                } else {
                    $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Error al actualizar proveedor.</div>';
                }
            }
        } elseif (isset($_POST['delete_supplier'])) {
            $id = intval($_POST['id']);
            if ($id > 0) {
                // Check if supplier has associated products
                $check_stmt = $pdo->prepare("SELECT COUNT(*) FROM productos WHERE proveedor_id = ?");
                $check_stmt->execute([$id]);
                $product_count = $check_stmt->fetchColumn();

                if ($product_count > 0) {
                    $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">No se puede eliminar el proveedor porque tiene productos asociados.</div>';
                } else {
                    $stmt = $pdo->prepare("DELETE FROM proveedores WHERE id=?");
                    if ($stmt->execute([$id])) {
                        $message = '<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">Proveedor eliminado exitosamente.</div>';
                    } else {
                        $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Error al eliminar proveedor.</div>';
                    }
                }
            }
        }
    }
}

// Obtener proveedores
$stmt = $pdo->query("SELECT p.*, COUNT(pr.id) as total_productos FROM proveedores p LEFT JOIN productos pr ON p.id = pr.proveedor_id GROUP BY p.id ORDER BY p.nombre");
$proveedores = $stmt->fetchAll();
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Proveedores -
        <?php echo APP_NAME; ?>
    </title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
</head>

<body class="bg-gray-100 font-sans antialiased text-gray-900">
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-800 tracking-tight">
                <i class="fas fa-truck text-blue-600 mr-2"></i>Gestión de Proveedores
            </h1>
            <button
                class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-md transition duration-200 ease-in-out transform hover:-translate-y-0.5 flex items-center"
                onclick="toggleAddForm()">
                <i class="fas fa-plus mr-2"></i>Agregar Proveedor
            </button>
        </div>

        <?php echo $message; ?>

        <!-- Formulario Agregar Proveedor -->
        <div id="addForm" class="bg-white rounded-xl shadow-lg mb-8 hidden overflow-hidden">
            <div class="p-6 border-b border-gray-100 bg-gray-50">
                <h3 class="text-xl font-bold text-gray-800">Agregar Nuevo Proveedor</h3>
            </div>
            <div class="p-6">
                <form method="POST" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nombre Comercial *</label>
                        <input type="text" name="nombre" required
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Razón Social</label>
                        <input type="text" name="razon_social"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">CUIT</label>
                        <input type="text" name="cuit" placeholder="20-12345678-9"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Teléfono</label>
                        <input type="text" name="telefono"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
                        <input type="email" name="email"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Dirección</label>
                        <input type="text" name="direccion"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Localidad</label>
                        <input type="text" name="localidad"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Provincia</label>
                        <input type="text" name="provincia"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Contacto - Nombre</label>
                        <input type="text" name="contacto_nombre"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Contacto - Teléfono</label>
                        <input type="text" name="contacto_telefono"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Notas</label>
                        <textarea name="notas" rows="3"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                    </div>

                    <div class="md:col-span-2 flex justify-end space-x-3">
                        <button type="button" onclick="toggleAddForm()"
                            class="bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold py-2 px-6 rounded-lg transition">Cancelar</button>
                        <button type="submit" name="add_supplier"
                            class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-md transition">Guardar
                            Proveedor</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tabla de Proveedores -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Nombre</th>
                            <th
                                class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase hidden md:table-cell">
                                Contacto</th>
                            <th
                                class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase hidden lg:table-cell">
                                Ubicación</th>
                            <th class="px-6 py-3 text-center text-xs font-bold text-gray-500 uppercase">Productos</th>
                            <th class="px-6 py-3 text-center text-xs font-bold text-gray-500 uppercase">Estado</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Acciones</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <?php foreach ($proveedores as $prov): ?>
                            <tr class="hover:bg-blue-50 transition">
                                <td class="px-6 py-4">
                                    <div class="text-sm font-bold text-gray-900">
                                        <?php echo htmlspecialchars($prov['nombre']); ?>
                                    </div>
                                    <div class="text-xs text-gray-500">
                                        <?php echo htmlspecialchars($prov['cuit'] ?? 'Sin CUIT'); ?>
                                    </div>
                                </td>
                                <td class="px-6 py-4 hidden md:table-cell">
                                    <div class="text-sm text-gray-900">
                                        <?php echo htmlspecialchars($prov['telefono'] ?? '-'); ?>
                                    </div>
                                    <div class="text-xs text-gray-500">
                                        <?php echo htmlspecialchars($prov['email'] ?? '-'); ?>
                                    </div>
                                </td>
                                <td class="px-6 py-4 hidden lg:table-cell">
                                    <div class="text-sm text-gray-500">
                                        <?php echo htmlspecialchars($prov['localidad'] ?? '-'); ?>,
                                        <?php echo htmlspecialchars($prov['provincia'] ?? '-'); ?>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <span
                                        class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                        <?php echo $prov['total_productos']; ?> productos
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <?php if ($prov['activo']): ?>
                                        <span
                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">Activo</span>
                                    <?php else: ?>
                                        <span
                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">Inactivo</span>
                                    <?php endif; ?>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <button
                                        class="text-yellow-600 hover:text-yellow-900 bg-yellow-100 hover:bg-yellow-200 p-2 rounded-lg transition mr-2"
                                        onclick='editSupplier(<?php echo json_encode($prov); ?>)' title="Editar">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button
                                        class="text-red-600 hover:text-red-900 bg-red-100 hover:bg-red-200 p-2 rounded-lg transition"
                                        onclick="deleteSupplier(<?php echo $prov['id']; ?>, '<?php echo addslashes($prov['nombre']); ?>')"
                                        title="Eliminar">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
            <?php if (empty($proveedores)): ?>
                <div class="p-8 text-center text-gray-500">
                    <i class="fas fa-truck text-5xl mb-4 text-gray-300"></i>
                    <p class="text-lg">No hay proveedores registrados.</p>
                </div>
            <?php endif; ?>
        </div>
    </div>

    <!-- Modal Editar (simplified for brevity - similar structure to categories) -->
    <div id="editModal" class="fixed inset-0 z-50 hidden overflow-y-auto">
        <div class="flex items-center justify-center min-h-screen px-4">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal()"></div>
            <div class="relative bg-white rounded-lg max-w-2xl w-full p-6">
                <h3 class="text-xl font-bold mb-4">Editar Proveedor</h3>
                <form method="POST" id="editForm" class="grid grid-cols-2 gap-4">
                    <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                    <input type="hidden" name="id" id="edit_id">
                    <div class="col-span-2"><label class="block text-sm font-medium mb-1">Nombre *</label><input
                            type="text" name="nombre" id="edit_nombre" required
                            class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">Razón Social</label><input type="text"
                            name="razon_social" id="edit_razon_social" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">CUIT</label><input type="text" name="cuit"
                            id="edit_cuit" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">Teléfono</label><input type="text"
                            name="telefono" id="edit_telefono" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">Email</label><input type="email" name="email"
                            id="edit_email" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div class="col-span-2"><label class="block text-sm font-medium mb-1">Dirección</label><input
                            type="text" name="direccion" id="edit_direccion" class="w-full px-4 py-2 border rounded-lg">
                    </div>
                    <div><label class="block text-sm font-medium mb-1">Localidad</label><input type="text"
                            name="localidad" id="edit_localidad" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">Provincia</label><input type="text"
                            name="provincia" id="edit_provincia" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">Contacto</label><input type="text"
                            name="contacto_nombre" id="edit_contacto_nombre" class="w-full px-4 py-2 border rounded-lg">
                    </div>
                    <div><label class="block text-sm font-medium mb-1">Tel. Contacto</label><input type="text"
                            name="contacto_telefono" id="edit_contacto_telefono"
                            class="w-full px-4 py-2 border rounded-lg"></div>
                    <div class="col-span-2"><label class="block text-sm font-medium mb-1">Notas</label><textarea
                            name="notas" id="edit_notas" rows="2" class="w-full px-4 py-2 border rounded-lg"></textarea>
                    </div>
                    <div class="col-span-2"><label class="flex items-center"><input type="checkbox" name="activo"
                                id="edit_activo" class="mr-2"> Proveedor Activo</label></div>
                    <div class="col-span-2 flex justify-end space-x-3">
                        <button type="button" onclick="closeModal()"
                            class="bg-gray-100 hover:bg-gray-200 px-6 py-2 rounded-lg">Cancelar</button>
                        <button type="submit" name="update_supplier"
                            class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg">Actualizar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Eliminar -->
    <div id="deleteModal" class="fixed inset-0 z-50 hidden overflow-y-auto">
        <div class="flex items-center justify-center min-h-screen px-4">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeDeleteModal()"></div>
            <div class="relative bg-white rounded-lg max-w-md w-full p-6">
                <h3 class="text-xl font-bold mb-4">Eliminar Proveedor</h3>
                <p class="mb-4">¿Estás seguro de eliminar el proveedor <strong id="delete_name"></strong>?</p>
                <form method="POST">
                    <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                    <input type="hidden" name="id" id="delete_id">
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="closeDeleteModal()"
                            class="bg-gray-100 hover:bg-gray-200 px-6 py-2 rounded-lg">Cancelar</button>
                        <button type="submit" name="delete_supplier"
                            class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-lg">Eliminar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function toggleAddForm() {
            document.getElementById('addForm').classList.toggle('hidden');
        }
        function editSupplier(data) {
            document.getElementById('edit_id').value = data.id;
            document.getElementById('edit_nombre').value = data.nombre || '';
            document.getElementById('edit_razon_social').value = data.razon_social || '';
            document.getElementById('edit_cuit').value = data.cuit || '';
            document.getElementById('edit_telefono').value = data.telefono || '';
            document.getElementById('edit_email').value = data.email || '';
            document.getElementById('edit_direccion').value = data.direccion || '';
            document.getElementById('edit_localidad').value = data.localidad || '';
            document.getElementById('edit_provincia').value = data.provincia || '';
            document.getElementById('edit_contacto_nombre').value = data.contacto_nombre || '';
            document.getElementById('edit_contacto_telefono').value = data.contacto_telefono || '';
            document.getElementById('edit_notas').value = data.notas || '';
            document.getElementById('edit_activo').checked = data.activo == 1;
            document.getElementById('editModal').classList.remove('hidden');
        }
        function deleteSupplier(id, nombre) {
            document.getElementById('delete_id').value = id;
            document.getElementById('delete_name').textContent = nombre;
            document.getElementById('deleteModal').classList.remove('hidden');
        }
        function closeModal() {
            document.getElementById('editModal').classList.add('hidden');
        }
        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.add('hidden');
        }
    </script>
</body>

</html>