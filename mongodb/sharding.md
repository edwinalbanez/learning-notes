# Sharding

El `sharding` en MongoDB es una técnica de escalamiento horizontal que permite distribuir datos a través de múltiples servidores (llamados shards) para manejar grandes volúmenes de datos y alta carga de trabajo que exceden la capacidad de un solo servidor.


Se divide una colección grande en fragmentos más pequeños llamados "chunks", donde cada chunk contiene un subconjunto de documentos basado en una clave de sharding (shard key). Estos chunks se distribuyen automáticamente entre diferentes shards en el clúster.

---

# Índice

1. [Componentes del Sharding](#componentes-de-la-arquitectura-de-sharding)
   - [Shards](#1-shards-fragmentos)
   - [Router](#2-router-mongos)
   - [Config servers](#3-config-servers-servidores-de-configuración)

2. [Shard key](#shard-key-clave-de-fragmentación)
   - [Características importantes](#características-importantes-de-una-buena-shard-key)

3. [Chunks](#chunks)
   - [Características principales](#características-principales)

4. [Balanceador](#proceso-de-balanceador)

5. [Fragmentación hash](#fragmentación-hash)
   - [Índice hash de un solo campo](#fragmentación-en-un-índice-hash-de-un-solo-campo)
   - [índice hash compuesto](#fragmentación-en-un-índice-hash-compuesto)
   - [Hash vs rangos](#fragmentación-hash-vs-fragmentación-a-distancia)
   - [Fragmentar una colección](#fragmentar-una-colección)
   - [Fragmentar una colección poblada](#fragmentar-una-colección-poblada-con-datos)
   - [Fragmentar una colección vacía](#fragmentar-una-colección-vacía)
      - [Clave hash de campo único](#clave-hash-de-campo-único)
      - [Clave compuesta hash con prefijo hash](#clave-compuesta-hash-con-prefijo-hash)
      - [Clave compuesta hash con prefijo no hash](#clave-compuesta-hash-con-prefijo-no-hash)

6. [Fragmentación por rangos](#fragmentación-por-rangos)
   - [Seleccionar shard key](#selección-de-clave-de-fragmento)
   - [Fragmentar una colección](#fragmentar-una-colección-1)
   - [Fragmentar una colección poblada](#fragmentar-una-colección-poblada)
   - [Fragmentar una colección vacía](#fragmentar-una-colección-vacía-1)
      - [Sin zonas](#sin-zonas-definidas-1)
      - [Con zonas](#con-zonas-y-rangos-definidos)

7. [Consideraciones antes de fragmentar](#consideraciones-antes-de-fragmentar)

---

# [Componentes de la arquitectura de Sharding](https://www.mongodb.com/docs/manual/sharding/#sharded-cluster)

## 1. Shards (Fragmentos)
   - [Cada shard es un replica set independiente](https://www.mongodb.com/docs/manual/sharding/#high-availability)
   - [Contiene un subconjunto de los datos totales](https://www.mongodb.com/docs/manual/sharding/#storage-capacity)
   - Los datos se distribuyen basándose en la shard key (clave de fragmentación)
   - Pueden agregarse más shards para escalar horizontalmente

## 2. Router (mongos)

   - [Son los puntos de entrada de las aplicaciones](https://www.mongodb.com/docs/manual/core/sharded-cluster-query-router/#routing-with-mongos)
   - Actúan como proxy entre la aplicación cliente y los shards
   - [Procesan las consultas y determinan a qué shard(s) dirigir cada operación](https://www.mongodb.com/docs/manual/sharding/#advantages-of-sharding)
   - No almacenan datos, solo enrutan las peticiones
   - Pueden tener múltiples instancias para alta disponibilidad

## 3. Config Servers (Servidores de Configuración)

   - Almacenan los metadatos del cluster sharded
   - Contienen información sobre:
        - Qué datos están en cada shard
        - Rangos de claves (shard keys) asignados a cada shard
        - Configuración del cluster
   - [Funciona como replica set para garantizar alta disponibilidad](https://www.mongodb.com/docs/manual/sharding/#high-availability)
   - Son críticos para el funcionamiento del cluster


El siguiente gráfico describe la interacción de los componentes dentro de un clúster fragmentado:

<img width="441" height="314" alt="image" src="https://github.com/user-attachments/assets/2b74d134-6212-48fb-b4b4-1b9045c213bf" />

## Flujo de funcionamiento:

1. `La aplicación` se conecta a los routers (mongos)
2. `El router` consulta los config servers para determinar dónde están los datos
3. `El router` dirige la consulta al shard apropiado
4. `El shard` procesa la operación y devuelve el resultado
5. `El router` consolida las respuestas (si es necesario) y las envía a la aplicación

---

# Shard Key (clave de fragmentación)

MongoDB utiliza la `shard key` para distribuir los documentos de la colección entre shards (fragmentos). La shard key consiste en uno o varios campos de los documentos.

Para fragmentar una colección completa, esta **debe tener un `índice` que comience con la shard key**. Al fragmentar una colección vacía, MongoDB crea el índice de apoyo si la colección no tiene un índice adecuado para la shard key especificada.

La elección de la clave de fragmentación afecta el rendimiento, la eficiencia y la escalabilidad de un clúster fragmentado. Un clúster con el mejor hardware e infraestructura posibles puede verse afectado por la elección de la clave de fragmentación.

## Características importantes de una buena shard key:

- **Alta cardinalidad**: Debe tener muchos valores únicos posibles
- **Distribución uniforme**: Los valores deben distribuirse de manera equilibrada
- **Patrones de consulta**: Debe alinearse con los patrones de consulta más comunes
- **Inmutable**: No puede cambiar después de que el documento es insertado

Para consultas que incluyen la clave de fragmento o el prefijo de una clave de fragmento compuesta, `Mongos` puede dirigir la consulta a un shard o conjunto de shards específicos. Estas **operaciones dirigidas** suelen ser más eficientes que la difusión a todos los shards del clúster.

---

# Chunks

MongoDB fragmenta los documentos de una colección en `chunks`. Un chunk es un **rango contiguo de datos** de una colección fragmentada que se define por los valores de la `shard key`. Cada chunk contiene documentos cuyos valores de shard key caen dentro de un rango específico, por ejemplo:

- Chunk 1: shard key valores de 1 a 100
- Chunk 2: shard key valores de 100 a 200
- Chunk 3: shard key valores de 200 a 300

> [!NOTE]
> Los rangos de los chunks excluyen el límite superior 

Una vez que los `chunks` están creados, el `balancer` se encarga de distribuir estos chunks de manera equilibrada entre los diferentes shards del clúster. Así, cada shard termina almacenando uno o más chunks.

### Características principales

- `Tamaño por defecto`: Cada chunk tiene un tamaño máximo de 64 MB por defecto (configurable entre 1 MB y 1024 MB).
- `Distribución`: Los chunks se distribuyen automáticamente entre los diferentes shards del cluster para balancear la carga.
- `Indivisibilidad`: Un chunk completo siempre reside en un solo shard, nunca se divide entre múltiples shards.

---

# Proceso de Balanceador

En un intento por lograr una distribución uniforme de datos entre todos los `shards` del clúster, un `balanceador` se ejecuta en segundo plano para migrar rangos entre los fragmentos.

MongoDB incluye un balanceador automático que:

- Monitorea la distribución de chunks entre shards
- Mueve chunks automáticamente cuando detecta desbalances
- Intenta mantener un número similar de chunks en cada shard
- Puede configurarse para ejecutarse en ventanas de tiempo específicas

---


MongoDB admite dos estrategias de fragmentación para distribuir datos entre clústeres fragmentados.

# `Fragmentación hash`

La fragmentación hash utiliza un `índice hash` de **un solo campo** o un **índice hash compuesto** como clave de fragmento para particionar los datos en el clúster fragmentado. 


La distribución de datos basada en valores hash facilita una distribución más uniforme, especialmente en conjuntos de datos donde la clave de fragmento cambia de `forma monótona` (que siempre van en la misma dirección) como valores de `ObjectId` o `marcas de tiempo`.


MongoDB toma el valor del campo que has definido como "shard key" (clave de fragmentación) y le aplica una función hash. Esta función convierte el valor original en un **número hash**. A cada `chunk` se le asigna un rango basado en los valores **hash** calculados.


## Fragmentación en un `índice hash de un solo campo`

La fragmentación hash proporciona una distribución de datos más uniforme en el clúster fragmentado. Aunque un rango de claves de fragmento puede ser similar, es poco probable que sus valores hash se encuentren en el mismo `chunk`.


Sin embargo, la distribución hash significa que las consultas basadas en rangos por medio de la `shard key` tienen menos probabilidades de apuntar a un solo `shard`, lo que da como resultado más operaciones de transmisión en todo el clúster.


<img width="442" height="157" alt="image" src="https://github.com/user-attachments/assets/0b216921-d572-471d-a817-040b8773e0c7" />


## Fragmentación en un `índice hash compuesto`

MongoDB permite crear `índices compuestos con un único campo hash`. Para crear un índice hash compuesto, especifique "hashed" como el valor de cualquier clave de índice al crear el índice.


El índice hash compuesto calcula el valor hash de un único campo del índice compuesto; este valor se utiliza junto con los demás campos del índice como clave de fragmentación.


La fragmentación hash compuesta admite funciones como la fragmentación por zonas, donde el prefijo (es decir, el primer campo o campos sin hash) admite rangos de zonas, mientras que el campo hash permite una distribución más uniforme de los datos fragmentados. La fragmentación hash compuesta también admite claves de fragmentación con un prefijo hash para resolver problemas de distribución de datos relacionados con campos de `crecimiento monótono`.

## Fragmentación hash vs. fragmentación a distancia

Dada una colección que utiliza un valor `X` que aumenta `monótonamente` como clave de fragmento, el uso de fragmentos por rango da como resultado una distribución de inserciones entrantes similar a la siguiente:

<img width="422" height="209" alt="image" src="https://github.com/user-attachments/assets/b7312e3c-480e-4a55-8234-633d3f8e532f" />


- `Chunk con MinKey`: Siempre existe un `chunk` que maneja el rango más bajo, desde `MinKey` (valor más pequeño posible) hasta algún valor específico.
- `Chunk con MaxKey`: Siempre existe un chunk que maneja el rango más alto, desde algún valor hasta `MaxKey` (valor más grande posible).

Si la clave `X` **siempre aumenta** (`25 → 26 → 27`):

- Todos los nuevos documentos van al chunk que termina en `MaxKey` (Chunk C en la imagen)
- El shard que contiene este chunk se sobrecarga con todas las escrituras

Al utilizar un índice hash en X, la distribución de inserciones es similar a la siguiente:


<img width="401" height="217" alt="image" src="https://github.com/user-attachments/assets/a4c21238-c1e6-43f0-933b-c93d37cef91d" />


Como ahora los datos se distribuyen de manera más uniforme, las inserciones se distribuyen de manera eficiente en todo el clúster.

## Fragmentar una colección

Utilice el método `sh.shardCollection()`, especificando el espacio de nombres completo de la colección y el índice hash de destino para utilizar como clave de fragmento.

```javascript
sh.shardCollection( "database.collection", { <field> : "hashed" } )
```

Para fragmentar una colección en un índice hash compuesto, especifique el espacio de nombres completo de la colección y el índice hash compuesto de destino que se utilizará como clave de fragmentación:

```javascript
sh.shardCollection(
  "database.collection",
  { "fieldA" : 1, "fieldB" : 1, "fieldC" : "hashed" }
)
```

---

## Fragmentar una colección poblada (con datos)

Cuando fragmentas una colección que ya tiene datos usando una clave hash:

1. `Creación inicial`: Se crea un chunk inicial que cubre todos los valores existentes de la clave de fragmentación
2. `Distribución posterior`: El balanceador mueve rangos de este chunk inicial cuando necesita equilibrar los datos entre shards

Es un proceso más simple porque ya hay datos para analizar y distribuir.

---

## Fragmentar una colección vacía

El comportamiento varía según el tipo de clave de fragmentación y la configuración:

### Clave hash de campo único

#### Sin zonas definidas:

- A partir de MongoDB 8.0, crea 1 chunk por shard por defecto
- Puedes usar la opción `numInitialChunks` para especificar un número diferente
- Después de la distribución inicial, el balanceador administra la distribución de fragmentos en adelante.

#### Con zonas definidas:

- Se crean fragmentos vacíos para los rangos de zona definidos, así como fragmentos adicionales para cubrir todo el rango de valores de clave de fragmentación
- Realiza distribución inicial basada en las zonas
- Después de la distribución inicial, el balanceador administra la distribución de fragmentos en adelante.

---

### Clave compuesta hash con `prefijo hash`

Cuando el campo hash es el primer campo en la clave compuesta:

#### Sin zonas:

- Crea chunks vacíos cubriendo todo el rango
- Los campos no-hash tienen valor `MinKey` en cada punto de división
- 1 chunk por shard por defecto (MongoDB 8.0+)
- Opción `numInitialChunks` disponible

#### Con zona única (MinKey a MaxKey) y opción presplitHashedZones:
- Crea chunks para la zona definida más chunks adicionales para cubrir todo el rango de valores de clave de fragmentación
- Distribución inicial basada en zonas
- Después de la distribución inicial, el balanceador administra la distribución de chunks en adelante.

---

### Clave compuesta hash con prefijo No-Hash

Cuando el campo hash **NO** es el primer campo:

#### Sin zonas y `preSplitHashedZones` false/omitido:

- MongoDB no realiza ninguna creación o distribución de fragmentos inicial al fragmentar la colección.

#### Sin zonas y `preSplitHashedZones` true:
- Retorna un error - no se puede hacer
  
#### Con zonas y `preSplitHashedZones` especificado:
- Crea chunks para rangos de zona definidos, así como chunks adicionales para cubrir todo el rango de valores de clave de fragmentación.
- Subdivide cada chunk inicial para que cada shard en la zona reciba el mismo número de chunks
- Tras la distribución inicial, el balanceador gestiona la distribución de los chunks en adelante.

---

# Fragmentación por rangos

La fragmentación basada en rangos implica dividir los datos en `rangos contiguos` determinados por los valores de la clave de fragmento. En este modelo, es probable que los documentos con valores de clave de fragmento cercanos se encuentren en el `mismo chunk o shard`. 


Esto permite consultas eficientes donde las lecturas se dirigen a documentos dentro de un rango contiguo. Sin embargo, el rendimiento de lectura y escritura puede disminuir si la selección de la clave de fragmento es deficiente


<img width="476" height="157" alt="image" src="https://github.com/user-attachments/assets/fb534b53-e92f-482a-b0ab-78b811f4f45d" />


La fragmentación basada en rangos es la metodología de fragmentación `predeterminada` si no se configuran otras opciones, como las requeridas para la fragmentación en hash o las zonas.

## Selección de clave de fragmento

La fragmentación por rango es más eficiente cuando la clave de fragmento presenta las siguientes características:

### Gran cardinalidad de clave de fragmento

La `cardinalidad` se refiere al número de valores únicos posibles que puede tener tu **shard key**.

- Necesitas una clave que pueda tener muchos valores diferentes
- Esto permite que MongoDB distribuya los datos en más "chunks" (fragmentos)
- Más chunks = mejor distribución = mejor paralelización

Ejemplo

```javascript
// ❌ BAJA cardinalidad (malo)
{ status: "active" }  // Solo 2-3 valores posibles

// ✅ ALTA cardinalidad (bueno)
{ userId: ObjectId }  // Millones de valores únicos posibles
{ email: "user@domain.com" }  // Cada email es único
```

---

### Baja frecuencia de clave de fragmento

La `frecuencia` se refiere a qué tan a menudo se repite cada valor de la **shard key**.

- Cada valor de tu shard key debería aparecer pocas veces en tu colección
- Evita valores que se repitan demasiado (hot spots)
- Distribución más uniforme de los datos

Ejemplo

```javascript
// ❌ ALTA frecuencia
{ country: "USA" }  // Si 80% de usuarios son de USA

// ✅ BAJA frecuencia
{ userId: ObjectId }  // Cada documento tiene un userId único
{ customerId: "CUST_12345" }  // Cada cliente aparece pocas veces
```

> [!NOTE]
> El ejemplo anterior no es una recomendación de `shard key`. Su objetivo es explicar el concepto de `frecuencia`

---

## Claves de fragmento con cambios no monótonos

**Monótonamente creciente** significa que los valores siempre aumentan (como timestamps o IDs secuenciales).

### ¿Por qué evitar claves monótonas?

- Todos los nuevos documentos van al mismo shard (el último)
- Crea un "hotspot" de escritura
- Los otros shards quedan subutilizados

Ejemplo:

```javascript
// ❌ MONOTÓNO
{ timestamp: ISODate() }      // Siempre creciente
{ _id: ObjectId() }           // ObjectId incluye timestamp
{ sequenceNumber: 12345 }     // Autoincremental

// ✅ NO MONOTÓNO
{ userId: "a1b2c3d4-e5f6-7g8h-9i0j-k1l2m3n4o5p6" } // UUID aleatorios
{ productCode: "LAPTOP-XR7-BLK", "MOUSE-WL2-RED", "KEY-MX3-WHT" } // códigos de productos
{ customerId: "CUST_XYZ" }    // IDs no secuenciales
```

---

La siguiente imagen ilustra un clúster fragmentado que utiliza el campo `X` como clave de fragmentación. Si los valores de X tienen un rango amplio, una frecuencia baja y cambian a un ritmo no monótono, la distribución de inserciones podría ser similar a la siguiente:


<img width="477" height="236" alt="image" src="https://github.com/user-attachments/assets/7b821b13-f338-4e6a-a501-69c6ba315c9b" />

---

## Fragmentar una colección

Utilice el método `sh.shardCollection()`, especificando el espacio de nombres completo de la colección y el índice de destino o índice compuesto que se utilizará como clave del fragmento.

```javascript
sh.shardCollection( "database.collection", { <shard key> } )
```

---

## Fragmentar una colección `poblada`

Si fragmenta una colección poblada, `inicialmente solo se crea un chunk`. El balanceador migra los rangos de ese fragmento si es necesario, según el tamaño del rango configurado.

### 1. Creación de un solo chunk inicial

Independientemente de cuántos documentos tenga tu colección (miles, millones, etc.), MongoDB crea inicialmente **UN SOLO CHUNK** que contiene TODOS los datos existentes.

### 2. El trabajo del balanceador

El balanceador analiza este chunk gigante y determina si necesita dividirlo según el tamaño de chunk configurado (por defecto 128MB).

- Si el chunk excede el tamaño límite, el balanceador lo divide (split)
- Luego migra los nuevos chunks a diferentes shards para equilibrar la carga
- Este proceso ocurre de forma automática y gradual

---

## Fragmentar una colección `vacía`

Si fragmenta una colección vacía:

### Sin zonas definidas:

1. **Creación de un solo chunk**: MongoDB crea un único fragmento (chunk) vacío que cubre todo el rango posible de valores de la shard key. Por ejemplo, si tu shard key es un campo numérico, este chunk cubriría desde -∞ hasta +∞.

2. **Trabajo del balanceador**: El balanceador de MongoDB (un proceso automático) toma este chunk inicial y lo distribuye entre los shards disponibles conforme sea necesario. También se encarga de la distribución futura cuando lleguen datos.


### Con zonas y rangos definidos:

1. **Creación de múltiples chunks**: MongoDB crea chunks vacíos específicamente para cada rango de zona que definiste, además de chunks adicionales para cubrir cualquier parte del rango de shard key que no esté cubierta por las zonas.
2. **Distribución inicial inteligente**: Los chunks se distribuyen inmediatamente según las zonas configuradas, lo que hace que el proceso sea más eficiente.
3. **Gestión futura**: El balanceador continúa manejando la distribución según las reglas de zona establecidas.

---

# Consideraciones antes de fragmentar

Los requisitos y la complejidad de la infraestructura del clúster fragmentado requieren una planificación, ejecución y mantenimiento cuidadosos.

Si bien es posible volver a fragmentar la colección más tarde, es importante considerar cuidadosamente la elección de clave de fragmentación para evitar problemas de escalabilidad y rendimiento.

A partir de `MongoDB 5.1`, al iniciar, reiniciar o añadir un `shard` (servidor) con `sh.addShard()`, se debe configurar la **preocupación de escritura a nivel de clúster (CWWC)**.

Si la `CWWC` no está configurada y el fragmento está configurado con la preocupación de escritura predeterminada `{w:1}`, el servidor de fragmentos no se iniciará ni se añadirá y generará un error.

---

# Conexión a un clúster fragmentado

Debes conectarte a un enrutador Mongos para interactuar con cualquier colección del clúster fragmentado. Esto incluye colecciones fragmentadas y no fragmentadas. Los clientes nunca deben conectarse a un único fragmento para realizar operaciones de lectura o escritura.

<img width="440" height="231" alt="image" src="https://github.com/user-attachments/assets/6a529589-d3c5-418a-80dd-93a01abf42d8" />


Puedes conectarte a un `mongos` de la misma manera que te conectas a un `mongod` usando `mongosh` o un controlador MongoDB.


