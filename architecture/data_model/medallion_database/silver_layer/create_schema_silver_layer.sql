CREATE SCHEMA IF NOT EXISTS sch_riesgo_capa_plata;

--hub de la transacción
CREATE TABLE IF NOT EXISTS sch_riesgo_capa_plata.tbl_h_transaccion (
    transaccion_hk VARCHAR(64) PRIMARY KEY, --identity de la transacción
    canal_origen VARCHAR(20), -- digital o tradicional
    carga_timestamp TIMESTAMP,
    source_system VARCHAR(30)
);

--hub del cliente
CREATE TABLE IF NOT EXISTS sch_riesgo_capa_plata.tbl_h_cliente (
    cliente_hk VARCHAR(64) PRIMARY KEY, --identity del cliente
    carga_timestamp TIMESTAMP,
    source_system VARCHAR(30)
);

--detalle información del hub de transacción
CREATE TABLE IF NOT EXISTS sch_riesgo_capa_plata.tbl_s_var_transaccion (
    transaccion_hk VARCHAR(64) PRIMARY KEY, --identity del hub
    score_riesgo DECIMAL(5,2),
    ingresos_mensuales DECIMAL(12,2),
    registro_timestamp TIMESTAMP,

    CONSTRAINT fk_transaccion FOREIGN KEY (transaccion_hk) REFERENCES sch_riesgo_capa_plata.tbl_h_transaccion(transaccion_hk)
);

--detalle información del hub de cliente
CREATE TABLE IF NOT EXISTS sch_riesgo_capa_plata.tbl_s_var_cliente (
    cliente_hk VARCHAR(64) PRIMARY KEY, --identity del hub
    edad INT,
    genero VARCHAR(20),
    estado_civil VARCHAR(20),
    registro_timestamp TIMESTAMP,

    CONSTRAINT fk_cliente FOREIGN KEY (cliente_hk) REFERENCES sch_riesgo_capa_plata.tbl_h_cliente(cliente_hk)
);

CREATE TABLE IF NOT EXISTS sch_riesgo_capa_plata.tbl_l_transaccion_cliente (
    transaccion_cliente_hk SERIAL, --identity del link
    transaccion_hk VARCHAR(64), --identity del hub
    cliente_hk VARCHAR(64), --identity del cliente
    relacion_timestamp TIMESTAMP, --timestamp de la relación
    
    CONSTRAINT pk_transaccion_cliente PRIMARY KEY (transaccion_hk, cliente_hk),
    CONSTRAINT fk_transaccion FOREIGN KEY (transaccion_hk) REFERENCES sch_riesgo_capa_plata.tbl_h_transaccion(transaccion_hk),
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_hk) REFERENCES sch_riesgo_capa_plata.tbl_h_cliente(cliente_hk)
);
