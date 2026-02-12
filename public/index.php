<?php
/**
 * Punto de entrada principal - Index con login (Rediseñado)
 */

require_once __DIR__ . '/../app/bootstrap.php';

$authController = new AuthController();

// Si ya está autenticado, redirigir
if (isset($_SESSION['user_id'])) {
    header('Location: /sis-ferreteria/public/dashboard.php');
    exit;
}

// Procesar login si es POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $authController->login();
    exit;
}

// Mostrar formulario de login
$csrf_token = Security::generateCsrf();
$flash = null;

if (isset($_SESSION['flash_message'])) {
    $flash = [
        'message' => $_SESSION['flash_message'],
        'type' => $_SESSION['flash_type'] ?? 'info'
    ];
    unset($_SESSION['flash_message'], $_SESSION['flash_type']);
}
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - <?php echo APP_NAME; ?></title>
    <script src="assets/js/tailwindcss.js"></script>
    <link href="assets/css/fontawesome.min.css" rel="stylesheet">
    <style>
        .login-bg {
            background-image: url('assets/img/pattern_tools.png'); /* Opcional si tienes un patrón */
            background-color: #f3f4f6;
        }
    </style>
</head>

<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">
    <div class="max-w-md w-full">
        <!-- Brand -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-gray-800 text-yellow-500 mb-4 shadow-lg">
                <i class="fas fa-hammer text-4xl"></i>
            </div>
            <h1 class="text-3xl font-extrabold text-gray-800 tracking-tight">
                FERRETERÍA
            </h1>
            <p class="text-gray-500 mt-2">Sistema de Gestión Integral</p>
        </div>

        <div class="bg-white rounded-lg shadow-xl overflow-hidden border border-gray-200">
            <div class="p-8">
                <h2 class="text-xl font-bold text-gray-700 mb-6 text-center">Iniciar Sesión</h2>

                <!-- Mensajes Flash -->
                <?php if ($flash): ?>
                    <div class="mb-6 p-4 rounded-lg text-sm font-medium <?php
                    echo $flash['type'] === 'error' ? 'bg-red-50 text-red-700 border border-red-200' :
                        ($flash['type'] === 'success' ? 'bg-green-50 text-green-700 border border-green-200' :
                            'bg-blue-50 text-blue-700 border border-blue-200');
                    ?>">
                        <div class="flex items-center">
                            <i class="fas fa-<?php echo $flash['type'] === 'error' ? 'exclamation-circle' :
                                ($flash['type'] === 'success' ? 'check-circle' : 'info-circle'); ?> mr-2"></i>
                            <?php echo htmlspecialchars($flash['message']); ?>
                        </div>
                    </div>
                <?php endif; ?>

                <!-- Formulario de Login -->
                <form method="POST" action="index.php" class="space-y-6">
                    <input type="hidden" name="<?php echo CSRF_TOKEN_NAME; ?>" value="<?php echo $csrf_token; ?>">

                    <!-- Usuario -->
                    <div>
                        <label for="username" class="block text-sm font-bold text-gray-700 mb-1">
                            Usuario
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-gray-400"></i>
                            </div>
                            <input type="text" id="username" name="username" required autofocus
                                class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition sm:text-sm"
                                placeholder="Ej: admin">
                        </div>
                    </div>

                    <!-- Contraseña -->
                    <div>
                        <label for="password" class="block text-sm font-bold text-gray-700 mb-1">
                            Contraseña
                        </label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-400"></i>
                            </div>
                            <input type="password" id="password" name="password" required
                                class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition sm:text-sm"
                                placeholder="••••••••">
                        </div>
                    </div>

                    <!-- Botón Submit -->
                    <button type="submit"
                        class="w-full bg-blue-600 text-white font-bold py-3 px-4 rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition duration-150 ease-in-out shadow-md">
                        INGRESAR
                    </button>
                </form>
            </div>
            
            <div class="bg-gray-50 px-8 py-4 border-t border-gray-100 text-center">
                <p class="text-xs text-gray-500">
                    &copy; <?php echo date('Y'); ?> <?php echo APP_NAME; ?>. Todos los derechos reservados.
                </p>
            </div>
        </div>
        
        <!-- Info Footer -->
        <div class="mt-6 text-center">
             <p class="text-xs text-gray-400">
                <i class="fas fa-code mr-1"></i> Versión 2.1
            </p>
        </div>
    </div>
</body>

</html>