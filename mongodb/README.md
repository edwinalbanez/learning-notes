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











