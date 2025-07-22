CREATE DATABASE libreria;
USE libreria;

CREATE TABLE autores (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE,
  nacionalidad VARCHAR(50),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE categorias (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  descripcion VARCHAR(200),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

CREATE TABLE libros (
  id INT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(200) NOT NULL,
  autor_id INT NOT NULL,
  categoria_id INT NOT NULL,
  ISBN VARCHAR(13) UNIQUE,
  publicacion DATE,
  precio DECIMAL(10,2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (autor_id) REFERENCES autores(id),
  FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE ventas (
  id INT NOT NULL AUTO_INCREMENT,
  libro_id INT NOT NULL,
  fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  cliente VARCHAR(100),
  PRIMARY KEY (id),
  FOREIGN KEY (libro_id) REFERENCES libros(id)
);


INSERT INTO autores (nombre, apellido, fecha_nacimiento, nacionalidad) VALUES
('Gabriel', 'García Márquez', '1927-03-06', 'Colombiana'),
('Isabel', 'Allende', '1942-08-02', 'Chilena'),
('Mario', 'Vargas Llosa', '1936-03-28', 'Peruana'),
('Julio', 'Cortázar', '1914-08-26', 'Argentina'),
('Jorge Luis', 'Borges', '1899-08-24', 'Argentina'),
('Pablo', 'Neruda', '1904-07-12', 'Chilena'),
('Octavio', 'Paz', '1914-03-31', 'Mexicana');

INSERT INTO categorias (nombre, descripcion) VALUES
('Ficción', 'Novelas y cuentos de ficción'),
('Poesía', 'Libros de poemas y versos'),
('Ensayo', 'Textos reflexivos y analíticos'),
('Biografía', 'Historias de vida reales'),
('Historia', 'Libros sobre eventos históricos'),
('Ciencia', 'Textos científicos y divulgación');

INSERT INTO libros (titulo, autor_id, categoria_id, ISBN, publicacion, precio, stock) VALUES
('Cien años de soledad', 1, 1, '9780307474728', '1967-05-30', 25.99, 15),
('El amor en los tiempos del cólera', 1, 1, '9780307389732', '1985-09-05', 23.50, 12),
('La casa de los espíritus', 2, 1, '9780553383803', '1982-10-01', 22.75, 8),
('Paula', 2, 4, '9780060927219', '1994-03-01', 19.99, 6),
('La ciudad y los perros', 3, 1, '9780374530532', '1963-10-01', 24.99, 10),
('Rayuela', 4, 1, '9780394752846', '1963-06-28', 28.50, 5),
('El Aleph', 5, 1, '9780525432889', '1949-06-01', 18.99, 20),
('Laberintos', 5, 1, '9780140291872', '1962-01-01', 21.00, 7),
('Veinte poemas de amor', 6, 2, '9780811216112', '1924-06-01', 15.99, 25),
('El laberinto de la soledad', 7, 3, '9780802150424', '1950-08-01', 20.50, 9);

INSERT INTO ventas (libro_id, cantidad, precio_unitario, total, cliente) VALUES
(1, 2, 25.99, 51.98, 'Ana García'),
(3, 1, 22.75, 22.75, 'Carlos Mendoza'),
(9, 3, 15.99, 47.97, 'María López'),
(7, 1, 18.99, 18.99, 'José Rodríguez'),
(1, 1, 25.99, 25.99, 'Laura Martínez'),
(5, 2, 24.99, 49.98, 'Pedro Sánchez'),
(2, 1, 23.50, 23.50, 'Carmen Ruiz'),
(9, 1, 15.99, 15.99, 'Diego Torres'),
(7, 2, 18.99, 37.98, 'Elena Vargas'),
(10, 1, 20.50, 20.50, 'Roberto Silva');

CREATE OR REPLACE VIEW view_catalogo_libros AS
SELECT 
  l.id,
  l.titulo,
  CONCAT(a.nombre, ' ', a.apellido) AS autor,
  c.nombre AS categoria,
  l.ISBN,
  l.publicacion,
  l.precio,
  l.stock,
  CASE 
    WHEN l.stock > 10 THEN 'Disponible'
    WHEN l.stock > 0 THEN 'Pocas unidades'
    ELSE 'Agotado'
  END AS estado
FROM libros l
INNER JOIN autores a ON l.autor_id = a.id
INNER JOIN categorias c ON l.categoria_id = c.id;

--

CREATE OR REPLACE VIEW view_ventas_por_autor AS
SELECT 
  CONCAT(a.nombre, ' ', a.apellido) AS autor,
  COUNT(v.id) AS numero_ventas,
  SUM(v.cantidad) AS libros_vendidos,
  SUM(v.total) AS ingreso_total,
  AVG(v.total) AS promedio_venta
FROM autores a
INNER JOIN libros l ON a.id = l.autor_id
INNER JOIN ventas v ON l.id = v.libro_id
GROUP BY a.id;

--

DELIMITER //

CREATE OR REPLACE PROCEDURE sp_ConsultarStockLibro(
  IN p_LibroID INT,
  OUT p_StockActual INT
)
BEGIN
  DECLARE libro_existe INT DEFAULT 0;
    
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SET p_StockActual = 0;
    RESIGNAL;
  END;
    
  -- Validar si el libro existe
  SELECT COUNT(*) INTO libro_existe 
  FROM libros 
  WHERE id = p_LibroID;
    
  IF libro_existe = 0 THEN
    SET p_StockActual = 0;
    SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'El libro especificado no existe';
  END IF;
    
  -- Obtener el stock actual
  SELECT stock INTO p_StockActual
  FROM libros
  WHERE id = p_LibroID;

  -- Mostrar información del libro
  SELECT 
    l.titulo,
    CONCAT(a.nombre, ' ', a.apellido) AS autor,
    l.precio,
    l.stock,
    CASE 
      WHEN l.stock > 10 THEN 'Stock alto'
      WHEN l.stock > 0 THEN 'Stock bajo'
      ELSE 'Sin stock'
    END AS estado
  FROM libros l
  INNER JOIN autores a ON l.autor_id = a.id
  WHERE l.id = p_LibroID;
END //

DELIMITER ;

--

DELIMITER //

CREATE OR REPLACE FUNCTION fn_calcular_descuento(
	precio DECIMAL(10,2), 
	porcentaje_descuento DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
BEGIN
  DECLARE precio_con_descuento DECIMAL(10,2);
    
  -- Validar que el porcentaje esté entre 0 y 100
  IF porcentaje_descuento < 0 OR porcentaje_descuento > 100 THEN
    SET porcentaje_descuento = 0;
  END IF;
    
  -- Calcular precio con descuento
  SET precio_con_descuento = precio * (1 - porcentaje_descuento / 100);  
  RETURN precio_con_descuento;
END //

DELIMITER ;

--

DELIMITER //

CREATE OR REPLACE TRIGGER tr_actualizar_stock_venta
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
  
  DECLARE stock_actual INT DEFAULT 0;
  SELECT stock INTO stock_actual FROM libros WHERE id = NEW.libro_id;

  IF NEW.cantidad > stock_actual THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No hay stock suficiente para realizar la venta';
  END IF; 
    
  UPDATE libros
  SET stock = stock - NEW.cantidad
  WHERE id = NEW.libro_id;
END //

DELIMITER ;