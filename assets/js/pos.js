/**
 * POS JavaScript - Sistema de Punto de Venta
 * Maneja búsqueda en tiempo real, carrito y pagos
 */

// Estado global del POS
const POS = {
    cart: {},
    total: 0,
    searchTimeout: null,
    selectedCustomer: null
};

// Inicializar POS
document.addEventListener('DOMContentLoaded', function() {
    initializeSearchListeners();
    initializeCartListeners();
    initializeBarcodeScanner();
    initializeKeyboardShortcuts();
});

// ============================================
// BÚSQUEDA DE PRODUCTOS EN TIEMPO REAL
// ============================================

function initializeSearchListeners() {
    const searchInput = document.getElementById('pos_search');
    if (!searchInput) return;

    searchInput.addEventListener('input', function() {
        clearTimeout(POS.searchTimeout);
        const query = this.value.trim();

        if (query.length < 2) {
            clearSearchResults();
            return;
        }

        // Debounce: esperar 300ms después de que el usuario deje de escribir
        POS.searchTimeout = setTimeout(() => {
            searchProducts(query);
        }, 300);
    });

    // Enter para agregar el primer resultado
    searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            const firstResult = document.querySelector('.search-result-item');
            if (firstResult) {
                const productId = firstResult.dataset.productId;
                addToCart(productId, 1);
                this.value = '';
                clearSearchResults();
            }
        }
    });
}

async function searchProducts(query) {
    try {
        const response = await fetch(`../api/search_products.php?q=${encodeURIComponent(query)}&limit=10`);
        const data = await response.json();

        if (data.success && data.products.length > 0) {
            displaySearchResults(data.products);
        } else {
            displayNoResults();
        }
    } catch (error) {
        console.error('Error en búsqueda:', error);
        showNotification('Error al buscar productos', 'error');
    }
}

function displaySearchResults(products) {
    const resultsContainer = document.getElementById('search_results');
    if (!resultsContainer) return;

    let html = '<div class="absolute z-50 w-full mt-1 bg-white rounded-lg shadow-xl border border-gray-200 max-h-96 overflow-y-auto">';
    
    products.forEach(product => {
        const stockClass = product.stock_status === 'sin_stock' ? 'bg-red-100 text-red-800' :
                          product.stock_status === 'bajo' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-green-100 text-green-800';
        
        html += `
            <div class="search-result-item p-3 hover:bg-blue-50 cursor-pointer border-b border-gray-100 transition"
                 data-product-id="${product.id}"
                 onclick="addToCart(${product.id}, 1); document.getElementById('pos_search').value=''; clearSearchResults();">
                <div class="flex justify-between items-start">
                    <div class="flex-1">
                        <p class="font-semibold text-gray-900">${product.nombre_completo}</p>
                        <p class="text-sm text-gray-500">${product.categoria || ''}</p>
                    </div>
                    <div class="text-right ml-4">
                        <p class="font-bold text-lg text-gray-900">$${parseFloat(product.precio).toFixed(2)}</p>
                        ${product.unidad_abrev && product.unidad_abrev !== 'ud' ? 
                            `<p class="text-xs text-gray-500">por ${product.unidad_abrev}</p>` : ''}
                        <span class="inline-block px-2 py-1 text-xs font-semibold rounded-full ${stockClass} mt-1">
                            Stock: ${product.stock}
                        </span>
                    </div>
                </div>
            </div>
        `;
    });
    
    html += '</div>';
    resultsContainer.innerHTML = html;
}

function displayNoResults() {
    const resultsContainer = document.getElementById('search_results');
    if (!resultsContainer) return;

    resultsContainer.innerHTML = `
        <div class="absolute z-50 w-full mt-1 bg-white rounded-lg shadow-xl border border-gray-200 p-4 text-center">
            <i class="fas fa-search text-gray-300 text-3xl mb-2"></i>
            <p class="text-gray-500">No se encontraron productos</p>
        </div>
    `;
}

function clearSearchResults() {
    const resultsContainer = document.getElementById('search_results');
    if (resultsContainer) {
        resultsContainer.innerHTML = '';
    }
}

// ============================================
// ESCÁNER DE CÓDIGO DE BARRAS
// ============================================

function initializeBarcodeScanner() {
    const scannerInput = document.getElementById('barcode_scanner');
    if (!scannerInput) return;

    scannerInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            const barcode = this.value.trim();
            if (barcode) {
                scanBarcode(barcode);
                this.value = '';
            }
        }
    });
}

