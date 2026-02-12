<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
$current_page = basename($_SERVER['PHP_SELF']);

// Verificar turno de caja para indicador
$turnoAbiertoNav = false;
if (isset($_SESSION['user_id'])) {
    $dbNav = Database::getInstance();
    $turnoAbiertoNav = $dbNav->fetchOne("SELECT id FROM turnos_caja WHERE user_id = ? AND estado = 'abierto'", [$_SESSION['user_id']]);
}
?>
<!-- Estilos y Scripts Globales -->
<link href="assets/css/styles.css" rel="stylesheet">
<script src="assets/js/shortcuts.js"></script>

<!-- Navbar Compacto (Estilo Ferretería) -->
<nav class="bg-gray-800 text-white p-2 flex justify-between items-center shadow-md sticky top-0 z-40">
    <div class="flex items-center gap-6">
        <a href="dashboard.php" class="text-xl font-bold flex items-center hover:text-yellow-400 transition">
            <i class="fas fa-hammer text-yellow-500 mr-2"></i>
            FERRETERÍA
        </a>

        <div class="hidden md:flex space-x-4 text-sm">
            <a href="dashboard.php"
                class="<?php echo $current_page == 'dashboard.php' ? 'text-white font-bold bg-gray-700 rounded px-2 py-1' : 'text-gray-300 hover:text-white px-2 py-1'; ?>">
                <i class="fas fa-home mr-1"></i>Inicio
            </a>

            <?php if (canAccess('sales')): ?>
                <a href="sales.php"
                    class="<?php echo $current_page == 'sales.php' ? 'text-white font-bold bg-gray-700 rounded px-2 py-1' : 'text-gray-300 hover:text-white px-2 py-1'; ?>">
                    <i class="fas fa-shopping-cart mr-1"></i>Ventas <span
                        class="text-xs bg-gray-600 px-1 rounded ml-1">F2</span>
                </a>
            <?php endif; ?>

            <?php if (canAccess('products')): ?>
                <a href="products.php"
                    class="<?php echo $current_page == 'products.php' ? 'text-white font-bold bg-gray-700 rounded px-2 py-1' : 'text-gray-300 hover:text-white px-2 py-1'; ?>">
                    <i class="fas fa-boxes mr-1"></i>Productos <span class="text-xs bg-gray-600 px-1 rounded ml-1">F3</span>
                </a>
            <?php endif; ?>

            <?php if (canAccess('cash')): ?>
                <a href="cash.php"
                    class="<?php echo $current_page == 'cash.php' ? 'text-white font-bold bg-gray-700 rounded px-2 py-1' : 'text-gray-300 hover:text-white px-2 py-1'; ?>">
                    <i class="fas fa-cash-register mr-1"></i>Caja <span
                        class="text-xs bg-gray-600 px-1 rounded ml-1">F4</span>
                </a>
            <?php endif; ?>

            <?php if (canAccess('reports')): ?>
                <a href="reports.php"
                    class="<?php echo $current_page == 'reports.php' ? 'text-white font-bold bg-gray-700 rounded px-2 py-1' : 'text-gray-300 hover:text-white px-2 py-1'; ?>">
                    <i class="fas fa-chart-line mr-1"></i>Reportes
                </a>
            <?php endif; ?>

            <?php if (checkAdmin()): ?>
                <a href="users.php"
                    class="<?php echo $current_page == 'users.php' ? 'text-white font-bold bg-gray-700 rounded px-2 py-1' : 'text-gray-300 hover:text-white px-2 py-1'; ?>">
                    <i class="fas fa-users mr-1"></i>Usuarios
                </a>
            <?php endif; ?>
        </div>
    </div>

    <div class="flex items-center gap-4 text-sm">
        <?php if ($turnoAbiertoNav): ?>
            <span class="bg-green-600 px-2 py-1 rounded text-xs font-bold border border-green-400">
                <i class="fas fa-lock-open mr-1"></i>CAJA ABIERTA
            </span>
        <?php else: ?>
            <span class="bg-red-600 px-2 py-1 rounded text-xs font-bold border border-red-400 animate-pulse">
                <i class="fas fa-lock mr-1"></i>CAJA CERRADA
            </span>
        <?php endif; ?>

        <div class="relative group">
            <button class="flex items-center hover:text-yellow-400 focus:outline-none">
                <i class="fas fa-user-circle text-lg mr-2"></i>
                <span class="font-semibold"><?php echo $_SESSION['username'] ?? 'Usuario'; ?></span>
            </button>
            <!-- Dropdown Menu -->
            <div class="absolute right-0 top-full pt-2 w-48 hidden group-hover:block z-50">
                <div class="bg-white text-gray-800 rounded shadow-xl border border-gray-200 overflow-hidden">
                    <div class="px-4 py-3 border-b border-gray-100 bg-gray-50">
                        <p class="text-xs text-gray-500 uppercase">Conectado como</p>
                        <p class="font-bold text-sm truncate"><?php echo $_SESSION['username'] ?? 'User'; ?></p>
                    </div>
                    
                    <a href="logout.php" class="block px-4 py-2 hover:bg-red-50 text-red-600 font-bold border-t border-gray-100">
                        <i class="fas fa-sign-out-alt mr-2"></i>Cerrar Sesión
                    </a>
                </div>
            </div>
        </div>
    </div>
</nav>

<!-- Footer de Atajos (Se muestra en todas las páginas) -->
<div class="shortcuts-footer">
    <div class="flex">
        <div class="shortcut-item"><span class="key">F1</span> Ayuda</div>
        <div class="shortcut-item"><span class="key">F2</span> Ventas</div>
        <div class="shortcut-item"><span class="key">F3</span> Productos</div>
        <div class="shortcut-item"><span class="key">F4</span> Caja</div>
    </div>
    <div class="text-gray-400 text-xs text-right">
        Sistema Ferretería v2.1
    </div>
</div>