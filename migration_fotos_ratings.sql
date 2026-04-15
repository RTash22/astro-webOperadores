-- =============================================
-- MIGRACIÓN: Fotos, descripciones y ratings
-- Ejecutar en Supabase SQL Editor
-- =============================================

-- ─── 1. Agregar columnas a catalogo_productos ───
ALTER TABLE catalogo_productos 
  ADD COLUMN IF NOT EXISTS descripcion text,
  ADD COLUMN IF NOT EXISTS imagen_url text;

-- ─── 2. Crear tabla de ratings de clientes ───
CREATE TABLE IF NOT EXISTS ratings_productos (
  id_rating uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  id_producto uuid REFERENCES catalogo_productos(id_producto) ON DELETE CASCADE,
  id_cliente uuid REFERENCES clientes(id_cliente) ON DELETE SET NULL,
  calificacion int4 NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
  comentario text,
  created_at timestamptz DEFAULT now()
);

-- Desactivar RLS para la nueva tabla
ALTER TABLE ratings_productos DISABLE ROW LEVEL SECURITY;

-- ─── 3. Actualizar productos con descripciones e imágenes ───
UPDATE catalogo_productos SET
  descripcion = 'Teclado mecánico con switches Cherry MX Brown, retroiluminación RGB personalizable, construcción en aluminio de grado aeroespacial. Layout español completo con pad numérico.',
  imagen_url = 'https://images.unsplash.com/photo-1618384887929-16ec33fab9ef?w=400&q=80'
WHERE nombre_articulo = 'Teclado Mecánico Pro RGB';

UPDATE catalogo_productos SET
  descripcion = 'Mouse ergonómico con sensor láser de alta precisión 4000 DPI, 7 botones programables, descanso de pulgar integrado. Ideal para jornadas largas.',
  imagen_url = 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400&q=80'
WHERE nombre_articulo = 'Mouse Ergonómico MX Master';

UPDATE catalogo_productos SET
  descripcion = 'Monitor profesional 27 pulgadas 4K UHD (3840x2160), panel IPS con cobertura 99% sRGB, biseles ultra delgados, base ajustable.',
  imagen_url = 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=400&q=80'
WHERE nombre_articulo = 'Monitor 27" 4K UltraSharp';

UPDATE catalogo_productos SET
  descripcion = 'Headset profesional over-ear con cancelación de ruido activa, micrófono con brazo flexible, conexión USB y 3.5mm. 40hrs de batería.',
  imagen_url = 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&q=80'
WHERE nombre_articulo = 'Headset Studio Pro Gen 2';

UPDATE catalogo_productos SET
  descripcion = 'Silla ergonómica con respaldo de mesh transpirable, soporte lumbar ajustable, reposabrazos 4D, base de aluminio con ruedas silenciosas.',
  imagen_url = 'https://images.unsplash.com/photo-1592078615290-033ee584e267?w=400&q=80'
WHERE nombre_articulo = 'Silla Ergonómica Executive';

UPDATE catalogo_productos SET
  descripcion = 'Escritorio eléctrico con altura ajustable 60-125cm, motor dual silencioso, tablero MDF premium 160x80cm, panel de control con memoria de 3 posiciones.',
  imagen_url = 'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=400&q=80'
WHERE nombre_articulo = 'Escritorio Eléctrico Ajustable';

UPDATE catalogo_productos SET
  descripcion = 'Webcam 4K con autofocus rápido, campo de visión 90°, micrófono estéreo integrado, corrección de luz automática. Compatible con todas las plataformas.',
  imagen_url = 'https://images.unsplash.com/photo-1587826080692-f439cd0b70da?w=400&q=80'
WHERE nombre_articulo = 'Webcam 4K AutoFocus';

UPDATE catalogo_productos SET
  descripcion = 'Hub USB-C 12 en 1: 2x HDMI, 3x USB-A 3.0, USB-C PD 100W, SD/MicroSD, Ethernet RJ45, audio 3.5mm. Carcasa de aluminio CNC.',
  imagen_url = 'https://images.unsplash.com/photo-1625723044792-44de16ccb4e9?w=400&q=80'
