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
   
7. [Insertar documentos](url)
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
     
10. [Actualizar documentos](#9-actualizar-documentos)
   - [Operadores de campo](#operadores-de-campo)
   - [Operadores de array](#operadores-de-array)
11. [Eliminar documentos](#10-eliminar-documentos)


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

---

# 7. Insertar documentos

Inserta solo un documento:

```javascript
db.usuarios.insertOne({
    nombre: "Juan",
    edad: 30,
    email: "juan@email.com",
    activo: true
})
```

Insertar múltiples documentos:
```javascript
db.usuarios.insertMany([
    {nombre: "María", edad: 25, email: "maria@email.com"},
    {nombre: "Pedro", edad: 35, email: "pedro@email.com"},
    {nombre: "Ana", edad: 28, email: "ana@email.com"}
])
```

Si la colección no existe se crea automáticamente al insertar un documento. También es posible crear una coleccón explícitamente:
```javascript
db.createCollection("usuarios")
```

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
```javacript
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
```javsacript
db.usuarios.deleteMany({})
```






