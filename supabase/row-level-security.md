# Seguridad a nivel de fila (Row Level Security)

## Contenido
- [Comprender la seguridad a nivel de fila (RLS)](#comprender-la-seguridad-a-nivel-de-fila): explica cómo se combinan los permisos y las políticas para controlar el acceso
- [Proteger una tabla mediante RLS]: es el procedimiento que debe seguirse para cada tabla en un esquema expuesto: permisos (grants), políticas y la base de datos de pruebas de Supabase.
---

## Comprender la seguridad a nivel de fila

### ¿Qué hace una política?
Las `políticas` son el motor de reglas de **PostgreSQL**. Cada política está asociada a una tabla y se ejecuta cada vez que se accede a ella.

Piensa en una política como si añadieras una cláusula `WHERE` a cada consulta. Una política como esta, evita que un usuario pueda ver las tareas de otros usuarios:
```sql
create policy "Los usuarios solo pueden ver sus propias tareas pendientes."
on tareas -- indica la tabla
for select -- en qué acción se activará la política
to authenticated -- la política se aplica a los usuarios que iniciaron sesión
using ( (select auth.uid()) = user_id ); -- condición para permitir el "select" (el resultado debe ser booleano)
```

> [!NOTE]
> `auth.uid()` es una función de **Supabase** que retorna el ID único del usuario que está realizando la consulta.

Esa política se traduce en lo siguiente cada vez que un usuario selecciona un elemento de la tabla de `tareas`:
```sql
select *
from tareas
where auth.uid() = tareas.user_id;
-- La política se añade de forma implícita.
```

### Roles
**Supabase** asigna cada consulta a uno de los roles:

- **`anon`**: una solicitud no autenticada (el usuario no ha iniciado sesión)
- **`authenticated`**: una solicitud autenticada (el usuario ha iniciado sesión)

Estos son roles de `Postgres`. Puedes utilizar estos roles dentro de tus políticas después de la palabra `TO`:
```sql
create policy "Los perfiles son visibles por todos"
on perfiles for select
to authenticated, anon
using ( true );

-- O también

create policy "Los perfiles públicos solo pueden ser vistos por usuarios autenticados."
on perfiles for select
to authenticated
using ( true );
```













