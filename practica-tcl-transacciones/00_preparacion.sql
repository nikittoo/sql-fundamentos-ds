-- 00_preparacion.sql
-- Crea las tablas de la práctica y carga datos iniciales.
-- Tablas: productos, ventas_log (auditoría) y stock_almacenes (para el Caso 3).

DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS ventas_log;
DROP TABLE IF EXISTS stock_almacenes;

CREATE TABLE productos (
    id     INTEGER PRIMARY KEY,
    nombre TEXT    NOT NULL,
    stock  INTEGER NOT NULL CHECK (stock >= 0)
);

CREATE TABLE ventas_log (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    producto_id INTEGER NOT NULL,
    cantidad    INTEGER NOT NULL,
    fecha       TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    detalle     TEXT
);

-- Stock de cada producto en cada almacén (la columna stock NO admite NULL)
CREATE TABLE stock_almacenes (
    id          INTEGER PRIMARY KEY,
    almacen     TEXT    NOT NULL,
    producto_id INTEGER NOT NULL,
    stock       INTEGER NOT NULL CHECK (stock >= 0)
);

INSERT INTO productos (id, nombre, stock) VALUES
    (1, 'Sensor de Humedad IoT',  100),
    (2, 'Placa Arduino Uno',       50),
    (3, 'Cable USB-C',            200);

INSERT INTO stock_almacenes (id, almacen, producto_id, stock) VALUES
    (1, 'Almacén A', 1, 60),
    (2, 'Almacén B', 1, 40);