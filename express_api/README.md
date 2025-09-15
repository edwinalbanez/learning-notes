# API en Express - Agenda telefónica


# índice




# Iniciar un nuevo proyecto

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

# Schema

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

## Modelo

El `Model` es la **clase JavaScript funcional** con todos los métodos necesarios para trabajar con MongoDB, creada a partir del `Schema`. Es lo que realmente interactúa con la base de datos. Te permite:

- Crear, leer, actualizar y eliminar documentos
- Ejecutar consultas
- Aplicar la lógica definida en el Schema


Finalmente se exporta el `modelo` creado a partir del esquema

```javascript
module.exports = mongoose.model('Person', personSchema);
```

En la definición del modelo `Person`, el primer parámetro de "Person" es el nombre singular del modelo. El nombre de la colección será el plural `people` en minúsculas, porque la convención de Mongoose es nombrar automáticamente las colecciones como el plural (por ejemplo, people) cuando el esquema se refiere a ellas en singular (por ejemplo, Person).

---

# dotenv

Para definir variables de entorno durante el desarrollo, instalaremos la librería `dotenv`:

```bash
pnpm install dotenv
```

Para usar la librería, creamos un archivo `.env` en la raíz del proyecto. Las variables de entorno se definen dentro del archivo y pueden verse así:

```.env
MONGODB_URI=mongodb+srv://fullstack:<thepasswordishere>@cluster0.o1opl.mongodb.net/phonebook?retryWrites=true&w=majority
PORT=3001
```

> [!CAUTION]
> El archivo `.env` debe ignorarse de inmediato en `.gitignore`, **¡ya que no queremos publicar ninguna información confidencial públicamente!**

---

# Morgan

Instalaremos el middleware `morgan` para el registro de solicitudes HTTP para `Node.js`

```javascript
pnpm install morgan
```

## Sintaxis y parámetros

```javascript
morgan(format, options)
```

## Parámetro `format`

Puede ser uno de tres tipos:

### 1. `String` con nombre predefinido
Morgan incluye varios formatos predefinidos:

```javascript
// Ejemplos de formatos predefinidos
app.use(morgan('combined'));  // Formato Apache combined
app.use(morgan('common'));    // Formato Apache common
app.use(morgan('dev'));       // Formato para desarrollo
app.use(morgan('short'));     // Formato corto
app.use(morgan('tiny'));      // Formato mínimo
```

### 2. `String` con formato personalizado
Puedes crear tu propio formato usando `tokens`:

```javascript
morgan(':method :url :status :res[content-length] - :response-time ms')
```

Los `tokens` más comunes incluyen:

- `:method` - Método HTTP (GET, POST, etc.)
- `:url` - URL de la petición
- `:status` - Código de estado HTTP
- `:response-time` - Tiempo de respuesta en ms
- `:remote-addr` - Dirección IP del cliente
- `:user-agent` - User agent del navegador


### 3. Función personalizada
Para máximo control, puedes usar una función, la función de formato se llamará con tres argumentos: `tokens`, `req` y `res`. 

Donde `tokens` es un objeto con todos los tokens definidos, `req` es la solicitud HTTP y `res` es la respuesta HTTP. Se espera que la función devuelva una cadena que será la línea de registro, o `undefined/null` para omitir el registro.


```javascript
morgan(function (tokens, req, res) {
  return [
    tokens.method(req, res),
    tokens.url(req, res),
    tokens.status(req, res),
    tokens.res(req, res, 'content-length'), '-',
    tokens['response-time'](req, res), 'ms'
  ].join(' ')
})
```

#### Argumentos de la función `format`
Cuando usas una función como formato, recibe tres argumentos:

- `tokens`: Un objeto que contiene todas las funciones de tokens disponibles
- `req`: El objeto de petición HTTP de Node.js
- `res`: El objeto de respuesta HTTP de Node.js


### Crear nuevos tokens
Para definir un `token`, simplemente invoque` morgan.token()` con el nombre y una función. Se espera que esta función devuelva un valor de `cadena`. En este caso, el nuevo token está disponible como "`:type`":

```javascript
morgan.token('type', (req, res) => req.headers['content-type']);
```

