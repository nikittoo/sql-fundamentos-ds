-- 04_eliminar.sql
-- DELETE con WHERE: elimina el vendedor de prueba y verifica que desapareció.

DELETE FROM vendedores
WHERE id = 99;

-- Verificación: no debe devolver ninguna fila
SELECT * 
FROM vendedores 
WHERE id = 99;