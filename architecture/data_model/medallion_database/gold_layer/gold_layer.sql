CREATE SCHEMA IF NOT EXISTS sch_riesgo_capa_oro;

CREATE OR REPLACE VIEW sch_riesgo_capa_oro.vw_sas_riesgo AS
SELECT 
    tht.id_cliente,
    tht.canal_origen,
    tst.score_riesgo,
    tst.ingresos_mensuales,
    thc.edad,
    thc.genero,
    thc.estado_civil
FROM sch_riesgo_capa_plata.tbl_h_transaccion tht
INNER JOIN sch_riesgo_capa_plata.tbl_s_var_transaccion tst ON tht.transaccion_hk = tst.transaccion_hk
INNER JOIN sch_riesgo_capa_plata.tbl_l_transaccion_cliente tltc ON tht.transaccion_hk = tltc.transaccion_hk
INNER JOIN sch_riesgo_capa_plata.tbl_h_cliente thc ON tltc.cliente_hk = thc.cliente_hk;