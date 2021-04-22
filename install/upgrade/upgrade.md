## INFO
Before executing SQL statements, backup the database. Replace database role "openatlas" if needed.
Older upgrade scripts and information can be found in the archive directory.

If you are using git and want to update to the latest stable release you can fetch the main branch
e.g.

    git pull origin main

After following the instructions restart Apache and test if the application is working.

    service apache2 restart

### 6.1.0 to 6.2.0
Execute **install/upgrade/6.2.0.sql** after making backups.

### 6.0.x to 6.1.0
Execute **install/upgrade/6.1.0.sql** after making backups.

### 5.7.x to 6.0.0
Execute **install/upgrade/6.0.0.sql** after making backups.

Install package needed for backup compression:

    #  apt install p7zip-full
