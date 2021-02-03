 Administering User Security Part 4

###  Users accounts

- Unique Username : Username cannot exceed 30 bytes , cannot contain special character and must start with a letter
- Authencation method : The most common authencation method is password
- Default Tablespace : This is  tablespace where user create objects if the user does not specifiy some other tablespace.
- Temporary Tablespace : This is a place where temporary objects, such as sorts and temporary tables are created on behalf of the user by the instance . No quota is applied to the tempoaray tablespace . If an administrator does not define a temporary tablespace for a user, the system defined temporary tablespace is used when the user create objects.
- User Profile : This is a set of resource and password restrictions assigned to a user
- Intial consumer group : This is used by the Resource Manager
- Account Status : Users can accec only "open" accounts. The account status may be "locked" and/or "expired".  