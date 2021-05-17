Export
======

.. toctree::

Available for admins and managers

Export SQL
----------
When clicking the **Export SQL** button a new SQL dump will be created with pg_dump.

* Be aware, especially when sharing, that **user data**, e.g. email addresses, is included.
* Existing files are shown in a list and can be downloaded or deleted (only admins can delete)
* If the directory isn't writeable, a warning will be shown
* SQL dumps are saved in the **export/sql** folder
* File names begin with date and time e.g. 2018-08-23_1533_dump.sql.


Export CSV
----------
When clicking the **Export CSV** button a new CSV export file for all marked tables will be created.

* Existing files are shown in a list and can be downloaded or deleted (only admins can delete)
* If the directory isn't writeable, a warning will be shown
* CSV exports are saved in the **export/csv** folder
* File names are constructed from the date, database schema and table name e.g. 2018-08-23_1533_model_class.csv

Options
*******
* **Export as ZIP and add info file** - files are compressed with an info file (date, username, domain)
* **Created and modified dates** - additional columns for creation and last modified dates
* **GIS format**

  * **Coordinates** - eg. "15.4498 47.0659", for polygons a `ST_PointOnSurface <https://postgis.net/docs/ST_PointOnSurface.html>`_ will be calculated
  * **WKT** - `Well known text <https://en.wikipedia.org/wiki/Well-known_text>`_ e.g. POINT (15.4498 47.0659)
  * **PostGIS geometry** - `PostGIS <https://en.wikipedia.org/wiki/PostGIS#Features>`_ geometry format
