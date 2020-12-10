Creating PDBs

# Oracle DB- Creating PDBs



 ## Creating PDBs

Creating PDBs from SEED

* We do this by create pluggable database statement.

* This will copy data files from seed to new location.

* This will create system and sysaux tablespaces.

* This will create default schemas and common users .

* Sys user will be super user.

* system user can manage the PDB.

* This will create the DB service automatically.

  #### Prerequisites for using create pluggable database

* The current container must be root

* You must have create pluggable database privileges

* The CDB must be in READ WRITE mode



![image-20201126094446401](https://user-images.githubusercontent.com/25578721/100306062-38681800-2fee-11eb-94e3-947be58069ed.png)





```sql
show con_name

select con_id,name,open_mode 
from v$containers;

alter session set container=PDB$SEED;

select con_id, username,DEFAULT_TABLESPACE,common 
from cdb_users;

select  username,DEFAULT_TABLESPACE,common 
from dba_users;

select con_id,file#, name from V$DATAFILE

select  * from V$TABLESPACE

alter session set container=cdb$root;

--go to vbox
--  mkdir /u01/app/oracle/oradata/ORCL/pdb1

CREATE PLUGGABLE DATABASE pdb1
  ADMIN USER pdb1admin IDENTIFIED BY welcome
  ROLES = (dba)
  DEFAULT TABLESPACE users
    DATAFILE '/u01/app/oracle/oradata/ORCL/pdb1/users01.dbf' SIZE 250M AUTOEXTEND ON
  FILE_NAME_CONVERT = ('/u01/app/oracle/oradata/ORCL/pdbseed/',
                       '/u01/app/oracle/oradata/ORCL/pdb1/')
 /*
 file_name_convert

Use this clause to determine how the database generates the names of files 
(such as data files and wallet files) for the PDB.

*/

select con_id,name,open_mode 
from v$containers;

alter session set container=pdb1; 

alter pluggable database open;


select con_id, username,DEFAULT_TABLESPACE,common 
from cdb_users;

select  username,DEFAULT_TABLESPACE,common 
from dba_users;

select con_id,file#, name from V$DATAFILE

select  * from V$TABLESPACE
```
### Dropping a PDB



```sql
alter session set container=cdb$root;

show con_name

alter pluggable database pdb2 close

select con_id,name,open_mode  from v$containers;

drop pluggable database pdb2 including datafiles; 

```

## Cloning PDBs

Cloning is a copying  a source PDB from a CDB and plugging the copy into the same or another CDB

#### Prerequisites for using cloning  pluggable database

* must connected to a CDB and the current container must be a root

* must have the create pluggable database privileges

* The CBD in which PDB is being created must be in READ Write Mode

* Recommended , PDB be is READ only mode

  ![image-20201126095213604](https://user-images.githubusercontent.com/25578721/100306123-5c2b5e00-2fee-11eb-9a99-46422d891bbf.png)

```sql
show con_name

select con_id,name,open_mode
from v$pdbs;


alter session set container=ORCLPDB;

show con_name

select username,DEFAULT_TABLESPACE,common 
from dba_users;

select  *
from dba_tables
where OWNER='HR';

select con_id,file#, name from V$DATAFILE

select  * from V$TABLESPACE


--NOW LET US CLONE ORCLPDB TO pdb5
--go to vbox
--login as oracle user
--  mkdir /u01/app/oracle/oradata/ORCL/pdb5
--login to orclpdb and do some uncommited tans.
--update hr.employees set salary=salary +1 where employee_id=100;
--select salary from hr.employees where employee_id=100; 

alter session set container=cdb$root;

show con_name

CREATE PLUGGABLE DATABASE pdb5 from orclpdb
FILE_NAME_CONVERT = ('/u01/app/oracle/oradata/ORCL/orclpdb/',
                       '/u01/app/oracle/oradata/ORCL/pdb5/')
/*
you can do this if you need oracle managed files to names the files
CREATE PLUGGABLE DATABASE pdb5 from orclpdb
create_file_dest '/u01/app/oracle/oradata/ORCL/pdb5'
*/

select con_id,name,open_mode 
from v$pdbs;

alter session set container=PDB5; 

alter pluggable database open;

select salary from hr.employees where employee_id=100; 



select  username,DEFAULT_TABLESPACE,common 
from dba_users;

select  *
from dba_tables
where OWNER='HR';

select con_id,file#, name from V$DATAFILE

select  * from V$TABLESPACE


```

## Unplugging and plugging in PDBs

* Unplugging a PDB is disassociating  the PDB from its CDB

* Plugging  in a PDB is associating a PDB with a CDB

* You can plug a PDB into the same or another CDB

#### Steps to Unplugging and plugging in PDBs

1. Close the pdb1

2. Unplug pdb1 to xml
3. Drop the pdb1 but we keep the datafiles
4. Check compatibility
5. Plug the pdb1 using the xml

```sql
show con_name

alter pluggable database all open;

select con_id, name, open_mode 
from v$pdbs;

alter session set container=pdb5;

select * from hr.employees;

alter session set container=cdb$root;

--we need to unplug pdb5
--step 1
alter pluggable database pdb5 close immediate;

select con_id, name, open_mode 
from v$pdbs;
--step 2
alter pluggable database pdb5 unplug into '/u01/app/oracle/oradata/pdb5.xml'

select con_id, name, open_mode 
from v$pdbs;

--step3
drop pluggable database pdb5 keep datafiles; --you should keep it.

select con_id, name, open_mode 
from v$pdbs;

--step 4 -- but this not work in 18c
/*
DECLARE
  l_result BOOLEAN;
BEGIN
  l_result := DBMS_PDB.check_plug_compatibility(
                pdb_descr_file => '/u01/app/oracle/oradata/pdb5.xml',
                pdb_name => 'PDB5');

  IF l_result THEN
    DBMS_OUTPUT.PUT_LINE('compatible');
  ELSE
    DBMS_OUTPUT.PUT_LINE('incompatible');
  END IF;
END;

*/


create pluggable database pdbtest
using '/u01/app/oracle/oradata/pdb5.xml'
FILE_NAME_CONVERT=('/u01/app/oracle/oradata/ORCL/pdb5/',
                  '/u01/app/oracle/oradata/ORCL/pdbtest/')




select con_id, name, open_mode 
from v$pdbs;


alter session set container=pdbtest;

alter pluggable database open;

select * from hr.employees;




```

```sql
show con_name

alter pluggable database all open;

select con_id, name, open_mode 
from v$pdbs;

alter session set container=pdbtest;

select * from hr.employees;

alter session set container=cdb$root;

--we need to unplug pdbtest
--step 1
alter pluggable database pdbtest close immediate;

select con_id, name, open_mode 
from v$pdbs;
--step 2
alter pluggable database pdbtest  unplug into '/u01/app/oracle/oradata/pdbtest.xml'

select con_id, name, open_mode 
from v$pdbs;

--step3
drop pluggable database pdbtest keep datafiles; --you should keep it.

select con_id, name, open_mode 
from v$pdbs;

--step 4 -- but this not work in 18c
/*
DECLARE
  l_result BOOLEAN;
BEGIN
  l_result := DBMS_PDB.check_plug_compatibility(
                pdb_descr_file => '/u01/app/oracle/oradata/pdbtest.xml',
                pdb_name => 'pdbtest');

  IF l_result THEN
    DBMS_OUTPUT.PUT_LINE('compatible');
  ELSE
    DBMS_OUTPUT.PUT_LINE('incompatible');
  END IF;
END;

*/

--step 5
create pluggable database pdbtest1
using '/u01/app/oracle/oradata/pdbtest.xml'
NOCOPY TEMPFILE REUSE;
--FILE_NAME_CONVERT=('/u01/app/oracle/oradata/ORCL/pdb5/',
  --                '/u01/app/oracle/oradata/ORCL/pdbtest/')




select con_id, name, open_mode 
from v$pdbs;


alter session set container=pdbtest1;

alter pluggable database open;

select * from hr.employees;

select con_id,file#, name from V$DATAFILE


```
