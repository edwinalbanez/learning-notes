# Guía para MySQL
## Índice
0. [Introducción](#qué-es-sql)
1. [Crear una Base de Datos](#1-crear-una-base-de-datos)
2. [Crear Tablas](#2-crear-tablas)
3. [Definir Llaves Foráneas](#3-definir-llaves-foráneas)
4. [Modificaciones con ALTER TABLE](#4-modificaciones-con-alter-table)
5. [Insertar, Actualizar y Eliminar Registros](#5-insertar-actualizar-y-eliminar-registros)
6. [Operadores BETWEEN e IN](#6-operadores-between-e-in)
7. [Operadores LIKE e IS NULL](#7-operadores-like-e-is-null)
8. [Uso de ORDER BY](#8-uso-de-order-by)
9. [Uso de LIMIT](#9-uso-de-limit)
10. [Subconsultas](#10-subconsultas)
11. [INNER JOIN](#11-inner-join)
12. [LEFT JOIN y RIGHT JOIN](#12-left-join-y-right-join)
13. [SELF JOIN](#13-self-join)
14. [GROUP BY](#14-group-by)
15. [HAVING](#15-having)
16. [WITH ROLLUP](#16-with-rollup)
17. [CASE](#17-case)
18. [OVER (Funciones de Ventana)](#18-over-funciones-de-ventana)
19. [Vistas](#19-vistas)

---

## ¿Qué es SQL?
El lenguaje de consulta estructurada (SQL, por sus siglas en inglés) permite la interacción con bases de datos desde el almacenamiento y manipulación hasta la recuperación de los datos.

---
<img width="338" alt="image" src="https://github.com/user-attachments/assets/8f79a8e8-635f-4ded-b112-37f9ce5d9ea4" />

---
<img width="544" alt="image" src="https://github.com/user-attachments/assets/4e3bee63-5aac-439f-a3a9-de073c79adc0" />

---
<img width="548" alt="image" src="https://github.com/user-attachments/assets/4740b428-7562-427d-b9de-a770d7ec4f87" />

---
<img width="542" alt="image" src="https://github.com/user-attachments/assets/ff3252e8-fef7-45f2-8438-ef1b877e2e75" />

## 1. Crear una Base de Datos

### Conceptos Fundamentales
Una base de datos es un contenedor que almacena tablas, vistas, procedimientos y otros objetos relacionados. Es el primer paso para organizar la información de manera estructurada.

### Sintaxis Básica
```sql
CREATE DATABASE nombre_database;
```

### Sintaxis Avanzada
```sql
CREATE DATABASE empresa
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

### Mejores Prácticas
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

## 2. Crear Tablas

### Conceptos Fundamentales
Las tablas son estructuras que almacenan datos en filas y columnas. Cada columna tiene un tipo de dato específico y puede tener restricciones.

### Tipos de Datos Principales
- **Numéricos**: INT, DECIMAL, FLOAT, DOUBLE
- **Texto**: VARCHAR, CHAR, TEXT
- **Fecha/Hora**: DATE, TIME, DATETIME, TIMESTAMP
- **Booleanos**: BOOLEAN

### Sintaxis Básica
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

### Restricciones Importantes
- **NOT NULL**: El campo no puede estar vacío
- **UNIQUE**: Valores únicos en la columna
- **DEFAULT**: Valor por defecto
- **AUTO_INCREMENT**: Incremento automático para claves primarias

---

## 3. Definir Llaves Foráneas

### Conceptos Fundamentales
Las llaves foráneas (Foreign Keys) establecen relaciones entre tablas, garantizando la integridad referencial de los datos.

### Sintaxis en CREATE TABLE
```sql
CREATE TABLE tabla_hija (
    id INT NOT NULL PRIMARY KEY,
    id_padre INT,
    FOREIGN KEY (id_padre) REFERENCES tabla_padre(id)
);
```

### Sintaxis con ALTER TABLE
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

### Opciones de Integridad Referencial
- **ON DELETE CASCADE**: Elimina registros relacionados
- **ON DELETE RESTRICT**: Impide eliminar si hay referencias
- **ON DELETE SET NULL**: Establece NULL en referencias
- **ON UPDATE CASCADE**: Actualiza referencias automáticamente

### ¿Qué es la Integridad Referencial?
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

## 4. Modificaciones con ALTER TABLE

### Conceptos Fundamentales
ALTER TABLE permite modificar la estructura de tablas existentes sin perder datos.

### Agregar Columnas
```sql
ALTER TABLE tabla ADD COLUMN nueva_columna tipo_dato restricciones;
```

### Modificar Columnas
```sql
ALTER TABLE tabla MODIFY COLUMN columna nuevo_tipo_dato;
ALTER TABLE tabla CHANGE COLUMN nombre_viejo nombre_nuevo tipo_dato;
```

### Eliminar Columnas
```sql
ALTER TABLE tabla DROP COLUMN nombre_columna;
```

### Agregar/Eliminar Restricciones
```sql
-- Agregar clave primaria
ALTER TABLE tabla ADD PRIMARY KEY (columna);

-- Agregar índice
ALTER TABLE tabla ADD INDEX idx_nombre (columna);

-- Eliminar restricción
ALTER TABLE tabla DROP FOREIGN KEY nombre_fk;
```

### Ejemplos Prácticos
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

### ¿Como funcionan los índices?
En MySQL, un **índice** es una estructura de datos especial que mejora la velocidad de las operaciones de recuperación de datos en una tabla de base de datos. Permite al motor de la base de datos encontrar filas rápidamente sin tener que escanear la tabla completa.

Cuando creas un índice en una o más columnas de una tabla, MySQL crea y mantiene una estructura de datos separada (comúnmente un árbol B o un árbol B+) que almacena los valores de esas columnas y punteros (variables que almacenan una dirección numérica que apunta a la ubicación específica de un dato en la memoria RAM) a las filas correspondientes en la tabla real.

Cuando ejecutas una consulta SELECT que incluye una cláusula WHERE en una columna indexada, MySQL puede usar el índice para ir directamente a las filas que cumplen con la condición, en lugar de revisar cada fila de la tabla.

### Ejemplos de Creación de Índices:
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

### ¿Para qué es útil este índice? (Un Ejemplo Práctico)
Imagina que tienes una tabla clientes con millones de filas, y a menudo realizas consultas como:
```sql
SELECT * FROM clientes WHERE nombre = 'Juan Perez';
```
**Sin el índice `idx_nombre`**:
MySQL tendría que recorrer toda la tabla (fila por fila, lo que se llama un "escaneo de tabla completo" o "full table scan") para encontrar todas las filas donde el nombre sea 'Juan Perez'. Si la tabla tiene un millón de clientes, eso podría significar leer un millón de filas, lo cual es muy ineficiente y lento.


---

## 5. Insertar, Actualizar y Eliminar Registros

### INSERT - Insertar Datos

#### Sintaxis Básica
```sql
INSERT INTO tabla (columna1, columna2) VALUES (valor1, valor2);
```

#### Inserción Múltiple
```sql
INSERT INTO tabla (columna1, columna2) VALUES 
(valor1a, valor2a),
(valor1b, valor2b),
(valor1c, valor2c);
```

#### Ejemplos Prácticos
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

### UPDATE - Actualizar Datos

#### Sintaxis Básica
```sql
UPDATE tabla SET columna1 = valor1 WHERE condición;
```

#### Ejemplos Prácticos
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
El comando **opcional** `IGNORE` sirve para que no se detenga la ejecución de una consulta si se producen errores al momento de la actualización. En caso de que hayan errores no se realiza la actualización y continua con la siguiente sentencia.

>[!WARNING]
> Siempre se debe especificar con `WHERE` el registro a actualizar, de lo contrario, se actualizarán todos los registros de la tabla.

### DELETE - Eliminar Datos

#### Sintaxis Básica
```sql
DELETE FROM tabla WHERE condición;
```

#### Ejemplos Prácticos
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

### Funciones internas de MySQL


## 6. Operadores BETWEEN e IN

### Operador BETWEEN

#### Conceptos Fundamentales
BETWEEN filtra registros dentro de un rango específico, incluyendo los valores límite.

#### Sintaxis
```sql
SELECT * FROM tabla WHERE columna BETWEEN valor1 AND valor2;
```

#### Ejemplos Prácticos
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

### Operador IN

#### Conceptos Fundamentales
IN permite filtrar registros que coincidan con cualquier valor de una lista.

#### Sintaxis
```sql
SELECT * FROM tabla WHERE columna IN (valor1, valor2, valor3);
```

#### Ejemplos Prácticos
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

## 7. Operadores LIKE e IS NULL

### Operador LIKE

#### Conceptos Fundamentales
LIKE permite búsquedas con patrones usando comodines:
- `%`: Representa cero o más caracteres
- `_`: Representa exactamente un carácter

#### Sintaxis
```sql
SELECT * FROM tabla WHERE columna LIKE 'patrón';
```

#### Ejemplos Prácticos
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

### Operador IS NULL

#### Conceptos Fundamentales
IS NULL identifica registros con valores nulos (vacíos).

#### Sintaxis
```sql
SELECT * FROM tabla WHERE columna IS NULL;
SELECT * FROM tabla WHERE columna IS NOT NULL;
```

#### Ejemplos Prácticos
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

## 8. Uso de ORDER BY

### Conceptos Fundamentales
ORDER BY ordena los resultados de una consulta según una o más columnas.

### Sintaxis Básica
```sql
SELECT * FROM tabla ORDER BY columna [ASC|DESC];
```

### Ordenamiento Múltiple
```sql
SELECT * FROM tabla ORDER BY columna1 ASC, columna2 DESC;
```

### Ejemplos Prácticos
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

### Ordenamiento Avanzado
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

## 9. Uso de LIMIT

### Conceptos Fundamentales
LIMIT restringe el número de filas devueltas por una consulta.

### Sintaxis Básica
```sql
SELECT * FROM tabla LIMIT cantidad;
```

### Con OFFSET
```sql
SELECT * FROM tabla LIMIT offset, cantidad;
-- o en algunos sistemas:
SELECT * FROM tabla LIMIT cantidad OFFSET offset;
```

### Ejemplos Prácticos
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

### Paginación Profesional
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

## 10. Subconsultas

### Conceptos Fundamentales
Las subconsultas son consultas anidadas dentro de otras consultas, permitiendo operaciones complejas de filtrado y análisis.

### Subconsultas en SELECT

#### Sintaxis
```sql
SELECT columna1, (SELECT ... FROM ...) as alias FROM tabla;
```

#### Ejemplos Prácticos
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

### Subconsultas en FROM

#### Sintaxis
```sql
SELECT * FROM (SELECT ... FROM ...) as alias;
```

#### Ejemplos Prácticos
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

### Subconsultas en WHERE

#### Ejemplos Prácticos
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

### Subconsultas Correlacionadas
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

## 11. INNER JOIN

### Conceptos Fundamentales
INNER JOIN combina registros de dos o más tablas basándose en una condición de coincidencia. Solo devuelve registros que tienen coincidencias en ambas tablas.

### Sintaxis Básica
```sql
SELECT columnas
FROM tabla1
INNER JOIN tabla2 ON tabla1.columna = tabla2.columna;
```

### Ejemplos Prácticos

#### JOIN Básico
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

#### JOIN Múltiple
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

#### JOIN con Condiciones Adicionales
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

## 12. LEFT JOIN y RIGHT JOIN

### LEFT JOIN

#### Conceptos Fundamentales
LEFT JOIN devuelve todos los registros de la tabla izquierda y los registros coincidentes de la tabla derecha. Si no hay coincidencia, devuelve NULL para las columnas de la derecha.

#### Sintaxis
```sql
SELECT columnas
FROM tabla_izquierda
LEFT JOIN tabla_derecha ON condición;
```

#### Ejemplos Prácticos
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

### RIGHT JOIN

#### Conceptos Fundamentales
RIGHT JOIN es lo opuesto a LEFT JOIN: devuelve todos los registros de la tabla derecha y los coincidentes de la izquierda.

#### Sintaxis
```sql
SELECT columnas
FROM tabla_izquierda
RIGHT JOIN tabla_derecha ON condición;
```

#### Ejemplos Prácticos
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

### Casos de Uso Profesionales

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

## 13. SELF JOIN

### Conceptos Fundamentales
SELF JOIN es una técnica donde una tabla se une consigo misma. Es útil para comparar registros dentro de la misma tabla o para trabajar con estructuras jerárquicas.

### Sintaxis Básica
```sql
SELECT columnas
FROM tabla t1
JOIN tabla t2 ON condición
WHERE t1.id != t2.id; -- Evitar comparar un registro consigo mismo
```

### Preparación de Datos de Ejemplo
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

### Ejemplos Prácticos

#### Estructura Jerárquica (Empleados y Supervisores)
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

#### Comparaciones Dentro de la Misma Tabla
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

#### Encontrar Duplicados o Similitudes
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

### Casos de Uso Profesionales

#### Análisis de Jerarquías
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

#### Detección de Anomalías
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

## 14. GROUP BY

### Conceptos Fundamentales
GROUP BY agrupa filas que tienen los mismos valores en columnas especificadas y permite aplicar funciones de agregación como COUNT, SUM, AVG, MAX, MIN.

### Sintaxis Básica
```sql
SELECT columnas, funcion_agregacion(columna)
FROM tabla
WHERE condiciones
GROUP BY columnas
ORDER BY columnas;
```

### Funciones de Agregación Principales
- **COUNT()**: Cuenta registros
- **SUM()**: Suma valores
- **AVG()**: Promedio
- **MAX()**: Valor máximo
- **MIN()**: Valor mínimo
- **GROUP_CONCAT()**: Concatena valores del grupo

### Ejemplos Básicos

#### Agrupación Simple
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

#### Agrupación con JOIN
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

### Agrupación Múltiple
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

### Casos de Uso Profesionales

#### Análisis de Cohortes de Clientes
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

#### Análisis ABC de Productos
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

## 15. HAVING

### Conceptos Fundamentales
HAVING es similar a WHERE, pero se usa para filtrar grupos creados por GROUP BY. Mientras WHERE filtra filas individuales antes del agrupamiento, HAVING filtra grupos después del agrupamiento.

### Diferencias Clave: WHERE vs HAVING
- **WHERE**: Filtra filas antes de GROUP BY
- **HAVING**: Filtra grupos después de GROUP BY
- **HAVING**: Puede usar funciones de agregación
- **WHERE**: No puede usar funciones de agregación

### Sintaxis Básica
```sql
SELECT columnas, funcion_agregacion(columna)
FROM tabla
WHERE condiciones_individuales
GROUP BY columnas
HAVING condiciones_de_grupo
ORDER BY columnas;
```

### Ejemplos Básicos

#### HAVING con Funciones de Agregación
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

#### Combinando WHERE y HAVING
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

### Ejemplos Avanzados

#### Análisis de Tendencias
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

#### Detección de Outliers
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

### Casos de Uso Profesionales

#### Segmentación de Clientes RFM (Recency, Frequency, Monetary)
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

## 16. WITH ROLLUP

### Conceptos Fundamentales
WITH ROLLUP es una extensión de GROUP BY que genera automáticamente subtotales y totales generales. Crea filas adicionales que muestran agregaciones en diferentes niveles de la jerarquía de agrupamiento.

### Sintaxis Básica
```sql
SELECT columnas, funcion_agregacion(columna)
FROM tabla
GROUP BY columna1, columna2, ... WITH ROLLUP;
```

### Cómo Funciona ROLLUP
Con GROUP BY col1, col2 WITH ROLLUP se generan estos grupos:
1. (col1, col2) - Agrupación normal
2. (col1, NULL) - Subtotales por col1
3. (NULL, NULL) - Total general

### Ejemplos Básicos

#### ROLLUP Simple
```sql
-- Ventas por categoría con subtotales
SELECT 
    categoria,
    COUNT(*) as total_productos,
    SUM(precio * stock) as valor_inventario
FROM productos
GROUP BY categoria WITH ROLLUP;
```

#### ROLLUP Múltiple
```sql
-- Análisis de ventas por año, mes con subtotales
SELECT 
    YEAR(fecha_pedido) as año,
    MONTH(fecha_pedido) as mes,
    COUNT(*) as total_pedidos,
    SUM(total) as ingresos,
    AVG(total) as ticket_promedio
FROM pedidos
WHERE estado = 'COMPLETADO'
GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido) WITH ROLLUP
ORDER BY año, mes;
```

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

## 17. CASE

### Conceptos Fundamentales
CASE es una expresión condicional que permite implementar lógica if-then-else en SQL. Existen dos formas: CASE simple y CASE buscado.

### CASE Simple
```sql
CASE columna
    WHEN valor1 THEN resultado1
    WHEN valor2 THEN resultado2
    ELSE resultado_default
END
```

### CASE Buscado (Más Versátil)
```sql
CASE 
    WHEN condicion1 THEN resultado1
    WHEN condicion2 THEN resultado2
    ELSE resultado_default
END
```

### Ejemplos Básicos

#### Clasificación de Productos por Precio
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

#### Análisis de Clientes
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

### CASE en Agregaciones

#### Conteos Condicionales
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

### CASE Anidado y Complejo

#### Sistema de Descuentos Dinámico
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

## 18. OVER (Funciones de Ventana)

### Conceptos Fundamentales
Las funciones de ventana (Window Functions) permiten realizar cálculos sobre un conjunto de filas relacionadas con la fila actual, sin necesidad de GROUP BY. La cláusula OVER define la "ventana" de filas para el cálculo.

### Sintaxis Básica
```sql
funcion_ventana() OVER (
    [PARTITION BY columna(s)]
    [ORDER BY columna(s)]
    [ROWS/RANGE BETWEEN ... AND ...]
)
```

### Tipos de Funciones de Ventana

#### 1. Funciones de Agregación
- SUM(), AVG(), COUNT(), MIN(), MAX()

#### 2. Funciones de Ranking
- ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()

#### 3. Funciones de Valor
- FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()
- LAG(), LEAD()

### Ejemplos con Funciones de Ranking

#### ROW_NUMBER, RANK, DENSE_RANK
```sql
-- Ranking de productos por precio
SELECT 
    nombre,
    categoria,
    precio,
    ROW_NUMBER() OVER (ORDER BY precio DESC) as numero_fila,
    RANK() OVER (ORDER BY precio DESC) as ranking,
    DENSE_RANK() OVER (ORDER BY precio DESC) as ranking_denso,
    ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY precio DESC) as ranking_por_categoria
FROM productos
ORDER BY precio DESC;
```

#### NTILE para Segmentación
```sql
-- Dividir clientes en cuartiles por valor total
SELECT 
    c.nombre,
    COALESCE(SUM(p.total), 0) as total_gastado,
    NTILE(4) OVER (ORDER BY COALESCE(SUM(p.total), 0) DESC) as cuartil,
    CASE NTILE(4) OVER (ORDER BY COALESCE(SUM(p.total), 0) DESC)
        WHEN 1 THEN 'Top 25%'
        WHEN 2 THEN 'Segundo 25%'
        WHEN 3 THEN 'Tercer 25%'
        WHEN 4 THEN 'Último 25%'
    END as segmento
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente AND p.estado = 'COMPLETADO'
GROUP BY c.id_cliente, c.nombre
ORDER BY total_gastado DESC;
```

### Funciones de Agregación con OVER

#### Totales Acumulativos y Promedios Móviles
```sql
-- Análisis de ventas con totales acumulativos
SELECT 
    DATE(fecha_pedido) as fecha,
    COUNT(*) as pedidos_dia,
    SUM(total) as ingresos_dia,
    SUM(COUNT(*)) OVER (ORDER BY DATE(fecha_pedido)) as pedidos_acumulados,
    SUM(SUM(total)) OVER (ORDER BY DATE(fecha_pedido)) as ingresos_acumulados,
    AVG(SUM(total)) OVER (
        ORDER BY DATE(fecha_pedido) 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as promedio_movil_7_dias,
    SUM(total) / SUM(SUM(total)) OVER () * 100 as porcentaje_del_total
FROM pedidos
WHERE estado = 'COMPLETADO'
GROUP BY DATE(fecha_pedido)
ORDER BY fecha;
```

#### Comparaciones con Valores Anteriores/Siguientes
```sql
-- Análisis de crecimiento mensual
SELECT 
    YEAR(fecha_pedido) as año,
    MONTH(fecha_pedido) as mes,
    COUNT(*) as pedidos,
    SUM(total) as ingresos,
    LAG(SUM(total)) OVER (ORDER BY YEAR(fecha_pedido), MONTH(fecha_pedido)) as ingresos_mes_anterior,
    LEAD(SUM(total)) OVER (ORDER BY YEAR(fecha_pedido), MONTH(fecha_pedido)) as ingresos_mes_siguiente,
    ROUND(
        (SUM(total) - LAG(SUM(total)) OVER (ORDER BY YEAR(fecha_pedido), MONTH(fecha_pedido))) 
        / LAG(SUM(total)) OVER

