# Seguridad a nivel de fila (Row Level Security)

> [!CAUTION]
> Una tabla en un esquema expuesto sin `RLS` puede ser **leída y modificada** por cualquier rol que tenga permisos sobre ella. Habilita `RLS` en todas las tablas de un esquema expuesto.
> En proyectos que aún conceden permisos a los roles `anon` y `authenticated` de forma predeterminada, revoca dichos permisos. 
> Añadir políticas no elimina los permisos existentes.