WHERE nombre_articulo = 'Hub USB-C 12 en 1';

-- ─── 4. Insertar ratings de ejemplo ───
-- Teclado Mecánico
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0001-4000-8000-000000000001', 'b2c3d4e5-0001-4000-8000-000000000001', 5, 'Excelente teclado, los switches son muy cómodos. Lleva 6 meses sin fallar.'),
  ('c3d4e5f6-0001-4000-8000-000000000001', 'b2c3d4e5-0003-4000-8000-000000000003', 4, 'Buena calidad pero el envío tardó más de lo esperado.'),
  ('c3d4e5f6-0001-4000-8000-000000000001', 'b2c3d4e5-0002-4000-8000-000000000002', 5, 'Mis empleados están encantados, ya hicimos segunda compra.');

-- Mouse
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0002-4000-8000-000000000002', 'b2c3d4e5-0001-4000-8000-000000000001', 4, 'Muy ergonómico, redujo quejas de dolor de muñeca en la oficina.'),
  ('c3d4e5f6-0002-4000-8000-000000000002', 'b2c3d4e5-0002-4000-8000-000000000002', 3, 'Funciona bien pero el scroll a veces falla.');

-- Monitor
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0003-4000-8000-000000000003', 'b2c3d4e5-0003-4000-8000-000000000003', 5, 'Colores perfectos para diseño, el 4K se nota muchísimo.'),
  ('c3d4e5f6-0003-4000-8000-000000000003', 'b2c3d4e5-0001-4000-8000-000000000001', 5, 'El mejor monitor que hemos comprado para la empresa.');

-- Headset
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0004-4000-8000-000000000004', 'b2c3d4e5-0002-4000-8000-000000000002', 4, 'Cancelación de ruido muy buena, micrófono claro.'),
  ('c3d4e5f6-0004-4000-8000-000000000004', 'b2c3d4e5-0003-4000-8000-000000000003', 5, 'Usamos 50 en nuestro call center, cero problemas.');

-- Silla
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0005-4000-8000-000000000005', 'b2c3d4e5-0001-4000-8000-000000000001', 5, 'Comodísima, el soporte lumbar es de lo mejor que he probado.'),
  ('c3d4e5f6-0005-4000-8000-000000000005', 'b2c3d4e5-0003-4000-8000-000000000003', 4, 'Buena silla, solo el armado fue un poco complicado.');

-- Escritorio
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0006-4000-8000-000000000006', 'b2c3d4e5-0003-4000-8000-000000000003', 5, 'El motor es ultra silencioso, la función de memoria es genial.');

-- Webcam
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0007-4000-8000-000000000007', 'b2c3d4e5-0002-4000-8000-000000000002', 3, 'Decente por el precio, el autofocus a veces tarda.'),
  ('c3d4e5f6-0007-4000-8000-000000000007', 'b2c3d4e5-0001-4000-8000-000000000001', 4, 'Buena calidad de imagen en videollamadas.');

-- Hub USB-C
INSERT INTO ratings_productos (id_producto, id_cliente, calificacion, comentario) VALUES
  ('c3d4e5f6-0008-4000-8000-000000000008', 'b2c3d4e5-0003-4000-8000-000000000003', 4, 'Funciona perfecto, todos los puertos son estables.'),
  ('c3d4e5f6-0008-4000-8000-000000000008', 'b2c3d4e5-0001-4000-8000-000000000001', 5, 'Indispensable para las laptops de la empresa.');

-- =============================================
-- RESUMEN DE CAMBIOS:
-- 
-- catalogo_productos: +2 columnas (descripcion, imagen_url)
-- ratings_productos: nueva tabla con 16 ratings de ejemplo
--
-- Ahora recarga /dashboard/solicitudes
-- =============================================