Llamar a `morgan.token()` con el mismo nombre que un token existente **sobrescribirá** la definición de dicho token. Se espera que la función `token` se llame con los argumentos `req` y `res`, que representan la solicitud HTTP y la respuesta HTTP. 


## Parámetro `options`
El parámetro `options` es un objeto opcional con configuraciones adicionales:

- `stream`: Dónde escribir los logs (por defecto stdout)
- `skip`: Función para decidir qué peticiones omitir
- `immediate`: Si escribir el log inmediatamente al recibir la petición


### `stream` - Dónde van los logs
Por defecto: Los logs van a `process.stdout` (consola). La opción `stream` debe ser un **objeto stream de escritura**.

```javascript
// Crear streams para diferentes archivos
const accessLogStream = fs.createWriteStream(
  path.join(__dirname, 'access.log'), 
  { flags: 'a' } // 'a' significa append (agregar al final)
);

const errorLogStream = fs.createWriteStream(
  path.join(__dirname, 'error.log'), 
  { flags: 'a' }
);

// Log de todas las peticiones a archivo
app.use(morgan('combined', {
  stream: accessLogStream
}));

// Log de errores a archivo separado
app.use(morgan('combined', {
  stream: errorLogStream,
  skip: function (req, res) { return res.statusCode < 400 }
}));
```

---

### `skip` - Qué peticiones omitir
Función que recibe: `(req, res) => boolean`

```javascript
// Omitir peticiones exitosas (solo loggear errores)
app.use(morgan('dev', {
  skip: function (req, res) { 
    return res.statusCode < 400; 
  }
}));

// Omitir peticiones a archivos estáticos
app.use(morgan('dev', {
  skip: function (req, res) { 
    return req.url.match(/\.(css|js|png|jpg|gif|ico)$/); 
  }
}));

// Omitir peticiones de health check
app.use(morgan('dev', {
  skip: function (req, res) { 
    return req.url === '/health' || req.url === '/ping'; 
  }
}));
```

---

### `immediate` - Cuándo hacer el log

`immediate: false` (defecto):

```javascript
// immediate: false (por defecto) - Log DESPUÉS de que la respuesta termine
app.use(morgan('dev', {
  immediate: false // Muestra el tiempo real de procesamiento y status code
}));

```

Ejemplo de log:
```
GET /api/users 200 145ms
```

- Log **después** de enviar respuesta
- Muestra status code y tiempo real
- No loggea si la app crashea antes de responder

`immediate: true`:

```javascript
// immediate: true - Log INMEDIATAMENTE al recibir la petición
app.use(morgan(':method :url', {
  immediate: true // Útil para ver qué peticiones llegan, aunque fallen
}));
```

Ejemplo de log:
```
GET /api/users
```

- Log **inmediatamente** al recibir petición
- No muestra status ni tiempo de respuesta
- Útil para detectar crashes o peticiones que no terminan

---

# Política del mismo origen y CORS

## Same origin policy (política de mismo origen)

La `política de mismo origen` es un mecanismo de seguridad implementado por los navegadores para prevenir el secuestro de sesiones, entre otras vulnerabilidades de seguridad.


