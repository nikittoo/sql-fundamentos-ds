-- 02_insertar.sql
-- INSERT individual (dos vendedores) e INSERT masivo (tres vendedores en una sola sentencia).

-- Inserciones individuales (el id 99 es el vendedor de prueba que se borra en el paso 04)
INSERT INTO vendedores (id, nombre, ventas_totales, zona, fecha_ingreso)
VALUES (6, 'Sofía Luna', 6700, 'Sur', '2023-02-14');

INSERT INTO vendedores (id, nombre, ventas_totales, zona, fecha_ingreso)
VALUES (99, 'Vendedor Prueba', 0, 'Norte', '2024-01-01');

-- Inserción masiva: 3 registros en una sola sentencia
INSERT INTO vendedores (id, nombre, ventas_totales, zona, fecha_ingreso) VALUES
    (7, 'Diego Pérez',  12400, 'Este',  '2022-09-05'),
    (8, 'Julia Mena',   3900,  'Oeste', '2023-06-18'),
    (9, 'Hugo Ríos',    7200,  'Norte', '2021-12-01');