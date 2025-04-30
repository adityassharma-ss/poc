Yes, you can import the data directly into the SYSTEM schema using the XE service. Here's how to do it:

1. First, make sure you're connecting as SYSTEM user or as SYS with SYSDBA privileges:

```
impdp \"sys/GMpoc321admin@XE as sysdba\" \
DIRECTORY=DATA_PUMP_DIR \
DUMPFILE=IPAMTable_2025042501.dmp,IPAMTable_2025042502.dmp,IPANTable_2025042503.dmp,IPAMTable_2025042504.dmp,IPAMTable_2025042505.dmp,IPAMTable_2025042506.dmp,IPAMTable_2025042507.dmp,IPAMTable_2025042508.dmp,IPAMTable_2025042509.dmp,IPAMTable_2025042510.dmp,IPAMTable_2025042511.dmp \
TRANSFORM=SEGMENT_ATTRIBUTES:N \
TABLE_EXISTS_ACTION=REPLACE \
LOGFILE=import.log \
METRICS=Y
```

Or using SYSTEM user:

```
impdp system/your_system_password@XE \
DIRECTORY=DATA_PUMP_DIR \
DUMPFILE=IPAMTable_2025042501.dmp,IPAMTable_2025042502.dmp,IPANTable_2025042503.dmp,IPAMTable_2025042504.dmp,IPAMTable_2025042505.dmp,IPAMTable_2025042506.dmp,IPAMTable_2025042507.dmp,IPAMTable_2025042508.dmp,IPAMTable_2025042509.dmp,IPAMTable_2025042510.dmp,IPAMTable_2025042511.dmp \
TRANSFORM=SEGMENT_ATTRIBUTES:N \
TABLE_EXISTS_ACTION=REPLACE \
LOGFILE=import.log \
METRICS=Y
```

Notes:
- I'm using `DATA_PUMP_DIR` which is a default directory that comes pre-configured in Oracle. It usually points to the $ORACLE_HOME/admin/[DB_NAME]/dpdump directory.
- If your dump files are not in this location, you'll need to either move them there or create a new directory object that points to where your files are located.
- Since you want to load into SYSTEM, I've removed the REMAP_SCHEMA parameter. If the original dump was from a different schema, add `REMAP_SCHEMA=original_schema:SYSTEM`.
- If you're importing into the SYSTEM schema but want to preserve the original schema structure, don't include the REMAP_SCHEMA parameter.

To check where DATA_PUMP_DIR points to, you can run:

```sql
SELECT * FROM dba_directories WHERE directory_name = 'DATA_PUMP_DIR';
```

If you need to create a new directory object pointing to where your dump files are located:

```sql
CREATE OR REPLACE DIRECTORY MY_DUMP_DIR AS '/path/to/your/dpdump/files';
GRANT READ, WRITE ON DIRECTORY MY_DUMP_DIR TO SYSTEM;
```

Then use MY_DUMP_DIR in your import command instead of DATA_PUMP_DIR.​​​​​​​​​​​​​​​​
