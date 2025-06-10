# Guía Completa de Playwright

## Tabla de contenido
1. [¿Qué es Playwright?](#qué-es-playwright)
2. [Instalación](#instalación)
3. [Configuración Básica](#configuración-básica)
4. [Conceptos Fundamentales](#conceptos-fundamentales)
5. [Ejemplos Prácticos](#ejemplos-prácticos)
6. [Funcionalidades Avanzadas](#funcionalidades-avanzadas)
7. [Debugging y Troubleshooting](#debugging-y-troubleshooting)
8. [Mejores Prácticas](#mejores-prácticas)
9. [Comandos Útiles](#comanfos-Útiles)

## ¿Qué es Playwright?

Playwright es una biblioteca de automatización de navegadores desarrollada por Microsoft que permite escribir pruebas end-to-end confiables y rápidas. Soporta múltiples navegadores (Chromium, Firefox, Safari) y lenguajes de programación (JavaScript, TypeScript, Python, Java, .NET).

## Instalación

### Instalación con npm (JavaScript/TypeScript)

```bash
# Crear un nuevo proyecto
npm init playwright@latest

# O instalar en un proyecto existente
npm install -D @playwright/test
npx playwright install
```

## Configuración Básica

### Archivo de configuración `playwright.config.js`

```javascript
// playwright.config.js
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
});
```

## Conceptos Fundamentales

### 1. Test Básico

```javascript
import { test, expect } from '@playwright/test';

test('mi primera prueba', async ({ page }) => {
  await page.goto('https://playwright.dev/');
  await expect(page).toHaveTitle(/Playwright/);
});
```

### 2. Navegación

```javascript
test('navegación básica', async ({ page }) => {
  // Ir a una página
  await page.goto('https://example.com');
  
  // Navegar hacia atrás
  await page.goBack();
  
  // Navegar hacia adelante
  await page.goForward();
  
  // Recargar página
  await page.reload();
});
```

### 3. Selectores

Playwright ofrece múltiples estrategias para seleccionar elementos:

```javascript
test('selectores', async ({ page }) => {
  await page.goto('https://example.com');
  
  // Por texto
  await page.getByText('Click me').click();
  
  // Por rol
  await page.getByRole('button', { name: 'Submit' }).click();
  
  // Por placeholder
  await page.getByPlaceholder('Enter your email').fill('test@example.com');
  
  // Por label
  await page.getByLabel('Password').fill('secretpassword');
  
  // Por test id
  await page.getByTestId('submit-button').click();
  
  // CSS selector
  await page.locator('.submit-btn').click();
  
  // XPath
  await page.locator('//button[@type="submit"]').click();
});
```

### 4. Interacciones con Elementos

```javascript
test('interacciones', async ({ page }) => {
  await page.goto('https://example.com');
  
  // Click
  await page.getByRole('button').click();
  
  // Doble click
  await page.getByRole('button').dblclick();
  
  // Click derecho
  await page.getByRole('button').click({ button: 'right' });
  
  // Hover
  await page.getByRole('button').hover();
  
  // Llenar campos de texto
  await page.getByLabel('Name').fill('John Doe');
  
  // Limpiar campo
  await page.getByLabel('Name').clear();
  
  // Seleccionar opciones
  await page.getByRole('combobox').selectOption('option1');
  
  // Checkbox
  await page.getByRole('checkbox').check();
  await page.getByRole('checkbox').uncheck();
  
  // Upload archivo
  await page.getByLabel('Upload').setInputFiles('path/to/file.pdf');
});
```

### 5. Esperas y Aserciones

```javascript
test('esperas y aserciones', async ({ page }) => {
  await page.goto('https://example.com');
  
  // Esperar que un elemento sea visible
  await expect(page.getByText('Welcome')).toBeVisible();
  
  // Esperar que un elemento contenga texto
  await expect(page.getByRole('heading')).toContainText('Dashboard');
  
  // Esperar que una página tenga título
  await expect(page).toHaveTitle('Home Page');
  
  // Esperar que un elemento tenga una clase
  await expect(page.getByRole('button')).toHaveClass('active');
  
  // Esperar que un campo tenga un valor
  await expect(page.getByLabel('Email')).toHaveValue('test@example.com');
  
  // Esperas personalizadas
  await page.waitForSelector('.loading', { state: 'hidden' });
  await page.waitForURL('**/dashboard');
  await page.waitForTimeout(1000);
});
```

## Ejemplos Prácticos

### Ejemplo 1: Formulario de Login

```javascript
import { test, expect } from '@playwright/test';

test('login exitoso', async ({ page }) => {
  await page.goto('/login');
  
  // Llenar formulario
  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Password').fill('password123');
  
  // Hacer click en submit
  await page.getByRole('button', { name: 'Login' }).click();
  
  // Verificar redirección
  await expect(page).toHaveURL('/dashboard');
  await expect(page.getByText('Welcome back!')).toBeVisible();
});

test('login con credenciales inválidas', async ({ page }) => {
  await page.goto('/login');
  
  await page.getByLabel('Email').fill('invalid@example.com');
  await page.getByLabel('Password').fill('wrongpassword');
  await page.getByRole('button', { name: 'Login' }).click();
  
  // Verificar mensaje de error
  await expect(page.getByText('Invalid credentials')).toBeVisible();
  await expect(page).toHaveURL('/login');
});
```

### Ejemplo 2: E-commerce - Agregar al Carrito

```javascript
test('agregar producto al carrito', async ({ page }) => {
  await page.goto('/products');
  
  // Buscar producto
  await page.getByPlaceholder('Search products').fill('laptop');
  await page.getByRole('button', { name: 'Search' }).click();
  
  // Seleccionar primer producto
  await page.getByRole('link').first().click();
  
  // Configurar opciones
  await page.getByLabel('Color').selectOption('black');
  await page.getByLabel('Size').selectOption('15-inch');
  
  // Agregar al carrito
  await page.getByRole('button', { name: 'Add to Cart' }).click();
  
  // Verificar notificación
  await expect(page.getByText('Product added to cart')).toBeVisible();
  
  // Verificar contador del carrito
  await expect(page.getByTestId('cart-count')).toContainText('1');
});
```

### Ejemplo 3: Manejo de Múltiples Páginas

```javascript
test('abrir enlace en nueva pestaña', async ({ context, page }) => {
  await page.goto('/');
  
  // Crear promise para nueva página
  const pagePromise = context.waitForEvent('page');
  
  // Click en enlace que abre nueva pestaña
  await page.getByRole('link', { name: 'Open in new tab' }).click();
  
  // Obtener nueva página
  const newPage = await pagePromise;
  await newPage.waitForLoadState();
  
  // Trabajar con la nueva página
  await expect(newPage).toHaveTitle('New Page');
  await newPage.getByRole('button', { name: 'Action' }).click();
  
  // Cerrar nueva página
  await newPage.close();
});
```

## Funcionalidades Avanzadas

### 1. Page Object Model

```javascript
// pages/LoginPage.js
export class LoginPage {
  constructor(page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.loginButton = page.getByRole('button', { name: 'Login' });
    this.errorMessage = page.getByTestId('error-message');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email, password) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }

  async getErrorMessage() {
    return await this.errorMessage.textContent();
  }
}

// Uso en tests
import { LoginPage } from './pages/LoginPage';

test('login con page object', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');
  
  await expect(page).toHaveURL('/dashboard');
});
```

### 2. Fixtures Personalizados

```javascript
// fixtures.js
import { test as base } from '@playwright/test';
import { LoginPage } from './pages/LoginPage';

export const test = base.extend({
  loginPage: async ({ page }, use) => {
    const loginPage = new LoginPage(page);
    await use(loginPage);
  },
  
  authenticatedPage: async ({ page }, use) => {
    // Auto-login para tests que requieren autenticación
    await page.goto('/login');
    await page.getByLabel('Email').fill('user@example.com');
    await page.getByLabel('Password').fill('password123');
    await page.getByRole('button', { name: 'Login' }).click();
    await page.waitForURL('/dashboard');
    await use(page);
  }
});

// Uso
test('test con fixture personalizado', async ({ authenticatedPage }) => {
  // La página ya está autenticada
  await expect(authenticatedPage.getByText('Welcome')).toBeVisible();
});
```

### 3. Interceptar Requests

```javascript
test('mockear API response', async ({ page }) => {
  // Interceptar y mockear request
  await page.route('**/api/users', async route => {
    const json = [
      { id: 1, name: 'John Doe', email: 'john@example.com' },
      { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
    ];
    await route.fulfill({ json });
  });
  
  await page.goto('/users');
  
  // Verificar que se muestran los usuarios mockeados
  await expect(page.getByText('John Doe')).toBeVisible();
  await expect(page.getByText('Jane Smith')).toBeVisible();
});

test('interceptar y modificar request', async ({ page }) => {
  await page.route('**/api/search', async route => {
    // Modificar el request
    const request = route.request();
    const postData = request.postDataJSON();
    postData.enhanced = true;
    
    // Continuar con datos modificados
    await route.continue({
      postData: JSON.stringify(postData)
    });
  });
  
  await page.goto('/search');
  // Realizar búsqueda...
});
```

### 4. Manejo de Storage State

```javascript
// Guardar estado de autenticación
test('guardar auth state', async ({ page }) => {
  await page.goto('/login');
  await page.getByLabel('Email').fill('user@example.com');
  await page.getByLabel('Password').fill('password123');
  await page.getByRole('button', { name: 'Login' }).click();
  
  // Guardar storage state
  await page.context().storageState({ path: 'auth.json' });
});

// Usar estado guardado
test.use({ storageState: 'auth.json' });
test('test con estado guardado', async ({ page }) => {
  await page.goto('/dashboard');
  // Usuario ya está logueado
  await expect(page.getByText('Welcome back')).toBeVisible();
});
```

## Debugging y Troubleshooting

### 1. Modo Debug

```bash
# Ejecutar en modo debug
npx playwright test --debug

# Debug test específico
npx playwright test login.spec.js --debug
```

### 2. Screenshots y Videos

```javascript
test('captura de pantalla', async ({ page }) => {
  await page.goto('/');
  
  // Screenshot de página completa
  await page.screenshot({ path: 'homepage.png', fullPage: true });
  
  // Screenshot de elemento específico
  await page.getByRole('navigation').screenshot({ path: 'nav.png' });
});
```

### 3. Configuración para Debugging

```javascript
// playwright.config.js
export default defineConfig({
  use: {
    // Ejecutar en modo headed para debugging
    headless: false,
    
    // Hacer más lento para observar
    slowMo: 1000,
    
    // Capturar traces
    trace: 'on-first-retry',
    
    // Screenshots en fallos
    screenshot: 'only-on-failure',
    
    // Videos
    video: 'retain-on-failure',
  },
});
```

### 4. Playwright Inspector

```javascript
test('debugging con inspector', async ({ page }) => {
  await page.goto('/');
  
  // Pausar ejecución para inspección
  await page.pause();
  
  // Continúa el test...
});
```

## Mejores Prácticas

### 1. Organización de Tests

```
tests/
├── fixtures/
│   └── auth.js
├── pages/
│   ├── LoginPage.js
│   └── DashboardPage.js
├── utils/
│   └── testData.js
├── auth.spec.js
├── dashboard.spec.js
└── e2e.spec.js
```

### 2. Datos de Prueba

```javascript
// utils/testData.js
export const testUsers = {
  admin: {
    email: 'admin@example.com',
    password: 'admin123'
  },
  user: {
    email: 'user@example.com',
    password: 'user123'
  }
};

export const generateRandomUser = () => ({
  email: `user${Date.now()}@example.com`,
  password: 'password123',
  name: `User ${Date.now()}`
});
```

### 3. Hooks de Setup y Teardown

```javascript
import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  // Setup común para cada test
  await page.goto('/');
  await page.getByRole('button', { name: 'Accept Cookies' }).click();
});

test.afterEach(async ({ page }) => {
  // Cleanup después de cada test
  await page.evaluate(() => localStorage.clear());
});

test.beforeAll(async () => {
  // Setup una vez antes de todos los tests
  console.log('Iniciando suite de tests');
});

test.afterAll(async () => {
  // Cleanup una vez después de todos los tests
  console.log('Finalizando suite de tests');
});
```

## Comandos Útiles

```bash
# Ejecutar todos los tests
npx playwright test

# Ejecutar tests en modo headed
npx playwright test --headed

# Ejecutar test específico
npx playwright test login.spec.js

# Ejecutar tests en un navegador específico
npx playwright test --project=chromium

# Generar reporte HTML
npx playwright show-report

# Actualizar screenshots
npx playwright test --update-snapshots

# Ejecutar en modo UI
npx playwright test --ui
```

## Conclusión

Playwright es una herramienta poderosa para automatización de pruebas web que ofrece:

- Soporte multi-navegador confiable
- API intuitiva y expresiva
- Excelentes capacidades de debugging
- Ejecución paralela rápida
- Manejo robusto de elementos dinámicos

Esta guía cubre los conceptos fundamentales y patrones más importantes para comenzar a usar Playwright efectivamente en tus proyectos de testing.
