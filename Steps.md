I understand the issue now. Let's solve this step-by-step:

# Complete Solution for Oracle Import Issue

## 1. Create the GMPOCADMIN User First

```sql
-- Connect as SYSDBA
sqlplus / as sysdba

-- Create the GMPOCADMIN user if it doesn't exist
CREATE USER gmpocadmin IDENTIFIED BY GMpoc321admin
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

-- Grant necessary privileges
GRANT CONNECT, RESOURCE, DBA TO gmpocadmin;
GRANT CREATE SESSION TO gmpocadmin;
GRANT CREATE TABLE TO gmpocadmin;
GRANT UNLIMITED TABLESPACE TO gmpocadmin;

-- Create directory for Data Pump
CREATE OR REPLACE DIRECTORY PB_DATA_DUMP AS '/opt/oracle/dpdump';

-- Grant directory access
GRANT READ, WRITE ON DIRECTORY PB_DATA_DUMP TO gmpocadmin;

-- Exit SQL*Plus
EXIT
```

## 2. Verify the User was Created

```bash
sqlplus system/your_system_password@XEPDB1

-- Check if user exists
SELECT username FROM dba_users WHERE username = 'GMPOCADMIN';

-- Exit
EXIT
```

## 3. Run the Import with Schema Remapping

```bash
impdp system/your_system_password@XEPDB1 \
DIRECTORY=PB_DATA_DUMP \
DUMPFILE=IPAMTable_2025042501.dmp,IPAMTable_2025042502.dmp,IPAMTable_2025042503.dmp,IPAMTable_2025042504.dmp,IPAMTable_2025042505.dmp,IPAMTable_2025042506.dmp,IPAMTable_2025042507.dmp,IPAMTable_2025042508.dmp,IPAMTable_2025042509.dmp,IPAMTable_2025042510.dmp,IPAMTable_2025042511.dmp \
REMAP_SCHEMA=MGMSIDEV:GMPOCADMIN \
TRANSFORM=SEGMENT_ATTRIBUTES:N \
TABLE_EXISTS_ACTION=REPLACE \
EXCLUDE=USER \
LOGFILE=import.log \
METRICS=Y
```

## 4. If XEPDB1 Connection Fails

If you have issues connecting to XEPDB1, try using the SYS user with direct connection:

```bash
impdp \"sys/your_sys_password@XEPDB1 as sysdba\" \
DIRECTORY=PB_DATA_DUMP \
DUMPFILE=IPAMTable_2025042501.dmp,IPAMTable_2025042502.dmp,IPAMTable_2025042503.dmp,IPAMTable_2025042504.dmp,IPAMTable_2025042505.dmp,IPAMTable_2025042506.dmp,IPAMTable_2025042507.dmp,IPAMTable_2025042508.dmp,IPAMTable_2025042509.dmp,IPAMTable_2025042510.dmp,IPAMTable_2025042511.dmp \
REMAP_SCHEMA=MGMSIDEV:GMPOCADMIN \
TRANSFORM=SEGMENT_ATTRIBUTES:N \
TABLE_EXISTS_ACTION=REPLACE \
EXCLUDE=USER \
LOGFILE=import.log \
METRICS=Y
```

## 5. Alternative Connection Approach

If you still have connection issues:

```bash
# Connect to the container database first
sqlplus / as sysdba

# Make sure XEPDB1 is open
ALTER SESSION SET CONTAINER = XEPDB1;
SELECT open_mode FROM v$pdbs WHERE name = 'XEPDB1';

# If not open, open it
ALTER PLUGGABLE DATABASE XEPDB1 OPEN;
ALTER PLUGGABLE DATABASE XEPDB1 SAVE STATE;

# Then try the import again but with the local connection
impdp \"sys/your_sys_password as sysdba\" \
DIRECTORY=PB_DATA_DUMP \
DUMPFILE=IPAMTable_2025042501.dmp,IPAMTable_2025042502.dmp,IPAMTable_2025042503.dmp,IPAMTable_2025042504.dmp,IPAMTable_2025042505.dmp,IPAMTable_2025042506.dmp,IPAMTable_2025042507.dmp,IPAMTable_2025042508.dmp,IPAMTable_2025042509.dmp,IPAMTable_2025042510.dmp,IPAMTable_2025042511.dmp \
REMAP_SCHEMA=MGMSIDEV:GMPOCADMIN \
TRANSFORM=SEGMENT_ATTRIBUTES:N \
TABLE_EXISTS_ACTION=REPLACE \
EXCLUDE=USER \
LOGFILE=import.log \
METRICS=Y
```

This comprehensive approach should address the issues with both the user creation and the import process.​​​​​​​​​​​​​​​​
