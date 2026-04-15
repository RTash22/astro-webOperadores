-- =============================================
-- MIGRACIÓN: Cantidad en cotizaciones + estado de flujo
-- Ejecutar en Supabase SQL Editor
-- =============================================

-- 1. Agregar columna cantidad a cotizaciones_downlabs
ALTER TABLE cotizaciones_downlabs
  ADD COLUMN IF NOT EXISTS cantidad int4 DEFAULT 1;

-- 2. Agregar columna notas_operador para cuando el operador finalice
ALTER TABLE cotizaciones_downlabs
  ADD COLUMN IF NOT EXISTS notas_operador text;

-- 3. Agregar más estados a solicitudes para el flujo completo
-- Los estados serán:
--   pendiente → en proceso → cotizada → respondida → completada
-- "cotizada"   = el operador terminó de armar y envió a proveedores
-- "respondida" = los proveedores respondieron, el operador puede cotizar al cliente
-- "completada" = el cliente aceptó y se generó el pedido

-- No necesitamos ALTER porque estado_solicitud es text, acepta cualquier valor.

-- 4. Limpiar cotizaciones de prueba anteriores que no tenían cantidad
UPDATE cotizaciones_downlabs SET cantidad = 1 WHERE cantidad IS NULL;

-- =============================================
-- ¡Listo! Ahora recarga la página.
-- =============================================
