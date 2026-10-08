-- 01_commit_exitoso.sql
-- CASO 1: transacción exitosa.
-- Principios ACID protegidos:
--   Atomicidad : el UPDATE de stock y el INSERT de auditoría se guardan juntos o no se guarda ninguno.
--   Durabilidad: tras el COMMIT, ambos cambios son permanentes.

-- Estado ANTES: el producto 1 tiene stock = 100 y ventas_log está vacía
SELECT id, nombre, stock 
FROM productos 
WHERE id = 1;

-- Resultado esperado: (1, 'Sensor de Humedad IoT', 100)
SELECT COUNT(*) AS registros_log 
FROM ventas_log;
-- Resultado esperado: 0

BEGIN TRANSACTION;

-- Paso 1: se venden 3 unidades del producto 1
UPDATE productos
SET stock = stock - 3
WHERE id = 1;

-- Paso 2: se registra la venta en la auditoría
INSERT INTO ventas_log (producto_id, cantidad, detalle)
VALUES (1, 3, 'Venta de 3 unidades');

COMMIT;  -- todo salió bien: se confirman ambos cambios

-- Estado DESPUÉS del COMMIT: ambos cambios persisten
SELECT id, nombre, stock FROM productos WHERE id = 1;

-- Resultado esperado: (1, 'Sensor de Humedad IoT', 97)

SELECT producto_id, cantidad, detalle FROM ventas_log;
-- Resultado esperado: (1, 3, 'Venta de 3 unidades')