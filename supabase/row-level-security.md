# Seguridad a nivel de fila (Row Level Security)

## Contenido
- [Comprender la seguridad a nivel de fila (RLS)](#comprender-la-seguridad-a-nivel-de-fila): explica cómo se combinan los permisos y las políticas para controlar el acceso
- [Proteger una tabla con RLS](#proteger-una-tabla-con-rls): es el procedimiento que debe seguirse para cada tabla en un esquema expuesto: permisos (grants), políticas y la base de datos de pruebas de Supabase.
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
using ( (select auth.uid()) = user_id ); -- el ID del usuario que inició sesión debe ser el mismo que la columna "user_id"
```

> [!NOTE]
> `auth.uid()` es una función de **Supabase** que retorna el ID único del usuario que está realizando la consulta.

Esa política se traduce en lo siguiente cada vez que un usuario selecciona un elemento de la tabla de `tareas`:
```sql
select *
from tareas
where auth.uid() = tareas.user_id; -- La política se añade de forma implícita.
```

---

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
> [!IMPORTANT]
> Una política que permite el acceso de lectura (`select`) al rol `anon` mediante `USING (true)` otorga a cualquier visitante no autenticado acceso de lectura a todas las filas de la tabla `perfiles`. Utilízala únicamente para datos destinados a ser públicos.

---

### Permisos y políticas

**Postgres** realiza dos comprobaciones antes de que un usuario acceda a una tabla:

- Los **`permisos`** (grants) determinan si un rol **puede o no** realizar una operación (`select`, `insert`, etc) sobre la tabla.
- Si el usuario tiene permiso; entonces, las **`políticas`** verifican a qué filas se puede aplicar dicha operación.

Configura ambos elementos para cada tabla que expongas.

> [!IMPORTANT]
> Añadir políticas `no revoca` los permisos concedidos. Una tabla protegida únicamente mediante políticas `sigue permitiendo` a un usuario anónimo realizar inserciones, siempre y cuando no se revoque el permiso correspondiente.

---

## Proteger una tabla con RLS

### Habilita RLS y establece los permisos

Ejecuta el siguiente código SQL utilizando el editor SQL en el panel de control (Dashboard) de Supabase. Habilita RLS y, a continuación, configura los permisos para que se ajusten a las funciones de cada rol en tu aplicación:

#### 1. Habilita `RLS` en la tabla.
```sql
alter table public.reportes enable row level security;
```
  Una vez habilitada la RLS, no es posible acceder a ningún dato a través de la API mediante una clave publicable hasta que se creen políticas.

#### 2. Revoca cualquier permiso existente en los roles `anon` y `authenticated`.
```sql
revoke all on table public.reportes from anon, authenticated;
```

#### 3. Concede únicamente los privilegios que el rol necesita.
```sql
-- Los usuarios que han iniciado sesión pueden gestionar los informes. Los que no han iniciado sesión no tienen acceso a nada.
grant select, insert, update, delete on table public.reports to authenticated;
```

### Escribir una política para cada operación.

Crea una política independiente para cada una de las operaciones: `SELECT`, `INSERT`, `UPDATE` y `DELETE`. Postgres no admite múltiples operaciones en una misma cláusula `FOR`, y una política `FOR ALL` oculta qué operación debía cubrir cada regla.

Estos ejemplos utilizan una tabla de perfiles en la que cada usuario solo tiene acceso a su propia fila. Primero, realizamos los 3 pasos anteriores:

```sql
create table perfiles (
  id uuid primary key,
  user_id uuid references auth.users,
  avatar_url text
);

-- Habilita RLS en la tabla.
alter table perfiles enable row level security;

--- Revoca cualquier permiso existente en los roles anon y authenticated
revoke all on table perfiles from anon, authenticated;

-- Concede únicamente los privilegios que el rol necesita
grant select, insert, update, delete on table perfiles to authenticated;
```

> [!NOTE]
> **Supabase** ofrece funciones auxiliares que simplifican RLS si utilizas **Supabase Auth**. `auth.uid()` devuelve el ID del usuario que realiza la solicitud.

#### Políticas `SELECT`
Puedes especificar determinadas políticas mediante la cláusula `using`.

```sql
create policy "Los usuarios solo pueden ver su propio perfil."
on perfiles for select
to authenticated
using ( (select auth.uid()) = user_id ); -- el ID del usuario que inició sesión debe ser el mismo que la columna "user_id"
```

#### Políticas `INSERT`
Puedes especificar políticas de inserción mediante la cláusula `with check`. La expresión `with check` garantiza que cualquier fila nueva cumpla con las restricciones de la política, en este ejemplo, un usuario no puede crear una fila que pertenezca a otra persona.

```sql
create policy "Los usuarios pueden crear su propio perfil."
on perfiles for insert
to authenticated
with check ( (select auth.uid()) = user_id );
```
Cada vez que se crea una nueva fila, el ID del usuario que inició sesión debe ser el mismo que se registró en la columna `user_id`.

#### Políticas `UPDATE`
Puedes especificar políticas de actualización combinando las expresiones `using` y `with check`. La cláusula `using` determina qué filas existentes **pueden** actualizarse. La cláusula `with check` define cómo debe ser la fila resultante, lo que impide que un usuario reasigne el `user_id` a otra persona.

```sql
create policy "Los usuarios pueden actualizar su propio perfil."
on perfiles for update
to authenticated
using ( (select auth.uid()) = user_id )       -- ¿Se puede actualizar esta fila?
with check ( (select auth.uid()) = user_id ); -- ¿Cómo debe quedar la fila después de actualizar?
```
Si no se define ninguna expresión de comprobación (`with check`), la expresión `using` determina tanto qué filas son visibles como qué filas nuevas están permitidas.

> [!IMPORTANT]
> Para realizar una operación `UPDATE`, se requiere una política `SELECT` antes. Sin una política `SELECT`, la operación `UPDATE` no funcionará según lo previsto.

#### Políticas `DELETE`
Puedes especificar políticas de eliminación mediante la cláusula `using`.

```sql
create policy "Los usuarios pueden eliminar su propio perfil."
on perfiles for delete
to authenticated
using ( (select auth.uid()) = user_id );
```



