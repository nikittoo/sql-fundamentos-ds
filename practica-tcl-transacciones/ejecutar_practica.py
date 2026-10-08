"""
Práctica Módulo 2.8 - TCL: transacciones seguras en SQLite.
Ejecuta los scripts en orden sobre practica_tcl.db y muestra el estado de las
tablas después de cada caso.

Nota sobre el Caso 3: el segundo UPDATE falla a propósito, y Python detiene el
script en ese punto. Por eso el 'except' ordena el ROLLBACK: el código detecta
el error y deshace la transacción (el SQL por sí solo no lo hace en ese caso).
"""

import os
import sqlite3

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "practica_tcl.db")


def leer(nombre):
    with open(os.path.join(BASE_DIR, nombre), encoding="utf-8") as f:
        return f.read()


def mostrar_estado(con, titulo):
    print(f"\n=== {titulo} ===")
    print("productos:       ", con.execute("SELECT id, nombre, stock FROM productos ORDER BY id").fetchall())
    print("stock_almacenes: ", con.execute("SELECT almacen, stock FROM stock_almacenes ORDER BY id").fetchall())
    print("ventas_log:      ", con.execute("SELECT producto_id, cantidad, detalle FROM ventas_log").fetchall())


if os.path.exists(DB_PATH):
    os.remove(DB_PATH)

con = sqlite3.connect(DB_PATH)

con.executescript(leer("00_preparacion.sql"))
mostrar_estado(con, "Estado inicial")

con.executescript(leer("01_commit_exitoso.sql"))
mostrar_estado(con, "Después del Caso 1 (COMMIT)")

con.executescript(leer("02_rollback_panico.sql"))
mostrar_estado(con, "Después del Caso 2 (ROLLBACK del DELETE sin WHERE)")

try:
    con.executescript(leer("03_atomicidad_fallo.sql"))
except sqlite3.Error as error:
    print(f"\nError esperado en el Caso 3: {error}")
    con.rollback()  # el código detecta el error y deshace la transacción
    print("Se ejecutó ROLLBACK.")
mostrar_estado(con, "Después del Caso 3 (ROLLBACK por fallo)")

con.close()