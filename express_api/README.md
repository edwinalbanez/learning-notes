# ¿Cómo crear una API en Express?

## índice


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


Hagamos un pequeño cambio en el objeto `scripts` agregando un nuevo comando de script:
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
