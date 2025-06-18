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
### constante
- La constante `MOBILE_BREAKPOINT` con valor 768 píxeles, que es el punto de quiebre común entre dispositivos móviles y tablets/desktop.
```javascript
const MOBILE_BREAKPOINT = 768
```

### Estado interno
```javascript
const [isMobile, setIsMobile] = React.useState<boolean | undefined>(undefined)
```
- Crea un estado local con useState.
- El tipo es boolean | undefined (puede ser verdadero, falso o indefinido).
- Inicializa como undefined para manejar el renderizado del lado del servidor.

### Effect para detectar cambios de tamaño
```javascript
useEffect(() => {
  const mql = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`)
```
- `useEffect` se ejecuta cuando el componente se monta.
- `window.matchMedia()` crea una consulta de medios CSS para detectar cuando la pantalla es menor a 767px (768-1).

### Función de cambio
```javascript
const onChange = () => {
  setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
}
```
- Define una función que actualiza el estado `isMobile`.
- Compara el ancho actual de la ventana con el breakpoint (768px).

### Listeners de eventos
```javascript
mql.addEventListener("change", onChange)
setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
return () => mql.removeEventListener("change", onChange)
```
- Agrega un listener para detectar cambios en el tamaño de pantalla.
- Establece el valor inicial inmediatamente.
- Retorna una función de limpieza que remueve el listener cuando el componente se desmonta.




