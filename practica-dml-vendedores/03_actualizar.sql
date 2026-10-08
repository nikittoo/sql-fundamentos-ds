-- 03_actualizar.sql
-- UPDATE con WHERE: suma una venta y reasigna la zona según el monto vendido.

-- Verificación previa: ¿qué fila voy a modificar?
SELECT * 
FROM vendedores 
WHERE id = 2;

-- El vendedor con id = 2 realizó una nueva venta de 500
UPDATE vendedores
SET ventas_totales = ventas_totales + 500
WHERE id = 2;

-- Reto: los vendedores con más de 10000 en ventas pasan a la zona Internacional
SELECT *    
FROM vendedores     
WHERE ventas_totales > 10000;

UPDATE vendedores
SET zona = 'Internacional'
WHERE ventas_totales > 10000;