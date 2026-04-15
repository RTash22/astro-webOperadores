-- =============================================
-- DATOS DE PRUEBA - Panel de Operadores
-- Ejecutar en Supabase SQL Editor
-- =============================================

-- 1. MAYORISTAS (Proveedores)
INSERT INTO mayoristas (id_mayorista, nombre_empresa, ubicacion, nivel_confianza) VALUES
  ('a1b2c3d4-0001-4000-8000-000000000001', 'TechNova Solutions', 'Monterrey, NL', 5),
  ('a1b2c3d4-0002-4000-8000-000000000002', 'Global Import Co.', 'CDMX, México', 3),
  ('a1b2c3d4-0003-4000-8000-000000000003', 'Nexus Logistics', 'Guadalajara, JAL', 4);

-- 2. CLIENTES
INSERT INTO clientes (id_cliente, nombre_empresa, historial_compras, calificacion_crediticia, correo_contacto, telefono_contacto, rfc, regimen_fiscal, codigo_postal_fiscal, uso_cfdi) VALUES
  ('b2c3d4e5-0001-4000-8000-000000000001', 'Distribuidora López S.A.', '{"compras": 12}', 85, 'lopez@distribuidora.com', '+5218331234567', 'DLO980101ABC', 'Persona Moral', '64000', 'G03'),
  ('b2c3d4e5-0002-4000-8000-000000000002', 'Papelería El Águila', '{"compras": 5}', 70, 'contacto@aguilapapeleria.mx', '+5218119876543', 'PAG050601XYZ', 'Persona Física', '89100', 'G01'),
  ('b2c3d4e5-0003-4000-8000-000000000003', 'Ferretería Industrial MX', '{"compras": 28}', 95, 'ventas@ferreindustrial.com', '+5218337654321', 'FIM120301QWE', 'Persona Moral', '66220', 'G03');

-- 3. CATALOGO DE PRODUCTOS (subidos por los mayoristas)
INSERT INTO catalogo_productos (id_producto, id_mayorista, nombre_articulo, categoria, precio_mayorista, materiales, moq) VALUES
  ('c3d4e5f6-0001-4000-8000-000000000001', 'a1b2c3d4-0001-4000-8000-000000000001', 'Teclado Mecánico Pro RGB', 'Periféricos', 84.50, 'Aluminio, ABS, Switch Cherry MX', 10),
  ('c3d4e5f6-0002-4000-8000-000000000002', 'a1b2c3d4-0001-4000-8000-000000000001', 'Mouse Ergonómico MX Master', 'Periféricos', 45.00, 'Plástico ABS, Sensor Láser', 5),
  ('c3d4e5f6-0003-4000-8000-000000000003', 'a1b2c3d4-0002-4000-8000-000000000002', 'Monitor 27" 4K UltraSharp', 'Monitores', 320.00, 'IPS Panel, Aluminio', 2),
  ('c3d4e5f6-0004-4000-8000-000000000004', 'a1b2c3d4-0002-4000-8000-000000000002', 'Headset Studio Pro Gen 2', 'Audio', 89.00, 'Cuero sintético, Acero', 5),
  ('c3d4e5f6-0005-4000-8000-000000000005', 'a1b2c3d4-0003-4000-8000-000000000003', 'Silla Ergonómica Executive', 'Mobiliario', 210.00, 'Mesh, Aluminio, Espuma HD', 1),
  ('c3d4e5f6-0006-4000-8000-000000000006', 'a1b2c3d4-0003-4000-8000-000000000003', 'Escritorio Eléctrico Ajustable', 'Mobiliario', 450.00, 'Acero, MDF Premium', 1),
  ('c3d4e5f6-0007-4000-8000-000000000007', 'a1b2c3d4-0001-4000-8000-000000000001', 'Webcam 4K AutoFocus', 'Periféricos', 55.00, 'Policarbonato, Vidrio óptico', 10),
  ('c3d4e5f6-0008-4000-8000-000000000008', 'a1b2c3d4-0002-4000-8000-000000000002', 'Hub USB-C 12 en 1', 'Accesorios', 38.00, 'Aluminio CNC', 20);

