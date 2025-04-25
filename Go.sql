CREATE CONTROLFILE REUSE DATABASE "XE" RESETLOGS ARCHIVELOG
    MAXLOGFILES 16
    MAXLOGMEMBERS 3
    MAXDATAFILES 100
    MAXINSTANCES 1
    MAXLOGHISTORY 292
LOGFILE
  GROUP 1 '/opt/oracle/oradata/XE/redo01.log' SIZE 50M,
  GROUP 2 '/opt/oracle/oradata/XE/redo02.log' SIZE 50M,
  GROUP 3 '/opt/oracle/oradata/XE/redo03.log' SIZE 50M
DATAFILE
  '/opt/oracle/oradata/XE/system01.dbf',
  '/opt/oracle/oradata/XE/sysaux01.dbf',
  '/opt/oracle/oradata/XE/undotbs01.dbf',
  '/opt/oracle/oradata/XE/users01.dbf'
CHARACTER SET AL32UTF8;
