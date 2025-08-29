# Consejos sobre React

## Índice

1. [¿Dónde usar los hooks?]()







# ¿Dónde usar los hooks?

**No** se debe llamar desde dentro de un `loop`, una expresión condicional (`if`) o cualquier lugar que no sea una función que defina a un componente. Esto debe hacerse para garantizar que los hooks siempre se llamen en el mismo orden o, si este no es el caso, la aplicación se comportará de manera errática.

En resumen, los hooks solo se pueden llamar desde el interior de un cuerpo de **la función que define un componente de React**.
