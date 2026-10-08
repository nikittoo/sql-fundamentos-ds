-- 02_rollback_panico.sql
-- CASO 2: el botón de pánico (error humano recuperado con ROLLBACK).
-- Principios ACID protegidos:
--   Atomicidad : el DELETE accidental se deshace por completo.
--   Consistencia: la base vuelve a un estado válido (los productos siguen existiendo).

-- Estado ANTES: 3 productos
SELECT COUNT(*) AS total_productos 
FROM productos;
-- Resultado esperado: 3

BEGIN TRANSACTION;

-- ¡ERROR HUMANO! DELETE sin WHERE: borra TODOS los productos
-- (la única vez en la práctica que se permite, porque está dentro de una transacción)
DELETE FROM productos;

-- Dentro de la transacción se ve el desastre
SELECT COUNT(*) AS total_productos 
FROM productos;
-- Resultado esperado: 0

-- Nos damos cuenta del error ANTES de confirmar: deshacemos todo
ROLLBACK;

-- Estado DESPUÉS del ROLLBACK: los datos siguen ahí
SELECT COUNT(*) AS total_productos 
FROM productos;

-- Resultado esperado: 3
SELECT id, nombre, stock 
FROM productos 
ORDER BY id;
-- Resultado esperado: (1, ..., 97), (2, ..., 50), (3, ..., 200)