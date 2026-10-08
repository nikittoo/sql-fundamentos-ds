# Práctica DML en SQLite: tabla `vendedores`

Práctica del Módulo 2.7 (DML). Simula tareas habituales de un analista de datos
sobre una tabla `vendedores` (`id`, `nombre`, `ventas_totales`, `zona`, `fecha_ingreso`)
en una base SQLite llamada `practica_dml.db`.

## Scripts

| Archivo | Problema que resuelve |
|---|---|
| `01_crear_y_consultar.sql` | Crea la tabla, carga 5 vendedores iniciales y consulta nombre y ventas de la zona Norte (`SELECT` + `WHERE`). |
| `02_insertar.sql` | Agrega 2 vendedores con `INSERT` individual (uno es de prueba) y 3 más con un `INSERT` masivo en una sola sentencia. |
| `03_actualizar.sql` | `UPDATE` con `WHERE`: suma 500 a las ventas del vendedor `id = 2` y pasa a la zona 'Internacional' a quienes superan 10.000 en ventas. |
| `04_eliminar.sql` | `DELETE` con `WHERE`: elimina el vendedor de prueba (`id = 99`) y verifica con un `SELECT` que ya no existe. |
| `ejecutar_practica.py` | Ejecuta los cuatro scripts en orden y muestra la tabla después de cada paso. |

## Cómo ejecutarla

    python ejecutar_practica.py

(Crea `practica_dml.db` desde cero en cada corrida.)

## Buenas prácticas aplicadas

- Todo `UPDATE` y `DELETE` lleva cláusula `WHERE`.
- Antes de cada `UPDATE` se hace un `SELECT` con el mismo `WHERE` para verificar qué filas se van a modificar.
- Los `INSERT` listan las columnas explícitamente.
- Los valores de texto van entre comillas simples.