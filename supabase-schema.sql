-- ============================================================
-- Yuyalma · Lista de precios — esquema de Supabase
-- Pegá TODO este archivo en Supabase > SQL Editor > New query
-- y hacé clic en "Run".
-- ============================================================

-- Tabla única: guarda todo el estado de la app (productos, ids,
-- categorías extra) como un solo JSON en la columna "data".
create table if not exists public.yuyalma_state (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Habilitar Row Level Security (recomendado por Supabase)
alter table public.yuyalma_state enable row level security;

-- Como esta app usa la clave "anon" (pública) directamente desde
-- el navegador y no tiene login de usuarios, permitimos lectura y
-- escritura pública sobre esta única fila. Si en el futuro agregás
-- login, reemplazá estas políticas por reglas basadas en auth.uid().
drop policy if exists "Lectura pública" on public.yuyalma_state;
create policy "Lectura pública"
  on public.yuyalma_state for select
  using (true);

drop policy if exists "Escritura pública" on public.yuyalma_state;
create policy "Escritura pública"
  on public.yuyalma_state for insert
  with check (true);

drop policy if exists "Actualización pública" on public.yuyalma_state;
create policy "Actualización pública"
  on public.yuyalma_state for update
  using (true)
  with check (true);

-- Habilitar Realtime para esta tabla (para que los cambios se
-- reflejen automáticamente en otros dispositivos/pestañas abiertas).
alter publication supabase_realtime add table public.yuyalma_state;

-- Fila inicial vacía (la app la completa sola con la semilla de
-- productos la primera vez que se abre si no encuentra datos).
insert into public.yuyalma_state (id, data)
values ('main', '{}'::jsonb)
on conflict (id) do nothing;
