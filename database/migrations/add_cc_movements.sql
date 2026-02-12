CREATE TABLE IF NOT EXISTS `cuenta_corriente_movimientos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) NOT NULL,
  `tipo` enum('venta','pago','ajuste_debito','ajuste_credito') NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `saldo_historico` decimal(10,2) NOT NULL DEFAULT 0.00,
  `referencia_id` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `usuario_id` int(11) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_cliente` (`cliente_id`),
  KEY `idx_fecha` (`fecha`),
  CONSTRAINT `fk_cc_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cc_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
