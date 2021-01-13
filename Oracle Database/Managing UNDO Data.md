Managing UNDO Data

# Managing UNDO Data

The Oracle Database server saves the old value (undo data) when a process changes data in a database.
It stores the data as it exists before modifications.
Retained at least until the transaction is ended. ( next slide )

UNDO Data used to support :
- Rollback Operations
- Read - Consistent queries
- Recovery from failed transactions

A failed transaction occurs when a user session ends abnormally (possibly because of network errors or a
failure on the client computer) before the user decides to commitor roll back the transaction.
Failed transactions may also occur when the instance crashes or you issue the SHUTDOWN ABORT
command.


How the transaction ends?
- User undoes a transaction (transaction rolls back).
- User ends a transaction (transaction commit).
- User executes a DDL statement, such as a CREATE, DROP, RENAME, or ALTER statement.
-  session terminates abnormally (transaction rolls back).
-  User session terminates normally with an exit (transaction commits).

### Transactions and Undo Data

- Each transaction is assigned to only one undo segment.
- An undo segment can service more than one transaction at a time.
-  When a transaction starts, it is assigned to an undo segment. Throughout the life of the transaction, when data is changed, the original (before the change) values are copied into the undo segment. You can see which transactions are assigned to which undo segments by checking the V$TRANSACTION dynamic performance view.
-  Undo segments are specialized segments that are automatically created by the database server as needed to support transactions. Like all segments, undo segments are made up of extents, which, in turn, consist of data blocks. Undo segments automatically grow and shrink as needed, acting as a circular storage buffer for their assigned transactions.
-  Undo information is stored in undo segments, which are stored in an undo tablespace.
-  you cannot create other segment types, such as tables, in the undo tablespace

The Database Configuration Assistant (DBCA) automatically creates a smallfile undo tablespace. You can also create a bigfile undo tablespace. However, in a high-volume online transaction processing (OLTP) environment with many
 short concurrent transactions, contention could occur on the file header. An undo tablespace, stored in multiple datafiles, can resolve this potential issue.
 Although a database may have many undo tablespaces, only one of them at a time can be designated as the current undo tablespace for any instance in the database.
 Undo segments are automatically created and always owned by SYS. Because the undo segments act as a circular buffer, each segment has a minimum of two extents. The default maximum number of extents depends on the database block size but is very high (32,765 for an 8 KB block size).
 Undo tablespaces are permanent, locally managed tablespaces with automatic extent allocation. They are automatically managed by the database.
 Because undo data is required to recover from failed transactions (such as those that may occur when an instance crashes), undo tablespaces can be recovered only while the instance is in the MOUNT state.
 
 
> Redo log file stores changes to the database as they occur and are used for data recovery.


## Exercise

```sql
create table emp( n number, sal number );

insert into emp values (1,500);
insert into emp values (2,400 );

select a.sid, a.serial#, a.username, b.used_urec, b.used_ublk
from   v$session a,
       v$transaction b
where  a.saddr = b.ses_addr
order by b.used_ublk desc;
--USED_UBLK = Number of undo blocks used 
--USED_UREC = Number of undo records used

insert into emp values (3,700 );

select a.sid, a.serial#, a.username, b.used_urec, b.used_ublk
from   v$session a,
       v$transaction b
where  a.saddr = b.ses_addr
order by b.used_ublk desc;

commit; --this mean end of transaction

select a.sid, a.serial#, a.username, b.used_urec, b.used_ublk
from   v$session a,
       v$transaction b
where  a.saddr = b.ses_addr
order by b.used_ublk desc;
```
