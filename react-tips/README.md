# Consejos sobre React

## Índice

1. [¿Dónde usar los hooks?](#dónde-usar-los-hooks)
2. [Componentes dentro de componentes](#no-definir-componentes-dentro-de-los-componentes)
3. [¿Qué es una Promesa?](#qué-es-una-promesa)
4. [Virtual DOM](url)

---




# 1. ¿Dónde usar los hooks?

**No** se deben llamar desde dentro de un `loop`, una expresión condicional (`if`) o cualquier lugar que no sea una función que defina a un componente. Esto debe hacerse para garantizar que los hooks siempre se llamen en el mismo orden o, si este no es el caso, la aplicación se comportará de manera errática.

En resumen, los hooks solo se pueden llamar desde el interior de un cuerpo de **la función que define un componente de React**.

---

# 2. No definir componentes dentro de los componentes

**Nunca** definas **componentes dentro de otros componentes**. El método no proporciona beneficios y da lugar a muchos problemas desagradables. Los mayores problemas se deben al hecho de que React trata un componente definido dentro de otro componente como un nuevo componente en cada render. Esto hace imposible que React optimice el componente.

---

# 3. ¿Qué es una Promesa?

Una promesa es un objeto que `representa una operación asíncrona`. Una promesa puede tener tres estados distintos:

- La promesa está `pendiente`: significa que el valor final (uno de los dos siguientes) aún no está disponible.
- La promesa está `cumplida`: Significa que la operación se ha completado y el valor final está disponible, que generalmente es una operación exitosa. Este estado a veces también se denomina resuelto.
- La promesa es `rechazada`: Significa que un error impidió determinar el valor final, que generalmente representa una operación fallida.

---

# 4. Virtual DOM

El `DOM virtual` de React es una **representación en memoria del DOM real** que actúa como una capa de abstracción entre tu código y las manipulaciones directas del DOM del navegador.

## ¿Qué es el DOM virtual?

El DOM virtual es una estructura de datos en JavaScript que describe cómo debería verse la interfaz de usuario. Es una copia "virtual" del DOM real que React mantiene en memoria como objetos JavaScript simples.

## 1. Renderizado inicial
Cuando tu componente se renderiza por primera vez, React crea una representación virtual de toda la estructura del DOM.

## 2. Cambios de estado
Cuando el estado de un componente cambia, React crea un nuevo árbol del DOM virtual que refleja el estado actualizado.

## 3. Algoritmo de diffing
React compara (hace "diff") el nuevo árbol virtual con la versión anterior para identificar exactamente qué cambió.

## 4. Reconciliación
React calcula el conjunto mínimo de cambios necesarios para actualizar el DOM real.

## 5. Actualización del DOM
Finalmente, React aplica solo los cambios necesarios al DOM real, no toda la estructura.

### Ejemplo conceptual

Imagina que tienes una lista de tareas y agregas una nueva. En lugar de recrear toda la lista en el DOM, React:

1. Detecta que solo se agregó un elemento
2. Calcula que solo necesita insertar un nuevo `<li>`
3. Realiza únicamente esa inserción en el DOM real











