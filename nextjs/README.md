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

## Prerenderizado parcial
### Rutas estáticas vs. dinámicas
En la mayoría de las aplicaciones web desarrolladas hoy en día, se puede elegir entre renderizado estático o dinámico para toda la aplicación o para una ruta específica . En Next.js, si se llama a una función dinámica en una ruta (como al consultar la base de datos), toda la ruta se vuelve dinámica.

Sin embargo, la mayoría de las rutas no son completamente estáticas ni dinámicas. Por ejemplo, considere un sitio de comercio electrónico.Es posible que desees renderizar estáticamente la mayor parte de la página de información del producto, pero también puedes querer obtener el carrito del usuario y los productos recomendados dinámicamente; esto te permite mostrar contenido personalizado a tus usuarios.

## TEMAS PENDIENTES

Optimización de imágenes y fuentes.
En Next.js, puedes crear puntos finales de API utilizando controladores de ruta.

