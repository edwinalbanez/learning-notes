# Sharding

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


## Estrategia de fragmentación

MongoDB admite dos estrategias de fragmentación para distribuir datos entre clústeres fragmentados.

### Fragmentación hash

La fragmentación hash utiliza un índice hash de un solo campo o un índice hash compuesto como clave de fragmento para particionar los datos en el clúster fragmentado.

Fragmentación en un índice hash de un solo campo
La fragmentación hash proporciona una distribución de datos más uniforme en el clúster fragmentado, a costa de reducir las operaciones dirigidas frente a las operaciones de difusión. Tras el hash, es poco probable que los documentos con valores de clave de fragmento "similares" se encuentren en el mismo fragmento o fragmento; es más probable que Mongos realice operaciones de difusión para responder a una consulta de rango determinada. Mongos puede dirigir consultas con coincidencias de igualdad a un único fragmento.






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
