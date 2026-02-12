<?php
/**
 * Funciones helper para compatibilidad con código antiguo
 */

if (!function_exists('checkSession')) {
    function checkSession()
    {
        if (!isset($_SESSION['user_id'])) {
            header('Location: index.php');
            exit();
        }

        // Verificar que el usuario exista en la BD (prevención de errores de FK)
        global $pdo;
        if (!isset($pdo)) {
            $db = Database::getInstance();
            $pdo = $db->getConnection();
        }

        $stmt = $pdo->prepare("SELECT id, activo, is_active FROM usuarios WHERE id = ?");
        $stmt->execute([$_SESSION['user_id']]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user) {
            // Usuario no existe (sesión huérfana), cerrar sesión
            session_destroy();
            header('Location: index.php?error=session_invalid');
            exit();
        }

        // Verificar activo (usando ambos campos por compatibilidad)
        $isActive = $user['is_active'] ?? $user['activo'] ?? 0;
        if (!$isActive) {
            session_destroy();
            header('Location: index.php?error=account_inactive');
            exit();
        }
    }
}

if (!function_exists('checkAdmin')) {
    function checkAdmin()
    {
        // Solo verifica si es admin
        return isset($_SESSION['role']) && $_SESSION['role'] === 'admin';
    }
}

if (!function_exists('sanitize')) {
    function sanitize($data)
    {
        return htmlspecialchars(strip_tags(trim($data)), ENT_QUOTES, 'UTF-8');
    }
}

/**
 * Verificar si el usuario tiene un rol específico
 */
if (!function_exists('hasRole')) {
    function hasRole($roleName)
    {
        if (!isset($_SESSION['role'])) {
            return false;
        }
        return strtolower($_SESSION['role']) === strtolower($roleName);
    }
}

/**
 * Verificar si el usuario puede acceder a una sección
 */
if (!function_exists('canAccess')) {
    function canAccess($section)
    {
        if (!isset($_SESSION['role'])) {
            return false;
        }

        $role = strtolower($_SESSION['role']);

        // Admin tiene acceso a todo
        if ($role === 'admin') {
            return true;
        }

        // Vendedor (ex Kiosquero): ventas, productos, categorías, caja y dashboard
        if ($role === 'vendedor' || $role === 'kiosquero') {
            return in_array($section, ['dashboard', 'products', 'sales', 'categories', 'cash', 'reports', 'customers']);
        }

        // Cajero: solo caja, dashboard y reportes (SIN ventas ni productos)
        if ($role === 'cajero') {
            return in_array($section, ['dashboard', 'cash', 'reports']);
        }

        // Por defecto no tiene acceso
        return false;
    }
}

/**
 * Verificar acceso y redirigir si no tiene permiso
 */
if (!function_exists('checkAccess')) {
    function checkAccess($section)
    {
        if (!canAccess($section)) {
            header('Location: dashboard.php?error=access_denied');
            exit;
        }
    }
}

// Obtener conexión PDO para código antiguo
if (!isset($pdo)) {
    $db = Database::getInstance();
    $pdo = $db->getConnection();
}
