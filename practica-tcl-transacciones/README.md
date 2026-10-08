# Práctica TCL en SQLite: transacciones seguras

Práctica del Módulo 2.8 (TCL y ACID). Demuestra cómo `BEGIN`, `COMMIT` y `ROLLBACK`
protegen la integridad de los datos ante errores, sobre las tablas `productos`,
`ventas_log` (auditoría) y `stock_almacenes`.

## Scripts

| Archivo | Problema que resuelve | Principio ACID |
|---|---|---|
| `00_preparacion.sql` | Crea las tablas y carga los datos iniciales | - |
| `01_commit_exitoso.sql` | Descuenta stock y registra la venta en la auditoría como una sola unidad; `COMMIT` confirma ambos cambios | Atomicidad, Durabilidad |
| `02_rollback_panico.sql` | Un `DELETE` accidental sin `WHERE` se deshace con `ROLLBACK` y los datos siguen intactos | Atomicidad, Consistencia |
| `03_atomicidad_fallo.sql` | En una transferencia de stock entre almacenes, el segundo `UPDATE` falla (`NOT NULL`) y obliga a deshacer el primero | Atomicidad |
| `ejecutar_practica.py` | Ejecuta todo en orden y muestra el estado de las tablas tras cada caso | - |

## Cómo ejecutarla

    python ejecutar_practica.py

Crea `practica_tcl.db` desde cero en cada corrida.

## Notas

- Cada archivo documenta con comentarios (`--`) qué principio ACID protege y el resultado
  esperado de cada `SELECT` antes y después del `COMMIT`/`ROLLBACK`.
- En el Caso 3 el error es intencional. Al ejecutar desde Python, el script se detiene en
  el segundo `UPDATE` y el bloque `except` ordena el `ROLLBACK`.
- Toda transacción abierta con `BEGIN` termina en `COMMIT` o `ROLLBACK`.