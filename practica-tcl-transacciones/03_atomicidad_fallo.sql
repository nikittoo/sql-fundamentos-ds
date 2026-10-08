-- 03_atomicidad_fallo.sql
-- CASO 3: atomicidad ante un fallo lógico.
-- Principio ACID protegido: ATOMICIDAD ("todo o nada").
-- Se transfieren 20 unidades del producto 1 desde el Almacén A al Almacén B.

-- Estado ANTES: A = 60, B = 40 (total = 100 unidades)
SELECT almacen, stock 
FROM stock_almacenes 
WHERE producto_id = 1 
ORDER BY id;
-- Resultado esperado: ('Almacén A', 60), ('Almacén B', 40)

BEGIN TRANSACTION;

-- Paso 1 (VÁLIDO): se restan 20 unidades del Almacén A
UPDATE stock_almacenes
SET stock = stock - 20
WHERE almacen = 'Almacén A' AND producto_id = 1;
-- En este punto, dentro de la transacción, A = 40 pero B sigue en 40:
-- faltan 20 unidades, la base está inconsistente.

-- Paso 2 (FALLA A PROPÓSITO): asignar NULL a una columna NOT NULL
-- SQLite lanza: "NOT NULL constraint failed: stock_almacenes.stock"
UPDATE stock_almacenes
SET stock = NULL
WHERE almacen = 'Almacén B' AND producto_id = 1;

-- Como el paso 2 falló, el paso 1 NO puede quedar guardado: si lo estuviera,
-- 20 unidades habrían desaparecido (salieron de A y nunca entraron en B).
-- Por la ATOMICIDAD hay que deshacer también el paso 1:
ROLLBACK;

-- Estado DESPUÉS del ROLLBACK: A = 60, B = 40, igual que al principio
SELECT almacen, stock 
FROM stock_almacenes 
WHERE producto_id = 1 
ORDER BY id;
-- Resultado esperado: ('Almacén A', 60), ('Almacén B', 40)