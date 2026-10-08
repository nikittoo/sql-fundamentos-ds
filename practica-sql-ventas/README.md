# sql-fundamentos-ds

# SQL - Exploración inicial de ventas_tecnologia

Práctica del Módulo 0.2 del curso de Machine Learning (Data Scientist 2).

## Objetivo

Practicar la extracción y manipulación de datos en una sola tabla
(`ventas_tecnologia`), simulando la exploración inicial que hace un Data
Scientist antes de modelar: selección, filtrado, detección de nulos y
agregación con `GROUP BY` / `HAVING`.

## Contenido

`ejercicio_sql.py` usa `sqlite3` para crear una tabla en memoria con datos de
ejemplo (incluye casos pensados a propósito: ventas en Colombia con
`precio_unitario` > 500, registros con `categoria` en `NULL`, y categorías con
ingresos por encima y por debajo de $10.000) y resuelve las 5 consultas de la
consigna, cada una precedida por un comentario con la pregunta de negocio que
responde:

1. **Selección simple**: producto y precio, ordenados alfabéticamente.
2. **Filtrado crítico**: ventas en Colombia con `precio_unitario > 500`.
3. **Búsqueda de nulos**: registros con `categoria IS NULL`.
4. **Agregación**: ingresos totales (`cantidad * precio_unitario`) por
   categoría, con alias `ingresos_totales`.
5. **HAVING**: categorías cuyos ingresos totales superan los $10.000.

Todas las palabras clave de SQL están en mayúsculas siguiendo las buenas
prácticas vistas en la unidad.

## Cómo ejecutar

```bash
python3 ejercicio_sql.py
```