-- 4. SOLICITUDES DE COTIZACIÓN (peticiones de clientes)
INSERT INTO solicitudes_cotizacion (id_solicitud, id_cliente, descripcion_articulo, especificaciones_req, nivel_urgencia, estado_solicitud) VALUES
  ('d4e5f6a7-0001-4000-8000-000000000001', 'b2c3d4e5-0001-4000-8000-000000000001', 'Necesito 20 teclados mecánicos para oficina nueva', '{"switches": "brown", "layout": "español", "retroiluminacion": "RGB"}', 'alta', 'pendiente'),
  ('d4e5f6a7-0002-4000-8000-000000000002', 'b2c3d4e5-0002-4000-8000-000000000002', 'Busco 5 monitores 4K para diseño gráfico', '{"tamaño": "27 pulgadas", "panel": "IPS", "resolución": "4K"}', 'media', 'pendiente'),
  ('d4e5f6a7-0003-4000-8000-000000000003', 'b2c3d4e5-0003-4000-8000-000000000003', '15 sillas ergonómicas y 15 escritorios ajustables para nueva sucursal', '{"color_silla": "negro", "escritorio_largo": "160cm"}', 'alta', 'en proceso'),
  ('d4e5f6a7-0004-4000-8000-000000000004', 'b2c3d4e5-0001-4000-8000-000000000001', 'Cotización de headsets para call center, 50 unidades', '{"tipo": "over-ear", "microfono": "cancelación de ruido", "conexion": "USB"}', 'baja', 'completada'),
  ('d4e5f6a7-0005-4000-8000-000000000005', 'b2c3d4e5-0003-4000-8000-000000000003', '30 webcams 4K para salas de videoconferencia', '{"autofocus": true, "campo_vision": "90 grados"}', 'media', 'pendiente');

-- 5. COTIZACIONES DOWNLABS (creadas por el operador)
INSERT INTO cotizaciones_downlabs (id_cotizacion, id_solicitud, id_producto, precio_final_cliente, costo_envio, estado) VALUES
  ('e5f6a7b8-0001-4000-8000-000000000001', 'd4e5f6a7-0001-4000-8000-000000000001', 'c3d4e5f6-0001-4000-8000-000000000001', 1990.00, 150.00, 'pendiente'),
  ('e5f6a7b8-0002-4000-8000-000000000002', 'd4e5f6a7-0003-4000-8000-000000000003', 'c3d4e5f6-0005-4000-8000-000000000005', 3450.00, 500.00, 'aceptada'),
  ('e5f6a7b8-0003-4000-8000-000000000003', 'd4e5f6a7-0003-4000-8000-000000000003', 'c3d4e5f6-0006-4000-8000-000000000006', 7200.00, 800.00, 'aceptada'),
  ('e5f6a7b8-0004-4000-8000-000000000004', 'd4e5f6a7-0004-4000-8000-000000000004', 'c3d4e5f6-0004-4000-8000-000000000004', 4650.00, 200.00, 'aceptada');

-- 6. PEDIDOS / CRÉDITOS
INSERT INTO pedidos_creditos (id_pedido, id_cotizacion, requiere_credito, cargo_financiamiento, monto_total_deuda, estado_pago, fecha_inicio_credito, fecha_vencimiento_credito, requiere_factura, tipo_pago) VALUES
  ('f6a7b8c9-0001-4000-8000-000000000001', 'e5f6a7b8-0002-4000-8000-000000000002', false, 0, 3950.00, 'pagado', NULL, NULL, true, 'transferencia'),
  ('f6a7b8c9-0002-4000-8000-000000000002', 'e5f6a7b8-0003-4000-8000-000000000003', true, 360.00, 8360.00, 'pendiente', '2026-04-14', '2026-07-14', true, 'crédito 90 días'),
  ('f6a7b8c9-0003-4000-8000-000000000003', 'e5f6a7b8-0004-4000-8000-000000000004', false, 0, 4850.00, 'pagado', NULL, NULL, false, 'contado');

-- =============================================
-- ¡Listo! Ahora recarga tu dashboard en el navegador.
-- =============================================
