CREATE SCHEMA IF NOT EXISTS sch_riesgo_capa_bronce;

CREATE TABLE IF NOT EXISTS sch_riesgo_capa_bronce.tbl_riesgos_tradicional (
    id_trx INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    canal_origen VARCHAR(20),
    edad INT,
    genero VARCHAR(20),
    estado_civil VARCHAR(20),
    score_riesgo DECIMAL(5,2),
    ingresos_mensuales DECIMAL(12,2),
    fecha_creacion TIMESTAMP,
);

CREATE TABLE IF NOT EXISTS sch_riesgo_capa_bronce.tbl_riesgos_digital (
id_trx INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    canal_origen VARCHAR(20),
    edad INT,
    genero VARCHAR(20),
    estado_civil VARCHAR(20),
    score_riesgo DECIMAL(5,2),
    ingresos_mensuales DECIMAL(12,2),
    fecha_creacion TIMESTAMP,
);
