BackUp and Recover -Activity

# BackUp and Recover -Activity

## Doing backup for PLUGGABLE DB and restoring

- Make sure that DB is up and running
-  Login to RMAN
  
  ```
  rman target= /
  ```
- In order to see any available backup, do this
  `list backup of database orclpdb; `
- Now we will do this command
  `backup database orclpdb plus archivelog;`
- Make sure from the backup
  `list backup of database orclpdb;`
- note: the backup contains backup sets  each set contains pieces 
- Let us do some changes
- Restore the backup
  
  ```
  RUN 
  {
  RESTORE PLUGGABLE DATABASE orclpdb;
  RECOVER PLUGGABLE DATABASE orclpdb;
  ALTER PLUGGABLE DATABASE orclpdb open;
  }
  ```
- Make sure that all changes that you did has been restored

## Doing full backup for CDB and restoring

- Make sure that DB is up and running
- Login to RMAN
  `rman target=/`
- In order to see any available backup, do this
  `list backup of database;`
- To list the any archived logs files, do this
  ` list archivelog all;`
- note: if you did not find any files this mean no redo logs switch happened, the redo logs still no filled yet.
- Now we will do this command
  `backup database plus archivelog;`
-  Make sure from the backup
  `list backup of database;`
- note: the backup contains backup sets  each set contains pieces 
- Use this to list the control file
  `list backup of controlfile;`
- Use this to list the spfile
  `list backup of spfile;`
- Let us do some transactions in pluggable database orclpdb Then we restore that backup 
- Restore the backup
  
  ```
  RUN
  {
  SHUTDOWN IMMEDIATE; 
  STARTUP MOUNT;
  RESTORE DATABASE;
  RECOVER DATABASE;
  ALTER DATABASE OPEN;
  }
  ```
- Make sure that all changes that you did has been restored, this mean the restoring will get the archived log that has been generated after the backup time.

## Point-in-time recovery of pluggable database

- Let us do new backup
  `rman target=/`
  `backup database orclpdb plus archivelog;`
- Let us do some changes in pluggable orclpdb
  `select TO_CHAR(sysdate,'DD-MON-YYYY HH24:MI:SS') from dual;`

```
RUN 
{
ALTER PLUGGABLE DATABASE orclpdb CLOSE;
SET UNTIL TIME "TO_DATE(' 29-JUN-2019 17:54:38','DD-MON-YYYY HH24:MI:SS')";
RESTORE PLUGGABLE DATABASE orclpdb;
RECOVER PLUGGABLE DATABASE orclpdb;
ALTER PLUGGABLE DATABASE orclpdb OPEN RESETLOGS;
}
```

## point-in-time recovery of the CDB

- Let us do new backup
  `rman target=/`
  `backup database plus archivelog;`
- Let us do some changes in pluggable orclpdb
  ` select TO_CHAR(sysdate,'DD-MON-YYYY HH24:MI:SS') from dual;`

```
RUN 
{
SHUTDOWN IMMEDIATE; 
STARTUP MOUNT;
SET UNTIL TIME "TO_DATE(' 29-JUN-2019 14:00:26','DD-MON-YYYY HH24:MI:SS')";
RESTORE DATABASE;
RECOVER DATABASE;
ALTER DATABASE OPEN RESETLOGS;
}
```

## Deleting backup

- Remember that we use this command to do full backup for the entire database.
  `backup database plus archivelog;`
- Remember that we use this command to do full backup for the a specific pluggable.
  `backup database orclpdb plus archivelog;`
- To delete all backups, Do this:
  
  ```
  Delete backup;
  Or
  DELETE NOPROMPT BACKUP;
  Or
  DELETE BACKUP TAG 'tag_name';
  ```
- To delete specific backup
  
  ```
  List backup of database orclpdb
  DELETE BACKUPSET 42
  ```
