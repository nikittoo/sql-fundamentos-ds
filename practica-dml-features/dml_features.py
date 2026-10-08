"""
Práctica Módulo 1.3 - DML aplicado a análisis de datos
Pipeline reproducible: crear tabla, insertar datos simulados, explorar con
SELECT, transformar con UPDATE, limpiar con DELETE y medir el impacto de
un índice en una consulta agregada.
"""

import os
import time
import sqlite3
from datetime import datetime, timedelta

import numpy as np
import pandas as pd
from sqlalchemy import create_engine

pd.set_option("display.max_columns", None)
np.random.seed(42)

DB_NAME = "dml_ml.db"
DB_PATH = os.path.join(os.getcwd(), DB_NAME)


# ---------------------------------------------------------------------------
# Paso 1: Crear la base y la tabla "features"
# ---------------------------------------------------------------------------
if os.path.exists(DB_PATH):
    os.remove(DB_PATH)  # reproducibilidad: arrancamos de cero cada corrida

conn = sqlite3.connect(DB_PATH)
cur = conn.cursor()

cur.execute("""
    CREATE TABLE features (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        feature1 REAL,
        feature2 REAL,
        category TEXT,
        label INTEGER,
        created_at TEXT
    );
""")
conn.commit()
print("Tabla features creada.")


# ---------------------------------------------------------------------------
# Paso 2: Generar e insertar datos simulados (INSERT masivo por lotes)
# ---------------------------------------------------------------------------
n = 2000

user_ids = np.random.randint(1000, 2000, size=n)

# feature1: distribución sesgada con outliers (ej. montos de compra)
feature1 = np.random.exponential(scale=100.0, size=n)
outlier_idx = np.random.choice(n, size=int(n * 0.01), replace=False)
feature1[outlier_idx] *= 30

# feature2: normal, con algunos NaN (ej. tiempo en segundos)
feature2 = np.random.normal(loc=50, scale=15, size=n)
nan_idx = np.random.choice(n, size=int(n * 0.02), replace=False)
feature2[nan_idx] = np.nan

categorias = ["online", "store", "partner", "mobile"]
category = np.random.choice(categorias, size=n, p=[0.5, 0.25, 0.15, 0.10])

label = np.random.choice([0, 1], size=n, p=[0.85, 0.15])  # clases desbalanceadas

inicio = datetime.now() - timedelta(days=90)
created_at = [
    (inicio + timedelta(seconds=int(np.random.rand() * 90 * 24 * 3600))).isoformat()
    for _ in range(n)
]

filas = []
for i in range(n):
    f1 = None if np.random.rand() < 0.01 else float(feature1[i])
    f2 = None if np.isnan(feature2[i]) else float(feature2[i])
    filas.append((int(user_ids[i]), f1, f2, category[i], int(label[i]), created_at[i]))

insert_sql = """
    INSERT INTO features (user_id, feature1, feature2, category, label, created_at)
    VALUES (?, ?, ?, ?, ?, ?);
"""
batch_size = 500
inicio_t = time.perf_counter()
for i in range(0, n, batch_size):
    cur.executemany(insert_sql, filas[i:i + batch_size])
    conn.commit()
print(f"Insertadas {n} filas en {time.perf_counter() - inicio_t:.3f} s")

resumen = pd.read_sql_query("""
    SELECT COUNT(*) AS total,
           SUM(CASE WHEN feature1 IS NULL THEN 1 ELSE 0 END) AS nulos_f1,
           SUM(CASE WHEN feature2 IS NULL THEN 1 ELSE 0 END) AS nulos_f2
    FROM features;
""", conn)
print(resumen)

conn.close()


# ---------------------------------------------------------------------------
# Paso 3: SELECT exploratorio — dataset "limpio" para ML
# ---------------------------------------------------------------------------
conn = sqlite3.connect(DB_PATH)

total = pd.read_sql_query("SELECT COUNT(*) AS total FROM features;", conn)["total"][0]
print(f"\nTotal de filas: {total}")

query_limpia = """
    SELECT id, user_id, feature1, feature2, category, label
    FROM features
    WHERE feature1 IS NOT NULL AND feature2 IS NOT NULL AND label IS NOT NULL;
"""
df_limpio = pd.read_sql_query(query_limpia, conn)
print(f"Filas limpias para ML: {len(df_limpio)}")
print(df_limpio.describe())

conn.close()


# ---------------------------------------------------------------------------
# Paso 4: UPDATE — columnas calculadas (normalización + capeo de outliers)
# ---------------------------------------------------------------------------
conn = sqlite3.connect(DB_PATH)
cur = conn.cursor()

