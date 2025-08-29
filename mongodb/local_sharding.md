# Implementar un clúster fragmentado autoadministrado
Este tutorial implica la creación de un nuevo clúster fragmentado que consta de un `mongos`, el conjunto de réplicas del servidor de configuración y dos conjuntos de réplicas de fragmentos.

## Implementaciones de localhost 
Si usa `localhost` o su `dirección IP` como la parte del nombre de host de cualquier identificador de host, debe usar ese identificador como configuración de host para cualquier otro componente de MongoDB en el clúster.

Por ejemplo, el método `sh.addShard()` toma un parámetro de host para el nombre de host del fragmento de destino. Si establece host como localhost, debe usar localhost como host para todos los demás fragmentos del clúster.

### CORRECTO:
```javascript
// Primer shard
sh.addShard("localhost:27019")

// Segundo shard  
sh.addShard("localhost:27020")

// Tercer shard
sh.addShard("localhost:27021")
```

### INCORRECTO:
```javascript
// Primer shard con localhost
sh.addShard("localhost:27018")

// Segundo shard con IP - ¡PROBLEMA!
sh.addShard("127.0.0.1:27019")

// Tercer shard mezclando nomenclaturas - ¡PROBLEMA!
sh.addShard("localhost:27020")
```

## 1. Inicie cada miembro del conjunto de réplicas del servidor de configuración.
Al iniciar cada `mongod`, especifique la configuración de `mongod` ya sea mediante un archivo de configuración o la línea de comando.

Si utiliza un archivo de configuración, configure:

```yaml
sharding:
  clusterRole: configsvr
replication:
  replSetName: <replica set name>
net:
  port: <port number>
  bindIp: localhost,<hostname(s)|ip address(es)>
```

### sharding:

```yaml
sharding:
  clusterRole: configsvr
```

`clusterRole: configsvr`: Define que esta instancia de `mongod` actuará como un servidor de configuración en el clúster fragmentado.


### replication:

```yaml
replication:
  replSetName: <replica set name>
```

`replSetName`: Especifica el nombre del replica set. Todos los config servers deben usar el mismo nombre de replica set.


### net:

```yaml
net:
  port: <port number>
  bindIp: localhost,<hostname(s)|ip address(es)>
```

`port`: Define en qué puerto TCP escuchará el proceso `mongod` para conexiones entrantes. Cada instancia de `mongod` debe tener su propio puerto.


`bindIp`: Define las direcciones IP donde el servidor escuchará conexiones. Incluye `localhost` para conexiones locales y las IPs/hostnames específicos del servidor.


Inicie `mongod` con la opción `--config` establecida en la ruta del archivo de configuración.

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
- El campo `configsvr` se establece en verdadero para el conjunto de réplicas del servidor de configuración.
- La matriz de miembros contiene un documento por cada miembro del conjunto de réplicas.