--CASO 1--
VARIABLE B_RUN NUMBER;
EXEC :B_RUN:=&RUT;

DECLARE
    V_CLIENTE           NUMBER;
    V_RUT               VARCHAR2(100);
    V_DV                VARCHAR2(100);
    V_NOMBRE            VARCHAR2(100);
    V_TIPO              VARCHAR2(100);
    V_MONTO             NUMBER;
    PUNTOS_EXTRAS       NUMBER;
    RUT_COMPLETO     VARCHAR2(100);
BEGIN
    SELECT C.NRO_CLIENTE, 
    C.NUMRUN, 
    C.DVRUN,
    C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO,
    TC.NOMBRE_TIPO_CLIENTE,
    SUM(CC.MONTO_SOLICITADO)
    INTO V_CLIENTE, V_RUT, V_DV, V_NOMBRE, V_TIPO, V_MONTO
    FROM CLIENTE C
    JOIN TIPO_CLIENTE TC ON (C.COD_TIPO_CLIENTE = TC.COD_TIPO_CLIENTE)
    JOIN CREDITO_CLIENTE CC ON (C.NRO_CLIENTE = CC.NRO_CLIENTE)
    WHERE EXTRACT(YEAR FROM CC.FECHA_SOLIC_CRED) = EXTRACT(YEAR FROM SYSDATE)-1 AND C.NUMRUN = 21300628
    GROUP BY C.NRO_CLIENTE, C.NUMRUN, C.DVRUN, C.PNOMBRE||' '||C.SNOMBRE||' '||C.APPATERNO||' '||C.APMATERNO,
    TC.NOMBRE_TIPO_CLIENTE;
    
    IF V_TIPO = 'Trabajadores independientes' AND   V_MONTO < 1000000    THEN
        PUNTOS_EXTRAS := ROUND((V_MONTO/100000)*1300);
    ELSIF V_TIPO = 'Trabajadores independientes' AND   V_MONTO BETWEEN 1000001 AND 3000000 THEN
        PUNTOS_EXTRAS := ROUND((V_MONTO/100000)*1500);
    ELSIF V_TIPO = 'Trabajadores independientes' AND   V_MONTO > 3000000 THEN
        PUNTOS_EXTRAS := ROUND((V_MONTO/100000)*1750);
    ELSE
        PUNTOS_EXTRAS := ROUND((V_MONTO/100000)*1200);
    END IF;
    
    RUT_COMPLETO:= TO_CHAR(V_RUT,'99G999G999')||'-'||V_DV;
    
    
    INSERT INTO CLIENTE_TODOSUMA VALUES (V_CLIENTE, RUT_COMPLETO , V_NOMBRE, V_TIPO, V_MONTO, PUNTOS_EXTRAS);


END;
--SELECT * FROM CLIENTE_TODOSUMA