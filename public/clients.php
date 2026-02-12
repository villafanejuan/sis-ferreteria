<?php
require_once __DIR__ . '/../app/bootstrap.php';
checkSession();
checkAccess('sales'); // Vendedores y Admins pueden ver clientes

$db = Database::getInstance();
$message = '';

// Procesar Formulario
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] !== $_SESSION['csrf_token']) {
        $message = '<div class="bg-red-100 text-red-700 px-4 py-2 rounded mb-4">Error CSRF</div>';
    } else {
        $nombre = sanitize($_POST['nombre']);
        $documento = sanitize($_POST['documento']);
        $tipo_documento = sanitize($_POST['tipo_documento']);
        $telefono = sanitize($_POST['telefono']);
        $email = sanitize($_POST['email']);
        $direccion = sanitize($_POST['direccion']);
        $limite_credito = floatval($_POST['limite_credito']);

        if (isset($_POST['add_client'])) {
            $sql = "INSERT INTO clientes (nombre, documento, tipo_documento, telefono, email, direccion, limite_credito) VALUES (?, ?, ?, ?, ?, ?, ?)";
            $db->query($sql, [$nombre, $documento, $tipo_documento, $telefono, $email, $direccion, $limite_credito]);
            header("Location: clients.php?msg=added");
            exit;
        } elseif (isset($_POST['edit_client'])) {
            $id = intval($_POST['id']);
            $sql = "UPDATE clientes SET nombre=?, documento=?, tipo_documento=?, telefono=?, email=?, direccion=?, limite_credito=? WHERE id=?";
            $db->query($sql, [$nombre, $documento, $tipo_documento, $telefono, $email, $direccion, $limite_credito, $id]);
            header("Location: clients.php?msg=updated");
            exit;
        } elseif (isset($_POST['delete_client'])) {
            if (checkAdmin()) {
                $id = intval($_POST['id']);
                $db->query("UPDATE clientes SET activo = 0 WHERE id = ?", [$id]);
                header("Location: clients.php?msg=deleted");
                exit;
            }
        }
    }
}

// Mensajes GET
if (isset($_GET['msg'])) {
    if ($_GET['msg'] == 'added') $message = '<div class="bg-green-100 text-green-700 px-4 py-2 rounded mb-4">Cliente agregado.</div>';
    if ($_GET['msg'] == 'updated') $message = '<div class="bg-blue-100 text-blue-700 px-4 py-2 rounded mb-4">Cliente actualizado.</div>';
    if ($_GET['msg'] == 'deleted') $message = '<div class="bg-yellow-100 text-yellow-700 px-4 py-2 rounded mb-4">Cliente eliminado.</div>';
}

// Listado
$search = $_GET['q'] ?? '';
$sql = "SELECT * FROM clientes WHERE activo = 1";
$params = [];

if (!empty($search)) {
    $sql .= " AND (nombre LIKE ? OR documento LIKE ?)";
    $params[] = "%$search%";
    $params[] = "%$search%";
}

$sql .= " ORDER BY nombre LIMIT 50";
$clientes = $db->fetchAll($sql, $params);

// Token
if (empty($_SESSION['csrf_token'])) $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Clientes - <?php echo APP_NAME; ?></title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
    <script src="assets/js/shortcuts.js"></script>
