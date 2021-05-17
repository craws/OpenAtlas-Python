### 5.6.0 to 5.7.0

#### Software
API version 0.2 needs an additional package:

    # apt install python3-flask-restful

#### Database
Execute **install/upgrade/5.7.0.sql** after making backups. Can most likely not be done from
within the application because superuser rights are needed to create the PostgreSQL unaccent extension.

If you are running tests be sure to also execute following in the test database:

    CREATE EXTENSION unaccent;

### 5.5.1 to 5.6.0
Execute install/upgrade/5.6.0.sql after making backups (can also be done in Admin/Execute SQL)

#### Wikidata
A Wikidata module was added and is activated by default which can be changed in Admin/Modules.
To install extra JavaScript (example commands for Linux/Debian in root of project):

    $ pip3 install calmjs
    $ cd openatlas/static
    $ pip3 install -e ./
    $ ~/.local/bin/calmjs npm --install openatlas

In case you get an error like "calmjs.cli not overwriting existing 'openatlas/static/package.json'":
Delete it and try again.

    $ rm openatlas/static/package.json

### 5.5.0 to 5.5.1
Execute install/upgrade/5.5.1.sql after making backups (can also be done in Admin/Execute SQL)

### 5.5.0 to 5.6.0
A code base update (e.g. with git pull) and an Apache restart should be sufficient.

The new Wikidata module will be inactive by default, but you can activate it as default at
admin/modules after the upgrade.

### 5.4.0 to 5.5.0
Execute install/upgrade/5.5.0.sql after making backups

Default modules for new user can now be set at admin/modules which can be overridden in user
profiles. You might want to check the default settings, and your own profile after the upgrade.

### 5.3.0 to 5.4.0
**Important**: we renamed our main branch which is also used for productive systems from **master**
to **main**. For this upgrade you have to fetch and checkout the **main** branch. You can delete
the master branch afterwards.

Otherwise it's a normal code update without database changes.

### 5.2.0 to 5.3.0
Install flask-cors packages e.g. on Debian: 

    # apt-get install python3-flask-cors

### 5.1.x to 5.2.0
Execute install/upgrade/5.2.0.sql after making backups

Some map configurations were moved from default/config.py to the database and can now be adjusted in 
the admin interface. In case you have overwritten them in instance/production.py (where they are not 
used anymore) you should adjust these settings at admin/map.
Moved values:
* MAX_ZOOM
* DEFAULT_ZOOM
* GEONAMES_USERNAME
* GEONAMES_VIEW_URL

### 5.1.0 to 5.1.1
A code base update (e.g. with git pull) and an Apache restart should be sufficient.

### 5.0.0 to 5.1.0
A code base update (e.g. with git pull) and an Apache restart should be sufficient.

### 4.1.0 to 5.0.0
WARNING - this is a major release and requires new software. JavaScript's libraries are now installed
in a separate step.

#### Software
Make a code base update (e.g. with git pull).

#### New frontend libraries
Install pip and npm packages, e.g. on Debian:

    # apt-get install python3-pip npm

Install frontend libraries with npm:

    $ pip3 install calmjs
    $ cd openatlas/static
    $ pip3 install -e ./
    $ ~/.local/bin/calmjs npm --install openatlas

#### Database
Execute install/upgrade/5.0.0.sql after making backups

#### Logo
In the new layout a much smaller logo is needed (40px height). To save bandwidth you could exchange an existing logo with a 40px height one.
