<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();

if (!canAccess('products')) {
    header('Location: dashboard.php');
    exit;
}

if (empty($_SESSION['csrf_token'])) {
    $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
}

$message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Error de seguridad.</div>';
    } else {
        if (isset($_POST['add_brand'])) {
            $nombre = sanitize($_POST['nombre']);
            $descripcion = sanitize($_POST['descripcion']);
            $pais_origen = sanitize($_POST['pais_origen']);

            if (empty($nombre)) {
                $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">Nombre de marca requerido.</div>';
            } else {
                $stmt = $pdo->prepare("INSERT INTO marcas (nombre, descripcion, pais_origen) VALUES (?, ?, ?)");
                if ($stmt->execute([$nombre, $descripcion, $pais_origen])) {
                    $message = '<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">Marca agregada exitosamente.</div>';
                }
            }
        } elseif (isset($_POST['update_brand'])) {
            $id = intval($_POST['id']);
            $nombre = sanitize($_POST['nombre']);
            $descripcion = sanitize($_POST['descripcion']);
            $pais_origen = sanitize($_POST['pais_origen']);
            $activo = isset($_POST['activo']) ? 1 : 0;

            $stmt = $pdo->prepare("UPDATE marcas SET nombre=?, descripcion=?, pais_origen=?, activo=? WHERE id=?");
            if ($stmt->execute([$nombre, $descripcion, $pais_origen, $activo, $id])) {
                $message = '<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">Marca actualizada exitosamente.</div>';
            }
        } elseif (isset($_POST['delete_brand'])) {
            $id = intval($_POST['id']);
            $check_stmt = $pdo->prepare("SELECT COUNT(*) FROM productos WHERE marca_id = ?");
            $check_stmt->execute([$id]);
            if ($check_stmt->fetchColumn() > 0) {
                $message = '<div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">No se puede eliminar la marca porque tiene productos asociados.</div>';
            } else {
                $stmt = $pdo->prepare("DELETE FROM marcas WHERE id=?");
                if ($stmt->execute([$id])) {
                    $message = '<div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">Marca eliminada exitosamente.</div>';
                }
            }
        }
    }
}

$stmt = $pdo->query("SELECT m.*, COUNT(p.id) as total_productos FROM marcas m LEFT JOIN productos p ON m.id = p.marca_id GROUP BY m.id ORDER BY m.nombre");
$marcas = $stmt->fetchAll();
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marcas -
        <?php echo APP_NAME; ?>
    </title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
</head>