columnas = pd.read_sql_query("PRAGMA table_info(features);", conn)["name"].values
for nueva_columna in ("feature1_scaled", "feature1_capped"):
    if nueva_columna not in columnas:
        cur.execute(f"ALTER TABLE features ADD COLUMN {nueva_columna} REAL;")
conn.commit()

max_f1 = cur.execute(
    "SELECT MAX(feature1) FROM features WHERE feature1 IS NOT NULL;"
).fetchone()[0]

if max_f1 and max_f1 > 0:
    cur.execute(
        "UPDATE features SET feature1_scaled = feature1 / ? WHERE feature1 IS NOT NULL;",
        (max_f1,),
    )
    conn.commit()
    print(f"\nfeature1_scaled actualizada (max usado: {max_f1:.2f})")

# Capeo de outliers con la regla del IQR
valores = pd.read_sql_query("SELECT feature1 FROM features WHERE feature1 IS NOT NULL;", conn)
q1, q3 = valores["feature1"].quantile([0.25, 0.75])
iqr = q3 - q1
tope = q3 + 1.5 * iqr
print(f"Tope de outliers (Q3 + 1.5*IQR): {tope:.2f}")

cur.execute(
    """
    UPDATE features
    SET feature1_capped = CASE
        WHEN feature1 IS NULL THEN NULL
        WHEN feature1 > ? THEN ?
        ELSE feature1
    END;
    """,
    (tope, tope),
)
conn.commit()

print(pd.read_sql_query(
    "SELECT id, feature1, feature1_scaled, feature1_capped "
    "FROM features ORDER BY id DESC LIMIT 5;", conn
))

conn.close()


# ---------------------------------------------------------------------------
# Paso 5: DELETE — eliminar registros irreparables
# ---------------------------------------------------------------------------
conn = sqlite3.connect(DB_PATH)
cur = conn.cursor()

antes = cur.execute("SELECT COUNT(*) FROM features;").fetchone()[0]

cur.execute("""
    DELETE FROM features
    WHERE label IS NULL OR (feature1 IS NULL AND feature2 IS NULL);
""")
eliminadas = cur.rowcount
conn.commit()

despues = cur.execute("SELECT COUNT(*) FROM features;").fetchone()[0]
print(f"\nFilas antes: {antes} | eliminadas: {eliminadas} | filas después: {despues}")

conn.close()


# ---------------------------------------------------------------------------
# Paso 6: SELECT optimizado — medir el impacto de un índice
# ---------------------------------------------------------------------------
conn = sqlite3.connect(DB_PATH)


def medir_tiempo(sql, repeticiones=3):
    tiempos = []
    for _ in range(repeticiones):
        t0 = time.perf_counter()
        pd.read_sql_query(sql, conn)
        tiempos.append(time.perf_counter() - t0)
    return np.mean(tiempos)


consulta_agregada = """
    SELECT category, label, COUNT(*) AS cantidad,
           AVG(feature1_capped) AS promedio_f1, AVG(feature2) AS promedio_f2
    FROM features
    GROUP BY category, label;
"""

tiempo_sin_indice = medir_tiempo(consulta_agregada)
print(f"\nTiempo medio sin índice: {tiempo_sin_indice:.5f} s")

cur = conn.cursor()
cur.execute("CREATE INDEX IF NOT EXISTS idx_features_category_label ON features(category, label);")
conn.commit()

tiempo_con_indice = medir_tiempo(consulta_agregada)
print(f"Tiempo medio con índice: {tiempo_con_indice:.5f} s")

print(pd.read_sql_query(consulta_agregada, conn))

conn.close()


# ---------------------------------------------------------------------------
# Paso 7: INSERT vía pandas/SQLAlchemy (to_sql)
# ---------------------------------------------------------------------------
engine = create_engine(f"sqlite:///{DB_PATH}")

df_nuevo = pd.DataFrame({
    "user_id": [9999, 10000],
    "feature1": [123.45, 67.89],
    "feature2": [12.3, 45.6],
    "category": ["online", "store"],
    "label": [0, 1],
    "created_at": [datetime.now().isoformat(), datetime.now().isoformat()],
    "feature1_scaled": [None, None],
    "feature1_capped": [None, None],
})

with engine.begin() as conexion_engine:
    df_nuevo.to_sql("features", conexion_engine, if_exists="append", index=False)
print("\nBatch insertado con SQLAlchemy (to_sql).")

with engine.connect() as conexion_engine:
    print(pd.read_sql_query(
        "SELECT * FROM features ORDER BY id DESC LIMIT 5;", conexion_engine
    ))