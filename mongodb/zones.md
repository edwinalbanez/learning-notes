# Zonas en clústeres fragmentados

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


## Rangos
Cada zona abarca **uno** o **más** `rangos de valores` de clave de fragmento para una colección. Cada `rango` que abarca una zona siempre incluye su límite inferior y excluye su límite superior. Las zonas no pueden compartir rangos ni tener rangos superpuestos.

Por ejemplo, considera una clave de fragmento en `{"x": 1}`. El clúster tiene los siguientes rangos de zona:

```javascript
{ "x" : 5 } --> { "x" : 10 } // Zona A
{ "x" : 10} --> { "x" : 20 } // Zona B
```

- Un documento con un valor de clave de fragmento de `7` se enruta a la `zona A`.
- Un documento con un valor de clave de fragmento de `10` se enruta a la `zona B`.

## Claves de fragmentos con hash y rangos de zonas

Cuando usas un `shard key` con `hash` en MongoDB, las zonas y la distribución de datos se basan en los valores hasheados, no en los valores originales de los documentos. Esto cambia completamente cómo se comporta el enrutamiento de documentos comparado con shard keys sin hash.

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


## Predefinir zonas y rangos de zonas para una colección vacía o inexistente
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
// Esto es código REAL que funciona:
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

## Clave de fragmento

Debes usar los campos incluidos en la clave de partición al definir un nuevo rango que una zona debe cubrir. Si usa una clave de partición compuesta, el rango debe incluir el **prefijo de la clave de partición**.


Por ejemplo, dada una clave de partición `{a: 1, b: 1, c: 1}`, para crear o actualizar un rango que cubra valores de `b`, se requiere incluir `a` como prefijo. Para crear o actualizar un rango que cubra valores de `c`, se requieren `a` y `b` como prefijos.


No puede crear rangos con campos que no estén incluidos en la clave de partición. Por ejemplo, si desea usar zonas para particionar datos según la ubicación geográfica, la clave de partición necesitaría que el primer campo contuviera datos geográficos.


Al elegir una clave de partición para una colección, considere qué campos podría usar para configurar las zonas.

> [!IMPORTANT]
> Eliminar una colección también elimina automáticamente todos sus rangos de zona asociados, así que ten esto en cuenta en tu estrategia de gestión de datos.

## Agregar shards a una zona
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

## Crear un rango de zonas

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


## Eliminar un rango de zona
Utilice el método auxiliar de shell `sh.removeRangeFromZone()` para eliminar un rango de una zona.

El siguiente ejemplo elimina la asignación de la zona de Nueva York para el rango de códigos postales dentro de Manhattan:

```javascript
sh.removeRangeFromZone("records.user", {zipcode: "10001"}, {zipcode: "10281"})
```

> [!NOTE]
> Al eliminar una colección se eliminan sus rangos de zona/etiqueta asociados.


## Ver zonas existentes
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

## `Collations` en `sharding`
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


### Para aplicar sharding correctamente se necesita:

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

### ¿Qué significa "simple"?

- Comparación binaria exacta
- Sensible a mayúsculas
- Sensible a acentos
- Sin reglas de idioma específicas
- Ordena por valores de bytes UTF-8

> [!NOTE]
> Por defecto, MongoDB usa `{collation: { locale: "simple"}}` al crear una colección


## Distribución inicial de chunks con shard key con `hash compuesto`

MongoDB admite la fragmentación de colecciones en índices con **hash compuesto**. Al fragmentar la colección vacía o inexistente en una clave de fragmento con hash compuesto, MongoDB optimiza la creación y distribución inicial de fragmentos.

### El campo hash es prefijo
Si el campo con hash es el prefijo de la clave de fragmento (es decir, el **primer campo** de la `shard key`), se debe cumplir con estas 2 condiciones para que MongoDB realice la creación y distribución del fragmento inicial:

#### 1.  Configuración de zona única
```javascript
// La colección debe tener una sola zona que cubra TODO el rango posible
{
  // Límites inferiores: MinKey para todos los campos
  "userId": MinKey,
  "timestamp": MinKey
},
{
  // Límites superiores: MaxKey para todos los campos  
  "userId": MaxKey,
  "timestamp": MaxKey
}
```

- `MinKey` y `MaxKey` son valores especiales que representan el mínimo y máximo posible
- Esta configuración significa que la zona abarca **todos los valores posibles** de la shard key
- Es como decir "toda la colección pertenece a una sola zona"


#### 2. Opción `presplitHashedZones: true`
```javascript
sh.shardCollection(
  "miBaseDatos.miColeccion",
  { "userId": "hashed", "timestamp": 1 },
  { presplitHashedZones: true }  // Esta opción es obligatoria
)
```

`presplitHashedZones` activa la **creación automática** de múltiples chunks **distribuidos uniformemente** antes de insertar datos

