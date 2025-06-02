Any time you make a change to the schema files, remember to increment the database schema version. Generally increment the minor number, major should be reserved for significant changes to the schema. Both values go up to 255.
 
Make sure to also update `DB_MAJOR_VERSION` and `DB_MINOR_VERSION`, which can be found in `code/__DEFINES/subsystem.dm`.
 
The latest database version is 5.28; The query to update the schema revision table is:
 
```sql
INSERT INTO `schema_revision` (`major`, `minor`) VALUES (5, 22);
```
 
or
 
```sql
INSERT INTO `SS13_schema_revision` (`major`, `minor`) VALUES (5, 22);
```
 
In any query remember to add a prefix to the table names if you use one.
 
---

Version 5.22, 22 December 2021, by Mothblocks
Fixes a bug in `telemetry_connections` that limited the range of IPs.
 
```sql
ALTER TABLE `telemetry_connections` MODIFY COLUMN `address` INT(10) UNSIGNED NOT NULL;
```
 
---
