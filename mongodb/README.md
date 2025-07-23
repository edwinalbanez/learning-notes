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


---

# 1. Instalación y configuración

## Pasos de instalación

1. Para habilitar el entorno de desarrollo, primero debes [descargar MongoDB](https://www.mongodb.com/try/download/community).
2. Ejecuta el instalador y acepta el acuerdo de la licencia gratuita. > [Next]
3. Da click en `Complete` para realizar la instalación completa de la base de datos.
4. Descarca la opción `Install DB as a Service` para evitar que el programa se ejecute permanentemente. > [Next]
5. Verifica que la opción `Install DB Compass` este marcada. > [Next]
6. Click en `Install`.

## Configuración de variables de entorno

1. Busca en la barra de tareas `Editar las variables de entorno del sistema`.
2. Click en `Variables de entorno...`.
3. Busca la carpeta donde se instalaron las librerias de la base de datos y tambien la ruta de la shell `mongosh` y copia ambas rutas. Las direcciones suelen ser:
  - Para el servidor: `C:\Program Files\MongoDB\Server\8.0\bin`.
  - Para **mongosh**: `C:\Program Files\MongoDB\mongosh-2.2.5-win32-x64\bin`
5. En el área de `Variables de usuario`, da doble click en la variable `Path`
6. Da click en `Nuevo` y pega una de las rutas que copiaste y repite el paso para la otra ruta.
7. Ahora, haz click en `Aceptar` en todas las ventanas emergentes.
8. En la raiz `C:\` crea una carpeta llamada `data` y dentro crea otra llamada `db`.

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

### String (Cadena)
Texto codificado en UTF-8. Es el tipo más común para almacenar texto.

```json
{ "nombre": "Juan Pérez" }
```

### Number
MongoDB maneja números de diferentes formas:

- **Int32**: Enteros de 32 bits
- **Int64**: Enteros de 64 bits
- **Double**: Números de punto flotante de 64 bits (tipo por defecto)

### Boolean
Valores verdadero o falso.

```json
{ "activo": true }
```

### Date
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

### Binary Data
Para almacenar datos binarios como imágenes o archivos.

### Regular Expression
Expresiones regulares para búsquedas de patrones.

### JavaScript Code
Código JavaScript que puede ejecutarse en el servidor.

### Null
Representa valores nulos o campos sin valor.

### Undefined
Similar a null, pero indica que el campo no está definido.

>[!IMPORTANT]
> MongoDB es `schema-flexible`, lo que significa que diferentes documentos en la misma colección pueden tener estructuras diferentes. Un documento puede tener campos que otros no tienen, y los tipos de datos pueden variar entre documentos.