</head>
<body class="bg-gray-100 flex flex-col min-h-screen pb-10">
    <?php include __DIR__ . '/../includes/nav.php'; ?>

    <div class="max-w-7xl mx-auto px-4 py-6 w-full flex-1">
        <?php echo $message; ?>

        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800"><i class="fas fa-users mr-2 text-blue-600"></i>Gestión de Clientes</h1>
            <button onclick="openModal()" class="bg-blue-600 text-white px-4 py-2 rounded font-bold hover:bg-blue-700">
                <i class="fas fa-plus mr-2"></i>Nuevo Cliente [F2]
            </button>
        </div>

        <!-- Buscador -->
        <div class="bg-white p-4 rounded-lg shadow mb-6">
            <form method="GET" class="flex gap-4">
                <input type="text" name="q" value="<?php echo htmlspecialchars($search); ?>" 
                       class="flex-1 border p-2 rounded focus:ring-2 focus:ring-blue-500" placeholder="Buscar por nombre o documento...">
                <button type="submit" class="bg-gray-200 px-4 py-2 rounded hover:bg-gray-300"><i class="fas fa-search"></i></button>
            </form>
        </div>

        <!-- Tabla -->
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <table class="w-full text-left border-collapse">
                <thead class="bg-gray-50 text-gray-600 uppercase text-xs">
                    <tr>
                        <th class="p-4 border-b">Nombre</th>
                        <th class="p-4 border-b">Documento</th>
                        <th class="p-4 border-b">Contacto</th>
                        <th class="p-4 border-b text-right">Saldo Cuenta</th>
                        <th class="p-4 border-b text-center">Acciones</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <?php foreach ($clientes as $c): ?>
                        <tr class="hover:bg-gray-50">
                            <td class="p-4 font-bold text-gray-700">
                                <a href="client_details.php?id=<?php echo $c['id']; ?>" class="text-blue-600 hover:underline">
                                    <?php echo htmlspecialchars($c['nombre']); ?>
                                </a>
                            </td>
                            <td class="p-4 text-sm">
                                <span class="bg-gray-100 px-2 py-1 rounded text-xs"><?php echo $c['tipo_documento']; ?></span>
                                <?php echo htmlspecialchars($c['documento']); ?>
                            </td>
                            <td class="p-4 text-sm text-gray-500">
                                <?php if ($c['telefono']): ?>
                                    <div><i class="fas fa-phone mr-1"></i><?php echo htmlspecialchars($c['telefono']); ?></div>
                                <?php endif; ?>
                            </td>
                            <td class="p-4 text-right font-mono font-bold <?php echo $c['saldo_cuenta_corriente'] > 0 ? 'text-red-500' : 'text-green-500'; ?>">
                                $<?php echo number_format($c['saldo_cuenta_corriente'], 2); ?>
                            </td>
                            <td class="p-4 text-center">
                                <button onclick='editClient(<?php echo json_encode($c); ?>)' class="text-blue-500 hover:text-blue-700 mx-2" title="Editar">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <?php if (checkAdmin()): ?>
                                    <button onclick="deleteClient(<?php echo $c['id']; ?>)" class="text-red-400 hover:text-red-600 mx-2" title="Eliminar">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                <?php endif; ?>
                                <a href="client_details.php?id=<?php echo $c['id']; ?>" class="text-gray-500 hover:text-gray-700 mx-2" title="Ver Cuenta">
                                    <i class="fas fa-file-invoice-dollar"></i>
                                </a>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal -->
    <div id="clientModal" class="fixed inset-0 z-50 hidden flex items-center justify-center">
        <div class="fixed inset-0 bg-gray-900 bg-opacity-50" onclick="closeModal()"></div>
        <div class="bg-white rounded-lg shadow-xl w-full max-w-lg z-10 p-6">
            <h3 class="text-xl font-bold mb-4 border-b pb-2" id="modalTitle">Nuevo Cliente</h3>
            <form method="POST">
                <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                <input type="hidden" name="id" id="clientId">
                
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700">Nombre Completo *</label>
                        <input type="text" name="nombre" id="clientName" required class="w-full border p-2 rounded focus:ring-2 focus:ring-blue-500">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500">Tipo Doc</label>
                            <select name="tipo_documento" id="clientTypeDoc" class="w-full border p-2 rounded">
                                <option value="DNI">DNI</option>
                                <option value="CUIT">CUIT</option>
                                <option value="CUIL">CUIL</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500">Número</label>
                            <input type="text" name="documento" id="clientDoc" class="w-full border p-2 rounded">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500">Teléfono</label>
                            <input type="text" name="telefono" id="clientPhone" class="w-full border p-2 rounded">
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500">Límite Crédito ($)</label>
                            <input type="number" step="0.01" name="limite_credito" id="clientLimit" class="w-full border p-2 rounded" value="0.00">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500">Dirección</label>
                        <input type="text" name="direccion" id="clientAddress" class="w-full border p-2 rounded">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-500">Email</label>
                        <input type="email" name="email" id="clientEmail" class="w-full border p-2 rounded">
                    </div>
                </div>

                <div class="mt-6 flex justify-end gap-3">
                    <button type="button" onclick="closeModal()" class="px-4 py-2 text-gray-600 hover:bg-gray-100 rounded">Cancelar</button>
                    <button type="submit" name="add_client" id="submitBtn" class="bg-blue-600 text-white px-6 py-2 rounded font-bold hover:bg-blue-700">Guardar</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        Shortcuts.register('f2', openModal, 'Nuevo Cliente');

        function openModal() {
            document.getElementById('modalTitle').innerText = 'Nuevo Cliente';
            document.getElementById('submitBtn').name = 'add_client';
            document.getElementById('submitBtn').innerText = 'Guardar';
            document.getElementById('clientId').value = '';
            document.getElementById('clientName').value = '';
            document.getElementById('clientDoc').value = '';
            document.getElementById('clientPhone').value = '';
            document.getElementById('clientAddress').value = '';
            document.getElementById('clientEmail').value = '';
            document.getElementById('clientLimit').value = '0.00';
            
            document.getElementById('clientModal').classList.remove('hidden');
            document.getElementById('clientName').focus();
        }

        function editClient(c) {
            document.getElementById('modalTitle').innerText = 'Editar Cliente';
            document.getElementById('submitBtn').name = 'edit_client';
            document.getElementById('submitBtn').innerText = 'Actualizar';
            
            document.getElementById('clientId').value = c.id;
            document.getElementById('clientName').value = c.nombre;
            document.getElementById('clientTypeDoc').value = c.tipo_documento;
            document.getElementById('clientDoc').value = c.documento;
            document.getElementById('clientPhone').value = c.telefono;
            document.getElementById('clientAddress').value = c.direccion;
            document.getElementById('clientEmail').value = c.email;
            document.getElementById('clientLimit').value = c.limite_credito;

            document.getElementById('clientModal').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('clientModal').classList.add('hidden');
        }

        function deleteClient(id) {
            if(confirm('¿Seguro que desea eliminar este cliente?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.innerHTML = `<input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
                                  <input type="hidden" name="delete_client" value="1">
                                  <input type="hidden" name="id" value="${id}">`;
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