<body class="bg-gray-100">
    <?php include __DIR__ . '/../includes/nav.php'; ?>
    <div class="max-w-7xl mx-auto px-4 py-8">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-800"><i class="fas fa-copyright text-blue-600 mr-2"></i>Gestión de
                Marcas</h1>
            <button
                class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-6 rounded-lg shadow-md transition flex items-center"
                onclick="toggleAddForm()">
                <i class="fas fa-plus mr-2"></i>Agregar Marca
            </button>
        </div>
        <?php echo $message; ?>

        <div id="addForm" class="bg-white rounded-xl shadow-lg mb-8 hidden">
            <div class="p-6 border-b bg-gray-50">
                <h3 class="text-xl font-bold">Agregar Nueva Marca</h3>
            </div>
            <div class="p-6">
                <form method="POST" class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                    <div><label class="block text-sm font-medium mb-1">Nombre *</label><input type="text" name="nombre"
                            required class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">País de Origen</label><input type="text"
                            name="pais_origen" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div class="md:col-span-2"><label
                            class="block text-sm font-medium mb-1">Descripción</label><textarea name="descripcion"
                            rows="3" class="w-full px-4 py-2 border rounded-lg"></textarea></div>
                    <div class="md:col-span-2 flex justify-end space-x-3">
                        <button type="button" onclick="toggleAddForm()"
                            class="bg-gray-100 hover:bg-gray-200 px-6 py-2 rounded-lg">Cancelar</button>
                        <button type="submit" name="add_brand"
                            class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg">Guardar</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Marca</th>
                        <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase hidden md:table-cell">
                            País</th>
                        <th class="px-6 py-3 text-center text-xs font-bold text-gray-500 uppercase">Productos</th>
                        <th class="px-6 py-3 text-center text-xs font-bold text-gray-500 uppercase">Estado</th>
                        <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Acciones</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                    <?php foreach ($marcas as $marca): ?>
                        <tr class="hover:bg-blue-50">
                            <td class="px-6 py-4">
                                <div class="font-bold">
                                    <?php echo htmlspecialchars($marca['nombre']); ?>
                                </div>
                                <div class="text-xs text-gray-500">
                                    <?php echo htmlspecialchars($marca['descripcion'] ?? ''); ?>
                                </div>
                            </td>
                            <td class="px-6 py-4 hidden md:table-cell text-sm">
                                <?php echo htmlspecialchars($marca['pais_origen'] ?? '-'); ?>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                    <?php echo $marca['total_productos']; ?>
                                </span>
                            </td>
                            <td class="px-6 py-4 text-center">
                                <?php if ($marca['activo']): ?>
                                    <span
                                        class="px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">Activo</span>
                                <?php else: ?>
                                    <span
                                        class="px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">Inactivo</span>
                                <?php endif; ?>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <button class="text-yellow-600 bg-yellow-100 hover:bg-yellow-200 p-2 rounded-lg mr-2"
                                    onclick='editBrand(<?php echo json_encode($marca); ?>)'><i
                                        class="fas fa-edit"></i></button>
                                <button class="text-red-600 bg-red-100 hover:bg-red-200 p-2 rounded-lg"
                                    onclick="deleteBrand(<?php echo $marca['id']; ?>, '<?php echo addslashes($marca['nombre']); ?>')"><i
                                        class="fas fa-trash-alt"></i></button>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
            <?php if (empty($marcas)): ?>
                <div class="p-8 text-center text-gray-500"><i class="fas fa-copyright text-5xl mb-4 text-gray-300"></i>
                    <p>No hay marcas registradas.</p>
                </div>
            <?php endif; ?>
        </div>
    </div>

    <div id="editModal" class="fixed inset-0 z-50 hidden">
        <div class="flex items-center justify-center min-h-screen px-4">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeModal()"></div>
            <div class="relative bg-white rounded-lg max-w-lg w-full p-6">
                <h3 class="text-xl font-bold mb-4">Editar Marca</h3>
                <form method="POST" class="space-y-4">
                    <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                    <input type="hidden" name="id" id="edit_id">
                    <div><label class="block text-sm font-medium mb-1">Nombre *</label><input type="text" name="nombre"
                            id="edit_nombre" required class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">País</label><input type="text" name="pais_origen"
                            id="edit_pais_origen" class="w-full px-4 py-2 border rounded-lg"></div>
                    <div><label class="block text-sm font-medium mb-1">Descripción</label><textarea name="descripcion"
                            id="edit_descripcion" rows="3" class="w-full px-4 py-2 border rounded-lg"></textarea></div>
                    <div><label class="flex items-center"><input type="checkbox" name="activo" id="edit_activo"
                                class="mr-2"> Marca Activa</label></div>
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="closeModal()"
                            class="bg-gray-100 px-6 py-2 rounded-lg">Cancelar</button>
                        <button type="submit" name="update_brand"
                            class="bg-blue-600 text-white px-6 py-2 rounded-lg">Actualizar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div id="deleteModal" class="fixed inset-0 z-50 hidden">
        <div class="flex items-center justify-center min-h-screen px-4">
            <div class="fixed inset-0 bg-gray-500 bg-opacity-75" onclick="closeDeleteModal()"></div>
            <div class="relative bg-white rounded-lg max-w-md w-full p-6">
                <h3 class="text-xl font-bold mb-4">Eliminar Marca</h3>
                <p class="mb-4">¿Eliminar la marca <strong id="delete_name"></strong>?</p>
                <form method="POST">
                    <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                    <input type="hidden" name="id" id="delete_id">
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="closeDeleteModal()"
                            class="bg-gray-100 px-6 py-2 rounded-lg">Cancelar</button>
                        <button type="submit" name="delete_brand"
                            class="bg-red-600 text-white px-6 py-2 rounded-lg">Eliminar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function toggleAddForm() { document.getElementById('addForm').classList.toggle('hidden'); }
        function editBrand(data) {
            document.getElementById('edit_id').value = data.id;
            document.getElementById('edit_nombre').value = data.nombre;
            document.getElementById('edit_pais_origen').value = data.pais_origen || '';
            document.getElementById('edit_descripcion').value = data.descripcion || '';
            document.getElementById('edit_activo').checked = data.activo == 1;
            document.getElementById('editModal').classList.remove('hidden');
        }
        function deleteBrand(id, nombre) {
            document.getElementById('delete_id').value = id;
            document.getElementById('delete_name').textContent = nombre;
            document.getElementById('deleteModal').classList.remove('hidden');
        }
        function closeModal() { document.getElementById('editModal').classList.add('hidden'); }
        function closeDeleteModal() { document.getElementById('deleteModal').classList.add('hidden'); }
    </script>
</body>

</html>