SET SERVEROUTPUT ON;

VARIABLE B_PORCENTAJE1 NUMBER;
EXEC :B_PORCENTAJE1:=8.5;

VARIABLE B_PORCENTAJE2 NUMBER;
EXEC :B_PORCENTAJE2:=20;

VARIABLE B_RANGO1 NUMBER;
EXEC :B_RANGO1:=200000;

VARIABLE B_RANGO2 NUMBER;
EXEC :B_RANGO2:=400000;

VARIABLE B_RUN VARCHAR2(20);
EXEC :B_RUN:=&RUT;

DECLARE

V_NOMBRE VARCHAR2(30);
V_RUT VARCHAR2(30); 
V_SUELDO NUMBER;
V_REAJUSTE1 NUMBER;
V_REAJUSTE2 NUMBER;

BEGIN
    SELECT NOMBRE_EMP||' '||APPATERNO_EMP||' '||APMATERNO_EMP,
            NUMRUT_EMP||'-'||DVRUT_EMP,
            SUELDO_EMP
    INTO V_NOMBRE, V_RUT, V_SUELDO
    FROM EMPLEADO
    WHERE NUMRUT_EMP = :B_RUN AND SUELDO_EMP BETWEEN :B_RANGO1 AND :B_RANGO2;
    
    V_REAJUSTE1 := (V_SUELDO * :B_PORCENTAJE1) / 100;
    V_REAJUSTE2 := (V_SUELDO * :B_PORCENTAJE2) / 100;
    
    DBMS_OUTPUT.PUT_LINE('NOMBRE DEL EMPLEADO: '||V_NOMBRE);
    DBMS_OUTPUT.PUT_LINE('RUN: '||V_RUT);
    DBMS_OUTPUT.PUT_LINE('SIMULACIÓN 1: Aumentar en '||:B_PORCENTAJE1||'% el salario de todos los empleados');
    DBMS_OUTPUT.PUT_LINE('Sueldo actual: '||V_SUELDO);
    DBMS_OUTPUT.PUT_LINE('Sueldo reajustado: '||(ROUND(V_SUELDO+V_REAJUSTE1)));
    DBMS_OUTPUT.PUT_LINE('Reajuste: '||ROUND(V_REAJUSTE1));
    DBMS_OUTPUT.PUT_LINE('SIMULACIÓN 2: Aumentar en '||:B_PORCENTAJE2||'% el salario de los empleados que poseen salarios entre $200.000 y $400.000');
    DBMS_OUTPUT.PUT_LINE('Sueldo actual: '||V_SUELDO);
    DBMS_OUTPUT.PUT_LINE('Sueldo reajustado: '||(ROUND(V_SUELDO+V_REAJUSTE2)));
    DBMS_OUTPUT.PUT_LINE('Reajuste: '||ROUND(V_REAJUSTE2));
    
    
END;