Cuando visitas un sitio web (por ejemplo, http://example.com), el navegador emite una solicitud al servidor en el que está alojado el sitio web (example.com). La respuesta enviada por el servidor es un archivo HTML que puede contener una o más referencias a recursos externos alojados ya sea en el mismo servidor que example.com o en un sitio web diferente.


Cuando el navegador ve referencias a una URL en el HTML fuente, emite una solicitud. Si la solicitud se realiza utilizando la URL desde la cual se obtuvo el HTML fuente, entonces el navegador procesa la respuesta sin problemas.

## CORS (Cross-Origin Resource Sharing)
Cuando el navegador detecta una solicitud `cross-origin`, implementa verificaciones de seguridad:

1. El navegador hace la solicitud al servidor externo (por ejemplo, googleapis.com)
2. Examina la respuesta buscando el encabezado Access-Control-Allow-Origin
3. Verificación del encabezado:
   - Si contiene `*`: permite cualquier origen
   - Si contiene la URL específica del sitio origen: permite esa URL
   - Si no está presente o no coincide: bloquea la respuesta


Podemos permitir solicitudes de otros orígenes utilizando el middleware `cors` de **Node**.

```bash
pnpm install cors
```

```javascript
const cors = require('cors')

app.use(cors())
```

# Servidor web

A partir de ahora trabajaremos en el archivo `index.js`.


Las variables de entorno definidas en el archivo `.env` se pueden utilizar con la expresión `require('dotenv').config()` y puedes referenciarlas en tu código como lo harías con las variables de entorno normales, con la sintaxis `process.env.SOME_VALUE`.

```javascript
require('dotenv').config();
```

Ahora realizamos estas importaciones:

- `express`: que esta vez es una función que se usa para crear una aplicación Express
- `morgan`: para el registro de solicitudes HTTP
- `cors`: para permitir solicitudes de otros orígenes
- `Person`: el modelo para interactuar con la base de datos


```javascript
const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const Person = require('./models/person');
```

Crear la app de `Express`:

```javascript
const app = express();
```

Para acceder a los datos fácilmente, necesitamos la ayuda del `json-parser` de Express, que se usa con el comando `app.use(express.json())`. El json-parser funciona para que tome los datos JSON de una solicitud, los transforme en un objeto JavaScript y luego los adjunte a la propiedad `body` del objeto `request` antes de llamar al controlador de ruta.

Una opción para implementar el frontend es copiar la compilación de producción (el directorio dist) a la raíz del repositorio del backend y configurar el backend para que muestre la página principal del frontend (el archivo `dist/index.html`) como su página principal.


Para hacer que Express muestre contenido estático, la página index.html y el JavaScript, etc., necesitamos un middleware integrado de Express: `express.static('dist')`.

```javascript
app.use(express.json());
app.use(cors());
app.use(express.static('dist'));
app.use(morgan('tiny'));
```

## Ver todos los documentos

```javascript
app.get('/api/persons', (request, response) => {
  Person.find({}).then(
    people => response.json(people)
  );
});
```

## Información de la agenda telefónica

```javascript
app.get('/info', (request, response) => {
  Person.find({}).then(people => {
    response.send(`
      Phonebook has info for ${people.length} people. <br />
      ${Date()}
    `)
  });
});
```

## Ver un documento específico

```javascript
app.get('/api/persons/:id',  (request, response) => {
  Person.findById(request.params.id).then(person => {
    response.json(person)
  })
});
```

## Crear documento

```javascript
app.post('/api/persons', (request, response, next) => {

  if (!request.body) {
    return response.status(400).json({
      error: 'No data in the request.'
    })
  }

  const { name, number } = request.body;

  if (!(name && number)) {
    return response.status(400).json({
      error: 'Name and number are required.'
    })
  }

  const person = new Person({ name, number })

  person.save().then(addedPerson => {
    response.status(201).json(addedPerson)
  })
  .catch(error => next(error));

});
```

## Eliminar un documento

```javascript
app.delete('/api/persons/:id', (request, response, next) => {
  const id = request.params.id;

  Person.findByIdAndDelete(id)
    .then(deletedPerson => {
      if (!deletedPerson) {
        return response.status(404).json({
          error: 'Person not found.'
        });
      }
      response.status(204).end();
    })
    .catch(error => next(error));

});
```

## Actualizar documento

```javascript
app.put('/api/persons/:id', (request, response, next) => {

  if (!request.body) {
    return response.status(400).json({
      error: 'No data in the request.'
    })
  }
  
  const { name, number } = request.body;
  
  if (!(name && number)) {
    return response.status(400).json({
      error: 'Name and number are required.'
    })
  }

  const id = request.params.id;
  const person = { name, number };

  Person.findByIdAndUpdate(
    id, person, { new: true, runValidators: true, context: 'query' }
  ).then(updatedPerson => {
      if (!updatedPerson) {
        return response.status(404).json({
          error: 'Person not found.'
        })
      }
      response.json(updatedPerson)
    })
    .catch(error => next(error));
});
```

## Ruta desconocida

```javascript
const unknowEndpoint = (request, response) => {
  response.status(404).json({ error: 'unknow endpoint'})
}

app.use(unknowEndpoint);
```

## Manejador de errores

```javascript
const errorHandler = (error, request, response, next) => {
  if (error.name === 'CastError') {
    return response.status(400).json({ error: 'Incorrect format id.' });

  } else if (error.name === 'ValidationError') {

    const fieldsWithError = Object.keys(error.errors);
    const errors = [];

    fieldsWithError.forEach(field => {

      if (field === 'name') {
        const { kind } = error.errors.name;
        
        switch (kind) {
          case 'required':
            errors.push('The name is required.');
            break;
          case 'minlength':
            errors.push('The name must have at least 3 characters.');
            break;
          default:
            errors.push('Incorrect name format.');
            break;
        }
      }

      if (field === 'number') {
        const { kind } = error.errors.number;
        
        switch (kind) {
          case 'required':
            errors.push('The number is required.');
            break;
          case 'minlength':
            errors.push('The number must have at least 8 digits.')
            break;
          case 'user defined':
            errors.push('Wrong number format, try something like 12-1234567 or 123-12345678.');
            break;
          default:
            errors.push('Incorrect number format.');
            break;
        }
      } 
    });
    
    return response.status(400).json({ error: errors.join(' ') });
  }

  next(error);
}

app.use(errorHandler);
```

## Iniciar app

Estamos utilizando el puerto definido en la variable de entorno `PORT` o el puerto 3001 si la variable de entorno PORT no está definida. Fly.io y Render configuran el puerto de la aplicación en función de esa variable de entorno.

```javascript
const PORT = process.env.PORT || 3001

app.listen(PORT, () => {
  console.log(`Server running in port ${PORT}`);
});
```

# Optimizando el despliegue del frontend

Una opción para implementar el frontend es copiar la compilación de producción (el directorio `dist`) a la raíz del repositorio del backend y configurar el backend para que muestre la página principal del frontend (el archivo `dist/index.html`) como su página principal.


Para crear una nueva compilación de producción del frontend sin trabajo manual adicional, agreguemos algunos scripts npm al `package.json` del repositorio de backend.

```json
{
  "scripts": {
    //...
    "build:ui": "rm -rf dist && cd ../frontend && npm run build && cp -r dist ../backend",
    "deploy:full": "npm run build:ui && git add . && git commit -m uibuild && git push"
  }
}
```

En Windows, los scripts de `npm` se ejecutan en `cmd.exe` como la shell predeterminada, que no admite comandos `bash`. Para que funcionen los comandos bash anteriores, puedes cambiar la shell predeterminada a Bash (en la instalación estándar de Git para Windows) de la siguiente manera:

```bash
npm config set script-shell "C:\\Program Files\\Git\\bin\\bash.exe""
```

Los scripts anteriores funcionan esta estructura del proyecto, modifica los scripts para que coincidan con el tuyo:
```
proyecto_raiz/
├── frontend/
└── backend/
```

---

# ESLint

Genéricamente, `lint` o `linter` es cualquier herramienta que detecta y marca errores en los lenguajes de programación, incluidos los errores de estilo. El término comportamiento lint-like a veces se aplica al proceso de marcar el uso de lenguaje sospechoso. Las herramientas de tipo lint generalmente realizan análisis estáticos del código fuente.


En el universo de JavaScript, la herramienta líder actual para el análisis estático (también conocida como "linting") es `ESlint`.


Podemos instalar y configurar ESLint usando este comando:

```bash
pnpm create @eslint/config@latest
```

Al ejecutar `pnpm create @eslint/config@latest`, se hacen una serie de preguntas para determinar cómo se está usando ESLint y qué opciones debería incluir. Tras responderlas, se creará un archivo `eslint.config.js` (o `eslint.config.mjs`) en su directorio.


Por ejemplo, una de las preguntas es "¿Dónde se ejecuta su código?". Si selecciona "Navegador", su archivo de configuración contendrá las definiciones de las variables globales de los navegadores web. Aquí tiene un ejemplo:

```javascript
import { defineConfig } from "eslint/config";
import globals from "globals";
import js from "@eslint/js";

export default defineConfig([
	{ files: ["**/*.js"], languageOptions: { globals: globals.browser } },
	{ files: ["**/*.js"], plugins: { js }, extends: ["js/recommended"] },
]);

```

La configuración `"js/recommended"` garantiza que se activen todas las reglas marcadas como recomendadas en la página de reglas. `ESLint` no analizará su código a menos que extienda una configuración compartida o active las reglas explícitamente en su configuración.





























