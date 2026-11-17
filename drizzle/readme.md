# Drizzle ORM

## Contenido
- [Instalación](#instalación)
- [Esquema](#esquema)
- [Conexión a la base de datos](#conexión-a-la-base-de-datos)
- [Configuración](#configuración)
- [Migraciones](#migraciones)
- [Studio](#studio)

---

## Instalación
Vamos a configurar Drizzle para nuestro proyecto. Primero, instale los paquetes necesarios:

```bash
npm install drizzle-orm @neondatabase/serverless
```
```bash
npm install -D drizzle-kit
```

El paquete `drizzle-orm` es el ORM en sí mismo. El paquete `@neondatabase/serverless` es el controlador de PostgreSQL optimizado para entornos *serverless* como Vercel, donde la base de datos se ejecuta en Neon. El paquete `drizzle-kit` es una herramienta de línea de comandos (CLI) para gestionar las migraciones de la base de datos.

## Esquema
A continuación, definimos el esquema de la base de datos. Creamos un archivo `db/schema.ts` en la raíz con el siguiente contenido:

```javascript
import { pgTable, serial, text, boolean } from "drizzle-orm/pg-core"

export const notes = pgTable("notes", {
  id: serial("id").primaryKey(),
  content: text("content").notNull(),
  important: boolean("important").notNull().default(false),
})
```

Esto define una tabla llamada `notes` con tres columnas:

- `id`: de tipo `serial`, lo que significa que es un entero autoincremental, marcada como clave primaria de la tabla.
- `content`: de tipo `text`, equivalente al tipo `TEXT` de SQL, marcada como `not null`, lo que implica que toda nota debe tener contenido.
- `important`: de tipo `boolean`, que almacena valores `true` o `false`, también marcada como `not null` y con un valor predeterminado de `false`.

Observa que el esquema es simplemente código TypeScript.

## Conexión a la base de datos
A continuación, creamos la conexión a la base de datos en el archivo `db/index.ts`:

```javascript
import { drizzle } from "drizzle-orm/neon-http"
import * as schema from "./schema"

export const db = drizzle(process.env.DATABASE_URL!, { schema })
```

La función `drizzle` de `drizzle-orm/neon-http` crea una conexión a la base de datos compatible con entornos *serverless*, 
utilizando la cadena de conexión proveniente de nuestra variable de entorno. El controlador `neon-http` está optimizado para entornos *serverless*: 
se comunica con la base de datos Neon a través de HTTP, por lo que no es necesario gestionar una conexión persistente.

El objeto `db` resultante es un generador de consultas tipado que podemos utilizar en toda nuestra aplicación.

## Configuración
Por último, necesitamos un archivo de configuración de Drizzle para la herramienta de migración que vamos a crear; este archivo, llamado `drizzle.config.ts`, 
debe ubicarse en la raíz del proyecto:

```js
import { defineConfig } from "drizzle-kit"

import * as dotenv from "dotenv"
dotenv.config({ path: ".env.local" })

export default defineConfig({
  schema: "./db/schema.ts",
  out: "./drizzle",
  dialect: "postgresql",
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
})
```

Esto le indica a `Drizzle Kit` dónde encontrar el esquema, dónde generar los archivos de migración y cómo conectarse a la base de datos.

También necesitamos instalar dos paquetes más:
```bash
npm install --save-dev dotenv postgres
```

El paquete `dotenv` es necesario porque los comandos de la CLI de Drizzle Kit se ejecutan como scripts de Node.js estándar, fuera del entorno de ejecución de Next.js. 
Aunque Next.js carga automáticamente el archivo `.env.local` para el código de tu aplicación, Drizzle Kit no se beneficia de ello. 


Al importar `dotenv` y llamar a `dotenv.config({ path: ".env.local" })` al principio de `drizzle.config.ts`, hacemos que la variable `DATABASE_URL` esté disponible 
para Drizzle Kit cuando este se conecta a la base de datos para ejecutar migraciones o abrir Drizzle Studio.

Nuestra aplicación utiliza el controlador `@neondatabase/serverless`, el cual se comunica con la base de datos a través de HTTP. 
Sin embargo, los comandos de la CLI de Drizzle Kit requieren una conexión más tradicional con la base de datos. Si no se tiene instalado el paquete `postgres`, 
los comandos de Drizzle Kit mostrarán advertencias sobre la ausencia de ciertas dependencias.

## Migraciones
Ahora podemos generar la migración y aplicarla a la base de datos:

```bash
npx drizzle-kit generate
```
```bash
npx drizzle-kit migrate
```

El primer comando lee el esquema y genera archivos de migración SQL en el directorio `drizzle`. El segundo comando aplica dichas migraciones a la base de datos, 
creando la tabla `notes`.

## Studio
Podemos verificar que la tabla se creó ejecutando:

```bash
npx drizzle-kit studio
```

Esto abre `Drizzle Studio`, un explorador visual de bases de datos, en la dirección `https://local.drizzle.studio`, donde podemos ver nuestra tabla de notas y sus columnas.

Añadamos también un par de notas a la base de datos:

<img width="1279" height="482" alt="image" src="https://github.com/user-attachments/assets/452d0f3a-78f8-475c-a1e1-f18a46aff166" />











