# Guía de Next.js
Fuente: [nextjs.org](https://nextjs.org/learn/dashboard-app/getting-started)

## Tabla de Contenido
1. [¿Qué es Next.js?](#qué-es-nextjs)
2. [Creando un nuevo proyecto](#creando-un-nuevo-proyecto)
3. [Estructura de carpetas](#estructura-de-carpetas)
4. [Ejecución del servidor](#ejecución-del-servidor-de-desarrollo)
5. [Optimización de fuentes e imágenes](#optimización-de-fuentes-e-imágenes)
6. [Enrutamiento](#enrutamiento)
7. [Navegando entre páginas](#navegando-entre-páginas)
8. [Obteniendo datos](#obteniendo-datos)
9. [Renderizado estático y dinámico](#renderizado-estático-y-dinámico)
10. [Streaming](#streaming)

## ¿Qué es Next.js?
 Next.js es un framework de React de código abierto desarrollado por Vercel.  Mientras que React es una librería para construir interfaces de usuario, Next.js es un framework completo que añade funcionalidades esenciales para aplicaciones web en producción, como renderizado del lado del servidor, enrutamiento automático, optimización de rendimiento y mucho más.

## Creando un nuevo proyecto
Se recomienda utilizar `pnpm` como gestor de paquetes, ya que es más rápido y eficiente que npm o yarn. Si no lo tiene instalado, se puede instalar globalmente ejecutando:
```bash
npm install -g pnpm
```

Para crear una aplicación Next.js, abra su terminal, acceda al directorio donde desea guardar el proyecto y ejecute el siguiente comando:
```bash
npx create-next-app@latest nextjs-dashboard --example "https://github.com/vercel/next-learn/tree/main/dashboard/starter-example" --use-pnpm
```

Este comando usa `create-next-app`, una herramienta de interfaz de línea de comandos (CLI) que configura automáticamente una aplicación Next.js. En el comando anterior, también se usa la bandera `--example` con un ejemplo de inicio.

## Estructura de carpetas

Después de la instalación, abra el proyecto en su editor de código y navegue hasta nextjs-dashboard.
```bash
cd nextjs-dashboard
```
Notará que el proyecto tiene la siguiente estructura de carpetas:

<img width="707" alt="image" src="https://github.com/user-attachments/assets/ecce5420-4dd8-41e8-a20e-cc3a01eaf441" />

- `/app`: Contiene todas las rutas, componentes y lógica para su aplicación; aquí es donde trabajará la mayor parte del tiempo.
- `/app/lib`: Contiene funciones utilizadas en su aplicación, como funciones de utilidad reutilizables y funciones de obtención de datos.
- `/app/ui`: Contiene todos los componentes de la interfaz de usuario de su aplicación, como tarjetas, tablas y formularios. Para ahorrarle tiempo, hemos prediseñado estos componentes.
- `/public`: Contiene todos los activos estáticos para su aplicación, como imágenes.
- **Archivos de configuración** : También encontrará archivos de configuración, como los que next.config.tsse encuentran en la raíz de su aplicación. La mayoría de estos archivos se crean y preconfiguran al iniciar un nuevo proyecto con create-next-app.

## Ejecución del servidor de desarrollo

Instale los paquetes del proyecto:
```bash
pnpm i
```
Ahora inicie el servidor de desarrollo:
```
pnpm dev
```
El servidor de desarrollo se ha iniciado en el puerto `3000`, compruebe si funciona abriendo `http://localhost:3000` en su navegador.

## Optimización de fuentes e imágenes

### ¿Por qué optimizar las fuentes?
`Cambio de diseño acumulativo` es una métrica que Google utiliza para evaluar el rendimiento y la experiencia del usuario de un sitio web. En el caso de las fuentes, el cambio de diseño se produce cuando el navegador inicialmente muestra el texto en una fuente de respaldo o del sistema y, una vez cargado, la reemplaza por una fuente personalizada. Este cambio puede provocar cambios en el tamaño, el espaciado o el diseño del texto, desplazando los elementos a su alrededor.

<img width="709" alt="image" src="https://github.com/user-attachments/assets/0b5542f6-3719-4d10-80a4-606b10c74bcc" />

Next.js optimiza automáticamente las fuentes de la aplicación al usar el módulo `next/font`. Descarga los archivos de fuentes durante la compilación y los aloja con el resto de tus recursos estáticos. Esto significa que, cuando un usuario visita tu aplicación, no hay solicitudes de red adicionales para las fuentes que afecten al rendimiento.

### Agregar una fuente principal
Agreguemos una fuente de Google personalizada a su aplicación para ver cómo funciona. En la carpeta `/app/ui`, crea un archivo llamado `fonts.ts`.

Importe la fuente `Inter` del módulo `next/font/google`: esta será la fuente principal. Luego, especifique el subconjunto que desea cargar, en este caso 'latin':
```javascript
import { Inter } from 'next/font/google';
 
export const inter = Inter({ subsets: ['latin'] });
```

Por último, se añade la fuente al elemento `<body>` para aplicar la fuente a toda la app:
```javascript
import '@/app/ui/global.css';
import { inter } from '@/app/ui/fonts';
 
export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={`${inter.className} antialiased`}>{children}</body>
    </html>
  );
}
```
Next.js puede servir recursos estáticos, como imágenes, en la carpeta de nivel superior `/public`. Los archivos que contiene pueden referenciarse en la aplicación.

Con HTML normal, agregarías una imagen de la siguiente manera:
```html
<img
  src="/hero.png"
  alt="Screenshots of the dashboard project showing desktop version"
/>
```
### El componente `<Image />`
El componente `<Image>` es una extensión de la etiqueta `<img>` HTML y viene con optimización automática de imágenes, como:

- Evitar el cambio de diseño automático cuando se cargan las imágenes.
- Cambiar el tamaño de las imágenes para evitar enviar imágenes grandes a dispositivos con una ventana gráfica más pequeña.
- Carga diferida de imágenes de forma predeterminada (las imágenes se cargan a medida que ingresan a la ventana gráfica).
- Sirviendo imágenes en formatos modernos, como `WebP` y `AVIF`, cuando el navegador lo admita.

Por ejemplo:
```javascript
import Image from 'next/image';
 
export default function Page() {
  return (
    <div>
      <Image
        src="/hero-desktop.png"
        width={1000}
        height={760}
        className="hidden md:block"
        alt="Screenshots of the dashboard project showing desktop version"
      />
    </div>
  );
}
```
Aquí, se configuran los valores de `width` a 1000 y `height` a 760 en píxeles. Es recomendable configurar los valores de `width` y `height` en las imágenes para evitar cambios de diseño. Estos valores deben tener una relación de aspecto idéntica a la de la imagen original. Estos valores *no* representan el tamaño de la imagen renderizada, sino el tamaño del archivo de imagen real utilizado para comprender la relación de aspecto.

### Lectura recomendada
Hay mucho más que aprender sobre estos temas, como la optimización de imágenes remotas y el uso de archivos de fuentes locales. Si desea profundizar en el tema de las fuentes y las imágenes, consulte:
- [Documentos de optimización de imágenes](https://nextjs.org/docs/app/building-your-application/optimizing/images)
- [Documentos de optimización de fuentes](https://nextjs.org/docs/app/building-your-application/optimizing/fonts)
- [Mejorar el rendimiento web con imágenes (MDN)](https://developer.mozilla.org/en-US/docs/Learn/Performance/Multimedia)
- [Fuentes web (MDN)](https://developer.mozilla.org/en-US/docs/Learn/CSS/Styling_text/Web_fonts)
- [Cómo afectan los core Web Vitals al CEO](https://vercel.com/blog/how-core-web-vitals-affect-seo)
- [Cómo gestiona Google Javascript durante el proceso de indexación](https://vercel.com/blog/how-google-handles-javascript-throughout-the-indexing-process)

## Enrutamiento
Cada carpeta representa un segmento de URL.

<img width="706" alt="image" src="https://github.com/user-attachments/assets/aef06dc4-42cc-49b8-9ca0-1040d9ebdf82" />

En cada carpeta debe existir un archivo `page.tsx` para que el segmento de la URL sea accesible.

<img width="707" alt="image" src="https://github.com/user-attachments/assets/67ea59ea-38d0-414b-9d1f-2ebb026a150a" />

Al agregar un archivo especial `layout.tsx` en una carpeta que representa un segmento de URL, se crea un diseño compartido para las páginas (`<page.tsx`) adentro de esa carpeta.

El componente `<Layout />` recibe una propiedad `children`, las paginas (`page.tsx`) internas de un segmento se anidaran automáticamente como la propiedad `children` de `<Layout />`.
<img width="707" alt="image" src="https://github.com/user-attachments/assets/810eb2bf-5b74-4b11-b99d-95110f81c856" />

Usando diseños (`layout.tsx`) en Next, durante la navegación, solo se actualizan los componentes de página (`page.tsx`), mientras que el diseño (`layout.tsx`) no se vuelve a renderizar. Esto se denomina renderizado parcial. 

<img width="704" alt="image" src="https://github.com/user-attachments/assets/9b21f52f-1294-44ab-8cc7-b7ef6fa58ada" />

## Navegando entre páginas

Next.js divide automáticamente el código de la aplicación por segmentos de ruta. Según la ruta que se visite se cargará el código correspondiente. 

En una SPA de React tradicional, el navegador carga todo el código de la aplicación en la carga inicial de la página.

En producción, siempre que los componentes `<Link>` aparecen en la ventana gráfica del navegador, Next precarga automáticamente el código de la ruta enlazada en segundo plano.

Next proporciona el hook `usePathname()` para obtener la URL actual. Para utilizarlo, el componente debe contener la directiva `"use client"` al inicio.

## Obteniendo datos

De forma predeterminada, las aplicaciones Next.js usan componentes de servidor de React.

Los componentes de servidor admiten promesas de JavaScript, lo que proporciona una solución nativa para tareas asíncronas como la obtención de datos.

Los componentes del servidor se ejecutan en el servidor, por lo que se puede mantener la costosa obtención de datos y la lógica en el servidor, enviando solo el resultado al cliente.

Dado que los componentes de servidor se ejecutan en el servidor, puede consultar la base de datos directamente sin una capa de API adicional.

Una "cascada" es una secuencia de solicitudes de red que dependen de la finalización de las solicitudes anteriores. Cada solicitud solo puede comenzar una vez que la solicitud anterior haya devuelto datos.

<img width="710" alt="image" src="https://github.com/user-attachments/assets/47be0143-06fb-478d-98a2-2db616517bda" />

## Renderizado estático y dinámico

Con la representación estática, la obtención y representación de datos se realiza en el servidor en el momento de la **compilación** (cuando se implementa) o al revalidar los datos. Cada vez que un usuario visita la aplicación, se muestra el resultado almacenado en caché.

Con la renderización dinámica, el contenido se renderiza en el **servidor** para cada usuario en el **momento de la solicitud** (cuando el usuario visita la página). 

## Streaming

La transmisión es una técnica de transferencia de datos que permite dividir una ruta en "fragmentos" más pequeños y transmitirlos progresivamente desde el servidor al cliente a medida que estén listos.

<img width="707" alt="image" src="https://github.com/user-attachments/assets/637ceffd-2af5-4a49-8185-9ed9d658edfc" />

Los fragmentos se procesan en paralelo, lo que reduce el tiempo de carga general.

Al transmitir, se evita que las solicitudes de datos lentas bloqueen toda la página. Esto permite al usuario ver e interactuar con partes de la página sin tener que esperar a que se carguen todos los datos.

Hay dos formas de implementar la transmisión en Next.js:

- A nivel de página, con el archivo `loading.tsx`  (crea `<Suspense>` automáticamente).
- A nivel de componentes, con <Suspense> para un control más granular.

### Transmitiendo una página completa con `loading.tsx`
`loading.tsx` es un archivo especial de Next.js basado en React Suspense. Al agregarlo en un segmento de ruta. Permite crear una interfaz de usuario alternativa para un segmento de URL mientras se carga el contenido de la página.

### Grupos de rutas
Dado que `loading.tsx` esta en un nivel superior a `/invoices/page.tsx` y `/customers/page.tsx` en el sistema de archivos, también se aplica a esas páginas.

Podemos cambiar esto con **Grupos de Rutas**. Cree una nueva carpeta `/(overview)` dentro de la carpeta del panel. Luego, mueva sus archivos `loading.tsx` y `page.tsx` dentro de ella:
<img width="702" alt="image" src="https://github.com/user-attachments/assets/f91018ac-4669-47e2-aabb-765d1f8753bb" />

Ahora, el archivo `loading.tsx` solo se aplicará a la página de descripción general de su panel de control.

Los grupos de rutas permiten organizar archivos en grupos lógicos sin afectar la estructura de la ruta URL. Al crear una carpeta nueva con paréntesis (), el nombre no se incluirá en la ruta URL. Por lo tanto, `/dashboard/(overview)/page.tsx` se convierte en `/dashboard`.
<img width="709" alt="image" src="https://github.com/user-attachments/assets/ae047828-1289-4358-91d0-e1fdada3c153" />

### Transmisión de un componente
Hasta ahora, se transmitió una página completa. Pero también puedes ser más específico y transmitir componentes específicos con React `Suspense`.

`Suspense` permite aplazar la renderización de partes de la aplicación hasta que se cumpla una condición (por ejemplo, la carga de datos). Puedes encapsular tus componentes dinámicos en Suspense. Luego, pásale un componente de reserva para que se muestre mientras se carga el componente dinámico.

Por ejemplo:
```javascript
import { Suspense } from 'react';
import { ComponentSkeleton } from '@/app/ui/skeletons';
import Component from '@/app/ui/Component';

export default Page(){
  return(
    <Suspense fallback={<ComponentSkeleton />}>
    <Component />
    </Suspense>
  )
}
```
La ubicación de los límites de suspense variará según la aplicación. En general, se recomienda mover las búsquedas de datos a los componentes que las necesitan y luego encapsularlos en Suspense. Sin embargo, no hay problema en transmitir las secciones o la página completa si así lo requiere la aplicación.

## Prerenderizado parcial
La prerenderización parcial es una función experimental introducida en Next.js 14. El contenido de esta página puede actualizarse a medida que la función se estabilice. La prerenderización parcial solo está disponible con las versiones canarias de Next.js ( next@canary), no en la versión estable. Aún no recomendamos su uso en producción.

Para instalar la versión Canary de Next.js, ejecute:
```bash
pnpm install next@canary
```

### Rutas estáticas vs. dinámicas
En la mayoría de las aplicaciones web desarrolladas hoy en día, se puede elegir entre renderizado estático o dinámico para toda la aplicación o para una ruta específica . En Next.js, si se llama a una función dinámica en una ruta (como al consultar la base de datos), toda la ruta se vuelve dinámica.

Sin embargo, la mayoría de las rutas no son completamente estáticas ni dinámicas. Por ejemplo, considere un sitio de comercio electrónico.Es posible que desees renderizar estáticamente la mayor parte de la página de información del producto, pero también puedes querer obtener el carrito del usuario y los productos recomendados dinámicamente; esto te permite mostrar contenido personalizado a tus usuarios.

### ¿Qué es la pre-renderización parcial?
Next.js 14 introdujo una versión experimental de Prerenderizado Parcial : un nuevo modelo de renderizado que permite combinar las ventajas del renderizado estático y dinámico en una misma ruta. Por ejemplo:

<img width="707" alt="image" src="https://github.com/user-attachments/assets/01fc6cac-9ebf-4e57-8531-896c0857dc2b" />
Cuando un usuario visita una ruta:

Se proporciona un shell de ruta estática que incluye la barra de navegación y la información del producto, lo que garantiza una carga inicial rápida.
El shell deja espacios donde el contenido dinámico, como el carrito y los productos recomendados, se cargarán de forma asincrónica.
Los agujeros asincrónicos se transmiten en paralelo, lo que reduce el tiempo de carga general de la página.

### ¿Cómo funciona la pre-renderización parcial?
La prerenderización parcial utiliza `Suspense` de React(que aprendiste en el capítulo anterior) para diferir la representación de partes de tu aplicación hasta que se cumpla alguna condición (por ejemplo, se carguen los datos).

El respaldo de Suspense se integra en el archivo HTML inicial junto con el contenido estático. Durante la compilación (o la revalidación), el contenido estático se pre-renderiza para crear un shell estático. La renderización del contenido dinámico se pospone hasta que el usuario solicita la ruta.

Envolver un componente en `Suspense` no hace que el componente en sí sea dinámico, sino que Suspense se utiliza como un límite entre su código estático y dinámico.

### Implementación de prerenderizado parcial
Habilite PPR para su aplicación Next.js agregando la opción `ppr` a su archivo `next.config.ts`:
```javascript
import type { NextConfig } from 'next';
 
const nextConfig: NextConfig = {
  experimental: {
    ppr: 'incremental'
  }
};
 
export default nextConfig;
```
El valor 'incremental' le permite adoptar `PPR` para rutas específicas.

A continuación, agregue la opción de configuración del segmento `experimental_ppr` al diseño de su panel:
```javascript
import SideNav from '@/app/ui/dashboard/sidenav';
 
export const experimental_ppr = true;
 
// ...
```
Eso es todo. Puede que no notes ninguna diferencia en tu aplicación durante el desarrollo, pero deberías notar una mejora en el rendimiento en producción. Next.js pre-renderizará las partes estáticas de tu ruta y pospondrá las partes dinámicas hasta que el usuario las solicite.

Lo mejor del prerenderizado parcial es que no necesitas modificar el código para usarlo. Mientras uses Suspense para encapsular las partes dinámicas de tu ruta, Next.js sabrá qué partes de tu ruta son estáticas y cuáles dinámicas.

## Agregar búsqueda y paginación

### ¿Por qué utilizar parámetros de búsqueda de URL?
Usará parámetros de búsqueda de URL para administrar el estado de la búsqueda. Este patrón puede ser nuevo si está acostumbrado a hacerlo con el estado del lado del cliente.

Implementar la búsqueda con parámetros de URL tiene un par de beneficios:

- **URL que se pueden marcar y compartir**: dado que los parámetros de búsqueda están en la URL, los usuarios pueden marcar el estado actual de la aplicación, incluidas sus consultas de búsqueda y filtros, para futuras referencias o compartir.
- **Representación del lado del servidor**: los parámetros de URL se pueden consumir directamente en el servidor para representar el estado inicial, lo que facilita el manejo de la representación del servidor.
- **Análisis y seguimiento**: tener consultas de búsqueda y filtros directamente en la URL facilita el seguimiento del comportamiento del usuario sin necesidad de lógica adicional del lado del cliente.

### Añadiendo la funcionalidad de búsqueda
Estos son los ganchos de cliente Next.js para implementar la funcionalidad de búsqueda:

- `useSearchParams` permite acceder a los parámetros de la URL actual. Por ejemplo, los parámetros de búsqueda para esta URL `/dashboard/invoices?page=1&query=pending` serían los siguientes: `{page: '1', query: 'pending'}`.
- `usePathname` permite leer la ruta de la URL actual. Por ejemplo, para la ruta `/dashboard/invoices`, `usePathname` devolvería '/dashboard/invoices'.
`useRouter` permite la navegación entre rutas dentro de los componentes del cliente mediante programación. Existen varios métodos que se pueden utilizar.

A continuación se ofrece una descripción general rápida de los pasos de implementación:

- Capturar la entrada del usuario.
- Actualice la URL con los parámetros de búsqueda.
- Mantenga la URL sincronizada con el campo de entrada.
- Actualice la tabla para reflejar la consulta de búsqueda.

### 1. Capturar la entrada del usuario
Para usar escuchas y ganchos de eventos se debe escribir `"use client"` al inicio de un componente.

Poe ejemplo al crear una nueva función y agrega un detector `onChange` al elemento `<input>`. `onChange` se invocará siempre que cambie el valor de entrada.
```javascript
'use client';
 
export default function Search({ placeholder }: { placeholder: string }) {
  function handleSearch(term: string) {
    console.log(term);
  }
 
  return (
    <div>
      <input
        onChange={(e) => {
          handleSearch(e.target.value);
        }}
      />
    </div>
  );
}
```

### 2. Actualice la URL con los parámetros de búsqueda.
Importe el hook `useSearchParams` desde `next/navigation` y asígnalo a una variable:
```javascript
'use client';

import { useSearchParams } from 'next/navigation';
 
export default function Search() {
  const searchParams = useSearchParams(); // uso de UseSearParams
 
  function handleSearch(term: string) {
    console.log(term);
  }
  // ...
}
```

Dentro  de `handleSearch`, crea una nueva instacia de `URLSearchParams` usando la variable `searchParams`.
```javascript
'use client';
 
import { MagnifyingGlassIcon } from '@heroicons/react/24/outline';
import { useSearchParams } from 'next/navigation';
 
export default function Search() {
  const searchParams = useSearchParams();
 
  function handleSearch(term: string) {
    const params = new URLSearchParams(searchParams); // nueva instancia de URLSearchParams
  }
  // ...
}
```

`URLSearchParams` es una API web que proporciona métodos de utilidad para manipular los parámetros de consulta de URL. En lugar de crear una cadena literal compleja, puede usarla para obtener la cadena de parámetros como `?page=1&query=a`.

A continuación, configure la cadena de parámetros según la entrada del usuario. Si la entrada está vacía, deberá eliminarla:
```javascript
'use client';
 
import { useSearchParams } from 'next/navigation';
 
export default function Search() {
  const searchParams = useSearchParams();
 
  function handleSearch(term: string) {
    const params = new URLSearchParams(searchParams);
    if (term) {
      params.set('query', term); // Se actualiza el parametro "query"
    } else {
      params.delete('query'); // Se elimina "quey"
    }
  }
  // ...
}
```

Ahora que tienes la cadena de consulta, puedes usar los ganchos `useRouter` y `usePathname` de Next.js para actualizar la URL.

Importa `useRouter` y `usePathname` desde `'next/navigation'` y usa el método `replace` de `useRouter()` dentro de `handleSearch`.
```javascript
'use client';
 
import {
 useSearchParams,
 usePathname,
 useRouter
} from 'next/navigation'; 
 
export default function Search() {
  const searchParams = useSearchParams();
  const pathname = usePathname();
  const { replace } = useRouter(); // se obtiene la función "replace"
 
  function handleSearch(term: string) {
    const params = new URLSearchParams(searchParams);
    if (term) {
      params.set('query', term);
    } else {
      params.delete('query');
    }
    replace(`${pathname}?${params.toString()}`); // Se cambia la URL
  }
}
```

A continuación un resumen de lo que está sucediendo:

- `${pathname}` es la ruta actual, en su caso.
- A medida que el usuario escribe en la barra de búsqueda, `params.toString()` traduce esta entrada a un formato compatible con URL.
- `replace(${pathname}?${params.toString()})` actualiza la URL con los datos de búsqueda del usuario. Por ejemplo, `/dashboard/invoices?query=rodrigo` si el usuario busca "Rodrigo".
- Finalmente la URL se actualiza sin recargar la página, gracias a la navegación del lado del cliente de Next.js.

### 3. Mantener la URL y la entrada sincronizadas
Para garantizar que el campo de entrada esté sincronizado con la URL y se completará al compartir, puede pasar un `defaultValue` a la entrada leyendo desde `searchParams`:
```javascript
<input
  onChange={(e) => {
    handleSearch(e.target.value);
  }}
  defaultValue={searchParams.get('query')?.toString()}
/>
```

### 4. Actualización de la tabla
Por último, debe actualizar una tabla para reflejar la consulta de búsqueda.

Los componentes de página (`page.tsx`) aceptan una propiedad llamada `searchParams` , por lo que puedes pasar los parámetros de la URL actual al `<Table>` componente.

**Por ejemplo:**
```javascript
import Search from '@/app/ui/search';
import Table from '@/app/ui/invoices/table';
import { Suspense } from 'react';
import { InvoicesTableSkeleton } from '@/app/ui/skeletons';
 
export default async function Page(props: {
  searchParams?: Promise<{
    query?: string;
    page?: string;
  }>;
}) {
  const searchParams = await props.searchParams; // parametros de búsqueda
  const query = searchParams?.query || ''; // se obtiene el parámetro "query"
  const currentPage = Number(searchParams?.page) || 1; // se obtiene el parametro "page"
 
  return (
    <div className="w-full">
      <div className="mt-4 flex items-center justify-between gap-2 md:mt-8">
        <Search placeholder="Search invoices..." /> {/* barra de búsqueda  */}
      </div>
      <Suspense key={query + currentPage} fallback={<InvoicesTableSkeleton />}> {/* se envuelte <Table> con <Suspense> */}
        <Table query={query} currentPage={currentPage} />
      </Suspense>
      <div className="mt-5 flex w-full justify-center">
      </div>
    </div>
  );
}
```

### Mejor práctica: Antirrebote
Se actualiza la URL con cada pulsación de tecla y, por lo tanto, consultas tu base de datos con cada pulsación. Esto no supone un problema en una aplicación pequeña, pero imagina que tu aplicación tuviera miles de usuarios, cada uno de los cuales enviara una nueva solicitud a tu base de datos con cada pulsación de tecla.

La eliminación de rebotes es una práctica de programación que limita la velocidad de ejecución de una función. En nuestro caso, solo se desea consultar la base de datos cuando el usuario deja de escribir.

Cómo funciona el rebote:

- **Evento desencadenante**: cuando se produce un evento que debe rebotarse (como una pulsación de tecla en el cuadro de búsqueda), se inicia un temporizador.
- **Esperar**: si ocurre un nuevo evento antes de que expire el temporizador, éste se reinicia.
- **Ejecución**: Si el temporizador llega al final de su cuenta regresiva, se ejecuta la función antirrebote.

Puedes implementar la función de rebote de varias maneras, incluyendo la creación manual de tu propia función. Para simplificar, usaremos una biblioteca llamada `use-debounce`.
```bash
pnpm i use-debounce
```

En el componente de la barra de búsqueda, importe una función llamada `useDebouncedCallback`:
```bash
// ...
import { useDebouncedCallback } from 'use-debounce';
 
// dentro del componente de búsqueda...
const handleSearch = useDebouncedCallback((term) => {
  console.log(`Searching... ${term}`);
 
  const params = new URLSearchParams(searchParams);
  if (term) {
    params.set('query', term);
  } else {
    params.delete('query');
  }
  replace(`${pathname}?${params.toString()}`);
}, 300);
```

Esta función envolverá el contenido de `handleSearch` y solo ejecutará el código después de un tiempo específico una vez que el usuario haya dejado de escribir (300 ms).

Al eliminar el rebote, puede reducir la cantidad de solicitudes enviadas a su base de datos, ahorrando así recursos.

## TEMAS PENDIENTES

Optimización de imágenes y fuentes.
En Next.js, puedes crear puntos finales de API utilizando controladores de ruta.

