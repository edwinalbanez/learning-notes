# Guía para MongoDB

## Índice

1. [Instalación y configuración](#1-instalación-y-configuración)
   - [Pasos de instalación](#pasos-de-instalación)
   - [Configuración de variables de entorno](#configuración-de-variables-de-entorno)

2. [Colecciones y documentos](#2-colecciones-y-documentos)
   - [Colecciones](#colecciones)
   - [Documentos y propiedades](#documentos-y-propiedades)
   - [Documentos embebidos](#documentos-embebidos)
     
3. [Tipos de datos](#3-tipos-de-datos)
   - [Datos básicos](#tipos-de-datos-básicos)
   - [Datos complejos](#tipos-de-datos-complejos)
   - [Datos especializados](#tipos-de-datos-especializados)

4. [Relaciones de documentos](#4-relaciones-de-documentos)
   - [Uno a uno](#one-to-one-11)
   - [Uno a muchos](#one-to-many-1n)
   - [Muchos a muchos](#many-to-many-nm)

5. [JSON y BSON](#5-json-y-bson)
   - [¿Qué es JSON?](#qué-es-json)
   - [¿Qué es BSON?](#qué-es-bson)
   - [Diferencias clave](#diferencias-clave)

6. [Creación de bases de datos](#6-creación-de-bases-de-datos)
   
7. [Insertar documentos](#7-insertar-documentos)
   - [writeConcern](#writeconcern-opcional)
      - [Nodos de réplica](#qué-significa-nodos-de-réplica)
      - [Journal del servidor](#qué-es-el-journal-del-servidor)
   - [ordered](#ordered---opcional)
   - [bypassDocumentValidation](#bypassdocumentvalidation---opcional)
   
8. [Buscar documentos](#8-buscar-documentos)
   - [Búsquedas básicas](#búsquedas-básicas)
   - [Operadores de comparación](#operadores-de-comparación)
   - [Operadores lógicos](#operadores-lógicos)
   - [Búsquedas en arrays](#búsquedas-en-arrays)
   - [Búsquedas en documentos anidados](#búsquedas-en-documentos-anidados)
   - [Búsquedas en expresiones regulares](#búsquedas-con-expresiones-regulares)
   - [Proyección de campos](#proyección-de-campos)
   - [Limitación y ordenamiento](#limitación-y-ordenamiento)
   - [Métodos relacionados](#métodos-relacionados)
   - [Operadores avanzados](#operadores-avanzados)
     
9. [Actualizar documentos](#9-actualizar-documentos)
   - [Operadores de campo](#operadores-de-campo)
   - [Operadores de array](#operadores-de-array)
     
10. [Eliminar documentos](#10-eliminar-documentos)

11. [Usuarios y roles](#11-usuarios-y-roles)
    - [Niveles de usuarios](#niveles-de-usuarios)
    - [Sistema de roles](#sistema-de-roles)
    - [Consultar usuarios](#consultar-usuarios)
    - [Eliminar usuarios](#eliminar-usuario)

12. [Escribir scripts](#12-escribir-scripts-javascript)
    - [Ejecutar desde mongosh](#ejecutar-desde-mongosh)
    - [Ejecutar desde la línea de comandos](#ejecutar-desde-la-línea-de-comandos)
    - [Ejecutar con autenticación](#ejecutar-desde-la-línea-de-comandos-con-autenticación)
    - [Manejo de errores](#terminar-un-script-en-caso-de-error)
    - [Abrir una nueva conexión](#abrir-una-nueva-conexión)

13. [índices](#13-índices)
    - [Tipos de índices](#tipos-de-índices)
    - [Estrategia de indexación](#estrategias-de-indexación)
    - [Operaciones principales](#operaciones-principales)
    - [¿Cómo funcionan los índices?](#qué-son-realmente-los-índices-internamente)
    - [Analogía de listas](#analogía-de-listas)

---

# 1. Instalación y configuración

## Pasos de instalación

1. Descargar [MongoDB Community Server](https://www.mongodb.com/try/download/community).
2. Ejecuta el instalador y acepta el acuerdo de la licencia gratuita. > [Next]
3. Da click en `Complete` para realizar la instalación completa de la base de datos.
4. Desmarca la opción `Install DB as a Service` para evitar que el programa se ejecute permanentemente. > [Next]
5. Verifica que la opción `Install DB Compass` este marcada. > [Next]
6. Click en `Install`.

## Configuración de variables de entorno

1. Busca en la barra de tareas `Editar las variables de entorno del sistema`.
2. Click en `Variables de entorno...`.
3. Busca la carpeta donde se instalaron las librerias de la base de datos y tambien la ruta de la shell `mongosh` y copia ambas rutas. Las direcciones suelen ser:
   - Para el servidor: `C:\Program Files\MongoDB\Server\8.0\bin`
   - Para **mongosh**: `C:\Program Files\MongoDB\mongosh-2.2.5-win32-x64\bin`
4. En el área de `Variables de usuario`, da doble click en la variable `Path`
5. Da click en `Nuevo`, pega una de las rutas que copiaste y repite el paso para la otra ruta.
6. Ahora, haz click en `Aceptar` en todas las ventanas emergentes.
7. En la raiz `C:\` crea una carpeta llamada `data` y dentro crea otra llamada `db`.

Para verificar que la configuración funciona, abre el `Simbolo del sistema` y escribe `mongosh --version`, debería aparecer la versión de la shell de MongoDB.

# 2. Colecciones y documentos

## Elementos principales

<img width="466" height="313" alt="image" src="https://github.com/user-attachments/assets/53a0c57d-66df-4198-af45-8bb628ce13fa" />

## Colecciones

<img width="469" height="304" alt="image" src="https://github.com/user-attachments/assets/9d40f909-4fce-4a07-9116-76e81e5268f9" />

## Documentos y propiedades

<img width="422" height="260" alt="image" src="https://github.com/user-attachments/assets/ae1e4bcc-e55e-40a6-904d-9598ea092337" />

---

<img width="409" height="311" alt="image" src="https://github.com/user-attachments/assets/006eeb53-f573-4bea-a113-4666d81a69f8" />

## Documentos embebidos

<img width="419" height="435" alt="image" src="https://github.com/user-attachments/assets/d189e594-1ff7-4514-8329-2dcb5f810f47" />

---

# 3. Tipos de datos

## Tipos de datos básicos

### `String (Cadena)`
Texto codificado en UTF-8. Es el tipo más común para almacenar texto.

```json
{ "nombre": "Juan Pérez" }
```

### `Number`
MongoDB maneja números de diferentes formas:

- **Int32**: Enteros de 32 bits
- **Int64**: Enteros de 64 bits
- **Double**: Números de punto flotante de 64 bits (tipo por defecto)

### `Boolean`
Valores verdadero o falso.

```json
{ "activo": true }
```

### `Date`
Fechas almacenadas como milisegundos desde la época Unix (1 enero 1970).

```json
{ "fechaCreacion": new Date() }
```

## Tipos de datos complejos

### Object (Documento Embebido)
Otros documentos JSON anidados dentro del documento principal.

```json
{
  "direccion": {
    "calle": "Av. Principal 123",
    "ciudad": "San Salvador"
  }
}
```

### Array
Listas ordenadas que pueden contener cualquier tipo de dato, incluso tipos mixtos.

```json
{ "hobbies": ["lectura", "deporte", "música"] }
```

### ObjectId
Identificador único de 12 bytes que MongoDB genera automáticamente para el campo `_id`.

```json
{ "_id": ObjectId("507f1f77bcf86cd799439011") }
```

## Tipos de datos especializados

### `Binary Data`
Para almacenar datos binarios como imágenes o archivos.

### `Regular Expression`
Expresiones regulares para búsquedas de patrones.

### `JavaScript Code`
Código JavaScript que puede ejecutarse en el servidor.

### `Null`
Representa valores nulos o campos sin valor.

### `Undefined`
Similar a null, pero indica que el campo no está definido.

>[!IMPORTANT]
> MongoDB es `schema-flexible`, lo que significa que diferentes documentos en la misma colección pueden tener estructuras diferentes. Un documento puede tener campos que otros no tienen, y los tipos de datos pueden variar entre documentos.

---

# 4. Relaciones de documentos

## One-to-One (1:1)
En estas relaciones, cada documento se relaciona con exactamente un documento de otra colección.

## Estrategias:

### 1. Embebido (`Recomendado`)

Incluir los datos relacionados dentro del mismo documento:

```javascript
// Usuario con perfil embebido
{
  _id: ObjectId("..."),
  nombre: "Juan Pérez",
  email: "juan@email.com",
  perfil: {
    biografia: "Desarrollador Full Stack",
    avatar: "avatar.jpg",
    fechaNacimiento: "1990-05-15",
    telefono: "+503 7777-7777"
  }
}
```

**Cuándo usar**: Cuando los datos se consultan frecuentemente juntos y el documento embebido no es muy grande (< 16MB).

### 2. Referenciado
Mantener documentos separados con referencias:

```javascript
// Colección usuarios
{
  _id: ObjectId("user1"),
  nombre: "Juan Pérez",
  email: "juan@email.com"
}

// Colección perfiles
{
  _id: ObjectId("profile1"),
  usuarioId: ObjectId("user1"),
  biografia: "Desarrollador Full Stack",
  avatar: "avatar.jpg"
}
```

## One-to-Many (1:N)
Un documento se relaciona con múltiples documentos de otra colección.

## Estrategias:

### 1. Array embebido (Para "Few")
Cuando la cantidad de elementos relacionados es pequeña y fija:

```javascript
// Blog post con comentarios embebidos
{
  _id: ObjectId("..."),
  titulo: "Introducción a MongoDB",
  contenido: "...",
  comentarios: [
    {
      autor: "María",
      texto: "Excelente artículo",
      fecha: ISODate("2025-01-15")
    },
    {
      autor: "Carlos",
      texto: "Muy útil, gracias",
      fecha: ISODate("2025-01-16")
    }
  ]
}
```

**Cuándo usar**: Cuando hay pocos elementos relacionados (< 100) que no crecen indefinidamente.

### 2. Referenciado con array de IDs (Para "Many")

```javascript
// Autor
{
  _id: ObjectId("author1"),
  nombre: "Gabriel García Márquez",
  libros: [
    ObjectId("libro1"),
    ObjectId("libro2"),
    ObjectId("libro3")
  ]
}

// Libros
{
  _id: ObjectId("libro1"),
  titulo: "Cien años de soledad",
  autorId: ObjectId("author1")
}
```

**Cuándo usar**: Cuando la cantidad de elementos relacionados puede crecer significativamente.

### 3. Referencia inversa (Parent Reference)

```javascript
// Categoría
{
  _id: ObjectId("cat1"),
  nombre: "Tecnología"
}

// Productos (muchos)
{
  _id: ObjectId("prod1"),
  nombre: "Laptop Dell",
  categoriaId: ObjectId("cat1")
}
{
  _id: ObjectId("prod2"),
  nombre: "iPhone 15",
  categoriaId: ObjectId("cat1")
}
```

**Cuándo usar**: Cuando hay muchos elementos del lado "many" y necesitas consultar desde el lado "one".

## Many-to-Many (N:M)
Múltiples documentos se relacionan con múltiples documentos de otra colección.

## Estrategias:

### 1. Array de referencias en ambos lados

```javascript
// Estudiantes
{
  _id: ObjectId("est1"),
  nombre: "Ana López",
  cursos: [
    ObjectId("curso1"),
    ObjectId("curso2")
  ]
}

// Cursos
{
  _id: ObjectId("curso1"),
  nombre: "Matemáticas",
  estudiantes: [
    ObjectId("est1"),
    ObjectId("est2")
  ]
}
```

**Cuándo usar**: Cuando necesitas consultar frecuentemente desde ambos lados de la relación.

### 2. Colección de unión (Junction Collection)

```javascript
// Estudiantes
{
  _id: ObjectId("est1"),
  nombre: "Ana López"
}

// Cursos
{
  _id: ObjectId("curso1"),
  nombre: "Matemáticas"
}

// Inscripciones (colección de unión)
{
  _id: ObjectId("..."),
  estudianteId: ObjectId("est1"),
  cursoId: ObjectId("curso1"),
  fechaInscripcion: ISODate("2025-01-15"),
  calificacion: 95,
  estado: "activo"
}
```

**Cuándo usar**: Cuando la relación tiene atributos adicionales (metadatos) o cuando las relaciones son muy dinámicas.

## Criterios para elegir

### Embebido vs Referenciado

Usa `embebido` cuando:

- Los datos se consultan siempre juntos
- Los datos embebidos no cambian frecuentemente
- El tamaño total del documento < 16MB
- La cardinalidad es pequeña (1:1 o 1:few)

Usa `referenciado` cuando:

- Los datos se consultan independientemente
- Los datos relacionados cambian frecuentemente
- Hay muchos elementos relacionados (1:many)
- Necesitas consultas complejas sobre los datos relacionados

## Ejemplo ráctico: Sistema de E-commerce
```javascript
// Producto (documento principal)
{
  _id: ObjectId("prod1"),
  nombre: "Smartphone Samsung Galaxy",
  precio: 599.99,
  categoriaId: ObjectId("cat1"), // Referencia (pocas categorías)
  
  // Especificaciones embebidas (se consultan siempre juntas)
  especificaciones: {
    pantalla: "6.1 pulgadas",
    memoria: "128GB",
    camara: "48MP"
  },
  
  // Imágenes embebidas (cantidad limitada)
  imagenes: [
    "img1.jpg",
    "img2.jpg"
  ],
  
  // Tags embebidos (búsqueda frecuente)
  tags: ["smartphone", "android", "samsung"]
}

// Reseñas (colección separada - pueden ser muchas)
{
  _id: ObjectId("..."),
  productoId: ObjectId("prod1"),
  usuario: "María García",
  calificacion: 5,
  comentario: "Excelente producto",
  fecha: ISODate("2025-01-15")
}

// Inventario (colección separada - cambia frecuentemente)
{
  _id: ObjectId("..."),
  productoId: ObjectId("prod1"),
  stock: 50,
  ubicacion: "Bodega A-15",
  ultimaActualizacion: ISODate("2025-01-20")
}
```

---

# 5. JSON y BSON
MongoDB utiliza BSON (Binary JSON) como su formato de almacenamiento interno, aunque interactúas con los datos a través de JSON. Esta diferencia fundamental tiene implicaciones importantes para entender cómo funciona MongoDB.

## ¿Qué es JSON?
JSON (JavaScript Object Notation) es un formato de intercambio de datos basado en texto plano que representa objetos JavaScript. Es legible por humanos y ampliamente utilizado en aplicaciones web. Un documento JSON típico se ve así:

```json
{
  "nombre": "Juan",
  "edad": 30,
  "activo": true,
  "hobbies": ["lectura", "deportes"]
}
```

## ¿Qué es BSON?
BSON (Binary JSON) es una representación binaria de documentos similares a JSON, desarrollada específicamente para MongoDB. Aunque conceptualmente similar a JSON, BSON tiene características adicionales que lo hacen más eficiente para el almacenamiento y procesamiento de bases de datos.

## Diferencias clave

**Formato de almacenamiento**: JSON es texto plano, mientras que BSON es un formato binario. Esto significa que BSON no es legible directamente por humanos, pero es más eficiente para que las máquinas lo procesen.

**Tipos de datos**: JSON tiene un conjunto limitado de tipos: string, number, boolean, array, object y null. BSON extiende estos tipos significativamente, incluyendo:

- ObjectId (identificadores únicos de MongoDB)
- Date (fechas con precisión de milisegundos)
- BinData (datos binarios)
- NumberInt y NumberLong (enteros de 32 y 64 bits)
- Decimal128 (números decimales de alta precisión)
- Regular expressions
- JavaScript code

**Tamaño**: BSON generalmente ocupa más espacio que JSON porque incluye información adicional sobre los tipos de datos y metadatos para facilitar el procesamiento. Sin embargo, esta sobrecarga se compensa con la eficiencia en las operaciones.

**Velocidad de Procesamiento**: BSON está optimizado para ser rápido de recorrer y modificar. Los documentos BSON incluyen información de longitud que permite saltar campos sin parsear todo el contenido, lo cual es crucial para las consultas eficientes en bases de datos.

---

# 6. Creación de bases de datos
Abre una consola (Simbolo del sistema) y realiza estos pasos:

### Iniciar el servicio de MongoDB
```bash
mongod
```

### Conectarse al servicio
Abre una nueva consola y ejecuta:

```bash
mongosh
```

### Crear/seleccionar una base de datos
```bash
use mydatabase
```

### Verificar la base de datos actual:
```bash
db
```

### Mostrar la lista de bases de datos
```bash
show dbs
```

>[!IMPORTANT]
> La base de datos que acabas de crear no aparecerá en la lista hasta que contenga al menos un documento.


### Ver el tamaño de la base de datos
```javascript
db.stats()
```

### Eliminar la base de datos actual
```javascript
db.dropDatabase()
```

---

# 7. Insertar documentos

## `insertOne()`
Este método se usa para añadir un único documento a una colección.
```javascript
db.usuarios.insertOne({
    nombre: "Juan",
    edad: 30,
    email: "juan@email.com",
    activo: true
})
```

## `insertMany()`
Este método se utiliza para insertar **múltiples documentos** en una colección en una sola operación.
```javascript
db.usuarios.insertMany([
    {nombre: "María", edad: 25, email: "maria@email.com"},
    {nombre: "Pedro", edad: 35, email: "pedro@email.com"},
    {nombre: "Ana", edad: 28, email: "ana@email.com"}
])
```

>[!NOTE]
> Si la colección no existe se crea automáticamente al insertar un documento. También es posible crear una coleccón explícitamente:
> ```javascript
> db.createCollection("usuarios")
> ```

---


## `writeConcern` (opcional)
El parámetro `writeConcern` es un documento que se pasa como segundo argumento a los métodos `insertOne()` y `insertMany()`.

```javascript
db.collection.insertOne(
   <documento>,
   {
      writeConcern: <documento>
   }
)
```

Controla el nivel de confirmación requerido para una operación de escritura. En otras palabras, define cuántas réplicas (`nodos`) de tu conjunto de réplicas de MongoDB deben confirmar la escritura para que la operación se considere exitosa.

### Sintaxis
```javascript
{
   writeConcern: {
      w: <valor>,           // Nivel de confirmación
      j: <boolean>,         // Confirmación de journal
      wtimeout: <número>    // Tiempo límite en milisegundos
   }
}
```

### `w`: 
Define el número de nodos de réplica que deben confirmar la escritura.

- `w: 1` (**valor por defecto**): La operación se considera exitosa tan pronto como el nodo primario la ha procesado.
- `w: "majority"`: La operación se considera exitosa solo después de que la mayoría de los nodos en el conjunto de réplicas han confirmado la escritura. Esto asegura una mayor durabilidad de los datos.
- `w: <número>`: Un número específico de nodos que deben confirmar la escritura.

### `j`:
Un valor booleano que indica si la escritura debe ser confirmada en el journal del servidor. 

Si es `true`, la operación no se considerará exitosa hasta que los datos se hayan escrito en el `journal`. Esto proporciona una mayor garantía de que la escritura persistirá incluso si el servidor se reinicia inesperadamente.

### `wtimeout`: 
Un valor numérico que define un límite de tiempo en milisegundos para que la operación se complete. Si la escritura no se confirma en el tiempo especificado, MongoDB devolverá un error.

## ¿Qué significa "nodos de réplica"?
Los **nodos de réplica** son servidores MongoDB que forman parte de un `Replica Set` (**conjunto de réplicas**), que es un grupo de instancias MongoDB que mantienen el mismo conjunto de datos.

### Estructura de un `Replica Set`

#### Nodo Primario (Primary)

- Es el **único** nodo que puede recibir operaciones de escritura
- Todas las escrituras se realizan aquí **primero**
- Procesa las operaciones de lectura por defecto
- Solo puede haber uno por replica set

#### Nodos Secundarios (Secondary)

- Replican automáticamente los datos del nodo primario
- Son de solo lectura (a menos que se configure específicamente)
- Pueden convertirse en primario si el actual falla
- Puede haber múltiples nodos secundarios

#### Nodo Árbitro (Arbiter) - Opcional

- No almacena datos, solo participa en elecciones
- Ayuda a mantener un número impar de nodos votantes
- Consume menos recursos


## ¿Qué es el `journal` del servidor?
Es un archivo de registro que almacena las operaciones de escritura antes de que se apliquen a los archivos de datos principales. Esto es crucial para la recuperación en caso de un fallo inesperado del servidor (como un corte de energía).

Aquí está cómo funciona:

1. Una operación de escritura llega a la base de datos.
2. MongoDB escribe esta operación en el **journal**.
3. Si la operación es confirmada en el journal, se considera persistente.
4. Más tarde, en un proceso asincrónico (o en puntos de control programados), MongoDB aplica los datos del journal a los archivos de datos reales.

Si el servidor se detiene inesperadamente (por ejemplo, debido a un apagón) antes de que los datos se escriban en los archivos principales, el journal le permite a MongoDB reproducir las operaciones faltantes desde el último punto de control, asegurando que no se pierdan datos.

## `ordered` - (opcional)
La opción `ordered` en el método `insertMany` de MongoDB es un parámetro que controla cómo se comporta la operación cuando encuentra un error durante la inserción de múltiples documentos.

```javascript
db.collection.insertMany(
   [ <documento1>, <documento2>, ... ],
   {
      writeConcern: <documento>,
      ordered: <booleano>
   }
)
```

### `ordered: true` ( por defecto)
Cuando `ordered` está establecido en `true`, MongoDB:

- Procesa los documentos **secuencialmente** en el orden que aparecen en el array
- Si encuentra un error en cualquier documento, **detiene inmediatamente** la operación
- Los documentos que se procesaron exitosamente antes del error **sí se insertan**
- Los documentos posteriores al error **no se procesan**

### `ordered: false`
Cuando `ordered` está establecido en `false`, MongoDB:

- Puede procesar los documentos en **paralelo** (no necesariamente en orden)
- Continúa procesando **todos los documentos** aunque encuentre errores
- Todos los documentos válidos se insertan, independientemente de los errores
- Los errores se reportan al final de la operación

## `bypassDocumentValidation` - (opcional)
La opción `bypassDocumentValidation` en el metodo `insertMany()` permite omitir las reglas de validación de documentos que hayas configurado en una colección durante operaciones de escritura.

```javascript
db.collection.insertMany(
  [documento1, documento2, ...],
  {
    ordered: <boolean>,     
    writeConcern: <document>,
    bypassDocumentValidation: <boolean> 
  }
)
```

- `bypassDocumentValidation: false` (por defecto): se aplican las validaciones en los documentos.
- `bypassDocumentValidation: true`: se omiten las validaciones establecidas.

---

# 8. Buscar documentos

## `find()`
El método `find` es la operación fundamental para buscar documentos en MongoDB. Su sintaxis básica es:

```javascript
db.collection.find(query, projection)
```

## Búsquedas básicas

### Buscar todos los documentos:
```javascript
db.usuarios.find()
```

### Buscar con condiciones específicas:
```javascript
// Buscar usuarios con edad igual a 25
db.usuarios.find({edad: 25})

// Buscar usuarios con nombre "Juan"
db.usuarios.find({nombre: "Juan"})
```

## Operadores de comparación
MongoDB ofrece varios operadores para realizar comparaciones más complejas:

```javascript
// Mayor que ($gt)
db.usuarios.find({edad: {$gt: 18}})

// Mayor o igual que ($gte)
db.usuarios.find({edad: {$gte: 18}})

// Menor que ($lt)
db.usuarios.find({edad: {$lt: 65}})

// Menor o igual que ($lte)
db.usuarios.find({edad: {$lte: 65}})

// No igual ($ne)
db.usuarios.find({estado: {$ne: "inactivo"}})

// Valores dentro de un array ($in)
db.usuarios.find({ciudad: {$in: ["Madrid", "Barcelona", "Valencia"]}})

// Valores que NO están en un array ($nin)
db.usuarios.find({ciudad: {$nin: ["Madrid", "Barcelona"]}})
```

## Operadores lógicos

### `AND` implícito (múltiples condiciones):
```javascript
db.usuarios.find({edad: {$gte: 18}, ciudad: "Madrid"})
```

### `OR` explícito:
```javascript
db.usuarios.find({
  $or: [
    {edad: {$lt: 18}},
    {edad: {$gt: 65}}
  ]
})
```

### `AND` explícito:
```javascript
db.usuarios.find({
  $and: [
    {edad: {$gte: 18}},
    {ciudad: "Madrid"}
  ]
})
```

### `NOT`:
```javascript
db.usuarios.find({
  edad: {$not: {$gt: 25}}
})
```

## Búsquedas en arrays
```javascript
// Buscar documentos que contengan un valor específico en un array
db.usuarios.find({hobbies: "lectura"})

// Buscar documentos que contengan TODOS los valores especificados
db.usuarios.find({hobbies: {$all: ["lectura", "música"]}})

// Buscar por el tamaño del array
db.usuarios.find({hobbies: {$size: 3}})

// Buscar elementos en posiciones específicas del array
db.usuarios.find({"hobbies.0": "lectura"})
```

## Búsquedas en documentos anidados
```javascript
// Buscar en un campo anidado
db.usuarios.find({"direccion.ciudad": "Madrid"})

// Buscar documento completo anidado
db.usuarios.find({
  direccion: {
    calle: "Gran Vía 1",
    ciudad: "Madrid",
    codigo_postal: "28013"
  }
})
```

## Búsquedas con expresiones regulares
```javascript
// Buscar nombres que empiecen con "Juan"
db.usuarios.find({nombre: /^Juan/})

// Buscar nombres que contengan "ana" (insensible a mayúsculas)
db.usuarios.find({nombre: /ana/i})

// Usando el operador $regex
db.usuarios.find({
  nombre: {
    $regex: "^Juan",
    $options: "i"
  }
})
```

## Proyección de campos
La proyección te permite especificar qué campos incluir o excluir en los resultados:

```javascript
// Incluir solo nombre y edad
db.usuarios.find({}, {nombre: 1, edad: 1})

// Excluir el campo _id
db.usuarios.find({}, {nombre: 1, edad: 1, _id: 0})

// Excluir campos específicos
db.usuarios.find({}, {password: 0, datos_privados: 0})
```

## Limitación y ordenamiento
```javascript
// Limitar resultados
db.usuarios.find().limit(10)

// Ordenar (1 = ascendente, -1 = descendente)
db.usuarios.find().sort({edad: 1, nombre: -1})

// Saltar documentos (paginación)
db.usuarios.find().skip(20).limit(10)

// Combinar todo
db.usuarios.find({edad: {$gte: 18}})
  .sort({nombre: 1})
  .skip(10)
  .limit(5)
```

## Métodos relacionados

### `findOne()` - Buscar un solo documento:
```javascript
db.usuarios.findOne({email: "juan@ejemplo.com"})
```

### `count()` - Contar documentos:
```javascript
db.usuarios.find({edad: {$gte: 18}}).count()
// O usando countDocuments() (recomendado)
db.usuarios.countDocuments({edad: {$gte: 18}})
```

### `distinct()` - Valores únicos:
```javascript
db.usuarios.distinct("ciudad")
```

## Operadores avanzados

### Verificar existencia de campos:
```javascript
// Documentos que tienen el campo "telefono"
db.usuarios.find({telefono: {$exists: true}})

// Documentos que NO tienen el campo "telefono"
db.usuarios.find({telefono: {$exists: false}})
```

### Verificar tipo de datos:
```javascript
// Buscar donde edad es un número
db.usuarios.find({edad: {$type: "number"}})

// Buscar donde fecha es un objeto Date
db.usuarios.find({fecha_registro: {$type: "date"}})
```

## Agregación básica con `find()`
```javascript
// Usar $where para lógica JavaScript personalizada (usar con cuidado)
db.usuarios.find({
  $where: "this.edad > this.años_experiencia * 2"
})
```

## Índices para optimizar búsquedas
Para mejorar el rendimiento de las búsquedas, es importante crear índices:

```javascript
// Crear índice simple
db.usuarios.createIndex({email: 1})

// Crear índice compuesto
db.usuarios.createIndex({edad: 1, ciudad: 1})

// Ver qué índices existen
db.usuarios.getIndexes()
```

## Ejemplos prácticos:
```javascript
// Buscar usuarios activos de Madrid entre 25 y 40 años
db.usuarios.find({
  estado: "activo",
  ciudad: "Madrid",
  edad: {$gte: 25, $lte: 40}
}).sort({fecha_registro: -1})

// Buscar productos con precio entre 50 y 200, en stock
db.productos.find({
  precio: {$gte: 50, $lte: 200},
  stock: {$gt: 0},
  categoria: {$in: ["electrónica", "informática"]}
}).limit(20)
```

---

# 9. Actualizar documentos

Actualizar un documento (**el primero que coincida**):

```javascript
db.usuarios.updateOne(
    {nombre: "Juan"},  // filtro
    {$set: {edad: 31, ciudad: "Madrid"}}  // actualización
)
```

Actualizar múltiples documentos:
```javascript
db.usuarios.updateMany(
    {edad: {$gte: 30}},  // filtro: edad mayor o igual a 30
    {$set: {categoria: "senior"}}
)
```

Reemplazar un documento completo:
```javascript
db.usuarios.replaceOne(
    {nombre: "Juan"},
    {nombre: "Juan Carlos", edad: 32, email: "juancarlos@email.com", activo: true}
)
```

## Operadores de actualización más comunes:

### Operadores de campo

### `$set` - Establece el valor de un campo
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $set: { nombre: "Juan", edad: 30 } }
)
```

### `$unset` - Elimina un campo del documento
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $unset: { telefono: "" } }
)
```

### `$rename` - Renombra un campo
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $rename: { "nombre_completo": "nombre" } }
)
```

### `$inc` - Incrementa un valor numérico
```javascript
db.productos.updateOne(
  { _id: ObjectId("...") },
  { $inc: { precio: 10, stock: -1 } }
)
```

### `$mul` - Multiplica un valor numérico
```javascript
db.productos.updateOne(
  { _id: ObjectId("...") },
  { $mul: { precio: 1.1 } } // Aumenta precio 10%
)
```

### `$min` y `$max` - Actualiza solo si el nuevo valor es menor/mayor
```javascript
db.productos.updateOne(
  { _id: ObjectId("...") },
  { $min: { precio: 100 } } // Solo actualiza si 100 es menor al precio actual
)
```

### `$currentDate` - Establece la fecha/hora actual
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $currentDate: { 
    ultimaModificacion: true,
    timestamp: { $type: "timestamp" }
  }}
)
```

### Operadores de array

### `$push` - Añade elementos al final de un array
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $push: { hobbies: "natación" } }
)

// Con múltiples elementos
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $push: { hobbies: { $each: ["natación", "lectura"] } } }
)
```

### `$pop` - Elimina el primer (-1) o último (1) elemento
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $pop: { hobbies: 1 } } // Elimina el último
)
````

### `$pull` - Elimina elementos que coincidan con una condición
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $pull: { hobbies: "fútbol" } }
)

// Con condición compleja
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $pull: { calificaciones: { $lt: 5 } } }
)
```

### `$pullAll` - Elimina múltiples valores específicos
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $pullAll: { hobbies: ["fútbol", "tenis"] } }
)
```

### `$addToSet` - Añade elementos únicos (evita duplicados)
```javascript
db.usuarios.updateOne(
  { _id: ObjectId("...") },
  { $addToSet: { hobbies: "natación" } }
)
```

### `$` (Operador Posicional Simple)
El operador `$` identifica y actualiza `el primer elemento` del array que coincide con la condición de la consulta.

**Sintaxis:**
```javascript
db.coleccion.updateOne(
  { "array.campo": valor }, // Condición que identifica el elemento
  { $set: { "array.$.campo": nuevoValor } } // $ representa la posición encontrada
)
```

**Ejemplo:**
```javascript
// Documento de ejemplo
{
  _id: 1,
  estudiantes: [
    { nombre: "Ana", nota: 8 },
    { nombre: "Luis", nota: 6 },
    { nombre: "María", nota: 9 }
  ]
}

// Actualizar la nota de Luis
db.clase.updateOne(
  { "estudiantes.nombre": "Luis" }, // Encuentra el elemento donde nombre = "Luis"
  { $set: { "estudiantes.$.nota": 7 } } // $ representa la posición de Luis
)

// Resultado:
{
  _id: 1,
  estudiantes: [
    { nombre: "Ana", nota: 8 },
    { nombre: "Luis", nota: 7 }, // ✅ Actualizado
    { nombre: "María", nota: 9 }
  ]
}
```

Limitaciones del operador `$`:

- Solo actualiza **el primer elemento** que coincide
- Requiere que la condición de consulta incluya el campo del array
- No puede usarse con arrays anidados profundamente

---

### `$[]` (Operador Posicional All)
El operador `$[]` actualiza todos los elementos del array, sin importar su contenido.

**Sintaxis:**
```javascript
db.coleccion.updateOne(
  { _id: valor }, // Condición del documento
  { $set: { "array.$[].campo": nuevoValor } } // $[] afecta todos los elementos
)
```

**Ejemplo:**
```javascript
// Documento de ejemplo
{
  _id: 1,
  estudiantes: [
    { nombre: "Ana", nota: 8, aprobado: false },
    { nombre: "Luis", nota: 6, aprobado: false },
    { nombre: "María", nota: 9, aprobado: false }
  ]
}

// Marcar todos como aprobados
db.clase.updateOne(
  { _id: 1 },
  { $set: { "estudiantes.$[].aprobado": true } }
)

// Resultado:
{
  _id: 1,
  estudiantes: [
    { nombre: "Ana", nota: 8, aprobado: true },    // ✅ Actualizado
    { nombre: "Luis", nota: 6, aprobado: true },   // ✅ Actualizado
    { nombre: "María", nota: 9, aprobado: true }   // ✅ Actualizado
  ]
}
```

**Casos de uso:**
```javascript
// Incrementar todas las notas en 1 punto
db.clase.updateOne(
  { _id: 1 },
  { $inc: { "estudiantes.$[].nota": 1 } }
)

// Añadir un campo a todos los elementos
db.clase.updateOne(
  { _id: 1 },
  { $set: { "estudiantes.$[].fecha_evaluacion": new Date() } }
)
```

---

### `$[identifier]` (Operador Posicional Filtrado)
El operador `$[identifier]` actualiza **elementos específicos** que cumplen una condición definida en `arrayFilters`.

**Sintaxis:**
```javascript
db.coleccion.updateOne(
  { _id: valor }, // Condición del documento
  { $set: { "array.$[identificador].campo": nuevoValor } },
  { arrayFilters: [{ "identificador.condicion": valor }] } // Define qué elementos actualizar
)
```

**Ejemplo:**
```javascript
// Documento de ejemplo
{
  _id: 1,
  estudiantes: [
    { nombre: "Ana", nota: 8, aprobado: false },
    { nombre: "Luis", nota: 4, aprobado: false },
    { nombre: "María", nota: 9, aprobado: false },
    { nombre: "Pedro", nota: 3, aprobado: false }
  ]
}

// Marcar como aprobados solo a quienes tienen nota >= 6
db.clase.updateOne(
  { _id: 1 },
  { $set: { "estudiantes.$[elem].aprobado": true } },
  { arrayFilters: [{ "elem.nota": { $gte: 6 } }] }
)

// Resultado:
{
  _id: 1,
  estudiantes: [
    { nombre: "Ana", nota: 8, aprobado: true },    // ✅ Actualizado (nota >= 6)
    { nombre: "Luis", nota: 4, aprobado: false },  // ❌ No actualizado
    { nombre: "María", nota: 9, aprobado: true },  // ✅ Actualizado (nota >= 6)
    { nombre: "Pedro", nota: 3, aprobado: false }  // ❌ No actualizado
  ]
}
```

### Otros ejemplos con `$[identifier]`

Múltiples condiciones en arrayFilters:
```javascript
// Actualizar estudiantes con nota entre 6 y 8
db.clase.updateOne(
  { _id: 1 },
  { $set: { "estudiantes.$[elem].categoria": "regular" } },
  { arrayFilters: [{ 
    "elem.nota": { $gte: 6, $lte: 8 }
  }] }
)
```

>[!IMPORTANT]
> Cuando aplicas múltiples operadores en **el mismo campo**, se comportan como `AND`.


Múltiples `arrayFilters`:
```javascript
// Actualizar con diferentes condiciones
db.clase.updateOne(
  { _id: 1 },
  { 
    $set: { 
      "estudiantes.$[aprobados].estado": "aprobado",
      "estudiantes.$[reprobados].estado": "reprobado"
    }
  },
  { 
    arrayFilters: [
      { "aprobados.nota": { $gte: 6 } },
      { "reprobados.nota": { $lt: 6 } }
    ]
  }
)
```

>[!NOTE]
> cada objeto en `arrayFilters` es un filtro independiente que puede usarse con diferentes **identificadores**.

---

Con arrays anidados:
```javascript
// Documento con arrays anidados
{
  _id: 1,
  cursos: [
    {
      nombre: "Matemáticas",
      tareas: [
        { titulo: "Tarea 1", puntos: 8 },
        { titulo: "Tarea 2", puntos: 6 }
      ]
    }
  ]
}

// Actualizar tareas específicas
db.estudiantes.updateOne(
  { _id: 1 },
  { $set: { "cursos.$[].tareas.$[tarea].revisada": true } },
  { arrayFilters: [{ "tarea.puntos": { $gte: 7 } }] }
)
```

> [!IMPORTANT]
> Cuando un filtro en `arrayFilters` tiene múltiples propiedades, **todas deben usar el mismo identificador** porque se refieren al mismo elemento del array.

---

# 10. Eliminar documentos

### Eliminar solo un documento:
```javascript
db.usuarios.deleteOne({nombre: "Pedro"})
```

### Eliminar múltiples documentos:
```javascript
db.usuarios.deleteMany({edad: {$lt: 25}})  // Elimina usuarios menores de 25 años
```

### Eliminar todos los documentos de una colección:
```javascript
db.usuarios.deleteMany({})
```

---

# 11. Usuarios y roles
MongoDB maneja usuarios a nivel de base de datos con diferentes roles y permisos.

Cada usuario tiene esta estructura:
```javascript
{
  _id: "database.username",
  user: "username",
  db: "database",
  credentials: { ... }, // hash de contraseña
  roles: [
    { role: "readWrite", db: "myapp" },
    { role: "userAdmin", db: "admin" }
  ]
}
```

## Niveles de usuarios

### 1. Usuarios de base de datos específica
```javascript
use myapp
db.createUser({
  user: "appuser",
  pwd: "password",
  roles: [{ role: "readWrite", db: "myapp" }]
})
```

### 2. Usuarios globales (base de datos `admin`)
```javascript
use admin
db.createUser({
  user: "globaladmin",
  pwd: "password",
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" }
  ]
})
```

En `admin` también es posible asignar roles para otras bases de datos:
```javascript
// Crear usuario en base de datos 'admin'
use admin
db.createUser({
  user: "cross_db_user",
  pwd: "password",
  roles: [
    { role: "readWrite", db: "ecommerce" },    // Permisos en ecommerce
    { role: "read", db: "analytics" },         // Permisos en analytics  
    { role: "dbAdmin", db: "logs" }            // Permisos admin en logs
  ]
})
```

## Sistema de roles

### Roles de base de datos:
- `read`: Solo lectura en una BD específica
- `readWrite`: Lectura y escritura en una BD específica
- `dbAdmin`: Administración de una BD específica. Este rol no otorga privilegios para la gestión de usuarios ni roles.
- `userAdmin`: Permite crear y modificar roles y usuarios en una BD específica, incluso a sí mismo.
- `dbOwner`: El propietario de la base de datos puede realizar cualquier acción administrativa en ella. Este rol combina los privilegios otorgados por los roles `readWrite`, `dbAdmin` y `userAdmin`.

---

### Roles administrativos:
- `readAnyDatabase`: Lectura en todas las BDs
- `readWriteAnyDatabase`: Lectura/escritura en todas las BDs
- `userAdminAnyDatabase`: Gestión de usuarios en todas las BDs
- `dbAdminAnyDatabase`: Administración de todas las BDs
- `root`: Acceso completo (equivalente al "root" de MySQL)

>[!CAUTION]
> El rol `userAdmin` conlleva riesgos de seguridad significativos:
>
> - **A nivel de base de datos**: Un usuario con `userAdmin` puede autoasignarse cualquier privilegio dentro de esa base de datos específica.
>
> - **A nivel de clúster**: Cuando se otorga `userAdmin` en la base de datos `admin`, el riesgo se amplifica considerablemente, ya que proporciona acceso de `superusuario` a todo el clúster. Esto permite al usuario conceder roles y privilegios globales, incluyendo `userAdminAnyDatabase`.
>
>En esencia, `userAdmin` en `admin` = **control total del sistema MongoDB**.

---

### Roles personalizados
```javascript
db.createRole({
  role: "customRole",
  privileges: [
    { resource: { db: "myapp", collection: "users" }, 
      actions: ["find", "insert", "update"] }
  ],
  roles: []
})
```

### Otorgar roles adicionales:
```javascript
db.grantRolesToUser("usuario_app", [
    {role: "dbAdmin", db: "mi_aplicacion"}
])
```

## Consultar usuarios:

### Ver usuarios de la BD actual:
```javascript
db.getUsers()
```

### Todos los usuarios autenticados en la sesión actual
```javascript
db.runCommand("connectionStatus")
```

### Información detallada de autenticación
```javascript
db.runCommand({connectionStatus: 1, showPrivileges: true})
```

### Actualizar contraseña:
```javascript
db.changeUserPassword("usuario_app", "nueva_contraseña")
```

---

## Eliminar usuario:
```javascript
db.dropUser("usuario_app")
```

# 12. Escribir scripts (JavaScript)

## Ejecutar desde `mongosh`
Es posible ejecutar un archivo `.js` desde dentro de MongoDB Shell utilizando el método `load()`.

### Rutas de archivo
El método `load()` acepta rutas **relativas** y **absolutas**. Si el directorio de trabajo actual de MongoDB Shell es `/data/db` y el archivo `insert-movies.js` se encuentra en el directorio `/data/db/scripts` , las siguientes llamadas dentro de MongoDB Shell son equivalentes:

```javascript
load( "scripts/insert-movies.js" )
load( "/data/db/scripts/insert-movies.js" )
```

### Ejemplo
El siguiente ejemplo crea y ejecuta un script que:

- Se conecta a una instancia local que se ejecuta en el puerto predeterminado.
- Se conecta a la base de datos `myDatabase`.
- Rellena la colección `movies` con documentos de muestra.

1. Crea un archivo `insert-movies.js` con el siguiente contenido:

```javascript
db = connect( 'mongodb://localhost/myDatabase' );

db.movies.insertMany( [
   {
      title: 'Titanic',
      year: 1997,
      genres: [ 'Drama', 'Romance' ]
   },
   {
      title: 'Spirited Away',
      year: 2001,
      genres: [ 'Animation', 'Adventure', 'Family' ]
   },
   {
      title: 'Casablanca',
      genres: [ 'Drama', 'Romance', 'War' ]
   }
] )
```

2. Para cargar y ejecutar el archivo `insert-movies.js` , usa `mongosh` para conectarse a su implementación y ejecuta el siguiente comando:

```javascript
load( "insert-movies.js" )
```

3. Para confirmar que los documentos se cargaron correctamente, realiza esta consulta:
```javascript
use myDatabase
db.movies.find()
```

## Ejecutar desde la línea de comandos
Puedes usar `mongosh` para ejecutar un script desde la línea de comandos sin necesidad de acceder a `mongosh`.

Para especificar el nombre del archivo, utilice los parámetros `--file` o `-f`. Es posible que también necesite especificar la información de conexión.

>[!TIP]
> Si pasa un nombre de archivo a `mongosh` sin usar los parámetros `--file` o `-f`, la conexión podría fallar si hay otros argumentos en la línea de comandos.

### Ejemplo
El siguiente ejemplo crea scripts y los ejecuta desde la línea de comandos.

- `loadMovies.js` usa `insertMany()` para actualizar una instancia local de MongodDB.
- `queryMovies.js` usa `db.collection.find()` para verificar la actualización.

1 Copia este script y guárdalo como `loadMovies.js`.

```javascript
db = connect( 'mongodb://localhost/films' );

db.movies.insertMany( [
   {
      title: 'Titanic',
      year: 1997,
      genres: [ 'Drama', 'Romance' ]
   },
   {
      title: 'Spirited Away',
      year: 2001,
      genres: [ 'Animation', 'Adventure', 'Family' ]
   },
   {
      title: 'Casablanca',
      genres: [ 'Drama', 'Romance', 'War' ]
   }
] )
```

2. Copie este script y guárdalo como `queryMovies.js`.

```javascript
db = connect( 'mongodb://localhost/films' );
printjson( db.movies.find( {} ) );
```

3. Ejecute los scripts desde la línea de comandos.

```javascript
mongosh --file loadMovies.js --file queryMovies.js
```

4. Verificar la salida
```javascript
Loading file: loadMovies.js
Loading file: queryMovies.js
[
   {
      _id: ObjectId("616f1b8092dbee425b661117"),
      title: 'Titanic',
      year: 1997,
      genres: [ 'Drama', 'Romance' ]
   },
   {
      _id: ObjectId("616f1b8092dbee425b661118"),
      title: 'Spirited Away',
      year: 2001,
      genres: [ 'Animation', 'Adventure', 'Family' ]
   },
   {
      _id: ObjectId("616f1b8092dbee425b661119"),
      title: 'Casablanca',
      genres: [ 'Drama', 'Romance', 'War' ]
   }
]
```

## Ejecutar desde la línea de comandos con autenticación
Para ejecutar un script en una instancia de `mongod` que requiere autenticación, especifique los detalles de **conexión** y **autenticación**, además del nombre del archivo.

Por ejemplo:
```bash
mongosh --host 172.17.0.3 --port 27500 --username filmFan --password superSecret --file loadMovies.js
```

También puedes especificar la forma abreviada de las opciones:
```javascript
mongosh --host 172.17.0.3 --port 27500 -u filmFan -p superSecret -f loadMovies.js
```

## Terminar un script en caso de error
Suele ser útil finalizar un script en ejecución si se lanza una excepción o en caso de resultados inesperados. Salir en un punto específico del script evita la ejecución de código innecesario y resultados potencialmente inesperados.

Para finalizar un script, puede llamar al método `exit(<code>)`, donde `<code>` es cualquier valor especificado por el usuario.

Como práctica recomendada, encierre el código en un bloque `try-catch`, llamando al método `exit` en el bloque `catch`. De igual modo, para comprobar los resultados de una consulta o cualquier comando, puede agregar una sentencia `if-else` y llamar al método `exit` si los resultados no son los esperados.

### Códigos de salida comunes
```javascript
// Convención de códigos de salida
// 0  = Éxito
// 1  = Error general
// 2  = Error de configuración
// 3  = Error de datos
// 10-19 = Errores de validación inicial
// 20-29 = Errores de procesamiento
// 99 = Error crítico/inesperado
```


## Abrir una nueva conexión

### Conectarse localmente a MongoDB:
Desde MongoDB Shell o desde un archivo JavaScript, puede crear instancias de conexiones de base de datos utilizando el método `Mongo()`. Todas estas maneras son válidas:

```javascript
new Mongo()
new Mongo(<host>)
new Mongo(<host:port>)
```

Si existe una instancia de MongoDB ejecutándose en localhost en el puerto predeterminado. El siguiente ejemplo:

- Crea una nueva conexión a la instancia 
- Establece la variable global `db` en `myDatabase` mediante el método `Mongo.getDB()`.

```javascript
conn = Mongo();
db = conn.getDB("myDatabase");

printjson(db.movies.find({}));
```

De esta manera puedes interactuar con `otras bases de datos` desde el mismo archivo JavaScript.

---

### Conectarse a MongoDB Atlas
Para conectarse a una implementación alojada en MongoDB Atlas, ejecute el comando `mongosh` con su cadena de conexión de Atlas. Por ejemplo:
```bash
mongosh "mongodb+srv://YOUR_CLUSTER_NAME.YOUR_HASH.mongodb.net/" --apiVersion YOUR_API_VERSION --username YOUR_USERNAME
```

Una vez establecida la conexión con su implementación, puede instanciar conexiones de base de datos directamente desde MongoDB Shell o un archivo JavaScript. Este ejemplo:

- Instancia una conexión a la implementación actual mediante el método `db.getMongo()`.
- Establece la variable global `db` en `myDatabase` mediante el `método Mongo.getDB()`.

```javascript
conn = db.getMongo()
db = conn.getDB("myDatabase");

printjson(db.movies.find({}));
```

En `mongosh`:
```javascript
load("/path/to/script.js")
```

### Conectarse a una instancia de MongoDB que aplica el control de acceso
Debes incluir las credenciales en la **cadena de conexión**.

El siguiente comando se conecta a una instancia de MongoDB que:

- Se ejecuta en el host local en el puerto predeterminado
- Está protegida mediante `SCRAM`.

```javascript
conn = Mongo("mongodb://<username>:<password>@localhost:27017/<authDB>");
```

# 13. Índices
Los índices en MongoDB son estructuras de datos que mejoran significativamente la velocidad de las operaciones de consulta al crear atajos organizados para encontrar documentos específicos.

## ¿Qué son los índices?
Los índices en MongoDB funcionan de manera similar a los índices de un libro. En lugar de examinar cada página (documento) para encontrar información específica, el índice proporciona una referencia directa a la ubicación exacta de los datos que buscas.

## Tipos de índices

### 1. Índice simple 

Se crea sobre un campo específico del documento:
```javascript
// Estos dos índices son funcionalmente equivalentes para consultas simples
db.usuarios.createIndex({ "edad": 1 })   // ascendente
db.usuarios.createIndex({ "edad": -1 })  // descendente

// Ambos optimizan estas consultas por igual:
db.usuarios.find({ edad: 25 })
db.usuarios.find({ edad: { $gt: 18 } })
db.usuarios.find().sort({ edad: 1 })     // orden ascendente
db.usuarios.find().sort({ edad: -1 })    // orden descendente
```

### Indexación en documentos embebidos

#### 1. Indexación de campos específicos (Dot Notation)
```javascript
// Documento de ejemplo
{
  "_id": 1,
  "user": {
    "name": "Juan",
    "age": 25,
    "address": {
      "city": "Madrid",
      "country": "España"
    }
  }
}

// Indexar campo específico del documento embebido
db.users.createIndex({ "user.name": 1 })
db.users.createIndex({ "user.address.city": 1 })

//Consultas optimizadas
db.users.find({ "user.name": "Juan" })
db.users.find({ "user.address.city": "Madrid" })
```

#### Indexación del documento completo
```javascript
// Documento de ejemplo
{
  "_id": 1,
  "user": {
    "name": "Juan",
    "age": 25,
    "address": {
      "city": "Madrid",
      "country": "España"
    }
  }
}

// Indexar todo el documento embebido
db.users.createIndex({ "user": 1 })
```

`Importante`: Este índice solo es útil para consultas que coincidan exactamente con la estructura y orden de los campos:
```javascript
// ✅ Esta consulta usará el índice
db.users.find({ "user": { "name": "Juan", "age": 25, "address": { "city": "Madrid", "country": "España" } } })

// ❌ Esta NO usará el índice (orden diferente)
db.users.find({ "user": { "age": 25, "name": "Juan", "address": { "city": "Madrid", "country": "España" } } })
```

---

### 2. Índice compuesto 

Combina múltiples campos en un solo índice:
```javascript
// Índice compuesto con direcciones mixtas
db.ventas.createIndex({ "fecha": -1, "monto": 1, "vendedor": -1 })
```

MongoDB puede usar un índice compuesto para ordenamiento y optimizar las consultas si:
```javascript
// El patrón de sort coincide exactamente con el índice
db.ventas.find().sort({ "fecha": -1, "monto": 1, "vendedor": -1 })

// El Patrón es completamente inverso
db.ventas.find().sort({ "fecha": 1, "monto": -1, "vendedor": 1 })

// Prefijos del patrón
db.ventas.find().sort({ "fecha": -1 })
db.ventas.find().sort({ "fecha": -1, "monto": 1 })
```

Por el contrario, estas son consultas **NO** optimizados (requieren ordenamiento en memoria)
```javascript
// Patrones mixtos que no coinciden
db.ventas.find().sort({ "fecha": -1, "monto": -1, "vendedor": -1 })
db.ventas.find().sort({ "fecha": 1, "monto": 1, "vendedor": -1 })
```

---

### 3. Índice multivalor

Un índice multivalor se crea automáticamente cuando indexas un campo que contiene un array. MongoDB genera entradas de índice separadas para cada elemento del array

MongoDB crea múltiples entradas (referencias) de índice para cada documento:
1. Para "Laptop": 3 entradas (electronica, computadora, portatil)
2. Para "Mesa": 2 entradas (mueble, madera)
3. Para "Telefono": 2 entradas (electronica, comunicacion)

```javascript
// Documentos con arrays
db.productos.insertMany([
  { nombre: "Laptop", etiquetas: ["electronica", "computadora", "portatil"] },
  { nombre: "Mesa", etiquetas: ["mueble", "madera"] },
  { nombre: "Telefono", etiquetas: ["electronica", "comunicacion"] }
])

// Crear índice multivalor
db.productos.createIndex({ "etiquetas": 1 })
```

#### Consultas optimizadas:
```javascript
// Todas estas usan el índice eficientemente
db.productos.find({ "etiquetas": "electronica" })
db.productos.find({ "etiquetas": { $in: ["mueble", "electronica"] } })
db.productos.find({ "etiquetas": { $all: ["electronica", "computadora"] } })
```

#### Arrays anidados:
```javascript
// Documento con array de objetos
db.pedidos.insertOne({
  numero: 123,
  productos: [
    { id: 1, categoria: "A" },
    { id: 2, categoria: "B" }
  ]
})

// Índice en campo anidado de array
db.pedidos.createIndex({ "productos.categoria": 1 })

// Consulta optimizada
db.pedidos.find({ "productos.categoria": "A" })
```

#### Estructura del índice: Array + 2 campos simples

#### Ejemplo de datos:
```javascript
// Documentos de ejemplo
{
  "_id": 1,
  "skills": ["JavaScript", "Python", "React"],
  "experience": 5,
  "salary": 80000
}

{
  "_id": 2, 
  "skills": ["Python", "MongoDB", "Node.js"],
  "experience": 3,
  "salary": 60000
}

{
  "_id": 3,
  "skills": ["React", "Vue", "Angular"],
  "experience": 7,
  "salary": 95000
}
```

Creación del índice:
```javascript
db.developers.createIndex({ "skills": 1, "experience": 1, "salary": 1 })
```

MongoDB genera una entrada de índice por cada elemento del array combinado con ambos campos simples:
```javascript
// Del documento 1:
["JavaScript", 5, 80000] → doc _id: 1
["Python", 5, 80000] → doc _id: 1
["React", 5, 80000] → doc _id: 1

// Del documento 2:
["MongoDB", 3, 60000] → doc _id: 2
["Node.js", 3, 60000] → doc _id: 2
["Python", 3, 60000] → doc _id: 2

// Del documento 3:
["Angular", 7, 95000] → doc _id: 3
["React", 7, 95000] → doc _id: 3
["Vue", 7, 95000] → doc _id: 3
```

#### Ordenamiento del índice:

Las entradas se ordenan por: `skills` → `experience` → `salary`
```javascript
["Angular", 7, 95000] → doc _id: 3
["JavaScript", 5, 80000] → doc _id: 1
["MongoDB", 3, 60000] → doc _id: 2
["Node.js", 3, 60000] → doc _id: 2
["Python", 3, 60000] → doc _id: 2
["Python", 5, 80000] → doc _id: 1
["React", 5, 80000] → doc _id: 1
["React", 7, 95000] → doc _id: 3
["Vue", 7, 95000] → doc _id: 3
```

#### Limitaciones importantes

- **Límite de claves por documento**: Un documento no puede generar más de un cierto número de claves de índice (generalmente alrededor de `1024`). Si un array es demasiado grande, la indexación fallará.
- **Índices compuestos**: Solo un campo array puede ser parte de un índice compuesto:
```javascript
// ❌ PROHIBIDO - Solo UN campo array por índice compuesto
// Error si ambos campos contienen arrays
db.productos.createIndex({ "etiquetas": 1, "categorias": 1 })

// ✅ PERMITIDO - Un array y campos escalares
db.productos.createIndex({ "etiquetas": 1, "precio": 1, "marca": 1 })
```
- **Arrays muy grandes**: pueden impactar negativamente el rendimiento de escritura, ya que cada inserción o actualización debe mantener múltiples entradas de índice.

---

### 4. Índice de texto

Los índices de texto permiten realizar búsquedas de texto completo dentro de documentos.
```javascript
db.articulos.createIndex({ "titulo": "text", "contenido": "text" })
```

### Arquitectura interna del índice de `Texto`

### 1. Proceso de tokenización:
Cuando MongoDB crea un índice de texto, realiza los siguientes pasos:

```javascript
// Documento original
{
  titulo: "Introducción a MongoDB y NoSQL",
  contenido: "MongoDB es una base de datos NoSQL que utiliza documentos JSON"
}
```

#### Paso 1: Normalización

- Convierte todo a minúsculas
- Elimina signos de puntuación y caracteres especiales
- Separa palabras por espacios

#### Paso 2: Eliminación de Stop Words
```javascript
// Palabras originales
["introducción", "a", "mongodb", "y", "nosql", "es", "una", "base", "de", "datos"]

// Después de eliminar stop words (español)
["introducción", "mongodb", "nosql", "base", "datos"]
```

#### Paso 3: Stemming (Reducción a raíz)
```javascript
// Reduce palabras a su raíz según el idioma
"introducción" → "introduc"
"bases" → "base"
"corriendo" → "corr"
```

### 2. Estructura del índice invertido
MongoDB crea un índice invertido que mapea cada término a los documentos:

```javascript
// Estructura interna simplificada
{
  "mongodb": [
    { docId: ObjectId("..."), weight: 2.5, fields: ["titulo", "contenido"] },
    { docId: ObjectId("..."), weight: 1.8, fields: ["contenido"] }
  ],
  "nosql": [
    { docId: ObjectId("..."), weight: 3.1, fields: ["titulo"] }
  ],
  "base": [
    { docId: ObjectId("..."), weight: 1.2, fields: ["contenido"] },
    { docId: ObjectId("..."), weight: 2.0, fields: ["titulo"] }
  ]
}
```

### 3. Configuración detallada
```javascript
// Índice básico
db.articulos.createIndex({ 
  "titulo": "text", 
  "contenido": "text" 
})

// Índice con configuración avanzada
db.articulos.createIndex(
  { 
    "titulo": "text", 
    "contenido": "text",
    "tags": "text"
  },
  {
    // Idioma por defecto
    default_language: "spanish",
    
    // Configurar idiomas específicos por campo
    language_override: "idioma",
    
    // Pesos para diferentes campos
    weights: {
      titulo: 10,      // Título tiene más importancia
      contenido: 5,    // Contenido importancia media
      tags: 2          // Tags menos importancia
    },
    
    // Nombre del índice
    name: "busqueda_articulos",
    
    // Configuración de texto
    textIndexVersion: 3
  }
)
```

### ¿Para qué sirven los pesos?
Los pesos permiten dar **diferente importancia a distintos campos** cuando MongoDB calcula la relevancia (score) de los resultados de búsqueda.

#### 1. Fórmula de Cálculo del Score
```
// Fórmula simplificada del Text Score
score = Σ (término_freq_en_campo × peso_campo × idf_término)

// Donde:
// - término_freq_en_campo: cuántas veces aparece el término en ese campo específico
// - peso_campo: el peso asignado al campo (weight)
// - idf_término: Inverse Document Frequency (qué tan raro/común es el término)
```

#### 2. Ejemplo de configuración
```javascript
// Configuración del índice con pesos
db.articulos.createIndex(
  {
    titulo: "text",
    resumen: "text", 
    contenido: "text",
    etiquetas: "text"
  },
  {
    weights: {
      titulo: 20,      // Peso más alto
      resumen: 10,     
      etiquetas: 5,    
      contenido: 1     // Peso por defecto
    }
  }
)
```

Documentos de ejemplo:
```javascript
// Documento A
{
  titulo: "Tutorial de MongoDB",           // "mongodb" aparece aquí
  resumen: "Aprende bases de datos NoSQL",
  contenido: "En este tutorial veremos...",
  etiquetas: ["tutorial", "base-datos"]
}

// Documento B  
{
  titulo: "Introducción a SQL",
  resumen: "Tutorial básico de SQL",
  contenido: "MongoDB es mencionado aquí como alternativa...", // "mongodb" aparece aquí
  etiquetas: ["sql", "tutorial"]
}
```

Cálculo del score para búsqueda "mongodb":
```javascript
// Documento A: "mongodb" en título (peso 20)
score_A = 1 × 20 × idf_mongodb = 20 × idf_mongodb

// Documento B: "mongodb" en contenido (peso 1)  
score_B = 1 × 1 × idf_mongodb = 1 × idf_mongodb

// Resultado: Documento A tendrá score 20 veces mayor que B
```

Los documentos con **mayor score** aparecen **primero** en los resultados.


#### Ejemplos de consultas:
```javascript
// Búsqueda AND implícita
// Busca documentos que contengan TANTO "mongodb" COMO "tutorial"
db.articulos.find({ $text: { $search: "mongodb tutorial" } })

// Búsqueda OR explícita
// Busca documentos que contengan "mongodb" O "mysql"
db.articulos.find({ $text: { $search: "mongodb | mysql" } })

// Búsqueda de frase exacta
// Busca la frase exacta "base de datos"
db.articulos.find({ $text: { $search: "\"base de datos\"" } })

// Negación
// Busca "mongodb" pero EXCLUYE documentos con "mysql"
db.articulos.find({ $text: { $search: "mongodb -mysql" } })

// Combinación compleja
// Busca "machine learning" exacto, con "python", sin "java", con "tutorial"
db.articulos.find({ 
  $text: { 
    $search: "\"machine learning\" python -java tutorial" 
  } 
})
```

>[!IMPORTANT]
> Solo puede haber un índice de texto por colección

---

### 5. Índice geoespacial 

Para consultas de ubicación:
```javascript
db.lugares.createIndex({ "ubicacion": "2dsphere" })
```

---

### 6. Índice hash

Un índice `hashed` es un tipo especial de índice donde MongoDB aplica una `función hash` a los valores del campo antes de almacenarlos en el índice, es especialmente útiles para sharding.

#### Creación de índices hash
```javascript
// Sintaxis básica
db.datos.createIndex({ "campo": "hashed" })

// Ejemplo práctico
db.usuarios.createIndex({ "userId": "hashed" })
```

#### ¿Qué hace la función hash?
La función hash toma cualquier valor y lo convierte en un **número entero de 64 bits** de forma determinística:

```javascript
// Ejemplos de transformación (valores aproximados):
1     → -2345678901234567890
"abc" → 1234567890123456789
100   → -9876543210987654321
1000  → 5555555555555555555
```

MongoDB aplica una función hash al valor del campo indexado, creando:

1. **Distribución uniforme**: Los valores se distribuyen equitativamente
2. **Óptimo para igualdad exacta**: Muy eficiente para consultas `db.col.find({campo: valor})`
3. **No ordenado**: No mantiene el orden original de los datos
4. **Sharding automático**: Distribución equilibrada en clusters sharded


### Limitaciones:
```javascript
// ✅ Eficiente - consulta de igualdad exacta
db.usuarios.find({ "userId": "12345" })

// ❌ Ineficiente - no soporta consultas de rango
db.usuarios.find({ "userId": { $gt: "12345" } })

// ❌ No útil para ordenamiento
db.usuarios.find().sort({ "userId": 1 })
```

#### Ejemplos

#### Para distribución uniforme en sharding:
```javascript
// Crear shard key con hash para distribución uniforme
sh.shardCollection("miapp.usuarios", { "userId": "hashed" })

// El índice hash se crea automáticamente
db.usuarios.createIndex({ "userId": "hashed" })
```

#### Para consultas de búsqueda rápida:
```javascript
// Índice hash para IDs de sesión
db.sesiones.createIndex({ "sessionId": "hashed" })

// Búsqueda muy rápida por sessionId específico
db.sesiones.find({ "sessionId": "abc123def456" })
```

#### Combinando con otros campos:
```javascript
// Índice compuesto: hash + campo normal
db.logs.createIndex({ "userId": "hashed", "timestamp": 1 })

// Eficiente para consultas que incluyen userId exacto
db.logs.find({ 
  "userId": "user123", 
  "timestamp": { $gte: new Date("2024-01-01") }
})
```

---

### 7. Índice TTL

Son índices especiales que MongoDB utiliza para eliminar automáticamente documentos después de un período específico de tiempo. Son especialmente útiles para datos temporales como logs, sesiones de usuario, datos de caché, o cualquier información que tenga una validez limitada en el tiempo.

MongoDB ejecuta una tarea en segundo plano cada 60 segundos que:

1. Examina todos los índices TTL en la base de datos
2. Identifica documentos que han superado su tiempo de vida
3. Elimina automáticamente esos documentos

Crear un índice:
```javascript
db.coleccion.createIndex(
  { "fechaCampo": 1 }, 
  { expireAfterSeconds: 3600 }  // Expira después de 1 hora
)
```

#### Expiración en una fecha específica:
```javascript
// El documento expira exactamente en la fecha especificada en el campo
db.logs.createIndex({ "fechaExpiracion": 1 }, { expireAfterSeconds: 0 })

// Documento de ejemplo
{
  "_id": ObjectId("..."),
  "mensaje": "Log entry",
  "fechaExpiracion": new Date("2024-12-31T23:59:59Z")
}
```

#### Expiración después de un tiempo relativo:
```javascript
// El documento expira 24 horas después de la fecha en el campo
db.sesiones.createIndex({ "fechaCreacion": 1 }, { expireAfterSeconds: 86400 })

// Documento de ejemplo
{
  "_id": ObjectId("..."),
  "usuarioId": "user123",
  "fechaCreacion": new Date()  // Se creó ahora, expira en 24 horas
}
```

---

### 8. Índices parciales

Los índices parciales solo incluyen documentos que cumplen con una condición específica, lo que los hace más eficientes en espacio y rendimiento. Esto significa:

- **Menor uso de espacio**: El índice solo almacena entradas para documentos que cumplen la condición
- **Mejor rendimiento**: Menos entradas para examinar durante las consultas
- **Mantenimiento más rápido**: Menos documentos que actualizar cuando cambian los datos

#### Ejemplos

#### Indexar solo documentos activos:
```javascript
// Solo indexa usuarios que están activos
db.usuarios.createIndex(
  { "email": 1 },
  { 
    partialFilterExpression: { estado: "activo" }
  }
)

// Esta consulta USARÁ el índice
db.usuarios.find({ email: "juan@email.com", "estado": "activo" })

// Esta consulta NO USARÁ el índice (falta la condición de estado)
db.usuarios.find({ email: "juan@email.com" })
```

#### Indexar solo campos no nulos:
```javascript
// Solo indexa documentos donde el campo telefono existe y no es null
db.contactos.createIndex(
  { "telefono": 1 },
  { 
    partialFilterExpression: { 
      "telefono": { $exists: true, $ne: null }
    }
  }
)
```

#### Índice con múltiples condiciones:
```javascript
// Solo indexa productos caros y en stock
db.productos.createIndex(
  { "categoria": 1, "precio": 1 },
  { 
    partialFilterExpression: { 
      "precio": { $gt: 100 },
      "stock": { $gt: 0 }
    }
  }
)
```

## Estrategias de indexación

### Regla ESR (Equality, Sort, Range)
Al crear índices compuestos, ordena los campos según:

1. `Equality`: Campos con consultas de igualdad exacta
2. `Sort`: Campos utilizados para ordenamiento
3. `Range`: Campos con consultas de rango

```javascript
// Para consulta: find({status: "active"}).sort({fecha: -1}).limit(10)
// donde también filtras por rango de edad
db.coleccion.createIndex({ 
  "status": 1,      // Equality
  "fecha": -1,      // Sort  
  "edad": 1         // Range
})
```

## Operaciones principales

### Crear índices
```javascript
// Índice simple
db.coleccion.createIndex({ campo: 1 })

// Índice con opciones
db.coleccion.createIndex(
  { campo: 1 }, 
  { 
    unique: true,           // Valores únicos
    sparse: true,           // Ignora documentos sin el campo
    name: "mi_indice"       // Nombre personalizado
  }
)
```

#### `unique: true`

Garantiza valores únicos en el campo indexado:
```javascript
db.usuarios.createIndex({ "email": 1 }, { unique: true })
// Impide documentos con emails duplicados
// null se considera un valor, solo puede haber un documento con campo null
```

#### `sparse: true`

Indexa solo documentos que tienen el campo (ignora nulls y campos inexistentes):
```javascript
db.usuarios.createIndex({ "telefono": 1 }, { sparse: true })
// No indexa documentos sin campo 'telefono' o con telefono: null
// Útil para campos opcionales con constraint unique```
```

#### `name: "nombre_personalizado"`

Asigna un nombre específico al índice:
```javascript
db.productos.createIndex(
  { "precio": 1, "categoria": 1 }, 
  { name: "idx_precio_categoria" }
)
// Por defecto MongoDB genera nombres como "precio_1_categoria_1"
```

#### `partialFilterExpression`

Crea índices parciales (solo documentos que cumplan condición):
```javascript
db.usuarios.createIndex(
  { "edad": 1 },
  { 
    partialFilterExpression: { 
      "edad": { $gte: 18 },
      "activo": true 
    }
  }
)
// Solo indexa usuarios mayores de edad y activos
// Reduce significativamente el tamaño del índice
```

#### `expireAfterSeconds`

Para índices TTL (Time To Live):
```javascript
db.sesiones.createIndex(
  { "fechaCreacion": 1 },
  { expireAfterSeconds: 3600 }  // 1 hora
)
// MongoDB elimina automáticamente documentos después del tiempo especificado
```

#### `collation`

Define reglas de comparación de texto:
```javascript
db.productos.createIndex(
  { "nombre": 1 },
  { 
    collation: { 
      locale: "es", 
      strength: 2  // Ignora mayúsculas/minúsculas y acentos
    }
  }
)
```

### Listar índices
```javascript
db.coleccion.getIndexes()
```

### Eliminar índices
```javascript
db.coleccion.dropIndex("nombre_indice")
db.coleccion.dropIndex({ campo: 1 })
db.coleccion.dropIndexes()  // Elimina todos excepto _id
```

## Mejores prácticas

1. Crea índices basados en patrones de consulta reales
2. Monitorea el rendimiento usando `explain()`:
```javascript
db.coleccion.find({campo: "valor"}).explain("executionStats")
```

3. Usa índices compuestos eficientemente siguiendo la regla ESR
4. Considera índices parciales para grandes colecciones
5. Elimina índices no utilizados regularmente

## ¿Qué son realmente los índices internamente?

### Árbol B (B-Tree)
Los índices de MongoDB no son listas lineales simples, sino `árboles B` balanceados, que son estructuras de datos mucho más sofisticadas:
```
Ejemplo visual de un índice sobre campo "edad":
                    [25]
                   /    \
            [18, 22]      [30, 35]
           /   |   \     /   |   \
         [16] [19] [24] [27] [32] [38]
         refs refs refs refs refs refs
```

### Características
- `Búsqueda`: O(log n) tiempo logarítmico
- `Inserción`: O(log n)
- `Uso de memoria`: optimizado para E/O de disco

## Analogía de "listas"
Puede ser útil pensar en los índices como "listas" ordenadas de referencias para entender su función:

### Indice simple
```javascript
// Documentos en colección
{ _id: ObjectId("...a"), nombre: "Ana", edad: 25 }
{ _id: ObjectId("...b"), nombre: "Carlos", edad: 18 }
{ _id: ObjectId("...c"), nombre: "Beatriz", edad: 30 }

// El índice { edad: 1 } conceptualmente es como:
[
  { valor: 18, referencia: ObjectId("...b") },
  { valor: 25, referencia: ObjectId("...a") },
  { valor: 30, referencia: ObjectId("...c") }
]
```

### Índice compuesto
```javascript
// Es como una lista ordenada por múltiples criterios
// Índice { edad: 1, nombre: 1 }
[
  { valores: [18, "Carlos"], referencia: ObjectId("...b") },
  { valores: [25, "Ana"], referencia: ObjectId("...a") },
  { valores: [30, "Beatriz"], referencia: ObjectId("...c") }
]
```

### índice multivalor
```javascript
// Documento
{ _id: 1, etiquetas: ["A", "B", "C"] }

// Índice conceptual
[
  { valor: "A", referencia: ObjectId("1") },
  { valor: "B", referencia: ObjectId("1") },  // mismo documento
  { valor: "C", referencia: ObjectId("1") }   // mismo documento
]
```

Todo esto en realidad está implementado como un `árbol B` de decisiones eficiente en lugar de una lista secuencial.

---

# 14. Colecciones con límite
Las `capped collections` son un tipo especial de colección en MongoDB que tienen un tamaño fijo predefinido. Funcionan como un buffer circular: cuando alcanzan su límite de tamaño, los documentos más antiguos se eliminan automáticamente para hacer espacio a los nuevos.

## Características principales

- **Tamaño fijo**: Se define un tamaño máximo en bytes al momento de creación y no puede cambiarse después.
- **Orden de inserción preservado**: Los documentos mantienen siempre el orden natural de inserción, similar a un log.
- **Alta performance**: Las inserciones son extremadamente rápidas porque no requieren búsqueda de espacio libre.
- **Eliminación automática**: Los documentos más antiguos se eliminan automáticamente cuando se alcanza el límite.
- **No modificables**: No puedes actualizar documentos si la actualización aumenta su tamaño. Las eliminaciones manuales tampoco están permitidas.

## Creación de Capped Collections
```javascript
db.createCollection("miColeccion", {
   capped: true,
   size: 100000,  // Tamaño en bytes
   max: 5000      // Máximo número de documentos (opcional)
})
```

## Ejemplos 

### Colección de logs limitada por tamaño:
```javascript
db.createCollection("logs", {
   capped: true,
   size: 10485760  // 10MB
})
```

### Colección limitada por número de documentos:
```javascript
db.createCollection("eventos", {
   capped: true,
   size: 5242880,  // 5MB mínimo requerido
   max: 1000       // Máximo 1000 documentos
})
```

## Casos de uso comunes

- **Sistemas de logging**: Perfectas para almacenar logs de aplicación con rotación automática.
- **Cache de datos**: Para mantener datos temporales con expiración automática.
- **Métricas y eventos**: Almacenamiento de métricas de rendimiento o eventos del sistema.
- **Colas de mensajes**: Implementación de colas FIFO simples.
- **Datos de sesión**: Almacenamiento temporal de datos de sesiones web.

## Operaciones especiales

### Consultas Tailable Cursors
Las capped collections soportan cursores "tailable" que permanecen abiertos y reciben nuevos documentos automáticamente:
```javascript
db.logs.find().addOption(DBQuery.Option.tailable)
```

### Verificar si una colección es capped:
```javascript
db.miColeccion.isCapped()
```

### Obtener estadísticas:
```javascript
db.miColeccion.stats()
```

## Limitaciones importantes

- `Sin sharding`: Las capped collections no pueden ser distribuidas en un cluster sharded.
- `Sin índices por defecto`: Solo tienen el índice _id por defecto, y agregar índices adicionales puede afectar el rendimiento.
- `Actualizaciones restringidas`: Solo se permiten actualizaciones que no cambien el tamaño del documento.
- `Sin eliminaciones manuales`: No puedes usar deleteOne() o deleteMany().
- `Tamaño no modificable`: Una vez creada, no puedes cambiar el tamaño de la colección.

# 14. Sharding
El `sharding` en MongoDB es una técnica de escalamiento horizontal que permite distribuir datos a través de múltiples servidores (llamados shards) para manejar grandes volúmenes de datos y alta carga de trabajo que exceden la capacidad de un solo servidor.

Se divide una colección grande en fragmentos más pequeños llamados "chunks", donde cada chunk contiene un subconjunto de documentos basado en una clave de sharding (shard key). Estos chunks se distribuyen automáticamente entre diferentes shards en el clúster.

## [Componentes de la arquitectura de Sharding](https://www.mongodb.com/docs/manual/sharding/#sharded-cluster)

### 1. Shards (Fragmentos)
   - [Cada shard es un replica set independiente](https://www.mongodb.com/docs/manual/sharding/#high-availability)
   - [Contiene un subconjunto de los datos totales](https://www.mongodb.com/docs/manual/sharding/#storage-capacity)
   - Los datos se distribuyen basándose en la shard key (clave de fragmentación)
   - Pueden agregarse más shards para escalar horizontalmente

### 2. Router (mongos)

   - [Son los puntos de entrada de las aplicaciones](https://www.mongodb.com/docs/manual/core/sharded-cluster-query-router/#routing-with-mongos)
   - Actúan como proxy entre la aplicación cliente y los shards
   - [Procesan las consultas y determinan a qué shard(s) dirigir cada operación](https://www.mongodb.com/docs/manual/sharding/#advantages-of-sharding)
   - No almacenan datos, solo enrutan las peticiones
   - Pueden tener múltiples instancias para alta disponibilidad

### 3. Config Servers (Servidores de Configuración)

   - Almacenan los metadatos del cluster sharded
   - Contienen información sobre:
        - Qué datos están en cada shard
        - Rangos de claves (shard keys) asignados a cada shard
        - Configuración del cluster
   - [Funciona como replica set para garantizar alta disponibilidad](https://www.mongodb.com/docs/manual/sharding/#high-availability)
   - Son críticos para el funcionamiento del cluster


El siguiente gráfico describe la interacción de los componentes dentro de un clúster fragmentado:

<img width="441" height="314" alt="image" src="https://github.com/user-attachments/assets/2b74d134-6212-48fb-b4b4-1b9045c213bf" />

### Flujo de funcionamiento:

1. `La aplicación` se conecta a los routers (mongos)
2. `El router` consulta los config servers para determinar dónde están los datos
3. `El router` dirige la consulta al shard apropiado
4. `El shard` procesa la operación y devuelve el resultado
5. `El router` consolida las respuestas (si es necesario) y las envía a la aplicación

## Shard Key (clave de fragmentación)
MongoDB utiliza la `shard key` para distribuir los documentos de la colección entre shards (fragmentos). La shard key consiste en uno o varios campos de los documentos.

Para fragmentar una colección completa, esta **debe tener un `índice` que comience con la shard key**. Al fragmentar una colección vacía, MongoDB crea el índice de apoyo si la colección no tiene un índice adecuado para la shard key especificada.

La elección de la clave de fragmentación afecta el rendimiento, la eficiencia y la escalabilidad de un clúster fragmentado. Un clúster con el mejor hardware e infraestructura posibles puede verse afectado por la elección de la clave de fragmentación.

### Características importantes de una buena shard key:

- **Alta cardinalidad**: Debe tener muchos valores únicos posibles
- **Distribución uniforme**: Los valores deben distribuirse de manera equilibrada
- **Patrones de consulta**: Debe alinearse con los patrones de consulta más comunes
- **Inmutable**: No puede cambiar después de que el documento es insertado

Para consultas que incluyen la clave de fragmento o el prefijo de una clave de fragmento compuesta, `Mongos` puede dirigir la consulta a un shard o conjunto de shards específicos. Estas **operaciones dirigidas** suelen ser más eficientes que la difusión a todos los shards del clúster.

## Chunks
MongoDB particiona los documentos de una colección en `chunks`. Un chunk es un **rango contiguo de datos** de una colección particionada (sharded collection) que se define por los valores de la `shard key`. Cada chunk contiene documentos cuyos valores de shard key caen dentro de un rango específico, por ejemplo:

- Chunk 1: shard key valores de 1 a 100
- Chunk 2: shard key valores de 101 a 200
- Chunk 3: shard key valores de 201 a 300

Una vez que los `chunks` están creados, el sistema de MongoDB (específicamente el `balancer`) se encarga de distribuir estos chunks de manera equilibrada entre los diferentes shards del clúster. Así, cada shard termina almacenando uno o más chunks.

### Características principales
- `Tamaño por defecto`: Cada chunk tiene un tamaño máximo de 64 MB por defecto (configurable entre 1 MB y 1024 MB).
- `Distribución`: Los chunks se distribuyen automáticamente entre los diferentes shards del cluster para balancear la carga.
- `Indivisibilidad`: Un chunk completo siempre reside en un solo shard, nunca se divide entre múltiples shards.

## Proceso de Balanceador
En un intento por lograr una distribución uniforme de datos entre todos los `shards` del clúster, un `balanceador` se ejecuta en segundo plano para migrar rangos entre los fragmentos.

MongoDB incluye un balanceador automático que:

- Monitorea la distribución de chunks entre shards
- Mueve chunks automáticamente cuando detecta desbalances
- Intenta mantener un número similar de chunks en cada shard
- Puede configurarse para ejecutarse en ventanas de tiempo específicas

## Ejemplo de configuración básica
Para habilitar sharding en una colección:

```javascript
// Habilitar sharding en la base de datos
sh.enableSharding("miBaseDeDatos")

// Crear índice en la shard key
db.miColeccion.createIndex({usuario_id: 1})

// Habilitar sharding en la colección
sh.shardCollection("miBaseDeDatos.miColeccion", {usuario_id: 1})
```

## Consideraciones antes de fragmentar
Los requisitos y la complejidad de la infraestructura del clúster fragmentado requieren una planificación, ejecución y mantenimiento cuidadosos.

Si bien es posible volver a fragmentar la colección más tarde, es importante considerar cuidadosamente la elección de clave de fragmentación para evitar problemas de escalabilidad y rendimiento.

A partir de `MongoDB 5.1`, al iniciar, reiniciar o añadir un `shard` (servidor) con `sh.addShard()`, se debe configurar la **preocupación de escritura a nivel de clúster (CWWC)**.

Si la `CWWC` no está configurada y el fragmento está configurado con la preocupación de escritura predeterminada `{w:1}`, el servidor de fragmentos no se iniciará ni se añadirá y generará un error.

## Conexión a un clúster fragmentado
Debes conectarte a un enrutador Mongos para interactuar con cualquier colección del clúster fragmentado. Esto incluye colecciones fragmentadas y no fragmentadas. Los clientes nunca deben conectarse a un único fragmento para realizar operaciones de lectura o escritura.

<img width="440" height="231" alt="image" src="https://github.com/user-attachments/assets/6a529589-d3c5-418a-80dd-93a01abf42d8" />


Puedes conectarte a un `mongos` de la misma manera que te conectas a un `mongod` usando `mongosh` o un controlador MongoDB.

## Estrategia de fragmentación
MongoDB admite dos estrategias de fragmentación para distribuir datos entre clústeres fragmentados .

### Fragmentación hash
Es una estrategia de distribución de datos donde MongoDB toma el valor del campo que has definido como "shard key" (clave de fragmentación) y le aplica una función hash. Esta función convierte el valor original en un **número hash**. A cada `chunk` se le asigna un rango basado en los valores **hash** calculados.


<img width="442" height="157" alt="image" src="https://github.com/user-attachments/assets/0b216921-d572-471d-a817-040b8773e0c7" />


Aunque un rango de claves de fragmento puede ser similar, es poco probable que sus valores hash se encuentren en el mismo `chunk`. La distribución de datos basada en valores hash facilita una distribución más uniforme, especialmente en conjuntos de datos donde la clave de fragmento cambia de `forma monótona`.

#### Ejemplos

```javascript
sh.shardCollection("mydb.users", {"userId": "hashed"})
sh.shardCollection("mydb.sessions", {"sessionId": "hashed"})
sh.shardCollection("mydb.logs", {"timestamp": "hashed"})
```

#### Ilustración

```javascript
// MongoDB creará chunks basados en valores hash:
// Chunk 1: userId_hash: MinKey → -5000000000000000000
// Chunk 2: userId_hash: -5000000000000000000 → 0
// Chunk 3: userId_hash: 0 → 5000000000000000000
// Chunk 4: userId_hash: 5000000000000000000 → MaxKey

sh.shardCollection("ecommerce.customers", {"userId": "hashed"})
```

#### ¿Cuando usar fragmentación hash?
```javascript
// 1. Writes secuenciales que causarían hotspots
sh.shardCollection("logs.events", {"timestamp": "hashed"})

// 2. IDs autoincrementales
sh.shardCollection("app.users", {"_id": "hashed"})

// 3. Necesitas máxima distribución uniforme
sh.shardCollection("sessions.data", {"sessionId": "hashed"})
```

Sin embargo, la distribución hash significa que las consultas basadas en rangos por medio de la `shard key` tienen menos probabilidades de apuntar a un solo `shard`, lo que da como resultado más operaciones de transmisión en todo el clúster.

### Fragmentación por rangos

Implica dividir los datos en **rangos** según los valores de la `shard key`. A cada `chunk` se le asigna un rango según los valores de la `shard key`.


<img width="443" height="144" alt="image" src="https://github.com/user-attachments/assets/be4dd6dd-91f1-49e4-8a3c-b7864e525441" />

Es más probable que un rango de `shard key` con valores similares resida en el mismo `chunk`. Esto permite **operaciones específicas**, ya que `Mongos` puede enrutar las operaciones únicamente a los `shards` que contienen los datos necesarios.

#### Ejemplos
```javascript
// Fragmentación por rangos (estrategia por defecto)
sh.shardCollection("mydb.users", {"age": 1})
sh.shardCollection("mydb.orders", {"orderDate": 1})
sh.shardCollection("mydb.products", {"category": 1, "price": 1})
```

#### Ilustración
```javascript
// MongoDB creará chunks basados en rangos de valores:
// Chunk 1: age: MinKey → 25
// Chunk 2: age: 25 → 50  
// Chunk 3: age: 50 → 75
// Chunk 4: age: 75 → MaxKey

sh.shardCollection("ecommerce.customers", {"age": 1})
```

La eficiencia de la fragmentación por rangos depende de la `shard key` elegida. Unas `shard key` mal diseñadas pueden resultar en una distribución desigual de los datos, lo que puede anular algunas de las ventajas de la fragmentación o causar cuellos de botella en el rendimiento.

---

# 15. Zonas en clústeres fragmentados

En clústeres fragmentados, se pueden crear zonas que **representan un grupo de shards** y asociar uno o más **rangos de valores de clave de fragmento** a esa zona. MongoDB enruta las lecturas y escrituras dentro de un rango de zona únicamente a los shards dentro de ella.


Esto es especialmente útil cuando el cluster se extiende a través de múltiples centros de datos.

<img width="441" height="219" alt="image" src="https://github.com/user-attachments/assets/6b3e0b14-327c-4e6e-8591-29e8b4a61d71" />

## Análisis del diagrama

### Configuración de Zones
En la parte superior vemos la definición de zonas:

- **Zona A**: Rango X: 1-10
- **Zona B**: Rango X: 10-20

### Distribución de Chunks
Los chunks (fragmentos de datos) se distribuyen según su shard key:

- `{ X : 8 }` → Va a Shard Alpha (está en zona A: 1-10)
- `{ X : 13 }` → Va a Shard Beta (está en zona B: 10-20)
- `{ X : 3 }` → Va a Shard Beta (está en zona A: 1-10)
- `{ X : 23 }` → Va a Shard Charlie (fuera de zonas definidas)

### Asignación de Shards a Zonas

- **Shard Alpha**: zone ["A"] - Solo maneja datos de zona A
- **Shard Beta**: zone ["A","B"] - Maneja datos de ambas zonas
- **Shard Charlie**: zone [ ] - No tiene zonas asignadas (datos sin zonificar)

Las zonas son **entidades lógicas** definidas a nivel del cluster. Los **shards se asignan a zonas**, no las zonas a shards. Cada zona abarca **uno o más rangos** de valores de clave de fragmento.

> [!IMPORTANT]
> Configurar zonas y rangos de zonas `antes` de fragmentar una colección vacía o inexistente permite una configuración más rápida de la fragmentación por zonas.


## Rangos
Cada zona abarca **uno** o **más** `rangos de valores` de clave de fragmento para una colección. Cada `rango` que abarca una zona siempre incluye su límite inferior y excluye su límite superior. Las zonas no pueden compartir rangos ni tener rangos superpuestos.

Por ejemplo, considera una clave de fragmento en `{"x": 1}`. El clúster tiene los siguientes rangos de zona:

```javascript
{ "x" : 5 } --> { "x" : 10 } // Zona A
{ "x" : 10} --> { "x" : 20 } // Zona B
```

- Un documento con un valor de clave de fragmento de `7` se enruta a la `zona A`.
- Un documento con un valor de clave de fragmento de `10` se enruta a la `zona B`.

## Claves de fragmentos con hash y rangos de zonas

Cuando usas un `shard key` con `hash` en MongoDB, las zonas y la distribución de datos se basan en los valores hasheados, no en los valores originales de los documentos. Esto cambia completamente cómo se comporta el enrutamiento de documentos comparado con shard keys sin hash.

Por ejemplo, considera una `shard key` en `{"x" : "hashed"}`. El siguiente rango representa el rango con hash entre `5` y `10`:

```javascript
{ "x": Long("4470791281878691347") } --> { "x": Long("7766103514953448109") } // Zone A
```

- Documento con `x: 1` → Su valor hash **SÍ** cae en la Zona `A`
- Documento con `x: 15` → Su valor hash **SÍ** cae en la Zona `A`
- Documento con `x: 8` → Su valor hash **NO** cae en la Zona `A`

El `8` (que está entre 5 y 10) **NO** va a la misma zona, porque **después del hash**, su valor transformado cae **fuera del rango definido**.

> [!IMPORTANT]
> Los rangos de zonas siempre incluyen el límite inferior y excluyen el límite superior.


## Predefinir zonas y rangos de zonas para una colección vacía o inexistente
MongoDB permite definir zonas y rangos de zona antes de fragmentar una colección vacía. Esto es importante porque:

- Las `zonas` son grupos lógicos de `shards` que pueden estar ubicados en diferentes centros de datos, regiones geográficas, o tener diferentes características de hardware
- Los `rangos de zona` definen qué valores de la clave de fragmentación (shard key) deben residir en cada zona desde el principio

Cuando ejecutas la operación de fragmentación (`sh.shardCollection()`) en una colección vacía o inexistente que `ya tiene zonas definidas`, MongoDB:

- Crea `chunks` automáticamente para cada **rango de zona** que hayas definido
- Genera `chunks` adicionales para cubrir todo el espacio posible de valores de la shard key que no esté cubierto por las zonas
- Distribuye inicialmente estos `chunks` basándose en la configuración de zonas

El `balanceador` realiza toda la gestión de `chunks` después de la creación y distribución inicial optimizada de los `chunks`.

> [!IMPORTANT]
> Los `chunks` que **no tienen zona asignada** se distribuyen entre **todos los shards disponibles** en el cluster, sin restricciones de zona.


### Ejemplo
```javascript
// 1. Primero defines las zonas
sh.addShardToZone("shard01", "US_EAST")
sh.addShardToZone("shard02", "US_WEST")

// 2. Defines los rangos de zona
sh.updateZoneKeyRange("mydb.users", 
  { region: "east", userId: MinKey }, 
  { region: "east", userId: MaxKey }, 
  "US_EAST")

sh.updateZoneKeyRange("mydb.users", 
  { region: "west", userId: MinKey }, 
  { region: "west", userId: MaxKey }, 
  "US_WEST")

// 3. Fragmentas la colección (vacía)
sh.shardCollection("mydb.users", { region: 1, userId: 1 })
```

`MinKey` y `MaxKey` son valores reales de MongoDB:

- `MinKey`: representa el valor más pequeño posible
- `MaxKey`: representa el valor más grande posible
- Son tipos de datos especiales del sistema BSON

```javascript
// Esto es código REAL que funciona:
sh.updateZoneKeyRange("mydb.users", 
  { region: "east", userId: MinKey },    // ← MinKey literal
  { region: "east", userId: MaxKey },    // ← MaxKey literal
  "US_EAST")

// Esto significa: TODOS los documentos donde region="east" 
// independientemente del valor de userId
```

Son útiles para definir rangos "abiertos":

```javascript
// Ejemplo: Todos los usuarios de región "east"
{ region: "east", userId: MinKey } → { region: "east", userId: MaxKey }

// Ejemplo: Todos los documentos con userId menor a 1000
{ region: MinKey, userId: MinKey } → { region: MaxKey, userId: 1000 }

// Ejemplo: Rango que cubre absolutamente todo
{ region: MinKey, userId: MinKey } → { region: MaxKey, userId: MaxKey }
```

## Clave de fragmento

Debes usar los campos incluidos en la clave de partición al definir un nuevo rango que una zona debe cubrir. Si usa una clave de partición compuesta, el rango debe incluir el **prefijo de la clave de partición**.


Por ejemplo, dada una clave de partición `{a: 1, b: 1, c: 1}`, para crear o actualizar un rango que cubra valores de `b`, se requiere incluir `a` como prefijo. Para crear o actualizar un rango que cubra valores de `c`, se requieren `a` y `b` como prefijos.


No puede crear rangos con campos que no estén incluidos en la clave de partición. Por ejemplo, si desea usar zonas para particionar datos según la ubicación geográfica, la clave de partición necesitaría que el primer campo contuviera datos geográficos.


Al elegir una clave de partición para una colección, considere qué campos podría usar para configurar las zonas.

> [!IMPORTANT]
> Eliminar una colección también elimina automáticamente todos sus rangos de zona asociados, así que ten esto en cuenta en tu estrategia de gestión de datos.

## Agregar shards a una zona
Asocia una `zona` a un `shard` específico mediante el método `sh.addShardToZone()` al conectarse a una instancia de `Mongos`. Un `shard` puede pertenecer a varias zonas, y varios `shard` también pueden pertenecer a la misma zona.

### Ejemplo
El siguiente ejemplo agrega la zona `NYC` a dos `shards` y las zonas `SFO` y `NRT` a un tercer `shard`:

```javascript
sh.addShardToZone("shard0000", "NYC")
sh.addShardToZone("shard0001", "NYC")
sh.addShardToZone("shard0002", "SFO")
sh.addShardToZone("shard0002", "NRT")
```

Puede eliminar la zona de un shard en particular usando el método s`h.removeShardFromZone()` cuando esté conectado a una instancia de `mongos`, como en el siguiente ejemplo, que elimina la zona `NRT` de un shard:

```javascript
sh.removeShardFromZone("shard0002", "NRT")
```

## Crear un rango de zonas

Para definir el rango de claves de fragmento de la zona, utiliza el método `sh.updateZoneKeyRange()` al conectarse a una instancia de Mongos. Cada rango de claves de fragmento solo puede tener una zona asignada. No se pueden superponer los rangos definidos.

Dada una colección denominada "users" en la base de datos "records", fragmentada por el campo de `zipcode`, las siguientes operaciones asignan:

- Dos rangos de códigos postales en Manhattan y Brooklyn (zona de Nueva York)
- Un rango de códigos postales en San Francisco (zona de San Francisco)

```javascript
sh.updateZoneKeyRange("records.users", { zipcode: "10001" }, { zipcode: "10281" }, "NYC")
sh.updateZoneKeyRange("records.users", { zipcode: "11201" }, { zipcode: "11240" }, "NYC")
sh.updateZoneKeyRange("records.users", { zipcode: "94102" }, { zipcode: "94135" }, "SFO")
```

No se puede crear un rango de valores de clave de fragmentación cuyos límites inferior y superior se superpongan con un rango existente para la colección fragmentada. Por ejemplo, dado un rango existente de `1` a `10`, no se puede crear un nuevo rango de `5` a `20`, ya que este se superpondría con el rango existente.


Una zona puede tener **varios rangos de datos asociados**, pero un rango puede estar asociado, como máximo, a **una sola zona**.


> [!NOTE]
> Los rangos de zonas siempre incluyen el límite inferior y excluyen el límite superior.


## Eliminar un rango de zona
Utilice el método auxiliar de shell `sh.removeRangeFromZone()` para eliminar un rango de una zona.

El siguiente ejemplo elimina la asignación de la zona de Nueva York para el rango de códigos postales dentro de Manhattan:

```javascript
sh.removeRangeFromZone("records.user", {zipcode: "10001"}, {zipcode: "10281"})
```

> [!NOTE]
> Al eliminar una colección se eliminan sus rangos de zona/etiqueta asociados.


## Ver zonas existentes
Utilice `sh.status()` para listar las zonas asociadas a cada shard del clúster. También puede ver las zonas de un shard consultando la colección de fragmentos en la base de datos de configuración.

El siguiente ejemplo utiliza el método `find()` para devolver todos los fragmentos con la zona `NYC`.

```javascript
use config
db.shards.find({ tags: "NYC" })
```

Puede encontrar los rangos de zona para todos los espacios de nombres en la colección de etiquetas de la base de datos de configuración. La salida de `sh.status()` también muestra todos los rangos de zona.

El siguiente ejemplo utiliza el método `find()` para devolver cualquier rango asociado a la zona `NYC`.

```javascript
use config
db.tags.find({ tag: "NYC" })
```

## `Collations` en `sharding`
Las `collations` en MongoDB definen las reglas para comparar y ordenar `strings`, incluyendo aspectos como sensibilidad a mayúsculas/minúsculas, acentos, y reglas específicas de idiomas.

Supongamos que tu colección tiene esta configuración:
```javascript
// Colección con collation española
db.createCollection("usuarios", {
  collation: { locale: "es", strength: 1 } // Ignora mayúsculas/acentos
})
```

Ahora tienes estos documentos:

```javascript
{ email: "jose@email.com", nombre: "José" }
{ email: "JOSE@email.com", nombre: "José" }  
{ email: "José@email.com", nombre: "José" }
```

Con `collation española`, MongoDB considera que estos 3 emails son "iguales":

"jose@email.com"
"JOSE@email.com"
"José@email.com"

Pero cuando MongoDB intenta hacer sharding, necesita saber exactamente en qué shard colocar cada documento. Si considera que los emails son "iguales", ¿dónde los pone?, esto crea **inconsistencias y confusión**.


### Para aplicar sharding correctamente se necesita:

### 1. Crear un índice con collation `simple`
```javascript
// Crear índice que MongoDB usará para sharding
db.usuarios.createIndex(
  { email: 1 },                    // Campo del shard key
  { collation: { locale: "simple" } }  // Reglas simples y exactas
)
```

### 2. Hacer sharding con collation simple
```javascript
sh.shardCollection("miDB.usuarios", 
  { email: 1 },                    // Shard key
  { collation: { locale: "simple" } }  // Usar reglas simples para distribución
)
```

Después del sharding tienes dos comportamientos:

### 1. Consultas normales (usan collation de la colección)
```javascript
// Usa la collation española de la colección
db.usuarios.find({ nombre: "josé" })
// Encuentra: "josé", "José", "JOSÉ", "Jose"
```

### 2. Consultas con collation `simple` (usan el índice de la shard key)
```javascript
// Usa collation simple para aprovechar el sharding
db.usuarios.find(
  { email: "jose@email.com" },
  { collation: { locale: "simple" } }
)
// Encuentra SOLO: "jose@email.com" (exacto)
```

### ¿Qué significa "simple"?

- Comparación binaria exacta
- Sensible a mayúsculas
- Sensible a acentos
- Sin reglas de idioma específicas
- Ordena por valores de bytes UTF-8

> [!NOTE]
> Por defecto, MongoDB usa `{collation: { locale: "simple"}}` al crear una colección


## Distribución inicial de chunks con shard key con `hash compuesto`

MongoDB admite la fragmentación de colecciones en índices con **hash compuesto**. Al fragmentar la colección vacía o inexistente en una clave de fragmento con hash compuesto, MongoDB optimiza la creación y distribución inicial de fragmentos.

### El campo hash es prefijo
Si el campo con hash es el prefijo de la clave de fragmento (es decir, el **primer campo** de la `shard key`), se debe cumplir con estas 2 condiciones para que MongoDB realice la creación y distribución del fragmento inicial:

#### 1.  Configuración de zona única
```javascript
// La colección debe tener una sola zona que cubra TODO el rango posible
{
  // Límites inferiores: MinKey para todos los campos
  "userId": MinKey,
  "timestamp": MinKey
},
{
  // Límites superiores: MaxKey para todos los campos  
  "userId": MaxKey,
  "timestamp": MaxKey
}
```

- `MinKey` y `MaxKey` son valores especiales que representan el mínimo y máximo posible
- Esta configuración significa que la zona abarca **todos los valores posibles** de la shard key
- Es como decir "toda la colección pertenece a una sola zona"


#### 2. Opción `presplitHashedZones: true`
```javascript
sh.shardCollection(
  "miBaseDatos.miColeccion",
  { "userId": "hashed", "timestamp": 1 },
  { presplitHashedZones: true }  // Esta opción es obligatoria
)
```

`presplitHashedZones` activa la **creación automática** de múltiples chunks **distribuidos uniformemente** antes de insertar datos


























