# ¿Cómo crear una API con Express?

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


Hagamos un pequeño cambio en el objeto `scripts` agregando un nuevo comando de script llamado `start`:
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
npm install express
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
npm update
```

## Web y Express

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

# Recibiendo información

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















