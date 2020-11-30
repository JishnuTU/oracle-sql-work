Connect Command

# Connect Method


In case of ERROR : TNS cannot resolved

Add the tnsnames.ora to the location : /u01/app/oracle/product/18/db_01/network/admin


Prerequiste:

- Instance is running
- Pluggable database should be in open mode
- Listener should be running

Connecting to ORCL as SYS user 

```
connect sys/ceit@dmhost.com:1521/orcl.com as sysdba
```



Connecting to orclpdp as demo user


```
connect demo/demo1234@dmhost.com:1521/orclpdb.com
```
