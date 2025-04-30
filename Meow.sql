SET SERVEROUTPUT ON;
DECLARE
  v_sql VARCHAR2(1000);
BEGIN
  FOR r IN (
    SELECT table_name, column_name, data_length, char_length
    FROM dba_tab_columns
    WHERE data_type = 'VARCHAR2'
      AND owner = 'SYSTEM'
      AND data_length < 100 -- current limit
  ) LOOP
    BEGIN
      v_sql := 'ALTER TABLE "SYSTEM"."' || r.table_name || 
               '" MODIFY ("' || r.column_name || '" VARCHAR2(100))';
      EXECUTE IMMEDIATE v_sql;
      DBMS_OUTPUT.PUT_LINE('Modified ' || r.table_name || '.' || r.column_name || ' to 100');
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Failed to modify ' || r.table_name || '.' || r.column_name || ': ' || SQLERRM);
    END;
  END LOOP;
END;
/

export ORACLE_SID=ORCL
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

