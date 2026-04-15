import type { APIRoute } from 'astro';
import { supabase } from '../../db/supabase.js';

// GET: Fetch cotizaciones for a specific solicitud
export const GET: APIRoute = async ({ url }) => {
  const idSolicitud = url.searchParams.get('id_solicitud');
  if (!idSolicitud) {
    return new Response(JSON.stringify({ error: 'id_solicitud requerido' }), { status: 400 });
  }

  const { data, error } = await supabase
    .from('cotizaciones_downlabs')
    .select(`
      id_cotizacion,
      id_solicitud,
      id_producto,
      precio_final_cliente,
      costo_envio,
      cantidad,
      estado,
      notas_operador,
      created_at,
      catalogo_productos (
        id_producto,
        nombre_articulo,
        categoria,
        precio_mayorista,
        materiales,
        moq,
        imagen_url,
        mayoristas (
          nombre_empresa,
          nivel_confianza
        )
      )
    `)
    .eq('id_solicitud', idSolicitud)
    .order('created_at', { ascending: false });

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }

  return new Response(JSON.stringify({ data }), {
    headers: { 'Content-Type': 'application/json' },
  });
};

// POST: Add product to a solicitud's cotización
export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();
  const { id_solicitud, id_producto, precio_final_cliente, costo_envio, cantidad } = body;

  if (!id_solicitud || !id_producto) {
    return new Response(JSON.stringify({ error: 'id_solicitud e id_producto son requeridos' }), { status: 400 });
  }

  // Check duplicate
  const { data: existing } = await supabase
    .from('cotizaciones_downlabs')
    .select('id_cotizacion')
    .eq('id_solicitud', id_solicitud)
    .eq('id_producto', id_producto)
    .limit(1);

  if (existing && existing.length > 0) {
    return new Response(JSON.stringify({ error: 'Este producto ya está en la cotización de esta solicitud' }), { status: 409 });
  }

  const { data, error } = await supabase
    .from('cotizaciones_downlabs')
    .insert({
      id_solicitud,
      id_producto,
      precio_final_cliente: precio_final_cliente || 0,
      costo_envio: costo_envio || 0,
      cantidad: cantidad || 1,
      estado: 'pendiente',
    })
    .select()
    .single();

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }

  // Auto-update solicitud status to "en proceso"
  await supabase
    .from('solicitudes_cotizacion')
    .update({ estado_solicitud: 'en proceso' })
    .eq('id_solicitud', id_solicitud)
    .eq('estado_solicitud', 'pendiente');

  return new Response(JSON.stringify({ data }), {
    status: 201,
    headers: { 'Content-Type': 'application/json' },
  });
};

// PATCH: Finalize cotización → send to providers + notify client
export const PATCH: APIRoute = async ({ request }) => {
  const body = await request.json();
  const { id_solicitud, notas_operador } = body;

  if (!id_solicitud) {
    return new Response(JSON.stringify({ error: 'id_solicitud requerido' }), { status: 400 });
  }

  // Check there are items in the cart
  const { data: items } = await supabase
    .from('cotizaciones_downlabs')
    .select('id_cotizacion')
    .eq('id_solicitud', id_solicitud);

  if (!items || items.length === 0) {
    return new Response(JSON.stringify({ error: 'No hay productos en la cotización' }), { status: 400 });
  }

  // Update all cotizaciones for this solicitud to "enviada"
  const { error: cotError } = await supabase
    .from('cotizaciones_downlabs')
    .update({ 
      estado: 'enviada',
      notas_operador: notas_operador || null,
    })
    .eq('id_solicitud', id_solicitud);

  if (cotError) {
    return new Response(JSON.stringify({ error: cotError.message }), { status: 500 });
  }

  // Update solicitud status to "cotizada"
  const { error: solError } = await supabase
    .from('solicitudes_cotizacion')
    .update({ estado_solicitud: 'cotizada' })
    .eq('id_solicitud', id_solicitud);

  if (solError) {
    return new Response(JSON.stringify({ error: solError.message }), { status: 500 });
  }

  // Here is where you would:
  // 1. Send notification to providers (via your C backend, email, or Supabase Edge Function)
  // 2. Send SMS/email to client that their request is being quoted
  // For now, we just update the database status

  return new Response(JSON.stringify({ 
    success: true, 
    message: 'Cotización enviada a proveedores. El cliente será notificado.',
    items_count: items.length,
  }), {
    headers: { 'Content-Type': 'application/json' },
  });
};

// DELETE: Remove product from cotización
export const DELETE: APIRoute = async ({ url }) => {
  const idCotizacion = url.searchParams.get('id_cotizacion');
  if (!idCotizacion) {
    return new Response(JSON.stringify({ error: 'id_cotizacion requerido' }), { status: 400 });
  }

  const { data: cotData } = await supabase
    .from('cotizaciones_downlabs')
    .select('id_solicitud')
    .eq('id_cotizacion', idCotizacion)
    .single();

  const { error } = await supabase
    .from('cotizaciones_downlabs')
    .delete()
    .eq('id_cotizacion', idCotizacion);

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }

  // If cart empty, revert solicitud status
  if (cotData?.id_solicitud) {
    const { data: remaining } = await supabase
      .from('cotizaciones_downlabs')
      .select('id_cotizacion')
      .eq('id_solicitud', cotData.id_solicitud)
      .limit(1);

    if (!remaining || remaining.length === 0) {
      await supabase
        .from('solicitudes_cotizacion')
        .update({ estado_solicitud: 'pendiente' })
        .eq('id_solicitud', cotData.id_solicitud)
        .in('estado_solicitud', ['en proceso']);
    }
  }

  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' },
  });
};
