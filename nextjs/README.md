# Anotaciones sobre Next.js

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

Con la representación estática, la obtención y representación de datos se realiza en el servidor en el momento de la **compilación** (cuando se implementa) o al revalidar los datos.

Cada vez que un usuario visita la aplicación, se muestra el resultado almacenado en caché.

Con la renderización dinámica, el contenido se renderiza en el **servidor** para cada usuario en el **momento de la solicitud** (cuando el usuario visita la página). 

## Streaming

La transmisión es una técnica de transferencia de datos que permite dividir una ruta en "fragmentos" más pequeños y transmitirlos progresivamente desde el servidor al cliente a medida que estén listos.
<img width="707" alt="image" src="https://github.com/user-attachments/assets/637ceffd-2af5-4a49-8185-9ed9d658edfc" />

Los fragmentos se procesan en paralelo, lo que reduce el tiempo de carga general.

Al transmitir, se evita que las solicitudes de datos lentas bloqueen toda la página. Esto permite al usuario ver e interactuar con partes de la página sin tener que esperar a que se carguen todos los datos.

Hay dos formas de implementar la transmisión en Next.js:

- A nivel de página, con el archivo `loading.tsx`  (crea `<Suspense>` automáticamente).
- A nivel de componentes, con <Suspense> para un control más granular.

`loading.tsx` s un archivo especial de Next.js basado en React Suspense. Permite crear una interfaz de usuario alternativa mientras se carga el contenido de la página.

Los grupos de rutas permiten organizar archivos en grupos lógicos sin afectar la estructura de la ruta URL. Al crear una carpeta nueva con paréntesis (), el nombre no se incluirá en la ruta URL. Por lo tanto, /dashboard/(overview)/page.tsxse convierte en /dashboard.

<img width="709" alt="image" src="https://github.com/user-attachments/assets/ae047828-1289-4358-91d0-e1fdada3c153" />

## TEMAS PENDIENTES

Optimización de imágenes y fuentes.
En Next.js, puedes crear puntos finales de API utilizando controladores de ruta.







