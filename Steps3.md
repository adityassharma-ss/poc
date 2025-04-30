I see the issue is still occurring despite the DATA_OPTIONS=SKIP_CONSTRAINT_ERRORS parameter. Let's take a more direct approach by altering the table structure before importing.

The error is specifically with the FMA_CD column in one of your tables, which is defined as 9 characters but needs to hold 17 characters.

Here's what we need to do:

1. First, let's identify the table that has the FMA_CD column:

```sql
-- Connect as system:
sqlplus system/GMpoc321admin@XE

-- Find the table with the FMA_CD column:
SELECT table_name FROM dba_tab_columns WHERE column_name = 'FMA_CD' AND owner = 'SYSTEM';
```

2. Once you identify the table (likely IFPART01_C_BR based on the error), alter the column size:

```sql
-- Assuming the table is IFPART01_C_BR:
ALTER TABLE IFPART01_C_BR MODIFY (FMA_CD VARCHAR2(20));

-- If you need to alter multiple tables, you can run:
BEGIN
  FOR r IN (SELECT table_name FROM dba_tab_columns WHERE column_name = 'FMA_CD' AND owner = 'SYSTEM') LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE ' || r.table_name || ' MODIFY (FMA_CD VARCHAR2(20))';
  END LOOP;
END;
/
```

3. Then restart the import process with the same parameters:

```
impdp system/GMpoc321admin@XE \
DIRECTORY=PB_DATA_DUMP \
DUMPFILE=IPAMTable_2025042501.dmp,IPAMTable_2025042502.dmp,IPANTable_2025042503.dmp,IPAMTable_2025042504.dmp,IPAMTable_2025042505.dmp,IPAMTable_2025042506.dmp,IPAMTable_2025042507.dmp,IPAMTable_2025042508.dmp,IPAMTable_2025042509.dmp,IPAMTable_2025042510.dmp,IPAMTable_2025042511.dmp \
REMAP_SCHEMA=mamgostbs:system,mgmsidev:system,MMMSIDEV:system \
REMAP_TABLESPACE=mamgostbs:system,MMKANVTBS:system,CWKANVTBS:system \
TRANSFORM=SEGMENT_ATTRIBUTES:N \
CONTENT=DATA_ONLY \
DATA_OPTIONS=SKIP_CONSTRAINT_ERRORS \
LOGFILE=import.log \
METRICS=Y
```

If you're still having issues, a different approach would be to:

1. Extract the table definitions from the dump files:
```
impdp system/GMpoc321admin@XE \
DIRECTORY=PB_DATA_DUMP \
DUMPFILE=IPAMTable_2025042501.dmp \
SQLFILE=schema_defs.sql
```

2. Edit the schema_defs.sql file to increase the size of the FMA_CD column

3. Run the edited SQL file to create tables with the proper sizes

4. Import only the data:
```
impdp system/GMpoc321admin@XE \
DIRECTORY=PB_DATA_DUMP \
DUMPFILE=IPAMTable_2025042501.dmp,IPAMTable_2025042502.dmp,IPANTable_2025042503.dmp,IPAMTable_2025042504.dmp,IPAMTable_2025042505.dmp,IPAMTable_2025042506.dmp,IPAMTable_2025042507.dmp,IPAMTable_2025042508.dmp,IPAMTable_2025042509.dmp,IPAMTable_2025042510.dmp,IPAMTable_2025042511.dmp \
REMAP_SCHEMA=mamgostbs:system,mgmsidev:system,MMMSIDEV:system \
REMAP_TABLESPACE=mamgostbs:system,MMKANVTBS:system,CWKANVTBS:system \
TRANSFORM=SEGMENT_ATTRIBUTES:N \
CONTENT=DATA_ONLY \
TABLE_EXISTS_ACTION=APPEND \
LOGFILE=import.log \
METRICS=Y
```
