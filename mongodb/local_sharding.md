# Implementar un clúster fragmentado localmente

Este tutorial implica la creación de un nuevo clúster fragmentado que consta de un `mongos`, el conjunto de réplicas del servidor de configuración y dos conjuntos de réplicas de fragmentos.

---

# Índice

1. [Conjunto de réplicas del servidor de configuración](#1-inicie-cada-miembro-del-conjunto-de-réplicas-del-servidor-de-configuración)
   - [Iniciar cada miembro](#1-inicie-cada-miembro-del-conjunto-de-réplicas-del-servidor-de-configuración)
   - [Conectarse a uno de los miembros](#2-conectarse-a-uno-de-los-servidores-de-configuración)
   - [Iniciar el conjunto de réplicas](#3-iniciar-el-conjunto-de-réplicas)

2. [Conjunto de réplicas de shards](#crear-los-conjuntos-de-réplicas-de-shards)
   - [Iniciar cada miembro](#1-inicie-cada-miembro-del-conjunto-de-réplicas-de-shards)
   - [Conectarse a uno de los miembros](#2-conectarse-a-un-miembro-del-conjunto-de-réplicas-de-shards)
   - [Iniciar el conjunto de réplicas](#3-iniciar-el-conjunto-de-réplicas-1)

3. [Iniciar mongos para el clúster fragmentado](#iniciar-mongos-para-el-clúster-fragmentado)
4. [Conectarse al clúster fragmentado](#conectarse-al-clúster-fragmentado)
5. [Agregar shards al clúster](#agregar-shards-al-clúster)

6. [Fragmentar una colección](#fragmentar-una-colección)
   - [Fragmentación hash](#la-fragmentación-hash)
   - [Fragmentación por rangos](#la-fragmentación-por-rangos)

7. [Diagrama del proceso](#diagrama-del-proceso)


---

# Implementaciones de localhost 

Si usa `localhost` o su `dirección IP` como la parte del nombre de host de cualquier identificador de host, debe usar ese identificador como configuración de host para cualquier otro componente de MongoDB en el clúster.


Por ejemplo, el método `sh.addShard()` toma un parámetro de host para el nombre de host del fragmento de destino. Si establece host como localhost, debe usar localhost como host para todos los demás fragmentos del clúster.

### Correcto:
```javascript
// Primer shard
sh.addShard("localhost:27019")

// Segundo shard  
sh.addShard("localhost:27020")

// Tercer shard
sh.addShard("localhost:27021")
```

### Incorrecto:
```javascript
// Primer shard con localhost
sh.addShard("localhost:27018")

// Segundo shard con IP - ¡PROBLEMA!
sh.addShard("127.0.0.1:27019")

// Tercer shard mezclando nomenclaturas - ¡PROBLEMA!
sh.addShard("localhost:27020")
```

---

# Crear el conjunto de réplicas del servidor de configuración

Los siguientes pasos implementan un conjunto de réplicas del servidor de configuración.


Para una implementación de producción, implemente un conjunto de réplicas del servidor de configuración con al menos `tres` miembros. Para realizar pruebas, puede crear un conjunto de réplicas de un solo miembro.


## 1. Inicie cada miembro del conjunto de réplicas del servidor de configuración.

Al iniciar cada `mongod`, especifique la configuración de `mongod` ya sea mediante un archivo de configuración o la línea de comando.

Si utiliza un archivo de configuración, configure:

```yaml
sharding:
  clusterRole: configsvr
replication:
  replSetName: <replica set name>
net:
  bindIp: localhost,<hostname(s)|ip address(es)>
  port: <port number>
```

Cada sección representa:

### `sharding:`

```yaml
sharding:
  clusterRole: configsvr
```

`clusterRole: configsvr`: Define que esta instancia de `mongod` actuará como un servidor de configuración en el clúster fragmentado.

---

### `replication:`

```yaml
replication:
  replSetName: <replica set name>
```

`replSetName`: Especifica el nombre del replica set. Todos los config servers deben usar el mismo nombre de replica set.

---

### `net:`

```yaml
net:
  bindIp: localhost,<hostname(s)|ip address(es)>
  port: <port number>
```

`port`: Define en qué puerto TCP escuchará el proceso `mongod` para conexiones entrantes. Cada instancia de `mongod` debe tener su propio puerto.


`bindIp`: Define las direcciones IP donde el servidor escuchará conexiones. Incluye `localhost` para conexiones locales y las IPs/hostnames específicos del servidor.

---

### _EJEMPLO_

Implementaremos `tres` miembros para el `servidor de configuración`.

Para cada uno:

1. Cree un archivo `.conf`, pegue lo siguiente y escriba un `port` diferente en cada uno:

```yaml
sharding:
  clusterRole: configsvr
replication:
  replSetName: myConfigReplSet
net:
  bindIp: localhost
  port: 27019
```

2. Inicie `mongod` con la opción `--config` establecida en la ruta del archivo de configuración.

```bash
mongod --config <path-to-config-file>
```


## 2. Conectarse a uno de los servidores de configuración.

Conecte `mongosh` a uno de los miembros del servidor de configuración.

```bash
mongosh --host <hostname> --port <port>
```

## 3. Iniciar el conjunto de réplicas.

Desde `mongosh`, ejecute el método `rs.initiate()`.


`rs.initiate()` puede tomar un documento de configuración de conjunto de réplicas opcional. En el documento de configuración de conjunto de réplicas, incluya:

- El `_id` se establece en el nombre del conjunto de réplicas especificado en `replication.replSetName` o en la opción `--replSet`.
- El campo `configsvr` se establece en `true` para el conjunto de réplicas del servidor de configuración.
- La matriz de miembros contiene un documento por cada miembro del conjunto de réplicas.


> [!IMPORTANT]
> Ejecute `rs.initiate()` solo en una instancia de `mongod` para el conjunto de réplicas.`


```javascript
rs.initiate(
  {
    _id: "myConfigReplSet",
    configsvr: true,
    members: [
      { _id : 0, host : "localhost:27019" },
      { _id : 1, host : "localhost:27020" },
      { _id : 2, host : "localhost:27021" }
    ]
  }
)
```

Una vez que el conjunto de réplicas del servidor de configuración (CSRS) se haya iniciado y esté activo, proceda a crear los conjuntos de réplicas de fragmentos.

---

# Crear los conjuntos de réplicas de `shards`

Para una implementación de producción, utilice un conjunto de réplicas con al menos tres miembros. Para realizar pruebas, puede crear un conjunto de réplicas con un solo miembro.


> [!NOTE]
> Los conjuntos de réplicas de shards no deben usar el mismo nombre que el conjunto de réplicas del servidor de configuración.


Para cada `shard`, utilice los siguientes pasos para crear el `conjunto de réplicas` de shards:

## 1. Inicie cada miembro del conjunto de réplicas de `shards`.

Al iniciar cada `mongod`, especifique la configuración de `mongod` ya sea mediante un archivo de configuración o la línea de comando.

Si utiliza un archivo de configuración, configure:

```yaml
sharding:
  clusterRole: shardsvr
replication:
  replSetName: <replica set name>
net:
  bindIp: localhost,<ip address>
  port: <port number>
storage:
  dbPath: /data/shard01/member01
```


### `storage:`

```yaml
storage:
  dbPath: /data/shard01/member01
```

`dbPath: /data/shard01/member01`: MongoDB creará automáticamente los archivos de base de datos dentro de esta carpeta.


Cada miembro del `shard` debe tener su propio directorio.

---

### _EJEMPLO_

Implementaremos `tres` miembros para el `conjunto de réplicas de shards`.

Para cada uno:

1. Cree un archivo `.conf`, pegue lo siguiente y especifique un `port` y `dbPath` diferente en cada `shard`:

```yaml
sharding:
  clusterRole: shardsvr
replication:
  replSetName: myShardReplSet
net:
  bindIp: localhost
  port: 27022
storage:
  dbPath: /data/shard01/member01
```

2. Inicie `mongod` con la opción `--config` establecida en la ruta del archivo de configuración.

```bash
mongod --config <path-to-config-file>
```

## 2. Conectarse a un miembro del conjunto de réplicas de shards.

Conecte `mongosh` a uno de los miembros del conjunto de réplicas.

```bash
mongosh --host <hostname> --port <port>
```

## 3. Iniciar el conjunto de réplicas.

Desde `mongosh`, ejecute el método `rs.initiate()`.

`rs.initiate()` puede tomar un documento de configuración del conjunto de réplicas opcional. En el documento de configuración del conjunto de réplicas, incluya:

- El campo `_id` establecido con el nombre del conjunto de réplicas especificado en `replication.replSetName` o en la opción `--replSet`.
- La matriz de miembros con un documento por cada miembro del conjunto de réplicas.

El siguiente ejemplo inicia `un conjunto de réplicas de tres miembros`:

> [!IMPORTANT]
> Ejecute `rs.initiate()` solo en una instancia de `mongod` para el conjunto de réplicas.

```javascript
rs.initiate(
  {
    _id : "myShardReplSet",
    members: [
      { _id : 0, host : "localhost:27022" },
      { _id : 1, host : "localhost:27023" },
      { _id : 2, host : "localhost:27024" }
    ]
  }
)
```

---

# Iniciar `mongos` para el clúster fragmentado

Inicie `mongos` usando un archivo de configuración o un parámetro de línea de comando para especificar los servidores de configuración.


Si usa un archivo de configuración, establezca `sharding.configDB` con el nombre del conjunto de réplicas del servidor de configuración y al menos un miembro del conjunto de réplicas en formato `<replSetName>/<host:port>`.

```yaml
sharding:
  configDB: myConfigReplSet/localhost:27019,localhost:27020,localhost:27021
net:
  port: 27018
  bindIp: localhost
```

Inicie `mongos` especificando la opción `--config` y la ruta al archivo de configuración.

```bash
mongos --config <path-to-config>
```

En este punto, su clúster fragmentado cuenta con `mongos` y los servidores y de configuración. Ahora puede conectarse al clúster fragmentado mediante `mongosh`.

---

# Conectarse al clúster fragmentado

Conecta `mongosh` a `mongos`. Especifica el host y el puerto donde se ejecuta `mongos`:

```bash
mongosh --host <hostname> --port <port>
```

Una vez que haya conectado `mongosh` a `mongos`, continúe con el siguiente procedimiento para agregar fragmentos al clúster.

---

# Agregar shards al clúster

En una sesión de `mongosh` conectada a `mongos`, use el método `sh.addShard()` para agregar cada fragmento al clúster.

La siguiente operación agrega un único conjunto de réplicas de fragmentos al clúster:

```javascript
sh.addShard("myShardReplSet/localhost:27019,localhost:27020,localhost:27021")
```

Repita estos pasos hasta que el clúster incluya todos los fragmentos deseados.

---

# Fragmentar una colección

Para fragmentar una colección, conecte `mongosh` a `mongos` y use el método `sh.shardCollection()`.

> [!IMPORTANT]
> Si la colección ya contiene datos, debe crear un **índice compatible con la clave de fragmentación** antes de fragmentarla. Si la colección está **vacía**, MongoDB crea el índice como parte de `sh.shardCollection()`.


MongoDB ofrece dos estrategias para fragmentar colecciones:

## La fragmentación hash

utiliza un índice en hash de un solo campo como clave de fragmentación para particionar los datos en todo el clúster fragmentado.

```javascript
sh.shardCollection("<database>.<collection>", { <shard key field> : "hashed" } )
```

## La fragmentación por rangos

Utiliza múltiples campos como clave de fragmento y divide los datos en rangos contiguos determinados por los valores de la clave de fragmento.

```javascript
sh.shardCollection("<database>.<collection>", { <shard key field> : 1, ... } )
```

---

# Diagrama del proceso


<img width="3056" height="2554" alt="image" src="https://github.com/user-attachments/assets/c22838ff-0ccf-4dc2-9d24-c5a3abb81b26" />

Hecho con [Excalidraw](https://excalidraw.com/#json=omtoEvjMVEu-FggYqFdsP,Z1rZLRCuGOmqJxIC6qR4vQ
)
