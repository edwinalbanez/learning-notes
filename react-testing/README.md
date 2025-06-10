# Testing en React 
Fuente: [FullStackOpen](https://fullstackopen.com/es/part5/probando_aplicaciones_react)

## Tabla de Contenido
1. [Instalaciones](#instalaciones)
2. [Configuración](#configuración)
3. [Renderizando componentes](#renderizando-el-componente-para-pruebas)
4. [Ubicación del archivo de pruebas](#ubicación-del-archivo-de-pruebas)
5. [Buscar contenido en componentes](#búsqueda-de-contenido-en-un-componente)
6. [Depurando pruebas](#depurando-pruebas)
7. [Hacer click](#clicando-botones-en-las-pruebas)
8. [Probando formularios](#probando-formularios)
9. [Cobertura de las pruebas](#cobertura-de-las-pruebas)

## Instalaciones
Comencemos instalando Vitest y la librería jsdom que simula un navegador web:
```bash
npm install --save-dev vitest jsdom
```
Además de Vitest, también necesitamos otra librería de pruebas que nos ayudará a renderizar componentes para fines de prueba. La mejor opción actual para esto es **react-testing-library**, que ha visto un rápido crecimiento en popularidad recientemente. También vale la pena extender el poder expresivo de las pruebas con la librería **jest-dom**.

Instalemos las librerías con el comando:
```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom
```
Resumen de instalaciones:

- `vitest` ➡️ framework principal para los tests.
- `jsdom` ➡️ simula el DOM de un navegador web.
- `@testing-library/react` ➡️ renderiza componentes de React en el DOM simulado.
- `@testing-library/jest-dom` ➡️ añade métodos para realizar pruebas.

## Configuración
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

El último import extiende el uso de Vitest con matchers específicos para DOM. Añade métodos como `toBeInTheDocument()`, `toHaveClass()`, `toBeVisible()`, etc.

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

## Renderizando el componente para pruebas
Tomaremos como ejemplo este componente para renderizar una nota:
```javascript
const Note = ({ note, toggleImportance }) => {
  const { content, important } = note;
  const label = important
    ? 'make not important'
    : 'make important'

  return (

    <li className='note'>
      { content }
      <button onClick={toggleImportance}> { label } </button>
    </li>
  )
}
```
El elemento `li` tiene el valor "note" para el atributo de CSS className, que se usa para acceder al componente en las pruebas.

El archivo para las prueba será `Note.test.jsx`.

La primera prueba verifica que el componente muestra el contenido de la nota:
```javascript
import { render, screen } from '@testing-library/react'
import Note from './Note'

test('renders content', () => {
  const note = {
    content: 'Component testing is done with react-testing-library',
    important: true
  }

  render(<Note note={note} />)

  const element = screen.getByText('Component testing is done with react-testing-library')
  expect(element).toBeDefined()
})
```
- La prueba renderiza el componente con el método render proporcionado por react-testing-library:
```javascript
render(<Note note={note} />)
```
- Podemos usar el objeto `screen` para acceder al componente renderizado.
```javascript
  const element = screen.getByText('Component testing is done with react-testing-library')
  expect(element).toBeDefined()
```
- Utilizamos el método `getByText` de `screen` para buscar un elemento que tenga el contenido de la nota y asegurarnos de que existe.
- La existencia de un elemento se verifica utilizando el comando `expect` de Vitest.
- `expect` genera una aserción para su argumento, cuya validez se puede probar utilizando varias funciones de condición.
- Ahora utilizamos `toBeDefined` que prueba si el argumento element de expect existe.

Problemas de Eslint con las palabras clave `test` y `expect` en las pruebas:
```bash
npm install --save-dev eslint-plugin-vitest-globals
```
y habilitando el plugin al editar el archivo .eslint.cjs de la siguiente manera:
```javascript
module.exports = {
  root: true,
  env: {
    browser: true,
    es2020: true,

    "vitest-globals/env": true
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react/jsx-runtime',
    'plugin:react-hooks/recommended',

    'plugin:vitest-globals/recommended',
  ],
  // ...
}
```

 El test se ejecuta con el comando:
 ```bash
npm test
```

## Ubicación del archivo de pruebas
En React hay (al menos) dos convenciones diferentes para la ubicación de los archivos de prueba:
- Colocar los archivos de prueba en el mismo directorio que el componente que se esta probando. (configuración predeterminada por Vite)
- Almacenar los archivos de prueba "normalmente" en su propio directorio separado llamado `test`. (me gusta más)

## Búsqueda de contenido en un componente

`react-testing-library` ofrece muchas formas de investigar el contenido del componente. En realidad, el expect en la prueba anterior no es necesario en absoluto ya que la prueba falla si getByText no encuentra el elemento que está buscando.:
```javascript
expect(element).toBeDefined()
```

También es posible usar selectores CSS para encontrar elementos renderizados mediante el uso del método `querySelector` del objeto `container`, que es uno de los elementos devueltos por el renderizado. La nueva version del test es:
```javascript
import { render, screen } from '@testing-library/react'
import Note from './Note'

test('renders content', () => {
  const note = {
    content: 'Component testing is done with react-testing-library',
    important: true
  }


  const { container } = render(<Note note={note} />)


  const div = container.querySelector('.note')
  expect(div).toHaveTextContent(
    'Component testing is done with react-testing-library'
  )
})
```

Una forma más consistente de seleccionar elementos es usando un atributo de datos que esté específicamente definido para propósitos de prueba. 
Usando `react-testing-library`, podemos aprovechar el método `getByTestId` para seleccionar elementos con un atributo `data-testid` especificado:
```html
<div data-testid="custom-element" >
```
```javascript
import {screen} from '@testing-library/dom'

const element = screen.getByTestId('custom-element')
```

## Depurando pruebas
El objeto `screen` tiene el método `debug` que se puede utilizar para imprimir en la terminal todo el HTML que se ha renderizado.
```javascript
screen.debug();
```

También es posible utilizar el mismo método para imprimir el elemento que queramos en la consola:
```javascript
const element = screen.getByText("Some text");
screen.debug(element);
```

## Clicando botones en las pruebas
La librería `user-event` simula la interacción del usuario:
```bash
npm install --save-dev @testing-library/user-event
```

El componente `<Note />` recibe una propiedad llamada `toggleImportance` que es una función para cambiar el estado de una nota.
```javascript
import { render, screen } from '@testing-library/react'

import userEvent from '@testing-library/user-event'
import Note from './Note'

// ...

test('clicking the button calls event handler once', async () => {
  const note = {
    content: 'Component testing is done with react-testing-library',
    important: true
  }
  const mockHandler = vi.fn()

  render(<Note note={note} toggleImportance={mockHandler} />)

  const user = userEvent.setup()
  const button = screen.getByText('make not important')
  await user.click(button)

  expect(mockHandler.mock.calls).toHaveLength(1)
})
```
Hay algunas cosas interesantes relacionadas con esta prueba. el valor de `toggleImportance` es una función simulada o falsa creada con Vitest:
```javasctipt
const mockHandler = vi.fn()
```
Se inicia una session (sesión) para interactuar con el componente renderizado:
```javascript
const user = userEvent.setup()
```
La prueba encuentra el botón basada en el texto del componente renderizado y hace clic en el elemento:
```javascript
const button = screen.getByText('make not important')
await user.click(button)
```
El clic ocurre con el método click de la librería userEvent.

La expectativa de la prueba utiliza toHaveLength para verificar que la mock function (función simulada) se haya llamado exactamente una vez:
```javascript
expect(mockHandler.mock.calls).toHaveLength(1)
```

Las llamadas a la mock function son guardadas en el array mock.calls dentro del objeto de la mock function.

En Vitest, estas tres funciones son fundamentales para organizar y estructurar tus pruebas:

`describe`: Agrupa pruebas relacionadas bajo un contexto común. Es útil para organizar múltiples tests que evalúan una misma funcionalidad o componente.
```javascript
describe('Calculator', () => {
  test('should add two numbers', () => {
    // test code
  })
  
  test('should subtract two numbers', () => {
    // test code
  })
})
```

`beforeEach`: Se ejecuta antes de cada test individual dentro del bloque donde se define. Es ideal para configurar el estado inicial que necesita cada prueba.
```javascript
describe('User service', () => {
  let user;
  
  beforeEach(() => {
    user = { name: 'John', age: 25 }
    // Esta configuración se ejecuta antes de cada test
  })
  
  test('should update user name', () => {
    // user ya está disponible y configurado
  })
  
  test('should update user age', () => {
    // user se reinicia para este test también
  })
})
```
`afterEach`: Se ejecuta después de cada test individual. Se usa para limpiar recursos, resetear mocks, o cualquier tarea de limpieza necesaria.
```javascript
describe('Database tests', () => {
  beforeEach(() => {
    // Configurar conexión a DB de prueba
  })
  
  afterEach(() => {
    // Limpiar datos de prueba
    // Cerrar conexiones
    // Resetear mocks
  })
  
  test('should save user', () => {
    // test code
  })
})
```

## Probando formularios
También podemos simular la entrada de texto con `userEvent`.

Se puede encontrar un elemento a partir de su función en la interfaz con el método `getByRole`:
```javascript
const input = screen.getByRole("textbox");
```

Sin embargo, si existe mas de un elemento `input`, lo anterior generaría un error. Una forma más fácil de encontrar elementos es por su `placeholder` .
```javascript
render(<Login />);

const usernameInput = screen.getByPlaceholderText("Correo electrónico o usuario");
const passwordIntput = screen.getByPlaceholderText("Contraseña");
const loginButton = screen.getByText("Login");

await user.type(usernameInput, "helloworld26");
await user.type(passwordIntput, "admin123");
await user.click(loginButton);
```
El método `type` de userEvent se utiliza para escribir texto en el campo de input.

La forma más flexible de encontrar elementos en pruebas es el método `querySelector` del objeto container, que es devuelto por el método `render`. Se puede usar cualquier selector CSS con este método para buscar elementos en las pruebas:
```javascript
const { container } = render(<Login />);
const input = container.querySelector("#password-input")
```
`render` por defecto crea un elemento `div` y lo añadirá a `document.body` del DOM, en este div es donde se representará el componente de React.

Si desea que `contanier` sea un elemento HTML diferente de `div`, no será añadido al `document.body` automáticamente.

Por ejemplo: si realiza una prueba unitaria de un elemento `tablebody`, este no puede ser hijo de un div. En este caso, puede especificar una tabla como contenedor de renderizado:
```javascript
const table = document.createElement('table')

const {container} = render(<TableBody {...props} />, {
  container: document.body.appendChild(table),
})
```

Supongamos que un componente renderiza texto en un elemento HTML de la siguiente manera:
```html
<h1>Hello World! :)</h1>
```

El método `getByText` no encuentra al elemento en esta prueba:
```javascript
const element = screen.getByText("Hello")

expect(element).toBeDefined()
```

El método `getByText` busca a un elemento que tenga exactamente el mismo texto que se proporciona como parámetro, y nada más. Si queremos buscar un elemento que contenga el texto, podríamos usar una opción adicional:
```javascript
const element = screen.getByText(
  "hello", { exact: false }
)
```
o podríamos usar el método findByText:
```javascript
const element = await screen.findByText("Hello")
```

Es importante tener en cuenta que, a diferencia de los otros métodos `ByText`, `findByText` ¡devuelve una promesa!

Existen situaciones en las que otra forma del método `queryByText` es útil. El método devuelve el elemento pero no genera una excepción si no se lo encuentra.
```javascript
const element = screen.queryByText("another text");
expect(element).toBeNull();
```

## Cobertura de las pruebas
Podemos encontrar fácilmente la cobertura de nuestras pruebas ejecutándolas con el comando:
```bash
npm test -- --coverage
```

La primera vez que ejecutes el comando, Vitest te preguntará si quieres instalar la librería requerida `@vitest/coverage-v8`. Instálala y ejecuta el comando de nuevo:

<img width="556" alt="image" src="https://github.com/user-attachments/assets/a8627276-0141-4853-b140-26d3c3809f47" />

Se generará un informe HTML en el directorio coverage. El informe nos dirá las líneas de código no probado en cada componente:

<img width="557" alt="image" src="https://github.com/user-attachments/assets/d73c3652-5770-446b-8c27-d8ce75f6c990" />
