# Cosas que considero útiles para React

## Índice
1. [useIsMobile](#useismobile)

## useIsMobile()
```javascript
import { useState, useEffect } from "react"

const MOBILE_BREAKPOINT = 768

export function useIsMobile() {
  const [isMobile, setIsMobile] = useState<boolean | undefined>(undefined)

  useEffect(() => {
    const mql = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`)
    const onChange = () => {
      setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    }
    mql.addEventListener("change", onChange)
    setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    return () => mql.removeEventListener("change", onChange)
  }, [])

  return !!isMobile
}
```

## Desglose
### 1. Constante
- La constante `MOBILE_BREAKPOINT` con valor 768 píxeles, que es el punto de quiebre común entre dispositivos móviles y tablets/desktop.
```javascript
const MOBILE_BREAKPOINT = 768
```

### 2. Estado interno
```javascript
const [isMobile, setIsMobile] = React.useState<boolean | undefined>(undefined)
```
- Crea un estado local con useState.
- El tipo es boolean | undefined (puede ser verdadero, falso o indefinido).
- Inicializa como undefined para manejar el renderizado del lado del servidor.

### 3. Effect para detectar cambios de tamaño
```javascript
useEffect(() => {
  const mql = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`)
```
- `useEffect` se ejecuta cuando el componente se monta.
- `window.matchMedia()` crea una consulta de medios CSS para detectar cuando la pantalla es menor a 767px (768-1).

### ¿Qué retorna `matchMedia()`?
Retorna un objeto `MediaQueryList` con propiedades como:
```javascript
{
  matches: true/false,     // Si la consulta coincide actualmente
  media: "(max-width: 767px)", // La consulta original
  addEventListener: function,   // Para escuchar cambios
  removeEventListener: function // Para remover listeners
}
```

### 4. Función de cambio
```javascript
const onChange = () => {
  setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
}
```
- Define una función que actualiza el estado `isMobile`.
- Compara el ancho actual de la ventana con el breakpoint (768px).

### 5. Listeners de eventos
```javascript
mql.addEventListener("change", onChange)
setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
return () => mql.removeEventListener("change", onChange)
```
- Agrega un listener para detectar cambios en el tamaño de pantalla.
- Establece el valor inicial inmediatamente.
- Retorna una función de limpieza que remueve el listener cuando el componente se desmonta.

### ¿Qué hace esta línea?
```javascript
mql.addEventListener("change", onChange)
```
Recordemos que `mql` es un objeto `MediaQueryList` que representa la consulta `(max-width: 767px)`:
- `change` es el único evento que dispara un MediaQueryList.
- Se ejecuta cuando la consulta de medios cambia de true a false o viceversa.
- NO se ejecuta en cada cambio de tamaño, solo cuando se cruza el umbral.
- La función `onChange` se ejecutará cuando ocurra el cambio.

### ¿Cuándo se dispara exactamente `change`?
```javascript
// Escenario 1: Pantalla cambia de 800px a 700px
// Antes: mql.matches = false (800 > 767)
// Después: mql.matches = true (700 < 767)
// ✅ Se dispara el evento "change"

// Escenario 2: Pantalla cambia de 500px a 400px  
// Antes: mql.matches = true (500 < 767)
// Después: mql.matches = true (400 < 767)
// ❌ NO se dispara (ambos son true)

// Escenario 3: Pantalla cambia de 700px a 800px
// Antes: mql.matches = true (700 < 767)
// Después: mql.matches = false (800 > 767)
// ✅ Se dispara el evento "change"
```

### 6. Valor de retorno
```javascript
return !!isMobile
```
- Usa el operador de doble negación `!!` para convertir `undefined` a `false`.
- Retorna `true` si es móvil, `false` si no lo es.



