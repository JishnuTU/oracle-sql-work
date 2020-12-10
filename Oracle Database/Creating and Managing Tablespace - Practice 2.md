# Creating and Managing Tablespace  - Practice 2 

### Helpful Queries

```sql

-- Create a tablespace ts2 using SQL Devleoper UI. 
	-- Select 'view' -> choose 'DBA'
	-- Open a connection to pdbts in DBA appeared
	-- Choose 'Storage'-> 'tablespace' -> Create New

create user x1 identified by x1
default tablespace ts2;


grant create session to x1;

grant create table to x1;

grant UNLIMITED tablespace to x1;

create table  x1.test ( n number) ;

select * from dba_tables
where owner='X1'

DROP TABLESPACE TS2 INCLUDING CONTENTS;
```

### Creating Tablespace

```sql
show user;

show con_name;

create tablespace t3;

SELECT DBMS_METADATA.GET_DDL('TABLESPACE','T3') FROM dual;

select TABLESPACE_NAME,BLOCK_SIZE,STATUS,CONTENTS,LOGGING,SEGMENT_SPACE_MANAGEMENt,COMPRESS_FOR
from dba_tablespaces;

select * from v$tablespace;


select * from v$datafile;

CREATE USER hrusr3 identified by hrusr3
default tablespace t3;

grant create session,create table, unlimited tablespace to hrusr3;

create table hrusr3.emp( id number, name varchar2(200));

insert into hrusr3.emp values (1,'ford');
insert into hrusr3.emp values (2,'sara');
insert into hrusr3.emp values (3,'ali');
commit;

ALTER TABLESPACE T3 READ ONLY;

insert into hrusr3.emp values (4,'DAVE');

ALTER TABLESPACE T3 READ WRITE;

insert into hrusr3.emp values (4,'DAVE');
COMMIT;

--LET US REZIE THE DATAFIE
select * from v$datafile;

ALTER DATABASE DATAFILE 
'XXXXXXXX.dbf'
   RESIZE 200M;


ALTER TABLESPACE T3
    ADD DATAFILE '/u01/app/oracle/oradata/ORCL/pdbts/ORCL/T3_02.dbf' SIZE 10M;

select * from v$datafile;
```





```sql
--Moving and Renaming Online Data Files
show user
show con_name

create tablespace t4
DATAFILE '/u01/app/oracle/oradata/ORCL/pdbts/t4_01.dbf' size 5m;


SELECT DBMS_METADATA.GET_DDL('TABLESPACE','T4') FROM dual;

--NOW LET US RENAME THE  FIE t4_01.dbf TO t4_001.dbf

ALTER DATABASE MOVE DATAFILE
'/u01/app/oracle/oradata/ORCL/pdbts/t4_01.dbf'
TO
'/u01/app/oracle/oradata/ORCL/pdbts/t4_001.dbf'

--NOW LET MOVE t4_001.dbf TO ANOTHER LOCATION
--CREATE FOLDER TEST IN /u01/app/oracle/oradata/ORCL/pdbts/

ALTER DATABASE MOVE DATAFILE
'/u01/app/oracle/oradata/ORCL/pdbts/t4_001.dbf'
TO
'/u01/app/oracle/oradata/ORCL/pdbts/test/t4_001.dbf'


/*
please read this

Queries and DML and DDL operations can be performed while the data file is being moved, for example:
1-SELECT statements against tables and partitions
2-Creation of tables and indexes
3- Rebuilding of indexes
Other notes:
1- If objects are compressed while the data file is moved, the compression remains the same.
2- You do not have to shut down the database or take the data file offline while you move a data file to another
location, disk, or storage system.
3- You can omit the TO clause only when an Oracle-managed file is used. In this case, the
DB_CREATE_FILE_DEST initialization parameter should be set to indicate the new location.
4-If the REUSE option is specified, the existing file is overwritten.
note:  The REUSE keyword indicates the new file should be created even if it already exists.
5-If the KEEP clause is specified, the old file will be kept after the move operation. The KEEP clause is not allowed
if the source file is an Oracle-managed file.

*/
```

