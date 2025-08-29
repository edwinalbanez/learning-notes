# Consejos sobre React

## Índice

1. [¿Dónde usar los hooks?](#dónde-usar-los-hooks)
2. [Componentes dentro de componentes](#no-definir-componentes-dentro-de-los-componentes)


---




# ¿Dónde usar los hooks?

**No** se deben llamar desde dentro de un `loop`, una expresión condicional (`if`) o cualquier lugar que no sea una función que defina a un componente. Esto debe hacerse para garantizar que los hooks siempre se llamen en el mismo orden o, si este no es el caso, la aplicación se comportará de manera errática.

En resumen, los hooks solo se pueden llamar desde el interior de un cuerpo de **la función que define un componente de React**.

---

# No definir componentes dentro de los componentes

**Nunca** definas **componentes dentro de otros componentes**. El método no proporciona beneficios y da lugar a muchos problemas desagradables. Los mayores problemas se deben al hecho de que React trata un componente definido dentro de otro componente como un nuevo componente en cada render. Esto hace imposible que React optimice el componente.

























