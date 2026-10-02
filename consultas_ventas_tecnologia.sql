-- =====================================================================
-- Práctica Módulo 0.2 - Sintaxis SQL fundamental
-- Exploración inicial de la tabla ventas_tecnologia
-- =====================================================================

-- Configuración: creación de la tabla
CREATE TABLE ventas_tecnologia (
    id_venta INTEGER PRIMARY KEY,
    producto TEXT,
    categoria TEXT,
    precio_unitario REAL,
    cantidad INTEGER,
    fecha TEXT,
    pais TEXT
);

-- Datos de ejemplo (incluye ventas en Colombia > 500, categorías NULL
-- y categorías con ingresos por encima y por debajo de $10.000)
INSERT INTO ventas_tecnologia VALUES
    (1, 'Notebook Gamer', 'Computadoras', 1200.0, 10, '2026-01-15', 'Colombia'),
    (2, 'Mouse Inalámbrico', 'Accesorios', 25.0, 50, '2026-01-16', 'México'),
    (3, 'Monitor 27 pulgadas', 'Computadoras', 350.0, 20, '2026-02-01', 'Colombia'),
    (4, 'Teclado Mecánico', 'Accesorios', 80.0, 30, '2026-02-03', 'Chile'),
    (5, 'Router WiFi 6', NULL, 90.0, 15, '2026-02-10', 'Colombia'),
    (6, 'Smart TV 55"', 'Electrónica', 700.0, 8, '2026-02-14', 'Colombia'),
    (7, 'Auriculares Bluetooth', 'Accesorios', 45.0, 60, '2026-03-01', 'España'),
    (8, 'Disco SSD 1TB', 'Computadoras', 110.0, 40, '2026-03-05', 'México'),
    (9, 'Cámara de Seguridad', NULL, 65.0, 25, '2026-03-10', 'Chile'),
    (10, 'Tablet 10 pulgadas', 'Electrónica', 320.0, 12, '2026-03-15', 'Colombia');


-- =====================================================================
-- Tarea 2: Selección simple
-- Pregunta de negocio: ¿qué productos vendemos y a qué precio,
-- en orden alfabético?
-- =====================================================================
SELECT producto, precio_unitario
FROM ventas_tecnologia
ORDER BY producto ASC;


-- =====================================================================
-- Tarea 3: Filtrado crítico
-- Pregunta de negocio: ¿qué ventas de alto valor (> 500) tuvimos
-- en Colombia?
-- =====================================================================
SELECT *
FROM ventas_tecnologia
WHERE pais = 'Colombia' AND precio_unitario > 500;


-- =====================================================================
-- Tarea 4: Búsqueda de nulos
-- Pregunta de negocio: ¿qué ventas quedaron sin categoría cargada
-- por el equipo?
-- =====================================================================
SELECT id_venta, producto, categoria
FROM ventas_tecnologia
WHERE categoria IS NULL;


-- =====================================================================
-- Tarea 5: Análisis de rendimiento (agregación)
-- Pregunta de negocio: ¿cuánto ingreso total generó cada categoría?
-- =====================================================================
SELECT categoria, SUM(cantidad * precio_unitario) AS ingresos_totales
FROM ventas_tecnologia
GROUP BY categoria;


-- =====================================================================
-- Tarea 6: Filtro de élite (HAVING)
-- Pregunta de negocio: ¿qué categorías superaron los $10.000 en
-- ingresos totales?
-- =====================================================================
SELECT categoria, SUM(cantidad * precio_unitario) AS ingresos_totales
FROM ventas_tecnologia
GROUP BY categoria
HAVING SUM(cantidad * precio_unitario) > 10000;