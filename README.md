# my2pg-atlassian-confluence-jira

MySQL to PostgreSQL migration using pgloader for Atlassian Confluence and Jira

This scripts were created to migrate MySQL 5.6 based databases for Confluence and Jira Datacenter Editions
There where a lot of assumptions so this code could require adjustments for any other environments like AWS or Azure

Steps to run scripts:

* Use one of the folder for migration "confluence" or "jira" - it is important as tables are different
* Copy my2pg-step00-settings.sh.def to my2pg-step00-settings.sh and set up source and destination database details except of passwords
* For MySQL password create "${HOME}/.my.cnf" file and set up section "clientName" to store password
** <https://dev.mysql.com/doc/refman/5.6/en/option-file-options.html#option_general_defaults-group-suffix>
* Export "APP_GRP" variable equal to the "Name" part of "clientName" from previous step
* Run migration "my2pg-step01-migrate.sh" script with mandatory "schema", "data" or "full" option
* Run "my2pg-step02-pkeys.sh" to fix primary keys - Atlassian has used strange namings ...
* Run "my2pg-step03-export.sh" optional script to export table configurations
** This could be used to compare it with original schema
** Original schema could be generated using clean Jira install and set of plug-ins installed
** This has been used to compare how script is working and completely optional
** If you have issues with migration use this to analyse which table is failing rules ...
