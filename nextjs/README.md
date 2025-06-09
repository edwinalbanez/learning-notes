# Anotaciones sobre Next.js

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

Por último, añada la fuente al elemento `<body>` en `/app/layout.tsx`:
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







