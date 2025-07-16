# Guía para MySQL
## Índice
0. [Introducción](#qué-es-sql)
1. [Crear una Base de Datos](#1-crear-una-base-de-datos)
2. [Crear Tablas](#2-crear-tablas)
3. [Definir Llaves Foráneas](#3-definir-llaves-foráneas)
4. [Modificaciones con ALTER TABLE](#4-modificaciones-con-alter-table)
5. [¿Cómo Funcionan los Índices?](#5-cómo-funcionan-los-índices)
6. [Insertar, Actualizar y Eliminar Registros](#6-insertar-actualizar-y-eliminar-registros)
7. [Safe Updates](#7-safe-updates)
8. [Tablas Temporales](#8-tablas-temporales)
9. [Funciones Internas de MySQL](#9-funciones-internas-de-mysql)
10. [Operadores Aritméticos, de Comparación y Lógicos](#10-operadores-aritméticos-de-comparación-y-lógicos)
11. [Operadores BETWEEN e IN](#11-operadores-between-e-in)
12. [Operadores LIKE e IS NULL](#12-operadores-like-e-is-null)
13. [Uso de ORDER BY](#13-uso-de-order-by)
14. [Uso de LIMIT](#14-uso-de-limit)
15. [Subconsultas](#15-subconsultas)
16. [INNER JOIN](#16-inner-join)
17. [LEFT JOIN y RIGHT JOIN](#17-left-join-y-right-join)
18. [SELF JOIN](#18-self-join)
19. [Funciones de Agregado](#19-funciones-de-agregado)
20. [GROUP BY](#20-group-by)
21. [HAVING](#21-having)
22. [WITH ROLLUP](#22-with-rollup)
23. [GROUPING](#23-grouping)
24. [CASE](#24-case)
25. [Expresiones Comunes de Tablas](#25-expresiones-comunes-de-tablas)
26. [UNION y UNION ALL](#26-union-all-y-union)
27. [OVER (Funciones de Ventana)](#27-over-funciones-de-ventana)
28. [Vistas](#28-vistas)
29. [Procedimientos Almacenados](#29-procedimientos-almacenados)
30. [DECLARE HANDLER en Procedimientos almacenados](#30-declare-handler-en-procedimientos-almacenados)
31. [IF](#31-if)
32. [LOOP, WHILE, REPEAT y FOR](#32-loop-while-repeat-y-for)
33. [Cursores](#33-cursores)
34. [COALESCE](#34-coalesce)
35. [Funciones Almacenadas](#35-funciones-almacenadas)
36. [Triggers](#36-triggers)
37. [Transacciones](#37-transacciones)
38. [Creación de usuarios](#38-creación-de-usuarios)

---

# ¿Qué es SQL?
El lenguaje de consulta estructurada (SQL, por sus siglas en inglés) permite la interacción con bases de datos desde el almacenamiento y manipulación hasta la recuperación de los datos.

---
<img width="338" alt="image" src="https://github.com/user-attachments/assets/8f79a8e8-635f-4ded-b112-37f9ce5d9ea4" />

---
<img width="544" alt="image" src="https://github.com/user-attachments/assets/4e3bee63-5aac-439f-a3a9-de073c79adc0" />

---
<img width="548" alt="image" src="https://github.com/user-attachments/assets/4740b428-7562-427d-b9de-a770d7ec4f87" />

---
<img width="542" alt="image" src="https://github.com/user-attachments/assets/ff3252e8-fef7-45f2-8438-ef1b877e2e75" />

# 1. Crear una Base de Datos

## Conceptos Fundamentales
Una base de datos es un contenedor que almacena tablas, vistas, procedimientos y otros objetos relacionados. Es el primer paso para organizar la información de manera estructurada.

## Sintaxis Básica
```sql
CREATE DATABASE nombre_database;
```

## Sintaxis Avanzada
```sql
CREATE DATABASE empresa
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

## Mejores Prácticas
- Usar nombres descriptivos y consistentes
- Definir el conjunto de caracteres (CHARACTER SET) para soporte internacional
- Establecer la colación (COLLATE) para reglas de ordenamiento
- Evitar espacios y caracteres especiales en nombres

### Ejemplo Práctico
```sql
-- Crear base de datos para sistema de ventas
CREATE DATABASE sistema_ventas
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Seleccionar la base de datos para trabajar
USE sistema_ventas;
```

---
# 2. Crear Tablas

## Conceptos Fundamentales
Las tablas son estructuras que almacenan datos en filas y columnas. Cada columna tiene un tipo de dato específico y puede tener restricciones.

## Tipos de Datos Principales
- **Numéricos**: INT, DECIMAL, FLOAT, DOUBLE
- **Texto**: VARCHAR, CHAR, TEXT
- **Fecha/Hora**: DATE, TIME, DATETIME, TIMESTAMP
- **Booleanos**: BOOLEAN

## Sintaxis Básica
```sql
CREATE TABLE nombre_tabla (
    columna1 tipo_dato restricciones,
    columna2 tipo_dato restricciones,
    PRIMARY KEY (columna_pk)
);
```

### Ejemplo Completo
```sql
CREATE TABLE clientes (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id)
);

CREATE TABLE productos (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(200) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    categoria VARCHAR(50),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
```

>[!NOTE]
> En MySQL, cuando defines una columna como PRIMARY KEY, automáticamente se le aplica la restricción NOT NULL. Sin embargo, se incluye NOT NULL explícitamente por claridad y para hacer el código más legible.

## Restricciones Importantes
- **NOT NULL**: El campo no puede estar vacío
- **UNIQUE**: Valores únicos en la columna
- **DEFAULT**: Valor por defecto
- **AUTO_INCREMENT**: Incremento automático para claves primarias

---
# 3. Definir llaves foráneas

## Conceptos Fundamentales
Las llaves foráneas (Foreign Keys) establecen relaciones entre tablas, garantizando la integridad referencial de los datos.

## Sintaxis en CREATE TABLE
```sql
CREATE TABLE tabla_hija (
    id INT NOT NULL PRIMARY KEY,
    id_padre INT,
    FOREIGN KEY (id_padre) REFERENCES tabla_padre(id)
);
```

## Sintaxis con ALTER TABLE
```sql
ALTER TABLE tabla_hija
ADD CONSTRAINT fk_nombre
FOREIGN KEY (columna_local) REFERENCES tabla_padre(columna_referenciada);
```

### Ejemplo Práctico
```sql
-- Crear tabla de pedidos con referencia a clientes
CREATE TABLE pedidos (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2),
    estado VARCHAR(20) DEFAULT 'PENDIENTE',
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Crear tabla de detalles de pedido
CREATE TABLE detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id)
        ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
        ON DELETE RESTRICT
);
```

## Opciones de Integridad Referencial
- **ON DELETE CASCADE**: Elimina registros relacionados
- **ON DELETE RESTRICT**: Impide eliminar si hay referencias
- **ON DELETE SET NULL**: Establece NULL en referencias
- **ON UPDATE CASCADE**: Actualiza referencias automáticamente

## ¿Qué es la integridad referencial?
La integridad referencial es una regla que garantiza que las relaciones entre tablas se mantengan consistentes. Cuando tienes una clave foránea (foreign key) que referencia a una clave primaria en otra tabla, estas opciones definen qué sucede cuando se modifica o elimina el registro padre.

### ON DELETE CASCADE
Cuando eliminas un registro padre, automáticamente elimina todos los registros hijos relacionados.

### Ejemplo Práctico
```sql
-- Tablas: Clientes y Pedidos
CREATE TABLE Clientes (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    cliente_id INT,
    producto VARCHAR(100),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE CASCADE
);
```
Si eliminas el cliente con ID 1, todos sus pedidos se eliminan automáticamente. Es útil cuando los registros hijos no tienen sentido sin el padre (como pedidos sin cliente).

### ON DELETE RESTRICT
Impide eliminar el registro padre si existen registros hijos relacionados.

### Ejemplo:
```sql
CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    cliente_id INT,
    producto VARCHAR(100),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE RESTRICT
);
```
Si intentas eliminar un cliente que tiene pedidos, la base de datos rechaza la operación con un error. Primero debes eliminar manualmente todos los pedidos de ese cliente.

### ON DELETE SET NULL
Cuando eliminas el registro padre, establece NULL en la clave foránea de los registros hijos.

### Ejemplo:
```sql
CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    cliente_id INT NULL,  -- Debe permitir NULL
    producto VARCHAR(100),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON DELETE SET NULL
);
```
Si eliminas un cliente, sus pedidos permanecen pero con cliente_id = NULL. Útil cuando quieres conservar el historial pero marcar que el padre ya no existe.

### ON UPDATE CASCADE
Cuando cambias el valor de la clave primaria del registro padre, automáticamente actualiza todas las claves foráneas relacionadas.

### Ejemplo:
```sql
CREATE TABLE Pedidos (
    id INT PRIMARY KEY,
    cliente_id INT,
    producto VARCHAR(100),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id) ON UPDATE CASCADE
);
```
Si cambias el ID del cliente de 1 a 100, todos los pedidos que tenían cliente_id = 1 se actualizan automáticamente a cliente_id = 100.

> [!NOTE]
> Cuando creas una clave foránea sin especificar las opciones ON DELETE o ON UPDATE, el comportamiento por defecto es RESTRICT tanto para eliminaciones como para actualizaciones.

---
# 4. Modificaciones con ALTER TABLE

## Conceptos Fundamentales
`ALTER TABLE` permite modificar la estructura de tablas existentes sin perder datos.

## Agregar Columnas
```sql
ALTER TABLE tabla ADD COLUMN nueva_columna tipo_dato restricciones;
```

## Modificar Columnas
```sql
ALTER TABLE tabla MODIFY COLUMN columna nuevo_tipo_dato;
ALTER TABLE tabla CHANGE COLUMN nombre_viejo nombre_nuevo tipo_dato;
```

## Eliminar Columnas
```sql
ALTER TABLE tabla DROP COLUMN nombre_columna;
```

## Agregar/Eliminar Restricciones
```sql
-- Agregar clave primaria
ALTER TABLE tabla ADD PRIMARY KEY (columna);

-- Agregar índice
ALTER TABLE tabla ADD INDEX idx_nombre (columna);

-- Eliminar restricción
ALTER TABLE tabla DROP FOREIGN KEY nombre_fk;
```

### Ejemplos prácticos
```sql
-- Agregar columna de descuento a productos
ALTER TABLE productos 
ADD COLUMN descuento DECIMAL(5,2) DEFAULT 0.00;

-- Modificar tamaño de columna nombre en clientes
ALTER TABLE clientes 
MODIFY COLUMN nombre VARCHAR(150);

-- Cambiar nombre de columna
ALTER TABLE clientes 
CHANGE COLUMN telefono numero_telefono VARCHAR(25);

-- Agregar índice para búsquedas rápidas
ALTER TABLE productos 
ADD INDEX idx_categoria (categoria);

-- Agregar restricción UNIQUE
ALTER TABLE clientes 
ADD CONSTRAINT uk_email UNIQUE (email);
```

---
# 5. ¿Cómo funcionan los índices?
En MySQL, un **índice** es una estructura de datos especial que mejora la velocidad de las operaciones de recuperación de datos en una tabla de base de datos. Permite al motor de la base de datos encontrar filas rápidamente sin tener que escanear la tabla completa.

Cuando creas un índice en una o más columnas de una tabla, MySQL crea y mantiene una estructura de datos separada (comúnmente un árbol B o un árbol B+) que almacena los valores de esas columnas y punteros (variables que almacenan una dirección numérica que apunta a la ubicación específica de un dato en la memoria RAM) a las filas correspondientes en la tabla real.

Cuando ejecutas una consulta SELECT que incluye una cláusula WHERE en una columna indexada, MySQL puede usar el índice para ir directamente a las filas que cumplen con la condición, en lugar de revisar cada fila de la tabla.

### Ejemplos de creación de índices:
```sql
-- Crear un índice simple en una columna
CREATE INDEX idx_nombre ON clientes (nombre);

-- Crear un índice único
CREATE UNIQUE INDEX udx_email ON usuarios (email);

-- Crear un índice compuesto (en múltiples columnas)
-- Útil para consultas que filtran por ambas columnas
CREATE INDEX idx_apellido_nombre ON empleados (apellido, nombre);

-- Crear un índice FULLTEXT
CREATE FULLTEXT INDEX fdx_contenido ON articulos (titulo, contenido);
```

Cuando MySQL construye el índice, tomará todos los valores de la columna nombre de cada fila de la tabla clientes y los organizará en una estructura optimizada para búsquedas (generalmente un árbol B-Tree).

MySQL escanea la tabla clientes. Para cada fila, toma el valor de la columna `nombre` y un "puntero"  a la ubicación física de esa fila en el disco.

La estructura del índice (idx_nombre) se almacena en el disco, separada de los datos reales de la tabla clientes. Esto significa que el índice ocupa espacio de almacenamiento adicional.

## ¿Para qué es útil este índice? (Un Ejemplo Práctico)
Imagina que tienes una tabla clientes con millones de filas, y a menudo realizas consultas como:
```sql
SELECT * FROM clientes WHERE nombre = 'Juan Perez';
```
**Sin el índice `idx_nombre`**:
MySQL tendría que recorrer toda la tabla (fila por fila, lo que se llama un "escaneo de tabla completo" o "full table scan") para encontrar todas las filas donde el nombre sea 'Juan Perez'. Si la tabla tiene un millón de clientes, eso podría significar leer un millón de filas, lo cual es muy ineficiente y lento.

---
# 6. Insertar, Actualizar y Eliminar Registros

## INSERT - insertar daatos

### Sintaxis Básica
```sql
INSERT INTO tabla (columna1, columna2) VALUES (valor1, valor2);
```

## Inserción múltiple
```sql
INSERT INTO tabla (columna1, columna2) VALUES 
(valor1a, valor2a),
(valor1b, valor2b),
(valor1c, valor2c);
```

### Ejemplos Prácticos
```sql
-- Insertar un cliente
INSERT INTO clientes (nombre, email, telefono) 
VALUES ('Juan Pérez', 'juan@email.com', '555-1234');

-- Insertar múltiples productos
INSERT INTO productos (nombre, precio, stock, categoria) VALUES
('Laptop Dell', 899.99, 10, 'Electrónicos'),
('Mouse Inalámbrico', 25.50, 50, 'Accesorios'),
('Teclado Mecánico', 120.00, 20, 'Accesorios');
```

## UPDATE - actualizar datos

### Sintaxis básica
```sql
UPDATE tabla SET columna1 = valor1 WHERE condición;
```

### Ejemplos prácticos
```sql
-- Actualizar precio de un producto
UPDATE IGNORE productos 
SET precio = 799.99 
WHERE id_producto = 1;

-- Actualizar múltiples columnas
UPDATE IGNORE clientes 
SET email = 'nuevo@email.com', telefono = '555-9999'
WHERE id_cliente = 1;

-- Actualizar con cálculos
UPDATE IGNORE productos 
SET precio = precio * 1.10 
WHERE categoria = 'Electrónicos';
```

>[!NOTE]
>El comando **opcional** `IGNORE` sirve para que no se detenga la ejecución de una consulta si se producen errores al momento de la actualización. En caso de que hayan errores no se realiza la actualización y continua con la siguiente sentencia.

>[!WARNING]
> Siempre se debe especificar con `WHERE` el registro a actualizar, de lo contrario, se actualizarán todos los registros de la tabla.

## DELETE - Eliminar Datos

### Sintaxis Básica
```sql
DELETE FROM tabla WHERE condición;
```

### Ejemplos Prácticos
```sql
-- Eliminar un cliente específico
DELETE FROM clientes WHERE id_cliente = 5;

-- Eliminar productos sin stock
DELETE FROM productos WHERE stock = 0;

-- Eliminar con subconsulta
DELETE FROM detalle_pedidos 
WHERE id_pedido IN (
    SELECT id_pedido FROM pedidos 
    WHERE estado = 'CANCELADO'
);
```

>[!WARNING]
> Siempre se debe especificar con `WHERE` el registro a eliminar, de lo contrario, se eliminarán todos los registros de la tabla.

---
# 7. Safe Updates
En MySQL, la opción `safe Updates (rejects UPDATEs and DELETEs with no restrictions)` en `Edit` > `SQL Editor` es un mecanismo de seguridad que previene la ejecución accidental de comandos UPDATE y DELETE que podrían modificar o eliminar datos de manera masiva e indeseada.

<img width="589" alt="image" src="https://github.com/user-attachments/assets/74315518-08f1-4ad0-a0fb-7eeaef99edf6" />

## ¿Qué hace exactamente?
Cuando está habilitada, esta opción rechaza automáticamente cualquier comando UPDATE o DELETE que no incluya una cláusula WHERE con al menos una de estas condiciones:

- Una cláusula `WHERE` que haga referencia a una columna con índice (KEY).
- Una cláusula `LIMIT` que restrinja el número de filas afectadas.
- El comando debe poder usar un índice para localizar las filas.

## ¿Por qué es importante?
Sin esta protección, es muy fácil cometer errores devastadores como:
```sql
-- PELIGROSO: Elimina TODOS los registros de la tabla
DELETE FROM usuarios;

-- PELIGROSO: Actualiza TODOS los salarios a 0
UPDATE empleados SET salario = 0;
```
Con `Safe Updates` habilitado, estos comandos serían rechazados automáticamente.

## Comandos que serían aceptados:
```sql
-- SEGURO: Usa una clave primaria en WHERE
DELETE FROM usuarios WHERE id = 123;

-- SEGURO: Usa un índice en WHERE
UPDATE empleados SET salario = 5000 WHERE email = 'juan@empresa.com';

-- SEGURO: Incluye LIMIT
DELETE FROM logs ORDER BY fecha LIMIT 100;
```

## Comandos que serían rechazados:
```sql
-- RECHAZADO: No tiene WHERE
DELETE FROM usuarios;

-- RECHAZADO: WHERE no usa columna indexada
UPDATE empleados SET salario = salario * 1.1 WHERE departamento = 'ventas';
```

### Cómo habilitarla/deshabilitarla:
```sql
-- Habilitar Safe Updates
SET sql_safe_updates = 1;

-- Deshabilitar Safe Updates
SET sql_safe_updates = 0;

-- Verificar el estado actual
SELECT @@sql_safe_updates;
```

>[!NOTE]
>No significa que solo puedas eliminar o actualizar 1 registro. `Safe Updates` no limita el número de registros que puedes modificar, sino que se asegura de que uses condiciones "seguras" en tu `WHERE`.

Safe Updates verifica que tu comando WHERE use columnas indexadas, no que afecte solo 1 registro. Puedes modificar múltiples registros siempre que uses índices.

### Ejemplos Prácticos
```sql
-- ✅ PERMITIDO: Puede eliminar 100 usuarios con el mismo rol
-- (si 'rol' tiene índice)
DELETE FROM usuarios WHERE rol = 'invitado';

-- ✅ PERMITIDO: Puede actualizar todos los empleados de un departamento
-- (si 'departamento_id' tiene índice)
UPDATE empleados SET salario = salario * 1.1 WHERE departamento_id = 5;

-- ✅ PERMITIDO: Puede eliminar múltiples pedidos del mismo cliente
-- (si 'cliente_id' tiene índice)
DELETE FROM pedidos WHERE cliente_id = 123;

-- ❌ RECHAZADO: No usa columna indexada
DELETE FROM usuarios WHERE nombre_completo LIKE '%Juan%';

-- ❌ RECHAZADO: No tiene WHERE
UPDATE empleados SET activo = 0;
```

---

# 8. Tablas Temporales
Las tablas temporales en MySQL son estructuras de datos que existen solo durante una sesión específica o por un tiempo determinado.

## Características principales
Las tablas temporales de sesión se crean con la palabra clave `TEMPORARY` y tienen estas propiedades:

- Solo son visibles para la conexión que las creó.
- Se eliminan automáticamente cuando la sesión termina.
- No aparecen en `SHOW TABLES`.
- Pueden tener el mismo nombre que una tabla permanente (la temporal tendrá prioridad, pero es recomendable asignarle un nombre diferente).
- Se almacenan en memoria o en disco según su tamaño.

## Sintaxis Básica
```sql
CREATE TEMPORARY TABLE nombre_tabla (
    columna1 tipo_dato,
    columna2 tipo_dato,
    ...
);
```

### Ejemplo práctico
```sql
-- Crear tabla temporal para procesamiento de datos
CREATE TEMPORARY TABLE temp_ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto VARCHAR(100),
    cantidad INT,
    precio DECIMAL(10,2),
    fecha DATE
);

-- Insertar datos
INSERT INTO temp_ventas (producto, cantidad, precio, fecha)
VALUES ('Laptop', 2, 1500.00, '2024-01-15');

-- La tabla desaparece al cerrar la conexión
```

También es posible crear tablas temporales con el comando `SELECT`.

## Sintaxis Básica
```sql
CREATE TEMPORARY TABLE nombre_tabla AS
SELECT columnas FROM tabla_origen WHERE condiciones;
```

### Ejemplo Práctico
```sql
-- Crear tabla temporal directamente desde una consulta
CREATE TEMPORARY TABLE temp_ventas_enero AS
SELECT 
    cliente_id,
    producto,
    cantidad,
    precio,
    fecha
FROM ventas 
WHERE MONTH(fecha) = 1 AND YEAR(fecha) = 2024;
```

## Motor de Almacenamiento

### MEMORY Engine
Para tablas completamente en memoria:
```sql
CREATE TEMPORARY TABLE temp_cache (
    id INT PRIMARY KEY,
    datos VARCHAR(255)
) ENGINE=MEMORY;
```
**Ventajas**: Acceso muy rápido.

**Desventajas**: Limitado por la RAM disponible, se pierden si se reinicia MySQL

### InnoDB/MyISAM
Para tablas que pueden usar disco:
```sql
CREATE TEMPORARY TABLE temp_procesamiento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    datos TEXT
) ENGINE=InnoDB;
```

## Motor Predeterminado
El motor de almacenamiento por defecto para las tablas temporales depende de la configuración del servidor y se controla mediante la variable `default_tmp_storage_engine`.

Por defecto, las tablas temporales creadas con `CREATE TEMPORARY TABLE` utilizan el motor definido por la variable `default_tmp_storage_engine`, que por defecto es `InnoDB`.

### Verificar la configuración actual
```sql
-- Ver el motor por defecto para tablas temporales
SHOW VARIABLES LIKE 'default_tmp_storage_engine';

-- También puedes ver todas las variables relacionadas
SHOW VARIABLES LIKE '%tmp%storage%';
```

### Cambiar el motor por defecto
```sql
-- Para la sesión actual
SET default_tmp_storage_engine = 'MEMORY';

-- Para cambiar globalmente (requiere privilegios SUPER)
SET GLOBAL default_tmp_storage_engine = 'MEMORY';
```

## Para diferentes casos de uso:

### InnoDB (por defecto):
- Bueno para tablas temporales grandes.
- Soporte completo para transacciones.
- Mejor para datos que pueden exceder la memoria.

### MEMORY
- Ideal para tablas pequeñas y acceso muy rápido
- Limitado por la RAM disponible
- No soporta columnas TEXT/BLOB

---

# 9. Funciones internas de MySQL
MySQL cuenta con **funciones internas** para operar cadenas de textos, números y fechas. Algunas de estas son:

<img width="374" alt="image" src="https://github.com/user-attachments/assets/4752a640-4ec0-43ba-bd28-0330a0118969" />

---
<img width="451" alt="image" src="https://github.com/user-attachments/assets/e1f3c2e2-8181-4f5d-80b5-5ee9a3342b9c" />

---
<img width="452" alt="image" src="https://github.com/user-attachments/assets/7a9be808-7292-440c-8b26-0134e38b71db" />

---

# 10. Operadores Aritméticos, de Comparación y Lógicos

## Operadores Aritméticos
Los operadores aritméticos permiten realizar cálculos matemáticos en consultas SQL:

### Operadores básicos:
- `+` (suma): Suma dos valores.
- `-` (resta): Resta el segundo valor del primero.
- `*` (multiplicación): Multiplica dos valores.
- `/` (división): Divide el primer valor entre el segundo.
- `%` o `MOD` (módulo): Devuelve el resto de una división.

### Ejemplos:
```sql
SELECT 10 + 5;          -- Resultado: 15
SELECT 20 - 8;          -- Resultado: 12
SELECT 6 * 7;           -- Resultado: 42
SELECT 15 / 3;          -- Resultado: 5.0000
SELECT 17 % 5;          -- Resultado: 2
SELECT 17 MOD 5;        -- Resultado: 2
```

### Uso en consultas:
```sql
SELECT producto_id, precio, cantidad, precio * cantidad AS total
FROM ventas;

SELECT empleado_id, salario, salario * 0.15 AS impuesto
FROM empleados;
```

## Operadores de comparación
Estos operadores comparan valores y devuelven un resultado booleano (1 para verdadero, 0 para falso):

### Operadores principales:

- `=` (igual): Comprueba si dos valores son iguales.
- `!=` o <> (diferente): Comprueba si dos valores son diferentes.
- `<` (menor que): El primer valor es menor que el segundo.
- `>` (mayor que): El primer valor es mayor que el segundo.
- `<=` (menor o igual): El primer valor es menor o igual que el segundo.
- `>=` (mayor o igual): El primer valor es mayor o igual que el segundo.

### Operadores especiales:

- `BETWEEN`: Verifica si un valor está dentro de un rango.
- `IN`: Verifica si un valor está en una lista de valores.
- `LIKE`: Busca un patrón específico en texto.
- `IS NULL` / `IS NOT NULL`: Verifica valores nulos.
- `REGEXP` o `RLIKE`: Coincidencia con expresiones regulares.

### Ejemplos:
```sql
-- Operadores básicos
SELECT * FROM productos WHERE precio = 100;
SELECT * FROM empleados WHERE edad > 30;
SELECT * FROM clientes WHERE ciudad != 'Madrid';

-- BETWEEN
SELECT * FROM productos WHERE precio BETWEEN 50 AND 200;

-- IN
SELECT * FROM empleados WHERE departamento IN ('Ventas', 'Marketing');

-- LIKE (% = cualquier número de caracteres, _ = un carácter)
SELECT * FROM clientes WHERE nombre LIKE 'Juan%';
SELECT * FROM productos WHERE codigo LIKE 'PR_001';

-- IS NULL
SELECT * FROM empleados WHERE telefono IS NULL;
```

## Operadores lógicos
Los operadores lógicos combinan o modifican condiciones booleanas.

### Operadores principales:

- `AND` (&&): Devuelve verdadero si ambas condiciones son verdaderas.
- `OR` (||): Devuelve verdadero si al menos una condición es verdadera.
- `NOT` (!): Invierte el valor lógico de una condición.
- `XOR`: Devuelve verdadero si exactamente una de las condiciones es verdadera.

## Tablas de verdad:

### `AND`:
- TRUE `AND` TRUE = TRUE
- TRUE `AND` FALSE = FALSE
- FALSE `AND` TRUE = FALSE
- FALSE `AND` FALSE = FALSE

### `OR`:
- TRUE `OR` TRUE = TRUE
- TRUE `OR` FALSE = TRUE
- FALSE `OR` TRUE = TRUE
- FALSE `OR` FALSE = FALSE

### `NOT`:
- `NOT` TRUE = FALSE
- `NOT` FALSE = TRUE

## Ejemplos prácticos:
```sql
-- AND
SELECT * FROM empleados 
WHERE edad > 25 AND salario > 3000;

-- OR
SELECT * FROM productos 
WHERE categoria = 'Electrónicos' OR precio < 100;

-- NOT
SELECT * FROM clientes 
WHERE NOT ciudad = 'Barcelona';

-- Combinación de operadores
SELECT * FROM empleados 
WHERE (departamento = 'Ventas' OR departamento = 'Marketing') 
AND salario BETWEEN 2000 AND 5000;

-- XOR
SELECT * FROM productos 
WHERE (precio > 100) XOR (categoria = 'Libros');
```

## Orden de operadores:
MySQL evalúa los operadores en el siguiente orden (de mayor a menor precedencia):

1. Paréntesis `()`
2. Operadores aritméticos: `*`, `/`, `%`
3. Operadores aritméticos: `+`, `-`
4. Operadores de comparación: `=`, `!=`, `<`, `>`, `<=`, `>=`
5. `NOT`
6. `AND`
7. `OR`, `XOR`

### Ejemplo de precedencia:
```sql
-- Sin paréntesis (AND tiene mayor precedencia que OR)
SELECT * FROM empleados 
WHERE departamento = 'Ventas' OR departamento = 'IT' AND salario > 3000;
-- Equivale a: departamento = 'Ventas' OR (departamento = 'IT' AND salario > 3000)

-- Con paréntesis para cambiar precedencia
SELECT * FROM empleados 
WHERE (departamento = 'Ventas' OR departamento = 'IT') AND salario > 3000;
```

---

# 11. Operadores BETWEEN e IN

## Operador `BETWEEN`

### Conceptos fundamentales
`BETWEEN` filtra registros dentro de un rango específico, incluyendo los valores límite.

### Sintaxis
```sql
SELECT * FROM tabla WHERE columna BETWEEN valor1 AND valor2;
```

### Ejemplos prácticos
```sql
-- Productos en rango de precio
SELECT * FROM productos 
WHERE precio BETWEEN 50.00 AND 200.00;

-- Pedidos en rango de fechas
SELECT * FROM pedidos 
WHERE fecha_pedido BETWEEN '2024-01-01' AND '2024-12-31';

-- Usando NOT BETWEEN
SELECT * FROM productos 
WHERE precio NOT BETWEEN 100.00 AND 500.00;
```

## Operador `IN`

### Conceptos fundamentales
IN permite filtrar registros que coincidan con cualquier valor de una lista.

### Sintaxis
```sql
SELECT * FROM tabla WHERE columna IN (valor1, valor2, valor3);
```

### Ejemplos prácticos
```sql
-- Productos de categorías específicas
SELECT * FROM productos 
WHERE categoria IN ('Electrónicos', 'Accesorios', 'Software');

-- Pedidos con estados específicos
SELECT * FROM pedidos 
WHERE estado IN ('PENDIENTE', 'PROCESANDO');

-- Usando subconsulta con IN
SELECT * FROM clientes 
WHERE id_cliente IN (
    SELECT DISTINCT id_cliente FROM pedidos 
    WHERE fecha_pedido >= '2024-01-01'
);
```

---

# 12. Operadores `LIKE` e `IS NULL`

## Operador LIKE

### Conceptos fundamentales
LIKE permite búsquedas con patrones usando comodines:
- `%`: Representa cero o más caracteres
- `_`: Representa exactamente un carácter

### Sintaxis
```sql
SELECT * FROM tabla WHERE columna LIKE 'patrón';
```

### Ejemplos prácticos
```sql
-- Clientes cuyo nombre comience con 'Juan'
SELECT * FROM clientes 
WHERE nombre LIKE 'Juan%';

-- Emails que contengan 'gmail'
SELECT * FROM clientes 
WHERE email LIKE '%gmail%';

-- Teléfonos con formato específico
SELECT * FROM clientes 
WHERE telefono LIKE '555-____';

-- Productos que NO contengan 'Dell'
SELECT * FROM productos 
WHERE nombre NOT LIKE '%Dell%';
```

## Operador `IS NULL`

### Conceptos Fundamentales
IS NULL identifica registros con valores nulos (vacíos).

### Sintaxis
```sql
SELECT * FROM tabla WHERE columna IS NULL;
SELECT * FROM tabla WHERE columna IS NOT NULL;
```

### Ejemplos prácticos
```sql
-- Clientes sin email registrado
SELECT * FROM clientes 
WHERE email IS NULL;

-- Productos con todas las columnas completas
SELECT * FROM productos 
WHERE precio IS NOT NULL 
  AND categoria IS NOT NULL 
  AND stock IS NOT NULL;

-- Pedidos sin fecha de entrega
SELECT * FROM pedidos 
WHERE fecha_entrega IS NULL;
```

---

# 13. Uso de `ORDER BY`

### Conceptos fundamentales
ORDER BY ordena los resultados de una consulta según una o más columnas.

### Sintaxis básica
```sql
SELECT * FROM tabla ORDER BY columna [ASC|DESC];
```

### Ordenamiento múltiple
```sql
SELECT * FROM tabla ORDER BY columna1 ASC, columna2 DESC;
```

### Ejemplos prácticos
```sql
-- Productos ordenados por precio (menor a mayor)
SELECT * FROM productos 
ORDER BY precio ASC;

-- Clientes ordenados por nombre alfabéticamente
SELECT * FROM clientes 
ORDER BY nombre;

-- Pedidos por fecha (más recientes primero)
SELECT * FROM pedidos 
ORDER BY fecha_pedido DESC;

-- Ordenamiento múltiple
SELECT * FROM productos 
ORDER BY categoria ASC, precio DESC;

-- Ordenar por columna calculada
SELECT nombre, precio, (precio * 0.9) as precio_descuento
FROM productos 
ORDER BY precio_descuento DESC;
```

### Ordenamiento avanzado
```sql
-- Ordenar por posición de columna
SELECT nombre, precio FROM productos 
ORDER BY 2 DESC; -- Ordena por la segunda columna (precio)

-- Ordenamiento condicional con CASE
SELECT * FROM pedidos 
ORDER BY 
  CASE estado 
    WHEN 'URGENTE' THEN 1
    WHEN 'PENDIENTE' THEN 2
    WHEN 'PROCESANDO' THEN 3
    ELSE 4
  END;
```

---

# 14. Uso de `LIMIT`

## Conceptos fundamentales
LIMIT restringe el número de filas devueltas por una consulta.

## Sintaxis básica
```sql
SELECT * FROM tabla LIMIT cantidad;
```

## Con `OFFSET`
```sql
SELECT * FROM tabla LIMIT offset, cantidad;
-- o en algunos sistemas:
SELECT * FROM tabla LIMIT cantidad OFFSET offset;
```

### Ejemplos prácticos
```sql
-- Los 5 productos más caros
SELECT * FROM productos 
ORDER BY precio DESC 
LIMIT 5;

-- Paginación: segunda página de 10 registros
SELECT * FROM clientes 
ORDER BY nombre 
LIMIT 10 OFFSET 10;

-- Los 3 clientes más recientes
SELECT * FROM clientes 
ORDER BY fecha_registro DESC 
LIMIT 3;

-- Producto más vendido (usando JOIN)
SELECT p.nombre, SUM(dp.cantidad) as total_vendido
FROM productos p
JOIN detalle_pedidos dp ON p.id_producto = dp.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY total_vendido DESC
LIMIT 1;
```

## Paginación profesional
```sql
-- Función para paginación
-- Página 1: LIMIT 10 OFFSET 0
-- Página 2: LIMIT 10 OFFSET 10
-- Página N: LIMIT 10 OFFSET ((N-1) * 10)

SELECT SQL_CALC_FOUND_ROWS * FROM productos 
ORDER BY nombre 
LIMIT 10 OFFSET 20;

-- Para obtener el total de registros:
SELECT FOUND_ROWS();
```

---

## 15. Subconsultas

## Conceptos fundamentales
Las subconsultas son consultas anidadas dentro de otras consultas, permitiendo operaciones complejas de filtrado y análisis.

## Subconsultas en `SELECT`

### Sintaxis
```sql
SELECT columna1, (SELECT ... FROM ...) as alias FROM tabla;
```

### Ejemplos prácticos
```sql
-- Mostrar clientes con su total de pedidos
SELECT 
    c.nombre,
    c.email,
    (SELECT COUNT(*) FROM pedidos p WHERE p.id_cliente = c.id_cliente) as total_pedidos,
    (SELECT COALESCE(SUM(total), 0) FROM pedidos p WHERE p.id_cliente = c.id_cliente) as monto_total
FROM clientes c;

-- Productos con su ranking de ventas
SELECT 
    p.nombre,
    p.precio,
    (SELECT COUNT(*) + 1 
     FROM productos p2 
     WHERE p2.precio > p.precio) as ranking_precio
FROM productos p
ORDER BY ranking_precio;
```

## Subconsultas en `FROM`

### Sintaxis
```sql
SELECT * FROM (SELECT ... FROM ...) as alias;
```

### Ejemplos prácticos
```sql
-- Análisis de ventas por mes
SELECT 
    mes,
    AVG(total_mes) as promedio_mensual
FROM (
    SELECT 
        DATE_FORMAT(fecha_pedido, '%Y-%m') as mes,
        SUM(total) as total_mes
    FROM pedidos
    GROUP BY DATE_FORMAT(fecha_pedido, '%Y-%m')
) as ventas_mensuales;

-- Top 5 clientes y sus detalles
SELECT c.*, top_clientes.total_gastado
FROM clientes c
JOIN (
    SELECT id_cliente, SUM(total) as total_gastado
    FROM pedidos
    GROUP BY id_cliente
    ORDER BY total_gastado DESC
    LIMIT 5
) as top_clientes ON c.id_cliente = top_clientes.id_cliente;
```

## Subconsultas en `WHERE`

### Ejemplos prácticos
```sql
-- Clientes que han realizado pedidos
SELECT * FROM clientes 
WHERE id_cliente IN (
    SELECT DISTINCT id_cliente FROM pedidos
);

-- Productos más caros que el promedio
SELECT * FROM productos 
WHERE precio > (
    SELECT AVG(precio) FROM productos
);

-- Clientes con pedidos superiores a $500
SELECT * FROM clientes 
WHERE EXISTS (
    SELECT 1 FROM pedidos 
    WHERE pedidos.id_cliente = clientes.id_cliente 
    AND total > 500
);

-- Productos nunca vendidos
SELECT * FROM productos 
WHERE id_producto NOT IN (
    SELECT DISTINCT id_producto 
    FROM detalle_pedidos 
    WHERE id_producto IS NOT NULL
);
```

## Subconsultas correlacionadas
```sql
-- Empleados con salario superior al promedio de su departamento
SELECT e1.* FROM empleados e1
WHERE salario > (
    SELECT AVG(salario) 
    FROM empleados e2 
    WHERE e2.departamento = e1.departamento
);
```

---

# 16. `INNER JOIN`

## Conceptos fundamentales
INNER JOIN combina registros de dos o más tablas basándose en una condición de coincidencia. Solo devuelve registros que tienen coincidencias en ambas tablas.

## Sintaxis básica
```sql
SELECT columnas
FROM tabla1
INNER JOIN tabla2 ON tabla1.columna = tabla2.columna;
```

## Ejemplos prácticos

### JOIN básico
```sql
-- Pedidos con información del cliente
SELECT 
    p.id_pedido,
    c.nombre as cliente,
    p.fecha_pedido,
    p.total
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente;
```

### JOIN múltiple
```sql
-- Detalle completo de pedidos
SELECT 
    c.nombre as cliente,
    p.id_pedido,
    pr.nombre as producto,
    dp.cantidad,
    dp.precio_unitario,
    (dp.cantidad * dp.precio_unitario) as subtotal
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
INNER JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
INNER JOIN productos pr ON dp.id_producto = pr.id_producto;
```

### JOIN con condiciones adicionales
```sql
-- Pedidos de electrónicos del último año
SELECT 
    c.nombre as cliente,
    p.fecha_pedido,
    pr.nombre as producto,
    dp.cantidad
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
INNER JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
INNER JOIN productos pr ON dp.id_producto = pr.id_producto
WHERE pr.categoria = 'Electrónicos'
  AND p.fecha_pedido >= DATE_SUB(NOW(), INTERVAL 1 YEAR);
```

### Casos de Uso Profesionales
```sql
-- Análisis de rendimiento de ventas
SELECT 
    pr.categoria,
    COUNT(dp.id_detalle) as items_vendidos,
    SUM(dp.cantidad) as cantidad_total,
    SUM(dp.cantidad * dp.precio_unitario) as ingresos_totales,
    AVG(dp.precio_unitario) as precio_promedio
FROM productos pr
INNER JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
INNER JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE p.estado = 'COMPLETADO'
GROUP BY pr.categoria
ORDER BY ingresos_totales DESC;
```

---

# 17. LEFT JOIN y RIGHT JOIN

## LEFT JOIN

### Conceptos Fundamentales
LEFT JOIN devuelve todos los registros de la tabla izquierda y los registros coincidentes de la tabla derecha. Si no hay coincidencia, devuelve NULL para las columnas de la derecha.

### Sintaxis
```sql
SELECT columnas
FROM tabla_izquierda
LEFT JOIN tabla_derecha ON condición;
```

### Ejemplos Prácticos
```sql
-- Todos los clientes y sus pedidos (incluso si no tienen pedidos)
SELECT 
    c.nombre,
    c.email,
    p.id_pedido,
    p.total,
    p.fecha_pedido
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
ORDER BY c.nombre;

-- Clientes sin pedidos
SELECT c.*
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_cliente IS NULL;

-- Productos y sus ventas totales (incluso productos no vendidos)
SELECT 
    pr.nombre,
    pr.precio,
    COALESCE(SUM(dp.cantidad), 0) as total_vendido,
    COALESCE(SUM(dp.cantidad * dp.precio_unitario), 0) as ingresos
FROM productos pr
LEFT JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto, pr.nombre, pr.precio
ORDER BY total_vendido DESC;
```

## RIGHT JOIN

### Conceptos Fundamentales
RIGHT JOIN es lo opuesto a LEFT JOIN: devuelve todos los registros de la tabla derecha y los coincidentes de la izquierda.

### Sintaxis
```sql
SELECT columnas
FROM tabla_izquierda
RIGHT JOIN tabla_derecha ON condición;
```

### Ejemplos Prácticos
```sql
-- Todos los pedidos y sus clientes
SELECT 
    p.id_pedido,
    p.fecha_pedido,
    c.nombre,
    c.email
FROM clientes c
RIGHT JOIN pedidos p ON c.id_cliente = p.id_cliente;

-- Equivalente usando LEFT JOIN (más común)
SELECT 
    p.id_pedido,
    p.fecha_pedido,
    c.nombre,
    c.email
FROM pedidos p
LEFT JOIN clientes c ON p.id_cliente = c.id_cliente;
```

### Casos de uso profesionales

#### Análisis de Abandono de Clientes
```sql
-- Clientes registrados pero que nunca compraron
SELECT 
    c.nombre,
    c.email,
    c.fecha_registro,
    DATEDIFF(NOW(), c.fecha_registro) as dias_sin_comprar
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.id_cliente IS NULL
ORDER BY c.fecha_registro;
```

#### Inventario y Ventas
```sql
-- Reporte completo de inventario con ventas
SELECT 
    pr.nombre,
    pr.stock,
    pr.precio,
    COALESCE(ventas.total_vendido, 0) as total_vendido,
    COALESCE(ventas.ingresos, 0) as ingresos_generados,
    (pr.stock + COALESCE(ventas.total_vendido, 0)) as stock_inicial_estimado
FROM productos pr
LEFT JOIN (
    SELECT 
        dp.id_producto,
        SUM(dp.cantidad) as total_vendido,
        SUM(dp.cantidad * dp.precio_unitario) as ingresos
    FROM detalle_pedidos dp
    JOIN pedidos p ON dp.id_pedido = p.id_pedido
    WHERE p.estado = 'COMPLETADO'
    GROUP BY dp.id_producto
) as ventas ON pr.id_producto = ventas.id_producto;
```

---

# 18. SELF JOIN

## Conceptos Fundamentales
SELF JOIN es una técnica donde una tabla se une consigo misma. Es útil para comparar registros dentro de la misma tabla o para trabajar con estructuras jerárquicas.

## Sintaxis Básica
```sql
SELECT columnas
FROM tabla t1
JOIN tabla t2 ON condición
WHERE t1.id != t2.id; -- Evitar comparar un registro consigo mismo
```

## Preparación de datos de ejemplo
```sql
-- Tabla de empleados con estructura jerárquica
CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(100),
    puesto VARCHAR(50),
    salario DECIMAL(10,2),
    id_supervisor INT,
    departamento VARCHAR(50),
    FOREIGN KEY (id_supervisor) REFERENCES empleados(id_empleado)
);

INSERT INTO empleados VALUES
(1, 'Ana García', 'Director General', 15000.00, NULL, 'Dirección'),
(2, 'Carlos López', 'Gerente Ventas', 8000.00, 1, 'Ventas'),
(3, 'María Rodríguez', 'Gerente IT', 8500.00, 1, 'IT'),
(4, 'Juan Pérez', 'Vendedor Senior', 4500.00, 2, 'Ventas'),
(5, 'Laura Martín', 'Desarrolladora', 5500.00, 3, 'IT'),
(6, 'Pedro Sánchez', 'Vendedor Junior', 3500.00, 2, 'Ventas');
```

## Ejemplos Prácticos

### Estructura Jerárquica (Empleados y Supervisores)
```sql
-- Empleados con sus supervisores
SELECT 
    e.nombre as empleado,
    e.puesto,
    s.nombre as supervisor,
    s.puesto as puesto_supervisor
FROM empleados e
LEFT JOIN empleados s ON e.id_supervisor = s.id_empleado
ORDER BY s.nombre, e.nombre;
```

### Comparaciones Dentro de la Misma Tabla
```sql
-- Empleados que ganan más que otros en el mismo departamento
SELECT 
    e1.nombre as empleado,
    e1.salario,
    e2.nombre as empleado_comparado,
    e2.salario as salario_comparado,
    e1.departamento
FROM empleados e1
JOIN empleados e2 ON e1.departamento = e2.departamento
WHERE e1.salario > e2.salario
ORDER BY e1.departamento, e1.salario DESC;
```

### Encontrar duplicados o similitudes
```sql
-- Empleados con salarios similares (diferencia menor a 1000)
SELECT 
    e1.nombre as empleado1,
    e1.salario as salario1,
    e2.nombre as empleado2,
    e2.salario as salario2,
    ABS(e1.salario - e2.salario) as diferencia
FROM empleados e1
JOIN empleados e2 ON e1.id_empleado < e2.id_empleado
WHERE ABS(e1.salario - e2.salario) < 1000
ORDER BY diferencia;
```

## Casos de Uso Profesionales

### Análisis de jerarquías
```sql
-- Supervisores con el número de subordinados y salario promedio del equipo
SELECT 
    s.nombre as supervisor,
    s.puesto,
    COUNT(e.id_empleado) as num_subordinados,
    AVG(e.salario) as salario_promedio_equipo,
    MAX(e.salario) as salario_maximo_equipo,
    MIN(e.salario) as salario_minimo_equipo
FROM empleados s
JOIN empleados e ON s.id_empleado = e.id_supervisor
GROUP BY s.id_empleado, s.nombre, s.puesto
ORDER BY num_subordinados DESC;
```

### Detección de anomalías
```sql
-- Empleados que ganan más que su supervisor
SELECT 
    e.nombre as empleado,
    e.salario as salario_empleado,
    s.nombre as supervisor,
    s.salario as salario_supervisor,
    (e.salario - s.salario) as diferencia
FROM empleados e
JOIN empleados s ON e.id_supervisor = s.id_empleado
WHERE e.salario > s.salario;
```

---

# 19. Funciones de agregado
Las funciones de agregado se utilizan para **operar múltiples registros y retornar un valor en específico**.

<img width="388" alt="image" src="https://github.com/user-attachments/assets/cae0634a-42bd-435f-a5b2-eaab0f77ac73" />

---

# 20. `GROUP BY`

## Conceptos Fundamentales
GROUP BY agrupa filas que tienen los mismos valores en columnas especificadas y permite aplicar funciones de agregación como COUNT, SUM, AVG, MAX, MIN.

## Sintaxis Básica
```sql
SELECT columnas, funcion_agregacion(columna)
FROM tabla
WHERE condiciones
GROUP BY columnas
ORDER BY columnas;
```

## Funciones de agregación principales
- **COUNT()**: Cuenta registros
- **SUM()**: Suma valores
- **AVG()**: Promedio
- **MAX()**: Valor máximo
- **MIN()**: Valor mínimo
- **GROUP_CONCAT()**: Concatena valores del grupo

## Ejemplos básicos

### Agrupación simple
```sql
-- Número de productos por categoría
SELECT 
    categoria,
    COUNT(*) as total_productos,
    AVG(precio) as precio_promedio,
    MIN(precio) as precio_minimo,
    MAX(precio) as precio_maximo
FROM productos
GROUP BY categoria
ORDER BY total_productos DESC;

-- Ventas por mes
SELECT 
    YEAR(fecha_pedido) as año,
    MONTH(fecha_pedido) as mes,
    COUNT(*) as total_pedidos,
    SUM(total) as ingresos_totales,
    AVG(total) as ticket_promedio
FROM pedidos
GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido)
ORDER BY año DESC, mes DESC;
```

### Agrupación con JOIN
```sql
-- Resumen de compras por cliente
SELECT 
    c.nombre,
    COUNT(p.id_pedido) as total_pedidos,
    SUM(p.total) as total_gastado,
    AVG(p.total) as promedio_por_pedido,
    MAX(p.fecha_pedido) as ultima_compra
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING total_gastado > 1000
ORDER BY total_gastado DESC;

-- Productos más vendidos
SELECT 
    pr.nombre,
    pr.categoria,
    SUM(dp.cantidad) as total_vendido,
    COUNT(DISTINCT dp.id_pedido) as pedidos_diferentes,
    SUM(dp.cantidad * dp.precio_unitario) as ingresos_producto
FROM productos pr
JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE p.estado = 'COMPLETADO'
GROUP BY pr.id_producto, pr.nombre, pr.categoria
ORDER BY total_vendido DESC;
```

### Agrupación múltiple
```sql
-- Análisis de ventas por categoría y mes
SELECT 
    pr.categoria,
    YEAR(p.fecha_pedido) as año,
    MONTH(p.fecha_pedido) as mes,
    COUNT(DISTINCT p.id_pedido) as pedidos,
    SUM(dp.cantidad) as unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) as ingresos,
    COUNT(DISTINCT c.id_cliente) as clientes_unicos
FROM productos pr
JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
JOIN clientes c ON p.id_cliente = c.id_cliente
WHERE p.estado = 'COMPLETADO'
GROUP BY pr.categoria, YEAR(p.fecha_pedido), MONTH(p.fecha_pedido)
ORDER BY año DESC, mes DESC, ingresos DESC;
```

## Casos de Uso Profesionales

### Análisis de cohortes de clientes
```sql
-- Análisis de retención de clientes por mes de registro
SELECT 
    DATE_FORMAT(c.fecha_registro, '%Y-%m') as mes_registro,
    COUNT(DISTINCT c.id_cliente) as clientes_registrados,
    COUNT(DISTINCT p.id_cliente) as clientes_que_compraron,
    ROUND(COUNT(DISTINCT p.id_cliente) * 100.0 / COUNT(DISTINCT c.id_cliente), 2) as tasa_conversion
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente 
    AND p.fecha_pedido BETWEEN c.fecha_registro AND DATE_ADD(c.fecha_registro, INTERVAL 30 DAY)
GROUP BY DATE_FORMAT(c.fecha_registro, '%Y-%m')
ORDER BY mes_registro;
```

### Análisis ABC de Productos
```sql
-- Clasificación ABC de productos por ingresos
SELECT 
    pr.nombre,
    pr.categoria,
    SUM(dp.cantidad * dp.precio_unitario) as ingresos,
    SUM(SUM(dp.cantidad * dp.precio_unitario)) OVER() as ingresos_totales,
    ROUND(SUM(dp.cantidad * dp.precio_unitario) * 100.0 / 
          SUM(SUM(dp.cantidad * dp.precio_unitario)) OVER(), 2) as porcentaje_ingresos,
    CASE 
        WHEN ROUND(SUM(dp.cantidad * dp.precio_unitario) * 100.0 / 
                  SUM(SUM(dp.cantidad * dp.precio_unitario)) OVER(), 2) >= 20 THEN 'A'
        WHEN ROUND(SUM(dp.cantidad * dp.precio_unitario) * 100.0 / 
                  SUM(SUM(dp.cantidad * dp.precio_unitario)) OVER(), 2) >= 5 THEN 'B'
        ELSE 'C'
    END as clasificacion_abc
FROM productos pr
JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE p.estado = 'COMPLETADO'
GROUP BY pr.id_producto, pr.nombre, pr.categoria
ORDER BY ingresos DESC;
```

---

# 21. HAVING

## Conceptos Fundamentales
`HAVING` es similar a WHERE, pero se usa para filtrar grupos creados por GROUP BY. Mientras `WHERE` filtra filas individuales antes del agrupamiento, HAVING filtra grupos después del agrupamiento.

## Diferencias Clave: `WHERE` vs `HAVING`
- **WHERE**: Filtra filas antes de `GROUP BY`
- **HAVING**: Filtra grupos después de `GROUP BY`
- **HAVING**: Puede usar funciones de agregación
- **WHERE**: No puede usar funciones de agregación

## Sintaxis básica
```sql
SELECT columnas, funcion_agregacion(columna)
FROM tabla
WHERE condiciones_individuales
GROUP BY columnas
HAVING condiciones_de_grupo
ORDER BY columnas;
```

## Ejemplos básicos

### HAVING con Funciones de Agregación
```sql
-- Categorías con más de 5 productos
SELECT 
    categoria,
    COUNT(*) as total_productos,
    AVG(precio) as precio_promedio
FROM productos
GROUP BY categoria
HAVING COUNT(*) > 5
ORDER BY total_productos DESC;

-- Clientes con compras superiores a $2000
SELECT 
    c.nombre,
    COUNT(p.id_pedido) as total_pedidos,
    SUM(p.total) as total_gastado
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING SUM(p.total) > 2000
ORDER BY total_gastado DESC;
```

### Combinando WHERE y HAVING
```sql
-- Productos de electrónicos con ventas promedio altas
SELECT 
    pr.nombre,
    COUNT(dp.id_detalle) as veces_vendido,
    AVG(dp.cantidad * dp.precio_unitario) as venta_promedio,
    SUM(dp.cantidad) as total_unidades
FROM productos pr
JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE pr.categoria = 'Electrónicos'  -- Filtro antes del agrupamiento
  AND p.estado = 'COMPLETADO'
GROUP BY pr.id_producto, pr.nombre
HAVING AVG(dp.cantidad * dp.precio_unitario) > 100  -- Filtro después del agrupamiento
   AND COUNT(dp.id_detalle) >= 5
ORDER BY venta_promedio DESC;
```

## Ejemplos avanzados

### Análisis de tendencias
```sql
-- Meses con crecimiento de ventas superior al 10%
SELECT 
    año,
    mes,
    ingresos_mes,
    ingresos_mes_anterior,
    porcentaje_crecimiento
FROM (
    SELECT 
        YEAR(fecha_pedido) as año,
        MONTH(fecha_pedido) as mes,
        SUM(total) as ingresos_mes,
        LAG(SUM(total)) OVER (ORDER BY YEAR(fecha_pedido), MONTH(fecha_pedido)) as ingresos_mes_anterior,
        ROUND(((SUM(total) - LAG(SUM(total)) OVER (ORDER BY YEAR(fecha_pedido), MONTH(fecha_pedido))) * 100.0 / 
               LAG(SUM(total)) OVER (ORDER BY YEAR(fecha_pedido), MONTH(fecha_pedido))), 2) as porcentaje_crecimiento
    FROM pedidos
    WHERE estado = 'COMPLETADO'
    GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido)
) as ventas_mensuales
WHERE porcentaje_crecimiento > 10;
```

### Detección de outliers
```sql
-- Clientes con comportamiento de compra anómalo
SELECT 
    c.nombre,
    COUNT(p.id_pedido) as total_pedidos,
    AVG(p.total) as ticket_promedio,
    MAX(p.total) as compra_maxima,
    STDDEV(p.total) as desviacion_estandar
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.estado = 'COMPLETADO'
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(p.id_pedido) >= 3  -- Al menos 3 compras para análisis estadístico
   AND MAX(p.total) > AVG(p.total) + 2 * STDDEV(p.total)  -- Compra máxima es outlier
ORDER BY desviacion_estandar DESC;
```

## Casos de Uso Profesionales

### Segmentación de Clientes RFM (Recency, Frequency, Monetary)
```sql
-- Segmentación básica de clientes
SELECT 
    c.nombre,
    DATEDIFF(NOW(), MAX(p.fecha_pedido)) as dias_ultima_compra,
    COUNT(p.id_pedido) as frecuencia_compras,
    SUM(p.total) as valor_monetario,
    CASE 
        WHEN DATEDIFF(NOW(), MAX(p.fecha_pedido)) <= 30 
         AND COUNT(p.id_pedido) >= 10 
         AND SUM(p.total) >= 5000 THEN 'VIP'
        WHEN DATEDIFF(NOW(), MAX(p.fecha_pedido)) <= 60 
         AND COUNT(p.id_pedido) >= 5 
         AND SUM(p.total) >= 2000 THEN 'Leal'
        WHEN DATEDIFF(NOW(), MAX(p.fecha_pedido)) <= 90 THEN 'Activo'
        ELSE 'En Riesgo'
    END as segmento
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.estado = 'COMPLETADO'
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(p.id_pedido) >= 2  -- Al menos 2 compras
ORDER BY valor_monetario DESC;
```

---

# 22. WITH ROLLUP

## Conceptos Fundamentales
WITH ROLLUP es una extensión de GROUP BY que genera automáticamente subtotales y totales generales. Crea filas adicionales que muestran agregaciones en diferentes niveles de la jerarquía de agrupamiento.

## Sintaxis Básica
```sql
SELECT columnas, funcion_agregacion(columna)
FROM tabla
GROUP BY columna1, columna2, columna3 ... WITH ROLLUP;
```

## Cómo Funciona `ROLLUP`
Con *`GROUP BY col1, col2 WITH ROLLUP`* se generan estos grupos:
1. (col1, col2, col3) - Agrupación normal
2. (col1, col2, NULL) - Subtotales por los grupos `col1-col2`
3. (col1, NULL, NULL) - Subtotales por los grupos `col1`
4. (NULL, NULL, NULL) - Total general

## Ejemplo:
```sql
SELECT region, categoria, producto, SUM(cantidad)
FROM ventas_detalladas
GROUP BY region, categoria, producto WITH ROLLUP;
```

**Generaría:**
- `(region, categoria, producto)` - detalle específico.
- `(region, categoria, NULL)` - subtotal por región y categoría.
- `(region, NULL, NULL)` - subtotal por región.
- `(NULL, NULL, NULL)` - gran total.

## Ejemplos básicos

### ROLLUP Simple
```sql
-- Ventas por region y producto con subtotales
SELECT region, producto, SUM(cantidad) as total_cantidad
FROM ventas
GROUP BY region, producto WITH ROLLUP;
```

**Resultado:**
```sql
+--------+----------+----------------+
| region | producto | total_cantidad |
+--------+----------+----------------+
| Este   | Laptop   |              8 |
| Este   | NULL     |              8 |  <-- Subtotal por región Este
| Norte  | Laptop   |             10 |
| Norte  | Mouse    |             50 |
| Norte  | NULL     |             60 |  <-- Subtotal por región Norte
| Sur    | Laptop   |             15 |
| Sur    | Teclado  |             30 |
| Sur    | NULL     |             45 |  <-- Subtotal por región Sur
| NULL   | NULL     |            113 |  <-- Total general
+--------+----------+----------------+
```

### ROLLUP Múltiple
```sql
SELECT region, categoria, producto, SUM(cantidad) as total_cantidad
FROM ventas_detalladas
GROUP BY region, categoria, producto WITH ROLLUP;
```

**Resultado:**
```sql
+--------+-------------+-----------+----------------+
| region | categoria   | producto  | total_cantidad |
+--------+-------------+-----------+----------------+
| Este   | Electronica | Tablet    |             14 |  
| Este   | Electronica | NULL      |             14 |  ← Subtotal: Este + Electronica
| Este   | NULL        | NULL      |             14 |  ← Subtotal: Este (todas las categorías)
| Norte  | Electronica | Laptop    |             10 |  
| Norte  | Electronica | Mouse     |             25 | 
| Norte  | Electronica | Teclado   |             15 |  
| Norte  | Electronica | NULL      |             50 |  ← Subtotal: Norte + Electronica
| Norte  | Oficina     | Escritorio|              5 |  
| Norte  | Oficina     | Silla     |              8 | 
| Norte  | Oficina     | NULL      |             13 |  ← Subtotal: Norte + Oficina
| Norte  | NULL        | NULL      |             63 |  ← Subtotal: Norte (todas las categorías)
| Sur    | Electronica | Laptop    |             12 |  
| Sur    | Electronica | Monitor   |             18 |  
| Sur    | Electronica | NULL      |             30 |  ← Subtotal: Sur + Electronica
| Sur    | Hogar       | Lampara   |             20 |  
| Sur    | Hogar       | NULL      |             20 |  ← Subtotal: Sur + Hogar
| Sur    | NULL        | NULL      |             50 |  ← Subtotal: Sur (todas categorías)
| NULL   | NULL        | NULL      |            127 |  ← GRAN TOTAL
+--------+-------------+-----------+----------------+
```

### Explicación de los niveles de agrupación:

#### Nivel 1 - Detalle completo:
`(region, categoria, producto)` = Filas normales con datos específicos

#### Nivel 2 - Subtotal por región + categoría:
`(region, categoria, NULL)` = Total por cada combinación región-categoría

#### Nivel 3 - Subtotal por región:
`(region, NULL, NULL)` = Total por cada región

#### Nivel 4 - Gran total:
`(NULL, NULL, NULL)` = Total absoluto = 127

---

### Mejorando la Presentación con ROLLUP

#### Usando COALESCE para Etiquetas
```sql
-- Ventas por categoría y año con etiquetas mejoradas
SELECT 
    COALESCE(pr.categoria, 'TOTAL GENERAL') as categoria,
    COALESCE(YEAR(p.fecha_pedido), 'TODOS LOS AÑOS') as año,
    COUNT(DISTINCT p.id_pedido) as pedidos,
    SUM(dp.cantidad) as unidades_vendidas,
    SUM(dp.cantidad * dp.precio_unitario) as ingresos
FROM productos pr
JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE p.estado = 'COMPLETADO'
GROUP BY pr.categoria, YEAR(p.fecha_pedido) WITH ROLLUP
ORDER BY 
    CASE WHEN pr.categoria IS NULL THEN 1 ELSE 0 END,
    pr.categoria,
    CASE WHEN YEAR(p.fecha_pedido) IS NULL THEN 1 ELSE 0 END,
    YEAR(p.fecha_pedido);
```

#### Identificando Niveles de ROLLUP
```sql
-- Usando GROUPING() para identificar niveles
SELECT 
    CASE 
        WHEN GROUPING(categoria) = 1 AND GROUPING(YEAR(fecha_pedido)) = 1 THEN 'GRAN TOTAL'
        WHEN GROUPING(YEAR(fecha_pedido)) = 1 THEN CONCAT('Subtotal ', categoria)
        ELSE CONCAT(categoria, ' - ', YEAR(fecha_pedido))
    END as descripcion,
    categoria,
    YEAR(fecha_pedido) as año,
    COUNT(DISTINCT p.id_pedido) as pedidos,
    SUM(dp.cantidad * dp.precio_unitario) as ingresos
FROM productos pr
JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE p.estado = 'COMPLETADO'
GROUP BY categoria, YEAR(fecha_pedido) WITH ROLLUP;
```

### Casos de Uso Profesionales

#### Reporte Financiero con Jerarquía
```sql
-- Reporte de ingresos por región, ciudad y mes
SELECT 
    COALESCE(region, '*** TOTAL NACIONAL ***') as region,
    COALESCE(ciudad, CASE WHEN region IS NOT NULL THEN '** Total Regional **' ELSE NULL END) as ciudad,
    COALESCE(MONTH(fecha_pedido), CASE WHEN ciudad IS NOT NULL THEN 0 ELSE NULL END) as mes,
    COUNT(DISTINCT id_pedido) as pedidos,
    COUNT(DISTINCT id_cliente) as clientes_unicos,
    SUM(total) as ingresos_totales,
    AVG(total) as ticket_promedio
FROM (
    SELECT 
        p.*,
        CASE 
            WHEN c.id_cliente <= 100 THEN 'Norte'
            WHEN c.id_cliente <= 200 THEN 'Centro'
            ELSE 'Sur'
        END as region,
        CASE 
            WHEN c.id_cliente <= 50 THEN 'Ciudad A'
            WHEN c.id_cliente <= 100 THEN 'Ciudad B'
            WHEN c.id_cliente <= 150 THEN 'Ciudad C'
            WHEN c.id_cliente <= 200 THEN 'Ciudad D'
            ELSE 'Ciudad E'
        END as ciudad
    FROM pedidos p
    JOIN clientes c ON p.id_cliente = c.id_cliente
    WHERE p.estado = 'COMPLETADO'
) as datos_geograficos
GROUP BY region, ciudad, MONTH(fecha_pedido) WITH ROLLUP
ORDER BY 
    CASE WHEN region IS NULL THEN 1 ELSE 0 END,
    region,
    CASE WHEN ciudad IS NULL THEN 1 ELSE 0 END,
    ciudad,
    CASE WHEN MONTH(fecha_pedido) IS NULL THEN 13 ELSE MONTH(fecha_pedido) END;
```

#### Análisis de Inventario Multinivel
```sql
-- Análisis de inventario por categoría y subcategoría
SELECT 
    CASE 
        WHEN GROUPING(categoria) = 1 THEN '=== INVENTARIO TOTAL ==='
        WHEN GROUPING(subcategoria) = 1 THEN CONCAT('--- Subtotal ', categoria, ' ---')
        ELSE categoria
    END as categoria_display,
    CASE 
        WHEN GROUPING(subcategoria) = 0 THEN subcategoria
        ELSE NULL
    END as subcategoria_display,
    COUNT(*) as productos,
    SUM(stock) as unidades_stock,
    SUM(precio * stock) as valor_stock,
    AVG(precio) as precio_promedio,
    MIN(precio) as precio_minimo,
    MAX(precio) as precio_maximo
FROM productos
GROUP BY categoria, subcategoria WITH ROLLUP
ORDER BY 
    CASE WHEN categoria IS NULL THEN 1 ELSE 0 END,
    categoria,
    CASE WHEN subcategoria IS NULL THEN 1 ELSE 0 END,
    subcategoria;
```

---

# 23. GROUPING
`GROUPING` es una función analítica en MySQL que se utiliza principalmente con las extensiones `ROLLUP`, `CUBE` y `GROUPING SETS` de la cláusula `GROUP BY`. Su propósito principal es identificar qué filas son resultado de operaciones de agregación y cuáles contienen valores reales de agrupación.

## ¿Qué hace GROUPING?
La función GROUPING devuelve:

- `0` cuando el valor en esa columna proviene de los datos originales (agrupación real)
- `1` cuando el valor es `NULL` debido a una operación `ROLLUP`, `CUBE` o `GROUPING SETS` (agregación)

## Sintaxis básica
```sql
GROUPING(columna)
```

## Funcionamiento con ROLLUP
ROLLUP genera subtotales jerárquicos. Veamos un ejemplo práctico:
```sql
SELECT 
    region,
    categoria,
    SUM(ventas) as total_ventas,
    GROUPING(region) as grupo_region,
    GROUPING(categoria) as grupo_categoria
FROM ventas_tabla
GROUP BY region, categoria WITH ROLLUP;
```

Los resultados podrían ser:
```sql
region    | categoria | total_ventas | grupo_region | grupo_categoria
----------|-----------|--------------|--------------|----------------
Norte     | A         | 1000         | 0            | 0
Norte     | B         | 1500         | 0            | 0
Norte     | NULL      | 2500         | 0            | 1  <- Subtotal por región
Sur       | A         | 800          | 0            | 0
Sur       | B         | 1200         | 0            | 0
Sur       | NULL      | 2000         | 0            | 1  <- Subtotal por región
NULL      | NULL      | 4500         | 1            | 1  <- Total general
```

>[!IMPORTANT]
> `GROUPING` no indica **"qué estamos resumiendo"**, sino **qué columnas fueron eliminadas** del agrupamiento. En las filas de resumen se elimina la columna `categoria` por eso `GROUPING(categoria)` devuelve `1` .

---

# 24. CASE

## Conceptos Fundamentales
CASE es una expresión condicional que permite implementar lógica if-then-else en SQL. Existen dos formas: CASE simple y CASE buscado.

## CASE Simple
```sql
CASE columna
    WHEN valor1 THEN resultado1
    WHEN valor2 THEN resultado2
    ELSE resultado_default
END
```

## CASE Buscado (Más Versátil)
```sql
CASE 
    WHEN condicion1 THEN resultado1
    WHEN condicion2 THEN resultado2
    ELSE resultado_default
END
```

## Ejemplos básicos

### Clasificación de Productos por Precio
```sql
-- Clasificar productos por rango de precio
SELECT 
    nombre,
    precio,
    CASE 
        WHEN precio < 50 THEN 'Económico'
        WHEN precio BETWEEN 50 AND 200 THEN 'Medio'
        WHEN precio BETWEEN 201 AND 500 THEN 'Premium'
        ELSE 'Lujo'
    END as categoria_precio,
    stock,
    CASE 
        WHEN stock = 0 THEN 'Sin Stock'
        WHEN stock < 10 THEN 'Stock Bajo'
        WHEN stock < 50 THEN 'Stock Normal'
        ELSE 'Stock Alto'
    END as estado_stock
FROM productos
ORDER BY precio;
```

### Análisis de Clientes
```sql
-- Segmentación de clientes por comportamiento
SELECT 
    c.nombre,
    COUNT(p.id_pedido) as total_pedidos,
    COALESCE(SUM(p.total), 0) as total_gastado,
    CASE 
        WHEN COUNT(p.id_pedido) = 0 THEN 'Sin Compras'
        WHEN COUNT(p.id_pedido) = 1 THEN 'Cliente Nuevo'
        WHEN COUNT(p.id_pedido) BETWEEN 2 AND 5 THEN 'Cliente Regular'
        WHEN COUNT(p.id_pedido) BETWEEN 6 AND 15 THEN 'Cliente Frecuente'
        ELSE 'Cliente VIP'
    END as tipo_cliente,
    CASE 
        WHEN COALESCE(SUM(p.total), 0) = 0 THEN 'Sin Valor'
        WHEN COALESCE(SUM(p.total), 0) < 500 THEN 'Valor Bajo'
        WHEN COALESCE(SUM(p.total), 0) < 2000 THEN 'Valor Medio'
        WHEN COALESCE(SUM(p.total), 0) < 5000 THEN 'Valor Alto'
        ELSE 'Valor Premium'
    END as segmento_valor
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente AND p.estado = 'COMPLETADO'
GROUP BY c.id_cliente, c.nombre
ORDER BY total_gastado DESC;
```

### CASE en agregaciones

#### Conteos condicionales
```sql
-- Análisis de pedidos por estado y mes
SELECT 
    YEAR(fecha_pedido) as año,
    MONTH(fecha_pedido) as mes,
    COUNT(*) as total_pedidos,
    SUM(CASE WHEN estado = 'COMPLETADO' THEN 1 ELSE 0 END) as completados,
    SUM(CASE WHEN estado = 'PENDIENTE' THEN 1 ELSE 0 END) as pendientes,
    SUM(CASE WHEN estado = 'CANCELADO' THEN 1 ELSE 0 END) as cancelados,
    SUM(CASE WHEN estado = 'COMPLETADO' THEN total ELSE 0 END) as ingresos_completados,
    ROUND(
        SUM(CASE WHEN estado = 'COMPLETADO' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) as porcentaje_completados
FROM pedidos
GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido)
ORDER BY año DESC, mes DESC;
```

#### Análisis de Ventas por Temporada
```sql
-- Ventas por temporadas del año
SELECT 
    pr.categoria,
    SUM(CASE WHEN MONTH(p.fecha_pedido) IN (12,1,2) THEN dp.cantidad ELSE 0 END) as ventas_invierno,
    SUM(CASE WHEN MONTH(p.fecha_pedido) IN (3,4,5) THEN dp.cantidad ELSE 0 END) as ventas_primavera,
    SUM(CASE WHEN MONTH(p.fecha_pedido) IN (6,7,8) THEN dp.cantidad ELSE 0 END) as ventas_verano,
    SUM(CASE WHEN MONTH(p.fecha_pedido) IN (9,10,11) THEN dp.cantidad ELSE 0 END) as ventas_otoño,
    SUM(dp.cantidad) as ventas_totales
FROM productos pr
JOIN detalle_pedidos dp ON pr.id_producto = dp.id_producto
JOIN pedidos p ON dp.id_pedido = p.id_pedido
WHERE p.estado = 'COMPLETADO'
GROUP BY pr.categoria
ORDER BY ventas_totales DESC;
```

### CASE anidado y complejo

#### Sistema de descuentos dinámico
```sql
-- Calcular descuentos basados en múltiples criterios
SELECT 
    c.nombre as cliente,
    p.id_pedido,
    p.total as total_original,
    CASE 
        WHEN cliente_info.tipo_cliente = 'VIP' AND p.total > 1000 THEN
            CASE 
                WHEN MONTH(p.fecha_pedido) IN (11,12) THEN p.total * 0.25  -- 25% en temporada alta
                ELSE p.total * 0.20  -- 20% regular VIP
            END
        WHEN cliente_info.tipo_cliente = 'Frecuente' AND p.total > 500 THEN
            CASE 
                WHEN MONTH(p.fecha_pedido) IN (11,12) THEN p.total * 0.15  -- 15% temporada alta
                ELSE p.total * 0.10  -- 10% regular frecuente
            END
        WHEN p.total > 200 THEN p.total * 0.05  -- 5% compras grandes
        ELSE 0
    END as descuento,
    p.total - CASE 
        WHEN cliente_info.tipo_cliente = 'VIP' AND p.total > 1000 THEN
            CASE 
                WHEN MONTH(p.fecha_pedido) IN (11,12) THEN p.total * 0.25
                ELSE p.total * 0.20
            END
        WHEN cliente_info.tipo_cliente = 'Frecuente' AND p.total > 500 THEN
            CASE 
                WHEN MONTH(p.fecha_pedido) IN (11,12) THEN p.total * 0.15
                ELSE p.total * 0.10
            END
        WHEN p.total > 200 THEN p.total * 0.05
        ELSE 0
    END as total_final
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN (
    SELECT 
        c.id_cliente,
        CASE 
            WHEN COUNT(p.id_pedido) >= 15 THEN 'VIP'
            WHEN COUNT(p.id_pedido) >= 6 THEN 'Frecuente'
            ELSE 'Regular'
        END as tipo_cliente
    FROM clientes c
    LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente AND p.estado = 'COMPLETADO'
    GROUP BY c.id_cliente
) as cliente_info ON c.id_cliente = cliente_info.id_cliente
WHERE p.estado = 'COMPLETADO'
ORDER BY descuento DESC;
```

### CASE en ORDER BY

#### Ordenamiento Personalizado
```sql
-- Ordenar pedidos por prioridad personalizada
SELECT 
    id_pedido,
    fecha_pedido,
    total,
    estado,
    CASE estado
        WHEN 'URGENTE' THEN 1
        WHEN 'PROCESANDO' THEN 2
        WHEN 'PENDIENTE' THEN 3
        WHEN 'COMPLETADO' THEN 4
        WHEN 'CANCELADO' THEN 5
    END as prioridad
FROM pedidos
ORDER BY 
    CASE estado
        WHEN 'URGENTE' THEN 1
        WHEN 'PROCESANDO' THEN 2
        WHEN 'PENDIENTE' THEN 3
        WHEN 'COMPLETADO' THEN 4
        WHEN 'CANCELADO' THEN 5
    END,
    fecha_pedido DESC;
```

---

# 25. Expresiones Comunes de Tablas
Las expresiones comunes de tabla (CTE - Common Table Expressions) en MySQL son una característica poderosa que permite crear conjuntos de resultados temporales y nombrados que pueden ser referenciados dentro de una consulta SELECT, INSERT, UPDATE o DELETE.

## Sintaxis Básica
```sql
WITH nombre_cte [(columna1, columna2, ...)] AS (
    -- Consulta que define el CTE
    SELECT ...
)
-- Consulta principal que usa el CTE
SELECT ... FROM nombre_cte;
```

## Características Principales

>[!IMPORTANT]
> - **Visibilidad y Alcance**: Los CTE **solo existen durante la ejecución de la consulta que los define**. No se almacenan permanentemente como las tablas o vistas.
> - **Alternativa a subconsultas**: A menudo son más claros que subconsultas anidadas complejas.

- **Reutilización**: Un CTE puede ser referenciado múltiples veces en la consulta principal, lo que evita duplicar código complejo.
- **Nomenclatura**: Puedes especificar nombres de columnas explícitamente o dejar que MySQL use los nombres de las columnas del SELECT interno.

## Tipos de CTE

### CTE No Recursivos
Son los más comunes y funcionan como subconsultas nombradas:
```sql
WITH ventas_por_region AS (
    SELECT region, SUM(monto) as total_ventas
    FROM ventas
    WHERE fecha >= '2024-01-01'
    GROUP BY region
)
SELECT region, total_ventas,
       total_ventas / (SELECT SUM(total_ventas) FROM ventas_por_region) * 100 as porcentaje
FROM ventas_por_region
ORDER BY total_ventas DESC;
```

### CTE Recursivos
Utilizan la palabra clave RECURSIVE y pueden hacer referencia a sí mismos:
```sql
WITH RECURSIVE jerarquia_empleados AS (
    -- Caso base: empleados sin jefe
    SELECT id, nombre, jefe_id, 0 as nivel
    FROM empleados
    WHERE jefe_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo: empleados con jefe
    SELECT e.id, e.nombre, e.jefe_id, j.nivel + 1
    FROM empleados e
    JOIN jerarquia_empleados j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia_empleados;
```

### CTE Múltiples
Puedes definir varios CTE en una sola consulta:
```sql
WITH 
ventas_2024 AS (
    SELECT producto_id, SUM(cantidad) as total_vendido
    FROM ventas
    WHERE YEAR(fecha) = 2024
    GROUP BY producto_id
),
productos_top AS (
    SELECT producto_id
    FROM ventas_2024
    WHERE total_vendido > 100
)
SELECT p.nombre, v.total_vendido
FROM productos p
JOIN productos_top pt ON p.id = pt.producto_id
JOIN ventas_2024 v ON p.id = v.producto_id;
```

## Limitaciones Importantes
Los CTE en MySQL tienen algunas restricriciones que debes conocer:

- No se pueden indexar (a diferencia de las tablas temporales).
- No soportan parámetros como los procedimientos almacenados.
- Los CTE recursivos tienen límites de profundidad (controlado por **cte_max_recursion_depth**).
- No pueden contener ciertas cláusulas como **ORDER BY** en el nivel superior del CTE recursivo.

---

# 26. UNION ALL y UNION
`UNION ALL` es un operador SQL que combina los resultados de dos o más consultas SELECT en un solo conjunto de resultados.

## Funcionalidad Básica
Toma todas las filas de múltiples consultas SELECT y las apila una encima de la otra, creando un conjunto de resultados unificado.
```sql
SELECT columna1, columna2 FROM tabla1
UNION ALL
SELECT columna1, columna2 FROM tabla2;
```

## Diferencia con `UNION`
La diferencia clave entre `UNION` y `UNION ALL`:

- **`UNION`**: Elimina filas duplicadas del resultado final.
- **`UNION`** ALL: Mantiene todas las filas, incluyendo duplicados.

```sql
-- Con UNION (elimina duplicados)
SELECT nombre FROM empleados_madrid
UNION
SELECT nombre FROM empleados_barcelona;

-- Con UNION ALL (mantiene duplicados)
SELECT nombre FROM empleados_madrid
UNION ALL
SELECT nombre FROM empleados_barcelona;
```
Si hay un empleado llamado "Juan" en ambas ciudades, UNION mostraría "Juan" una sola vez, mientras que UNION ALL lo mostraría dos veces.

## Reglas Importantes

### 1. Compatibilidad de Columnas
Las consultas deben tener:

- Mismo número de columnas.
- Tipos de datos compatibles en cada posición correspondiente.
```sql
-- ✅ Correcto
SELECT id, nombre, salario FROM empleados
UNION ALL
SELECT codigo, apellido, sueldo FROM contratistas;

-- ❌ Incorrecto - diferente número de columnas
SELECT id, nombre FROM empleados
UNION ALL
SELECT codigo, apellido, salario FROM contratistas;
```

### 2. Nombres de Columnas
Los nombres de las columnas finales se toman de la primera consulta SELECT:
```sql
SELECT nombre as empleado, salario as sueldo FROM empleados
UNION ALL
SELECT apellido, ingreso FROM freelancers;
-- Las columnas del resultado se llamarán "empleado" y "sueldo"
```
## Casos de Uso Comunes

### 1. Combinar Datos de Tablas Similares
```sql
SELECT 'Ventas' as tipo, fecha, monto FROM ventas
UNION ALL
SELECT 'Devoluciones' as tipo, fecha, -monto FROM devoluciones
ORDER BY fecha;
```

### 2. Crear Reportes Consolidados
```sql
SELECT region, 'Q1' as trimestre, SUM(ventas) as total
FROM ventas_q1 GROUP BY region
UNION ALL
SELECT region, 'Q2' as trimestre, SUM(ventas) as total
FROM ventas_q2 GROUP BY region
UNION ALL
SELECT region, 'Q3' as trimestre, SUM(ventas) as total
FROM ventas_q3 GROUP BY region;
```

>[!IMPORTANT]
>UNION ALL es más rápido que `UNION` porque:
>
> - No necesita identificar duplicados.
> - No requiere ordenamiento interno para comparar filas.
> - Procesa los datos de forma más directa.

## Limitaciones

- No puedes usar `ORDER BY` en las consultas individuales del `UNION ALL`, solo al final.
- El `LIMIT` en consultas individuales puede comportarse de manera inesperada.
- Las funciones de ventana se evalúan después del `UNION ALL`.

`UNION ALL` es especialmente útil cuando necesitas combinar datos de múltiples fuentes manteniendo todos los registros, o cuando estás seguro de que no hay duplicados y quieres el mejor rendimiento posible.

---

# 27. OVER (Funciones de Ventana)

## Conceptos fundamentales
Las **funciones de ventana** (window functions) son una característica avanzada de SQL que permite realizar cálculos sobre un conjunto de filas relacionadas con la fila actual, sin colapsar el resultado como lo haría `GROUP BY`.

## Tipos de funciones de ventana

### 1. Funciones de Agregación
- SUM(), AVG(), COUNT(), MIN(), MAX()

### 2. Funciones de Ranking
- ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()

### 3. Funciones de Valor
- FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()
- LAG(), LEAD()

## ¿Qué es `OVER`?
`OVER` es parte fundamental de las funciones ventana, define una "ventana" de filas sobre las cuales se aplica una función. A diferencia de `GROUP BY` que colapsa filas en grupos, las funciones de ventana mantienen todas las filas mientras realizan cálculos sobre un conjunto específico de filas relacionadas.

## Sintaxis Básica
```sql
funcion_ventana() OVER (
    [PARTITION BY columna(s)]
    [ORDER BY columna(s)]
    [ROWS/RANGE BETWEEN ... AND ...]
)
```

## Componentes de OVER

### 1. `PARTITION BY` y `ORDER BY`
Divide el conjunto de resultados en particiones. La función de ventana se aplica a cada partición. Es similar a `GROUP BY`, pero sin colapsar las filas.

### Datos de ejemplo en la tabla `empleados`:

| id | empleado | departamento | salario |
|----|----------|--------------|---------|
| 1  | Juan     | Ventas       | 45000   |
| 2  | María    | Ventas       | 52000   |
| 3  | Carlos   | Ventas       | 38000   |
| 4  | Ana      | IT           | 65000   |
| 5  | Pedro    | IT           | 58000   |
| 6  | Laura    | IT           | 72000   |
| 7  | Sofia    | RRHH         | 48000   |
| 8  | Miguel   | RRHH         | 42000   |
| 9  | Elena    | RRHH         | 55000   |

### Consulta ejecutada:
```sql
SELECT 
    empleado,
    departamento,
    salario,
    ROW_NUMBER() OVER (PARTITION BY departamento ORDER BY salario DESC) as ranking
FROM empleados;
```

### Ordenamiento interno con `OVER`:

>[!NOTE]
> Aquí se muestra cómo se ordenan internamente o en **"segundo plano"** las filas con las sentencias `PARTITION BY` y `ORDER BY` dentro de `OVER` para finalmente asignar los valores del campo  `ranking`. Este no es el orden real del resultado final.

Cada departamento tiene su propio ranking independiente, donde el empleado con mayor salario obtiene el ranking 1.

| id | empleado | departamento | salario | ranking |
|----|----------|--------------|---------|---------|
| 6  | Laura    | IT           | 72000   | 1       |
| 4  | Ana      | IT           | 65000   | 2       |
| 5  | Pedro    | IT           | 58000   | 3       |
| 9  | Elena    | RRHH         | 55000   | 1       |
| 7  | Sofia    | RRHH         | 48000   | 2       |
| 8  | Miguel   | RRHH         | 42000   | 3       |
| 2  | María    | Ventas       | 52000   | 1       |
| 1  | Juan     | Ventas       | 45000   | 2       |
| 3  | Carlos   | Ventas       | 38000   | 3       |

### Resultado REAL de la consulta:

| id | empleado | departamento | salario | ranking |
|----|----------|--------------|---------|---------|
| 1  | Juan     | Ventas       | 45000   | 2       |
| 2  | María    | Ventas       | 52000   | 1       |
| 3  | Carlos   | Ventas       | 38000   | 3       |
| 4  | Ana      | IT           | 65000   | 2       |
| 5  | Pedro    | IT           | 58000   | 3       |
| 6  | Laura    | IT           | 72000   | 1       |
| 7  | Sofia    | RRHH         | 48000   | 2       |
| 8  | Miguel   | RRHH         | 42000   | 3       |
| 9  | Elena    | RRHH         | 55000   | 1       |

>[!IMPORTANT]
> - Las cláusulas `PARTITION BY` y `ORDER BY` dentro de `OVER` **NO afectan** el orden en que se muestran los datos en el resultado final.
> - Para ordenar las filas es necesario `ORDER BY` al final de toda la consulta.

### ¿Qué hace `PARTITION BY`?
`PARTITION BY` **solamente define grupos internos** para el cálculo de la función de ventana:

1. Crea particiones lógicas temporales.
2. Aplica la función dentro de cada partición.
3. Asigna el resultado a cada fila de la partición.
4. NO reordena las filas.

### ¿Qué hace `ORDER BY`?
1. Ordena las filas **solo dentro de cada grupo/partición** creadas por `PARTITION BY`, es decir, cada grupo se ordena por separado, no a todas las filas de la tabla.
2. Cuando se usa sin `PARTITION BY` se ordenan todas las filas.

### Resumen:

- `PARTITION BY`: Solo agrupa internamente, NO ordena el resultado.
- `ORDER BY` dentro de OVER: ordena las filas **solo dentro de cada grupo/partición**, no a todas las filas de la tabla.
- `ORDER BY` al final de una consulta: Es lo único que determina el orden del resultado mostrado.
- `RANK()`: asigna rankings independientes para cada partición.

>[!IMPORTANT]
> Todas las cláusulas dentro de `OVER`, ese decir, `PARTITION BY` y `ORDER BY` son para hacer cálculos en "segundo plano" sin alterar el orden de presentación de los datos.

## Ejemplo únicamente con `ORDER BY` en `OVER`

### Consulta:
```sql
SELECT 
    nombre,
    salario,
    ROW_NUMBER() OVER (ORDER BY salario DESC) as posicion
FROM empleados;
```

### Datos de ejemplo en la tabla `empleados`:

| id | nombre          | salario |
|----|-----------------|---------|
| 1  | Ana García      | 75000   |
| 2  | Carlos López    | 65000   |
| 3  | María Rodríguez | 80000   |
| 4  | Juan Pérez      | 70000   |
| 5  | Laura Martín    | 90000   |
| 6  | Pedro Sánchez   | 65000   |

### Ordenamiento interno con `OVER`:

| id | nombre           | salario | posicion |
|----|------------------|---------|----------|
| 5  | Laura Martín     | 90000   | 1        |
| 3  | María Rodríguez  | 80000   | 2        |
| 1  | Ana García       | 75000   | 3        |
| 4  | Juan Pérez       | 70000   | 4        |
| 2  | Carlos López     | 65000   | 5        |
| 6  | Pedro Sánchez    | 65000   | 6        |

### Resultado real (orden original de la tabla):

| id | nombre          | salario | posicion |
|----|-----------------|---------|----------|
| 1  | Ana García      | 75000   | 3        |
| 2  | Carlos López    | 65000   | 5        |
| 3  | María Rodríguez | 80000   | 2        |
| 4  | Juan Pérez      | 70000   | 4        |
| 5  | Laura Martín    | 90000   | 1        |
| 6  | Pedro Sánchez   | 65000   | 6        |

### Para ordenar el resultado final necesitarías:
```sql
SELECT 
    nombre,
    salario,
    ROW_NUMBER() OVER (ORDER BY salario DESC) as posicion
FROM empleados
ORDER BY salario DESC;  -- Esto SÍ ordena el resultado final
```

---

# 28. Vistas
Las vistas en MySQL son objetos de base de datos que funcionan como "tablas virtuales" basadas en el resultado de una consulta SQL. No almacenan datos físicamente, sino que representan una consulta almacenada que se ejecuta cada vez que se referencia la vista.

## ¿Qué es una vista?
Una vista es esencialmente una consulta `SELECT` guardada con un nombre específico. Cuando consultas una vista, MySQL ejecuta automáticamente la consulta subyacente y devuelve los resultados como si fuera una tabla real.

## Creación de vistas
La sintaxis básica para crear una vista es:
```sql
CREATE VIEW nombre_vista AS
SELECT columna1, columna2, ...
FROM tabla
WHERE condición;
```

## Ejemplo práctico:
```sql
-- Supongamos que tenemos una tabla empleados
CREATE VIEW empleados_activos AS
SELECT id, nombre, apellido, salario, departamento
FROM empleados
WHERE estado = 'activo' AND fecha_contratacion >= '2020-01-01';
```

## Tipos de vistas

### 1. Vistas simples
Basadas en una sola tabla, generalmente permiten operaciones DML (`INSERT`, `UPDATE`, `DELETE`).
```sql
CREATE VIEW empleados_ventas AS
SELECT id, nombre, salario
FROM empleados
WHERE departamento = 'Ventas';
```

### 2. Vistas complejas
Involucran múltiples tablas, funciones agregadas, `GROUP BY`, etc. Generalmente son de solo lectura.
```sql
CREATE VIEW resumen_departamentos AS
SELECT d.nombre as departamento, 
       COUNT(e.id) as total_empleados,
       AVG(e.salario) as salario_promedio
FROM departamentos d
LEFT JOIN empleados e ON d.id = e.departamento_id
GROUP BY d.id, d.nombre;
```

## Operaciones con vistas

### Consultar una vista
```sql
SELECT * FROM empleados_activos;
SELECT nombre, salario FROM empleados_activos WHERE salario > 50000;
```

### Modificar una vista
```sql
ALTER VIEW empleados_activos AS
SELECT id, nombre, apellido, salario, departamento, fecha_contratacion
FROM empleados
WHERE estado = 'activo';
```

### Eliminar una vista
```sql
DROP VIEW empleados_activos;
```

## Vistas actualizables
Una vista es actualizable si cumple ciertas condiciones:

- Basada en una sola tabla.
- No contiene funciones agregadas (`SUM`, `COUNT`, etc.).
- No usa `DISTINCT`,` GROUP BY`, `HAVING`.
- No contiene subconsultas en `SELECT`.

```sql
-- Vista actualizable
CREATE VIEW empleados_it AS
SELECT id, nombre, salario
FROM empleados
WHERE departamento = 'IT';

-- Puedes hacer:
UPDATE empleados_it SET salario = 60000 WHERE id = 1;
INSERT INTO empleados_it (nombre, salario) VALUES ('Juan Pérez', 55000);
```

## `ALGORITHM`
Este parámetro controla cómo MySQL procesa internamente la vista cuando es consultada.

### Sintaxis:
```sql
CREATE ALGORITHM = {MERGE | TEMPTABLE | UNDEFINED} VIEW nombre_vista AS
SELECT ...
```

### 1. `ALGORITHM = MERGE`
MySQL combina la definición de la vista directamente con la consulta que la referencia, creando una sola consulta optimizada.

```sql
-- Crear vista con MERGE
CREATE ALGORITHM = MERGE VIEW empleados_activos AS
SELECT id, nombre, salario, departamento
FROM empleados
WHERE estado = 'activo';

-- Cuando ejecutas:
SELECT nombre, salario FROM empleados_activos WHERE salario > 50000;

-- MySQL internamente lo convierte en:
SELECT nombre, salario 
FROM empleados 
WHERE estado = 'activo' AND salario > 50000;
```

#### Ventajas de `MERGE`:

- Mejor rendimiento porque evita crear tablas temporales.
- Permite usar índices de las tablas base eficientemente.
- Consume menos memoria.

#### Cuándo usar `MERGE`:

- Vistas simples basadas en una tabla.
- Consultas que no usan funciones agregadas complejas.
- Cuando necesitas máximo rendimiento.

### 2. `ALGORITHM = TEMPTABLE`
MySQL ejecuta primero la vista, almacena los resultados en una tabla temporal, y luego ejecuta la consulta externa sobre esa tabla temporal. 

La necesidad de crear tablas temporales surge de limitaciones fundamentales en el orden de cómo SQL procesa las consultas y las reglas del lenguaje SQL estándar.

Cuando tienes una vista con agregaciones (`COUNT`, `SUM`, `AVG`, etc.) o ciertas operaciones complejas, MySQL no puede simplemente "fusionar" la consulta externa con la vista como en `MERGE` porque violaría las reglas sintácticas de SQL.

>[!NOTE]
> SQL tiene un orden de ejecución estricto:
>
> `FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT`

```sql
-- Vista que requiere TEMPTABLE
CREATE ALGORITHM = TEMPTABLE VIEW resumen_ventas AS
SELECT departamento, 
       COUNT(*) as total_empleados,
       AVG(salario) as salario_promedio,
       MAX(salario) as salario_maximo
FROM empleados
GROUP BY departamento;

-- Cuando consultas esta vista:
SELECT * FROM resumen_ventas WHERE total_empleados > 5;
```

Con `ALGORITHM = TEMPTABLE`, la tabla temporal **se crea cada vez que se ejecuta la vista** y **se elimina inmediatamente después de completar la consulta**. No persiste durante la sesión como las tablas temporales comunes.

#### Cuándo MySQL fuerza `TEMPTABLE`:

- Vistas con funciones agregadas (`COUNT`, `SUM`, `AVG`, etc.).
- Uso de `GROUP BY`, `HAVING`.
- Uso de `DISTINCT`.
- Subconsultas correlacionadas.
- Funciones de ventana (window functions).

#### Desventajas de TEMPTABLE:

- Mayor uso de memoria y E/O de disco.
- No puede ser actualizable.
- Rendimiento potencialmente menor.

>[!IMPORTANT]
> En resumen, la tabla temporal es un mecanismo necesario para mantener la sintaxis y semántica correcta de SQL cuando las operaciones de la vista no se pueden fusionar directamente con consultas externas.


### 3. ALGORITHM = UNDEFINED (Predeterminado)
MySQL decide automáticamente entre MERGE y TEMPTABLE basándose en la complejidad de la vista.

```sql
-- MySQL decide automáticamente
CREATE VIEW empleados_departamento AS
SELECT e.nombre, e.salario, d.nombre_departamento
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id;
```

## `DEFINER`
Especifica qué usuario se considera el "propietario" de la vista para propósitos de permisos y seguridad.

### Sintaxis:
```sql
CREATE DEFINER = usuario@host VIEW nombre_vista AS
SELECT ...
```

### Comportamiento predeterminado:
```sql
-- Sin especificar DEFINER (usa el usuario actual)
CREATE VIEW empleados_publicos AS
SELECT nombre, apellido, departamento FROM empleados;

-- Equivale a:
CREATE DEFINER = CURRENT_USER VIEW empleados_publicos AS
SELECT nombre, apellido, departamento FROM empleados;
```

### Especificar un DEFINER diferente:
```sql
-- Solo usuarios con privilegios SUPER pueden hacer esto
CREATE DEFINER = admin@localhost VIEW datos_sensibles AS
SELECT id, nombre, salario FROM empleados WHERE nivel_acceso >= 3;
```

### Opciones de `DEFINER`:

```sql
-- Usuario específico
CREATE DEFINER = juan@'192.168.1.%' VIEW mi_vista AS SELECT ...;

-- Usuario actual
CREATE DEFINER = CURRENT_USER VIEW mi_vista AS SELECT ...;

-- Usuario que invoca la vista
CREATE DEFINER = INVOKER VIEW mi_vista AS SELECT ...;
```

## `SQL SECURITY`
Controla con qué privilegios se ejecuta la vista cuando es accedida.

### Sintaxis:

```sql
CREATE SQL SECURITY {DEFINER | INVOKER} VIEW nombre_vista AS
SELECT ...
```

**Hay dos opciones:**

- `SQL SECURITY DEFINER` (predeterminado): Se ejecuta con los permisos del creador de la vista.
- `SQL SECURITY INVOKER`: Se ejecuta con los permisos del usuario que consulta la vista.

### Ejemplos prácticos paso a paso:

### Configuración inicial:

```sql
-- Tabla con información sensible (solo admin puede acceder)
CREATE TABLE empleados_completos (
    id INT,
    nombre VARCHAR(100),
    salario DECIMAL(10,2),
    numero_seguro_social VARCHAR(11),
    evaluacion_confidencial TEXT
);

-- Solo el admin tiene permisos
GRANT ALL ON empleados_completos TO admin@localhost;

-- Usuario regular SIN permisos directos
CREATE USER juan@localhost IDENTIFIED BY 'password';
-- juan NO tiene acceso a empleados_completos
````

### Ejemplo 1: `SQL SECURITY DEFINER` (Predeterminado)
La vista se ejecuta con los privilegios del usuario definido en `DEFINER`.

```sql
-- Admin crea una vista "filtrada"
CREATE DEFINER = admin@localhost
SQL SECURITY DEFINER VIEW empleados_publicos AS
SELECT id, nombre  -- Solo campos no sensibles
FROM empleados_completos
WHERE departamento = 'Marketing';

-- Dar acceso a la vista (no a la tabla)
GRANT SELECT ON empleados_publicos TO juan@localhost;
```

#### ¿Qué pasa cuando juan consulta la vista?
```sql
-- Juan ejecuta:
SELECT * FROM empleados_publicos;
```

**Proceso interno:**
1. Juan solicita datos de la vista `empleados_publicos`.
2. MySQL ve que es `SQL SECURITY DEFINER`.
3. MySQL ejecuta la consulta usando los permisos de `admin@localhost`.
4. Admin SÍ tiene acceso a `empleados_completos`.
5. La vista se ejecuta exitosamente.
6. Juan ve solo los datos filtrados en la vista (id, nombre)

Resultado: ✅ Juan puede ver los datos, aunque **NO** tiene permisos directos sobre la tabla `empleados_completos`.

### Ejemplo 2: `SQL SECURITY INVOKER`
La vista se ejecuta con los privilegios del usuario que la está consultando.

```sql
-- Admin crea vista con INVOKER
CREATE DEFINER = admin@localhost
SQL SECURITY INVOKER VIEW empleados_invoker AS
SELECT id, nombre
FROM empleados_completos
WHERE departamento = 'Marketing';

GRANT SELECT ON empleados_invoker TO juan@localhost; 
```

#### ¿Qué pasa cuando juan consulta esta vista?
```sql
-- Juan ejecuta:
SELECT * FROM empleados_invoker;
```

**Proceso interno:**
1. Juan solicita datos de la vista `empleados_invoker`.
2. MySQL ve que es `SQL SECURITY INVOKER`.
3. MySQL ejecuta la consulta usando los permisos de `juan@localhost`.
4. Juan **NO** tiene acceso a `empleados_completos`.
5. **ERROR**: Access denied for user 'juan'@'localhost' to table 'empleados_completos'

Resultado: ❌ Juan `NO` puede ver los datos porque no tiene permisos sobre la tabla `empleados_completos`.

---

# 29. Procedimientos almacenados

## ¿Qué son los procedimientos almacenados?
Un procedimiento almacenado es un conjunto de declaraciones SQL que se compilan y almacenan en el servidor de base de datos. Una vez creado, puede ser invocado por su nombre, lo que permite reutilizar el código y ejecutar operaciones complejas con una sola llamada.

## Ventajas principales
- `Rendimiento mejorado`: Los procedimientos se compilan una vez y se almacenan en forma ejecutable, lo que reduce el tiempo de procesamiento en ejecuciones posteriores.
- `Seguridad`: Permiten controlar el acceso a los datos mediante la concesión de permisos específicos para ejecutar el procedimiento sin dar acceso directo a las tablas.
- `Reducción del tráfico de red`: En lugar de enviar múltiples consultas SQL, se envía una sola llamada al procedimiento.
- `Mantenimiento centralizado`: Los cambios en la lógica de negocio se pueden realizar en un solo lugar.

## Sintaxis básica

```sql
DELIMITER //
CREATE DEFINER = 'usuario@host' PROCEDURE nombre_procedimiento (
    [IN | OUT | INOUT] parametro1 tipo_dato,
    [IN | OUT | INOUT] parametro2 tipo_dato
)
SQL SECURITY { DEFINER | INVOKER }
BEGIN
    -- Cuerpo del procedimiento
    -- Declaraciones SQL
END //
DELIMITER ;
```

## Tipos de parámetros

- `IN`: Parámetros de entrada (valor por defecto).
- `OUT`: Parámetros de salida.
- `INOUT`: Parámetros que pueden ser tanto de entrada como de salida.

## Ejemplo:

```sql
DELIMITER //
CREATE PROCEDURE ObtenerEmpleadosPorDepartamento(
    IN dept_id INT,
    OUT total_empleados INT
)
BEGIN
    SELECT COUNT(*) INTO total_empleados
    FROM empleados
    WHERE departamento_id = dept_id;
    
    SELECT nombre, apellido, salario
    FROM empleados
    WHERE departamento_id = dept_id;
END //
DELIMITER ;
```

## Ejecución de procedimientos
Para ejecutar un procedimiento almacenado:

```sql
CALL ObtenerEmpleadosPorDepartamento(5, @total);
SELECT @total;
```

## Parámetros `INOUT`
Los parámetros `INOUT` permiten que una variable funcione tanto como entrada (`IN`) como salida (`OUT`) en el mismo procedimiento.

### Características de `INOUT`

- `Bidireccional`: Puede recibir un valor inicial y devolver un valor modificado.
- `Eficiencia`: Evita la necesidad de declarar parámetros separados `IN` y `OUT`.
- `Flexibilidad`: Permite operaciones complejas sobre el mismo valor.

### Ejemplo básico de `INOUT`

```sql
DELIMITER //
CREATE PROCEDURE CalcularBonificacion(
    INOUT salario DECIMAL(10,2),
    IN porcentaje DECIMAL(5,2)
)
BEGIN
    -- El salario entra como valor inicial
    -- y sale modificado con la bonificación
    SET salario = salario + (salario * porcentaje / 100);
END //
DELIMITER ;
```

 Uso del ejemplo anterior:

```sql
-- Establecer el salario inicial
SET @salario_empleado = 5000.00;

-- Ejecutar el procedimiento
CALL CalcularBonificacion(@salario_empleado, 15.0);

-- Ver el resultado modificado
SELECT @salario_empleado; -- Resultado: 5750.00
```

### Ejemplo más complejo con `INOUT`

```sql
DELIMITER //
CREATE PROCEDURE ProcesarInventario(
    INOUT cantidad_producto INT,
    IN operacion VARCHAR(10),
    IN ajuste INT,
    OUT mensaje VARCHAR(100)
)
BEGIN
    DECLARE cantidad_original INT;
    
    -- Guardar la cantidad original
    SET cantidad_original = cantidad_producto;
    
    -- Procesar según la operación
    IF operacion = 'AGREGAR' THEN
        SET cantidad_producto = cantidad_producto + ajuste;
        SET mensaje = CONCAT('Agregado: ', ajuste, ' unidades');
        
    ELSEIF operacion = 'RETIRAR' THEN
        IF cantidad_producto >= ajuste THEN
            SET cantidad_producto = cantidad_producto - ajuste;
            SET mensaje = CONCAT('Retirado: ', ajuste, ' unidades');
        ELSE
            SET mensaje = 'Stock insuficiente';
            SET cantidad_producto = cantidad_original; -- Revertir
        END IF;
        
    ELSE
        SET mensaje = 'Operación no válida';
        SET cantidad_producto = cantidad_original; -- Revertir
    END IF;
    
END //
DELIMITER ;
```

Uso del ejemplo complejo:

```sql
-- Establecer inventario inicial
SET @stock_actual = 100;

-- Procesar una operación
CALL ProcesarInventario(@stock_actual, 'RETIRAR', 25, @resultado);

-- Ver los resultados
SELECT @stock_actual AS 'Stock Final', @resultado AS 'Mensaje';
-- Resultado: Stock Final: 75, Mensaje: 'Retirado: 25 unidades'
```

>[!IMPORTANT]
> - **Inicialización**: Los parámetros `INOUT` deben tener un valor inicial antes de llamar al procedimiento.
> - **Tipo de datos**: El tipo debe ser compatible tanto para entrada como para salida.
> - **Variables de sesión**: Se suelen usar variables de sesión (`@variable`) para pasar valores `INOUT`.

## `DEFINER`
El parámetro `DEFINER` especifica qué usuario se considera el "propietario" o "definidor" del procedimiento almacenado. Este concepto es crucial para el control de acceso y la seguridad.

### Sintaxis

```sql
CREATE DEFINER = 'usuario'@'host' PROCEDURE nombre_procedimiento()
BEGIN
    -- código del procedimiento
END;
```

## `SQL SECURITY`
Cuando se ejecuta un procedimiento almacenado, MySQL determina qué permisos usar basándose en la característica `SQL SECURITY`:

`SQL SECURITY DEFINER` (por defecto):

- El procedimiento se ejecuta con los privilegios del usuario especificado en `DEFINER`.
- Es el comportamiento por defecto.
- Permite que usuarios con permisos limitados ejecuten operaciones que requieren más privilegios.

`SQL SECURITY INVOKER`:

- El procedimiento se ejecuta con los privilegios del usuario que lo invoca.
- Más restrictivo pero más seguro en ciertos contextos.

## Ejemplo de `DEFINER` y `SQL SECURITY`

```sql
-- Crear un procedimiento con DEFINER específico
DELIMITER //
CREATE DEFINER = 'admin'@'localhost' PROCEDURE ConsultarSalarios()
SQL SECURITY DEFINER
BEGIN
    SELECT empleado_id, nombre, salario 
    FROM empleados_confidenciales;
END //
DELIMITER ;

-- Un usuario con permisos limitados puede ejecutar este procedimiento
-- y acceder a datos que normalmente no podría ver
CALL ConsultarSalarios();
```

En este ejemplo, aunque el usuario actual no tenga permisos para leer la tabla `empleados_confidenciales`, puede ejecutar el procedimiento porque se ejecuta con los privilegios del usuario 'admin'.

## Características adicionales
Los procedimientos almacenados en MySQL pueden incluir estructuras de control como `IF-ELSE`, `WHILE`, `FOR`, `CASE`, manejo de excepciones con `DECLARE HANDLER`, y declaración de variables locales con `DECLARE`.

También pueden llamar a otros procedimientos almacenados y funciones, lo que permite crear lógica compleja y modular.

## Gestión de procedimientos
Para ver los procedimientos existentes:

```sql
SHOW PROCEDURE STATUS;
```

Para eliminar un procedimiento:

```sql
DROP PROCEDURE IF EXISTS nombre_procedimiento;
```

---

# 30. DECLARE HANDLER en Procedimientos almacenados
`DECLARE HANDLER` es un mecanismo para manejar errores y excepciones en procedimientos almacenados. Permite capturar y responder a condiciones específicas que pueden ocurrir durante la ejecución.

Permite definir código SQL que se ejecutará cuando ocurra una excepción específica.

## Sintaxis básica:

```sql
DECLARE {CONTINUE | EXIT} HANDLER FOR condición
    declaración_handler;
```

## Tipos de `HANDLER`:

- `CONTINUE`: Continúa la ejecución después de manejar la condición.
- `EXIT`: Sale del bloque `BEGIN-END` actual después de manejar la condición.

## Condiciones que se pueden manejar:

- **Códigos de error MySQL**: Números específicos de error.
- **Estados SQL**: Códigos de estado `SQLSTATE`.
- **Condiciones predefinidas**: `SQLWARNING`, `NOT FOUND`, `SQLEXCEPTION`.

## Ejemplo básico con `NOT FOUND`:

```sql
DELIMITER //
CREATE PROCEDURE BuscarEmpleado(
    IN empleado_id INT,
    OUT nombre_completo VARCHAR(100),
    OUT encontrado BOOLEAN
)
BEGIN
    -- Declarar el handler para cuando no se encuentra registro
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
        SET encontrado = FALSE;
    
    -- Inicializar variable
    SET encontrado = TRUE;
    
    -- Intentar buscar el empleado
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
    FROM empleados 
    WHERE id = empleado_id;
    
    -- Si no se encontró, el handler se ejecutará automáticamente
    
END //
DELIMITER ;
```

## Ejemplo con manejo de errores SQL:

```sql
DELIMITER //
CREATE PROCEDURE InsertarEmpleado(
    IN p_nombre VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_departamento_id INT,
    OUT resultado VARCHAR(100)
)
BEGIN
    -- Handler para clave duplicada (error 1062)
    DECLARE CONTINUE HANDLER FOR 1062
        SET resultado = 'Error: El email ya existe en el sistema';
    
    -- Handler para violación de clave foránea (error 1452)
    DECLARE CONTINUE HANDLER FOR 1452
        SET resultado = 'Error: El departamento especificado no existe';
    
    -- Handler para cualquier otro error SQL
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET resultado = 'Error: Ocurrió un problema inesperado';
    
    -- Inicializar resultado exitoso
    SET resultado = 'Empleado insertado correctamente';
    
    -- Intentar insertar
    INSERT INTO empleados (nombre, email, departamento_id)
    VALUES (p_nombre, p_email, p_departamento_id);
    
END //
DELIMITER ;
```

## Ejemplo complejo con múltiples handlers:

```sql
DELIMITER //
CREATE PROCEDURE TransferirSaldo(
    IN cuenta_origen INT,
    IN cuenta_destino INT,
    IN monto DECIMAL(10,2),
    OUT resultado VARCHAR(200)
)
BEGIN
    DECLARE saldo_actual DECIMAL(10,2);
    DECLARE operacion_exitosa BOOLEAN DEFAULT TRUE;
    
    -- Handler para registro no encontrado
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SET operacion_exitosa = FALSE;
        SET resultado = 'Error: Una de las cuentas no existe';
    END;
    
    -- Handler para errores SQL generales
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET operacion_exitosa = FALSE;
        SET resultado = 'Error: Problema durante la transacción';
        ROLLBACK;
    END;
    
    -- Iniciar transacción
    START TRANSACTION;
    
    -- Verificar saldo de cuenta origen
    SELECT saldo INTO saldo_actual 
    FROM cuentas 
    WHERE id = cuenta_origen;
    
    -- Verificar que hay suficiente saldo
    IF operacion_exitosa AND saldo_actual < monto THEN
        SET operacion_exitosa = FALSE;
        SET resultado = 'Error: Saldo insuficiente';
    END IF;
    
    -- Realizar transferencia si todo está bien
    IF operacion_exitosa THEN
        UPDATE cuentas SET saldo = saldo - monto WHERE id = cuenta_origen;
        UPDATE cuentas SET saldo = saldo + monto WHERE id = cuenta_destino;
        
        COMMIT;
        SET resultado = CONCAT('Transferencia exitosa de $', monto);
    ELSE
        ROLLBACK;
    END IF;
    
END //
DELIMITER ;
```

> [!NOTE]
> - `ROLLBACK` y `COMMIT` solo funcionan dentro de transacciones (`START TRANSACTION`).
> - `ROLLBACK` deshace **TODA** la transacción.


## Ejemplo con handler `EXIT`:

```sql
DELIMITER //
CREATE PROCEDURE EliminarEmpleado(
    IN empleado_id INT,
    OUT mensaje VARCHAR(100)
)
BEGIN
    -- Handler EXIT - sale del procedimiento inmediatamente
    DECLARE EXIT HANDLER FOR NOT FOUND
    BEGIN
        SET mensaje = 'Error: Empleado no encontrado';
    END;
    
    -- Handler para violación de integridad referencial
    DECLARE EXIT HANDLER FOR 1451
    BEGIN
        SET mensaje = 'Error: No se puede eliminar, tiene registros dependientes';
    END;
    
    -- Si llegamos aquí, el empleado existe
    DELETE FROM empleados WHERE id = empleado_id;
    SET mensaje = 'Empleado eliminado correctamente';
    
END //
DELIMITER ;
```

## Usar condiciones nombradas:

```sql
DELIMITER //
CREATE PROCEDURE ProcedimientoConCondiciones()
BEGIN
    -- Declarar condiciones personalizadas
    DECLARE empleado_no_encontrado CONDITION FOR SQLSTATE '02000';
    DECLARE error_salario CONDITION FOR SQLSTATE '45000';
    
    -- Handlers para condiciones nombradas
    DECLARE EXIT HANDLER FOR empleado_no_encontrado
    BEGIN
        SELECT 'Empleado no encontrado' AS mensaje;
    END;
    
    DECLARE EXIT HANDLER FOR error_salario
    BEGIN
        SELECT 'Error en el cálculo del salario' AS mensaje;
    END;
    
    -- Código del procedimiento...
    
END //
DELIMITER ;
```

## `Puntos importantes`:

1. **Orden de declaración**: Los handlers deben declararse antes de las demás declaraciones en el bloque **BEGIN-END**.
2. **Jerarquía**: Los handlers más específicos tienen prioridad sobre los generales.
3. **Ámbito**: Los handlers solo son válidos dentro del bloque donde se declaran.
4. **Múltiples** condiciones: Un handler puede manejar múltiples condiciones separadas por comas.

---

# 31. IF
La declaración `IF` en MySQL es una estructura de control que permite ejecutar código condicionalmente basado en una expresión booleana.

## Sintaxis básica
```sql
IF(condición, valor_si_verdadero, valor_si_falso)
```

## Tipos de `IF` en MySQL

### 1. `IF` como función (en `SELECT`)
La forma más común es usar `IF` como función dentro de consultas `SELECT`:

```sql
SELECT 
    nombre,
    edad,
    IF(edad >= 18, 'Mayor de edad', 'Menor de edad') AS categoria
FROM usuarios;
```

### 2. `IF` en procedimientos almacenados
Dentro de procedimientos almacenados puedes usar la estructura IF-THEN-ELSE:

```sql
DELIMITER //
CREATE PROCEDURE ejemplo_if(IN edad INT)
BEGIN
    IF edad >= 18 THEN
        SELECT 'Mayor de edad' AS resultado;
    ELSEIF edad >= 13 THEN
        SELECT 'Adolescente' AS resultado;
    ELSE
        SELECT 'Niño' AS resultado;
    END IF;
END //
DELIMITER ;
```

---

# 32. LOOP, WHILE, REPEAT y FOR

## `LOOP`
La sentencia `LOOP` crea un bucle infinito que debe ser terminado explícitamente con `LEAVE`.

### Sintaxis
```sql
[etiqueta:] LOOP
    -- declaraciones
    IF condición THEN
        LEAVE etiqueta;
    END IF;
END LOOP [etiqueta];
```

### Ejemplo práctico:
```sql
DELIMITER $$
CREATE PROCEDURE ejemplo_loop()
BEGIN
    DECLARE contador INT DEFAULT 0;
    
    mi_loop: LOOP
        SET contador = contador + 1;
        SELECT CONCAT('Iteración: ', contador) AS mensaje;
        
        IF contador >= 5 THEN
            LEAVE mi_loop;
        END IF;
    END LOOP mi_loop;
END$$
DELIMITER ;
```

## `WHILE`
El bucle `WHILE` ejecuta las declaraciones mientras la condición sea verdadera. La condición se evalúa al inicio de cada iteración.

### Sintaxis
```sql
[etiqueta:] WHILE condición DO
    -- declaraciones
END WHILE [etiqueta];
```

### Ejemplo práctico:
```sql
DELIMITER $$
CREATE PROCEDURE ejemplo_while()
BEGIN
    DECLARE contador INT DEFAULT 1;
    
    WHILE contador <= 5 DO
        SELECT CONCAT('Número: ', contador) AS resultado;
        SET contador = contador + 1;
    END WHILE;
END$$
DELIMITER ;
```

## `REPEAT`
`REPEAT` define la condición al final de la sentencia. Primero se ejecuta el bloque de código y luego evalúa la condición. Esto permite ejecutar al menos una vez el bloque de código aunque no se cumpla la condición. Es similar a un do-while en otros lenguajes.

### Sintaxis
```sql
[etiqueta:] REPEAT
    -- declaraciones
UNTIL condición
END REPEAT [etiqueta];
```

### Ejemplo práctico:
```sql
DELIMITER $$
CREATE PROCEDURE ejemplo_repeat()
BEGIN
    DECLARE contador INT DEFAULT 1;
    
    REPEAT
        SELECT CONCAT('Valor: ', contador) AS salida;
        SET contador = contador + 1;
    UNTIL contador > 5
    END REPEAT;
END$$
DELIMITER ;
```

## `FOR` (MySQL 8.0+)
La sentencia FOR es más reciente y permite iterar sobre un rango de valores o sobre el resultado de un cursor.

### Sintaxis para rango:
```sql
FOR variable IN inicio..fin DO
    -- declaraciones
END FOR;
```

#### Ejemplo con `rango`:
```sql
DELIMITER $$
CREATE PROCEDURE ejemplo_for()
BEGIN
    FOR i IN 1..5 DO
        SELECT CONCAT('Iteración FOR: ', i) AS mensaje;
    END FOR;
END$$
DELIMITER ;
```

### Sintaxis para cursor:
```sql
FOR registro IN cursor_name DO
    -- declaraciones
END FOR;
```

#### Ejemplo con cursor:
```sql
DELIMITER $$
CREATE PROCEDURE ejemplo_for_cursor()
BEGIN
    FOR registro IN (SELECT id, nombre FROM usuarios LIMIT 3) DO
        SELECT CONCAT('Usuario: ', registro.nombre, ' ID: ', registro.id) AS info;
    END FOR;
END$$
DELIMITER ;
```

---

# 33. Cursores

Un cursor en MySQL es una estructura que permite recorrer fila por fila el resultado de una consulta `SELECT`. Es como un "puntero" que te permite navegar a través de un conjunto de resultados de manera secuencial.

## ¿Qué es un cursor?
Un cursor es especialmente útil cuando necesitas procesar cada fila de un resultado individualmente, en lugar de trabajar con todo el conjunto de datos de una vez.

## Sintaxis tradicional de cursores (MySQL 5.x y superior)
```sql
-- 1. Declarar el cursor
DECLARE cursor_nombre CURSOR FOR SELECT columna1, columna2 FROM tabla WHERE condicion;

-- 2. Declarar handler para el final del cursor
DECLARE CONTINUE HANDLER FOR NOT FOUND SET variable_fin = TRUE;

-- 3. Abrir el cursor
OPEN cursor_nombre;

-- 4. Leer datos del cursor
FETCH cursor_nombre INTO variable1, variable2;

-- 5. Cerrar el cursor
CLOSE cursor_nombre;
```

## Ejemplo:
```sql
DELIMITER $$
CREATE PROCEDURE ejemplo_cursor_detallado()
BEGIN
    DECLARE emp_id INT;
    DECLARE emp_nombre VARCHAR(100);
    DECLARE terminado INT DEFAULT FALSE;
    
    -- PASO 1: Solo definimos la consulta (no se ejecuta)
    DECLARE mi_cursor CURSOR FOR 
        SELECT id, nombre FROM empleados LIMIT 3;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = TRUE;
    
    SELECT 'Cursor declarado pero no abierto' AS estado;
    
    -- PASO 2: AQUÍ se ejecuta la consulta y se reservan recursos
    OPEN mi_cursor;
    SELECT 'Cursor abierto - Consulta ejecutada y recursos reservados' AS estado;
    
    -- PASO 3: Leemos datos
    bucle: LOOP
        FETCH mi_cursor INTO emp_id, emp_nombre;
        
        IF terminado THEN
            LEAVE bucle;
        END IF;
        
        SELECT CONCAT('Leído: ', emp_nombre) AS resultado;
    END LOOP;
    
    -- PASO 4: Liberamos recursos
    CLOSE mi_cursor;
    SELECT 'Cursor cerrado - Recursos liberados' AS estado;
END$$
DELIMITER ;
```

## ¿Por qué hay que abrir y cerrar el cursor?

### Qué sucede internamente con `OPEN`:
Cuando declaras un cursor, simplemente estás definiendo **qué consulta SQL** va a ejecutar, pero **no se ejecuta todavía**.

```sql
-- Esto NO ejecuta la consulta, solo la define
DECLARE cursor_empleados CURSOR FOR 
    SELECT id, nombre, salario FROM empleados WHERE departamento = 'Ventas';
```

### Cuando usas `OPEN`, MySQL:

1. Ejecuta la consulta SQL definida en el cursor.
2. Crea un conjunto de resultados en memoria.
3. Posiciona el puntero ANTES de la primera fila.
4. Reserva recursos del sistema (memoria, conexiones, etc.).

```sql
-- AQUÍ es cuando MySQL realmente ejecuta el SELECT
OPEN cursor_empleados;
```

### Qué sucede internamente con `CLOSE`:

`CLOSE` es crucial porque:

1. Libera la memoria ocupada por el conjunto de resultados.
2. Libera recursos del sistema (conexiones, buffers, etc.).
3. Marca el cursor como no utilizable hasta que se vuelva a abrir.

```sql
-- Libera todos los recursos asociados
CLOSE cursor_empleados;
```

## ¿Exactamente qué pasa en la sentencia `FETCH - INTO`?

### Funcionamiento interno de `FETCH`:
`FETCH` es como mover un puntero a través de los resultados y copiar los datos de la fila actual a variables.

### Estado inicial del cursor (después de `OPEN`):
```sql
Posición del puntero: [ANTES DE LA PRIMERA FILA]
Resultados en memoria:
  Fila 1: id=1, nombre='Juan'
  Fila 2: id=2, nombre='María'  
  Fila 3: id=3, nombre='Carlos'
```

### Primera ejecución de `FETCH`:
```sql
FETCH mi_cursor INTO emp_id, emp_nombre;
```

Lo que sucede internamente:

1. Avanza el puntero a la siguiente fila (Fila 1).
2. Copia los valores de la fila actual a las variables.
3. Verifica si hay más filas disponibles

```sql
Posición del puntero: [FILA 1] ← Aquí está ahora
Resultados en memoria:
  Fila 1: id=1, nombre='Juan'     ← Datos copiados a variables
  Fila 2: id=2, nombre='María'  
  Fila 3: id=3, nombre='Carlos'

Variables después del FETCH:
  emp_id = 1
  emp_nombre = 'Juan'
```


### Segunda ejecución de `FETCH`:
```sql
FETCH mi_cursor INTO emp_id, emp_nombre;
```
---
```sql
Posición del puntero: [FILA 2] ← Ahora aquí
Resultados en memoria:
  Fila 1: id=1, nombre='Juan'     
  Fila 2: id=2, nombre='María'    ← Datos copiados a variables
  Fila 3: id=3, nombre='Carlos'

Variables después del FETCH:
  emp_id = 2
  emp_nombre = 'María'
```

## ¿Qué pasa cuando no hay más filas?
Cuando `FETCH` intenta leer más allá de la última fila:

1. **No copia ningún dato** a las variables.
2. **Activa la excepción** `NOT FOUND`.
3. Las variables **mantienen sus valores anteriores**.

```sql
-- Última fila leída exitosamente
FETCH mi_cursor INTO emp_id, emp_nombre;  -- emp_id=3, emp_nombre='Carlos'

-- Intento de leer una fila que no existe
FETCH mi_cursor INTO emp_id, emp_nombre;  -- Activa NOT FOUND
                                          -- emp_id sigue siendo 3
                                          -- emp_nombre sigue siendo 'Carlos'
```

## Correspondencia entre `SELECT` y `FETCH` `INTO`
Hay una correspondencia **posicional** y **obligatoria** entre las columnas del `SELECT` usado para crear el cursor y las variables del `FETCH` `INTO`.

### Reglas:
1. **Mismo número de elementos**: `SELECT` debe tener el mismo número de columnas que variables en `INTO`.
2. **Mismo orden**: La primera columna del `SELECT` va a la primera variable del `INTO`, la segunda columna a la segunda variable, etc.
3. **Compatibilidad de tipos**: Los tipos deben ser compatibles (MySQL hace conversiones automáticas cuando es posible).

>[!IMPORTANT]
> Los cursores solo se pueden usar en:
> 1. Procedimientos almacenados.
> 2. Funciones almacenadas.
> 3. Triggers.

---

# 34. COALESCE
`COALESCE` es una función muy útil en MySQL que devuelve el primer valor no nulo de una lista de expresiones.

## Sintaxis básica
```sql
COALESCE(expresión1, expresión2, expresión3, ...)
```

## Funcionamiento
`COALESCE` evalúa las expresiones de izquierda a derecha y devuelve el primer valor que no sea `NULL`. Si todas las expresiones son `NULL`, entonces devuelve `NULL`.

### Ejemplo básico
```sql
SELECT COALESCE(NULL, NULL, 'Hola', 'Mundo');
-- Resultado: 'Hola'

SELECT COALESCE(NULL, 'Primera', 'Segunda');
-- Resultado: 'Primera'

SELECT COALESCE(NULL, NULL, NULL);
-- Resultado: NULL
```

### Uso con columnas de tabla
Supongamos que tienes una tabla de usuarios:
```sql
CREATE TABLE usuarios (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    nickname VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO usuarios VALUES 
(1, 'Juan', 'Pérez', NULL, 'juan@email.com'),
(2, NULL, 'García', 'jgarcia', 'garcia@email.com'),
(3, 'María', NULL, 'mary123', NULL);
```

Puedes usar `COALESCE` para mostrar el primer nombre disponible:
```sql
SELECT id, 
       COALESCE(nickname, nombre, 'Sin nombre') AS nombre_mostrar
FROM usuarios;
```

Resultado:

| id | nombre         |
-----|----------------|
| 1  | Juan           |
| 2  | jgarcia        | 
| 3  | mary123        |

## Diferencias con otras funciones

### `COALESCE` vs `ISNULL`

- `ISNULL(expresión, reemplazo)` solo acepta 2 parámetros.
- `COALESCE` puede aceptar múltiples parámetros.

### `COALESCE` vs `IFNULL`

- `IFNULL(expresión, reemplazo)` es específico de MySQL y acepta 2 parámetros.
- `COALESCE` es estándar SQL y más flexible.

### `COALESCE` vs `CASE`
```sql
-- Estos son equivalentes:
SELECT COALESCE(col1, col2, 'default') FROM tabla;

SELECT CASE 
    WHEN col1 IS NOT NULL THEN col1
    WHEN col2 IS NOT NULL THEN col2
    ELSE 'default'
END FROM tabla;
```

## Consideraciones `importantes`
1. **Tipos de datos**: Todos los argumentos deben ser del mismo tipo o convertibles entre sí.
2. **Rendimiento**: `COALESCE` se evalúa de forma lazy (se detiene en el primer valor no nulo).
3. **Índices**: `COALESCE` en `WHERE` puede afectar el uso de índices.
4. **NULL vs valores vacíos**: `COALESCE` solo maneja `NULL`, no cadenas vacías o espacios.

---

# 35. Funciones almacenadas
Las funciones almacenadas en MySQL son bloques de código SQL reutilizables que se almacenan en la base de datos y pueden ser invocados desde cualquier parte de una consulta.

## ¿Qué son las funciones almacenadas?
Son subrutinas que aceptan parámetros de entrada, ejecutan un conjunto de instrucciones SQL y devuelven un único valor. Son similares a las funciones en lenguajes de programación tradicionales, pero operan dentro del contexto de la base de datos.

## Sintaxis básica
```sql
DELIMITER $$
CREATE FUNCTION nombre_funcion(parametros)
RETURNS tipo_dato
[caracteristicas]
BEGIN
    -- Código de la función
    RETURN valor;
END$$
DELIMITER ;
```

>[!IMPORTANT]
> Las funciones **siempre deben retornar un valor**. Si intentas crear una función sin especificar `RETURNS` o sin incluir una declaración `RETURN`, MySQL generará un error.

## Tipos de parámetros
Las funciones MySQL solo aceptan parámetros de entrada (`IN`), a diferencia de los procedimientos almacenados que pueden tener parámetros `IN`, `OUT` e `INOUT`.

## Características opcionales:
Las características de las funciones en MySQL son fundamentales para la **optimización del rendimiento** y el **correcto funcionamiento** de la base de datos. 

### 1. `DETERMINISTIC`
Indica que la función siempre devuelve el mismo resultado con los mismos parámetros.

```sql
CREATE FUNCTION calcular_iva(precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC  -- Siempre devuelve lo mismo con el mismo precio
BEGIN
    RETURN precio * 0.19;
END
```

### 2. `NOT DETERMINISTIC` (por defecto):
El resultado puede variar aunque los parámetros sean iguales.

```sql
CREATE FUNCTION obtener_timestamp_actual()
RETURNS DATETIME
NOT DETERMINISTIC  -- Cada llamada devuelve un tiempo diferente
BEGIN
    RETURN NOW();
END
```

Estas características informan al optimizador sobre qué tipo de operaciones SQL realiza la función:

### 3. `READS SQL DATA`:
La función lee datos pero no los modifica.

```sql
CREATE FUNCTION contar_productos_categoria(categoria VARCHAR(50))
RETURNS INT
READS SQL DATA  -- Solo lee, no modifica
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM productos WHERE categoria_id = categoria;
    RETURN total;
END
```

### 4. `MODIFIES SQL DATA`: 
La función modifica datos (`INSERT`, `UPDATE`, `DELETE`).

```sql
CREATE FUNCTION actualizar_stock(producto_id INT, cantidad INT)
RETURNS INT
MODIFIES SQL DATA  -- Modifica datos
BEGIN
    UPDATE productos SET stock = stock - cantidad WHERE id = producto_id;
    RETURN ROW_COUNT();
END
```

### 5. `NO SQL`: 
No contiene declaraciones SQL.

```sql
CREATE FUNCTION calcular_potencia(base INT, exponente INT)
RETURNS INT
NO SQL  -- Solo cálculos matemáticos
BEGIN
    DECLARE resultado INT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= exponente DO
        SET resultado = resultado * base;
        SET i = i + 1;
    END WHILE;
    
    RETURN resultado;
END
```

### 6. `CONTAINS SQL`: 
Contiene SQL pero no lee ni modifica datos (declaraciones, variables, etc.).

```sql
CREATE FUNCTION formatear_mensaje(texto VARCHAR(100))
RETURNS VARCHAR(150)
CONTAINS SQL  -- Usa SQL pero no accede a datos
BEGIN
    DECLARE resultado VARCHAR(150);
    SET resultado = CONCAT('[INFO] ', UPPER(texto));
    RETURN resultado;
END
```

## Ejemplo práctico:
```sql
DELIMITER $$

-- Función determinística para cálculos
CREATE FUNCTION calcular_comision(venta DECIMAL(10,2), tasa DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
COMMENT 'Calcula comisión basada en venta y tasa'
BEGIN
    RETURN venta * (tasa / 100);
END$$

-- Función que lee datos
CREATE FUNCTION obtener_promedio_ventas(vendedor_id INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
COMMENT 'Promedio de ventas de un vendedor'
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(monto) INTO promedio 
    FROM ventas 
    WHERE vendedor = vendedor_id;
    RETURN IFNULL(promedio, 0);
END$$

-- Función no determinística
CREATE FUNCTION log_actividad(mensaje VARCHAR(255))
RETURNS INT
MODIFIES SQL DATA
NOT DETERMINISTIC
COMMENT 'Registra actividad con timestamp'
BEGIN
    INSERT INTO log_sistema (mensaje, fecha) VALUES (mensaje, NOW());
    RETURN LAST_INSERT_ID();
END$$

DELIMITER ;
```

>[!IMPORTANT]
> Definir correctamente las características de las funciones es crucial para que MySQL pueda optimizar su ejecución, manejar la replicación apropiadamente y aplicar las
> restricciones de seguridad correctas.

## Gestión de funciones

### Crear función:
```sql
CREATE FUNCTION nombre_funcion...
```

### Eliminar función:
```sql
DROP FUNCTION IF EXISTS nombre_funcion;
```

### Modificar función
```sql
ALTER FUNCTION nombre_funcion [caracteristicas];
```

### Ver funciones existentes:
```sql
SHOW FUNCTION STATUS;
SHOW CREATE FUNCTION nombre_funcion;
```

### Verificación de características:
```sql
-- Ver las características de una función
SHOW CREATE FUNCTION nombre_funcion;

-- Ver todas las funciones y sus características
SELECT 
    ROUTINE_NAME,
    IS_DETERMINISTIC,
    SQL_DATA_ACCESS,
    SECURITY_TYPE
FROM information_schema.ROUTINES 
WHERE ROUTINE_TYPE = 'FUNCTION';
```

## Diferencias con procedimientos almacenados

### `Funciones`:

- Retornan un solo valor.
- Solo parámetros de entrada.
- Pueden usarse en expresiones SQL.
- No pueden contener transacciones.

### `Procedimientos`:

- Pueden retornar múltiples valores o ninguno.
- Parámetros `IN`, `OUT`, `INOUT`.
- Se ejecutan con `CALL`.
- Pueden manejar transacciones.

---

# 36. Triggers
Los triggers en MySQL son procedimientos almacenados especiales que se ejecutan automáticamente cuando ocurren eventos específicos en una tabla o vista de la base de datos. A diferencia de los procedimientos almacenados regulares, los triggers no se pueden invocar directamente, sino que se activan automáticamente cuando se producen ciertos eventos.

## Tipos de triggers
MySQL admite varios tipos de triggers basados en el evento que los activa:

### Por evento `DML` (`Data Manipulation Language`):

- `INSERT`: Se activa cuando se insertan nuevos registros.
- `UPDATE`: Se activa cuando se modifican registros existentes.
- `DELETE`: Se activa cuando se eliminan registros.

### Por momento de ejecución:

- `BEFORE`: Se ejecuta antes de que ocurra el evento.
- `AFTER`: Se ejecuta después de que ocurra el evento.

Esto nos da seis combinaciones posibles: 

1. `BEFORE` - `INSERT`
2. `AFTER` - `INSERT`
3. `BEFORE` - `UPDATE`
4. `AFTER` - `UPDATE`
5. `BEFORE` - `DELETE`
6. `AFTER` - `DELETE`


## Sintaxis básica
```sql
CREATE TRIGGER nombre_trigger
    {BEFORE | AFTER} {INSERT | UPDATE | DELETE}
    ON nombre_tabla
    FOR EACH ROW
BEGIN
    -- Código del trigger
END;
```

## Características `importantes`

### 1. Acceso a los datos:

- `NEW`: Referencia a los nuevos valores en operaciones `INSERT` y `UPDATE`.
- `OLD`: Referencia a los valores anteriores en operaciones `UPDATE` y `DELETE`.

### 2. `FOR EACH ROW`:
Esta cláusula indica que el trigger se ejecutará **una vez por cada fila** que sea afectada por la operación que lo activa (`INSERT`, `UPDATE` o `DELETE`), teniendo acceso a los valores `OLD` y `NEW` específicos de cada fila.

#### Comparación con otros sistemas
Aunque MySQL solo admite `FOR EACH ROW`, otros sistemas de bases de datos como `PostgreSQL`, `Oracle` y `SQL Server` también admiten `FOR EACH STATEMENT`, que funciona diferente:

- `FOR EACH ROW`: Se ejecuta N veces (una por cada fila afectada).
- `FOR EACH STATEMENT`: Se ejecuta solo 1 vez por toda la operación, sin importar cuántas filas se vean afectadas.

### 3. Limitaciones:

- No se pueden crear triggers en tablas temporales.
- Un trigger no puede modificar la tabla que lo activó (previene recursión infinita).
- No se pueden usar sentencias que generen o modifiquen triggers dentro del trigger.
- Los triggers `BEFORE` pueden modificar los valores `NEW` antes de la inserción/actualización

## Ejemplos

### Trigger para auditoría:
```sql
CREATE TRIGGER auditoria_empleados
    AFTER UPDATE ON empleados
    FOR EACH ROW
BEGIN
    INSERT INTO log_cambios (tabla, accion, usuario, fecha, valores_anteriores, valores_nuevos)
    VALUES ('empleados', 'UPDATE', USER(), NOW(), 
            CONCAT('salario:', OLD.salario), 
            CONCAT('salario:', NEW.salario));
END;
```

### Trigger para validación:
```sql
CREATE TRIGGER validar_salario
    BEFORE INSERT ON empleados
    FOR EACH ROW
BEGIN
    IF NEW.salario < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El salario no puede ser negativo';
    END IF;
END;
```

`SIGNAL`: Es la instrucción que permite lanzar una excepción de forma manual en MySQL. Es equivalente a un "throw" en otros lenguajes de programación.

`SQLSTATE '45000'`: Es el código de estado SQL que identifica el tipo de error. El código '45000' es un código genérico para errores definidos por el usuario (user-defined exceptions). MySQL reserva este código específicamente para que los desarrolladores puedan crear sus propias excepciones personalizadas.

`SET MESSAGE_TEXT`: Define el mensaje de error que se mostrará al usuario cuando se lance la excepción. En este caso, el mensaje será "El salario no puede ser negativo".


### Trigger para cálculos automáticos:
```sql
CREATE TRIGGER calcular_total
    BEFORE INSERT ON facturas
    FOR EACH ROW
BEGIN
    SET NEW.total = NEW.subtotal + (NEW.subtotal * NEW.impuesto / 100);
END;
```

## Gestión de triggers

### Listar triggers:
```sql
SHOW TRIGGERS;
SHOW TRIGGERS FROM nombre_base_datos;
```

### Ver definición específica:
```sql
SHOW CREATE TRIGGER nombre_trigger;
```

### Eliminar trigger:
```sql
DROP TRIGGER nombre_trigger;
```

---

# 37. Transacciones
Las transacciones en MySQL son un mecanismo fundamental para garantizar la integridad y consistencia de los datos.

## ¿Qué es una transacción?
Una transacción es un conjunto de operaciones de base de datos que se ejecutan como una unidad atómica. Esto significa que todas las operaciones se completan exitosamente o ninguna se ejecuta en absoluto.

## Propiedades ACID
Las transacciones en MySQL siguen las propiedades `ACID`:

- **Atomicidad (Atomicity)**: Todas las operaciones de la transacción se ejecutan completamente o no se ejecuta ninguna. No hay estados intermedios.
- **Consistencia (Consistency)**: La transacción lleva la base de datos de un estado válido a otro estado válido, respetando todas las reglas de integridad.
- **Aislamiento (Isolation)**: Las transacciones concurrentes no interfieren entre sí. Cada transacción se ejecuta como si fuera la única en el sistema.
- **Durabilidad (Durability)**: Una vez que una transacción se confirma, los cambios persisten permanentemente, incluso ante fallos del sistema.

## Sintaxis básica
```sql
-- Iniciar una transacción
START TRANSACTION;
-- o también
BEGIN;

-- Ejecutar operaciones
INSERT INTO cuentas (id, saldo) VALUES (1, 1000);
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 1;
INSERT INTO movimientos (cuenta_id, monto, tipo) VALUES (1, -100, 'retiro');

-- Confirmar la transacción
COMMIT;

-- O cancelar la transacción
ROLLBACK;
```

## Comandos principales

- `START TRANSACTION` o `BEGIN`: Inicia una nueva transacción.
- `COMMIT`: Confirma todos los cambios realizados en la transacción actual.
- `ROLLBACK`: Cancela todos los cambios realizados en la transacción actual.
- `SAVEPOINT`: Crea un punto de guardado dentro de la transacción.
- `ROLLBACK TO SAVEPOINT`: Deshace cambios hasta un punto específico.

## Ejemplo práctico: transferencia bancaria
```sql
START TRANSACTION;

-- Verificar saldo suficiente
SELECT saldo FROM cuentas WHERE id = 1;

-- Si hay saldo suficiente, continuar
UPDATE cuentas SET saldo = saldo - 500 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 500 WHERE id = 2;

-- Registrar la transferencia
INSERT INTO transferencias (cuenta_origen, cuenta_destino, monto, fecha) 
VALUES (1, 2, 500, NOW());

-- Si todo está correcto
COMMIT;

-- Si hay algún error
-- ROLLBACK;
```

## Uso de savepoints
Los savepoints permiten crear puntos de control dentro de una transacción:

```sql
START TRANSACTION;

INSERT INTO usuarios (nombre, email) VALUES ('Juan', 'juan@email.com');

SAVEPOINT sp1;

UPDATE usuarios SET email = 'nuevo@email.com' WHERE nombre = 'Juan';

SAVEPOINT sp2;

DELETE FROM usuarios WHERE nombre = 'Juan';

-- Volver al savepoint 2
ROLLBACK TO SAVEPOINT sp2;

-- Volver al savepoint 1
ROLLBACK TO SAVEPOINT sp1;

COMMIT;
```

## Autocommit
Por defecto, MySQL tiene habilitado el autocommit, lo que significa que cada sentencia SQL se ejecuta automáticamente como una transacción:
```sql
-- Verificar estado del autocommit
SELECT @@autocommit;

-- Deshabilitar autocommit
SET autocommit = 0;

-- Habilitar autocommit
SET autocommit = 1;
```

## Manejo de errores
```sql
START TRANSACTION;

-- Usar bloques de manejo de errores
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    RESIGNAL;
END;

-- Operaciones que pueden fallar
UPDATE cuentas SET saldo = saldo - 1000 WHERE id = 1;
UPDATE cuentas SET saldo = saldo + 1000 WHERE id = 2;

COMMIT;
```

## Niveles de aislamiento
MySQL soporta cuatro niveles de aislamiento:

### 1. `READ UNCOMMITTED` (Lectura No Confirmada)
Es el nivel más permisivo. Las transacciones pueden leer datos que aún no han sido confirmados por otras transacciones. Esto permite:

- **Dirty reads**: Leer datos modificados pero no confirmados.
- **Non-repeatable reads**: Obtener resultados diferentes en lecturas repetidas.
- **Phantom reads**: Ver filas nuevas que aparecen entre consultas.

### 2. `READ COMMITTED` (Lectura Confirmada)
Solo permite leer datos que han sido confirmados por otras transacciones. Evita **dirty reads** pero permite:

- **Non-repeatable reads**: Los datos pueden cambiar entre lecturas dentro de la misma transacción.
- **Phantom reads**: Pueden aparecer o desaparecer filas entre consultas.

### 3. `REPEATABLE READ` (Lectura Repetible)
Es el nivel por defecto en MySQL. Garantiza que las lecturas repetidas dentro de una transacción devuelvan los mismos resultados. Evita dirty reads y non-repeatable reads, pero en teoría permite:

- **Phantom reads**: Aunque MySQL InnoDB los previene en la mayoría de casos.

### 4. `SERIALIZABLE` (Serializable)
El nivel más restrictivo. Las transacciones se ejecutan como si fueran completamente secuenciales. Evita todos los fenómenos de concurrencia pero puede causar más bloqueos y reducir el rendimiento.

## Configuración de aislamiento

### Establecer el nivel de aislamiento
```sql
-- Para la sesión actual
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Para todas las nuevas conexiones
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Para una transacción específica
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
-- ... comandos de la transacción
COMMIT;
```

### Verificar el nivel actual
```sql
-- Nivel de la sesión
SELECT @@SESSION.transaction_isolation;

-- Nivel global
SELECT @@GLOBAL.transaction_isolation;
```

## Comportamiento práctico

### En `REPEATABLE READ` (por defecto):

- La primera lectura en una transacción establece el punto de vista
- Las lecturas subsecuentes ven la misma instantánea
- Los cambios de otras transacciones no son visibles hasta que se confirmen y se inicie una nueva transacción

### Ejemplo de funcionamiento:
```sql
-- Transacción A
START TRANSACTION;
SELECT balance FROM accounts WHERE id = 1; -- Resultado: 1000

-- Transacción B (en otra conexión)
START TRANSACTION;
UPDATE accounts SET balance = 1500 WHERE id = 1;
COMMIT;

-- Transacción A (continuación)
SELECT balance FROM accounts WHERE id = 1; -- Sigue siendo: 1000
COMMIT;

-- Nueva consulta fuera de transacción
SELECT balance FROM accounts WHERE id = 1; -- Ahora: 1500
```

>[!IMPORTANT]
> En MySQL las transacciones se ejecutan en **paralelo (muchas a la vez)**, no en serie (una a la vez).

## Conflictos y resolución

### Cuando las transacciones paralelas entran en conflicto:

Ejemplo de conflicto:
```sql
-- Transacción A
START TRANSACTION;
UPDATE accounts SET balance = balance - 50 WHERE id = 1;

-- Transacción B (paralela)
START TRANSACTION;
UPDATE accounts SET balance = balance + 100 WHERE id = 1;  -- Debe esperar
```

### Mecanismos de resolución:

1. **Bloqueo temporal**: Una transacción espera a que la otra libere el recurso
2. **Timeout**: Si la espera es muy larga, se produce un timeout
3. **Deadlock detection**: MySQL detecta y resuelve automáticamente los deadlocks

>[!NOTE]
> Los `deadlocks` son situaciones en las que dos o más transacciones se bloquean mutuamente, creando un ciclo de espera donde ninguna puede continuar. Es como un "callejón sin salida" en el mundo de las bases de datos.

---

# 38. Creación de usuarios

## Sintaxis básica:
```sql
CREATE USER 'nombre_usuario'@'host' IDENTIFIED BY 'contraseña';
```
## Componentes de la creación de usuarios

### 1. Nombre de usuario y host
- **'nombre_usuario'**: El nombre que identificará al usuario
- **'host'**: Especifica desde dónde puede conectarse el usuario:
    - `'localhost'`: Solo conexiones locales
    - `'%'`: Desde cualquier host (menos seguro)
    - `'192.168.1.%'`: Desde una subred específica
    - `'ejemplo.com'`: Desde un dominio específico

### 2. Métodos de autenticación

#### Contraseña tradicional:
```sql
CREATE USER 'usuario1'@'localhost' IDENTIFIED BY 'mi_contraseña_segura';
```

#### Plugin de autenticación específico:
```sql
CREATE USER 'usuario2'@'localhost' IDENTIFIED WITH mysql_native_password BY 'contraseña';
```

#### Sin contraseña (no recomendado):
```sql
CREATE USER 'usuario3'@'localhost';
```

## Ejemplos prácticos

### Crear usuario para acceso local solamente
```sql
CREATE USER 'admin_local'@'localhost' IDENTIFIED BY 'Admin123!';
```

### Crear usuario para acceso remoto
```sql
CREATE USER 'usuario_remoto'@'%' IDENTIFIED BY 'ContraseñaSegura456!';
```

### Crear usuario para una IP específica
```sql
CREATE USER 'app_user'@'192.168.1.100' IDENTIFIED BY 'AppPassword789!';
```

## Opciones adicionales al crear usuarios

### Expiración de contraseña
```sql
CREATE USER 'usuario_temp'@'localhost' 
IDENTIFIED BY 'contraseña' 
PASSWORD EXPIRE INTERVAL 90 DAY;
```

### Bloquear cuenta después de intentos fallidos
```sql
CREATE USER 'usuario_seguro'@'localhost' 
IDENTIFIED BY 'contraseña' 
FAILED_LOGIN_ATTEMPTS 3 
PASSWORD_LOCK_TIME 2;
```

### Requerir SSL
```sql
CREATE USER 'usuario_ssl'@'%' 
IDENTIFIED BY 'contraseña' 
REQUIRE SSL;
```

## Verificar usuarios creados
```sql
-- Ver todos los usuarios
SELECT User, Host FROM mysql.user;

-- Ver información detallada de un usuario específico
SHOW GRANTS FOR 'nombre_usuario'@'host';
````

## Otorgar permisos
Después de crear un usuario, necesitas otorgarle permisos:

```sql
-- Permisos completos en una base de datos específica
GRANT ALL PRIVILEGES ON nombre_bd.* TO 'usuario'@'localhost';

-- Permisos específicos
GRANT SELECT, INSERT, UPDATE ON nombre_bd.tabla TO 'usuario'@'localhost';

-- Permisos de administrador (cuidado con esto)
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;

-- Aplicar los cambios
FLUSH PRIVILEGES;
```

>[!IMPORTANT]
> No olvides aplicar los cambios con `FLUSH PRIVILEGES`

## Mejores prácticas de seguridad

1. **Usa contraseñas fuertes**: Mínimo 12 caracteres con mayúsculas, minúsculas, números y símbolos
2. **Principio de menor privilegio**: Otorga solo los permisos mínimos necesarios
3. **Especifica hosts**: Evita usar '%' a menos que sea absolutamente necesario
4. **Nombres descriptivos**: Usa nombres que indiquen el propósito del usuario
5. **Auditoría regular**: Revisa periódicamente los usuarios existentes

## Ejemplo completo paso a paso
```sql
-- 1. Crear el usuario
CREATE USER 'app_ventas'@'192.168.1.%' IDENTIFIED BY 'VentasSecure2024!';

-- 2. Otorgar permisos específicos
GRANT SELECT, INSERT, UPDATE ON tienda.productos TO 'app_ventas'@'192.168.1.%';
GRANT SELECT, INSERT ON tienda.ventas TO 'app_ventas'@'192.168.1.%';

-- 3. Aplicar cambios
FLUSH PRIVILEGES;

-- 4. Verificar
SHOW GRANTS FOR 'app_ventas'@'192.168.1.%';
```

## Quitar permisos

### Sintaxis básica
```sql
REVOKE privilegios ON base_datos.tabla FROM 'usuario'@'host';
```

### Quitar permisos específicos
```sql
-- Quitar permiso de SELECT
REVOKE SELECT ON tienda.productos FROM 'usuario'@'localhost';

-- Quitar múltiples permisos específicos
REVOKE SELECT, INSERT, UPDATE ON tienda.ventas FROM 'usuario'@'localhost';

-- Quitar permiso de DELETE
REVOKE DELETE ON tienda.* FROM 'usuario'@'localhost';
```

### Quitar todos los permisos de una base de datos
```sql
REVOKE ALL PRIVILEGES ON nombre_bd.* FROM 'usuario'@'localhost';
```

### Quitar todos los permisos globales
```sql
REVOKE ALL PRIVILEGES ON *.* FROM 'usuario'@'localhost';
```

### Quitar permisos de `procedimientos almacenados`
```sql
-- Quitar ejecución de procedimientos
REVOKE EXECUTE ON tienda.* FROM 'usuario'@'localhost';

-- Quitar ejecución de una función específica
REVOKE EXECUTE ON FUNCTION tienda.calcular_descuento FROM 'usuario'@'localhost';
```

### Ejemplo completo paso a paso
```sql
-- 1. Ver permisos actuales
SHOW GRANTS FOR 'empleado'@'localhost';

-- 2. Quitar permisos específicos
REVOKE DELETE ON tienda.productos FROM 'empleado'@'localhost';
REVOKE DROP ON tienda.* FROM 'empleado'@'localhost';

-- 3. Aplicar cambios
FLUSH PRIVILEGES;

-- 4. Verificar que se quitaron
SHOW GRANTS FOR 'empleado'@'localhost';
```

>[!IMPORTANT]
> Después de `quitar` u `otorgar` permisos, es importante aplicar los cambios:
> ```sql
> FLUSH PRIVILEGES;
>```

## Eliminar usuarios (por si es necesario)
```sql
DROP USER 'nombre_usuario'@'host';
```



























