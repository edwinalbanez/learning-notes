# API con Express


## índice


# Node.js y Express

## Iniciar un nuevo proyecto

Naveguemos a un directorio apropiado y creemos una nueva plantilla para nuestra aplicación con el comando:

```javascript
npm init
```

Responderemos a las preguntas presentadas por la utilidad y el resultado será un archivo package.json generado automáticamente en la raíz del proyecto, que contiene información sobre el proyecto.

```json
{
  "name": "backend",
  "version": "1.0.0",
  "description": "",
  "license": "ISC",
  "author": "Edwin Albanez",
  "type": "commonjs",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  }
}
```

El archivo define, por ejemplo, que el punto de entrada de la aplicación es el archivo `index.js`.


Hagamos un pequeño cambio en el objeto `scripts` agregando un nuevo comando de script llamado `start`. Este comando permite iniciar la aplicación:
```json
{
  // ...
  "scripts": {

    "start": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  // ...
}
```

---

# Express

Usemos Express definiéndolo como una dependencia del proyecto con el comando:

```bash
pnpm install express
```

La versión `5.1.0` de Express se instaló en nuestro proyecto. ¿Qué significa el signo de intercalación delante del número de versión en package.json?
```json
"express": "^5.1.0"
```

El modelo de control de versiones utilizado en `npm` se denomina `control de versiones semántico`.


El signo de intercalación al frente de `^5.1.0` significa que si y cuando se actualizan las dependencias de un proyecto, la versión de Express que se instala será al menos `5.1.0`. 


Sin embargo, la versión instalada de Express también puede ser una que tenga un número de parche más grande (el último número) o un número menor más grande (el número del medio). La versión principal de la librería indicada por el primer número mayor debe ser la misma.


Podemos actualizar las dependencias del proyecto con el comando:
```bash
pnpm update
```

---

# Nodemon

Si hacemos cambios en el código de la aplicación, tenemos que reiniciar la aplicación para ver los cambios


`Nodemon` observará los archivos en el directorio en el que se inició nodemon, y si algún archivo cambia, nodemon reiniciará automáticamente tu aplicación de node.


Instalemos nodemon definiéndolo como una dependencia de desarrollo con el comando:

```bash
npm install --save-dev nodemon
```

Definamos un script npm dedicado para él en el archivo `package.json`:

```json
{
  // ..
  "scripts": {

    "dev": "nodemon index.js",

  },
  // ..
}
```

> [!NOTE]
> A diferencia de los scripts de `start` y `test`, también tenemos que agregar `run` al comando ya que se trata de un script no nativo.

---

# Mongoose

Mongoose podría describirse como un object document mapper (`ODM`) o mapeador de objetos a documentos en castellano, guardar objetos JavaScript como documentos en Mongo es sencillo con esta libería.


Instalemos Mongoose:

```bash
pnpm install mongoose
```

# Schemas

En la raíz del proyecto, crea un directorio llamado `models` y dentro de él crea un archivo `person.js`.


En `person.js`, primero se establece la conexion a MongoDB:

```javascript
const mongoose = require('mongoose');
const url = process.env.MONGODB_URI;

mongoose
  .connect(url)
  .then(result => {
    console.log('Connected to MongoDB!');
    
  })
  .catch(error => {
    console.log('Error connecting to MongoDB', error.message);
    
  });
```

---

El `Schema` es la definición o estructura de los datos. Define:

- Qué campos tendrá el documento
- Qué tipo de datos acepta cada campo
- Validaciones, valores por defecto, índices
- Métodos y middleware


Definimos el `esquema` de una persona que se almacena en la variable `personSchema`. El esquema le dice a Mongoose cómo se almacenarán los objetos de `persona` en la base de datos.
También podemos definir reglas de validación específicas para cada campo en el esquema:

```javascript
const personSchema = new mongoose.Schema({
  name: {
    type: String,
    minLength: 3,
    required: true
  },
  number: {
    type: String,
    minLength: 8,
    required: true,
    validate: {
      validator: number => /^\d{2,3}-\d+$/.test(number)
    },
    message: props => `${props.value} is not a valid phone number`,
  }
});
```

Las bases de datos de documentos como `Mongo` no tienen esquema, lo que significa que la base de datos en sí no se preocupa por la estructura de los datos que se almacenan en la base de datos. Es posible almacenar documentos con campos completamente `diferentes` en la misma colección.

---

Ahora se configura `cómo se transforman a JSON` los documentos. Una forma de formatear los documentos devueltos por Mongoose es modificar el método `toJSON` del esquema, que se utiliza en todas las instancias de los modelos producidos con ese esquema:

```javascript
personSchema.set('toJSON', {
  transform: (document, returnedObject) => {
    returnedObject.id = returnedObject._id.toString();

    delete returnedObject._id;
    delete returnedObject.__v;
  }
});
```

---

Finalmente se exporta el `modelo` creado a partir del esquema

```javascript
module.exports = mongoose.model('Person', personSchema);
```

En la definición del modelo `Person`, el primer parámetro de "Person" es el nombre singular del modelo. El nombre de la colección será el plural `people` en minúsculas, porque la convención de Mongoose es nombrar automáticamente las colecciones como el plural (por ejemplo, people) cuando el esquema se refiere a ellas en singular (por ejemplo, Person).




















































---

# Web y Express

Crea un archivo llamado `index.js` en la raiz del proyecto y escribe:

```javascript
const express = require('express')
const app = express()

let notes = [
  {
    id: 1,
    content: "HTML is easy",
    important: true
  },
  {
    id: 2,
    content: "Browser can execute only JavaScript",
    important: false
  },
  {
    id: 3,
    content: "GET and POST are the most important methods of HTTP protocol",
    important: true
  }
]

app.get('/', (request, response) => {
  response.send('<h1>Hello World!</h1>')
})

app.get('/api/notes', (request, response) => {
  response.json(notes)
})

const PORT = 3001
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
```

Justo al comienzo de nuestro código estamos importando express, que esta vez es una función que se usa para crear una aplicación Express almacenada en la variable app:
```javascript
const express = require('express')
const app = express()
```

A continuación, definimos dos rutas a la aplicación. El primero define un controlador de eventos, que se utiliza para manejar las solicitudes HTTP `GET` realizadas a la raíz `/` de la aplicación:
```javascript
app.get('/', (request, response) => {
  response.send('<h1>Hello World!</h1>')
})
```

La función del controlador de eventos acepta dos parámetros. El primer parámetro `request` contiene toda la información de la solicitud HTTP y el segundo parámetro `response` se utiliza para definir cómo se responde a la solicitud.


---


# Recibiendo información (`express.json()`)

Para acceder a los datos fácilmente, necesitamos la ayuda del `json-parser` de Express, que se usa con el comando `app.use(express.json())`.

Activemos json-parser e implementemos un controlador inicial para manejar las solicitudes HTTP POST:


```javascript
const express = require('express')
const app = express()


app.use(express.json())

//...


app.post('/api/notes', (request, response) => {
  const note = request.body
  console.log(note)
  response.json(note)
})
```

La función del controlador de eventos puede acceder a los datos de la propiedad `body` del objeto `request`.


Sin `json-parser`, la propiedad `body` no estaría definida. El json-parser funciona para que tome los datos JSON de una solicitud, los transforme en un objeto JavaScript y luego los adjunte a la propiedad **body** del objeto **request** antes de llamar al controlador de ruta.















