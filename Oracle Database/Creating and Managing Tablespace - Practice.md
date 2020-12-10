# Creating and Managing Tablespace  - Practice

### Helpful Queries

```sql
show user

show con_name


select * from database_properties
--see GLOBAL_DB_NAME,DEFAULT_PERMANENT_TABLESPACE,DEFAULT_TEMP_TABLESPACE

create user hrms identified by hrms


SELECT DBMS_METADATA.GET_DDL('USER','HRMS') FROM dual;
--SO WE CAN SEE THAT THE USER HRMS WILL HAVE
-- DEFAULT TABLESPACE "USERS" 
-- TEMPORARY TABLESPACE "TEMP"

CREATE TABLE HRMS.EMP ( EMP_ID NUMBER, ENAME VARCHAR2(100) );
INSERT INTO   HRMS.EMP VALUES (1,'ford');
INSERT INTO   HRMS.EMP VALUES (2,'sami');
commit;


select * from dba_tables
where owner='HRMS'; --SO THE TABLE WILL BE USERS TABLESPACE



--tablespaces info
desc dba_tablespaces

select TABLESPACE_NAME,BLOCK_SIZE,STATUS,CONTENTS,LOGGING,SEGMENT_SPACE_MANAGEMENt,COMPRESS_FOR
from dba_tablespaces;

select * from v$tablespace

--data_files info
select * from dba_data_files
--BYTES Size of the file in bytes
--BLOCKS Size of the file in Oracle blocks
--MAXBYTES Maximum file size in bytes
--MAXBLOCKS Maximum file size in blocks
--INCREMENT_BY Number of tablespace blocks used as autoextension increment
--USER_BYTES The size of the file available for user data.
--USER_BLOCKS Number of blocks which can be used by the data
--https://docs.oracle.com/database/121/REFRN/GUID-0FA17297-73ED-4B5D-B511-103993C003D3.htm#REFRN23049

select * from v$datafile

--temp_files info
select * from dba_temp_files

select * from v$tempfile
```

### Creating Tablespace

```sql
SHOW USER

SHOW CON_NAME

create tablespace t1


/*
Oracle Managed Files
When creating a tablespace, either a permanent tablespace or an undo tablespace,
the DATAFILE clause is optional. 
When you include the DATAFILE clause, the file name is optional. 
If the DATAFILE clause or file name is not provided, then the following rules
apply:
• If the DB_CREATE_FILE_DEST initialization parameter is specified, then an Oracle
managed data file is created in the location specified by the parameter.
• If the DB_CREATE_FILE_DEST initialization parameter is not specified, then the
statement creating the data file fails
*/

show parameter DB_CREATE_FILE_DEST

alter system set DB_CREATE_FILE_DEST='/u01/app/oracle/oradata/ORCL/pdbts'; 

show parameter DB_CREATE_FILE_DEST

create tablespace t1

SELECT DBMS_METADATA.GET_DDL('TABLESPACE','T1') FROM dual;

select TABLESPACE_NAME,BLOCK_SIZE,STATUS,CONTENTS,LOGGING,SEGMENT_SPACE_MANAGEMENt,COMPRESS_FOR
from dba_tablespaces;

select * from v$tablespace

select * from dba_data_files

create user hrms2 identified by hrms2 
default tablespace t1;

SELECT DBMS_METADATA.GET_DDL('USER','HRMS2') FROM dual;

CREATE TABLE HRMS2.TEST123 ( N NUMBER );

select * from dba_tables
where owner='HRMS2'; --
```





