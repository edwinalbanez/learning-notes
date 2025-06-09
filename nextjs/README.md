# Anotaciones sobre Next.js

## Enrutamiento

Cada carpeta representa un segmento de URL.
<img width="706" alt="image" src="https://github.com/user-attachments/assets/c7790b79-8329-4b08-8a82-53d1fba8a16e" />

En cada carpeta debe existir un archivo `page.tsx` para que el segmento de la URL sea accesible.
<img width="707" alt="image" src="https://github.com/user-attachments/assets/07e5e858-b6d1-42e6-89c2-d33f2eb6306d" />

Al agregar un archivo especial `layout.tsx` en una carpeta que representa un segmento de URL, se crea un diseño compartido para las páginas (`<page.tsx`) adentro de esa carpeta.

El componente `<Layout />` recibe una propiedad `children`, las paginas (`page.tsx`) internas de un segmento se anidaran automáticamente como la propiedad `children` de `<Layout />`.
<img width="707" alt="image" src="https://github.com/user-attachments/assets/8720920c-9ee2-46f0-af65-f65ce1cb038f" />

Usando diseños (`layout.tsx`) en Next, durante la navegación, solo se actualizan los componentes de página (`page.tsx`), mientras que el diseño (`layout.tsx`) no se vuelve a renderizar. Esto se denomina renderizado parcial.
<img width="703" alt="image" src="https://github.com/user-attachments/assets/49da7e3a-7bec-488e-83a3-714ba8b34909" />

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
<img width="710" alt="image" src="https://github.com/user-attachments/assets/c8aaa70c-650c-43e8-82a2-2ef0a491bd8b" />

## Renderizado estático y dinámico

Con la representación estática, la obtención y representación de datos se realiza en el servidor en el momento de la **compilación** (cuando se implementa) o al revalidar los datos.

Cada vez que un usuario visita la aplicación, se muestra el resultado almacenado en caché.

Con la renderización dinámica, el contenido se renderiza en el **servidor** para cada usuario en el **momento de la solicitud** (cuando el usuario visita la página). 

## Streaming

La transmisión es una técnica de transferencia de datos que permite dividir una ruta en "fragmentos" más pequeños y transmitirlos progresivamente desde el servidor al cliente a medida que estén listos.
<img width="706" alt="image" src="https://github.com/user-attachments/assets/88a6dc5b-4a7c-44ed-9641-8b43f632319e" />

Los fragmentos se procesan en paralelo, lo que reduce el tiempo de carga general.

Al transmitir, se evita que las solicitudes de datos lentas bloqueen toda la página. Esto permite al usuario ver e interactuar con partes de la página sin tener que esperar a que se carguen todos los datos.

Hay dos formas de implementar la transmisión en Next.js:

- A nivel de página, con el archivo `loading.tsx`  (crea `<Suspense>` automáticamente).
- A nivel de componentes, con <Suspense> para un control más granular.

`loading.tsx` s un archivo especial de Next.js basado en React Suspense. Permite crear una interfaz de usuario alternativa mientras se carga el contenido de la página.

Los grupos de rutas permiten organizar archivos en grupos lógicos sin afectar la estructura de la ruta URL. Al crear una carpeta nueva con paréntesis (), el nombre no se incluirá en la ruta URL. Por lo tanto, /dashboard/(overview)/page.tsxse convierte en /dashboard.

<img width="712" alt="image" src="https://github.com/user-attachments/assets/4212e9bc-0b8e-4939-8fa7-89d363064254" />

## TEMAS PENDIENTES

Optimización de imágenes y fuentes.
En Next.js, puedes crear puntos finales de API utilizando controladores de ruta.







