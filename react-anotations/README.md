# Anotaciones sobre React

>[!IMPORTANT]
>Estas son anotaciones personales para comprender mejor algunos temas de React

## Índice
1. [¿Qué es un re-render?](#qué-es-un-re-render)
2. [useCallback](#usecallback)
3. [useMemo](#usememo)

---
## ¿Qué es un re-render?
Un **re-render** es cuando React ejecuta nuevamente la función del componente y recalcula todo su JSX. Esto incluye:

- Ejecutar toda la lógica del componente.
- Recrear variables y funciones.
- Ejecutar hooks como `useMemo`, `useEffect` (si sus dependencias cambiaron).
- Generar el nuevo árbol de elementos React.
- Comparar con el render anterior (reconciliación).
- Actualizar el DOM si es necesario.

### Ejemplo visual del problema:
```javascript
function Parent() {
  const [count, setCount] = useState(0);
  
  // Esta función se RECREA en cada render
  const handleClick = () => {
    console.log('Clicked!');
  };

  console.log('Parent rendered'); // Se ejecuta en cada render

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>
        Count: {count}
      </button>
      <Child onClick={handleClick} />
    </div>
  );
}

function Child({ onClick }) {
  console.log('Child rendered'); // ¡Se ejecuta aunque NADA cambió en Child!
  
  // Simulemos que Child hace trabajo costoso
  const expensiveCalculation = () => {
    let result = 0;
    for (let i = 0; i < 1000000; i++) {
      result += i;
    }
    return result;
  };

  const result = expensiveCalculation(); // ¡Se ejecuta en cada re-render!

  return (
    <div>
      <p>Expensive result: {result}</p>
      <button onClick={onClick}>Child Button</button>
    </div>
  );
}
```

### Lo que pasa paso a paso:
1. **Render inicial**: Parent y Child se renderizan
2. **Usuario hace click en "Count"**:
- `count` cambia de 0 a 1.
- Parent se re-renderiza (normal, su state cambió).
- `handleClick` se recrea (nueva función, nueva referencia en memoria).
- `Child` recibe `onClick` con nueva referencia.
- React piensa: "Child recibió props diferentes, debo re-renderizarlo"
- `Child` se re-renderiza y ejecuta `expensiveCalculation()` otra vez.

### Visualizando las referencias de funciones:
```javascript
function Parent() {
  const [count, setCount] = useState(0);
  
  const handleClick = () => console.log('Clicked!');
  
  // En cada render, handleClick es una nueva función:
  // Render 1: handleClick = función_A (referencia: 0x001)
  // Render 2: handleClick = función_B (referencia: 0x002)  
  // Render 3: handleClick = función_C (referencia: 0x003)
  
  return <Child onClick={handleClick} />;
}
```

### Solución con useCallback:
```javascript
function Parent() {
  const [count, setCount] = useState(0);
  
  // La función mantiene la MISMA referencia entre renders
  const handleClick = useCallback(() => {
    console.log('Clicked!');
  }, []); // Sin dependencias = nunca se recrea

  console.log('Parent rendered');

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>
        Count: {count}
      </button>
      <Child onClick={handleClick} />
    </div>
  );
}

// IMPORTANTE: Para que funcione, Child debe estar memoizado
const Child = React.memo(function Child({ onClick }) {
  console.log('Child rendered'); // Solo se ejecuta cuando es necesario
  
  const expensiveCalculation = () => {
    let result = 0;
    for (let i = 0; i < 1000000; i++) {
      result += i;
    }
    return result;
  };

  const result = expensiveCalculation(); // Solo se ejecuta cuando Child realmente re-renderiza

  return (
    <div>
      <p>Expensive result: {result}</p>
      <button onClick={onClick}>Child Button</button>
    </div>
  );
});
```
>[!IMPORTANT]
> ### *`RESUMEN`*
>Siempre que un componente `Padre` se re-renderiza, tambien lo hacen todos los componentes `Hijos`, sin importar si las propiedades de los hijos realmente cambiaron. React no compara propiedades por defecto, simplemente re-renderiza todos los hijos.
>
>Para evitar re-renderizados innecesarios, se usa *`React.memo`* que:
>- Memoriza el resultado del renderizado del componente.
>- Compara las props actuales con las anteriores usando comparación superficial.
>- Solo re-renderiza el componente cuando las propiedades realmente han cambiado.
>
>Para que *`React.memo`* funcione, las propiedades que reciben los componentes deben estar memorizadas con [useCallback](#usecallback) o [useMemo](#usememo)

---
## useCallback
Es un hook que memoriza una función y solo la recrea si sus dependencias cambian.

### Sintaxis
```javascript
// useCallback - memoriza la función
const memoizedFunction = useCallback(() => {
  // lógica de la función
}, [dependencies]);
```

### ¿Cuándo usarlo?
**useCallback** es útil cuando:

### 1. Pasas funciones como props a componentes hijos
### Problema sin useCallback:
```javascript
function Parent() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState('');

  // Esta función se recrea en CADA render del Parent
  const handleButtonClick = () => {
    console.log('Button clicked!');
  };

  return (
    <div>
      <input 
        value={name} 
        onChange={(e) => setName(e.target.value)} 
      />
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      
      {/* Child se re-renderiza aunque handleButtonClick no cambió lógicamente */}
      <Child onClick={handleButtonClick} />
    </div>
  );
}

function Child({ onClick }) {
  console.log('Child rendered'); // Se ejecuta en cada render del Parent
  return <button onClick={onClick}>Child Button</button>;
}
```
En este ejemplo, cada vez que escribes en el input o incrementas el contador, `handleButtonClick` se recrea como una nueva función, causando que `Child` se re-renderice innecesariamente.

### Solución con useCallback:
```javascript
function Parent() {
  const [count, setCount] = useState(0);
  const [name, setName] = useState('');

  // La función solo se recrea si cambian sus dependencias (array vacío = nunca)
  const handleButtonClick = useCallback(() => {
    console.log('Button clicked!');
  }, []);

  return (
    <div>
      <input 
        value={name} 
        onChange={(e) => setName(e.target.value)} 
      />
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      
      {/* Child NO se re-renderiza porque onClick es la misma referencia */}
      <Child onClick={handleButtonClick} />
    </div>
  );
}

// Para que esto funcione completamente, Child debe estar memoizado
const Child = React.memo(function Child({ onClick }) {
  console.log('Child rendered'); // Solo se ejecuta cuando onClick realmente cambia
  return <button onClick={onClick}>Child Button</button>;
});
```

### 2. Evitar renders innecesarios con React.memo 
>[!NOTE]
>*Esto es prácticamente otro ejemplo del punto anterior.*

`React.memo` compara las props por referencia. Sin `useCallback`, las funciones siempre son "diferentes":

```javascript
function ExpensiveChild({ data, onUpdate }) {
  console.log('ExpensiveChild rendered');
  
  // Simulamos un componente costoso
  const expensiveCalculation = useMemo(() => {
    return data.reduce((sum, item) => sum + item.value, 0);
  }, [data]);

  return (
    <div>
      <p>Result: {expensiveCalculation}</p>
      <button onClick={onUpdate}>Update</button>
    </div>
  );
}

// Memoizamos el componente
const MemoizedExpensiveChild = React.memo(ExpensiveChild);

function Parent() {
  const [items, setItems] = useState([{id: 1, value: 10}]);
  const [otherState, setOtherState] = useState(0);

  // Sin useCallback: se recrea en cada render
  const handleUpdate = useCallback(() => {
    setItems(prev => [...prev, {id: Date.now(), value: Math.random() * 100}]);
  }, []);

  return (
    <div>
      <button onClick={() => setOtherState(otherState + 1)}>
        Other State: {otherState}
      </button>
      
      {/* Sin useCallback, este componente se re-renderizaría 
          cada vez que otherState cambia */}
      <MemoizedExpensiveChild 
        data={items} 
        onUpdate={handleUpdate} 
      />
    </div>
  );
}
```

### 3. La función es dependencia de otros hooks

### useEffect con función como dependencia:
```javascript
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [posts, setPosts] = useState([]);

  // Sin useCallback, esta función se recrea en cada render
  const fetchUserData = useCallback(async () => {
    const userData = await fetch(`/api/users/${userId}`).then(r => r.json());
    setUser(userData);
  }, [userId]); // Se recrea solo cuando userId cambia

  const fetchUserPosts = useCallback(async () => {
    const postsData = await fetch(`/api/users/${userId}/posts`).then(r => r.json());
    setPosts(postsData);
  }, [userId]);

  // useEffect depende de fetchUserData
  useEffect(() => {
    fetchUserData();
  }, [fetchUserData]); // Sin useCallback, esto se ejecutaría en cada render

  // Otro useEffect que también depende de funciones
  useEffect(() => {
    if (user) {
      fetchUserPosts();
    }
  }, [user, fetchUserPosts]);

  return (
    <div>
      {user && <h1>{user.name}</h1>}
      <ul>
        {posts.map(post => (
          <li key={post.id}>{post.title}</li>
        ))}
      </ul>
    </div>
  );
}
```

### ¿Cuándo NO usarlo?
- La clave es recordar que `useCallback` solo es útil cuando la **estabilidad de referencia** de la función importa para el rendimiento de tu aplicación.
- No uses `useCallback` para funciones que **NO** se pasan como props o dependencias.

---
## useMemo
Es un hook que optimiza valores calculados. Memoriza el resultado de un cálculo costoso y solo lo recalcula si sus dependencias cambian.

```javascript
/ useMemo - memoriza el resultado
const memoizedValue = useMemo(() => {
  return expensiveCalculation();
}, [dependencies]);
```

### ¿Cuándo usarlo?
`useMemo` es útil cuando:
- Tienes cálculos costosos que no deben ejecutarse en cada render.
- Quieres memorizar objetos o arrays complejos.
- El valor calculado es una dependencia de otros hooks.

```javascript
function Component({ data, filter }) {
  // Cálculo costoso que solo se ejecuta si data o filter cambian
  const filteredData = useMemo(() => {
    return data.filter(item => item.category === filter)
      .sort((a, b) => a.name.localeCompare(b.name));
  }, [data, filter]);

  return <ExpensiveList items={filteredData} />;
}
```

### ¿Cuándo NO usarlo?
- No uses `useMemo` para valores simples o cálculos triviales.
- La regla general es: usa `useCallback` para funciones y `useMemo` para valores calculados.


