### 4.0.0 to 4.1.0
A code base update (e.g. with git pull) and an Apache restart should be sufficient.

If you're using tests make sure that this line is in instance/testing.py

    IS_UNIT_TEST = True

### 3.20.x to 4.0.0
WARNING - this is a major release and requires software upgrades. If you are using Debian upgrade it to 10 (buster).

See install.md which versions of software are needed after the upgrade.

If you upgrade a Debian system to buster be sure to have the new postgis packages installed (see install.md) before you upgrade database clusters.

#### Database
Execute install/upgrade/4.0.0.sql after making backups

#### Paths
The new version uses operating system independent paths with pathlib.
In case you want to override the ones in default.py take a look there, how to do it.

#### Tests
If you're using tests add this to line to instance/testing.py

    IS_UNIT_TEST = True
