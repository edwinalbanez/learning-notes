# Programación Orientada a Objetos en PHP

# Índice

1. [Clases y objetos](#)

---

# 1. Clases y objetos
Una Clase es el plano arquitectónico de una casa, y el Objeto es la casa física construida a partir de ese plano. Puedes construir 100 casas (objetos) usando el mismo plano (clase).

- `Clase`: Define las propiedades (datos) y métodos (comportamiento).
- `Objeto`: Es una "instancia" única de esa clase.

```php
class Coche {
  public string $marca;
  public string $modelo;

  public function arrancar(){
    return "El $this->marca $this->modelo esta arrancando...";
  }
}

$miCoche = new Coche();
$miCoche->marca = "Toyota";
$miCoche->modelo = "Corolla";
echo $miCoche->arrancar();
```

---

# 2. Los 4 pilares de la POO

## A. Encapsulamiento (Visibilidad)
Se trata de proteger el estado interno del objeto. No queremos que cualquiera modifique datos sensibles directamente. Usamos modificadores de acceso:

`public`: Acceso desde cualquier lugar.

`protected`: Acceso solo desde la propia clase o clases que heredan de ella.

`private`: Acceso únicamente dentro de la clase donde se definió.

>[!NOTE]
> Siempre empieza por `private` o `protected`. Solo haz algo `public` si es estrictamente necesario. Esto se conoce como el principio de menor privilegio.

## B. Herencia
Permite que una clase (hija) herede propiedades y métodos de otra (padre). En PHP se usa la palabra clave `extends`.

```php
<?php

class Vehiculo {
  public function tocarClaxon (){
    return "¡Beep beep!";
  }
}

class Motocicleta extends Vehiculo {
  //Motocicleta ya tiene el método "tocarClaxon"
}
```

## C. Abstracción
Sirve para ocultar la complejidad. Se define "qué" hace un objeto, pero no necesariamente "cómo". Para esto se usan clases abstractas e interfaces.

### Clases abstractas
Una clase abstracta es una clase que no se puede instanciar (no puedes crear un objeto directamente con new ClaseAbstracta()). Su único propósito es ser heredada por otras clases (clases hijas).

Se utiliza para definir una estructura común y obligar a las clases hijas a implementar ciertos métodos, garantizando que todas compartan un comportamiento base.

#### Métodos Abstractos
Un método abstracto es una declaración de una función que obliga a la clase hija a definir su lógica. Es como decir: "No sé exactamente cómo lo harás, pero prometo que cualquier hijo mío sabrá hacer esto".

#### Ejemplo
Imagina que estás desarrollando un sistema para una veterinaria. Todos los animales hacen un sonido, pero un "Animal" genérico no suena a nada; un "Perro" o un "Gato" sí.

```php
<?php

abstract class Animal {
  protected string $nombre;
  
  public function __construct(string $nombre){
    $this->nombre = $nombre;
  }

  //método normal, todos los animales respiran igual
  public function respirar(){
    return "$this->nombre esta respirando...";
  }

  //método abstracto, cada animal suena distinto
  abstract public function hacerSonido();

}

//clases hijas que extienden de la clase abstracta
class Perro extends Animal {
  public function hacerSonido(){
    return "$this->nombre hace ¡guau!";
  }
}

class Gato extends Animal {
  public function hacerSonido(){
    return "$this->nombre hace ¡miau!";
  }
}

$miPerro = new Perro("Bruno");
echo $miPerro->respirar(); //Bruno está respirando
echo "\n";
echo $miPerro->hacerSonido(); //Bruno hace ¡guau!
```

>[!NOTE]
> La clase `Perro` no tiene definido un método `__construct()`, por lo tanto, se llama automáticamente al constructor del padre (`Animal`).

### Interfaces
Es un contrato puro. No puede tener lógica, solo define qué métodos deben existir. Una clase puede implementar múltiples interfaces.

```php
<?php

interface Exportable {
  public function exportar(): string;
}

class ReporteVentas implements Exportable {
  public function exportar(): string {
    return "Exportando a CSV...";
  }
}
```

