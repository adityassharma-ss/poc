BEGIN
  FOR r IN (
    SELECT table_name 
    FROM dba_tab_columns 
    WHERE column_name = 'FMA_CD' 
      AND owner = 'SYSTEM'
  ) LOOP
    EXECUTE IMMEDIATE 
      'ALTER TABLE SYSTEM.' || r.table_name || ' MODIFY (FMA_CD VARCHAR2(30))';
  END LOOP;
END;
/
