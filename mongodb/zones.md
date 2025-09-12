# Zonas en clústeres fragmentados

En clústeres fragmentados, se pueden crear zonas de datos fragmentados según la `clave de fragmento`. Cada zona se puede asociar con uno o más `shards` del clúster. Un `shard` se puede asociar con cualquier número de zonas.

---

# Índice

1. [¿Qué son las zonas?](#qué-son-las-zonas)
2. [Rangos](#rangos)
3. [Shard key con hash](#shard-key-con-hash-y-rangos-de-zonas)
4. [Clave de fragmento](#clave-de-fragmento)
5. [Agregar shards a una zona](#agregar-shards-a-una-zona)
6. [Crear un rango de zonas](#crear-un-rango-de-zonas)
7. [Eliminar un rango de zonas](#eliminar-un-rango-de-zona)
8. [Ver zonas existentes](#ver-zonas-existentes)
9. [Collations en sharding](#collations-en-sharding)
10. [Zonas y rangos para una colección vacía](#zonas-y-rangos-de-zonas-para-una-colección-vacía-o-inexistente)
11. [Shard keys simples o compuestas](#shard-keys-simples-o-compuestas)
   - [Crear las zonas](#1-crear-las-zonas)
   - [Crear los rangos de zonas](#2-crear-los-rangos-de-zona)
   - [Fragmentar la colección](#3-fragmentar-la-colección)
   - [Revisar los fragmentos creados y la distribución](#4-revisar-los-fragmentos-creados-y-la-distribución)

12. [Shard key con prefijo hash](#shard-key-con-hash-compuesto-y-prefijo-con-hash)
   - [Crear las zonas](#1-crear-las-zonas-1)
   - [Crear los rangos de zonas](#2-crear-los-rangos-de-zona-1)
   - [Fragmentar la colección](#3-fragmentar-la-colección-1)
   - [Revisar los fragmentos creados y la distribución](#4-revisar-los-fragmentos-creados-y-la-distribución-1)

13. [Shard key con prefijo no hash](#shard-key-con-hash-compuesto-y-prefijo-no-hash)
   - [Crear las zonas](#1-crear-las-zonas-2)
   - [Crear los rangos de zonas](#2-crear-los-rangos-de-zona-2)
   - [Fragmentar la colección](#3-fragmentar-la-colección-2)
   - [Revisar los fragmentos creados y la distribución](#4-revisar-los-fragmentos-creados-y-la-distribución-2)

---


# ¿Qué son las zonas?

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

---

# Rangos

Cada zona abarca **uno** o **más** `rangos de valores` de clave de fragmento para una colección. Cada `rango` que abarca una zona siempre incluye su límite inferior y excluye su límite superior. Las zonas no pueden compartir rangos ni tener rangos superpuestos.

Por ejemplo, considera una clave de fragmento en `{"x": 1}`. El clúster tiene los siguientes rangos de zona:

```javascript
{ "x" : 5 } --> { "x" : 10 } // Zona A
{ "x" : 10} --> { "x" : 20 } // Zona B
```

- Un documento con un valor de clave de fragmento de `7` se enruta a la `zona A`.
- Un documento con un valor de clave de fragmento de `10` se enruta a la `zona B`.

---

# `Shard key` con hash y rangos de zonas

Cuando usas una `shard key` con `hash` en MongoDB, las zonas y la distribución de datos se basan en los valores hasheados, no en los valores originales de los documentos. Esto cambia completamente cómo se comporta el enrutamiento de documentos comparado con shard keys sin hash.

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

---

# Clave de fragmento

Debes usar los campos incluidos en la clave de partición al definir un nuevo rango que una zona debe cubrir. Si usa una clave de partición compuesta, el rango debe incluir el **prefijo de la clave de partición**.


Por ejemplo, dada una clave de partición `{a: 1, b: 1, c: 1}`, para crear o actualizar un rango que cubra valores de `b`, se requiere incluir `a` como prefijo. Para crear o actualizar un rango que cubra valores de `c`, se requieren `a` y `b` como prefijos.


No puede crear rangos con campos que no estén incluidos en la clave de partición. Por ejemplo, si desea usar zonas para particionar datos según la ubicación geográfica, la clave de partición necesitaría que el primer campo contuviera datos geográficos.


Al elegir una clave de partición para una colección, considere qué campos podría usar para configurar las zonas.

> [!IMPORTANT]
> Eliminar una colección también elimina automáticamente todos sus rangos de zona asociados, así que ten esto en cuenta en tu estrategia de gestión de datos.

---

# Agregar shards a una zona

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

---

# Crear un rango de zonas

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

---

# Eliminar un rango de zona

Utilice el método auxiliar de shell `sh.removeRangeFromZone()` para eliminar un rango de una zona.

El siguiente ejemplo elimina la asignación de la zona de Nueva York para el rango de códigos postales dentro de Manhattan:

```javascript
sh.removeRangeFromZone("records.user", {zipcode: "10001"}, {zipcode: "10281"})
```

> [!NOTE]
> Al eliminar una colección se eliminan sus rangos de zona/etiqueta asociados.

---

# Ver zonas existentes

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

---

# `Collations` en `sharding`
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


## Para aplicar sharding correctamente se necesita:

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

## ¿Qué significa "simple"?

- Comparación binaria exacta
- Sensible a mayúsculas
- Sensible a acentos
- Sin reglas de idioma específicas
- Ordena por valores de bytes UTF-8

> [!NOTE]
> Por defecto, MongoDB usa `{collation: { locale: "simple"}}` al crear una colección

---

# Zonas y rangos de zonas para una colección **vacía o inexistente**

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

---

# Shard keys simples o compuestas

> [!NOTE]
> Este ejemplo solo aplica a claves de fragmento de campo único o compuestas sin un campo con hash.
> 
> Por ejemplo, `{ "zip": 1}` o `{ "zip": 1, "account": 1}`


## 1. Crear las zonas

usa `sh.addShardToZone()` para crear las zonas:

```javascript
sh.addShardToZone("shardA", "DC1")
sh.addShardToZone("shardB", "DC2")
```

## 2. Crear los rangos de zona

Utilice `sh.updateZoneKeyRange()` para crear los rangos para la colección `contacts` vacía en la base de datos `exampledb`:

```javascript
sh.updateZoneKeyRange(
    "exampledb.contacts",
    { zip: 10001 },
    { zip: 10090 },
    "DC1"
);

sh.updateZoneKeyRange(
    "exampledb.contacts",
    { zip: 90001 },
    { zip: 96054 },
    "DC2"
);
```

## 3. Fragmentar la colección

> [!NOTE]
> Si la colección no existe, la operación de fragmentación la crea.
> 
> Si la colección está vacía y no existe un índice que admita la clave de fragmentación, la operación de fragmentación crea el índice.

Utilice `sh.shardCollection()` para fragmentar la colección `contacts`:

```javascript
sh.shardCollection("exampledb.contacts",  { zip: 1 } );
```

## 4. Revisar los fragmentos creados y la distribución
Para ver los fragmentos creados y la distribución, ejecute la operación `sh.status()`:

```javascript
sh.status()
```

El método retorna:
```javascript
--- Sharding Status ---
  sharding version: {
    "_id" : 1,
    "minCompatibleVersion" : 5,
    "currentVersion" : 6,
    "clusterId" : ObjectId("5b80c06d35a961fd0ae1986d")
  }
  shards:
        {  "_id" : "shardA",  "host" : "shardA/mongodb0.example.net:27018,mongodb1.example.net:27018,mongodb2.example.net:27018",  "state" : 1,  "tags" : [ "DC1" ] }
        {  "_id" : "shardB",  "host" : "shardB/mongodb3.example.net:27018,mongodb4.example.net:27018,mongodb5.example.net:27018",  "state" : 1,  "tags" : [ "DC2" ] }
  active mongoses:
        "4.2.0" : 2
  autosplit:
        Currently enabled: yes
  balancer:
        Currently enabled:  yes
        Currently running:  no
        Failed balancer rounds in last 5 attempts:  0
        Migration Results for the last 24 hours:
                No recent migrations
  databases:
        { "_id" : "config", "primary" : "config" }
        { "_id" : "exampledb", "primary" : "shardA", "version" : { "uuid" : UUID("6c351bcf-acd2-4fd9-82d8-9f6bd7321558"), "lastMod" : 1 } }
                exampledb.contacts
                        shard key: { "zip" : 1 }
                        unique: false
                        balancing: true
                        chunks:
                                shardA   3
                                shardB   2
                        { "zip" : { "$minKey" : 1 } } -->> { "zip" : 10001 } on : shardA Timestamp(1, 0)
                        { "zip" : 10001 } -->> { "zip" : 10090 } on : shardA Timestamp(1, 1)
                        { "zip" : 10090 } -->> { "zip" : 90001 } on : shardB Timestamp(1, 2)
                        { "zip" : 90001 } -->> { "zip" : 96054 } on : shardB Timestamp(1, 3)
                        { "zip" : 96054 } -->> { "zip" : { "$maxKey" : 1 } } on : shardA Timestamp(1, 4)
                          tag: DC1  { "zip" : 10001 } -->> { "zip" : 10090 }
                          tag: DC2  { "zip" : 90001 } -->> { "zip" : 96054 }
```

Para la colección, la operación de fragmentación creó cinco `chunks` (dos chunks que corresponden a los rangos de zona y los otros tres para cubrir todos los demás valores) en el `shardA` y el `shardB`.

---

# Shard key con hash compuesto y `prefijo con hash`

> [!NOTE]
> Este ejemplo solo se aplica a claves de fragmento con hash compuesto donde el campo con hash es el prefijo de la clave de fragmento (es decir, el primer campo de la clave de fragmento tiene hash).
> 
> Por ejemplo, `{ "_id": "hashed", "facility": 1}`

MongoDB admite la fragmentación de colecciones en índices con hash compuesto. Al fragmentar una clave de fragmento con hash compuesto, MongoDB puede optimizar la creación y distribución inicial de fragmentos en la colección vacía o inexistente solo si los rangos de zona definidos cumplen requisitos adicionales.


Considere una colección vacía, `examples.metrics`, que almacenará análisis de una de dos plantas de fabricación. La clave de fragmento planificada es `{ "_id": "hashed", "facility": 1}`, donde el campo hash es el prefijo de la clave de fragmento.

## 1. Crear las zonas

La clave de fragmento planificada es `{ "_id": "hashed", "facility": 1}`. Dado que el campo hash es el prefijo (es decir, el primer campo de la clave de fragmento), cree una sola zona con `sh.addShardToZone()`:

```javascript
sh.addShardToZone("shardA", "FacilityAlpha")
sh.addShardToZone("shardB", "FacilityAlpha")
```

## 2. Crear los rangos de zona
La distribución inicial de `chunks` en una clave de fragmento con hash compuesto y un `prefijo con hash` requiere un `único rango de zona` con `MinKey` para todos los campos de límite inferior y `MaxKey` para todos los campos de límite superior.


Utilice `sh.updateZoneKeyRange()` para crear un único rango:

```javascript
sh.updateZoneKeyRange(
   "examples.metrics",
   { "_id" : MinKey, "facility" : MinKey },
   { "_id" : MaxKey, "facility" : MaxKey },
   "FacilityAlpha"
);
```

## 3. Fragmentar la colección

> [!NOTE]
> Si la colección no existe, la operación de fragmentación la crea.
> 
> Si la colección está vacía y no existe un índice que admita la clave de fragmentación, la operación de fragmentación crea el índice.

Utilice `sh.shardCollection()` con `presplitHashedZones: true` para fragmentar la colección y realizar la creación y distribución inicial de fragmentos:

```javascript
sh.shardCollection(
  "examples.metrics",
  { "_id" : "hashed", "facility" : 1 },
  false,
  { presplitHashedZones: true }
)
```

## 4. Revisar los fragmentos creados y la distribución

Para ver los fragmentos creados y su distribución, ejecute la operación:

```javascript
sh.status()
```

El resultado se asemeja al siguiente (se omite el contenido para facilitar la lectura):

```javascript
--- Sharding Status ---

databases:
  { "_id" : "config", "primary" : "config" }
  { "_id" : "examples", "primary" : "shardA", "version" : { "uuid" : UUID("245f8abf-a363-48b0-8208-2a5b577bbb4e"), "lastMod" : 1 } }
    examples.metrics
      shard key: { "_id" : "hashed", "facility" : 1 }
      unique: false
      balancing: true
      chunks:
        shardA  2
        shardB  2
      { "_id" : { "$minKey" : 1 }, "facility" : { "$minKey" : 1 } } -->> { "_id" : NumberLong("-4611686018427387902"), "facility" : { "$minKey" : 1 } } on : shardA Timestamp(1, 0)
      { "_id" : NumberLong("-4611686018427387902"), "facility" : { "$minKey" : 1 } } -->> { "_id" : NumberLong(0), "facility" : { "$minKey" : 1 } } on : shardA Timestamp(1, 1)
      { "_id" : NumberLong(0), "facility" : { "$minKey" : 1 } } -->> { "_id" : NumberLong("4611686018427387902"), "facility" : { "$minKey" : 1 } } on : shardB Timestamp(1, 2)
      { "_id" : NumberLong("4611686018427387902"), "facility" : { "$minKey" : 1 } } -->> { "_id" : { "$maxKey" : 1 }, "facility" : { "$maxKey" : 1 } } on : shardB Timestamp(1, 3)

        tag: FacilityAlpha  { "_id" : { "$minKey" : 1 }, "facility" : { "$minKey" : 1 } } -->> { "_id" : { "$maxKey" : 1 }, "facility" : { "$maxKey" : 1 } }
```

La fragmentación generó un total de 4 `chunks`. Dos de ellos corresponden a los límites absolutos inferior y superior. Se creó una zona en el `shardA` y el `shardB`, correspondiente a `FacilityAlpha`. La zona se subdividió en 2 fragmentos mediante el campo hash.

---

# Shard key con hash compuesto y `prefijo no hash`

> [!NOTE]
> Este ejemplo solo se aplica a claves de fragmento con hash compuesto donde el campo con hash no es el prefijo de la clave de fragmento (es decir, el primer campo de la clave de fragmento no tiene hash).
>
> Por ejemplo, { "facility": 1, "_id": "hashed"}

Considere una colección vacía, `examples.metrics`, que almacenará análisis de una de dos instalaciones de fabricación. La clave de fragmento planificada es `{ "facility": 1, "_id": "hashed"}`, donde el campo hash no es el prefijo de la clave de fragmento.


- El campo "`facility`" almacena el nombre de la instalación: "`FacilityAlpha`" o "`FacilityBaker`". La colección requiere rangos de zona en la instalación para ayudar a aislar los datos de cada instalación en fragmentos específicos.
- El campo `_id` compensa la baja cardinalidad del campo "`facility`". El hash compensa la naturaleza monótonamente creciente del campo `_id`.

## 1. Crear las zonas

Utilice el comando `sh.addShardToZone()` para crear las zonas.

```javascript
sh.addShardToZone("shardA", "FacilityAlpha")
sh.addShardToZone("shardB", "FacilityBaker")
```

## 2. Crear los rangos de zona

La clave de fragmento planificada es `{"facility": 1, "_id": "hashed"}`. El campo "`facility`" tiene dos valores posibles: `FacilityAlpha` y `FacilityBaker`.


La distribución inicial de fragmentos en una clave de fragmento con hash compuesto, donde el campo con hash no es el prefijo, requiere **un rango de zona para cada combinación de valores** de campo de prefijo distintos (es decir, todos los campos que preceden al campo con hash). Dado que "`facility`" tiene dos valores de prefijo distintos, la colección requiere exactamente dos rangos de zona que cubran esos valores.

- El rango de límite inferior especifica `MinKey` para todos los campos sin prefijo.
- El rango de límite superior tiene al menos un campo de prefijo que difiere de su equivalente de límite inferior.

Utilice `sh.updateZoneKeyRange()` para crear el rango para `"facility": "FacilityAlpha"`:

```javascript
sh.updateZoneKeyRange(
   "examples.metrics",
   { "facility": "FacilityAlpha", "_id" : MinKey },
   { "facility": "FacilityBaker", "_id" : MinKey },
   "FacilityAlpha"
);
```

- Dado que los límites superiores del rango de zona son `exclusivos`, este rango solo cubre documentos con el valor de prefijo de clave de fragmento distintivo `"facilty": "FacilityAlpha"` y todos los valores posibles de `_id`.

Utilice `sh.updateZoneKeyRange()` para crear el rango para "facility": "FacilityBaker":

```javascript
sh.updateZoneKeyRange(
   "examples.metrics",
   { "facility": "FacilityBaker", "_id" : MinKey },
   { "facility": MaxKey, "_id" : MinKey },
   "FacilityBaker"
);
```

- Si bien el límite superior de este rango puede técnicamente capturar otros valores de facilidad, la lógica inicial de distribución de fragmentos se basa en la suposición de que no existen otros valores distintos para `facility`. Dado que la colección solo contiene documentos donde `facility` es `FacilityAlpha` o `FacilityBaker`, este rango solo cubre los documentos con el valor de prefijo de clave de fragmento distinto` "facility" : "FacilityBaker"` y todos los valores posibles de `_id`.

## 3. Fragmentar la colección

> [!NOTE]
> Si la colección no existe, la operación de fragmentación la crea.
>
> Si la colección está vacía y no existe un índice que admita la clave de fragmentación, la operación de fragmentación crea el índice.

Utilice `sh.shardCollection()` con `presplitHashedZones: true` para fragmentar la colección y realizar la creación y distribución inicial de fragmentos:

```javascript
sh.shardCollection(
  "examples.metrics",
  { "facility" : 1, "_id" : "hashed"},
  false,
  { presplitHashedZones: true }
)
```

## 4. Revisar los fragmentos creados y la distribución

Para ver los fragmentos creados y su distribución, ejecute la operación:

```javascript
sh.status()
```

El resultado se parece al siguiente (se omite el contenido para facilitar la lectura):

```javascript
--- Sharding Status ---

  databases:
    { "_id" : "config", "primary" : "config" }
    { "_id" : "examples", "primary" : "shardA", "version" : { "uuid" : UUID("6c351bcf-acd2-4fd9-82d8-9f6bd7321558"), "lastMod" : 1 } }
      examples.metrics
        shard key: { "facility" : 1, "_id" : "hashed" }
        unique: false
        balancing: true
        chunks:
          shardA  3
          shardB  3
        { "facility" : { "$minKey" : 1 }, "_id" : { "$minKey" : 1 } } -->> { "facility" : "FacilityAlpha", "_id" : { "$minKey" : 1 } } on : shard1 Timestamp(1, 0)
        { "facility" : "FacilityAlpha", "_id" : { "$minKey" : 1 } } -->> { "facility" : "FacilityAlpha", "_id" : NumberLong(0) } on : shard1 Timestamp(1, 1)
        { "facility" : "FacilityAlpha", "_id" : NumberLong(0) } -->> { "facility" : "FacilityBaker", "_id" : { "$minKey" : 1 } } on : shard1 Timestamp(1, 2)
        { "facility" : "FacilityBaker", "_id" : { "$minKey" : 1 } } -->> { "facility" : "FacilityBaker", "_id" : NumberLong(0) } on : shard2 Timestamp(1, 3)
        { "facility" : "FacilityBaker", "_id" : NumberLong(0) } -->> { "facility" : { "$maxKey" : 1 }, "_id" : { "$minKey" : 1 } } on : shard2 Timestamp(1, 4)
        { "facility" : { "$maxKey" : 1 }, "_id" : { "$minKey" : 1 } } -->> { "facility" : { "$maxKey" : 1 }, "_id" : { "$maxKey" : 1 } } on : shard2 Timestamp(1, 5)

          tag: FacilityAlpha  { "facility" : "FacilityAlpha", "_id" : { "$minKey" : 1 } } -->> { "facility" : "FacilityBaker", "_id" : { "$minKey" : 1 } }
          tag: FacilityBaker  { "facility" : "FacilityBaker", "_id" : { "$minKey" : 1 } } -->> { "facility" : { "$maxKey" : 1 }, "_id" : { "$minKey" : 1 } }
```

La operación de fragmentación generó un total de 6 `chunks`. Dos de ellos corresponden a los límites absolutos inferior y superior. Se crearon dos zonas, una en el  `shardA` y otra en el `shardB`, correspondientes a `FacilityAlpha` y `FacilityBaker`. Cada una de estas zonas se subdividió en dos fragmentos mediante el campo hash.

---
