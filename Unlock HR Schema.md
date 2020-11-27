# Unlock HR Schema

Connect to SQL Plus

`sqlplus / as sysdba`

Execute the below command to unlock the HR Schema

```sql
show pdbs;


alter session set container =orclpdb;

select username from all  users;


alter user hr account unlock;

alter user hr identified by hr;


```
