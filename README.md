# Yuyalma · Lista de precios

App de una sola página (`index.html`) para gestionar el catálogo de
Yuyalma: agregar/editar productos, historial de precios, y exportar
la lista como Excel o como imagen (A4 o Historia de Instagram/WhatsApp)
con el diseño de la marca.

Los datos se guardan en **Supabase** (sincronizados entre cualquier
dispositivo) y también en el `localStorage` del navegador como
respaldo/caché instantáneo.

## 1) Crear el proyecto en Supabase

1. Entrá a [supabase.com](https://supabase.com) → **New project**.
2. Elegí nombre, contraseña de base de datos y región (`South America`
   si querés menor latencia) → **Create new project**.
3. Cuando termine de aprovisionar, andá a **SQL Editor** → **New query**.
4. Pegá el contenido de `supabase-schema.sql` (incluido en este repo)
   y tocá **Run**. Esto crea la tabla `yuyalma_state`, las políticas
   de acceso y activa Realtime.
5. Andá a **Project Settings → API**. Vas a necesitar dos valores:
   - **Project URL** (algo como `https://xxxxx.supabase.co`)
   - **anon public key** (una clave larga que empieza con `eyJ...`)

## 2) Configurar el HTML con esos datos

Abrí `index.html` y buscá, cerca del `</head>`, este bloque:

```html
<script>
  window.SUPABASE_URL = "https://TU-PROYECTO.supabase.co";
  window.SUPABASE_ANON_KEY = "TU-ANON-KEY-PUBLICA";
</script>
```

Reemplazá los dos valores por los tuyos y guardá. **La `anon key` está
pensada para ser pública** (va en el navegador de cualquier visitante);
la seguridad real la dan las políticas de la tabla, no el secreto de
esa clave.

> Si preferís no tocar el HTML a mano, podés generar ese bloque desde
> Vercel con una variable de entorno y un pequeño build step, pero
> para este proyecto (sitio estático simple) es más simple así.

## 3) Subir el proyecto a GitHub

```bash
git init
git add .
git commit -m "Yuyalma: lista de precios con Supabase"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/TU-REPO.git
git push -u origin main
```

(Podés crear el repo vacío primero en github.com → **New repository**,
sin README, y usar la URL que te da ahí en el `remote add`.)

## 4) Desplegar en Vercel

1. Entrá a [vercel.com](https://vercel.com) → **Add New… → Project**.
2. Importá el repositorio de GitHub que acabás de crear.
3. Framework Preset: **Other** (es HTML estático, no necesita build).
   Dejá "Build Command" y "Output Directory" vacíos/por defecto.
4. **Deploy**. En un minuto tenés una URL tipo
   `https://tu-proyecto.vercel.app` que podés abrir desde cualquier
   celular, PC o tablet — todos van a ver y editar la misma lista.

Cada vez que hagas `git push` a `main`, Vercel vuelve a desplegar
automáticamente.

## 5) Probar que la sincronización funciona

1. Abrí la URL de Vercel en dos pestañas o dos dispositivos distintos.
2. En letras chiquitas, abajo del logo en el menú lateral, debería
   decir **"Sincronizado con Supabase ☁️"** (si dice "Solo en este
   equipo", revisá el paso 2).
3. Editá un precio en una pestaña → en unos segundos debería
   actualizarse solo en la otra (gracias a Supabase Realtime), y
   además queda guardado para la próxima vez que abras la app desde
   cualquier lugar.

## Exportar imágenes

Desde el botón **Exportar** podés elegir:
- **A4** (210×297mm): para imprimir o mandar por PDF.
- **Historia** (1080×1920px): pensada para subir directo a estados
  de WhatsApp / Instagram / Facebook, con tipografía grande y legible.

Si la lista no entra en una sola hoja/historia, la app genera
automáticamente varias imágenes numeradas ("Página 1 de 2", etc.),
manteniendo el mismo encabezado y pie en todas.

## Estructura de archivos

```
index.html            → la app completa (HTML + CSS + JS, un solo archivo)
supabase-schema.sql    → script SQL para crear la tabla en Supabase
README.md              → este archivo
```