async function scanBarcode(barcode) {
    try {
        const response = await fetch(`../api/search_products.php?q=${encodeURIComponent(barcode)}&limit=1`);
        const data = await response.json();

        if (data.success && data.products.length > 0) {
            const product = data.products[0];
            // Verificar si el código de barra coincide exactamente
            if (product.codigo_barra === barcode) {
                addToCart(product.id, 1);
                showNotification(`✓ ${product.nombre} agregado`, 'success');
            } else {
                showNotification('Código de barra no encontrado', 'error');
            }
        } else {
            showNotification('Producto no encontrado', 'error');
        }
    } catch (error) {
        console.error('Error al escanear:', error);
        showNotification('Error al escanear código', 'error');
    }
}

// ============================================
// GESTIÓN DEL CARRITO
// ============================================

function initializeCartListeners() {
    // Los listeners se agregan dinámicamente cuando se actualiza el carrito
}

async function addToCart(productId, quantity = 1) {
    try {
        // Obtener información del producto
        const response = await fetch(`../api/search_products.php?q=&limit=1000`);
        const data = await response.json();
        
        if (!data.success) {
            showNotification('Error al cargar producto', 'error');
            return;
        }

        const product = data.products.find(p => p.id == productId);
        if (!product) {
            showNotification('Producto no encontrado', 'error');
            return;
        }

        // Verificar stock
        const currentQty = POS.cart[productId] ? POS.cart[productId].quantity : 0;
        const newQty = currentQty + quantity;

        if (newQty > product.stock) {
            showNotification('Stock insuficiente', 'error');
            return;
        }

        // Agregar o actualizar en el carrito
        if (POS.cart[productId]) {
            POS.cart[productId].quantity = newQty;
        } else {
            POS.cart[productId] = {
                id: product.id,
                nombre: product.nombre_completo,
                precio: parseFloat(product.precio),
                quantity: quantity,
                stock: product.stock,
                unidad: product.unidad_abrev || 'ud'
            };
        }

        updateCartUI();
        showNotification('Producto agregado al carrito', 'success');
        
        // Enfocar en búsqueda para continuar
        const searchInput = document.getElementById('pos_search');
        if (searchInput) searchInput.focus();

    } catch (error) {
        console.error('Error al agregar al carrito:', error);
        showNotification('Error al agregar producto', 'error');
    }
}

function removeFromCart(productId) {
    delete POS.cart[productId];
    updateCartUI();
    showNotification('Producto eliminado', 'info');
}

function updateQuantity(productId, quantity) {
    if (quantity <= 0) {
        removeFromCart(productId);
        return;
    }

    const item = POS.cart[productId];
    if (!item) return;

    if (quantity > item.stock) {
        showNotification('Stock insuficiente', 'error');
        return;
    }

    item.quantity = quantity;
    updateCartUI();
}

function clearCart() {
    if (Object.keys(POS.cart).length === 0) return;

    if (confirm('¿Vaciar el carrito?')) {
        POS.cart = {};
        updateCartUI();
        showNotification('Carrito vaciado', 'info');
    }
}

function updateCartUI() {
    const cartContainer = document.getElementById('cart_items');
    const cartTotal = document.getElementById('cart_total');
    const cartCount = document.getElementById('cart_count');
    
    if (!cartContainer) return;

    // Calcular total
    POS.total = 0;
    let itemCount = 0;

    for (const item of Object.values(POS.cart)) {
        POS.total += item.precio * item.quantity;
        itemCount += item.quantity;
    }

    // Actualizar contador
    if (cartCount) {
        cartCount.textContent = itemCount;
        cartCount.classList.toggle('hidden', itemCount === 0);
    }

    // Actualizar total
    if (cartTotal) {
        cartTotal.textContent = `$${POS.total.toFixed(2)}`;
    }

    // Renderizar items
    if (Object.keys(POS.cart).length === 0) {
        cartContainer.innerHTML = `
            <div class="text-center py-12 text-gray-400">
                <i class="fas fa-shopping-cart text-6xl mb-4 opacity-20"></i>
                <p class="text-lg">Carrito vacío</p>
                <p class="text-sm">Busca productos para agregar</p>
            </div>
        `;
        disableCheckout();
    } else {
        let html = '';
        for (const [productId, item] of Object.entries(POS.cart)) {
            const subtotal = item.precio * item.quantity;
            html += `
                <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg border border-gray-200 hover:border-blue-300 transition group">
                    <div class="flex-1">
                        <p class="font-semibold text-gray-900">${item.nombre}</p>
                        <div class="flex items-center gap-2 mt-1">
                            <span class="text-sm text-gray-500">$${item.precio.toFixed(2)}</span>
                            <span class="text-gray-300">×</span>
                            <input type="number" 
                                   value="${item.quantity}" 
                                   min="1" 
                                   max="${item.stock}"
                                   class="w-16 px-2 py-1 text-center border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                                   onchange="updateQuantity(${productId}, parseInt(this.value))">
                            <span class="text-xs text-gray-400">${item.unidad}</span>
                        </div>
                    </div>
                    <div class="flex items-center gap-3 ml-4">
                        <span class="font-bold text-lg text-gray-900">$${subtotal.toFixed(2)}</span>
                        <button onclick="removeFromCart(${productId})" 
                                class="text-red-500 hover:text-red-700 hover:bg-red-50 p-2 rounded transition opacity-0 group-hover:opacity-100"
                                title="Eliminar">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </div>
                </div>
            `;
        }
        cartContainer.innerHTML = html;
        enableCheckout();
    }

    // Actualizar campo de pago
    updatePaymentFields();
}

