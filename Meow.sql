SET SERVEROUTPUT ON;
BEGIN
  FOR r IN (
    SELECT table_name 
    FROM dba_tab_columns 
    WHERE UPPER(column_name) = 'FMA_CD' 
      AND owner = 'SYSTEM'
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 
        'ALTER TABLE "SYSTEM"."' || r.table_name || '" MODIFY ("FMA_CD" VARCHAR2(30))';
      DBMS_OUTPUT.PUT_LINE('Modified FMA_CD in table: ' || r.table_name);
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Failed to modify FMA_CD in table: ' || r.table_name || ' - ' || SQLERRM);
    END;
  END LOOP;
END;
/
