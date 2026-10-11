## 1. Crear tabla

Crea una tabla de clasificación para almacenar los nombres de los jugadores y sus puntuaciones.

```sql
create table leaderboard (
  id serial primary key,
  player text not null,
  score integer not null default 0,
  created_at timestamptz default now()
);
```

## 2. Habilitar el acceso a la API de datos para el rol `anon`
Exponga la tabla `leaderboard` a través de la API de datos para que pueda consultarse mediante HTTP. Una tabla de clasificación debe ser pública, por lo que los clientes anónimos solo necesitan acceso de lectura.

