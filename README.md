# SQL y fundamentos para Data Science

Prácticas del curso de Machine Learning (Data Scientist 2), organizadas por carpeta.
Cada carpeta tiene el código y se puede ejecutar de forma independiente.

| Carpeta | Tema | Qué se practica |
|---|---|---|
| `practica-sql-ventas/` | Módulo 0.2: sintaxis SQL fundamental | Consultas `SELECT`, `WHERE`, `GROUP BY` y `ORDER BY` sobre ventas de tecnología, ejecutadas con SQLite y Python |
| `practica-dml-features/` | Módulo 1.3: DML aplicado a análisis de datos | Pipeline con `INSERT`, `UPDATE`, `DELETE`, índices y `pandas`/`SQLAlchemy` sobre una tabla de features para ML |
| `practica-dml-vendedores/` | Módulo 2.7: DML | `SELECT`, `INSERT`, `UPDATE` y `DELETE` con `WHERE` sobre la tabla `vendedores` |
| `practica-tcl-transacciones/` | Módulo 2.8: TCL y ACID | `BEGIN`, `COMMIT` y `ROLLBACK` para proteger la integridad de los datos |

## Requisitos

- Python 3.10 o superior
- Las prácticas usan `sqlite3` (incluido en Python); `practica-dml-features` también usa
  `pandas`, `numpy` y `sqlalchemy`

## Cómo ejecutar

Entrá a la carpeta de la práctica y seguí las instrucciones de su `README.md`
(o ejecutá el `.py` correspondiente). Las bases `.db` se generan al correr los scripts
y no se suben al repositorio.