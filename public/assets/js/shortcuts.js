/**
 * Sistema Global de Atajos de Teclado
 * Maneja eventos de teclado y muestra ayuda
 */

const Shortcuts = {
    handlers: {},

    init() {
        document.addEventListener('keydown', this.handleKey.bind(this));
        console.log('Shortcuts system initialized');
    },

    /**
     * Registrar un atajo
     * @param {string} key - Tecla (ej: 'F2', 'Enter', 'Escape')
     * @param {function} callback - Función a ejecutar
     * @param {string} description - Descripción para la ayuda (opcional)
     */
    register(key, callback, description = '') {
        this.handlers[key.toLowerCase()] = { callback, description };
    },

    handleKey(e) {
        const key = e.key.toLowerCase();

        // F1 Global Help (Not implemented yet globally, but good practice)
        if (key === 'f1') {
            e.preventDefault();
            this.showHelp();
            return;
        }

        if (this.handlers[key]) {
            e.preventDefault(); // Prevenir acción por defecto del navegador para teclas F
            // Validar si es un input y si la tecla es funcional (no bloquear escritura normal)
            const activeTag = document.activeElement.tagName.toLowerCase();
            const isInput = activeTag === 'input' || activeTag === 'textarea';

            // Permitir teclas F y Escape siempre. Bloquear letras solo si no es input.
            if (key.startsWith('f') || key === 'escape' || !isInput) {
                this.handlers[key].callback(e);
            }
        }
    },

    showHelp() {
        let helpText = "Atajos Disponibles:\n\n";
        for (const [key, data] of Object.entries(this.handlers)) {
            if (data.description) {
                helpText += `${key.toUpperCase()}: ${data.description}\n`;
            }
        }
        alert(helpText);
    }
};

Shortcuts.init();

// Atajos Globales de Navegación (siempre activos)
document.addEventListener('DOMContentLoaded', () => {
    // Solo si no estamos ya en esas páginas
    if (!window.location.href.includes('sales.php')) {
        Shortcuts.register('f2', () => window.location.href = 'sales.php', 'Ir a Ventas');
    }
    if (!window.location.href.includes('products.php')) {
        Shortcuts.register('f3', () => window.location.href = 'products.php', 'Ir a Productos');
    }
    if (!window.location.href.includes('cash.php')) {
        Shortcuts.register('f4', () => window.location.href = 'cash.php', 'Ir a Caja');
    }
    Shortcuts.register('escape', () => {
        // Cerrar modales genéricos si existen
        const modals = document.querySelectorAll('[id$="Modal"]:not(.hidden)');
        modals.forEach(m => m.classList.add('hidden'));
    }, 'Cerrar Modales / Volver');
});
