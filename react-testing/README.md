## Instalaciones

Comencemos instalando Vitest y la librería jsdom que simula un navegador web:

```bash
pnpm install --save-dev vitest jsdom
```
Además de Vitest, también necesitamos otra librería de pruebas que nos ayudará a renderizar componentes para fines de prueba. La mejor opción actual para esto es **react-testing-library**, que ha visto un rápido crecimiento en popularidad recientemente. También vale la pena extender el poder expresivo de las pruebas con la librería **jest-dom**.

Instalemos las librerías con el comando:

```bash
pnpm install --save-dev @testing-library/react @testing-library/jest-dom
```

Resumen de instalaciones:

- `vitest` => framework principal para los tests.
- `jsdom` => simula el DOM de un navegador web.
- `@testing-library/react` => renderiza componentes de React en el DOM simulado.
- `@testing-library/jest-dom` => añade métodos para realizar pruebas.

# Configuraciones

Agregamos un script al archivo `package.json` para ejecutar las pruebas:

```json
{
  "scripts": {
    //...
    "test": "vitest run"
  }
  //...
}
```

Vamos a crear un archivo `testSetup.js` en la raíz del proyecto con el siguiente contenido:

 ```javascript
 import { afterEach } from 'vitest'
 import { cleanup } from '@testing-library/react'
 import '@testing-library/jest-dom/vitest'

 afterEach(() => {
  cleanup();
 })
 ```

Ahora, luego de cada prueba, la función cleanup es ejecutada para resetear jsdom, que esta simulando al navegador.

Expandamos el archivo `vite.config.js` de la siguiente manera:

```javascript
export default defineConfig({
  //...
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './testSetup.js'
  }
})
```
Con globals: true, no es necesario importar palabras clave como `describe`, `test` y `expect` en las pruebas.

Resumen de configuraciones:

- Agregar un script en `package.json` para ejecutar los tests.
- Crear un archivo que se ejecuta automáticamente antes de todas las pruebas. Su propósito es preparar el entorno de testing y establecer comportamientos comunes.
- Definir el entorno de las pruebas (jsdom), permitir el uso de funciones comunes para el testing sin necesidad de importarlas, y establecer que archivos se ejecutan antes de las pruebas.