// ============================================
// PROCESAMIENTO DE PAGO
// ============================================

function updatePaymentFields() {
    const amountPaidInput = document.getElementById('amount_paid');
    if (amountPaidInput) {
        amountPaidInput.min = POS.total.toFixed(2);
        calculateChange();
    }
}

function calculateChange() {
    const amountPaid = parseFloat(document.getElementById('amount_paid')?.value || 0);
    const change = amountPaid - POS.total;
    const changeDisplay = document.getElementById('change_display');
    const checkoutBtn = document.getElementById('checkout_btn');

    if (changeDisplay) {
        if (change >= 0) {
            changeDisplay.textContent = `$${change.toFixed(2)}`;
            changeDisplay.className = 'text-2xl font-bold text-green-600';
        } else {
            changeDisplay.textContent = '$0.00';
            changeDisplay.className = 'text-2xl font-bold text-gray-400';
        }
    }

    if (checkoutBtn) {
        checkoutBtn.disabled = change < 0 || POS.total === 0;
        checkoutBtn.classList.toggle('opacity-50', change < 0 || POS.total === 0);
        checkoutBtn.classList.toggle('cursor-not-allowed', change < 0 || POS.total === 0);
    }
}

function quickAmount(amount) {
    const amountPaidInput = document.getElementById('amount_paid');
    if (amountPaidInput) {
        const current = parseFloat(amountPaidInput.value || 0);
        amountPaidInput.value = (current + amount).toFixed(2);
        calculateChange();
    }
}

function setExactAmount() {
    const amountPaidInput = document.getElementById('amount_paid');
    if (amountPaidInput) {
        amountPaidInput.value = POS.total.toFixed(2);
        calculateChange();
    }
}

function enableCheckout() {
    const paymentSection = document.getElementById('payment_section');
    if (paymentSection) {
        paymentSection.classList.remove('hidden');
    }
}

function disableCheckout() {
    const paymentSection = document.getElementById('payment_section');
    if (paymentSection) {
        paymentSection.classList.add('hidden');
    }
}

// ============================================
// ATAJOS DE TECLADO
// ============================================

function initializeKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // F1 - Nueva venta (limpiar carrito)
        if (e.key === 'F1') {
            e.preventDefault();
            clearCart();
        }
        
        // F2 - Enfocar búsqueda
        if (e.key === 'F2') {
            e.preventDefault();
            document.getElementById('pos_search')?.focus();
        }
        
        // F3 - Enfocar escáner
        if (e.key === 'F3') {
            e.preventDefault();
            document.getElementById('barcode_scanner')?.focus();
        }
        
        // ESC - Limpiar búsqueda
        if (e.key === 'Escape') {
            const searchInput = document.getElementById('pos_search');
            if (searchInput && searchInput === document.activeElement) {
                searchInput.value = '';
                clearSearchResults();
            }
        }
    });
}

// ============================================
// NOTIFICACIONES
// ============================================

function showNotification(message, type = 'info') {
    const container = document.getElementById('notifications');
    if (!container) return;

    const icons = {
        success: 'fa-check-circle text-green-500',
        error: 'fa-exclamation-circle text-red-500',
        info: 'fa-info-circle text-blue-500',
        warning: 'fa-exclamation-triangle text-yellow-500'
    };

    const colors = {
        success: 'bg-green-50 border-green-200',
        error: 'bg-red-50 border-red-200',
        info: 'bg-blue-50 border-blue-200',
        warning: 'bg-yellow-50 border-yellow-200'
    };

    const notification = document.createElement('div');
    notification.className = `${colors[type]} border px-4 py-3 rounded-lg shadow-lg flex items-center gap-3 mb-2 animate-slide-in`;
    notification.innerHTML = `
        <i class="fas ${icons[type]} text-xl"></i>
        <span class="flex-1">${message}</span>
        <button onclick="this.parentElement.remove()" class="text-gray-400 hover:text-gray-600">
            <i class="fas fa-times"></i>
        </button>
    `;

    container.appendChild(notification);

    // Auto-remover después de 3 segundos
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Exportar funciones globales
window.POS = POS;
window.addToCart = addToCart;
window.removeFromCart = removeFromCart;
window.updateQuantity = updateQuantity;
window.clearCart = clearCart;
window.calculateChange = calculateChange;
window.quickAmount = quickAmount;
window.setExactAmount = setExactAmount;
window.showNotification = showNotification;
