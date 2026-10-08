"""
Práctica Módulo 2.7 - DML en SQLite.
Ejecuta en orden los cuatro scripts .sql sobre practica_dml.db y muestra
la tabla vendedores después de cada paso.
"""

import os
import sqlite3

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "practica_dml.db")

SCRIPTS = [
    "01_crear_y_consultar.sql",
    "02_insertar.sql",
    "03_actualizar.sql",
    "04_eliminar.sql",
]

# Arrancamos de cero para que la práctica sea reproducible
if os.path.exists(DB_PATH):
    os.remove(DB_PATH)

conexion = sqlite3.connect(DB_PATH)

for nombre_script in SCRIPTS:
    with open(os.path.join(BASE_DIR, nombre_script), encoding="utf-8") as f:
        conexion.executescript(f.read())

    print(f"\n=== Después de {nombre_script} ===")
    for fila in conexion.execute("SELECT * FROM vendedores ORDER BY id;"):
        print(fila)

conexion.close()