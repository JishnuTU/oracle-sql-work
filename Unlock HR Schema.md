# Unlock HR Schema

Connect to SQL Plus

`sqlplus / as sysdba`

Start your Database Instance : `startup`

Open the PDB orclpbd : `alter pluggable database orclpdb open;`

Execute the below command to unlock the HR Schema

```sql
show pdbs;


alter session set container =orclpdb;

select username from all  users;


alter user hr account unlock;

alter user hr identified by hr;


```
