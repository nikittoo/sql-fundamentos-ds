-- 01_crear_y_consultar.sql
-- Crea la tabla vendedores, carga los registros iniciales (INSERT) y consulta (SELECT).

DROP TABLE IF EXISTS vendedores;

CREATE TABLE vendedores (
    id             INTEGER PRIMARY KEY,
    nombre         TEXT    NOT NULL,
    ventas_totales REAL    NOT NULL DEFAULT 0,
    zona           TEXT    NOT NULL,
    fecha_ingreso  TEXT    NOT NULL
);

INSERT INTO vendedores (id, nombre, ventas_totales, zona, fecha_ingreso) VALUES
    (1, 'Ana Torres',    8500,  'Norte', '2021-03-15'),
    (2, 'Luis Gómez',    9800,  'Sur',   '2020-07-01'),
    (3, 'Marta Ruiz',    15200, 'Norte', '2019-11-20'),
    (4, 'Pedro Sosa',    4300,  'Este',  '2022-01-10'),
    (5, 'Carla Díaz',    11800, 'Oeste', '2018-05-30');

-- Nombre y ventas de los vendedores de la zona Norte
SELECT nombre, ventas_totales
FROM vendedores
WHERE zona = 'Norte';