File
====

.. toctree::

A file overview can be seen navigating to menu item **Admin** at the right top of the site.
The first tab will be **Files** with a **List** button to show all files.

.. include:: /entity/navigation.rst

If entities are linked to displayable files the first one is shown in the info tab but can be
changed to another one in the files tab of the entity.

Files can be uploaded by editors if they don't exceed the upload size limit and have an allowed
extension. Both criteria are displayed at the upload form. It is possible to upload multiple files
in one go.

Form fields
-----------
* **File** - here you can chose a file from your computer
* :doc:`/form/name` - if empty it will be prefilled after the file selection with the filename
* **License** - which works like a :doc:`type`, it is a good practice to define one
* :doc:`/form/description`


Can be linked via tabs to
-------------------------
* :doc:`/entity/source`
* :doc:`/entity/event`
* :doc:`/entity/actor`
* :doc:`/entity/place`
* :doc:`/entity/reference`


Settings
--------

* **Maximum file size in MB**
* **Profile image width in pixel** - this only influences the layout of info tabs
* **Allowed file extensions** - enter file extensions witout a dot and separated with a space e.g.

.. code-block:: python

  gif jpg jpeg

Images that can be displayed in the browser are defined through their extensions and can be changed
in the configuration file (e.g. instance/production.py) default is:

.. code-block:: python

   DISPLAY_FILE_EXTENSIONS = ['.bmp', '.gif', '.ico', '.jpeg', '.jpg', '.png', '.svg']

Logo
----
You can chose a custom logo. The file has to be uploaded before and has to have a display file
extension. The displayed logo has a max-height of 120 px. If you selected a larger one the browser
will try to scale it.
