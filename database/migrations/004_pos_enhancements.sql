-- =====================================================
-- Migración 004: Mejoras para Sistema POS Profesional
-- =====================================================
-- Fecha: Febrero 2026
-- Descripción: Agrega campos necesarios para POS profesional
--              con descuentos, pagos mixtos, ventas pendientes

-- Mejorar tabla ventas para POS profesional
ALTER TABLE ventas 
ADD COLUMN descuento_porcentaje DECIMAL(5,2) DEFAULT 0 COMMENT 'Descuento general en porcentaje',
ADD COLUMN descuento_monto DECIMAL(10,2) DEFAULT 0 COMMENT 'Monto de descuento aplicado',
ADD COLUMN metodo_pago_secundario VARCHAR(50) NULL COMMENT 'Segundo método de pago (pagos mixtos)',
ADD COLUMN monto_pago_secundario DECIMAL(10,2) DEFAULT 0 COMMENT 'Monto del segundo método de pago',
ADD COLUMN estado ENUM('completada', 'pendiente', 'cancelada') DEFAULT 'completada' COMMENT 'Estado de la venta',
ADD COLUMN notas TEXT NULL COMMENT 'Observaciones de la venta',
ADD COLUMN vuelto DECIMAL(10,2) DEFAULT 0 COMMENT 'Vuelto entregado al cliente';

-- Mejorar tabla venta_items para descuentos por producto
ALTER TABLE venta_items
ADD COLUMN descuento_porcentaje DECIMAL(5,2) DEFAULT 0 COMMENT 'Descuento en porcentaje por producto',
ADD COLUMN descuento_monto DECIMAL(10,2) DEFAULT 0 COMMENT 'Monto de descuento por producto',
ADD COLUMN precio_costo DECIMAL(10,2) DEFAULT 0 COMMENT 'Precio de costo para calcular margen',
ADD COLUMN subtotal_sin_descuento DECIMAL(10,2) DEFAULT 0 COMMENT 'Subtotal antes de descuento';

-- Índices para mejorar rendimiento de búsqueda en POS
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_codigo_barra ON productos(codigo_barra);
CREATE INDEX idx_productos_marca ON productos(marca_id);
CREATE INDEX idx_ventas_estado ON ventas(estado);
CREATE INDEX idx_ventas_fecha ON ventas(fecha);

-- Tabla para ventas pendientes/suspendidas
CREATE TABLE IF NOT EXISTS ventas_pendientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT NOT NULL,
    cliente_id INT NULL,
    items JSON NOT NULL COMMENT 'Carrito guardado en JSON',
    subtotal DECIMAL(10,2) DEFAULT 0,
    descuento DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    notas TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Ventas suspendidas temporalmente';

-- Actualizar ventas existentes con valores por defecto
UPDATE ventas SET estado = 'completada' WHERE estado IS NULL;
UPDATE ventas SET descuento_porcentaje = 0 WHERE descuento_porcentaje IS NULL;
UPDATE ventas SET descuento_monto = 0 WHERE descuento_monto IS NULL;
UPDATE ventas SET vuelto = 0 WHERE vuelto IS NULL;

-- Actualizar venta_items existentes
UPDATE venta_items SET descuento_porcentaje = 0 WHERE descuento_porcentaje IS NULL;
UPDATE venta_items SET descuento_monto = 0 WHERE descuento_monto IS NULL;
UPDATE venta_items SET precio_costo = 0 WHERE precio_costo IS NULL;

-- Crear vista para productos más vendidos (útil para POS)
CREATE OR REPLACE VIEW productos_mas_vendidos AS
SELECT 
    p.id,
    p.nombre,
    p.codigo_barra,
    p.precio,
    p.stock,
    m.nombre as marca,
    c.nombre as categoria,
    COALESCE(SUM(vi.cantidad), 0) as total_vendido,
    COALESCE(SUM(vi.subtotal), 0) as total_ingresos
FROM productos p
LEFT JOIN marcas m ON p.marca_id = m.id
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN venta_items vi ON p.id = vi.producto_id
LEFT JOIN ventas v ON vi.venta_id = v.id AND v.estado = 'completada'
WHERE p.deleted_at IS NULL
GROUP BY p.id, p.nombre, p.codigo_barra, p.precio, p.stock, m.nombre, c.nombre
ORDER BY total_vendido DESC;

-- Crear vista para alertas de stock bajo
CREATE OR REPLACE VIEW productos_stock_bajo AS
SELECT 
    p.id,
    p.nombre,
    p.codigo_barra,
    p.stock,
    p.stock_minimo,
    m.nombre as marca,
    c.nombre as categoria,
    pr.nombre as proveedor,
    pr.telefono as proveedor_telefono
FROM productos p
LEFT JOIN marcas m ON p.marca_id = m.id
LEFT JOIN categorias c ON p.categoria_id = c.id
LEFT JOIN proveedores pr ON p.proveedor_id = pr.id
WHERE p.deleted_at IS NULL 
  AND p.stock <= p.stock_minimo
ORDER BY p.stock ASC;

-- Comentarios para documentación
ALTER TABLE ventas COMMENT = 'Ventas con soporte para descuentos y pagos mixtos';
ALTER TABLE venta_items COMMENT = 'Items de venta con descuentos por producto';
