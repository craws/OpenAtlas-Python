
### 3.20.0 to 3.20.1

A code base update (e.g. with git pull) and an Apache restart should be sufficient.

### 3.19.x to 3.20.0

Execute install/upgrade/3.20.0.sql after making backups

### 3.18.0 to 3.19.0

In preparation of other new features the color themes were removed and
the classes Production (E12) and Destruction (E6) were remapped to Activity (E7) - check issue #1054 if your project was tested and is affected.

Execute install/upgrade/3.19.0.sql after making backups

### 3.17.x to 3.18.0

For the function to check similar names the library fuzzywuzzy is needed. On Debian it can be installed with:

    # apt-get install python3-fuzzywuzzy

### 3.16.0 to 3.17.0

Execute install/upgrade/3.17.0.sql after making backups

### 3.15.0 to 3.16.0

If you are running a productive online system take a look at install.md section "Additional security" for instructions to improve server side security.

The package python3-geopandas is no longer required.

A code base update (e.g. with git pull) and an Apache restart should be sufficient.

### 3.14.0 to 3.15.0

Execute install/upgrade/3.15.0.sql after making backups

### 3.13.0 to 3.14.0

A code base update (e.g. with git pull) and an Apache restart should be sufficient.

### 3.12.0 to 3.13.0

Execute install/upgrade/3.13.0.sql after making backups

The database structure changed significantly regarding how dates are mapped.

Also some inconsistency in the actor forms were resolved. In the former version there were form fields for appears first/last at a place and begin/end dates.
Since these date and place information weren't connected we changed it to begin and end fields for places and dates to e.g. enter a birthplace.

Since we couldn't assume that the information entered before was related this update creates events for first/last appearances which are named "First/Last Appearance of actor_name".

After the update you can check the new created entries going to the event overview and filter for "appearance of".

#### Value type label (description)

After this update the descriptions of value types is shown at entity views.
e.g. if the value type "height" has "centimeter" in its description and a find has it with the value 5 it will displayed as:
Height: 5 centimeter
So you might want to check the value type descriptions and e.g. change "In centimeter" to "centimeter"

### 3.11.0 to 3.12.0

Execute install/upgrade/3.12.0.sql after making backups

After the update minimum character search for tables and jstree can be configured in general settings (instead of the config file). The default value is 1 and has to be adjusted if needed. Former entries (MIN_CHARS_TABLESORTER_SEARCH and MIN_CHARS_JSTREE_SEARCH) in your instance config (e.g. production.py) can be removed.

### 3.10.0 to 3.11.0

Execute install/upgrade/3.11.0.sql after making backups

If you are using multiple OpenAtlas versions on the same server it is import to add something like

    WSGIDaemonProcess openatlas processes=2 threads=15 display-name=%{GROUP}
    WSGIProcessGroup openatlas

And replace openatlas for every instance with a unique name.

If you are using additional https configuration add there only

    WSGIProcessGroup openatlas

### 3.9.0 to 3.10.0

Install pandas libraries (needed for export and import)

    # apt-get install python3-pandas python3-geopandas python3-xlrd

Add this line to your apache config right after the WSGIScriptAlias line.
If you have an additional HTTPS config file it has to be added there too.

    WSGIApplicationGroup %{GLOBAL}

Execute install/upgrade/3.10.0.sql after making backups

### 3.8.0 to 3.9.0

Execute install/upgrade/3.9.0.sql after making backups

### 3.7.0 to 3.8.0

For the export functions you need to make these directories writeable for the Apache user:

openatlas/export/csv

openatlas/export/sql

e.g.

    # chown www-data openatlas/uploads

You can check at /admin if there are warnings about non-writeable directories.

### 3.6.x to 3.7.0

One major change is that it isn't needed anymore to have different branches for different projects.
The master branch should be sufficient for all projects.

Execute install/upgrade/3.7.0.sql after making backups

Changes to look out for:

- Change logo function to customize the logo if you like to replace the default OpenAtlas logo
- The site header text is now a setting on its own and can be configured at admin/settings/general
- Configuration should be done in instance/production.py (not in config/default.py)

### 3.5.0 to 3.6.0

Due to a bug it was possible to link information carriers to event, actor and place. These links are
invalid and will be removed with the 3.6.0.sql update. You should check the information carriers for
those invalid links which will be deleted before executing the SQL.

Execute install/upgrade/3.6.0.sql after making backups

### 3.4.x to 3.5.0

Execute install/upgrade/3.5.0.sql after making backups

After the upgrade you can add a legal notice text if you like at admin > content > legal notice

### 3.3.x to 3.4.0

Execute install/upgrade/3.4.0.sql after making backups

### 3.2.x to 3.3.0

Execute install/upgrade/3.3.0.sql after making backups

Make the openatlas/uploads directory writable for apache e.g.

    chown www-data /var/www/net/openatlas/openatlas/uploads/

### 3.1.0 to 3.2.0

#### Database

Execute install/upgrade/3.2.0.sql after making backups

#### Apache

Update Apache config for serving static files - see install/example_apache.conf

### 3.0.0 to 3.1.0

apt-get install python3-numpy

### 2.4.1 to 3.0.0 Upgrade (PHP to Python upgrade)

Be sure to have upgraded the database to the PHP Version 2.3.2 and have read the information below.

#### Passwords

The password hash function changed to Bcrypt so all user passwords from the PHP version will be
invalid.

The mail password is not being stored in the database anymore and has to be set in
/instance/config.py (MAIL_TRANSPORT_PASSWORD). See /install/example_config.py

#### Content

Website text translations where completely rewritten.

Please backup your text translations at "Content" in the web interface and
enter them in "Settings" (intro and contact; faq was removed) again after upgrading.

#### Edition and Bibliography

Edition and bibliography types are only checked one level deep. Meaning if your
edition/bibliography subtypes have also subtypes you have to remove them or adapt the SQL.

#### Database update

Execute install/upgrade/3.0.0.sql after making backups.
