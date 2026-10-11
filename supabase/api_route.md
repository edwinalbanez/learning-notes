# 1. Uso de esquemas personalizados
Por defecto, su base de datos tiene un esquema `public` que se expone automáticamente en las API de datos.

## 1.1 Creación de esquemas personalizados 
Puedes crear tu propio esquema personalizado ejecutando la siguiente consulta SQL, sustituyendo `myschema` por el nombre que quieras usar para tu esquema:
```sql
CREATE SCHEMA myschema;
```

## 1.2 Exponiendo esquemas personalizados
Puedes exponer esquemas de base de datos personalizados; para ello, debes seguir estos pasos:

- Ve a la configuración de la API y agrega tu esquema personalizado a "Esquemas expuestos".
<img width="706" height="233" alt="image" src="https://github.com/user-attachments/assets/050e8446-3ae2-4117-ab46-fed778d440e4" />
 
 - Ejecute la siguiente consulta SQL, sustituyendo `myschema` por el nombre de su esquema:
```sql
  GRANT USAGE ON SCHEMA myschema TO anon, authenticated, service_role;
  GRANT ALL ON ALL TABLES IN SCHEMA myschema TO anon, authenticated, service_role;
  GRANT ALL ON ALL ROUTINES IN SCHEMA myschema TO anon, authenticated, service_role;
  GRANT ALL ON ALL SEQUENCES IN SCHEMA myschema TO anon, authenticated, service_role;
  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA myschema GRANT ALL ON TABLES TO anon, authenticated, service_role;
  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA myschema GRANT ALL ON ROUTINES TO anon, authenticated, service_role;
  ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA myschema GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;
```

---
# 2. Crea una ruta API

## 2.1 Crear tabla

Crea una tabla de clasificación para almacenar los nombres de los jugadores y sus puntuaciones.

```sql
create table leaderboard (
  id serial primary key,
  player text not null,
  score integer not null default 0,
  created_at timestamptz default now()
);
```

## 2.2 Habilitar el acceso a la API de datos para el rol `anon`
Exponga la tabla `leaderboard` a través de la API de datos para que pueda consultarse mediante HTTP. Una tabla de clasificación debe ser pública, por lo que los clientes anónimos solo necesitan acceso de lectura.

```sql
-- Permitir acceso de solo lectura a clientes anónimos y autenticados
grant select on table myschema.leaderboard to anon, authenticated;
```

## 2.3 Configurar RLS
Habilite la seguridad a nivel de fila (RLS) para esta tabla y cree las políticas que controlan quién puede leer y escribir filas. En una tabla de clasificación, cualquier persona debería poder leer las puntuaciones. Solo los usuarios autenticados deberían poder enviarlas o actualizarlas.

```sql
-- Activar RLS
alter table myschema.leaderboard
enable row level security;

-- Cualquiera puede consultar la tabla de clasificación.
create policy "La clasificación es pública."
  on myschema.leaderboard
  for select
  to anon, authenticated
  using (true);

-- Los usuarios autenticados pueden enviar y actualizar puntuaciones.
create policy "Los usuarios autenticados pueden enviar puntuaciones."
  on myschema.leaderboard
  for insert
  to authenticated
  with check (true);

create policy "Los usuarios autenticados pueden actualizar las puntuaciones."
  on myschema.leaderboard
  for update
  to authenticated
  using (true)
  with check (true);
```
